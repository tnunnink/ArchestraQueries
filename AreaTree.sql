-- =============================================
-- Author: Timothy Nunnink
-- Description:	Gets the heirarchical tree of
-- area objects for a given area tag name.
-- =============================================
ALTER FUNCTION [dbo].[AreaTree] 
(	
	@TagName NVARCHAR(329)
)
RETURNS TABLE 
AS
RETURN 
(
	WITH AreaTree AS (
	SELECT 0 [Level], 
			CAST(tag_name AS NVARCHAR(1000)) [Path],
			g.*
	FROM gobject g
	WHERE g.template_definition_id = 26 and g.is_template = 0 and tag_name = @TagName
	UNION ALL
	SELECT [Level] + 1 [Level],
			CAST(CONCAT([Path], '\', g.tag_name) AS NVARCHAR(1000)) [Path],
			g.*
	FROM gobject g
	JOIN AreaTree a on a.gobject_id = g.area_gobject_id
	WHERE g.template_definition_id = 26 and g.is_template = 0
	)

	SELECT * FROM AreaTree
)
