
/****** Object:  Table [dbo].[ANM_CLIENTE_ATAC_LIMITE_CREDITO]    Script Date: 14/09/2016 10:32:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ANM_CLIENTE_ATAC_LIMITE_CREDITO](
	[REDE_LOJAS] [char](6) NOT NULL,
	[COLECAO] [char](6) NOT NULL,
	[COD_CLIENTE] [char](6) NOT NULL,
	[LIMITE] [numeric](14, 2) NOT NULL,
 CONSTRAINT [PK_ANM_CLIENTE_ATAC_LIMITE_CREDITO] PRIMARY KEY CLUSTERED 
(
	[REDE_LOJAS] ASC,
	[COLECAO] ASC,
	[COD_CLIENTE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

