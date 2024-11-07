CREATE TABLE servers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    ip_address VARCHAR(15) NOT NULL UNIQUE,
    status BOOLEAN DEFAULT TRUE,
    config JSON,
    last_monitored TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO servers (name, ip_address, status)
VALUES ('Web Server', '192.168.1.100', TRUE);


SELECT s.name, COUNT(srv.id)
FROM servers s
LEFT JOIN server_service ss ON s.id = ss.server_id
LEFT JOIN services srv ON srv.id = ss.service_id
GROUP BY s.name;

SELECT id, config->>'cpu' FROM servers WHERE name = 'Web Server';

