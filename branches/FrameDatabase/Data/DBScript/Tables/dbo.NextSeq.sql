IF not exists (SELECT 1
            FROM  sysobjects
            WHERE  id = object_id(N'[dbo].[NextSeq]')
            AND   TYPE = 'U')
BEGIN
CREATE TABLE [dbo].[NextSeq](
	[Keycode] [varchar](30) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[Next_value] [int] NOT NULL CONSTRAINT [DF__next_seq__next_v__1209AD79]  DEFAULT (0),
	[Next_string] [varchar](30) COLLATE Chinese_PRC_CI_AS NULL,
 CONSTRAINT [PK_next_seq] PRIMARY KEY CLUSTERED 
(
	[keycode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END

