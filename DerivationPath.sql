-- =============================================
-- Author: Timothy Nunnink
-- Description:	Gets the derived path value for
-- the specified tag name.
-- =============================================
ALTER FUNCTION [dbo].[DerivationPathOf] 
(
	@TagName VARCHAR(329)
)
RETURNS NVARCHAR(1000)
AS
BEGIN
	DECLARE @Path NVARCHAR(1000)

	;WITH CTE AS (
	SELECT g.*,
			CAST(g.tag_name as nvarchar(1000)) derivation_path
	FROM gobject g
	WHERE g.tag_name = @TagName
	UNION ALL
	SELECT c.*,
			CAST(CONCAT(c.tag_name, '\', d.derivation_path) as nvarchar(1000)) derivation_path
	FROM gobject c
		JOIN CTE d ON d.derived_from_gobject_id = c.gobject_id
		WHERE d.derived_from_gobject_id > 0
	)

	SELECT @Path = (SELECT TOP 1 derivation_path FROM CTE WHERE derived_from_gobject_id = 0)
	RETURN @Path
END
