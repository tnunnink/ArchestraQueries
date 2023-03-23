CREATE view [dbo].[HistorizedTags] AS
SELECT g.gobject_id,
		g.tag_name ObjectName,
		p.primitive_name AttributeName,
		concat(g.tag_name, '.', p.primitive_name) TagName
FROM gobject g
JOIN primitive_instance p on g.gobject_id = p.gobject_id and g.deployed_package_id = p.package_id and p.execution_group = 18
GO
