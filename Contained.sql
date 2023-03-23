-- =============================================
-- Author: Timothy Nunnink
-- Create date: 11/8/2022
-- Description:	Gets table of contained objects
-- for the provided object id table.
-- =============================================
ALTER FUNCTION [dbo].[Contained]
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
			0 as contained_level,
			CAST('' AS NVARCHAR(329)) container_name,
			CAST(g.tag_name as nvarchar(1000)) contained_path
	FROM gobject g
	WHERE g.gobject_id IN (SELECT * FROM @ObjectIds)
	UNION ALL
	SELECT c.base_tag_name,
			g.*,
			c.contained_level + 1 as contained_level,
			c.tag_name container_name,
			CAST(CONCAT(c.contained_path, '.', g.contained_name) as nvarchar(1000)) contained_path
	FROM gobject g
		JOIN CTE c ON c.gobject_id = g.contained_by_gobject_id
	)

	SELECT * FROM CTE
)
