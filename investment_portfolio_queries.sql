-- =====================================================
-- Queries: Investment Portfolio Management System
-- =====================================================

-- ============ EASY ============

-- 1. Retrieve all client names and their contact information
SELECT name, contact_info
FROM clients;

-- 2. Retrieve all portfolio names along with their corresponding client names
SELECT p.portfolio_name, c.name
FROM portfolios p
JOIN clients c ON p.client_id = c.client_id;

-- 3. Retrieve the total investment amount for each portfolio
SELECT p.portfolio_name, SUM(i.amount) AS total_investment_amount
FROM portfolios p
JOIN investments i ON p.portfolio_id = i.portfolio_id
GROUP BY p.portfolio_name;

-- 4. Retrieve all investments made in a specific investment type
SELECT i.investment_type, i.amount, p.portfolio_name
FROM investments i
JOIN portfolios p ON i.portfolio_id = p.portfolio_id
WHERE i.investment_type = 'Equity';

-- 5. Retrieve the average return percentage for each investment type
SELECT i.investment_type, AVG(r.return_percentage) AS average_return_percentage
FROM investments i
JOIN returns r ON i.investment_id = r.investment_id
GROUP BY i.investment_type;


-- ============ INTERMEDIATE ============

-- 1. Total return amount for each investment type, with portfolio and client info
SELECT i.investment_type, r.return_amount, p.portfolio_name, c.name
FROM returns r
JOIN investments i ON r.investment_id = i.investment_id
JOIN portfolios p ON i.portfolio_id = p.portfolio_id
JOIN clients c ON p.client_id = c.client_id
ORDER BY i.investment_type, r.return_amount DESC;

-- 2. Top 5 portfolios with the highest total investment amount
SELECT p.portfolio_name, SUM(i.amount) AS total_investment_amount
FROM portfolios p
JOIN investments i ON p.portfolio_id = i.portfolio_id
GROUP BY p.portfolio_name
ORDER BY total_investment_amount DESC
LIMIT 5;

-- 3. Investments made in the past year, with portfolio and client info
-- (Postgres syntax: NOW() - INTERVAL '1 year' instead of DATE_SUB)
SELECT i.investment_type, i.amount, i.investment_date, p.portfolio_name, c.name
FROM investments i
JOIN portfolios p ON i.portfolio_id = p.portfolio_id
JOIN clients c ON p.client_id = c.client_id
WHERE i.investment_date > NOW() - INTERVAL '1 year';

-- 4. Clients who have investments in multiple portfolios
SELECT c.name, COUNT(DISTINCT p.portfolio_id) AS num_portfolios
FROM clients c
JOIN portfolios p ON c.client_id = p.client_id
JOIN investments i ON p.portfolio_id = i.portfolio_id
GROUP BY c.name
HAVING COUNT(DISTINCT p.portfolio_id) > 1;

-- 5. Portfolios with a total return amount higher than the average return amount
SELECT p.portfolio_name, SUM(r.return_amount) AS total_return_amount
FROM portfolios p
JOIN investments i ON p.portfolio_id = i.portfolio_id
JOIN returns r ON i.investment_id = r.investment_id
GROUP BY p.portfolio_name
HAVING SUM(r.return_amount) > (SELECT AVG(return_amount) FROM returns);


-- ============ ADVANCED ============

-- 1. Top 3 clients with the highest total investment amount across all portfolios
SELECT c.name, SUM(i.amount) AS total_invested
FROM clients c
JOIN portfolios p ON c.client_id = p.client_id
JOIN investments i ON p.portfolio_id = i.portfolio_id
GROUP BY c.name
ORDER BY total_invested DESC
LIMIT 3;

-- 2. Portfolios with the highest average return percentage, with investment and client info
SELECT p.portfolio_name, AVG(r.return_percentage) AS avg_return_percentage,
       i.investment_type, c.name
FROM portfolios p
JOIN investments i ON p.portfolio_id = i.portfolio_id
JOIN returns r ON i.investment_id = r.investment_id
JOIN clients c ON p.client_id = c.client_id
GROUP BY p.portfolio_name, i.investment_type, c.name
ORDER BY avg_return_percentage DESC;

-- 3. Investments that have not yet received any returns
SELECT i.investment_type, i.amount, i.investment_date, p.portfolio_name, c.name
FROM investments i
JOIN portfolios p ON i.portfolio_id = p.portfolio_id
JOIN clients c ON p.client_id = c.client_id
LEFT JOIN returns r ON i.investment_id = r.investment_id
WHERE r.return_id IS NULL;

-- 4. Clients whose every portfolio has at least one investment
SELECT c.name
FROM clients c
JOIN portfolios p ON c.client_id = p.client_id
LEFT JOIN investments i ON p.portfolio_id = i.portfolio_id
GROUP BY c.name
HAVING COUNT(DISTINCT p.portfolio_id) = COUNT(DISTINCT i.portfolio_id);

-- 5. The single highest-value portfolio for each client
SELECT c.client_id, c.name, p.portfolio_name, SUM(i.amount) AS total_investment_amount
FROM clients c
JOIN portfolios p ON c.client_id = p.client_id
JOIN investments i ON p.portfolio_id = i.portfolio_id
GROUP BY c.client_id, c.name, p.portfolio_name
HAVING SUM(i.amount) = (
    SELECT MAX(total_investment_amount)
    FROM (
        SELECT c2.client_id, p2.portfolio_id, SUM(i2.amount) AS total_investment_amount
        FROM clients c2
        JOIN portfolios p2 ON c2.client_id = p2.client_id
        JOIN investments i2 ON p2.portfolio_id = i2.portfolio_id
        GROUP BY c2.client_id, p2.portfolio_id
    ) AS subquery
    WHERE subquery.client_id = c.client_id
);
