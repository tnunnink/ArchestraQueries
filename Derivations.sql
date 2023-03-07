-- =============================================
-- Author: Timothy Nunnink
-- Create date: 11/8/2022
-- Description:	Gets table of parent template
-- objects for all object ids in input table.
-- =============================================
ALTER FUNCTION [dbo].[Derivations]
(	
	@ObjectIds gobject_id_type READONLY
)
RETURNS TABLE 
AS
RETURN 
(
	WITH CTE AS (
	SELECT g.tag_name base_tag_name,
			g.*,
			0 as derivation_level,
			CAST(g.tag_name as nvarchar(500)) derivation_path
	FROM gobject g
	WHERE g.gobject_id IN (SELECT * FROM @ObjectIds)
	UNION ALL
	SELECT d.base_tag_name,
			p.*,
			d.derivation_level + 1 as derivation_level,
			CAST(CONCAT(d.derivation_path, '\', p.tag_name) as nvarchar(500)) derivation_path
	FROM gobject p
		JOIN CTE d ON d.derived_from_gobject_id = p.gobject_id
	)

	SELECT * FROM CTE
)
