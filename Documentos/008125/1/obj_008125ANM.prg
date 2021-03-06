* Cria��o *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HOR�RIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Campos Adicionais Ordens de Servico	/ Seleciona somente materiais da fase corrente					                    *
********************************************************************************************************************* 

* Altera��o ********************************************************************************************************* 
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HOR�RIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                                        *
* OBJETIVO.:                                                                                                        *
********************************************************************************************************************* 


********************************************************************************************************************* 
*- Programa Base de Cria��o de Objeto de Entrada                                                                    *
********************************************************************************************************************* 
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela                                      *
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos                                            *
********************************************************************************************************************* 
*- Existem 2 parametros que influem nos objetos de Entrada:                                                         *
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos                       *
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execu��o para facilitar o desenvolvimento *
********************************************************************************************************************* 
* - Atencao !!!!!!!!!!!														                                        *
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP                                      *
********************************************************************************************************************* 

define class obj_entrada as custom
	*- Nome do metodo/fun��o que os objetos linx v�o chamar.

	procedure metodo_usuario
		*- Parametros do metodo:
		*- Xmetodo= nome do metodo
		*- Xobjeto= variavel com a referencia ao objeto
		*- Xnome_obj  = nome do objeto
		lparam xmetodo, xobjeto ,xnome_obj
		
		******************** Metodos chamados pelo FORMSET
		*	USR_INIT  												=> NA INICIALIZACAO DA TELA 
		*	USR_ALTER_BEFORE  -> Return .f. Para o Metodo 			=> ANTES DA ALTERACAO ,AO CLICKAR ANTES DE LIBERAR OS CAMPOS
		*	USR_ALTER_AFTER 										=> APOS LIBERAR OS CAMPOS PARA INCLUSAO   
		*	USR_INCLUDE_AFTER 										=> APOS LIBERAR OS CAMPOS PARA INCLUSAO
		*	USR_SEARCH_BEFORE -> Return .f. Para o Metodo PESQUISA	=> ANTES DE FAZER A PESQUISA NO BANCO
		*	USR_SEARCH_AFTER										=> APOS FAZER A PESQUISA NO BANCO
		*	USR_CLEAN_AFTER 										=> APOS LIMPAR A TELA 
		*	USR_REFRESH                                             => 
		*	USR_SAVE_BEFORE   -> Return .f. Para o Metodo 			=> SALVAR ANTES DE JOGAR INFORMACOES NO BANCO
		*	USR_SAVE_AFTER                                          => APOS SALVAR AS INFORMACOES    NO BANCO
		*	USR_ITENs_DELETE_BEFORE -> Return .f. Para o Metodo 		=> ANTES DE EXCLUIR ITEN NA TABELA FILHA '+'
		*	USR_ITEN_DELETE_AFTER                                   => APOS DELETAR UM ITEM NA TABELA FILHA '-' 
		*	USR_ITEN_INCLUDE_BEFORE -> Return .f. Para o Metodo 	=> ANTES DE INCLUIR ITEM NA TABELA FILHA
		*	USR_ITEN_INCLUDE_AFTER									=> APOS INCLUIR ITEM NA TABELA FILHA 
		*
		***************** Metodos que ocorrem dentro da Transaction do Banco de Dados
		*	USR_TRIGGER_AFTER ->Return .f. Para o Salvamento e da Rollback ANTES DE EXECUTAR UMA TRIGGER
		*	USR_TRIGGER_BEFORE ->Return .f. Para o Salvamento e da Rollback


		******************** Metodo chamado pelos Objetos na Valida��o
		*   USR_VALID -> Return .f. N�o deixa o Usuario sair do objeto.

		******************** Metodo chamado pelos PageFrames
		*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada

		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

			do case

			case upper(xmetodo) == 'USR_INIT'	
				
				xalias=alias()		
				
							Public cData,xOldStatusAlmox
				
							cur1="RESERVA N(9,3),CONSUMIDA N(9,3),DATA_RESERVA D,RESERVA_ORIGINAL N(9,3),ULTIMA_SAIDA D,DIFERENCA_PREVISAO N(9,3),FATOR_CONVERSAO_NA_RESERVA N(12,5),MATAR_SALDO_RESERVA L,DESC_COR_MATERIAL C(50),REFER_FABRICANTE C(15),FASE_PRODUCAO C(25),"
							cur2="SETOR_PRODUCAO C(25),DESC_MATERIAL C(40),FATOR_CONVERSAO N(9,4),UNID_ESTOQUE C(5),UNID_FICHA_TEC C(5),RESERVA_MATERIAL_OP L, MATERIAL_INDIRETO L,ABATER_RESERVA_QTDE L,ESTOQUE_MATERIAL N(16,3),FALTAS_MATERIAL N(16,3),OUTRAS_RESERVAS N(16,3),"
							cur3="ESTOQUE_DISPONIVEL N(16,3),COMPRAS N(16,3),NECESSIDADE_FINAL N(16,3),SOBRA_FINAL N(16,3),PROXIMA_ENTREGA D,MATERIAL_SUBSTITUIDO C(11),COR_MATERIAL_SUBSTITUIDO C(10),PRIORIDADE_SUBSTITUICAO I,ALTERACAO_CONSUMO N(8,2),SUBSTITUICAO_POR_PRODUTO L,"
							cur4="GRUPO C(25),SUBGRUPO C(25),ORDEM_SERVICO C(8),MATERIAL C(11),COR_MATERIAL C(10),ORDEM_PRODUCAO C(8),ITEM C(3),QTDE_NECESSARIA N(9,3)"
								
							ocursor = GETCURSORADAPTER("V_PRODUCAO_OS_02_MATERIAIS")							
							ocursor.CursorSchema =cur1+cur2+cur3+cur4
							
							cur1="CONSUMIDA N(11,3),RESERVA N(11,3),DATA_RESERVA D,RESERVA_ORIGINAL N(11,3),ULTIMA_SAIDA D,DIFERENCA_PREVISAO N(11,3),FATOR_CONVERSAO_NA_RESERVA N(12,5),MATAR_SALDO_RESERVA L,DESC_COR_MATERIAL C(50),REFER_FABRICANTE C(15),"
							cur2="FASE_PRODUCAO C(25),SETOR_PRODUCAO C(25),DESC_MATERIAL C(40),FATOR_CONVERSAO N(12,5),UNID_ESTOQUE C(5),UNID_FICHA_TEC C(5),RESERVA_MATERIAL_OP L,MATERIAL_INDIRETO L,ABATER_RESERVA_QTDE L,ESTOQUE_MATERIAL N(16,3)," 
							cur3="FALTAS_MATERIAL N(16,3),OUTRAS_RESERVAS N(16,3),ESTOQUE_DISPONIVEL N(16,3),COMPRAS N(16,3),NECESSIDADE_FINAL N(16,3),SOBRA_FINAL N(16,3),PROXIMA_ENTREGA D,MATERIAL_SUBSTITUIDO C(11),COR_MATERIAL_SUBSTITUIDO C(10),"
							cur4="PRIORIDADE_SUBSTITUICAO I,ALTERACAO_CONSUMO N(10,5),SUBSTITUICAO_POR_PRODUTO L,GRUPO C(25),SUBGRUPO C(25),ORDEM_SERVICO C(8),MATERIAL C(11),COR_MATERIAL C(10),ORDEM_PRODUCAO C(8),ITEM C(3),QTDE_NECESSARIA N(11,3),"
							cur5="PARTE_APLICADO_MATERIAL C(10),DESC_USO_MATERIAL C(40),AUX N(3,0),PRODUTO C(12),COR_PRODUTO C(10),DESC_PRODUTO C(40),DESC_COR_PRODUTO C(40)"

							
							ocursor = GETCURSORADAPTER("V_PRODUCAO_OS_01_MATERIAIS")							
							ocursor.CursorSchema =cur1+cur2+cur3+cur4+cur5
							
							Thisformset.lx_forM1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.Col_tx_DESC_COR_MATERIAL.Tx_DESC_COR_MATERIAL.InputMask = "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
							
						
			 *Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_os_01   
				sele v_producao_os_01   
				xalias_pai=alias()

  				oCur = getcursoradapter(xalias_pai)
				oCur.addbufferfield("PRODUCAO_ORDEM_SERVICO.ANM_STATUS_ALMOX", "C(25)",.T., "ANM_STATUS_ALMOX", "PRODUCAO_ORDEM_SERVICO.ANM_STATUS_ALMOX")
				oCur.addbufferfield("PRODUCAO_ORDEM_SERVICO.ANM_DATA_INICIO_SEPARACAO", "D",.T., "ANM_DATA_INICIO_SEPARACAO", "PRODUCAO_ORDEM_SERVICO.ANM_DATA_INICIO_SEPARACAO")				
				oCur.addbufferfield("SPACE(70) AS PROG_PRIORIDADE","C(70)",.T.,"PROG_PRIORIDADE","PROG_PRIORIDADE")
				oCur.confirmstructurechanges() 	
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 

			
			*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_os_01   
				sele v_producao_os_01_tarefas   
				xalias_pai=alias()

  				oCur = getcursoradapter(xalias_pai)
				oCur.addbufferfield("PRODUTOS.GRIFFE", "C(25)",.T., "GRIFFE", "PRODUTOS.GRIFFE")
				oCur.addbufferfield("PRODUTOS.COLECAO", "C(25)",.T., "COLECAO", "PRODUTOS.COLECAO")
				oCur.confirmstructurechanges() 	
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 
	
				

			 *Inicio Inclusao Campos Novos de Produtos no Cursor Filha-- v_producao_os_02_materiais   
				sele v_producao_os_02_materiais   
				xalias_pai=alias()

  				oCur = getcursoradapter(xalias_pai)
				*oCur.addbufferfield("SPACE(25) AS ANM_RESERVA_ALMOX" , "C(25)",.T., "ANM_RESERVA_ALMOX", "ANM_RESERVA_ALMOX")
				oCur.addbufferfield("0 AS ANM_RESERVA_ALMOX" , "I",.T., "ANM_RESERVA_ALMOX", "ANM_RESERVA_ALMOX")
				oCur.confirmstructurechanges() 	
				**-Fim Inclusao Campos Novos de Produtos no Cursor Filha
			
			 * Inclui Nova Procedure na Classe da Tela >> Dentro de Activate da Guia Materiais
			 		Bindevent(thisformset.lx_FORM1.lx_pageframe1.page6, "Activate", This, "AnmBuscaSeparaAlmox", 1)


				

				Thisformset.L_limpa()
				o_toolbar.Botao_limpa.Click()  


				f_select("select colecao from colecoes order by colecao","xcolecao",ALIAS())
				f_select("select griffe from produtos_griffes order by griffe","xgriffe",ALIAS())
				
				TEXT TO xSelPropProg TEXTMERGE NOSHOW
					SELECT case when VALOR_PROPRIEDADE = 'MOSTRUARIO' THEN '1-MOSTRUARIO'
						 when VALOR_PROPRIEDADE = 'VAREJO'     THEN '2-VAREJO'
						 when VALOR_PROPRIEDADE = 'ATACADO'    THEN '3-ATACADO'
					else '4-'+LTRIM(VALOR_PROPRIEDADE) END AS 'PROG_PRIORIDADE'
					FROM PROPRIEDADE_VALIDA WHERE PROPRIEDADE = '00038'
					ORDER BY case when VALOR_PROPRIEDADE = 'MOSTRUARIO' THEN '1-MOSTRUARIO'
						 when VALOR_PROPRIEDADE = 'VAREJO'     THEN '2-VAREJO'
						 when VALOR_PROPRIEDADE = 'ATACADO'    THEN '3-ATACADO'
					else '4-'+LTRIM(VALOR_PROPRIEDADE) END
				ENDTEXT
				f_select(xSelPropProg,"xprogPrioridade",ALIAS())
				
				public xstatus_entrada,xordem_servico,curSepara
				
				f_select("select convert(varchar(25),valor_propriedade) as anm_status_almox from propriedade_valida where propriedade='00057'","xstatus_entrada")
				
				text to xselSepara noshow textmerge	
					select 1 as cod_separacao_almox,convert(varchar(25),'SEPARA') as desc_separacao_almox
					union all
					select 2 as cod_separacao_almox,convert(varchar(25),'N�O SEPARA') as desc_separacao_almox	
				endtext	
				
				f_select(xselSepara,"curSepara",alias() )
				
				store '' to	xordem_servico

				with thisformset.lx_form1
					.addobject("lb_status_entrada","lb_status_entrada")
					.addobject("cmb_status_entrada","cmb_status_entrada")
					.addobject("tx_data_ini_separacao","tx_data_ini_separacao")					
					.addobject("lb_data_ini_separacao","lb_data_ini_separacao")
					.addobject("bt_salvar","bt_salvar")
					.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.RemoveObject("tx_COR_MATERIAL_SUBSTITUIDO")
					.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.addobject("cmb_separa_almox","cmb_separa_almox")						
				endwith		
			
				with thisformset.lx_form1
					.cmb_status_entrada.RowSource="xstatus_entrada"
					.cmb_status_entrada.ControlSource="v_producao_os_01.ANM_STATUS_ALMOX" 
					.tx_data_ini_separacao.ControlSource="v_producao_os_01.ANM_DATA_INICIO_SEPARACAO" 
					.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.cmb_separa_almox.RowSource="curSepara.desc_separacao_almox,cod_separacao_almox"
					.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.controlsource="v_producao_os_02_materiais.ANM_RESERVA_ALMOX"
					.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Enabled= .F.
					.lx_pageframe1.page9.addobject("cmb_prog_prioridade","cmb_prog_prioridade")
					.lx_pageframe1.page9.addobject("lb_filtro_tipoProg","lb_filtro_tipoProg")
					.lx_pageframe1.page2.addobject("tx_codigo_barras","tx_codigo_barras")
					.lx_pageframe1.page2.addobject("lb_codigo_barra","lb_codigo_barra")  
					.lx_pageframe1.page5.addobject("bt_altera_obs","bt_altera_obs")
					.lx_pageframe1.page6.lx_pageframe1.page1.AddObject("bt_inverte_separacao", "bt_inverte_separacao")
				endwith	
				
				f_select( "SELECT '' AS FILIAL UNION ALL "+ ;
						  +"SELECT FILIAL FROM W_FILIAIS WHERE CTRL_ESTOQUE_MATERIAL = 1 AND TIPO_FILIAL LIKE '%ESTOQUE%' AND INATIVO = 0","CurFilOS")
				thisformset.lx_FORM1.cmb_FILIAL.RowSource="CurFilOS.filial"
				*thisformset.lx_FORM1.cmb_FILIAL.ControlSource="CurFilOS.filial"
								
				if !f_vazio(xalias)
					sele &xalias
				endif	
			
			
			case upper(xmetodo) == 'USR_TX_ORDEM_PRODUCAO' AND UPPER(xnome_obj)=='TX_ORDEM_PRODUCAO'
				
				TEXT TO xSelValorProg TEXTMERGE NOSHOW				
					
					select valor_propriedade as valor_prop
					from PROP_PRODUCAO_PROGRAMA A
					join PRODUCAO_ORDEM B
					ON A.PROGRAMACAO = B.PROGRAMACAO
					where PROPRIEDADE = '00038'
					AND ORDEM_PRODUCAO = '<<ALLTRIM(v_producao_os_02_anterior.ordem_producao)>>'			
				
				ENDTEXT
				
				f_select("SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_OS_CODIGO_BARRA') as valor_atual","xPropHab")
				f_select("SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_OS_CODIGO_BARRA_TIPO') as valor_atual","xPropTipo")				
				f_select(xSelValorProg,"xPropProg")
				
				IF thisformset.lx_FORM1.tv_fase_producao.value = "021" AND VAL(xPropHab.valor_atual) = 0 AND ALLTRIM(xPropProg.valor_prop) $ ALLTRIM(xPropTipo.valor_atual)
					
					IF thisformset.lx_FORM1.Cnt_Tipo_Digitacao.Ck_op_por_digitacao.Value=1
						thisformset.lx_FORM1.lx_pageframe1.page2.tx_codigo_barras.Visible = .T.
						thisformset.lx_FORM1.lx_pageframe1.page2.lb_codigo_barra.Visible = .T. 
						thisformset.lx_FORM1.lx_pageframe1.page2.LX_GRID_FILHA1.Col_tx_QTDE_A.Lx_grade48_1.Enabled= .F. 
					ELSE
						thisformset.lx_FORM1.lx_pageframe1.page2.tx_codigo_barras.Visible = .F. 
					ENDIF
					
					sele v_producao_os_02_anterior
					GO TOP
					SCAN

						FOR i=1 TO 48
							xGrade = "A"+ALLTRIM(STR(i))
							REPLACE &xGrade WITH 0
						NEXT

					sele v_producao_os_02_anterior
					ENDSCAN
					
					sele v_producao_os_02_anterior
					GO TOP	
					
					RETURN .T.
					
				ENDIF
			
			
			case upper(xmetodo) == 'USR_VALID' AND UPPER(xnome_obj)=='TX_CODIGO_BARRAS'
			
				IF !EMPTY(thisformset.lx_FORM1.lx_pageframe1.page2.tx_codigo_barras.value)
					
					xCodigoBarra = ALLTRIM(thisformset.lx_FORM1.lx_pageframe1.page2.tx_codigo_barras.value)
					f_select("SELECT PRODUTO,COR_PRODUTO,'A'+RTRIM(CONVERT(CHAR(2),TAMANHO)) AS GRADE FROM PRODUTOS_BARRA WHERE CODIGO_BARRA =?xCodigoBarra","xTmpGrade")

					IF RECCOUNT() > 0 
					sele v_producao_os_02_anterior
					LOCATE FOR COR_PRODUTO = xTmpGrade.cor_produto AND PRODUTO = xTmpGrade.produto
						IF !EOF()
							xComando = "v_producao_os_02_anterior."+xTmpGrade.grade
							xGrade = xTmpGrade.grade
							sele v_producao_os_02_anterior
							REPLACE &xGrade WITH evaluate(xComando)+1
						ELSE
							MESSAGEBOX("Produto\Cor n�o encontrado na Ordem de servi�o!",48)
							RETURN .F.
						ENDIF	
					ELSE
						MESSAGEBOX("C�digo de Barras n�o encontrado no cadastro de Produtos!",48)
						RETURN .F.
					ENDIF	
				
					thisformset.lx_FORM1.lx_pageframe1.page2.tx_codigo_barras.value = ""
					thisformset.lx_FORM1.lx_pageframe1.page2.LX_GRID_FILHA1.Col_tx_QTDE_A.Lx_grade48_1.L_desenhista_recalculo()
					
					RETURN .F.
									
				ENDIF	
				
				
			
				
			case upper(xmetodo) == 'USR_VALID' AND UPPER(xnome_obj)=='TX_ORDEM_PRODUCAO'
					*alimentar propriedades de tarefa_anterior
					
				    SELECT v_producao_os_02_anterior
				     	
*!*					     	TEXT TO  xverifOsAnterior NOSHOW TEXTMERGE
*!*					     		select tarefa,tarefa_anterior,ordem_servico 
*!*					     		from PRODUCAO_OS_ANTERIOR 
*!*					     		where ordem_producao='<<ALLTRIM(v_producao_os_02_anterior.ordem_producao)>>'
*!*					     		and tarefa='<<ALLTRIM(v_producao_os_02_anterior.tarefa_anterior)>>'

*!*					     	ENDTEXT
						
						TEXT TO  xverifOsAnterior NOSHOW TEXTMERGE
				     		select tarefa,tarefa_anterior,ordem_servico 
				     		from PRODUCAO_OS_ANTERIOR 
				     		where ordem_producao='<<ALLTRIM(v_producao_os_02_anterior.ordem_producao)>>'
				     	ENDTEXT
						
						f_select(xverifOsAnterior,'curOsAnterior',ALIAS())
						
						SELECT curOsAnterior
						IF RECCOUNT()>0
							
*!*								TEXT TO xselProps NOSHOW TEXTMERGE							
*!*									select ordem_servico,propriedade,
*!*									case when propriedade = '00053' then '0.00' else 
*!*									valor_propriedade end as  valor_propriedade
*!*									from PROP_PRODUCAO_ORDEM_SERVICO 
*!*									where ordem_servico='<<ALLTRIM(curOsAnterior.ordem_servico)>>'
*!*								ENDTEXT
							
							TEXT TO xselProps NOSHOW TEXTMERGE							
								select min(ordem_servico) ordem_servico,propriedade,
								case when propriedade = '00053' then '0.00' else 
								valor_propriedade end as  valor_propriedade
								from PROP_PRODUCAO_ORDEM_SERVICO 
								where ordem_servico in ( select ordem_servico 
											     		 from PRODUCAO_OS_ANTERIOR 
											     		 where ordem_producao='<<ALLTRIM(v_producao_os_02_anterior.ordem_producao)>>'
											     		 and tarefa='<<ALLTRIM(v_producao_os_02_anterior.tarefa_anterior)>>' )
								group by propriedade,case when propriedade = '00053' then '0.00' else valor_propriedade end												     		 
							ENDTEXT
							
							
							f_select(xselProps,'curProps',ALIAS())
							
							SELECT curProps
							SCAN 							
								replace ALL valor_propriedade WITH curProps.valor_propriedade FOR propriedade=curProps.propriedade  IN curPropProducaoOrdemServico
							
							ENDSCAN
							
							RELEASE curProps

						ENDIF
				

*!*					case upper(xmetodo) == 'USR_VALID' AND UPPER(xnome_obj)=='TV_SETOR_PRODUCAO'
*!*						
*!*						Sele v_producao_os_01
*!*						
*!*						If thisformset.pp_ANM_BLOQ_MOVIMENTAR_OS AND v_producao_os_01.desc_setor_producao = 'EXTERNO'
*!*							Messagebox("Favor dar Entrada de Nota Fiscal por Ordem de Servi�o !!!",0+48)
*!*							Return .f.
*!*						Endif
*!*					
				case upper(xmetodo) == 'USR_SAVE_BEFORE'	
					
					
						LOCAL xVerificado 
				  			xVerificado = 0
				  			
				  			SELE V_PRODUCAO_OS_01_TAREFAS
				  			GO TOP
					  	  		
					  	  	   IF v_producao_os_01.FASE_PRODUCAO = '170'
					  	  	   	
						  	  	   TEXT TO xSelNF_Fabrica TEXTMERGE NOSHOW
						  	  	   
						  	  	 --  		SELECT TOP 1 NF_SAIDA,SERIE_NF 
								 --		FROM FATURAMENTO_PROD A
								 -- 			JOIN PRODUCAO_ORDEM B
								--		ON A.ORDEM_PRODUCAO = RIGHT(RTRIM(LTRIM(B.ORDEM_CORTE)),LEN(B.ORDEM_PRODUCAO))
								--			
								--		WHERE B.ORDEM_PRODUCAO = '<<V_PRODUCAO_OS_01_TAREFAS.ORDEM_PRODUCAO>>' 	
								--		ORDER BY NF_SAIDA
								SELECT TOP 1 A.NF_SAIDA,A.SERIE_NF
										FROM FATURAMENTO_PROD A
											JOIN (SELECT * FROM PRODUCAO_ORDEM 
												  WHERE RIGHT(RTRIM(LTRIM(ORDEM_CORTE)),LEN(ORDEM_PRODUCAO)) IN
														(SELECT RIGHT(RTRIM(LTRIM(ORDEM_CORTE)),LEN(ORDEM_PRODUCAO)) FROM PRODUCAO_ORDEM WHERE ORDEM_PRODUCAO = '<<V_PRODUCAO_OS_01_TAREFAS.ORDEM_PRODUCAO>>') OR
														ORDEM_PRODUCAO = (SELECT RIGHT(RTRIM(LTRIM(ORDEM_CORTE)),LEN(ORDEM_PRODUCAO)) FROM PRODUCAO_ORDEM WHERE ORDEM_PRODUCAO = '<<V_PRODUCAO_OS_01_TAREFAS.ORDEM_PRODUCAO>>' ) ) B
											ON A.ORDEM_PRODUCAO = B.ORDEM_PRODUCAO
											--= RIGHT(RTRIM(LTRIM(B.ORDEM_CORTE)),LEN(B.ORDEM_PRODUCAO))
											LEFT JOIN FATURAMENTO_ENTRADA_DEVOLUCAO C
											ON A.NF_SAIDA = C.NF_ENTRADA
											AND A.SERIE_NF = C.SERIE_NF_ENTRADA
											AND A.FILIAL = C.NOME_CLIFOR
											AND A.QTDE = C.QTDE_DEVOLVIDA
											AND A.ITEM_IMPRESSAO = C.ITEM_IMPRESSAO_ENTRADA
										WHERE --B.ORDEM_PRODUCAO = '699137'	AND 
										C.NF_ENTRADA IS NULL 										
										ORDER BY A.NF_SAIDA		
						  	  	   ENDTEXT
						  	  	   
						  	  	   F_SELECT(xSelNF_Fabrica,"CurNFTransf")	
						  	  	   
						  	  	   SELECT v_producao_os_01
								   REPLACE nf_entrada       WITH CurNFTransf.NF_SAIDA
								   REPLACE serie_nf_entrada WITH CurNFTransf.SERIE_NF
						  	   
						  	   ENDIF
						  	   	   
						  	   
					  	   Sele v_producao_os_01_tarefas
							Go Top
				
								F_SELECT("select a.filial, matriz_fiscal, a.filial_producao, b.matriz from producao_ordem a join filiais b on a.filial = b.filial where ordem_producao=?v_producao_os_01_tarefas.ORDEM_PRODUCAO","CurMFOP")			
								F_SELECT("select filial, matriz, matriz_fiscal from filiais where filial=?v_producao_os_01.filial","CurMFOS")
								*f_select("select matriz_fiscal from filiais where filial =?CurFilialOS.Filial","xMatriz")
								f_select("select LTRIM(RTRIM(valor_propriedade)) as TIPO from prop_produtos where propriedade = '00036' and produto = ?v_producao_os_01_tarefas.produto","xTipoProd")
														
							If (thisformset.pp_anm_val_cons_filial_op = .t. AND  xTipoProd.TIPO = 'PRODUTO ACABADO') OR xTipoProd.TIPO = 'PRODU�AO'								
								If ALLTRIM(CurMFOS.Matriz) <> ALLTRIM(CurMFOP.Matriz)


									xFilialOsOld = v_producao_os_01.Filial
									MESSAGEBOX("Matriz da OP diferente da Matriz da OS !!!",0+16)
									replace v_producao_os_01.Filial with xFilialOsOld
									Return .F.
								endif
							endif

							f_select("select MAX(sequencia_produtiva) sequencia_produtiva from PRODUCAO_TAREFAS where ORDEM_PRODUCAO = ?v_producao_os_01_tarefas.ordem_producao","curMaxSeq")
							If ALLTRIM(v_producao_os_01_tarefas.sequencia_produtiva) = ALLTRIM(curMaxSeq.sequencia_produtiva)
									f_select("select valor_propriedade from prop_filiais where PROPRIEDADE = '00248' and filial = ?v_producao_os_01.Filial","xFabrica")
									If ALLTRIM(xFabrica.valor_propriedade) = 'SIM'
										Replace v_producao_os_01.Filial With CurMFOP.filial
									Else	
										f_select("select valor_propriedade from prop_filiais where propriedade = '00206' and filial = ?v_producao_os_01.Filial","xRevisao")
										If F_VAZIO(xRevisao.valor_propriedade)
											Replace v_producao_os_01.Filial With CurMFOP.filial
										Else	
											Replace v_producao_os_01.Filial With xRevisao.valor_propriedade		
										Endif								
									Endif
							Endif
*!*									Thisformset.lx_FORM1.Cmb_FILIAL.Refresh()
*!*													
*!*									Sele v_producao_os_01
*!*									f_select("select LEFT(ltrim(REDE_LOJAS),1) as rede_lojas from filiais (nolock) where filial=?CurFilialOS.FILIAL","xConsFilial")
*!*									Sele xConsFilial

*!*									Sele v_producao_os_01_tarefas
*!*									f_select("select rede_lojas from WANM_PRODUTOS_RL_UNION where produto=?v_producao_os_01_tarefas.produto","xConsProd")
*!*									Sele xConsProd

*!*		 							If ALLTRIM(xConsFilial.rede_lojas) <> ALLTRIM(xConsProd.rede_lojas)
*!*										MESSAGEBOX("Rede Lojas da Filial � diferente do produto !!!"+chr(13)+"Favor Procurar o TI !!!",0+16)
*!*										RETURN .f.
*!*									Endif
					
					IF thisformset.p_tool_status $'IA'
					 	
					 	IF ALLTRIM(V_PRODUCAO_OS_01_ANTERIOR.DESC_FASE_PRODUCAO) = 'FABRICA'
					 		f_select("SELECT CUSTO_TAREFA FROM PRODUCAO_TAREFAS WHERE TAREFA =?V_PRODUCAO_OS_01_ANTERIOR.tarefa_anterior","Cur_CustoFab")
							IF Cur_CustoFab.CUSTO_TAREFA <> V_PRODUCAO_OS_01_ANTERIOR.CUSTO_EFETIVO+V_PRODUCAO_OS_01_TAREFAS.custo_previsto
								MESSAGEBOX('CUSTOS DE FAC��O\FABRICA COM VALORES INCORRETOS :'+CHR(13)+CHR(13)+;
								'CUSTO INFORMADO PEDIDO:    R$ '+ALLTRIM(STR(Cur_CustoFab.CUSTO_TAREFA))+CHR(13)+;
								'CUSTO INFORMADO FABRICA:   R$ '+ALLTRIM(STR(V_PRODUCAO_OS_01_ANTERIOR.CUSTO_EFETIVO))+CHR(13)+;
								'CUSTO INFORMADO FAC��O:    R$ '+ALLTRIM(STR(V_PRODUCAO_OS_01_TAREFAS.custo_previsto))+CHR(13)+CHR(13)+;
								'CUSTO PEDIDO PRECISA SER IGUAL AO'+CHR(13)+'CUSTO FABRICA+CUSTO FAC��O',0+64)
								 
								thisformset.lx_foRM1.lx_pageframe1.page7.SetFocus()
								thisformset.lx_foRM1.lx_pageframe1.page7.Refresh()
								RETURN .F.
							ENDIF				
						ENDIF
			
						*F_SELECT("SELECT PROPRIEDADE FROM PROP_PRODUCAO_ORDEM_SERVICO WHERE ORDEM_SERVICO = ?v_producao_os_01.ORDEM_SERVICO AND PROPRIEDADE in ('00012','50013')","xProp")
						
				 	
				  		IF thisformset.p_tool_status == 'A'
						*** JULIO - acerta ultimo_custo na tabela producao_tarefas_saldo para puxar o valor correto na entrada de nota fiscal
							SELECT V_PRODUCAO_OS_01_TAREFAS
							
							TEXT TO xUpdateCusto NOSHOW TEXTMERGE
									UPDATE PRODUCAO_TAREFAS_SALDO SET 
									ULTIMO_CUSTO_PREVISTO = '<<v_producao_os_01_tarefas.custo_previsto>>' 
									WHERE TAREFA = '<<v_producao_os_01_tarefas.tarefa>>' 
									AND ORDEM_PRODUCAO = '<<v_producao_os_01_tarefas.ordem_producao>>' 
							ENDTEXT
								
							f_update(xUpdateCusto)	
							
						ENDIF	
						
					
		
*!*							SELECT v_producao_os_01
*!*							IF ALLTRIM(v_producao_os_01_anterior.fase_producao)='004'
*!*								
*!*								xCount=0
*!*								*SELECT * from curPropProducaoOrdemServico INTO cursor vtmp_prop_producao_ordem_servico_00 
*!*	 
*!*								SELECT curPropProducaoOrdemServico 
*!*								
*!*								IF RECCOUNT()>0 
*!*									   
*!*									xTotRec=RECCOUNT()
*!*									GO TOP 
*!*									*busca propriedade vazia
*!*									SCAN  
*!*										*cursor de propriedade varre somente registros com valor. 
*!*										xCount=xCount + 1 										
*!*									ENDSCAN 								
*!*									
*!*									GO TOP 
*!*									IF xCount<xTotRec-1
*!*										MESSAGEBOX('Propriedades pendentes de cadastro. Verifique!',0+48,"Aten��o")
*!*										RETURN .f.
*!*									ENDIF 
*!*									
*!*								ELSE 
*!*									MESSAGEBOX('Propriedades pendentes de cadastro. Verifique!',0+48,"Aten��o")	 
*!*									RETURN .f.
*!*									 	 	
*!*								ENDIF 
*!*							ENDIF						
*!*						
					
						thisformset.lx_form1.lb_status_entrada.visible = .t.
						thisformset.lx_form1.cmb_status_entrada.visible = .t.
					
					ENDIF
					
*!*						TEXT TO XVerifRedeFilial TEXTMERGE NOSHOW
*!*							
*!*							SELECT COUNT(*) AS OK
*!*							FROM FILIAIS (NOLOCK) B
*!*										JOIN PRODUTOS (NOLOCK) C
*!*										ON C.PRODUTO = '<<v_producao_os_01_tarefas.PRODUTO>>'
*!*										AND LEFT(CASE WHEN B.REDE_LOJAS IN (1,3,4,9) THEN 1 ELSE B.REDE_LOJAS END,1) = 
*!*										    LEFT(CASE WHEN C.REDE_LOJAS IN (1,3,4,9) THEN 1 ELSE C.REDE_LOJAS END,1)
*!*								WHERE B.FILIAL = '<<v_producao_os_01.FILIAL>>'
*!*						
*!*						ENDTEXT
*!*						
*!*						f_select(XVerifRedeFilial,"CurTempRedeFilial")
*!*						IF CurTempRedeFilial.OK = 0
*!*							MESSAGEBOX("Rede Loja da Filial diferente da Rede Loja do Produto.",64)
*!*							RETURN .f.
*!*						ENDIF
	
*!*						 case upper(xmetodo) == 'USR_SAVE_AFTER'
*!*							F_SELECT("SELECT PROPRIEDADE FROM PROP_PRODUCAO_ORDEM_SERVICO WHERE ORDEM_SERVICO = ?v_producao_os_01.ORDEM_SERVICO AND PROPRIEDADE in ('00012','50013')","xProp")
*!*								
*!*						 	IF !F_VAZIO(xProp.propriedade='00012') AND F_VAZIO(xProp.propriedade='50013')
*!*									MESSAGEBOX('Propriedades CHECKLIST STATUS pendente. Verifique!',0+48,"Aten��o")	 
*!*									RETURN .f.	 
*!*							ENDIF

					case upper(xmetodo) == 'USR_SAVE_AFTER'				
				
					*Lparameters cData
				
					F_SELECT("SELECT PROPRIEDADE FROM PROP_PRODUCAO_ORDEM_SERVICO WHERE ORDEM_SERVICO = ?v_producao_os_01.ORDEM_SERVICO  AND PROPRIEDADE in ('00012')","xProp012")
					F_SELECT("SELECT PROPRIEDADE, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_ORDEM_SERVICO WHERE ORDEM_SERVICO = ?v_producao_os_01.ORDEM_SERVICO  AND PROPRIEDADE in ('50013')","xProp013")

					IF !F_VAZIO(xProp012.propriedade='00012') AND F_VAZIO(xProp013.propriedade='50013')
						IF MESSAGEBOX('Propriedades CHECKLIST STATUS pendente. Verifique! Se Sim ser� "Aprovado", se N�o "Reprovado"',3+32,"Aten��o")=6
						xordem_servico1=v_producao_os_01.ordem_servico
				
							text to	xinsert2 noshow textmerge	

								INSERT INTO PROP_PRODUCAO_ORDEM_SERVICO
								(PROPRIEDADE,ITEM_PROPRIEDADE,VALOR_PROPRIEDADE,DATA_PARA_TRANSFERENCIA, ORDEM_SERVICO)
								SELECT 
								'50013','1','APROVADO','<<DTOS(WDATA)>>','<<xordem_servico1>>'
							endtext

					if !f_insert(xinsert2) 
					messagebox("N�o foi poss�vel Alterar o Status da Ordem de Servi�o",48,"Aten��o_8!")
					retu .f.
					endif
			ELSE
						xordem_servico1=v_producao_os_01.ordem_servico
				
						 text to xinsert2 noshow textmerge	

							INSERT INTO PROP_PRODUCAO_ORDEM_SERVICO
							(PROPRIEDADE,ITEM_PROPRIEDADE,VALOR_PROPRIEDADE,DATA_PARA_TRANSFERENCIA, ORDEM_SERVICO)
							SELECT 
							'50013','1','REPROVADO','<<DTOS(WDATA)>>','<<xordem_servico1>>'
						 endtext

					if !f_insert(xinsert2) 
						messagebox("N�o foi poss�vel Alterar o Status da Ordem de Servi�o",48,"Aten��o_8!")
						retu .f.
					endif
			endif
ENDIF 			
				
*!*					F_SELECT("SELECT PROPRIEDADE FROM PROP_PRODUCAO_ORDEM_SERVICO WHERE ORDEM_SERVICO = ?v_producao_os_01.ordem_servico  AND PROPRIEDADE in ('00012')","xProp012")
*!*					F_SELECT("SELECT PROPRIEDADE FROM PROP_PRODUCAO_ORDEM_SERVICO WHERE ORDEM_SERVICO = ?v_producao_os_01.ordem_servico  AND PROPRIEDADE in ('50013')","xProp013")
*SET STEP ON

				IF F_VAZIO(xProp012.propriedade='00012') AND (!F_VAZIO(xProp013.propriedade='50013') AND xProp013.valor_propriedade <> 'PENDENTE')
	*SET STEP ON			
						IF MESSAGEBOX('Propriedades DATA CHECKLIST pendente. Informe a data!',0+16,"Aten��o")=1
							DO FORM wdir+'Linx\Exclusivos\inputboxdate.scx'
							
							xordem_servico1=v_producao_os_01.ordem_servico	
							
*!*								if !f_vazio(cData)
*!*									*xfiltro_data=cData 
*!*									text to	xinsert2 noshow textmerge	
*!*										INSERT INTO PROP_PRODUCAO_ORDEM_SERVICO
*!*										(PROPRIEDADE,ITEM_PROPRIEDADE,VALOR_PROPRIEDADE,DATA_PARA_TRANSFERENCIA, ORDEM_SERVICO)
*!*										SELECT 
*!*										'00012','1','<<cData>>' ,'<<DTOS(WDATA)>>','<<xordem_servico1>>'
*!*									ENDTEXT
*!*									
*!*									if !f_insert(xinsert2) 
*!*											messagebox("Data n�o foi Inserida !!!!",48,"Aten��o_8!")
*!*											retu .f.
*!*									ENDIF		
*!*								ENDIF 
						ENDIF				
				ENDIF

					* ronald - 28042008 - digita�ao nas propriedades 46 e 12 apenas em inclus�o   
					case upper(xmetodo) == 'VALID' AND UPPER(xnome_obj)=='TX_VALOR_PROPRIEDADE'
						
						SELECT curPropProducaoOrdemServico
						*IF ((curPropProducaoOrdemServico.propriedade='00046' ) OR (curPropProducaoOrdemServico.propriedade='00012' )) 
						** Retirado o bloqueio para alterar a propriedade 00012 - data chk list - a pedido da Leticia, chamado 000226 
						IF (curPropProducaoOrdemServico.propriedade='00046') 	
						
							xalias=alias()
							
							
							IF  thisformset.p_tool_status $ 'IA'
							 
								
								TEXT TO xselProps NOSHOW TEXTMERGE
									select ordem_servico,propriedade,valor_propriedade 
									from PROP_PRODUCAO_ORDEM_SERVICO 
									where ordem_servico='<<ALLTRIM(v_producao_os_01.ordem_servico)>>'
									and propriedade='<<curPropProducaoOrdemServico.propriedade>>'
								ENDTEXT
								
								f_select(xselProps,'curProps',ALIAS())
								
								IF !f_vazio(curProps.valor_propriedade)
									replace ALL valor_propriedade WITH curProps.valor_propriedade FOR propriedade=curProps.propriedade IN curPropProducaoOrdemServico
									
									MESSAGEBOX('Altera��o n�o permitida!',0+48,'Aten��o')
							 	ENDIF 
							ENDIF 
							
							if !f_vazio(xalias)
								sele &xalias 
							endif
		
						ENDIF 


					case upper(xmetodo) == 'USR_SEARCH_BEFORE'
										 	
						xTMPand = ""
						*xmaior = DTOS(thisformset.lx_form1.lx_pageframe1.page9.tx_data_maior_que.value)
						*xmenor = DTOS(thisformset.lx_form1.lx_pageframe1.page9.tx_data_menor_que.value)
						*xTMPcolecao = ALLTRIM(thisformset.lx_form1.lx_pageframe1.page9.cmb_filtro_colecao.value)
						*xTMPgriffe = ALLTRIM(thisformset.lx_form1.lx_pageframe1.page9.cmb_filtro_griffe.value)
						xTMPProg = ALLTRIM(thisformset.lx_form1.lx_pageframe1.page9.cmb_prog_prioridade.value)
						
*!*							IF f_vazio(thisformset.lx_form1.cmb_status_entrada.value)
*!*								IF MESSAGEBOX('Deseja pesquisar todas as Ordens de Servi�os?',4+32)=7
*!*									RETURN .F.
*!*								ENDIF
*!*							ENDIF		
						
						
						IF !f_vazio(thisformset.lx_FORM1.lx_pageframe1.page9.lx_filtro_produtos1.p_where_produto)
							
							if !f_vazio(thisformset.p_pai_filtro_query)
								xTMPand = " AND "
							endif
							
							thisformset.p_pai_filtro_query= thisformset.p_pai_filtro_query+xTMPand+"PRODUCAO_ORDEM_SERVICO.ORDEM_SERVICO IN (SELECT DISTINCT ORDEM_SERVICO FROM PRODUCAO_OS_TAREFAS WHERE PRODUTO IN (SELECT PRODUTO FROM PRODUTOS WHERE "+thisformset.lx_FORM1.lx_pageframe1.page9.lx_filtro_produtos1.p_where_produto+" )) "
						
						ENDIF
						
*!*							IF ( !f_vazio(xTMPProg) OR !f_vazio(xTMPcolecao) OR !f_vazio(xTMPgriffe) ) AND f_vazio(thisformset.lx_form1.cmb_status_entrada.value)
*!*								IF MESSAGEBOX('Deseja pesquisar todas as Ordens de Servi�os?',4+32)=7
*!*									RETURN .F.
*!*								ENDIF
*!*							ENDIF		
						
*!*							IF !f_vazio(xmaior) AND !f_vazio(xmenor)
*!*										
*!*								if !f_vazio(thisformset.p_pai_filtro_query)
*!*									xTMPand = " AND "
*!*								endif
*!*								
*!*								thisformset.p_pai_filtro_query = thisformset.p_pai_filtro_query+xTMPand+"(PRODUCAO_ORDEM_SERVICO.DATA >= '"+xmaior+"' AND PRODUCAO_ORDEM_SERVICO.DATA <= '"+xmenor+"') OR "+"(PRODUCAO_ORDEM_SERVICO.ANM_DATA_INICIO_SEPARACAO >= '"+xmaior+"' AND PRODUCAO_ORDEM_SERVICO.ANM_DATA_INICIO_SEPARACAO <= '"+xmenor+"') "
*!*							
*!*							ENDIF
*!*							
*!*							IF !f_vazio(xTMPcolecao)
*!*								
*!*								if !f_vazio(thisformset.p_pai_filtro_query)
*!*									xTMPand = " AND "
*!*								endif	
*!*								
*!*								thisformset.p_pai_filtro_query= thisformset.p_pai_filtro_query+xTMPand+"PRODUCAO_ORDEM_SERVICO.ORDEM_SERVICO IN (SELECT DISTINCT ORDEM_SERVICO FROM PRODUCAO_OS_TAREFAS WHERE PRODUTO IN (SELECT PRODUTO FROM PRODUTOS WHERE COLECAO = '"+xTMPcolecao+"'))"
*!*							
*!*							ENDIF
*!*							
*!*							IF !f_vazio(xTMPgriffe)
*!*									
*!*								if !f_vazio(thisformset.p_pai_filtro_query)
*!*									xTMPand = " AND "
*!*								endif	
*!*								
*!*								thisformset.p_pai_filtro_query= thisformset.p_pai_filtro_query+xTMPand+"PRODUCAO_ORDEM_SERVICO.ORDEM_SERVICO IN (SELECT DISTINCT ORDEM_SERVICO FROM PRODUCAO_OS_TAREFAS WHERE PRODUTO IN (SELECT PRODUTO FROM PRODUTOS WHERE GRIFFE = '"+xTMPgriffe+"'))"
*!*							
*!*							ENDIF
						
						IF !f_vazio(xTMPProg)
								
							if !f_vazio(thisformset.p_pai_filtro_query)
								xTMPand = " AND "
							endif	
							
							thisformset.p_pai_filtro_query= thisformset.p_pai_filtro_query+xTMPand+"PRODUCAO_ORDEM_SERVICO.ORDEM_PRODUCAO_OS IN (SELECT ORDEM_PRODUCAO FROM PRODUCAO_ORDEM A JOIN WANM_PRODUCAO_PROGRAMA B ON A.PROGRAMACAO = B.PROGRAMACAO WHERE TIPO_PROG_PRIORIDADE ='"+xTMPProg+"')"
						
						ENDIF

					
				case upper(xmetodo) == 'USR_WHEN'
					
					
					xalias=alias()
					 
						IF UPPER(xnome_obj)=='BT_FINALIZA'
						
							****** BUSCA CUSTO DA ENTRADA DA NF DE IMPORTA��O ****
							IF V_PRODUCAO_OS_02_ANTERIOR.setor_producao = '09'
								
								SELE V_PRODUCAO_OS_02_ANTERIOR
								GO TOP
								SCAN
								
									TEXT TO xBuscaCustoImp TEXTMERGE NOSHOW
									
										SELECT DISTINCT CUSTO_EFETIVO 
										FROM VW_MIT_ENTRADAS_RETORNO_BENEFICIAMENTO_OS
										WHERE TAREFA         = ?V_PRODUCAO_OS_02_ANTERIOR.tarefa_anterior   AND 
								      		  PRODUTO        = ?V_PRODUCAO_OS_02_ANTERIOR.produto  AND
								      		  COR_PRODUTO 	 = ?V_PRODUCAO_OS_02_ANTERIOR.cor_produto AND
								      	      ORDEM_PRODUCAO = ?V_PRODUCAO_OS_02_ANTERIOR.ordem_producao
									
									ENDTEXT

									f_select(xBuscaCustoImp,"cCustoEfetivoImp")
	**AND RECCOUNT()=1
									
									IF CUSTO_EFETIVO > 0 AND RECCOUNT()=1
										SELE V_PRODUCAO_OS_02_ANTERIOR
										REPLACE custo_tarefa WITH  cCustoEfetivoImp.CUSTO_EFETIVO
									ELSE	
										MESSAGEBOX("Custo da OS n�o encontrado."+CHR(13)+CHR(13)+;
										           "Se j� fez a entrada da NF de compras,"+CHR(13)+"favor entrar em contato com o suporte."+CHR(13)+CHR(13)+;
										           "Caso n�o,"+CHR(13)+"favor efetuar a entrada da NF de compras e tentar novamente.",64)
										           
										RETURN .F.           
									ENDIF	           
								
								SELE V_PRODUCAO_OS_02_ANTERIOR
								ENDSCAN
							ENDIF
							
					Sele V_PRODUCAO_OS_02_ANTERIOR
					*bloqueia se o setor for do tipo 02 - externo*
					If thisformset.pp_ANM_BLOQ_MOVIMENTAR_OS AND V_PRODUCAO_OS_02_ANTERIOR.setor_producao = '02'
						Messagebox("Favor dar Entrada de Nota Fiscal por Ordem de Servi�o !!!",0+48)
						Return .f.
					Endif
						ENDIF
						
					if !f_vazio(xalias)
						sele &xalias
					endif
					
					
					
					case upper(xmetodo) == 'USR_SEARCH_AFTER'
					
							
							thisformset.p_pai_filtro_query=""
							thisform.lx_pageframe1.page6.Lx_optiongroup1.Value=1
							thisform.lx_pageframe1.page6.Lx_optiongroup1.valid()

							
							thisform.Lx_pageframe1.Page2.Lx_grid_filha1.Refresh()
							thisform.Lx_pageframe1.Page1.Lx_grid_filha1.Refresh()

							*thisformset.lx_form1.lx_pageframe1.page9.tx_data_maior_que.enabled = .F.
							*thisformset.lx_form1.lx_pageframe1.page9.tx_data_menor_que.enabled = .F.
							
							*thisformset.lx_form1.lx_pageframe1.page9.cmb_filtro_colecao.enabled = .F.
							*thisformset.lx_form1.lx_pageframe1.page9.cmb_filtro_griffe.enabled = .F.
							
							thisformset.lx_form1.lx_pageframe1.page9.cmb_prog_prioridade.enabled = .F.
							
							thisformset.lx_FORM1.lx_pageframe1.page5.bt_altera_obs.visible = .T.
							
*!*								Sele v_producao_os_01
*!*								cursorset('buffering',3)
*!*								INDEX ON ORDEM_SERVICO TAG iProg
*!*								Go Top
*!*								
*!*								IF MESSAGEBOX('Deseja Orderna Visualiza��o por prioridade de OS?',+4+32+256)=6
*!*									
*!*									Scan
*!*															
*!*										f_prog_bar("Pequisando Programa��o da OS: "+ALLTRIM(v_producao_os_01.ORDEM_SERVICO),RECNO(),RECCOUNT())
*!*										
*!*										TEXT TO xSelProg TEXTMERGE NOSHOW
*!*											
*!*											SELECT TOP 1 TIPO_PROG_PRIORIDADE 
*!*											FROM PRODUCAO_ORDEM A
*!*											          JOIN WANM_PRODUCAO_PROGRAMA B
*!*											          ON A.PROGRAMACAO = B.PROGRAMACAO
*!*											         WHERE A.ORDEM_PRODUCAO IN
*!*											          ( SELECT DISTINCT ORDEM_PRODUCAO FROM WANM_PRODUCAO_TAREFAS_OS
*!*											           WHERE ORDEM_SERVICO = '<<v_producao_os_01.ORDEM_SERVICO>>')
*!*											ORDER BY TIPO_PROG_PRIORIDADE     
*!*		
*!*										ENDTEXT
*!*										f_select(xSelProg,"CurTmpProg")
*!*										
*!*										Sele v_producao_os_01
*!*										replace PROG_PRIORIDADE with CurTmpProg.TIPO_PROG_PRIORIDADE 	
*!*										
*!*									EndScan
*!*									
*!*									SELE V_PRODUCAO_OS_01
*!*									IF RECCOUNT()>1
*!*										
*!*											INDEX ON DTOS(ANM_DATA_INICIO_SEPARACAO)+PROG_PRIORIDADE TAG iProg	
*!*									ENDIF	
*!*								
*!*								ENDIF	
*!*								Sele v_producao_os_01
*!*								Go Top
*!*		
*!*								f_prog_bar()
							
							
						
					case upper(xmetodo) == 'USR_REFRESH'
					
						
						if type("thisformset.lx_FORM1.lb_status_entrada")<>"U"
							thisformset.lx_FORM1.lb_status_entrada.Alignment   = 0
							thisformset.lx_FORM1.lb_status_entrada.left =660
							thisformset.lx_FORM1.lb_status_entrada.Anchor=0	
							if thisformset.p_tool_status = "I" or thisformset.p_tool_status = "L" 
								thisformset.lx_FORM1.cmb_status_entrada.enabled=.T.
							else	
								thisformset.lx_FORM1.cmb_status_entrada.enabled=.F.
							endif		
							
							thisformset.lx_FORM1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.cmb_separa_almox.enabled=.t.
																	
							if thisformset.p_tool_status $'IA'
								thisformset.lx_form1.lb_status_entrada.visible = .f.
								thisformset.lx_form1.cmb_status_entrada.visible = .f.
								thisformset.lx_form1.bt_salvar.visible = .f.
								
							else
								thisformset.lx_form1.lb_status_entrada.visible = .t.
								thisformset.lx_form1.cmb_status_entrada.visible = .t.
								thisformset.lx_form1.bt_salvar.visible = .t.
							endif	
						
						endif	

						if type("thisformset.lx_FORM1.tx_data_ini_separacao")<>"U"
							
							if	thisformset.p_tool_status='L'
								thisformset.lx_FORM1.tx_data_ini_separacao.enabled=.t.
							else	
								thisformset.lx_FORM1.tx_data_ini_separacao.enabled=.f.								
							endif
							
						endif
					
					
					 	IF thisformset.p_tool_status='A'  
					 		thisformset.lx_Form1.lx_pageframe1.page1.lX_GRID_FILHA1.Col_tx_QTDE_O.Enabled=.f.
					 	ELSE
					 		thisformset.lx_Form1.lx_pageframe1.page1.lX_GRID_FILHA1.Col_tx_QTDE_O.Enabled=.t.
						ENDIF
					 	
					 	
					 			

					case upper(xmetodo) == 'USR_CLEAN_AFTER'
						
						IF type("thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.Bt_inverte_separacao") <> "U"
							thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.Bt_inverte_separacao.visible = .F.
						ENDIF	
						
						IF type("thisformset.lx_FORM1.lx_pageframe1.page5.bt_altera_obs") <> "U"
							thisformset.lx_FORM1.lx_pageframe1.page5.bt_altera_obs.visible = .F.
						ENDIF	

						if type("thisformset.lx_FORM1.tx_data_ini_separacao")<>"U" 
							
							if	thisformset.p_tool_status='L'
								thisformset.lx_FORM1.tx_data_ini_separacao.enabled=.t.
								thisformset.lx_FORM1.tx_data_ini_separacao.refresh()
							else	
								thisformset.lx_FORM1.tx_data_ini_separacao.enabled=.f.	
								thisformset.lx_FORM1.tx_data_ini_separacao.refresh()							
							endif
						
						*thisformset.lx_form1.lx_pageframe1.page9.tx_data_maior_que.value = CTOD('')
						*thisformset.lx_form1.lx_pageframe1.page9.tx_data_menor_que.value = CTOD('')
						*thisformset.lx_form1.lx_pageframe1.page9.tx_data_maior_que.enabled = .T.
						*thisformset.lx_form1.lx_pageframe1.page9.tx_data_menor_que.enabled = .T.
						thisformset.p_pai_filtro_query = ''
						thisformset.lx_FORM1.cmb_FILIAL.value=''
						
						thisformset.lx_form1.lb_status_entrada.visible = .t.
						thisformset.lx_form1.cmb_status_entrada.visible = .t.
						
						*thisformset.lx_form1.lx_pageframe1.page9.cmb_filtro_colecao.value=''
						*thisformset.lx_form1.lx_pageframe1.page9.cmb_filtro_colecao.enabled=.t.
						*thisformset.lx_form1.lx_pageframe1.page9.cmb_filtro_griffe.value=''
						*thisformset.lx_form1.lx_pageframe1.page9.cmb_filtro_griffe.enabled=.t.
						thisformset.lx_form1.lx_pageframe1.page9.cmb_prog_prioridade.enabled = .t.
						thisformset.lx_form1.lx_pageframe1.page9.cmb_prog_prioridade.value=''
							
						endif
 

*!*							thisformset.lx_form1.lx_PAGEFRAME1.page1.Enabled=.t.
*!*							thisformset.lx_form1.lx_PAGEFRAME1.page5.Enabled=.t.
*!*							thisformset.lx_form1.lx_PAGEFRAME1.page6.Enabled=.t.
*!*							thisformset.lx_form1.lx_PAGEFRAME1.page7.Enabled=.t.
*!*							thisformset.lx_form1.lx_PAGEFRAME1.page9.Enabled=.t.
*!*							thisformset.lx_form1.lx_PAGEFRAME1.page10.Enabled=.t.

					case upper(xmetodo) == 'USR_INCLUDE_AFTER'
						
						thisformset.lx_form1.lb_status_entrada.visible = .f.
						thisformset.lx_form1.cmb_status_entrada.visible = .f.	
						thisformset.lx_form1.tx_data_ini_separacao.enabled = .F.
						thisformset.lx_FORM1.lx_pageframe1.page2.tx_codigo_barras.Visible = .F. 
						thisformset.lx_FORM1.lx_pageframe1.page2.lb_codigo_barra.Visible  = .F.
						thisformset.lx_FORM1.lx_pageframe1.page2.LX_GRID_FILHA1.Col_tx_QTDE_A.Lx_grade48_1.Enabled= .T.
						Thisformset.lx_FORM1.cmb_FILIAL.Value = Thisformset.pp_filial_padrao

					case upper(xmetodo) == 'USR_ALTER_BEFORE'	
				
						xalias=alias()

*!*								SELE V_PRODUCAO_OS_01
*!*								IF !F_VAZIO(V_PRODUCAO_OS_01.NF_SAIDA) OR V_PRODUCAO_OS_01.acerto_entrada = .T.
*!*									MESSAGEBOX("Proibido alterar OS com NF Emitida !!!",0+48)
*!*									RETURN .f.	
*!*	*!*									MESSAGEBOX("Proibido alterar OS com notas Emitidas,"+CHR(13)+"somente a aba Propriedades ficar� dispon�vel"+CHR(13)+"para altera��o !!!",0+48)
*!*	*!*									thisformset.lx_form1.lx_PAGEFRAME1.page1.Enabled=.f.
*!*	*!*									thisformset.lx_form1.lx_PAGEFRAME1.page2.Enabled=.f.
*!*	*!*									thisformset.lx_form1.lx_PAGEFRAME1.page3.Enabled=.f.
*!*	*!*									thisformset.lx_form1.lx_PAGEFRAME1.page4.Enabled=.f.
*!*	*!*									thisformset.lx_form1.lx_PAGEFRAME1.page5.Enabled=.f.
*!*	*!*									thisformset.lx_form1.lx_PAGEFRAME1.page6.Enabled=.f.
*!*	*!*									thisformset.lx_form1.lx_PAGEFRAME1.page7.Enabled=.f.
*!*	*!*									thisformset.lx_form1.lx_PAGEFRAME1.page8.Enabled=.f.
*!*	*!*									thisformset.lx_form1.lx_PAGEFRAME1.page9.Enabled=.f.
*!*	*!*									thisformset.lx_form1.lx_PAGEFRAME1.page10.Enabled=.f.
*!*	*!*									thisformset.lx_form1.lx_PAGEFRAME1.page_PROPS.Enabled=.t.
*!*								ENDIF			
											
							IF ALLTRIM(v_producao_os_01.anm_status_almox) == "1-ENVIADO PARA ALMOX"
								messagebox("Voc� N�o tem Permiss�o para Alterar a OS com o Status de Enviado Para Almox, Favor Entrar em contato com o Almoxarifado para a libera��o",48,"Aten��o!!!")
								return .F.
							ENDIF
						
						thisformset.lx_form1.tx_data_ini_separacao.enabled = .F.
						thisformset.lx_form1.lb_status_entrada.visible = .f.
						thisformset.lx_form1.cmb_status_entrada.visible = .f.
						
						xFacAnt = v_producao_os_01_tarefas.custo_previsto
								
						if !f_vazio(xalias)
							sele &xalias
						endif
				
																
				otherwise
				return .t.				
			endcase

	
	endproc


	* Inclui Nova Procedure na Classe da Tela >> Dentro de Activate da Guia Materiais
	
	Procedure AnmBuscaSeparaAlmox 
	
		sele v_producao_os_02_materiais  
		go top	
		scan	
			*f_select("select convert(varchar(25),case when anm_reserva_almox=1 then 'SEPARA' else 'N�O SEPARA' end) as anm_reserva_almox " + ; 
			         "from producao_reserva where material=?v_producao_os_02_materiais.material " + ; 
			         "and cor_material=?v_producao_os_02_materiais.cor_material " + ;
			         "and ordem_producao=?v_producao_os_02_materiais.ordem_producao","curSeparaAlmox",alias())
			f_select("select anm_reserva_almox " + ; 
			         "from producao_reserva where material=?v_producao_os_02_materiais.material " + ; 
			         "and cor_material=?v_producao_os_02_materiais.cor_material " + ;
			         "and ordem_producao=?v_producao_os_02_materiais.ordem_producao","curSeparaAlmox",alias())

			repla anm_reserva_almox with curSeparaAlmox.anm_reserva_almox 
		endscan	

		sele v_producao_os_02_materiais  
		go top	

	Endproc
	* Inclui Nova Procedure na Classe da Tela >> Dentro de Activate da Guia Materiais


ENDDEFINE






**************************************************
*-- Class:        lb_status_entrada (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_status_entrada AS lx_label


	Caption = "Status Entrada"
	Height = 15
	Left = 660
	Top = 30
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	FontBold = .T.
	p_muda_size = .F.
	Name = "lb_status_entrada"
	Visible = .t.
	Anchor = 0
	Alignment=0

	PROCEDURE DblClick	
		
		*If thisformset.p_tool_status="P" and (v_producao_os_01.anm_status_almox <>"2-RECEBIDO ALMOX" or f_vazio(v_producao_os_01.anm_status_almox))  
	If thisformset.p_tool_status="P"
		sele v_producao_os_01
		xOldStatusAlmox = v_producao_os_01.anm_status_almox
		
		If v_producao_os_01.anm_status_almox="1-ENVIADO PARA ALMOX" 
			
			text to xselUser noshow textmerge	
				SELECT * FROM PROPRIEDADE_VALIDA 
				WHERE PROPRIEDADE='00058' 
				AND LTRIM(RTRIM(VALOR_PROPRIEDADE))= '<<WUSUARIO>>'
			endtext	
		
			f_select(xselUser,"curUserFimOs",alias())
			
			if f_vazio(curUserFimOs.valor_propriedade)
				messagebox("Voc� N�o tem Permiss�o para Alterar o Status da OS enquanto n�o for Finalizada",48,"Aten��o!!!")
				thisformset.lx_form1.cmb_status_entrada.enabled=.F.
				retu .f.
				o_toolbar.Botao_refresh.Click()
			else
				if messagebox("Deseja Alterar o Status da Ordem de Servi�o?",4+32+256,"Aten��o!")=6	
					thisformset.lx_form1.cmb_status_entrada.enabled=.T.
				endif
			endif				
		Else
				if messagebox("Deseja Alterar o Status da Ordem de Servi�o?",4+32+256,"Aten��o!")=6	
					thisformset.lx_form1.cmb_status_entrada.enabled=.T.
					thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.enabled = .T.
					thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Refresh()
				endif		
		Endif
	Endif

	ENDPROC 

ENDDEFINE
*
*-- EndDefine: lb_status_entrada 
**************************************************



**************************************************
*-- Class:        cmb_status_entrada (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_status_entrada AS lx_combobox


	RowSource = ""
	ControlSource = ""
	Height = 22
	Left = 625
	TabIndex = 1
	Top = 45
	Width = 147
	ZOrderSet = 5
	Name = "cmb_status_entrada"
	Visible = .t.
	Enabled = .t.
	Anchor = 0

	PROCEDURE Valid	
	
	IF THISFORMSET.P_TOOL_STATUS="P"

		If v_producao_os_01.anm_status_almox <> "1-ENVIADO PARA ALMOX" 
			
			if messagebox("Deseja Finalizar esta Ordem de Servi�o?",4+32+256,"Aten��o!")=6	

				xordem_servico=v_producao_os_01.ordem_servico
				*ORDEM_SERVICO,ANM_STATUS_ALMOX,DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP
				text to	xinsert1 noshow textmerge	

					UPDATE PRODUCAO_ORDEM_SERVICO SET ANM_STATUS_ALMOX='<<v_producao_os_01.anm_status_almox>>'	
					WHERE ordem_servico='<<xordem_servico>>' 
				
					INSERT INTO ANM_STATUS_OS_MOV
					(ORDEM_SERVICO,ANM_STATUS_ALMOX,
					DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP,CHAVE_ID)
					SELECT 
					'<<xordem_servico>>',
					'<<v_producao_os_01.ANM_STATUS_ALMOX>>','<<DTOS(WDATA)>>',
					'<<WUSUARIO>>','<<SYSTEM.NetUserName>>','<<SYSTEM.NetComputerName>>',(SELECT GETDATE()),
					(select max(id_registro) from ANM_STATUS_OS_MOV where ordem_servico = '<<xordem_servico>>' and left(ANM_STATUS_ALMOX,1)='1' )
					--where '<<xordem_servico>>'+'<<v_producao_os_01.ANM_STATUS_ALMOX>>' 
					--not in 
					--(select  ORDEM_SERVICO+anm_status_ALMOX
					-- from ANM_STATUS_OS_MOV)	

				endtext


				if !f_insert(xinsert1) 
					messagebox("N�o foi poss�vel Alterar o Status da Ordem de Servi�o",48,"Aten��o_8!")
					replace v_producao_os_01.anm_status_almox with xOldStatusAlmox
					thisformset.lx_form1.cmb_status_entrada.enabled=.F.
					thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.enabled = .f.
					thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Refresh()
					retu .f.
				endif
				
				thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.enabled = .F.
				thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Refresh()
				o_toolbar.Botao_refresh.Click()
 

			endif
						
		
		Else
		
			
			if messagebox("Deseja Alterar o Status desta OS para "+allt(v_producao_os_01.anm_status_almox)+" ?",4+32+256,"Aten��o!")=6
					
					
					** #1 - Julio Cesar - 11/05/2016 - CONTROLE P/ N�O ENVIAR MAT PARA ALMOX COM CUSTO IGUAL 0
					** Incio **
					TEXT TO xCustoZero TEXTMERGE NOSHOW
					
						SELECT A.MATERIAL,A.COR_MATERIAL 
						FROM PRODUCAO_RESERVA A
							JOIN WANM_MATERIAIS_CUSTOS B ON A.MATERIAL = B.MATERIAL AND A.COR_MATERIAL = B.COR_MATERIAL
						WHERE A.ORDEM_PRODUCAO = '<<v_producao_os_01_tarefas.ordem_producao>>'  
						  AND ANM_RESERVA_ALMOX = 1 AND B.CUSTO_A_VISTA = 0 AND A.RESERVA > 0
						
					ENDTEXT
					f_select(xCustoZero,"xCusCustoZero")
					
					IF RECCOUNT()>0
						
						GO Top
						xMsgcusto = 'Existem materiais com custo igual a zero:'+CHR(13)+CHR(13)
						SCAN
							xMsgcusto = xMsgcusto + ALLTRIM(xCusCustoZero.MATERIAL) + ' - ' +  ALLTRIM(xCusCustoZero.COR_MATERIAL) + CHR(13)
						ENDSCAN

						MESSAGEBOX(xMsgcusto+CHR(13)+CHR(13)+"CTRL+C Executado",64)
						_CLIPTEXT = xMsgcusto
						
						SELECT v_producao_os_01
						replace v_producao_os_01.anm_status_almox with xOldStatusAlmox
						thisformset.lx_form1.cmb_status_entrada.enabled=.F.
						thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.enabled = .f.
						thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Refresh()
						retu .f.

					ENDIF
					** Fim #1 **	
						
					
					sele curpropproducaoordemservico			
					LOCATE FOR propriedade = '00052'

						f_select("select MATRIZ from Filiais Where Filial = ?curpropproducaoordemservico.valor_propriedade","curFilMatCont")
						IF curFilMatCont.MATRIZ <> 'FARM MATRIZ'
						
							**** Verificando Filial de corte ****
							TEXT TO xVerifCorte TEXTMERGE NOSHOW

								SELECT TOP 1 1 AS TEM_CORTE,G.FILIAL 
									FROM PRODUCAO_TAREFAS A
									JOIN PRODUCAO_ORDEM (NOLOCK) C ON A.ORDEM_PRODUCAO = C.ORDEM_PRODUCAO
									JOIN PRODUTOS (NOLOCK) D ON C.PRODUTO = D.PRODUTO
									JOIN FX_ANM_PARAMETROS_REDE_LOJAS('ANM_FASE_CORTE_OS') E 
									ON D.REDE_LOJAS = E.REDE_LOJAS AND A.FASE_PRODUCAO = E.VALOR_ATUAL
									JOIN FX_ANM_PARAMETROS_REDE_LOJAS('ANM_FILIAL_CORTE_POR_REDE') F
									ON D.REDE_LOJAS = F.REDE_LOJAS
									JOIN FILIAIS (NOLOCK) G ON F.VALOR_ATUAL = G.COD_FILIAL
									JOIN PRODUCAO_OS_TAREFAS (NOLOCK) H ON A.TAREFA = H.TAREFA AND C.ORDEM_PRODUCAO = H.ORDEM_PRODUCAO
									JOIN PRODUCAO_ORDEM_SERVICO (NOLOCK) I ON H.ORDEM_SERVICO = I.ORDEM_SERVICO 
									JOIN PRODUCAO_SETOR (NOLOCK) B 
									ON I.FASE_PRODUCAO = B.FASE_PRODUCAO AND I.SETOR_PRODUCAO = B.SETOR_PRODUCAO AND B.DESC_SETOR_PRODUCAO = 'INTERNO' 
								WHERE A.ORDEM_PRODUCAO = '<<v_producao_os_01_tarefas.ordem_producao>>'
								AND I.FILIAL <> G.FILIAL
								GROUP BY G.FILIAL 

							ENDTEXT
							f_select(xVerifCorte,"xCurVerifCorte")
							IF !f_vazio(xCurVerifCorte.tem_corte)
								IF MESSAGEBOX('OP com fase de corte interno,'+CHR(13)+'Deseja alterar a filial da OS para: '+;
								           ALLTRIM(xCurVerifCorte.filial)+' ?',4+32)=6
								   if !f_update("Update PRODUCAO_ORDEM_SERVICO Set FILIAL = ?xCurVerifCorte.filial WHERE ORDEM_SERVICO = ?v_producao_os_01.ordem_servico")
								   		MESSAGEBOX("N�o foi poss�vel alterar a filial da OS.",64)
								   		replace v_producao_os_01.anm_status_almox with xOldStatusAlmox
										thisformset.lx_form1.cmb_status_entrada.enabled=.F.
										thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.enabled = .f.
										thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Refresh()
										retu .f.
								   endif
								   replace v_producao_os_01.filial WITH xCurVerifCorte.filial
								   o_toolbar.Botao_refresh.Click()
								ELSE
									replace v_producao_os_01.anm_status_almox with xOldStatusAlmox
									thisformset.lx_form1.cmb_status_entrada.enabled=.F.
									thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.enabled = .f.
									thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Refresh()
									retu .f.
								ENDIF	        
							ENDIF	
							USE IN "xCurVerifCorte"
							RELEASE xVerifCorte
						ENDIF
			
							

				**** Verificando se Filial da OS � igual a filial do ultimo consumo ****
				TEXT TO xVerifFilialOS TEXTMERGE NOSHOW

					SELECT FILIAL FROM
						(SELECT TOP 1 A.FILIAL 
						FROM ESTOQUE_SAI_MAT A
						JOIN ESTOQUE_SAI1_MAT B
						ON A.REQ_MATERIAL = B.REQ_MATERIAL AND A.FILIAL = B.FILIAL
						WHERE ORDEM_PRODUCAO = '<<v_producao_os_01_tarefas.ordem_producao>>'
						ORDER BY EMISSAO DESC ) A
					WHERE  A.FILIAL <> '<<v_producao_os_01.filial>>'

				ENDTEXT
				f_select(xVerifFilialOS,"xCurVerifFilialOS")
				IF !f_vazio(xCurVerifFilialOS.FILIAL)
					
					xRespConsumo = MESSAGEBOX('J� existe um consumo na filial: '+ALLTRIM(xCurVerifFilialOS.FILIAL)+CHR(13)+;
					                          'Deseja corrigir a filial da OS ?',3+32)
					IF xRespConsumo=6
					   if !f_update("Update PRODUCAO_ORDEM_SERVICO Set FILIAL = ?xCurVerifFilialOS.FILIAL WHERE ORDEM_SERVICO = ?v_producao_os_01.ordem_servico")
					   		MESSAGEBOX("N�o foi poss�vel alterar a filial da OS.",64)
					   		replace v_producao_os_01.anm_status_almox with xOldStatusAlmox
							thisformset.lx_form1.cmb_status_entrada.enabled=.F.
							thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.enabled = .f.
							thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Refresh()
							retu .f.
					   endif
					   replace v_producao_os_01.filial WITH xCurVerifFilialOS.filial
					   o_toolbar.Botao_refresh.Click()
					ELSE
						IF xRespConsumo=2
							replace v_producao_os_01.anm_status_almox with xOldStatusAlmox
							thisformset.lx_form1.cmb_status_entrada.enabled=.F.
							thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.enabled = .f.
							thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Refresh()
							retu .f.
						ENDIF	
					ENDIF	        
				ENDIF	

				USE IN xCurVerifFilialOS
				RELEASE xVerifFilialOS
				**** Fim da verifica��es ****
				
				xordem_servico=v_producao_os_01.ordem_servico
				
				TEXT TO xSelReserva TEXTMERGE NOSHOW
				
					SELECT COUNT(*) as QTDE FROM PRODUCAO_RESERVA (NOLOCK) A
					JOIN (SELECT DISTINCT ORDEM_PRODUCAO FROM WANM_PRODUCAO_TAREFAS_OS (NOLOCK)
							      WHERE ORDEM_SERVICO = '<<xordem_servico>>' ) B
							ON A.ORDEM_PRODUCAO= B.ORDEM_PRODUCAO  
					WHERE RESERVA > 0 AND A.ANM_RESERVA_ALMOX = 1
				
				ENDTEXT
				
				f_select(xSelReserva,"xVerifReserva")
				
				IF xVerifReserva.QTDE = 0
					MESSAGEBOX("ATEN��O!"+CHR(13)+"Imposs�vel Enviar OS, N�o existe material a ser consumido.",64)
					replace v_producao_os_01.anm_status_almox with xOldStatusAlmox
					thisformset.lx_form1.cmb_status_entrada.enabled=.F.
					thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.enabled = .f.
					thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Refresh()
					RETURN .F.
				ENDIF
				
				
				*ORDEM_SERVICO,ANM_STATUS_ALMOX,DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP
				text to	xinsert1 noshow textmerge	

						UPDATE PRODUCAO_ORDEM_SERVICO SET ANM_STATUS_ALMOX='<<v_producao_os_01.anm_status_almox>>'
						WHERE ordem_servico='<<xordem_servico>>' 

						UPDATE PRODUCAO_ORDEM_SERVICO SET ANM_DATA_INICIO_SEPARACAO=
							case 
						           when convert(int,left(convert(varchar(13),getdate(),108),2)) > 15  OR
										(SELECT COUNT(*) WHERE
											DBO.LX_DATA_REAL('000994',convert(datetime,convert(varchar(13),getdate(),112)))=	
											                          convert(datetime,convert(varchar(13),getdate(),112)) ) = 0
						           then dbo.lx_dias_uteis('000994',convert(datetime,convert(varchar(13),getdate(),112)),2)
						           else dbo.lx_dias_uteis('000994',convert(datetime,convert(varchar(13),getdate(),112)),1)
						    end
										
						WHERE ordem_servico='<<xordem_servico>>' 

					INSERT INTO ANM_STATUS_OS_MOV
					(ORDEM_SERVICO,ANM_STATUS_ALMOX,
					DATA_ALTERACAO,DATA_SEPARA,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP)
					SELECT 
					'<<xordem_servico>>',
					'<<v_producao_os_01.ANM_STATUS_ALMOX>>','<<DTOS(WDATA)>>',
					(select anm_data_inicio_separacao from producao_ordem_servico where ordem_servico = '<<xordem_servico>>'),
					'<<WUSUARIO>>','<<SYSTEM.NetUserName>>','<<SYSTEM.NetComputerName>>',(SELECT GETDATE())
					--where '<<xordem_servico>>'+'<<v_producao_os_01.ANM_STATUS_ALMOX>>' 
					--not in 
					--(select  ORDEM_SERVICO+anm_status_ALMOX
					-- from ANM_STATUS_OS_MOV)	

				endtext	
				
				
				if !f_insert(xinsert1) 
					messagebox("N�o foi poss�vel Alterar o Status da Ordem de Servi�o",48,"Aten��o_8!")
					replace v_producao_os_01.anm_status_almox with xOldStatusAlmox
					thisformset.lx_form1.cmb_status_entrada.enabled=.F.
					thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.enabled = .f.
					thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Refresh()
					retu .f.
				endif
				
				thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.enabled = .F.
				thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Refresh()
				o_toolbar.Botao_refresh.Click()
				
				f_select("select ANM_DATA_INICIO_SEPARACAO from PRODUCAO_ORDEM_SERVICO where ordem_servico=?xordem_servico ","curDataIciAlmox",alias())
				
				thisformset.lx_form1.tx_data_ini_separacao.value=curDataIciAlmox.ANM_DATA_INICIO_SEPARACAO 
							
			endif	
	
		Endif	
	
	ENDIF 
	
	ENDPROC 
	
	



ENDDEFINE
*
*-- EndDefine: cmb_status_entrada
**************************************************


**************************************************
*-- Class:        tx_data_ini_separacao (c:\temp\tx_data_ini_separacao.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_data_ini_separacao AS lx_textbox_base


	ControlSource = ""
	Height = 22
	Left = 160
	TabIndex = 11
	Top = 153
	Width = 65
	ZOrderSet = 8
	Name = "tx_data_ini_separacao"
	Enabled=.T.
	Visible=.T.

ENDDEFINE
*
*-- EndDefine: tx_data_ini_separacao
**************************************************


**************************************************
*-- Class:        tx_data_ini_separacao (c:\temp\tx_data_ini_separacao.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_data_menor_que AS lx_textbox_base


	ControlSource = ""
	Height = 22
	Left = 250
	TabIndex = 11
	Top = 153
	Width = 65
	ZOrderSet = 8
	Name = "tx_data_menor_que"
	value = CTOD('')
	Enabled=.T.
	Visible=.T.

ENDDEFINE
*
*-- EndDefine: tx_data_ini_separacao
**************************************************

**************************************************
*-- Class:        tx_data_ini_separacao (c:\temp\tx_data_ini_separacao.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_data_maior_que AS lx_textbox_base


	ControlSource = ""
	Height = 22
	Left = 160
	TabIndex = 11
	Top = 153
	Width = 65
	ZOrderSet = 8
	Name = "tx_data_maior_que"
	value = CTOD('')
	Enabled=.T.
	Visible=.T.

ENDDEFINE
*
*-- EndDefine: tx_data_ini_separacao
**************************************************

**************************************************
*-- Class:        lb_data_ini_separacao (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_filtro_a AS lx_label


	Caption = "a"
	Height = 15
	Left = 232
	Top = 155
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filtro_a"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_data_ini_separacao 
**************************************************

**************************************************
*-- Class:        lb_data_ini_separacao (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_filtro_de AS lx_label


	Caption = "De"
	Height = 15
	Left = 142
	Top = 155
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filtro_de"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_data_ini_separacao 
**************************************************

**************************************************
*-- Class:        lb_data_ini_separacao (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_filtro_relatorio AS lx_label


	Caption = "Filtro por data"
	Height = 15
	Left = 160
	Top = 135
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filtro_relatorio"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_data_ini_separacao 
**************************************************

**************************************************
*-- Class:        lb_data_ini_separacao (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_data_ini_separacao AS lx_label


	Caption = "Data In�cio Separa��o Almox"
	Height = 15
	Left = 20
	Top = 155
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_data_ini_separacao"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_data_ini_separacao 
**************************************************


**************************************************
*-- Class:        lb_filto_colecao (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_filtro_colecao AS lx_label


	Caption = "Cole��o"
	Height = 15
	Left = 130
	Top = 105
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filtro_colecao"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_filtro_colecao
**************************************************

**************************************************
*-- Class:        cmb_filtro_colecao (c:\temp\cmb_filtro_colecao.vcx)
*-- ParentClass:  lx_textbox_valida (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   05/18/09 01:02:02 PM
*
DEFINE CLASS cmb_filtro_colecao AS lx_combobox

	RowSource = "xcolecao.colecao"
	ControlSource = ""
	Height = 22
	Left = 180
	Top = 100
	Width = 140
	TabIndex = 1
	ZOrderSet = 5
	Name = "cmb_filtro_colecao"
	Visible = .T.
	Enabled = .T.

ENDDEFINE
*
*-- EndDefine: cmb_filtro_colecao
**************************************************


**************************************************
*-- Class:        lb_filtro_griffe(p:\tmpsid\entradas_rbx\lb_filtro_griffe.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_filtro_griffe AS lx_label


	Caption = "Griffe"
	Height = 15
	Left = 350
	Top = 105
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filtro_griffe"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_filtro_griffe
**************************************************

**************************************************
*-- Class:        cmb_filtro_griffe(c:\temp\cmb_filtro_griffe.vcx)
*-- ParentClass:  lx_textbox_valida (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   05/18/09 01:02:02 PM
*
DEFINE CLASS cmb_filtro_griffe AS lx_combobox

	RowSource = "xgriffe.griffe"
	ControlSource = ""
	Height = 22
	Left = 390
	Top = 100
	Width = 140
	TabIndex = 1
	ZOrderSet = 5
	Name = "cmb_filtro_griffe"
	Visible = .T.
	Enabled = .T.

ENDDEFINE
*
*-- EndDefine: lb_filtro_griffe
**************************************************


**************************************************
*-- Class:        cmb_separa_almox (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_separa_almox AS lx_combobox


	RowSource = ""
	ControlSource = ""
	Height = 22
	Left = 1
	TabIndex = 1
	Top = 1
	Width = 147
	ZOrderSet = 5
	Name = "cmb_separa_almox"
	Visible = .t.
	Enabled = .T.
	Anchor = 0
	BoundColumn=2


	PROCEDURE VALID 	
		
		dodefault() 
		text to	xupdt noshow textmerge	
			update producao_reserva set anm_reserva_almox=?v_producao_os_02_materiais.anm_reserva_almox 
			where ordem_producao=?v_producao_os_02_materiais.ordem_producao 
			and material=?v_producao_os_02_materiais.material   
			and cor_material=?v_producao_os_02_materiais.cor_material 			
		endtext	 
		
		f_update(xupdt)
		
	ENDPROC



ENDDEFINE
*
*-- EndDefine: cmb_status_entrada
**************************************************


**************************************************
*-- Class:        ck_separa_almox (c:\temp\est_renato\ck_separa_almox.vcx)
*-- ParentClass:  lx_checkbox (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   09/01/11 02:19:13 PM
*
DEFINE CLASS ck_separa_almox AS lx_checkbox


	Top = 78
	Left = 664
	Alignment = 0
	ControlSource = "V_PRODUCAO_OS_01.RECURSO_PROPRIO"
	TabIndex = 14
	ZOrderSet = 20
	Name = "ck_RECURSO_PROPRIO"

	PROCEDURE DBLCLICK	
		
		this.Enabled=.t. 
		MESSAGEBOX(v_producao_os_02_materiais.anm_reserva_almox )
		
	ENDPROC	


ENDDEFINE
*
*-- EndDefine: ck_separa_almox
**************************************************


**************************************************
*-- Class:        lb_custo_fabrica (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_custo_fabrica AS lx_label


	Caption = "Custo Fabrica"
	Height = 15
	Left = 250
	Top = 155
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_custo_fabrica"
	Visible = .F.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_custo_fabrica 
**************************************************



**************************************************
*-- Class:        tx_data_ini_separacao (c:\temp\tx_data_ini_separacao.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_custo_fabrica AS lx_textbox_base


	ControlSource = ""
	Height = 22
	Left = 320
	TabIndex = 11
	Top = 153
	Width = 65
	ZOrderSet = 8
	Name = "tx_custo_fabrica"
	Enabled=.T.
	Visible=.F.
	value = 0.00

ENDDEFINE
*
*-- EndDefine: tx_data_ini_separacao
**************************************************

**************************************************
*-- Class:        tx_codigo_barras(c:\temp\tx_codigo_barras.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_codigo_barras AS lx_textbox_base


	ControlSource = ""
	Height = 22
	Left = 257
	TabIndex = 11
	Top = 61
	Width = 250
	ZOrderSet = 8
	Name = "tx_codigo_barras"
	Enabled=.T.
	Visible=.F.


ENDDEFINE
*
*-- EndDefine: tx_codigo_barras
**************************************************

**************************************************
*-- Class:        lb_codigo_barra (p:\tmpsid\entradas_rbx\lb_codigo_barra .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_codigo_barra AS lx_label


	Caption = "Cod. Barra"
	Height = 15
	Left = 197
	Top = 63
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_codigo_barra "
	Visible = .F.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_codigo_barra 
**************************************************

**************************************************
*-- Class:        cmb_prog_prioridade (c:\temp\cmb_prog_prioridade .vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS cmb_prog_prioridade AS lx_combobox

	RowSource = "xprogPrioridade.PROG_PRIORIDADE"
	ControlSource = ""
	Height = 22
	Left = 224
	TabIndex = 11
	Top = 287
	Width = 150
	ZOrderSet = 8
	Name = "cmb_prog_prioridade"
	value = ''
	Enabled=.T.
	Visible=.T.

ENDDEFINE
*
*-- EndDefine: cmb_prog_prioridade 
**************************************************

**************************************************
*-- Class:        lb_filtro_tipoProg (p:\tmpsid\entradas_rbx\lb_filtro_tipoProg.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_filtro_tipoProg AS lx_label


	Caption = "Programa��o"
	Height = 15
	Left = 150
	Top = 290
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filtro_tipoProg"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_filtro_tipoProg 
**************************************************
**************************************************
*-- Class:        bt_inverte_separacao (c:\linx desenv\classes lucas\bt_inverte_separacao.vcx)
*-- ParentClass:  botao (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   06/05/15 01:54:07 PM
*!*	*
DEFINE CLASS bt_inverte_separacao AS botao


	Top = 5
	Left = 116
	Height = 27
	Width = 104
	Caption = "Inverte Separa��o"
	Name = "bt_inverte_separacao"
	Visible = .T.
	Enabled = .T.
	
	PROCEDURE Click

			IF F_VAZIO(V_PRODUCAO_OS_02_MATERIAIS.MATERIAL)
					MESSAGEBOX("SEM MATERIAL NA TELA",0+64)
					RETURN .f.
			ENDIF
				IF thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Enabled=.t.

					SELE V_PRODUCAO_OS_02_MATERIAIS
						GO TOP
						SCAN
							IF v_producao_os_02_materiais.anm_reserva_almox=1
								replace v_producao_os_02_materiais.anm_reserva_almox WITH 2
							ELSE
								replace v_producao_os_02_materiais.anm_reserva_almox WITH 1
							ENDIF
							SELE V_PRODUCAO_OS_02_MATERIAIS
						ENDSCAN
					SELE V_PRODUCAO_OS_02_MATERIAIS
				 ELSE
				 	RETURN .f.
				ENDIF
				
	ENDPROC


ENDDEFINE
*!*	*
*-- EndDefine: bt_inverte_separacao
**************************************************
**************************************************
*-- Class:        bt_altera_obs(c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/08/10 01:37:14 PM
*
DEFINE CLASS bt_altera_obs AS botao


	Top = 155
	Left = 35
	Height = 18
	Width = 90
	FontBold = .T.
	Caption = "Alterar"
	TabIndex = 40
	Name = "bt_altera_obs"
	Visible = .F.


	PROCEDURE Click

		
		IF thisformset.lx_FORM1.lx_pageframe1.page5.bt_altera_obs.caption == "Alterar"
				with thisformset.lx_FORM1.lx_pageframe1.page5
					.bt_altera_obs.caption = "Salvar"
				    .Ed_OBSERVACAO.ReadOnly= .F.
				endwith    
		ELSE 		
				
				f_insert("UPDATE PRODUCAO_ORDEM_SERVICO SET OBSERVACAO =?V_PRODUCAO_OS_01.OBSERVACAO WHERE ORDEM_SERVICO =?V_PRODUCAO_OS_01.ORDEM_SERVICO")
				MESSAGEBOX("Alterado com Sucesso",0+64)
				
				with thisformset.lx_FORM1.lx_pageframe1.page5
					.bt_altera_obs.caption = "Alterar"
				    .Ed_OBSERVACAO.ReadOnly= .T.
				endwith
		ENDIF
				
					
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_altera_obs 
**************************************************

**************************************************
*-- Class:        botao_salvar (c:\pastas\work\classes_julio\botao_salvar.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/24/15 01:52:13 PM
*
DEFINE CLASS bt_salvar AS commandbutton


	Top = 23
	Left = 750
	Height = 22
	Width = 23
	Visible= .T.
	Picture = ("salvar.jpg")
	Caption = "Salvar"
	Style = 0
	ToolTipText = [Salvar]
	PicturePosition = 14
	ZOrderSet = 46
	Name = "bt_salvar"


	PROCEDURE Click
		if	thisformset.p_tool_status='P'
			thisformset.lx_form1.cmb_status_entrada.ENABLED = .f.
			thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.enabled = .f.
			thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Refresh()
		endif
	ENDPROC


ENDDEFINE
*
*-- EndDefine: botao_salvar
**************************************************