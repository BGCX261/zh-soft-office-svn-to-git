

IF EXISTS (
       SELECT *
       FROM   DBO.SYSOBJECTS
       WHERE  ID = OBJECT_ID(N'[DBO].[stp_GetNextSequence]')
              AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1
   )
    DROP PROCEDURE [DBO].[stp_GetNextSequence]
GO 

CREATE PROCEDURE stp_GetNextSequence
	@pKeyCode NVARCHAR(30)
AS
BEGIN
	DECLARE @pReturn INT  
	
	SELECT @pReturn = next_value
	FROM   NextSeq
	WHERE  keycode = @pKeyCode    
	
	IF ISNULL(@pReturn, 0) > 0
	BEGIN
	    SELECT @pReturn = @pReturn    
	    UPDATE NextSeq
	    SET    next_value = next_value + 1
	    WHERE  keycode = @pKeyCode
	END
	ELSE
	BEGIN
	    SELECT @pReturn = 1   
	    INSERT INTO NextSeq
	      (
	        keycode,
	        next_value
	      )
	    VALUES
	      (
	        @pKeyCode,
	        2
	      )
	END    
	
	SELECT @pReturn AS Result
END 