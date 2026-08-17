INSERT INTO "RolePermission" ("roleId", "permissionId")
SELECT r.id, p.id
FROM "Role" r, "Permission" p
WHERE r.name = 'LOCATAIRE' AND p.code = 'maintenance:manage_attachments'
ON CONFLICT DO NOTHING;
