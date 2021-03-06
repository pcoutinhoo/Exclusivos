

TEXT TO XSEL NOSHOW TEXTMERGE 
	--- SINTETICO

	SELECT LANCAMENTOS.COD_MATRIZ_CONTABIL,LANCAMENTOS.MATRIZ_CONTABIL,
	VISAO.CLASSIFICACAO,VISAO.DESCR_CONTA,SUM(LANCAMENTOS.VALOR_PAGAR) AS VALOR_ABERTO
	FROM 

		--- EM ABERTO -------
		(SELECT A.[COD MATRIZ CONTABIL] AS COD_MATRIZ_CONTABIL,B.FILIAL AS MATRIZ_CONTABIL,
		A.[CONTA CONTABIL] AS CONTA_CONTABIL,A.[DESC CONTA] AS DESC_CONTA,A.LANCAMENTO,A.ITEM,
		CONVERT(INT,NULL) AS LANCAMNETO_MOV,CONVERT(INT,NULL) AS ITEM_MOV,
		A.[VALOR A PAGAR PADRAO] AS VALOR_PAGAR,CONVERT(VARCHAR(13),'EM ABERTO') AS EM_ABERTO 
		FROM TMP_TITULOS_ABERTO_3110 A 
		JOIN FILIAIS B 
		ON A.[COD MATRIZ CONTABIL]=B.COD_FILIAL
		WHERE A.[COD MATRIZ CONTABIL]='000990'
		AND A.[TIPO MOVIMENTO]=1
		--- EM ABERTO -------

		UNION ALL

		--- PAGOS DEPOIS-----
		SELECT A.[COD MATRIZ CONTABIL] AS COD_MATRIZ_CONTABIL,B.FILIAL AS MATRIZ_CONTABIL,
		A.[CONTA CONTABIL] AS CONTA_CONTABIL,A.[DESC CONTA] AS DESC_CONTA,A.LANCAMENTO,A.ITEM,
		A.[LANCAMENTO MOV] AS LANCAMNETO_MOV,A.[ITEM MOV] AS ITEM_MOV,
		A.[VALOR MOV PADRAO] AS VALOR_PAGO ,CONVERT(VARCHAR(13),'PAGO_DEPOIS') AS EM_ABERTO 
		FROM TMP_TITULOS_PAGOS_3110 A 
		JOIN FILIAIS B 
		ON A.[COD MATRIZ CONTABIL]=B.COD_FILIAL
		WHERE A.[COD MATRIZ CONTABIL]='000990'
		AND A.[TIPO MOVIMENTO]=1 ) LANCAMENTOS
		--- PAGOS DEPOIS-----

	JOIN 

		(SELECT B.CONTA_CONTABIL,A.CLASSIFICACAO,C.DESCR_CONTA 
		FROM CTB_PLANO_VISAO A 
		JOIN CTB_CONTA_PLANO B 
		ON A.CONTA_CONTABIL=B.CONTA_CONTABIL 
		JOIN CTB_VISAO C 
		ON A.CLASSIFICACAO=C.CLASSIFICACAO 
		AND A.VISAO_CONTABIL=C.VISAO_CONTABIL
		WHERE A.VISAO_CONTABIL='11' ) VISAO 

	ON LANCAMENTOS.CONTA_CONTABIL=VISAO.CONTA_CONTABIL
	GROUP BY LANCAMENTOS.COD_MATRIZ_CONTABIL,LANCAMENTOS.MATRIZ_CONTABIL,
	VISAO.CLASSIFICACAO,VISAO.DESCR_CONTA 
	ORDER BY LANCAMENTOS.COD_MATRIZ_CONTABIL,LANCAMENTOS.MATRIZ_CONTABIL,
	VISAO.CLASSIFICACAO

ENDTEXT

F_SELECT(XSEL,'CUR_LANCAMENTOS_SINTETICO')

SELECT CUR_LANCAMENTOS_SINTETICO
COPY TO C:\TEMP\LANCAMENTOS_SINTETICO.XLS XLS





TEXT TO XSEL NOSHOW TEXTMERGE 

	--- ANALITICO

	SELECT LANCAMENTOS.COD_MATRIZ_CONTABIL,LANCAMENTOS.MATRIZ_CONTABIL,
	VISAO.CLASSIFICACAO,VISAO.DESCR_CONTA,LANCAMENTOS.CONTA_CONTABIL,
	LANCAMENTOS.DESC_CONTA,LANCAMENTOS.LANCAMENTO,LANCAMENTOS.ITEM,LANCAMENTOS.LANCAMENTO_MOV,
	LANCAMENTOS.ITEM_MOV,LANCAMENTOS.VALOR_PAGAR,LANCAMENTOS.EM_ABERTO,CONVERT(VARCHAR(25),LANCAMENTOS.NOME_CLIFOR) AS NOME_CLIFOR,
	CONVERT(VARCHAR(25),LANCAMENTOS.NOME_CLIFOR_SACADO) AS NOME_CLIFOR_SACADO,
	CONVERT(VARCHAR(10),CASE WHEN LOJAS.FILIAL IS NOT NULL THEN 'LOJA' ELSE '' END) AS LOJA
	FROM 

		--- EM ABERTO -------
		(SELECT A.[COD MATRIZ CONTABIL] AS COD_MATRIZ_CONTABIL,B.FILIAL AS MATRIZ_CONTABIL,
		A.[CONTA CONTABIL] AS CONTA_CONTABIL,A.[DESC CONTA] AS DESC_CONTA,A.LANCAMENTO,A.ITEM,
		CONVERT(INT,NULL) AS LANCAMENTO_MOV,CONVERT(INT,NULL) AS ITEM_MOV,
		A.[VALOR A PAGAR PADRAO] AS VALOR_PAGAR,CONVERT(VARCHAR(13),'EM ABERTO') AS EM_ABERTO,
		A.[NOME CLIFOR] AS NOME_CLIFOR ,A.[NOME CLIFOR SACADO] AS NOME_CLIFOR_SACADO ,CONVERT(DATETIME,A.VENCIMENTO) AS VENCIMENTO
		FROM TMP_TITULOS_ABERTO_3110 A 
		JOIN FILIAIS B 
		ON  A.[COD MATRIZ CONTABIL]=B.COD_FILIAL
		WHERE A.[COD MATRIZ CONTABIL]='000990' 
		AND A.[TIPO MOVIMENTO]=1
		--- EM ABERTO -------

		UNION ALL

		--- PAGOS DEPOIS-----
		SELECT A.[COD MATRIZ CONTABIL] AS COD_MATRIZ_CONTABIL,B.FILIAL AS MATRIZ_CONTABIL,
		A.[CONTA CONTABIL] AS CONTA_CONTABIL,A.[DESC CONTA] AS DESC_CONTA,A.LANCAMENTO,A.ITEM,
		A.[LANCAMENTO MOV] AS LANCAMNETO_MOV,A.[ITEM MOV] AS ITEM_MOV,
		A.[VALOR MOV PADRAO] AS VALOR_PAGO ,CONVERT(VARCHAR(13),'PAGO_DEPOIS') AS EM_ABERTO,
		A.[NOME CLIFOR] AS NOME_CLIFOR ,A.[NOME CLIFOR SACADO] AS NOME_CLIFOR_SACADO,CONVERT(DATETIME,A.VENCIMENTO) AS VENCIMENTO
		FROM TMP_TITULOS_PAGOS_3110 A 
		JOIN FILIAIS B 
		ON A.[COD MATRIZ CONTABIL]=B.COD_FILIAL
		WHERE A.[COD MATRIZ CONTABIL]='000990'
		AND A.[TIPO MOVIMENTO]=1 ) LANCAMENTOS
		--- PAGOS DEPOIS-----

	JOIN 

		(SELECT B.CONTA_CONTABIL,A.CLASSIFICACAO,C.DESCR_CONTA 
		FROM CTB_PLANO_VISAO A 
		JOIN CTB_CONTA_PLANO B 
		ON A.CONTA_CONTABIL=B.CONTA_CONTABIL 
		JOIN CTB_VISAO C 
		ON A.CLASSIFICACAO=C.CLASSIFICACAO 
		AND A.VISAO_CONTABIL=C.VISAO_CONTABIL
		WHERE A.VISAO_CONTABIL='11' ) VISAO 

	ON LANCAMENTOS.CONTA_CONTABIL=VISAO.CONTA_CONTABIL


	LEFT JOIN LOJAS_VAREJO LOJAS
	ON LANCAMENTOS.NOME_CLIFOR_SACADO = LOJAS.FILIAL

	ORDER BY VISAO.CLASSIFICACAO

ENDTEXT 


F_SELECT(XSEL,'CUR_LANCAMENTOS_ANALITICO')

SELECT CUR_LANCAMENTOS_ANALITICO
COPY TO C:\TEMP\LANCAMENTOS_ANALITICO.XLS XLS