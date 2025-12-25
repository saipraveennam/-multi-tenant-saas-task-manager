-- 005_create_auditlogs.sql
-- UP Migration
CREATE TABLE auditlogs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenantid UUID REFERENCES tenants(id) ON DELETE CASCADE,
    userid UUID REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    entitytype VARCHAR(50),
    entityid UUID,
    ipaddress VARCHAR(45),
    createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_auditlogs_tenantid ON auditlogs(tenantid);
CREATE INDEX idx_auditlogs_userid ON auditlogs(userid);
CREATE INDEX idx_auditlogs_createdat ON auditlogs(createdat);

-- DOWN Migration (Rollback)
DROP TABLE auditlogs;
