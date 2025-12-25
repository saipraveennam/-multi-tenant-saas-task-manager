-- 001_create_tenants.sql
-- UP Migration
CREATE TABLE tenants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    subdomain VARCHAR(100) UNIQUE NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'trial')),
    subscriptionplan VARCHAR(20) DEFAULT 'free' CHECK (subscriptionplan IN ('free', 'pro', 'enterprise')),
    maxusers INTEGER DEFAULT 5,
    maxprojects INTEGER DEFAULT 3,
    createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tenants_subdomain ON tenants(subdomain);
CREATE INDEX idx_tenants_status ON tenants(status);

-- DOWN Migration (Rollback)
DROP TABLE tenants;
