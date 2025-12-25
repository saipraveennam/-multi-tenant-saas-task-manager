-- 003_create_projects.sql
-- UP Migration
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenantid UUID REFERENCES tenants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'archived', 'completed')),
    createdby UUID REFERENCES users(id) ON DELETE SET NULL,
    createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_projects_tenantid ON projects(tenantid);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_createdby ON projects(createdby);

-- DOWN Migration (Rollback)
DROP TABLE projects;
