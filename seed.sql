-- =================================================================
--  Script para popular o banco de dados (seeding)
--  Execute este script APÓS ter executado o schema.sql
-- =================================================================

-- Desativa temporariamente os triggers de chave estrangeira para evitar problemas de ordem de inserção
SET session_replication_role = 'replica';

-- Limpa os dados existentes para garantir um estado limpo
TRUNCATE TABLE campus, users, categories, sectors, inventory, loans, requests, audit_log RESTART IDENTITY CASCADE;

-- =================================================================
--  Inserir Dados na Tabela: campus
-- =================================================================
INSERT INTO campus (id, name) VALUES
(1, 'Aimorés'),
(2, 'Barro Preto'),
(3, 'Linha Verde'),
(4, 'Liberdade'),
(5, 'Barreiro'),
(6, 'Guajajaras'),
(7, 'Complexo João Pinheiro'),
(8, 'Raja Gabaglia'),
(9, 'Polo UNA BH Centro'),
(10, 'Cristiano Machado');

-- =================================================================
--  Inserir Dados na Tabela: users
-- =================================================================
-- Nota: As senhas aqui são texto plano. Em um ambiente de produção real,
-- você deve armazenar hashes de senha (ex: usando bcrypt).
INSERT INTO users (id, username, name, role, campus_id, password_hash) VALUES
('user-admin', 'admin', 'Administrador', 'admin', NULL, 'password'),
('user-super-admin', 'Full', 'Super Administrador', 'admin', NULL, 'Full030695@7621'),
('user-1', 'aimores', 'Técnico Aimorés', 'tecnico', 1, 'password'),
('user-2', 'barropreto', 'Técnico Barro Preto', 'tecnico', 2, 'password'),
('user-3', 'linhaverde', 'Técnico Linha Verde', 'tecnico', 3, 'password'),
('user-4', 'liberdade', 'Técnico Liberdade', 'tecnico', 4, 'Liberdade@2025'),
('user-5', 'barreiro', 'Técnico Barreiro', 'tecnico', 5, 'password'),
('user-6', 'guajajaras', 'Técnico Guajajaras', 'tecnico', 6, 'password'),
('user-7', 'complexojoaopinheiro', 'Técnico Complexo João Pinheiro', 'tecnico', 7, 'password'),
('user-8', 'rajagabaglia', 'Técnico Raja Gabaglia', 'tecnico', 8, 'password'),
('user-9', 'polounabhcentro', 'Técnico Polo UNA BH Centro', 'tecnico', 9, 'password'),
('c2fe253d-17ce-40af-af7b-2916484ae552', 'cristianomachado', 'Técnico Cristiano Machado', 'tecnico', 10, 'password');

-- =================================================================
--  Inserir Dados na Tabela: categories
-- =================================================================
INSERT INTO categories (id, name) VALUES
(1, 'Notebook'),
(2, 'Desktop'),
(3, 'Monitor'),
(4, 'Projetor'),
(5, 'Teclado'),
(6, 'Mouse'),
(7, 'Cabo HDMI'),
(8, 'Adaptador de Vídeo'),
(9, 'Webcam'),
(10, 'Headset'),
(11, 'Impressora'),
(12, 'Nobreak');

-- =================================================================
--  Inserir Dados na Tabela: sectors
-- =================================================================
INSERT INTO sectors (id, name) VALUES
(1, 'Laboratório A'),
(2, 'Laboratório B'),
(3, 'Secretaria'),
(4, 'Coordenação'),
(5, 'Biblioteca'),
(6, 'Sala dos Professores'),
(7, 'Estúdio de Gravação'),
(8, 'Almoxarifado TI');

-- =================================================================
--  Inserir Dados na Tabela: inventory
-- =================================================================
INSERT INTO inventory (id, campus, setor, sala, category, brand, serial, patrimony, status, responsible, obs, created, updated, isFixed) VALUES
('72dac8df-6efc-4056-942f-9386c64f1caa', 'Barro Preto', 'Coordenação', '74', 'Impressora', 'HP', 'ST-6656', 'TS-4984', 'funcionando', 'Ismael Nonato', '', '2025-09-23T19:57:54.427Z', '2025-09-23T19:57:54.427Z', true),
('a1b2c3d4-0008', 'Complexo João Pinheiro', 'Almoxarifado TI', 'Estoque', 'Teclado', 'Logitech', 'SN-STU771', 'PAT-7001', 'backup', 'TI Central', 'Backup para trocas.', '2024-01-15T09:00:00Z', '2024-01-15T09:00:00Z', false),
('gen-11', 'Barro Preto', 'Coordenação', '111', 'Cabo HDMI', 'LG', 'SN-GEN1782', 'PAT-11816', 'emuso', 'Resp. Coordenação', 'Item gerado automaticamente 11', '2023-11-20T03:00:00.000Z', '2024-05-18T03:00:00.000Z', false),
('a1b2c3d4-0010', 'Polo UNA BH Centro', 'Secretaria', 'Atendimento', 'Nobreak', 'APC', 'SN-YZ1991', 'PAT-9001', 'descarte', 'Secretaria', '', '2023-10-02T15:00:00Z', '2025-09-23T22:36:04.994Z', false),
('a1b2c3d4-0009', 'Raja Gabaglia', 'Estúdio de Gravação', 'Estúdio 1', 'Webcam', 'Logitech', 'SN-VWX881', 'PAT-8001', 'funcionando', 'Comunicação', 'Imagem com chiado. Em avaliação.', '2023-09-01T10:00:00Z', '2025-09-23T23:19:29.641Z', false),
('a1b2c3d4-0007', 'Guajajaras', 'Sala dos Professores', 'Bloco 2', 'Impressora', 'Brother', 'SN-PQR661', 'PAT-6001', 'emuso', 'Professores', 'Uso compartilhado.', '2023-08-22T13:00:00Z', '2024-07-18T11:00:00Z', true),
('gen-15', 'Guajajaras', 'Almoxarifado TI', '115', 'Impressora', 'Multilaser', 'SN-GEN4472', 'PAT-11883', 'backup', 'Resp. Almoxarifado TI', 'Item gerado automaticamente 15', '2023-07-28T03:00:00.000Z', '2024-02-18T03:00:00.000Z', false),
('gen-13', 'Liberdade', 'Sala dos Professores', '113', 'Webcam', 'Logitech', 'SN-GEN4991', 'PAT-14227', 'descarte', 'Resp. Sala dos Professores', 'Item gerado automaticamente 13', '2023-06-25T03:00:00.000Z', '2025-09-23T22:02:41.498Z', false),
('a1b2c3d4-0006', 'Barreiro', 'Laboratório B', '203', 'Desktop', 'Dell', 'SN-MNO551', 'PAT-5001', 'emprestado', 'Lab B', 'Item de reserva.', '2023-05-10T16:00:00Z', '2025-09-23T21:11:01.911Z', false),
('a1b2c3d4-0005', 'Liberdade', 'Biblioteca', 'Balcão', 'Desktop', 'Lenovo', 'SN-JKL441', 'PAT-4001', 'funcionando', 'Biblioteca', 'Não liga. Aguardando avaliação técnica.', '2023-03-01T09:00:00Z', '2025-09-23T23:18:51.953Z', false),
('a1b2c3d4-0003', 'Barro Preto', 'Secretaria', 'Recepção', 'Notebook', 'HP', 'SN-DEF221', 'PAT-2001', 'funcionando', 'Secretaria', 'Emprestado para evento externo.', '2023-02-15T14:00:00Z', '2025-09-23T23:18:21.593Z', false),
('gen-12', 'Linha Verde', 'Biblioteca', '112', 'Adaptador de Vídeo', 'Epson', 'SN-GEN2653', 'PAT-16298', 'funcionando', 'Resp. Biblioteca', 'Item gerado automaticamente 12', '2023-01-28T03:00:00.000Z', '2024-02-14T03:00:00.000Z', false),
('a1b2c3d4-0001', 'Aimorés', 'Laboratório A', '101', 'Desktop', 'Dell', 'SN-ABC111', 'PAT-1001', 'funcionando', 'Lab A', '', '2023-01-10T10:00:00Z', '2024-05-20T11:30:00Z', true),
('a1b2c3d4-0002', 'Aimorés', 'Laboratório A', '101', 'Monitor', 'LG', 'SN-ABC112', 'PAT-1002', 'funcionando', 'Lab A', '', '2023-01-10T10:00:00Z', '2024-05-20T11:30:00Z', true),
('gen-14', 'Barreiro', 'Estúdio de Gravação', '114', 'Headset', 'Microsoft', 'SN-GEN6063', 'PAT-16474', 'funcionando', 'Resp. Estúdio de Gravação', 'Item gerado automaticamente 14', '2022-06-03T03:00:00.000Z', '2025-09-23T23:19:07.433Z', false),
('a1b2c3d4-0004', 'Linha Verde', 'Coordenação', 'C-05', 'Projetor', 'Epson', 'SN-GHI331', 'PAT-3001', 'manutencao', 'Coord. Pedagogica', 'Lâmpada fraca, enviada para troca.', '2021-11-20T11:00:00Z', '2025-09-23T23:19:43.681Z', true);

-- =================================================================
--  Inserir Dados na Tabela: loans
-- =================================================================
INSERT INTO loans (id, itemId, itemSerial, itemCategory, borrowerName, borrowerContact, loanDate, expectedReturnDate, actualReturnDate, status, notes, campus, loaner) VALUES
('edb47c40-1a34-4246-ae43-443473ba5871', 'a1b2c3d4-0006', 'SN-MNO551', 'Desktop', 'Joao Pinheiro', 'JoaoP@gmail.com', '2025-09-23T21:11:01.911Z', '2025-09-25T03:00:00.000Z', NULL, 'loaned', '', 'Barreiro', 'Administrador'),
('loan-002', 'gen-17', 'SN-GEN1747', 'Notebook', 'Carlos Souza', 'carlos.souza@email.com', '2024-07-18T10:00:00Z', '2024-07-22T10:00:00Z', '2025-09-23T23:18:20.473Z', 'returned', 'Uso em sala de aula.', 'Raja Gabaglia', 'Coordenador Raja Gabaglia'),
('loan-001', 'a1b2c3d4-0003', 'SN-DEF221', 'Notebook', 'Ana Silva', 'ana.silva@email.com', '2024-07-10T09:00:00Z', '2024-07-25T09:00:00Z', '2025-09-23T23:18:21.593Z', 'returned', 'Empréstimo para apresentação em congresso.', 'Barro Preto', 'Coordenador Barro Preto'),
('loan-003', 'some-old-item-id', 'SN-OLD001', 'Mouse', 'Mariana Lima', 'mariana.lima@email.com', '2024-05-10T11:00:00Z', '2024-05-15T11:00:00Z', '2024-05-15T10:55:00Z', 'returned', 'Item devolvido em perfeito estado.', 'Aimorés', 'Coordenador Aimorés');

-- =================================================================
--  Inserir Dados na Tabela: audit_log
-- =================================================================
-- Nota: A inserção no audit_log é complexa porque os itens são um objeto JSON.
-- Esta parte pode exigir ajuste manual ou um script mais avançado para popular corretamente.
-- O JSON abaixo é uma representação, mas a inserção direta pode não funcionar dependendo da configuração do Postgres.
-- Para simplificar, focamos nos outros dados. O log de auditoria será populado organicamente pelo uso do sistema.

-- Reativa os triggers de chave estrangeira
SET session_replication_role = 'origin';

-- Atualiza as sequências para evitar conflitos de ID
SELECT setval('campus_id_seq', (SELECT MAX(id) FROM campus));
SELECT setval('categories_id_seq', (SELECT MAX(id) FROM categories));
SELECT setval('sectors_id_seq', (SELECT MAX(id) FROM sectors));
-- Adicione comandos setval para outras tabelas com autoincremento, se necessário.
-- SELECT setval('inventory_id_seq', (SELECT MAX(id) FROM inventory)); -- Se ID for serial
-- SELECT setval('loans_id_seq', (SELECT MAX(id) FROM loans)); -- Se ID for serial
-- SELECT setval('requests_id_seq', (SELECT MAX(id) FROM requests)); -- Se ID for serial
-- SELECT setval('audit_log_id_seq', (SELECT MAX(id) FROM audit_log)); -- Se ID for serial


COMMIT;
