-- seeddata.sql - REQUIRED SEED DATA
-- Super Admin (tenantid = NULL)
INSERT INTO users (tenantid, email, passwordhash, fullname, role) VALUES 
(NULL, 'superadminsystem.com', '$2b$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Super Admin', 'superadmin')
ON CONFLICT DO NOTHING;

-- Demo Tenant
INSERT INTO tenants (name, subdomain, status, subscriptionplan, maxusers, maxprojects) VALUES 
('Demo Company', 'demo', 'active', 'pro', 25, 15)
ON CONFLICT DO NOTHING;

-- Get demo tenant ID (for reference)
DO $$
DECLARE demo_tenant_id UUID;
BEGIN
    SELECT id INTO demo_tenant_id FROM tenants WHERE subdomain = 'demo';
    
    -- Demo Tenant Admin
    INSERT INTO users (tenantid, email, passwordhash, fullname, role) VALUES 
    (demo_tenant_id, 'admindemo.com', '$2b$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Demo Admin', 'tenantadmin')
    ON CONFLICT DO NOTHING;
    
    -- Demo Regular Users
    INSERT INTO users (tenantid, email, passwordhash, fullname, role) VALUES 
    (demo_tenant_id, 'user1demo.com', '$2b$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'User One', 'user'),
    (demo_tenant_id, 'user2demo.com', '$2b$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'User Two', 'user')
    ON CONFLICT DO NOTHING;
    
    -- Demo Projects (created by tenant admin)
    INSERT INTO projects (tenantid, name, description, status, createdby) VALUES 
    (demo_tenant_id, 'Website Redesign', 'Complete company website redesign', 'active', 
     (SELECT id FROM users WHERE email = 'admindemo.com')),
    (demo_tenant_id, 'Mobile App', 'Develop iOS/Android companion app', 'inprogress', 
     (SELECT id FROM users WHERE email = 'admindemo.com'))
    ON CONFLICT DO NOTHING;
    
    -- Demo Tasks
    INSERT INTO tasks (projectid, tenantid, title, description, priority, assignedto) VALUES 
    ((SELECT id FROM projects WHERE name = 'Website Redesign'), demo_tenant_id, 'Design Homepage', 'Create high-fidelity mockups', 'high', 
     (SELECT id FROM users WHERE email = 'user1demo.com')),
    ((SELECT id FROM projects WHERE name = 'Website Redesign'), demo_tenant_id, 'API Integration', 'Connect frontend to backend APIs', 'medium', 
     (SELECT id FROM users WHERE email = 'user2demo.com')),
    ((SELECT id FROM projects WHERE name = 'Mobile App'), demo_tenant_id, 'User Authentication', 'Implement JWT login flow', 'high', NULL)
    ON CONFLICT DO NOTHING;
END $$;
