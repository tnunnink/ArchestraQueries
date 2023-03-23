-- =============================================
-- Author:		Timothy Nunnink
-- Create date: 9/28/2022
-- Description:	Gets table of derived objects
-- from supplied object id table.
-- =============================================
ALTER FUNCTION [dbo].[Descendants]
(	
	@ObjectIds gobject_id_type READONLY
)
RETURNS TABLE 
AS
RETURN 
(
	WITH CTE AS (
	SELECT g.*,
			0 as Level,
			CAST(g.tag_name as nvarchar(500)) derivation_path
	FROM gobject g
	WHERE g.gobject_id IN (SELECT * FROM @ObjectIds)
	UNION ALL
	SELECT c.*,
			d.Level + 1 as Level,
			CAST(CONCAT(d.derivation_path, '\', c.tag_name) as nvarchar(500)) derivation_path
	FROM gobject c
		JOIN CTE d ON d.gobject_id = c.derived_from_gobject_id
	)

	SELECT * FROM CTE
)
