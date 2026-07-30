-- =====================================================
-- Investment Portfolio Management System
-- Schema and Sample Data (PostgreSQL / Supabase)
-- =====================================================

CREATE TABLE clients (
    client_id     SERIAL PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    contact_info  VARCHAR(255)
);

CREATE TABLE portfolios (
    portfolio_id    SERIAL PRIMARY KEY,
    client_id       INT REFERENCES clients(client_id),
    portfolio_name  VARCHAR(100) NOT NULL,
    other_details   VARCHAR(255)
);

CREATE TABLE investments (
    investment_id     SERIAL PRIMARY KEY,
    portfolio_id      INT REFERENCES portfolios(portfolio_id),
    investment_type   VARCHAR(100) NOT NULL,
    amount            DECIMAL(12, 2) NOT NULL,
    investment_date   DATE,
    other_details     VARCHAR(255)
);

CREATE TABLE returns (
    return_id          SERIAL PRIMARY KEY,
    investment_id      INT REFERENCES investments(investment_id),
    return_percentage  DECIMAL(5, 2) NOT NULL,
    return_amount       DECIMAL(12, 2) NOT NULL,
    return_date         DATE,
    other_details        VARCHAR(255)
);

-- Clients
INSERT INTO clients (name, contact_info) VALUES
('Kabo Molefe',      '+267 71234567'),
('Boitumelo Seleka',  '+267 72345678'),
('Thabo Ntsima',      '+267 73456789'),
('Lesego Mokgosi',    '+267 74567890'),
('Naledi Pheto',      '+267 75678901'),
('Kagiso Tau',        '+267 76789012'),
('Bontle Motshegwa',  '+267 77890123'),
('Tumelo Kealotswe',  '+267 78901234'),
('Refilwe Dikgang',   '+267 79012345'),
('Onalenna Segwabe',  '+267 70123456');

-- Portfolios
INSERT INTO portfolios (client_id, portfolio_name, other_details) VALUES
(1,  'Equity Portfolio',       'Long-term growth investments'),
(2,  'Commodity Portfolio',    'Diversified commodity holdings'),
(3,  'Equity Portfolio',       'Long-term growth investments'),
(3,  'Property Portfolio',     'Real estate investments'),
(4,  'Fixed Income Portfolio', 'Short-term bonds and notes'),
(5,  'Equity Portfolio',       'Long-term growth investments'),
(6,  'Fixed Income Portfolio', 'Short-term bonds and notes'),
(7,  'Commodity Portfolio',    'Diversified commodity holdings'),
(8,  'Equity Portfolio',       'Long-term growth investments'),
(9,  'Fixed Income Portfolio', 'Short-term bonds and notes'),
(10, 'Equity Portfolio',       'Long-term growth investments');

-- Investments
INSERT INTO investments (portfolio_id, investment_type, amount, investment_date, other_details) VALUES
(1,  'Equity',       75000.00,  '2023-12-31', 'BSE-listed shares'),
(2,  'Commodity',    25000.00,  '2023-11-15', 'Gold and diversified commodities'),
(3,  'Equity',       200000.00, '2024-03-01', 'BSE-listed shares'),
(4,  'Property',     650000.00, '2023-10-20', 'Residential property'),
(5,  'Fixed Income', 100000.00, '2023-09-01', 'Government bonds'),
(6,  'Equity',       500000.00, '2023-08-15', 'BSE-listed shares'),
(7,  'Fixed Income', 75000.00,  '2024-02-28', 'Corporate bonds'),
(8,  'Commodity',    100000.00, '2024-03-10', 'Diversified commodities'),
(9,  'Equity',       150000.00, '2024-01-20', 'BSE-listed shares'),
(10, 'Fixed Income', 30000.00,  '2023-11-30', 'Government bonds'),
(11, 'Equity',       220000.00, '2024-04-05', 'BSE-listed shares');

-- Returns
INSERT INTO returns (investment_id, return_percentage, return_amount, return_date, other_details) VALUES
(1,  8.50,  4250.00,  '2024-04-01', 'Quarterly returns'),
(2,  7.00,  1750.00,  '2024-03-01', 'Monthly returns'),
(3,  12.75, 25500.00, '2024-06-01', 'Quarterly returns'),
(4,  10.00, 65000.00, '2024-01-01', 'Yearly returns'),
(5,  6.25,  6250.00,  '2024-05-15', 'Quarterly returns'),
(6,  9.75,  4875.00,  '2024-03-15', 'Quarterly returns'),
(7,  5.50,  4125.00,  '2024-06-15', 'Quarterly returns'),
(8,  4.00,  4000.00,  '2024-02-15', 'Monthly returns'),
(9,  11.25, 16875.00, '2024-05-20', 'Quarterly returns'),
(10, 6.00,  1800.00,  '2024-04-30', 'Monthly returns');

-- Sanity check
SELECT
    (SELECT COUNT(*) FROM clients)     AS clients,
    (SELECT COUNT(*) FROM portfolios)  AS portfolios,
    (SELECT COUNT(*) FROM investments) AS investments,
    (SELECT COUNT(*) FROM returns)     AS returns;
