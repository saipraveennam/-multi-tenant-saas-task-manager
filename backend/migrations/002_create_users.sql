-- 002_create_users.sql
-- UP Migration
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenantid UUID REFERENCES tenants(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL,
    passwordhash VARCHAR(255) NOT NULL,
    fullname VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('superadmin', 'tenantadmin', 'user')),
    isactive BOOLEAN DEFAULT true,
    createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(tenantid, email)
);

CREATE INDEX idx_users_tenantid ON users(tenantid);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

-- DOWN Migration (Rollback)
DROP TABLE users;
