-- Arquivo: schema.sql
-- Descrição: Script completo para criação do banco de dados nsi_inventory_db no PostgreSQL 17.
-- Este script cria todas as tabelas, tipos, relações e índices necessários para a aplicação.

-- ========= CRIAÇÃO DE TIPOS ENUMERADOS (ENUMs) =========
-- Usar ENUMs garante a integridade dos dados para campos com valores pré-definidos.

CREATE TYPE user_role AS ENUM ('admin', 'tecnico');
CREATE TYPE item_status AS ENUM ('funcionando', 'defeito', 'manutencao', 'backup', 'descarte', 'emprestado', 'emuso');
CREATE TYPE request_status AS ENUM ('aberto', 'em-andamento', 'concluido', 'cancelado');
CREATE TYPE audit_action AS ENUM ('create', 'update', 'delete', 'loan', 'return');

-- ========= CRIAÇÃO DAS TABELAS PRINCIPAIS =========

-- Tabela de Campus
CREATE TABLE campus (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE
);
COMMENT ON TABLE campus IS 'Armazena a lista de todos os campus da instituição.';

-- Tabela de Usuários
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) NOT NULL UNIQUE,
    "password" VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role user_role NOT NULL,
    campus_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_users_campus FOREIGN KEY (campus_id) REFERENCES campus(id) ON DELETE SET NULL
);
COMMENT ON TABLE users IS 'Gerencia as contas de usuários, suas senhas (hash), papéis e a qual campus pertencem.';
COMMENT ON COLUMN users.campus_id IS 'Se nulo, pode ser um administrador geral não associado a um campus específico.';

-- Tabela de Categorias de Equipamentos
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE
);
COMMENT ON TABLE categories IS 'Lista de todas as categorias de equipamentos disponíveis (ex: Notebook, Projetor).';

-- Tabela de Setores
CREATE TABLE sectors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE
);
COMMENT ON TABLE sectors IS 'Lista de todos os setores/departamentos da instituição (ex: Laboratório A, Secretaria).';

-- Tabela Principal de Inventário
CREATE TABLE inventory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    serial VARCHAR(100) NOT NULL UNIQUE,
    patrimony VARCHAR(100) UNIQUE,
    brand VARCHAR(100),
    sala VARCHAR(100),
    responsible VARCHAR(100),
    obs TEXT,
    is_fixed BOOLEAN NOT NULL DEFAULT FALSE,
    status item_status NOT NULL DEFAULT 'funcionando',
    
    -- Chaves Estrangeiras
    campus_id UUID NOT NULL,
    category_id UUID NOT NULL,
    setor_id UUID NOT NULL,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT fk_inventory_campus FOREIGN KEY (campus_id) REFERENCES campus(id) ON DELETE RESTRICT,
    CONSTRAINT fk_inventory_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT,
    CONSTRAINT fk_inventory_setor FOREIGN KEY (setor_id) REFERENCES sectors(id) ON DELETE RESTRICT
);
COMMENT ON TABLE inventory IS 'Tabela central que armazena cada item de equipamento individualmente.';
COMMENT ON COLUMN inventory.is_fixed IS 'True se o item é fixo em um local, como um projetor ou switch de rede.';

-- Tabela de Empréstimos
CREATE TABLE loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    inventory_id UUID NOT NULL,
    borrower_name VARCHAR(150) NOT NULL,
    borrower_contact VARCHAR(150) NOT NULL,
    notes TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'loaned', -- pode ser 'loaned' ou 'returned'
    loan_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expected_return_date TIMESTAMPTZ NOT NULL,
    actual_return_date TIMESTAMPTZ,
    loaner_id UUID NOT NULL, -- Usuário que realizou o empréstimo

    -- Constraints
    CONSTRAINT fk_loans_inventory FOREIGN KEY (inventory_id) REFERENCES inventory(id) ON DELETE CASCADE,
    CONSTRAINT fk_loans_loaner FOREIGN KEY (loaner_id) REFERENCES users(id) ON DELETE RESTRICT
);
COMMENT ON TABLE loans IS 'Registra todos os empréstimos de equipamentos a usuários.';

-- Tabela de Solicitações de Suporte (Chamados)
CREATE TABLE requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    requester_email VARCHAR(150) NOT NULL,
    details TEXT NOT NULL,
    status request_status NOT NULL DEFAULT 'aberto',
    
    -- Chaves Estrangeiras
    campus_id UUID NOT NULL,
    setor_id UUID NOT NULL,
    sala VARCHAR(100),

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT fk_requests_campus FOREIGN KEY (campus_id) REFERENCES campus(id) ON DELETE RESTRICT,
    CONSTRAINT fk_requests_setor FOREIGN KEY (setor_id) REFERENCES sectors(id) ON DELETE RESTRICT
);
COMMENT ON TABLE requests IS 'Armazena os chamados de suporte técnico abertos pelos usuários.';

-- Tabela de Log de Auditoria
CREATE TABLE audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "action" audit_action NOT NULL,
    details TEXT,
    "timestamp" TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Chaves Estrangeiras
    user_id UUID NOT NULL,
    campus_id UUID NOT NULL,
    inventory_id UUID, -- Pode ser nulo se a ação não for específica de um item

    -- Constraints
    CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_audit_campus FOREIGN KEY (campus_id) REFERENCES campus(id) ON DELETE RESTRICT,
    CONSTRAINT fk_audit_inventory FOREIGN KEY (inventory_id) REFERENCES inventory(id) ON DELETE SET NULL
);
COMMENT ON TABLE audit_log IS 'Registra todas as ações importantes realizadas no sistema para fins de auditoria.';


-- ========= CRIAÇÃO DE ÍNDICES PARA OTIMIZAÇÃO DE CONSULTAS =========
-- Índices aceleram significativamente as buscas em colunas usadas com frequência.

CREATE INDEX idx_inventory_serial ON inventory(serial);
CREATE INDEX idx_inventory_patrimony ON inventory(patrimony);
CREATE INDEX idx_inventory_status ON inventory(status);
CREATE INDEX idx_inventory_campus_id ON inventory(campus_id);
CREATE INDEX idx_inventory_category_id ON inventory(category_id);

CREATE INDEX idx_loans_inventory_id ON loans(inventory_id);
CREATE INDEX idx_loans_status ON loans(status);

CREATE INDEX idx_requests_status ON requests(status);
CREATE INDEX idx_requests_campus_id ON requests(campus_id);

CREATE INDEX idx_audit_log_user_id ON audit_log(user_id);
CREATE INDEX idx_audit_log_inventory_id ON audit_log(inventory_id);
CREATE INDEX idx_audit_log_action ON audit_log("action");

-- Fim do script.
