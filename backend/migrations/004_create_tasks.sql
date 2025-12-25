-- 004_create_tasks.sql
-- UP Migration
CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    projectid UUID REFERENCES projects(id) ON DELETE CASCADE,
    tenantid UUID REFERENCES tenants(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'todo' CHECK (status IN ('todo', 'inprogress', 'completed')),
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
    assignedto UUID REFERENCES users(id) ON DELETE SET NULL,
    duedate DATE,
    createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tasks_tenantid ON tasks(tenantid);
CREATE INDEX idx_tasks_projectid ON tasks(projectid);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_priority ON tasks(priority);
CREATE INDEX idx_tasks_assignedto ON tasks(assignedto);

-- DOWN Migration (Rollback)
DROP TABLE tasks;
