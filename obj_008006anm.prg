* Cria��o *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  26/02/2009                                                                                               *
* HOR�RIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: inclui checkbox para matar saldo nas programacoes - por produto ou total			                    *
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
		*	USR_ITEN_DELETE_BEFORE -> Return .f. Para o Metodo 		=> ANTES DE EXCLUIR ITEN NA TABELA FILHA '+'
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
		PUBLIC xDataLimiteBancoProd as Date ,xDataLimiteBancoMost as DATE()
			do case

 
				case upper(xmetodo) == 'USR_INIT' 
				
					xalias=alias()
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Vers�o: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
					
					** INICIO ** Instancia da Classe exclusiva Grupo Soma ***
					Public o_gs As Object
					o_gs = Newobject("obj_GS_classes","linx\exclusivo\obj_GS_classes.prg")
					** FIM ** Instancia da Classe exclusiva Grupo Soma ***
					
					PUBLIC xValorTotOTBinit,xValorTotOTBsave,xMes,xAno,xQuinzena,xQtde_calc_mrp, xErroImport, xImport
					xMes=''
					XAno=''
					xQuinzena=''
					xImport=0
					xErroImport=0
					*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_programa_00  
					sele v_producao_programa_00   
					xalias_pai=alias()

	  				oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("ANM_ZERAR_SALDOS", "L",.T., "Saldos Zerados", "PRODUCAO_PROGRAMA.ANM_ZERAR_SALDOS")				
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 

					* Inclus�o dos bot�es - Projeto - Importar Programa��o *
					* Lucas Miranda - 25/10/2017
					Thisformset.lx_form1.AddObject("btn_importa_prog","btn_importa_prog")
					Thisformset.lx_form1.AddObject("btn_ajuda","btn_ajuda")
					
					*Inicio Inclusao Campos Novos de Produtos no Cursor Filha -- v_producao_programa_00_prod  
					sele v_producao_programa_00_prod   
					xalias_filha=alias()

	  				oCur = getcursoradapter(xalias_filha)
					oCur.addbufferfield("ANM_MATAR_SALDO", "L",.T., "Matar Saldo", "PRODUCAO_PROG_PROD.ANM_MATAR_SALDO")	
					oCur.addbufferfield("ANM_OP_LIBERADA", "L",.T., "Bloqueia", "PRODUCAO_PROG_PROD.ANM_OP_LIBERADA")		
					oCur.addbufferfield("0 as ITEM_ALTERADO", "L",.T., "Item Alterado", "0 as ITEM_ALTERADO")	
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Filha 

					WITH Thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1
		                        .AddColumn(1)
		                        .Column1.Name='col_op_liberada'
		                 WITH .col_op_liberada
                            .RemoveObject("text1") 
				            .Header1.Name='h_check_libera'
				            .h_check_libera.Caption='Bloqueia'
			                .AddObject('ck_Liberar_op','CheckBox')
				            .Sparse= .F.
				            .CurrentControl = 'ck_Liberar_op'
				            .ck_Liberar_op.Caption=""
				            .ck_Liberar_op.Visible = .T.
                            .Width=60
                            .BackColor = 15399423
                            .ck_Liberar_op.DisabledBackColor= 15399423
                            .ck_Liberar_op.BackColor = 15399423
                            .h_check_libera.FontName = "Tahoma"
                            .h_check_libera.FontSize = 8
                            .h_check_libera.Alignment= 2
				            .FontName = "Tahoma"
				            .FontSize = 8
				            .ck_Liberar_op.value = 1
                            .ControlSource="v_producao_programa_00_prod.anm_op_liberada"
		                ENDWITH	
                    ENDWITH	
				
					with thisform
						.addobject("ck_matar_saldo_total","ck_matar_saldo_total")
						.lx_PAGEFRAME1.page2.addobject("ck_matar_saldo_produto","ck_matar_saldo_produto")		
						
					endwith
					
					WITH Thisformset.lX_FORM1.lx_PAGEFRAME1
						.page2.addobject("bloqueia","bloqueia")	
						.page2.addobject("desbloqueia","desbloqueia")

					ENDWITH

					*Inicio Inclusao Campos Novos de Produtos no Cursor Filha-- curfiliais
					sele curfiliais
					xalias_pai=alias()

	  				oCur = getcursoradapter(xalias_pai)
	  				oCur.addbufferfield("FILIAIS.CTRL_PRODUCAO_PRODUTO", "L",.T., "CTRL_PRODUCAO_PRODUTO", "FILIAIS.CTRL_PRODUCAO_PRODUTO")
					oCur.addbufferfield("CADASTRO_CLI_FOR.INATIVO", "L",.T., "CADASTRO_CLI_FOR.INATIVO", "CADASTRO_CLI_FOR.INATIVO")
					oCur.confirmstructurechanges()
					**-Fim Inclusao Campos Novos de Produtos no Cursor Filha
					
					* Inclui Nova Procedure na Classe da Tela >> Dentro de Activate da Guia Materiais
			 		Bindevent(thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1.col_op_liberada.CK_LIBERAR_OP, "click", This, "COL_OP_LIBERADA", 1)					
					

					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
										
					Thisformset.L_Limpa()
				
				case upper(xmetodo) == 'USR_INCLUDE_AFTER'
					xalias=alias()
						
						IF USED("curTipoStatus")
							USE IN curTipoStatus
						Endif	
						
						text to xSelTipo noshow textmerge
							SELECT CAST(LTRIM(RTRIM(LEFT(A.TIPO_PROGRAMACAO,2))) AS INT) AS TIPO_PROGRAMACAO FROM 
							(SELECT '1 - EM ESTUDO' AS TIPO_PROGRAMACAO
							UNION ALL
							SELECT '2 - CONFIRMADO' AS TIPO_PROGRAMACAO
							UNION ALL
							SELECT '3 - TESTE' AS TIPO_PROGRAMACAO
							UNION ALL
							SELECT '4 - ENCERRADO' AS TIPO_PROGRAMACAO
							) A 
							JOIN (SELECT DBO.FX_ANM_PARAMETRO_USER('GS_STATUS_PROG_TIPO') AS TIPO_PROGRAMACAO) AS PARAMETRO_TIPO 
							ON LTRIM(RTRIM(LEFT(A.TIPO_PROGRAMACAO,2))) = PARAMETRO_TIPO.TIPO_PROGRAMACAO 
						endtext
						f_select(xSelTipo, "curTipoStatus", alias())
						
						If RECCOUNT("curTipoStatus") > 0
							Sele v_producao_programa_00
							Replace v_producao_programa_00.tipo_programacao WITH curTipoStatus.tipo_programacao
							Thisformset.LX_FORM1.Lx_combobox1.Refresh()
						ENDIF
						
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				
				case upper(xmetodo) == 'USR_ITEN_DELETE_BEFORE'
					
					xalias=alias()
					
						IF !v_producao_programa_00_prod.anm_op_liberada
							MESSAGEBOX("N�o � permitido excluir produto com pedido liberado.",64," ALERTA")
							RETURN .f.
						ENDIF	
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
				
				
				case upper(xmetodo) == 'USR_ITEN_INCLUDE_BEFORE'
				
					Sele CURPROPPRODUCAOPROGRAMA
					Locate For PROPRIEDADE = '00038'
					If !Found() Or F_VAZIO(VALOR_PROPRIEDADE)
						Messagebox("Favor selecionar o tipo da programa��o.",16)
						Return .F.
					Endif
				
				case upper(xmetodo) == 'USR_ITEN_INCLUDE_AFTER'
		
					IF !v_producao_programa_00_prod.ANM_OP_LIBERADA	
						replace ANM_OP_LIBERADA WITH .T. IN v_producao_programa_00_prod
					endif

				case upper(xmetodo) == 'USR_WHEN' 
					 
					xalias=alias()
					
						IF upper(xnome_obj) = 'CK_LIBERAR_OP'
							IF !v_producao_programa_00_prod.ANM_OP_LIBERADA	
								replace ANM_OP_LIBERADA WITH .T. IN v_producao_programa_00_prod
							ENDIF
						ENDIF 
					
						IF upper(xnome_obj) = 'CK_MATAR_SALDO_PROGRAMACAO'
							If xImport = 1
								
								xImport = 0
								xErroImport=0
								
								SELE v_producao_programa_00_prod
								IF v_producao_programa_00_prod.qtde_em_op = v_producao_programa_00_prod.qtde_programada ;
										AND v_producao_programa_00_prod.qtde_em_op > 0;
										AND v_producao_programa_00_prod.matar_saldo_programacao = .t.
									
									xErroImport=1
									
									MESSAGEBOX('N�o � permitido matar saldo desse Produto/Cor: '+ALLTRIM(v_producao_programa_00_prod.produto)+'-'+ALLTRIM(v_producao_programa_00_prod.cor_produto)+CHR(13)+;
											   'OP ou pedido de compra j� emitido.'+CHR(13)+CHR(13)+;
											   'OPERA��O CANCELADA !!!',16,'Matar Saldo')
										o_toolbar.botao_cancela.Click
										o_toolbar.botao_refresh.Click
								ENDIF
							
								IF v_producao_programa_00_prod.qtde_em_op > 0 AND v_producao_programa_00_prod.matar_saldo_programacao = .f.
									
									xErroImport=1
									
									MESSAGEBOX('OP ou pedido de compra j� emitido do produto/Cor: '+ALLTRIM(v_producao_programa_00_prod.produto)+'-'+ALLTRIM(v_producao_programa_00_prod.cor_produto)+CHR(13)+;
											   'N�o � permitido voltar com o saldo.'+CHR(13)+CHR(13)+;
											   'OPERA��O CANCELADA !!!',16,'Matar Saldo')
									
									o_toolbar.botao_cancela.Click
									o_toolbar.botao_refresh.Click
								ENDIF
							Endif
						ENDIF
						
						
						IF upper(xnome_obj) = 'TX_1'  OR upper(xnome_obj) = 'TX_2'  OR upper(xnome_obj) = 'TX_3'  OR upper(xnome_obj) = 'TX_4'  OR;
						   upper(xnome_obj) = 'TX_5'  OR upper(xnome_obj) = 'TX_6'  OR upper(xnome_obj) = 'TX_7'  OR upper(xnome_obj) = 'TX_8'  OR;
						   upper(xnome_obj) = 'TX_9'  OR upper(xnome_obj) = 'TX_10' OR upper(xnome_obj) = 'TX_11' OR upper(xnome_obj) = 'TX_12' OR;
						   upper(xnome_obj) = 'TX_13' OR upper(xnome_obj) = 'TX_14' OR upper(xnome_obj) = 'TX_15' OR upper(xnome_obj) = 'TX_16' 
							
							
							If Thisformset.p_tool_status = 'A' AND iif(TYPE("Thisformset.pp_Permite_desprogramar_prod")="U",.f.,.t.) AND xImport = 1
								
								xImport = 0
								xErroImport=0
								xProgNaoValida = 0
								xSelect="select * FROM dbo.FX_ANM_PARAMETROS_REDE_LOJAS('GS_PROG_NAO_BLOQ_DESPROG')"
								f_select(xSelect,"CurValidaNomeProg")
								
								GO top
								SCAN
									IF ALLTRIM(CurValidaNomeProg.valor_atual) $ V_PRODUCAO_PROGRAMA_00.programacao
										xProgNaoValida = 1
									ENDIF
								ENDSCAN
								
								IF TYPE("CurValidaNomeProg")<>"U"
									USE IN CurValidaNomeProg
								ENDIF
								
								IF TYPE("Cur_Valida")<>"U"
									USE IN Cur_Valida
								ENDIF

								xQtdeAlter = IIF(v_producao_programa_00_prod.matar_saldo_programacao = .f.,;
																v_producao_programa_00_prod.QTDE_PROGRAMADA,;
																v_producao_programa_00_prod.qtde_em_op)
								
								IF USED("CurOldValProg") 
									USE IN CurOldValProg
								ENDIF					
								
								Sele v_producao_programa_00_prod_otb
								locate FOR  produto = v_producao_programa_00_prod.produto AND ;
											cor_produto = v_producao_programa_00_prod.cor_produto AND;
											entrega_inicial = v_producao_programa_00_prod.entrega_inicial
											
										
								
								IF FOUND() AND xQtdeAlter < v_producao_programa_00_prod_otb.qtde_prog_mrp;
										   AND xProgNaoValida = 0
										   			   	
										xQtdeOldProg = 1																	
										xCompradora = '.'
													 							
										TEXT TO xSel TEXTMERGE NOSHOW
											Select Count(*) as OK From GS_PROGRAMACAO_SEM_COMPRA (nolock) 
											Where Programacao = '<<v_producao_programa_00.programacao>>'  and 
											      Produto     = '<<v_producao_programa_00_prod.produto>>' and 
											      Cor_Produto = '<<v_producao_programa_00_prod.cor_produto>>' 
										ENDTEXT
										f_select(xSel,"Cur_Valida")
										
										IF Cur_Valida.OK = 0
								
											TEXT TO xSel TEXTMERGE NOSHOW
												
												SELECT *
												FROM FN_CONSULTA_RESERVA_PROG_008006
												(
													'<<v_producao_programa_00.programacao>>'			,
													'<<v_producao_programa_00_prod.produto>>'			,
													'<<v_producao_programa_00_prod.cor_produto>>'		,
													 <<v_producao_programa_00_prod_otb.qtde_prog_mrp>>	,
													 <<xQtdeAlter>>
												)   


											ENDTEXT
											
											f_select(xSel,"Cur_Valida")
											IF RECCOUNT()>0
												xQtdeOldProg = Cur_Valida.qtde_programada
												xCompradora  = CHR(13)+ALLTRIM(Cur_Valida.usuario_linx)
												xSobraMatMRP = Cur_Valida.SOBRA_MRP_FINAL
											ELSE
												xQtdeOldProg = v_producao_programa_00_prod_otb.qtde_programada
												xSobraMatMRP = 0
											ENDIF
											
											Thisformset.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
											xDesprog = INT((1-(xQtdeAlter/xQtdeOldProg))*100)
											IF xDesprog > Thisformset.pp_Permite_desprogramar_prod AND xSobraMatMRP < 0  and IIF(f_vazio(Cur_Valida.valida_prod),0,Cur_Valida.valida_prod) > 0
												
												xErroImport = 1
												
												MESSAGEBOX("Produto/Cor com pedido de compra de MP j� emitido."+CHR(13)+;
													"Favor solicitar o cancelamento com a compradora"+ALLTRIM(xCompradora)+CHR(13)+CHR(13)+;
													"Produto: "+ALLTRIM(v_producao_programa_00_prod.produto)+CHR(13)+;
													"Cor: "+ALLTRIM(v_producao_programa_00_prod.cor_produto)+CHR(13)+CHR(13)+;
													"OPERA��O CANCELADA !!!",64,+;
													"Altera��o de Grade n�o Permitida")
												
												o_toolbar.botao_cancela.Click
												o_toolbar.botao_refresh.Click
																								
												IF upper(xnome_obj) = 'CK_MATAR_SALDO_PROGRAMACAO'
													
													Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1.COL_ck_MATAR_SALDO_PROGRAMACAO.Ck_MATAR_SALDO_PROGRAMACAO.Value = 0
												ELSE
*!*														xRetornaValor = "Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1."+;
*!*																		"col_TX_QTDE_PROGRAMADA.LX_GRADE48_1.GRADE."+upper(ALLTRIM(xnome_obj))+".value = "+;
*!*																		"Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1."+;
*!*																		"col_TX_QTDE_PROGRAMADA.LX_GRADE48_1.GRADE."+upper(ALLTRIM(xnome_obj))+".OldValue"																		
*!*														TRY 
*!*															&xRetornaValor
*!*														ENDTRY	
												ENDIF
												
												o_toolbar.botao_cancela.Click
												o_toolbar.botao_refresh.Click
												
											ELSE
								
												Sele Cur_Valida	
												IF RECCOUNT()>0
													    
													    Sele cNECESSIDADE_MAT_MRP_PROG
													    locate FOR ALLT(Material) = ALLT(Cur_Valida.MATERIAL) AND; 
														   		   ALLT(Cor_Material) = ALLT(Cur_Valida.COR_MATERIAL)
													    
													    IF FOUND()
													    	Replace SOBRA_MRP_FINAL WITH Cur_Valida.SOBRA_MRP_FINAL
													    ELSE
															SELECT cNECESSIDADE_MAT_MRP_PROG
															APPEND BLANK
															REPLACE material 		WITH Cur_Valida.material;
																	cor_material 	WITH Cur_Valida.cor_material;
																	sobra_mrp_final WITH Cur_Valida.SOBRA_MRP_FINAL
													    ENDIF
	
												ENDIF
											ENDIF	
										
										ENDIF
								   ENDIF
							Endif
							IF !v_producao_programa_00_prod.ANM_OP_LIBERADA	
								replace ANM_OP_LIBERADA WITH .T. IN v_producao_programa_00_prod
							ENDIF
						ENDIF
											
						
				
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				
					
				case upper(xmetodo) == 'USR_VALID' 
					
					xalias=alias()	
						
						IF upper(xnome_obj) = 'CK_MATAR_SALDO_PROGRAMACAO'
							
							SELE v_producao_programa_00_prod
							IF v_producao_programa_00_prod.qtde_em_op = v_producao_programa_00_prod.qtde_programada ;
									AND v_producao_programa_00_prod.qtde_em_op > 0;
									AND v_producao_programa_00_prod.matar_saldo_programacao = .t.
								
								MESSAGEBOX('N�o � permitido matar saldo desse Produto/Cor'+CHR(13)+'OP ou pedido de compra j� emitido.',16,'Matar Saldo')
								Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1.COL_ck_MATAR_SALDO_PROGRAMACAO.Ck_MATAR_SALDO_PROGRAMACAO.Value = 0
								RETURN .F.
							ENDIF
							
							IF v_producao_programa_00_prod.qtde_em_op < v_producao_programa_00_prod.qtde_programada ;
									AND v_producao_programa_00_prod.qtde_em_op > 0;
									AND v_producao_programa_00_prod.matar_saldo_programacao = .t.
								
								MESSAGEBOX('OP ou pedido de compra j� emitido'+CHR(13)+'O Saldo da OP ou Pedido n�o ser� matado'+CHR(13)+;
										   'Saldo matado ser� de '+ALLTRIM(STR(v_producao_programa_00_prod.qtde_programada-v_producao_programa_00_prod.qtde_em_op,9,0))+;
										   ' Pe�as',64,'Matar Saldo')
							ENDIF
							
							IF v_producao_programa_00_prod.qtde_em_op > 0 AND v_producao_programa_00_prod.matar_saldo_programacao = .f.
								
								MESSAGEBOX('OP ou pedido de compra j� emitido'+CHR(13)+'N�o � permitido voltar com o saldo.',16,'Matar Saldo')
								Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1.COL_ck_MATAR_SALDO_PROGRAMACAO.Ck_MATAR_SALDO_PROGRAMACAO.Value = 1
								RETURN .F.
							ENDIF
							
						ENDIF
						
						IF upper(xnome_obj) = 'TV_PRODUTO'
						
							f_select("select valor_propriedade from prop_produtos where propriedade = '00036' and produto =?v_producao_programa_00_prod.produto","CurPropProd",ALIAS())
							Thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1.col_OP_LIBERADA.CK_LIBERAR_OP.value = CurPropProd.valor_propriedade = "PRODUTO ACABADO"
							
							
							****** PROJETO PROGRAMACAO QUINZENAL
							F_Select("Select * From Produtos Where Produto =?V_Producao_Programa_00_Prod.Produto","xRede")
							Sele xRede
							
							F_Select("select * from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_BLOQ_ENTR_FINAL_PROG')","ppRL_ANM_BLOQ_ENTR_FINAL_PROG")
							Sele ppRL_ANM_BLOQ_ENTR_FINAL_PROG
							Locate For REDE_LOJAS = xRede.rede_lojas
							If FOUND() AND ppRL_ANM_BLOQ_ENTR_FINAL_PROG.valor_atual = 'SIM'	
								
								Sele CurPropProducaoPrograma
								Locate For Propriedade == '00038'
								
								If F_Vazio(CurPropProducaoPrograma.valor_propriedade)
									Messagebox("Favor Preencher o Tipo de Programa��o!!!",0+16)
									
									Thisformset.LX_FORM1.LX_PAGEFRAME1.ActivePage =1
									Thisformset.L_DESenhista_filhas_exclui_antes
									Sele v_producao_programa_00_prod
									if recno()!= 0 and !eof() and !deleted()
										tablerevert()
										if recno() > 0
											delete
										endif
									ENDIF
									Thisformset.l_desenhista_filhas_exclui_apos
										
									USE IN xrede
									USE IN ppRL_ANM_BLOQ_ENTR_FINAL_PROG
									Return .t.
									
								Endif	
							Else						
								USE IN xrede
								USE IN ppRL_ANM_BLOQ_ENTR_FINAL_PROG
							Endif	
								
						ENDIF
						
						*** PROJETO REPROGRAMACAO QUINZENAL
						IF upper(xnome_obj) = 'TX_ENTREGA_INICIAL' AND Thisformset.p_tool_status = 'I'

							xAno=LEFT(DTOS(V_Producao_Programa_00_Prod.entrega_inicial),4)
							xMes=STR(MONTH(V_Producao_Programa_00_Prod.entrega_inicial))
							xQuinzena=IIF(ALLTRIM(STR(VAL(RIGHT(DTOS(V_Producao_Programa_00_Prod.entrega_inicial),2))))>='1' AND ALLTRIM(STR(VAL(RIGHT(DTOS(V_Producao_Programa_00_Prod.entrega_inicial),2))))<='14','1','2')
							
							
							F_Select("Select a.*,b.desc_rede_lojas as marca From Produtos a join lojas_rede b on a.rede_lojas=b.rede_lojas Where Produto =?V_Producao_Programa_00_Prod.Produto","xRede")
							Sele xRede
			
							F_Select("select * from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_BLOQ_ENTR_FINAL_PROG')","ppRL_ANM_BLOQ_ENTR_FINAL_PROG")
							Sele ppRL_ANM_BLOQ_ENTR_FINAL_PROG
							Locate For REDE_LOJAS = xRede.rede_lojas
							If FOUND() AND ppRL_ANM_BLOQ_ENTR_FINAL_PROG.valor_atual = 'SIM'
								
								Sele CurPropProducaoPrograma
								Locate For Propriedade == '00038'
								
								If F_Vazio(CurPropProducaoPrograma.valor_propriedade)
									Messagebox("Favor Preencher o Tipo de Programa��o!!!",0+16,"Tipo Programa��o Inv�lido")
									Return .F.
								Else
									F_Select("select VALOR_ATUAL as PARAMETROS from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_PROG_MOSTR')","xParamMost")
								Sele xParamMost
									Scan 
										Sele CurPropProducaoPrograma
										Locate For Propriedade == '00038'
										
										If LTRIM(RTRIM(CurPropProducaoPrograma.valor_propriedade)) == LTRIM(RTRIM(xParamMost.Parametros))
											***Verifica��o Mostru�rio
									
											F_Select("select * from Gs_Calendarios_Reprog_Most Where Codigo_Marca = ?xRede.rede_lojas","xCalendario")
											Sele xCalendario
											Locate For xCalendario.mes = Ltrim(Rtrim(xMes)) AND xCalendario.ano = Ltrim(Rtrim(xAno))
											
											If !F_Vazio(xCalendario.marca)									  		   
												If CTOD(DTOC(DATE()))-CTOD(DTOC(xCalendario.data_programacao)) >= Thisformset.pp_anm_dias_atraso_prog_most
													xDiasAtraso=CTOD(DTOC(DATE()))-CTOD(DTOC(xCalendario.data_programacao))
													xDataSugeridaProg=V_Producao_Programa_00_Prod.entrega_final + xDiasAtraso

													*F_Select("Select * From Producao_Prog_Prod Where Programacao=?V_Producao_Programa_00_Prod.Programacao AND Produto=?V_Producao_Programa_00_Prod.Produto AND Cor_Produto=?V_Producao_Programa_00_Prod.Cor_Produto","xDataProg")
													TEXT TO curDataProg NOSHOW TEXTMERGE
														Select * From Producao_Prog_Prod 
														Where Programacao=?V_Producao_Programa_00_Prod.Programacao 
														AND Produto=?V_Producao_Programa_00_Prod.Produto 
														AND Cor_Produto=?V_Producao_Programa_00_Prod.Cor_Produto
														and entrega_inicial=?V_Producao_Programa_00_Prod.Entrega_Inicial
													ENDTEXT
													f_select(curDataProg,"xDataProg")
													Sele xDataProg
													
													f_select("select * from GS_MESES_MINI_COLECAO_MOST where rede_lojas=?xRede.rede_lojas","xMiniMeses")
													sele xMiniMeses
													Locate For MONTH(v_producao_programa_00_prod.entrega_inicial) >= Inicio_Mes  and MONTH(v_producao_programa_00_prod.entrega_inicial) <= Fim_Mes	
													
													If !F_Vazio(xMiniMeses.prox_codigo_min_col)
														Sele xMiniMeses
														xProxMin=xMiniMeses.prox_codigo_min_col
														Locate For codigo_mini_col= xProxMin
		
																												
														xInicioMes=IIF(xMiniMeses.inicio_mes=1,'JANEIRO',IIF(xMiniMeses.inicio_mes=2,'FEVEREIRO',IIF(xMiniMeses.inicio_mes=3,'MAR�O',IIF(xMiniMeses.inicio_mes=4,'ABRIL',IIF(xMiniMeses.inicio_mes=5,'MAIO',IIF(xMiniMeses.inicio_mes=6,'JUNHO',IIF(xMiniMeses.inicio_mes=7,'JULHO',IIF(xMiniMeses.inicio_mes=8,'AGOSTO',IIF(xMiniMeses.inicio_mes=9,'SETEMBRO',IIF(xMiniMeses.inicio_mes=10,'OUTUBRO',IIF(xMiniMeses.inicio_mes=11,'NOVEMBRO','DEZEMBRO')))))))))))
														xFimMes=IIF(xMiniMeses.fim_mes=1,'JANEIRO',IIF(xMiniMeses.fim_mes=2,'FEVEREIRO',IIF(xMiniMeses.fim_mes=3,'MAR�O',IIF(xMiniMeses.fim_mes=4,'ABRIL',IIF(xMiniMeses.fim_mes=5,'MAIO',IIF(xMiniMeses.fim_mes=6,'JUNHO',IIF(xMiniMeses.fim_mes=7,'JULHO',IIF(xMiniMeses.fim_mes=8,'AGOSTO',IIF(xMiniMeses.fim_mes=9,'SETEMBRO',IIF(xMiniMeses.fim_mes=10,'OUTUBRO',IIF(xMiniMeses.fim_mes=11,'NOVEMBRO','DEZEMBRO')))))))))))
														
														MESSAGEBOX("ATEN��O !!!"+CHR(13)+"Data Limite: " +DTOC(xCalendario.data_programacao);
																	+CHR(13)+"Dias atraso: "+ LTRIM(RTRIM(STR(xDiasAtraso)))+CHR(13)+"Meses poss�veis para programar: Entre "+ALLTRIM(xInicioMes)+" e "+ALLTRIM(xFimMes) + " ("+ALLTRIM(xMiniMeses.codigo_mini_col)+")",0+16,"Aten��o - Mostru�rio")			
														Use In xDataProg
														Use In xMiniMeses														
													Endif	
												Endif
											Endif
										Else
											***Aqui entra a verifica��o quando n�o for mostruario		  							
											*F_Select("select * from Gs_Calendarios_Reprogramacao Where Codigo_Marca = ?xRede.rede_lojas","xCalendario")
											TEXT TO CurCalendarioRepro NOSHOW TEXTMERGE
												Select * From Gs_Calendarios_Reprogramacao (nolock) A
												Join Wgs_Canal_Calendario B
												On A.CANAL = B.Canal
												where Codigo_Marca = ?xRede.rede_lojas
												and b.tipo_programacao = ?CurPropProducaoPrograma.valor_propriedade											
											ENDTEXT
										
											F_SELECT(CurCalendarioRepro,"xCalendario")
											Sele xCalendario
											Locate For xCalendario.mes = Ltrim(Rtrim(xMes)) AND xCalendario.ano = Ltrim(Rtrim(xAno)) AND xCalendario.quinzena = LTRIM(RTRIM(xQuinzena))
											
											If !F_Vazio(xCalendario.marca) AND Thisformset.pp_anm_perm_entr_final_prog = .F.										  		   
													If CTOD(DTOC(DATE()))-CTOD(DTOC(xCalendario.data_programacao)) > 0 AND CTOD(DTOC(DATE()))-CTOD(DTOC(xCalendario.data_programacao)) < 60
														xDiasAtraso=CTOD(DTOC(DATE()))-CTOD(DTOC(xCalendario.data_programacao))
														xDataSugeridaProg=CTOD(DTOC(xCalendario.data_ent_loja)) + IIF(xDiasAtraso>0 AND xDiasAtraso<=15,15,IIF(xDiasAtraso>15 and xDiasAtraso<=30,30,IIF(xDiasAtraso>45 and xDiasAtraso<=60,60,60)))
														
														TEXT TO xSugerida NOSHOW TEXTMERGE
															SELECT CONVERT(VARCHAR(10),DBO.FN_GS_DATA_ENT_LOJA_CALENDARIO('<<xDataSugeridaProg>>','<<xRede.marca>>','<<CurPropProducaoPrograma.valor_propriedade>>'),103) as data_meta
														ENDTEXT
														F_SELECT(xSugerida,'Cur_Sugerida')
												
														MESSAGEBOX("ATEN��O !!!"+CHR(13)+"Data Limite: " +DTOC(xCalendario.data_programacao);
																	+CHR(13)+"Dias atraso: "+ LTRIM(RTRIM(STR(xDiasAtraso)))+CHR(13)+"Data Meta: "+Cur_Sugerida.data_meta,0+16,"Aten��o - Produ��o")	
																	*+CHR(13)+"Dias atraso: "+ LTRIM(RTRIM(STR(xDiasAtraso)))+CHR(13)+"Data Entrega ser�: "+DTOC(xDataSugeridaProg),0+16,"Aten��o - Produ��o")	
																		
														Use In Cur_Sugerida 			
													Endif	
											
													If CTOD(DTOC(DATE()))-CTOD(DTOC(xCalendario.data_programacao)) > 60	
														xDiasAtraso=CTOD(DTOC(DATE()))-CTOD(DTOC(xCalendario.data_programacao))
														xDataSugeridaProg=CTOD(DTOC(xCalendario.data_ent_loja)) + 60
														
														TEXT TO xSugerida NOSHOW TEXTMERGE
															SELECT CONVERT(VARCHAR(10),DBO.FN_GS_DATA_ENT_LOJA_CALENDARIO('<<xDataSugeridaProg>>','<<xRede.marca>>','<<CurPropProducaoPrograma.valor_propriedade>>'),103) as data_meta
														ENDTEXT
														F_SELECT(xSugerida,'Cur_Sugerida')
														
														MESSAGEBOX("ATEN��O MAIS DE 60 DIAS!!!"+CHR(13)+"Data Limite: " +DTOC(xCalendario.data_programacao);
																	+CHR(13)+"Dias atraso: "+ LTRIM(RTRIM(STR(xDiasAtraso)))+CHR(13)+"Data Meta: "+Cur_Sugerida.data_meta,0+16,"Aten��o - Produ��o")														
																	*+CHR(13)+"Dias atraso: "+ LTRIM(RTRIM(STR(xDiasAtraso)))+CHR(13)+"Data Sugerida Programa��o: "+xDataSugeridaProg,0+16,"Aten��o - Produ��o")	
													Endif
											Endif
										Endif
									EndScan
								Endif
							ENDIF
						ENDIF

						IF upper(xnome_obj) = 'TX_ENTREGA_INICIAL'
							***************
							*!* Inicio - Card: Trava de programa��es
							*!* Marco Banaggia - 30/08/2018
							**************
							xDataLimiteBancoProd = Date() + Thisformset.pp_GS_DIAS_BLOQ_PROG_PROD
							xDataLimiteBancoMost = Date()
							xCountCur = 0
							xFiltro   = .T.
							
							SELECT CURPROPPRODUCAOPROGRAMA
							LOCATE FOR PROPRIEDADE = '00038'
							If Alltrim(Upper(CURPROPPRODUCAOPROGRAMA.VALOR_PROPRIEDADE)) = Upper('MOSTRUARIO')
							***** Pega o valor do parametro para o bloqueio de entrega para mostruario
								If Thisformset.p_tool_status = 'A'
									TEXT TO XSQL TEXTMERGE NOSHOW
										SELECT MAX(ENTREGA_INICIAL) AS ENTREGA_INICIAL, MAX(ENTREGA_FINAL) AS ENTREGA_FINAL
											FROM PRODUCAO_PROG_PROD (NOLOCK)
										WHERE PROGRAMACAO = ?V_Producao_Programa_00_Prod.Programacao AND
											  PRODUTO =?V_Producao_Programa_00_Prod.Produto AND
											  COR_PRODUTO = ?V_Producao_Programa_00_Prod.COR_Produto
										HAVING MAX(ENTREGA_INICIAL) IS NOT NULL
									ENDTEXT

									f_select(XSQL,"vCurDataLImite")
									IF RECCOUNT()>0
										xFiltro = IIF(v_Producao_Programa_00_Prod.ENTREGA_INICIAL > vCurDataLImite.ENTREGA_INICIAL,.F.,.T.)
									ENDIF
								Endif
								 
								If Thisformset.pp_GS_DIAS_BLOQ_PROG_MOST > 0 AND xFiltro 
									TEXT TO XSQL TEXTMERGE NOSHOW
										exec PROC_GS_VERIFICA_DATA_PROG_MOST '<<V_Producao_Programa_00_Prod.PRODUTO>>','<<V_Producao_Programa_00_Prod.ENTREGA_INICIAL>>'
									ENDTEXT
									f_select(XSQL,"vtmp_bloqprog")

									Set Century On
									If vtmp_bloqprog.prazo = 1
										Messagebox("Data n�o permitida para mostru�rio"+ Chr(13)+;
											'Data Sugerida: '+dtoc(vtmp_bloqprog.data_programacao_sugerida),48+0,"Informa��o")
										Replace ENTREGA_INICIAL With vtmp_bloqprog.data_programacao_sugerida In V_Producao_Programa_00_Prod
										Replace ENTREGA_FINAL   With vtmp_bloqprog.data_programacao_sugerida In V_Producao_Programa_00_Prod
										Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1.COL_tx_ENTREGA_INICIAL.TX_ENTREGA_INICIAL.Value = vtmp_bloqprog.data_programacao_sugerida
										Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1.COL_tx_ENTREGA_FINAL.TX_ENTREGA_FINAL.Value   = vtmp_bloqprog.data_programacao_sugerida
									Endif
								Endif
							Else
							***** Pega o valor do parametro para o bloqueio de entrega para Produto
								If Thisformset.pp_GS_DIAS_BLOQ_PROG_PROD > 0

									If Thisformset.p_tool_status = 'I'
										Set Century On
										xDataLimiteProd = Date() + Thisformset.pp_GS_DIAS_BLOQ_PROG_PROD

										If V_Producao_Programa_00_Prod.ENTREGA_INICIAL  < xDataLimiteProd
											Messagebox("Data n�o permitida para o produto"+Chr(13)+;
												'Data Sugerida: '+dtoc(xDataLimiteProd),48+0,"Informa��o")
											Replace ENTREGA_INICIAL With xDataLimiteProd In V_Producao_Programa_00_Prod
											Replace ENTREGA_FINAL   With xDataLimiteProd In V_Producao_Programa_00_Prod
											Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1.COL_tx_ENTREGA_INICIAL.TX_ENTREGA_INICIAL.Value = xDataLimiteProd
											Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1.COL_tx_ENTREGA_FINAL.TX_ENTREGA_FINAL.Value   = xDataLimiteProd
										Endif
									Else
										If Thisformset.p_tool_status = 'A'
											TEXT TO XSQL TEXTMERGE NOSHOW
												SELECT MAX(ENTREGA_INICIAL) AS ENTREGA_INICIAL, MAX(ENTREGA_FINAL) AS ENTREGA_FINAL
													FROM PRODUCAO_PROG_PROD (NOLOCK)
												WHERE PROGRAMACAO = ?V_Producao_Programa_00_Prod.Programacao AND
													  PRODUTO =?V_Producao_Programa_00_Prod.Produto AND
													  COR_PRODUTO = ?V_Producao_Programa_00_Prod.COR_Produto
												HAVING MAX(ENTREGA_INICIAL) IS NOT NULL
											ENDTEXT

											f_select(XSQL,"vCurDataLImite")
											xCountCur = RECCOUNT()
											
											If (V_Producao_Programa_00_Prod.ENTREGA_INICIAL < vCurDataLImite.ENTREGA_INICIAL) Or xCountCur=0
												Set Century On
												xDataLimiteProd = Date() + Thisformset.pp_GS_DIAS_BLOQ_PROG_PROD

												If V_Producao_Programa_00_Prod.ENTREGA_INICIAL < xDataLimiteProd
													If xCountCur > 0
														Messagebox("N�o � poss�vel reduzir a data programada"+Chr(13)+;
															IIF(vCurDataLImite.ENTREGA_INICIAL - Thisformset.pp_GS_DIAS_BLOQ_PROG_PROD > DATE(),;
																"M�nima data permitida: "+DTOC(xDataLimiteProd),;
															    "S� � permitido aumentar a data de entrega."),48+0,"Data fora do Prazo")
														Replace ENTREGA_INICIAL With vCurDataLImite.ENTREGA_INICIAL In V_Producao_Programa_00_Prod
														Replace ENTREGA_FINAL   With vCurDataLImite.ENTREGA_FINAL   In V_Producao_Programa_00_Prod
														Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1.Col_tx_ENTREGA_INICIAL.TX_ENTREGA_INICIAL.Value = vCurDataLImite.ENTREGA_INICIAL
														Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1.COL_tx_ENTREGA_FINAL.TX_ENTREGA_FINAL.Value   = vCurDataLImite.ENTREGA_FINAL
													Else
														Messagebox("Data n�o permitida para o produto"+Chr(13)+;
															'Data Sugerida: '+dtoc(xDataLimiteProd),48+0,"Informa��o")
														Replace ENTREGA_INICIAL With xDataLimiteProd In V_Producao_Programa_00_Prod
														Replace ENTREGA_FINAL   With xDataLimiteProd In V_Producao_Programa_00_Prod
														Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1.Col_tx_ENTREGA_INICIAL.TX_ENTREGA_INICIAL.Value = xDataLimiteProd
														Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1.COL_tx_ENTREGA_FINAL.TX_ENTREGA_FINAL.Value   = xDataLimiteProd
													Endif
												Endif
											Endif
										Endif
									Endif
								Endif
							Endif
						ENDIF
						***************
						*!* Fim - Card: Trava de programa��es
						*!* Marco Banaggia - 30/08/2018
						***************


						IF upper(xnome_obj) = 'TX_1'  OR upper(xnome_obj) = 'TX_2'  OR upper(xnome_obj) = 'TX_3'  OR upper(xnome_obj) = 'TX_4'  OR;
						   upper(xnome_obj) = 'TX_5'  OR upper(xnome_obj) = 'TX_6'  OR upper(xnome_obj) = 'TX_7'  OR upper(xnome_obj) = 'TX_8'  OR;
						   upper(xnome_obj) = 'TX_9'  OR upper(xnome_obj) = 'TX_10' OR upper(xnome_obj) = 'TX_11' OR upper(xnome_obj) = 'TX_12' OR;
						   upper(xnome_obj) = 'TX_13' OR upper(xnome_obj) = 'TX_14' OR upper(xnome_obj) = 'TX_15' OR upper(xnome_obj) = 'TX_16' 
						   
							If Thisformset.p_tool_status = 'A'
								if used("xQtdeProg")
									USE IN xQtdeProg
								ENDIF
									
							   *F_Select("Select * From Producao_Prog_Prod Where Programacao=?V_Producao_Programa_00_Prod.Programacao AND Produto=?V_Producao_Programa_00_Prod.Produto AND Cor_Produto=?V_Producao_Programa_00_Prod.Cor_Produto","xQtdeProg",ALIAS())
							    TEXT TO curQtdeProg NOSHOW TEXTMERGE
									Select * From Producao_Prog_Prod 
									Where Programacao=?V_Producao_Programa_00_Prod.Programacao 
									AND Produto=?V_Producao_Programa_00_Prod.Produto 
									AND Cor_Produto=?V_Producao_Programa_00_Prod.Cor_Produto
									and entrega_inicial=?V_Producao_Programa_00_Prod.Entrega_Inicial
								ENDTEXT
								f_select(curQtdeProg,"xQtdeProg")
								
							   IF xQtdeProg.qtde_programada < V_Producao_Programa_00_Prod.qtde_programada
							   		xAno=LEFT(DTOS(V_Producao_Programa_00_Prod.entrega_inicial),4)
									xMes=STR(MONTH(V_Producao_Programa_00_Prod.entrega_inicial))
									xQuinzena=IIF(ALLTRIM(STR(VAL(RIGHT(DTOS(V_Producao_Programa_00_Prod.entrega_inicial),2))))>='1' AND ALLTRIM(STR(VAL(RIGHT(DTOS(V_Producao_Programa_00_Prod.entrega_inicial),2))))<='14','1','2')
									
									
									F_Select("Select a.*,b.desc_rede_lojas as marca From Produtos a join lojas_rede b on a.rede_lojas=b.rede_lojas Where Produto =?V_Producao_Programa_00_Prod.Produto","xRede")
									Sele xRede
					
									F_Select("select * from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_BLOQ_ENTR_FINAL_PROG')","ppRL_ANM_BLOQ_ENTR_FINAL_PROG")
									Sele ppRL_ANM_BLOQ_ENTR_FINAL_PROG
									Locate For REDE_LOJAS = xRede.rede_lojas
									If FOUND() AND ppRL_ANM_BLOQ_ENTR_FINAL_PROG.valor_atual = 'SIM'
										
										Sele CurPropProducaoPrograma
										Locate For Propriedade == '00038'
										
										If F_Vazio(CurPropProducaoPrograma.valor_propriedade)
											Messagebox("Favor Preencher o Tipo de Programa��o!!!",0+16)
											Return .F.
										Else
											F_Select("select VALOR_ATUAL as PARAMETROS from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_PROG_MOSTR')","xParamMost")
											Sele xParamMost
												Scan 
													Sele CurPropProducaoPrograma
													Locate For Propriedade == '00038'
													
													If LTRIM(RTRIM(CurPropProducaoPrograma.valor_propriedade)) == LTRIM(RTRIM(xParamMost.Parametros))
														***Verifica��o Mostru�rio
												
														F_Select("select * from Gs_Calendarios_Reprog_Most Where Codigo_Marca = ?xRede.rede_lojas","xCalendario")
														Sele xCalendario
														Locate For xCalendario.mes = Ltrim(Rtrim(xMes)) AND xCalendario.ano = Ltrim(Rtrim(xAno))
														
														If !F_Vazio(xCalendario.marca)									  		   
															If CTOD(DTOC(DATE()))-CTOD(DTOC(xCalendario.data_programacao)) >= Thisformset.pp_anm_dias_atraso_prog_most
																xDiasAtraso=CTOD(DTOC(DATE()))-CTOD(DTOC(xCalendario.data_programacao))
																xDataSugeridaProg=V_Producao_Programa_00_Prod.entrega_final + xDiasAtraso

																*F_Select("Select * From Producao_Prog_Prod Where Programacao=?V_Producao_Programa_00_Prod.Programacao AND Produto=?V_Producao_Programa_00_Prod.Produto AND Cor_Produto=?V_Producao_Programa_00_Prod.Cor_Produto","xDataProg")
																TEXT TO curDataProg NOSHOW TEXTMERGE
																	Select * From Producao_Prog_Prod 
																	Where Programacao=?V_Producao_Programa_00_Prod.Programacao 
																	AND Produto=?V_Producao_Programa_00_Prod.Produto 
																	AND Cor_Produto=?V_Producao_Programa_00_Prod.Cor_Produto
																	and entrega_inicial=?V_Producao_Programa_00_Prod.Entrega_Inicial
																ENDTEXT
																f_select(curDataProg,"xDataProg")
																Sele xDataProg
																
																f_select("select * from GS_MESES_MINI_COLECAO_MOST where rede_lojas=?xRede.rede_lojas","xMiniMeses")
																sele xMiniMeses
																Locate For MONTH(v_producao_programa_00_prod.entrega_inicial) >= Inicio_Mes  and MONTH(v_producao_programa_00_prod.entrega_inicial) <= Fim_Mes	
																
																If !F_Vazio(xMiniMeses.prox_codigo_min_col)
																	Sele xMiniMeses
																	xProxMin=xMiniMeses.prox_codigo_min_col
																	Locate For codigo_mini_col= xProxMin
					
																															
																	xInicioMes=IIF(xMiniMeses.inicio_mes=1,'JANEIRO',IIF(xMiniMeses.inicio_mes=2,'FEVEREIRO',IIF(xMiniMeses.inicio_mes=3,'MAR�O',IIF(xMiniMeses.inicio_mes=4,'ABRIL',IIF(xMiniMeses.inicio_mes=5,'MAIO',IIF(xMiniMeses.inicio_mes=6,'JUNHO',IIF(xMiniMeses.inicio_mes=7,'JULHO',IIF(xMiniMeses.inicio_mes=8,'AGOSTO',IIF(xMiniMeses.inicio_mes=9,'SETEMBRO',IIF(xMiniMeses.inicio_mes=10,'OUTUBRO',IIF(xMiniMeses.inicio_mes=11,'NOVEMBRO','DEZEMBRO')))))))))))
																	xFimMes=IIF(xMiniMeses.fim_mes=1,'JANEIRO',IIF(xMiniMeses.fim_mes=2,'FEVEREIRO',IIF(xMiniMeses.fim_mes=3,'MAR�O',IIF(xMiniMeses.fim_mes=4,'ABRIL',IIF(xMiniMeses.fim_mes=5,'MAIO',IIF(xMiniMeses.fim_mes=6,'JUNHO',IIF(xMiniMeses.fim_mes=7,'JULHO',IIF(xMiniMeses.fim_mes=8,'AGOSTO',IIF(xMiniMeses.fim_mes=9,'SETEMBRO',IIF(xMiniMeses.fim_mes=10,'OUTUBRO',IIF(xMiniMeses.fim_mes=11,'NOVEMBRO','DEZEMBRO')))))))))))
																	
																	MESSAGEBOX("ATEN��O !!!"+CHR(13)+"Data Limite: " +DTOC(xCalendario.data_programacao);
																				+CHR(13)+"Dias atraso: "+ LTRIM(RTRIM(STR(xDiasAtraso)))+CHR(13)+"Meses poss�veis para programar: Entre "+ALLTRIM(xInicioMes)+" e "+ALLTRIM(xFimMes) + " ("+ALLTRIM(xMiniMeses.codigo_mini_col)+")",0+16,"Aten��o - Mostru�rio")			
																	Use In xDataProg
																	Use In xMiniMeses														
																Endif	
															Endif
														Endif
													Else
														***Aqui entra a verifica��o quando n�o for mostruario		  							
														*F_Select("select * from Gs_Calendarios_Reprogramacao Where Codigo_Marca = ?xRede.rede_lojas","xCalendario")
														TEXT TO CurCalendarioRepro NOSHOW TEXTMERGE
															Select * From Gs_Calendarios_Reprogramacao (nolock) A
															Join Wgs_Canal_Calendario B
															On A.CANAL = B.Canal
															where Codigo_Marca = ?xRede.rede_lojas
															and b.tipo_programacao = ?CurPropProducaoPrograma.valor_propriedade											
														ENDTEXT
													
													F_SELECT(CurCalendarioRepro,"xCalendario")
														Sele xCalendario
														Locate For xCalendario.mes = Ltrim(Rtrim(xMes)) AND xCalendario.ano = Ltrim(Rtrim(xAno)) AND xCalendario.quinzena = LTRIM(RTRIM(xQuinzena))
														
														If !F_Vazio(xCalendario.marca) AND Thisformset.pp_anm_perm_entr_final_prog = .F.										  		   
																If CTOD(DTOC(DATE()))-CTOD(DTOC(xCalendario.data_programacao)) > 0 AND CTOD(DTOC(DATE()))-CTOD(DTOC(xCalendario.data_programacao)) < 60
																	xDiasAtraso=CTOD(DTOC(DATE()))-CTOD(DTOC(xCalendario.data_programacao))
																	xDataSugeridaProg=CTOD(DTOC(xCalendario.data_ent_loja)) + IIF(xDiasAtraso>0 AND xDiasAtraso<=15,15,IIF(xDiasAtraso>15 and xDiasAtraso<=30,30,IIF(xDiasAtraso>45 and xDiasAtraso<=60,60,60)))
																	
																	TEXT TO xSugerida NOSHOW TEXTMERGE
																		SELECT CONVERT(VARCHAR(10),DBO.FN_GS_DATA_ENT_LOJA_CALENDARIO('<<xDataSugeridaProg>>','<<xRede.marca>>','<<CurPropProducaoPrograma.valor_propriedade>>'),103) as data_meta
																	ENDTEXT
																	F_SELECT(xSugerida,'Cur_Sugerida')
															
																	MESSAGEBOX("ATEN��O !!!"+CHR(13)+"Data Limite: " +DTOC(xCalendario.data_programacao);
																				+CHR(13)+"Dias atraso: "+ LTRIM(RTRIM(STR(xDiasAtraso)))+CHR(13)+"Data Meta: "+Cur_Sugerida.data_meta,0+16,"Aten��o - Produ��o")	
																				*+CHR(13)+"Dias atraso: "+ LTRIM(RTRIM(STR(xDiasAtraso)))+CHR(13)+"Data Entrega ser�: "+DTOC(xDataSugeridaProg),0+16,"Aten��o - Produ��o")	
																					
																	Use In Cur_Sugerida 			
																Endif	
														
																If CTOD(DTOC(DATE()))-CTOD(DTOC(xCalendario.data_programacao)) > 60	
																	xDiasAtraso=CTOD(DTOC(DATE()))-CTOD(DTOC(xCalendario.data_programacao))
																	xDataSugeridaProg=CTOD(DTOC(xCalendario.data_ent_loja)) + 60
																	
																	TEXT TO xSugerida NOSHOW TEXTMERGE
																		SELECT CONVERT(VARCHAR(10),DBO.FN_GS_DATA_ENT_LOJA_CALENDARIO('<<xDataSugeridaProg>>','<<xRede.marca>>','<<CurPropProducaoPrograma.valor_propriedade>>'),103) as data_meta
																	ENDTEXT
																	F_SELECT(xSugerida,'Cur_Sugerida')
																	
																	MESSAGEBOX("ATEN��O MAIS DE 60 DIAS!!!"+CHR(13)+"Data Limite: " +DTOC(xCalendario.data_programacao);
																				+CHR(13)+"Dias atraso: "+ LTRIM(RTRIM(STR(xDiasAtraso)))+CHR(13)+"Data Meta: "+Cur_Sugerida.data_meta,0+16,"Aten��o - Produ��o")														
																				*+CHR(13)+"Dias atraso: "+ LTRIM(RTRIM(STR(xDiasAtraso)))+CHR(13)+"Data Sugerida Programa��o: "+xDataSugeridaProg,0+16,"Aten��o - Produ��o")	
																Endif
														Endif
													Endif
												EndScan
										Endif
									Endif				   	
							   	
							   ENDIF	
							Endif
							************************** FIM PROJETO REPROGRAMACAO QUINZENAL
							
							If Thisformset.p_tool_status = 'A' AND iif(TYPE("Thisformset.pp_Permite_desprogramar_prod")="U",.f.,.t.)
								
								xErroImport=0
								xProgNaoValida = 0
								xSelect="select * FROM dbo.FX_ANM_PARAMETROS_REDE_LOJAS('GS_PROG_NAO_BLOQ_DESPROG')"
								f_select(xSelect,"CurValidaNomeProg")
								
								GO top
								SCAN
									IF ALLTRIM(CurValidaNomeProg.valor_atual) $ V_PRODUCAO_PROGRAMA_00.programacao
										xProgNaoValida = 1
									ENDIF
								ENDSCAN
								
								IF TYPE("CurValidaNomeProg")<>"U"
									USE IN CurValidaNomeProg
								ENDIF
								
								IF TYPE("Cur_Valida")<>"U"
									USE IN Cur_Valida
								ENDIF

								xQtdeAlter = IIF(v_producao_programa_00_prod.matar_saldo_programacao = .f.,;
																v_producao_programa_00_prod.QTDE_PROGRAMADA,;
																v_producao_programa_00_prod.qtde_em_op)
											
								Sele v_producao_programa_00_prod_otb
								locate FOR  produto = v_producao_programa_00_prod.produto AND ;
											cor_produto = v_producao_programa_00_prod.cor_produto AND;
											entrega_inicial = v_producao_programa_00_prod.entrega_inicial
											
										
								
								IF FOUND() AND xQtdeAlter < v_producao_programa_00_prod_otb.qtde_prog_mrp;
										   AND xProgNaoValida = 0
										   			   	
										xQtdeOldProg = 1																	
										xCompradora = '.'
													 							
										TEXT TO xSel TEXTMERGE NOSHOW
											Select Count(*) as OK From GS_PROGRAMACAO_SEM_COMPRA (nolock) 
											Where Programacao = '<<v_producao_programa_00.programacao>>'  and 
											      Produto     = '<<v_producao_programa_00_prod.produto>>' and 
											      Cor_Produto = '<<v_producao_programa_00_prod.cor_produto>>' 
										ENDTEXT
										f_select(xSel,"Cur_Valida")
										
										IF Cur_Valida.OK = 0
								
											TEXT TO xSel TEXTMERGE NOSHOW
												
												SELECT *
												FROM FN_CONSULTA_RESERVA_PROG_008006
												(
													'<<v_producao_programa_00.programacao>>'			,
													'<<v_producao_programa_00_prod.produto>>'			,
													'<<v_producao_programa_00_prod.cor_produto>>'		,
													 <<v_producao_programa_00_prod_otb.qtde_prog_mrp>>	,
													 <<xQtdeAlter>>
												)   


											ENDTEXT
											
											f_select(xSel,"Cur_Valida")
											IF RECCOUNT()>0
												xQtdeOldProg = Cur_Valida.qtde_programada
												xCompradora  = CHR(13)+ALLTRIM(Cur_Valida.usuario_linx)
												xSobraMatMRP = Cur_Valida.SOBRA_MRP_FINAL
											ELSE
												xQtdeOldProg = v_producao_programa_00_prod_otb.qtde_programada
												xSobraMatMRP = 0
											ENDIF
											
											Thisformset.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
											xDesprog = INT((1-(xQtdeAlter/xQtdeOldProg))*100)
											IF xDesprog > Thisformset.pp_Permite_desprogramar_prod AND xSobraMatMRP < 0  and IIF(f_vazio(Cur_Valida.valida_prod),0,Cur_Valida.valida_prod) > 0
												
												xErroImport = 1
												
												MESSAGEBOX("Produto/Cor com pedido de compra de MP j� emitido."+CHR(13)+;
													"Favor solicitar o cancelamento com a compradora"+ALLTRIM(xCompradora),64,+;
													"Altera��o de Grade n�o Permitida")
												
												IF upper(xnome_obj) = 'CK_MATAR_SALDO_PROGRAMACAO'
													
													Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1.COL_ck_MATAR_SALDO_PROGRAMACAO.Ck_MATAR_SALDO_PROGRAMACAO.Value = 0
												ELSE
													xRetornaValor = "Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1."+;
																	"col_TX_QTDE_PROGRAMADA.LX_GRADE48_1.GRADE."+upper(ALLTRIM(xnome_obj))+".value = "+;
																	"Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_GRID_FILHA1."+;
																	"col_TX_QTDE_PROGRAMADA.LX_GRADE48_1.GRADE."+upper(ALLTRIM(xnome_obj))+".OldValue"	
													
													Thisformset.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
																	
													TRY 
														&xRetornaValor
													ENDTRY	
												ENDIF
												
												Thisformset.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
												RETURN .f.
											ELSE
								
												Sele Cur_Valida	
												IF RECCOUNT()>0
													    
													    Sele cNECESSIDADE_MAT_MRP_PROG
													    locate FOR ALLT(Material) = ALLT(Cur_Valida.MATERIAL) AND; 
														   		   ALLT(Cor_Material) = ALLT(Cur_Valida.COR_MATERIAL)
													    
													    IF FOUND()
													    	Replace SOBRA_MRP_FINAL WITH Cur_Valida.SOBRA_MRP_FINAL
													    ELSE
															SELECT cNECESSIDADE_MAT_MRP_PROG
															APPEND BLANK
															REPLACE material 		WITH Cur_Valida.material;
																	cor_material 	WITH Cur_Valida.cor_material;
																	sobra_mrp_final WITH Cur_Valida.SOBRA_MRP_FINAL
													    ENDIF
	
												ENDIF
											ENDIF	
										
										ENDIF
								   ENDIF
							
							Endif
							
						ENDIF
						
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
				
				case upper(xmetodo) == 'USR_SAVE_AFTER' 				
					
					xalias=alias()	
						
						IF TYPE("cNECESSIDADE_MAT_MRP_PROG.sobra_mrp_final")<>"U"
							
							SELECT cNECESSIDADE_MAT_MRP_PROG
							GO TOP
							SCAN
								
								TEXT TO xUdt TEXTMERGE NOSHOW
									
									IF EXISTS(SELECT 1 FROM TB_NECESSIDADE_MAT_MRP_PROG (nolock)
												WHERE MATERIAL = '<<cNECESSIDADE_MAT_MRP_PROG.material>>' and
									      			  COR_MATERIAL = '<<cNECESSIDADE_MAT_MRP_PROG.cor_material>>' )
										
										UPDATE TB_NECESSIDADE_MAT_MRP_PROG
										SET NECESSIDADE_SOBRA_GERAL = <<cNECESSIDADE_MAT_MRP_PROG.sobra_mrp_final>>
										WHERE MATERIAL = '<<cNECESSIDADE_MAT_MRP_PROG.material>>' and
										      COR_MATERIAL = '<<cNECESSIDADE_MAT_MRP_PROG.cor_material>>'	
									ELSE
										BEGIN
											INSERT INTO TB_NECESSIDADE_MAT_MRP_PROG
											(MATERIAL,COR_MATERIAL,NECESSIDADE_SOBRA_GERAL)
											VALUES ('<<cNECESSIDADE_MAT_MRP_PROG.material>>',
													'<<cNECESSIDADE_MAT_MRP_PROG.cor_material>>',
													<<cNECESSIDADE_MAT_MRP_PROG.sobra_mrp_final>>)
										END
								ENDTEXT
								f_update(xUdt) 
								
								SELECT cNECESSIDADE_MAT_MRP_PROG
							ENDSCAN
							
						ENDIF
							
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
					
					
				case upper(xmetodo) == 'USR_REFRESH' 
				
					xalias=alias()	
						
						Thisformset.lx_FORM1.lx_pageframe1.page2.lx_GRID_FILHA1.Top=51
						
						If Type("Thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1.col_OP_LIBERADA.CK_LIBERAR_OP")<>"U"
							If Thisformset.p_tool_status $ 'I,A' 								
									Thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1.col_OP_LIBERADA.CK_LIBERAR_OP.Enabled= .T.
							Else
									Thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1.col_OP_LIBERADA.CK_LIBERAR_OP.Enabled= .F.
							Endif			
						Endif
						
						sele curfiliais
						IF Thisformset.p_tool_status $ "IA"
							SET FILTER TO inativo = .f. AND CTRL_PRODUCAO_PRODUTO = .t.
						ELSE 
							SET FILTER TO
						ENDIF
						GO top
						
						*** Projeto Importar Programa��o 
						*** Lucas Miranda- 25/10/2017
						If TYPE("Thisformset.lx_form1.btn_importa_prog") <> "U"
							If Thisformset.p_tool_status = 'I' 
								Thisformset.lx_form1.btn_importa_prog.enabled=.T.
								Thisformset.lx_form1.btn_importa_prog.caption='Incluir Programa��o'
							Else   
								If Thisformset.p_tool_status = 'A'
									Thisformset.lx_form1.btn_importa_prog.enabled=.T.
									Thisformset.lx_form1.btn_importa_prog.caption='Alterar Programa��o'
								Else
									Thisformset.lx_form1.btn_importa_prog.enabled=.F.
									Thisformset.lx_form1.btn_importa_prog.caption='Importar Programa��o'
								Endif	
							Endif
						Endif
						*** Fim - Projeto Importar Programa��o
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
				 
				case upper(xmetodo) == 'USR_ALTER_AFTER'				
					xalias=alias()	
						
						Sele *,QTDE_PROGRAMADA as qtde_prog_mrp ;
						from v_producao_programa_00_prod into cursor v_producao_programa_00_prod_otb		
						
						IF TYPE("cNECESSIDADE_MAT_MRP_PROG.Sobra_Mrp_Final")<>"U"
							USE IN cNECESSIDADE_MAT_MRP_PROG
						ENDIF
						
						CREATE CURSOR cNECESSIDADE_MAT_MRP_PROG;
						 (Material C(12), Cor_Material C(6), Sobra_Mrp_Final N(14,5))	

					if	!f_vazio(xalias)	
						sele &xalias 
					endif
						
				case upper(xmetodo) == 'USR_SAVE_BEFORE' 				
					xalias=alias()	

						IF TYPE("CurValidaOTB")<>"U"
							USE IN CurValidaOTB
						ENDIF
						
						sele v_producao_programa_00
						
						IF f_vazio(v_producao_programa_00.filial)
							MESSAGEBOX("Favor colocar a Filial !!!",0+48)
							RETURN .f.
						ENDIF 
						
						f_select("select COUNT(*) as xTesteFil from filiais where CTRL_PRODUCAO_PRODUTO = 1 and filial = ?v_producao_programa_00.filial","xTesteFil")
						if  xTesteFil.xTesteFil = 0
							MESSAGEBOX("Filial n�o autorizada para produ��o ou Compra !!!",0+48)
							RETURN .f.
						ENDIF 
						
						*** Verifica mais de uma data entrega por programa��o **** INICIO
						SELECT v_producao_programa_00_prod
						CALCULATE CNT(YEAR(entrega_inicial)) FOR YEAR(entrega_inicial)>2017 TO laCntDt
						CALCULATE VAR(YEAR(entrega_inicial)*MONTH(entrega_inicial)*IIF(DAY(entrega_inicial)<15,1,2)) TO laCntDist
						
						IF laCntDt>0 AND laCntDist>0 AND IIF(TYPE("thisformset.pp_anm_uma_data_prog")="U",.f.,thisformset.pp_anm_uma_data_prog)
							MESSAGEBOX("N�o � permitido mais de uma data/entrega por programa��o.",0+48,"Erro: Entrega Inicial")
							RETURN .f.
						ENDIF 	
						*** Verifica mais de uma data entrega por programa��o **** FIM
							
						*** INICIO OTB ****
						
						** Se for somente altera��o de cor, n�o efetuar a valida��o OTB - 15/09 - Solicitado por Flavia Pinho
						IF Thisformset.p_tool_status = "A"
							SELECT PRODUTO,COR_PRODUTO,ENTREGA_INICIAL,00000 AS QTDE_PROGRAMADA,matar_saldo_programacao ;
							FROM V_PRODUCAO_PROGRAMA_00_PROD WHERE 1=2 INTO CURSOR V_PRODUCAO_PROGRAMA_00_PROD_A READWRITE
							SELECT V_PRODUCAO_PROGRAMA_00_PROD
							GO TOP
							SCAN
								SELECT V_PRODUCAO_PROGRAMA_00_PROD_A
								APPEND BLANK 
								REPLACE PRODUTO WITH V_PRODUCAO_PROGRAMA_00_PROD.PRODUTO
								REPLACE COR_PRODUTO WITH V_PRODUCAO_PROGRAMA_00_PROD.COR_PRODUTO
								REPLACE ENTREGA_INICIAL WITH V_PRODUCAO_PROGRAMA_00_PROD.ENTREGA_INICIAL
								REPLACE QTDE_PROGRAMADA WITH V_PRODUCAO_PROGRAMA_00_PROD.qtde_programada 
								REPLACE MATAR_SALDO_PROGRAMACAO WITH V_PRODUCAO_PROGRAMA_00_PROD.matar_saldo_programacao 
								
								SELECT V_PRODUCAO_PROGRAMA_00_PROD
							ENDSCAN
							GO top
							
							SELECT 	NVL(a.produto,b.produto) as produto,NVL(a.entrega_inicial,b.entrega_inicial) as entrega_inicial,;
									NVL(a.qtde_prod,0) qtde_prod_a,NVL(b.qtde_prod,0) qtde_prod_b  FROM  ;
								(select produto,entrega_inicial,SUM(qtde_programada*IIF(matar_saldo_programacao = .t.,0,1)) as qtde_prod FROM V_PRODUCAO_PROGRAMA_00_PROD_A GROUP BY produto,entrega_inicial ) a;
								full join;
								(select produto,entrega_inicial,SUM(qtde_programada*IIF(matar_saldo_programacao = .t.,0,1)) as qtde_prod FROM v_producao_programa_00_prod_otb GROUP BY produto,entrega_inicial ) b;
								ON a.produto = b.produto AND a.entrega_inicial = b.entrega_inicial;
							INTO CURSOR xcur_valida_cor
							GO top

							xValidaCor = 0
							SCAN
								IF qtde_prod_a != qtde_prod_b
									xValidaCor = 1	
								ENDIF	

							ENDSCAN
							use in xcur_valida_cor
							use in V_PRODUCAO_PROGRAMA_00_PROD_A
						ELSE
							xValidaCor = 1
						ENDIF	
						** Se for somente altera��o de cor, n�o efetuar a valida��o OTB - 15/09 - Solicitado por Flavia Pinho
						
						*SELECT produto,cor_produto,entrega_inicial FROM v_producao_programa_00_prod WHERE 1=2 INTO CURSOR cteste readwrite
						SELECT v_producao_programa_00_prod
						COUNT FOR YEAR(entrega_inicial)>= IIF(TYPE("thisformset.pp_anm_valida_otb")="U",0,thisformset.pp_anm_valida_otb) TO lnReccount
						GO Top
						
						*** N�o executar para pilotagem ****
						Sele CurPropProducaoPrograma
						Locate For Propriedade == '00038'
													
						If FOUND() 
							IF LTRIM(RTRIM(CurPropProducaoPrograma.valor_propriedade)) = 'PILOTAGEM JOIAS'
								xTipoPilotagem = 1
							ELSE
								xTipoPilotagem = 0
							ENDIF
						ENDIF
												
						xValidaProdOTB=0
						IF lnReccount > 0 AND xValidaCor > 0 AND IIF(TYPE("thisformset.pp_anm_valida_otb")="U",0,thisformset.pp_anm_valida_otb)>0 AND xTipoPilotagem = 0

							IF Thisformset.p_tool_status = "A"
								SELECT v_producao_programa_00_prod
								GO top
								SCAN
								IF YEAR(v_producao_programa_00_prod.entrega_inicial) >= thisformset.pp_anm_valida_otb
									
									Sele v_producao_programa_00_prod_otb
									locate FOR produto = v_producao_programa_00_prod.produto AND ;
											   cor_produto = v_producao_programa_00_prod.cor_produto AND;
											   entrega_inicial = v_producao_programa_00_prod.entrega_inicial 
									
									IF FOUND()
										IF qtde_programada*IIF(matar_saldo_programacao = .t.,0,1)< ;
											v_producao_programa_00_prod.qtde_programada*;
											IIF(v_producao_programa_00_prod.matar_saldo_programacao = .t.,0,1)
											
											SELECT v_producao_programa_00_prod
											Replace ITEM_ALTERADO WITH .t.
											
											xValidaProdOTB=xValidaProdOTB+1
										ELSE
											SELECT v_producao_programa_00_prod
											Replace ITEM_ALTERADO WITH .f.
										ENDIF
									ELSE
										SELECT v_producao_programa_00_prod
										Replace ITEM_ALTERADO WITH .t.
										
										xValidaProdOTB=xValidaProdOTB+1
									ENDIF			
								
								ENDIF
									
									SELECT v_producao_programa_00_prod
								ENDSCAN 
							ELSE								
								IF Thisformset.p_tool_status = "E"
									xValidaProdOTB=0
								ELSE
									xValidaProdOTB=1
								ENDIF	
							ENDIF
						ENDIF
						
						IF xValidaProdOTB>0 
						
							TEXT TO xSel TEXTMERGE NOSHOW
							
								SELECT  REDE_LOJAS,MES,ANO,ENTRADA,VERBA_UTIL_ACUMULADA,VERBA_ACUMULADA,SALDO_VERBA_ACUMULADA,
										ESTOURO_DE_VERBA_ACUMULADA AS ESTOURO_DE_VERBA,VERBA_UTILIZADA,VERBA_OTB,SALDO_VERBA_OTB,
										ESTOURO_DE_VERBA_OTB,VERBA_UTILIZADA_PERIODO,VERBA_PERIODO,SALDO_VERBA_PERIODO,ESTOURO_VERBA_PERIODO,
										
										VERBA_ACUMULADA AS TOT_VERBA_PROG,SALDO_VERBA_ACUMULADA AS DISPONIVEL,
										SALDO_VERBA_PERIODO AS DISPONIVEL_PERIODO
								FROM FN_OTB_PRODUTOS_VERBA_PROG('') WHERE 1=2
							
							ENDTEXT
							f_select(xSel,"CurValidaOTB",ALIAS())
							
							SELECT v_producao_programa_00_prod
							GO TOP
							
							SCAN
								xEntregaInicial = v_producao_programa_00_prod.entrega_inicial
								IF v_producao_programa_00_prod.ITEM_ALTERADO = .t.

									REPLACE ALL ITEM_ALTERADO WITH .t. FOR entrega_inicial = xEntregaInicial
								ENDIF
							ENDSCAN
							GO TOP
							
							xValorTotOTBsave = 0.00
							xMsgErro = ''
							xCurValidaOTBExc=0						
													
							
							xRec = RECCOUNT()
							xRecn = 0
							SCAN
							
							xRecn = xRecn+1
							f_wait("Consultando verba ... Aguarde!"+CHR(13)+ALLT(STR(xRecn/xRec*100))+ "% Conclu�do",xRec)
							
							IF v_producao_programa_00_prod.ITEM_ALTERADO = .t.
							
								xValorOTBItem = 0.00
								xDataEntregaNum=YEAR(entrega_inicial)*MONTH(entrega_inicial)*IIF(DAY(entrega_inicial)<15,1,2)
								
								f_select("Select rede_lojas from produtos where produto = ?v_producao_programa_00_prod.produto","xRedeLoja")
								f_select("SELECT ISNULL(CUSTO_EFETIVO,CUSTO_MEDIO_PREVISTO) as Custo FROM GS_CUSTO_GERENCIAL_RESUMIDO WHERE PRODUTO=?v_producao_programa_00_prod.produto","xProdPreco")
								IF RECCOUNT()=0
									MESSAGEBOX("Custo Previsto do produto igual a zero."+CHR(13)+"Imposs�vel continuar salvando.",64,"Erro Custo produto")
									f_wait()
									RETURN .f.
								ENDIF 
								xValorOTBItem = IIF(iif(v_producao_programa_00_prod.qtde_em_op<0,0,v_producao_programa_00_prod.qtde_em_op)>0,;
														iif(v_producao_programa_00_prod.qtde_em_op<0,0,v_producao_programa_00_prod.qtde_em_op),;
														(v_producao_programa_00_prod.qtde_programada*IIF(v_producao_programa_00_prod.matar_saldo_programacao = .t.,0,1));
													)*xProdPreco.custo

								xValorTotOTBsave = xValorTotOTBsave + xValorOTBItem
							
								Sele CurValidaOTB
								LOCATE FOR MES = month(v_producao_programa_00_prod.entrega_inicial) AND;
										   ANO = year(v_producao_programa_00_prod.entrega_inicial)  AND;
										   ENTRADA = IIF(DAY(v_producao_programa_00_prod.entrega_inicial)<15,1,2) AND;
										   REDE_LOJAS = xRedeLoja.rede_lojas
							
								IF FOUND()
									REPLACE VERBA_UTIL_ACUMULADA    WITH VERBA_UTIL_ACUMULADA+xValorOTBItem
									REPLACE SALDO_VERBA_ACUMULADA   WITH VERBA_ACUMULADA-(VERBA_UTIL_ACUMULADA+xValorOTBItem)
									REPLACE VERBA_UTILIZADA_PERIODO WITH VERBA_UTILIZADA_PERIODO+xValorOTBItem
									REPLACE SALDO_VERBA_PERIODO     WITH VERBA_PERIODO-(VERBA_UTILIZADA_PERIODO+xValorOTBItem)	

									xEstouroVerba = iif(VERBA_UTILIZADA_PERIODO>VERBA_PERIODO,1,0)
									IF xEstouroVerba = 0
										xEstouroVerba = iif(VERBA_UTIL_ACUMULADA>VERBA_ACUMULADA,1,0)
									ELSE
										REPLACE DISPONIVEL WITH DISPONIVEL_PERIODO	
									ENDIF		
									
									REPLACE ESTOURO_DE_VERBA 	 	WITH xEstouroVerba
									REPLACE TOT_VERBA_PROG   	    WITH TOT_VERBA_PROG+xValorOTBItem  	
								ELSE
								
									TEXT TO xSel TEXTMERGE NOSHOW
									
										SELECT 
												REDE_LOJAS,MES,ANO,ENTRADA,
												VERBA_UTIL_ACUMULADA+<<xValorOTBItem>> AS VERBA_UTIL_ACUMULADA,
												VERBA_ACUMULADA,
												VERBA_ACUMULADA-(VERBA_UTIL_ACUMULADA+<<xValorOTBItem>>) AS SALDO_VERBA_ACUMULADA,
													ESTOURO_DE_VERBA_ACUMULADA AS ESTOURO_DE_VERBA,
												VERBA_UTILIZADA+<<xValorOTBItem>> AS VERBA_UTILIZADA,
												VERBA_OTB,
												VERBA_OTB-(VERBA_UTILIZADA+<<xValorOTBItem>>) AS SALDO_VERBA_OTB,
													ESTOURO_DE_VERBA_OTB,
												VERBA_UTILIZADA_PERIODO+<<xValorOTBItem>> AS VERBA_UTILIZADA_PERIODO,
												VERBA_PERIODO,
												VERBA_PERIODO-(VERBA_UTILIZADA_PERIODO+<<xValorOTBItem>>) AS SALDO_VERBA_PERIODO,
													ESTOURO_VERBA_PERIODO,
									
												<<xValorOTBItem>> AS TOT_VERBA_PROG,SALDO_VERBA_ACUMULADA AS DISPONIVEL,
												SALDO_VERBA_PERIODO AS DISPONIVEL_PERIODO 

										FROM FN_OTB_PRODUTOS_VERBA_PROG('<<v_producao_programa_00.programacao>>')
											WHERE 	REDE_LOJAS = '<<xRedeLoja.rede_lojas>>' 						AND
													MES = <<month(v_producao_programa_00_prod.entrega_inicial)>> 	AND
													ANO = <<year(v_producao_programa_00_prod.entrega_inicial)>>		AND
													ENTRADA = <<IIF(DAY(v_producao_programa_00_prod.entrega_inicial)<15,1,2)>>
													
									ENDTEXT
									f_select(xSel,"CurValidaOTB_TEMP")
									
									IF RECCOUNT()=0 AND xCurValidaOTBExc <> xDataEntregaNum
										xMsgErro = xMsgErro +;
											   "REDE LOJA: "+ALLTRIM(xRedeLoja.rede_lojas)+;
											   " | DATA: "+ALLTRIM(STR(month(v_producao_programa_00_prod.entrega_inicial)))+;
											   "/"+ALLTRIM(STR(year(v_producao_programa_00_prod.entrega_inicial)))+;
											   " - ENTRADA: "+ALLTRIM(STR(IIF(DAY(v_producao_programa_00_prod.entrega_inicial)<15,1,2)))+CHR(13)+;
											   "PROG: "+ALLTRIM(TRANSFORM(xValorTotOTBsave,'9,999,999,999.99'))+;
											   " | DISP: Verba N�o Lan�ada"+CHR(13)+CHR(13)
										
										xCurValidaOTBExc = xDataEntregaNum
									ELSE
										INSERT INTO CurValidaOTB SELECT * FROM CurValidaOTB_TEMP
										
										sele CurValidaOTB
										xEstouroVerba = iif(VERBA_UTILIZADA_PERIODO>VERBA_PERIODO,1,0)
										IF xEstouroVerba = 0
											xEstouroVerba = iif(VERBA_UTIL_ACUMULADA>VERBA_ACUMULADA,1,0)
										ELSE
											REPLACE DISPONIVEL WITH DISPONIVEL_PERIODO	
										ENDIF	
										
										SELECT CurValidaOTB
										REPLACE ESTOURO_DE_VERBA WITH xEstouroVerba
												
									ENDIF
								ENDIF

							ENDIF	

								SELECT v_producao_programa_00_prod				   
							endscan
							f_wait()
							GO top
							
							SELECT CurValidaOTB
							GO TOP

							SCAN
								IF CurValidaOTB.ESTOURO_DE_VERBA = 1
									
									xMsgErro = xMsgErro +;
											   "REDE LOJA: "+ALLTRIM(CurValidaOTB.rede_lojas)+;
											   " | DATA: "+ALLTRIM(STR(CurValidaOTB.MES))+"/"+ALLTRIM(STR(CurValidaOTB.ANO))+;
											   " - ENTRADA: "+ALLTRIM(STR(CurValidaOTB.ENTRADA))+CHR(13)+;
											   "PROG: "+ALLTRIM(TRANSFORM(CurValidaOTB.TOT_VERBA_PROG,'9,999,999,999.99'))+;
											   " | DISP: "+ALLTRIM(TRANSFORM(CurValidaOTB.DISPONIVEL,'9,999,999,999.99'))+;
											   " | DIF: "+ALLTRIM(TRANSFORM(CurValidaOTB.DISPONIVEL-CurValidaOTB.TOT_VERBA_PROG,'9,999,999,999.99'))+;
											   CHR(13)+CHR(13)

								ENDIF
								
								SELECT CurValidaOTB
							ENDSCAN
														
							IF !f_vazio(xMsgErro)
								xMsgErro = "Estouro de Verba, imposs�vel efetuar altera��o."+CHR(13)+CHR(13)+xMsgErro	
								MESSAGEBOX(xMsgErro,64,"Estouro de Verba")
								RETURN .F.
							ENDIF	
						
						ENDIF
						*** FIM OTB ****						
						
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
																
				otherwise
				return .t.				
			endcase

	
	endproc

	* Inclui Nova Procedure na Classe da Tela >> Dentro de Activate da Guia Materiais
	
	Procedure COL_OP_LIBERADA
		
		f_select("select valor_propriedade from prop_produtos where propriedade = '00036' and produto =?v_producao_programa_00_prod.produto","CurPropProd",ALIAS())
		IF CurPropProd.valor_propriedade = "PRODUTO ACABADO"
			IF v_producao_programa_00_prod.anm_op_liberada = .t.
				IF ! Thisformset.pp_anm_perm_bloq_prod_prog
					MESSAGEBOX("Voc� n�o tem permiss�o de bloquear produto",64,"Aviso!")
					Thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1.col_op_liberada.CK_LIBERAR_OP.Value = 0
				ENDIF
			ELSE
				IF MESSAGEBOX("Aten��o!"+CHR(13)+"Antes de confirmar, verifique grade e custo."+CHR(13)+;
						      "Ap�s confirmar, essa informa��o n�o poder� ser alterada."+CHR(13)+CHR(13)+;
						      "Voc� confirma o desbloqueio desse Produto para emiss�o de pedido?",32+4+256," ALERTA") = 7
					
					Thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1.col_op_liberada.CK_LIBERAR_OP.Value = 1
				ENDIF		   
			ENDIF				
		ENDIF
		
	Endproc
	* Inclui Nova Procedure na Classe da Tela >> Dentro de Activate da Guia Materiais
ENDDEFINE



**************************************************
*-- Class:        ck_matar_saldo_total (c:\temp\v7\ck_matar_saldo_total.vcx)
*-- ParentClass:  lx_checkbox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   05/20/09 06:31:00 PM
**
DEFINE CLASS ck_matar_saldo_total AS lx_checkbox


	Top = 44
	Left = 582
	Height = 15
	Width = 102
	FontName = "Tahoma"
	FontSize = 8
	WordWrap = .F.
	Alignment = 0
	Caption = "Matar Saldo Total"
	Value = .F.
	ControlSource = "v_producao_programa_00.anm_zerar_saldos"
	TabIndex = 5
	p_tipo_dado = "EDITA"
	Name = "ck_matar_saldo_total"
	Visible = .T.
	Enabled = .T.

	PROCEDURE l_desenhista_recalculo
		IF this.Value=.f.
			This.Parent.lx_combobox1.Value =2 
			This.Parent.lx_combobox1.Refresh() 
		endif 
	ENDPROC


	*PROCEDURE Refresh
	*	This.L_DESENHISTA_RECALCULO
	*ENDPROC


ENDDEFINE
*
*-- EndDefine: ck_matar_saldo_total
**************************************************


**************************************************
*-- Class:        ck_matar_saldo_produto (c:\temp\v7\ck_matar_saldo_produto.vcx)
*-- ParentClass:  lx_checkbox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   05/20/09 06:31:05 PM
*
*
DEFINE CLASS ck_matar_saldo_produto AS lx_checkbox


	Top = 7
	Left = 690
	Height = 28
	Width = 101
	FontName = "Tahoma"
	FontSize = 8
	WordWrap = .T.
	Alignment = 0
	Caption = "Matar Saldo Reserva Produto"
	Value = .F.
	ControlSource = "v_producao_programa_00_prod.anm_matar_saldo"
	TabIndex = 5
	p_tipo_dado = "EDITA"
	Name = "ck_matar_saldo_produto"
	Visible = .T.
	Enabled = .T.


	PROCEDURE Refresh
		*This.L_DESENHISTA_RECALCULO
	ENDPROC


	PROCEDURE l_desenhista_recalculo
		*This.Parent.LX_GRID_FILHA1.L_ESCONDE_COLUNA('Column61',This.Value)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ck_matar_saldo_produto
**************************************************

**************************************************
*-- Class:        bloqueia (c:\users\julio.cesar\onedrive - fabula confeccao e comercio de roupas ltda - epp\julio\classes\bloqueia.vcx)
*-- ParentClass:  botao (c:\linx grupo soma\linx\exclusivos\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/29/17 05:35:14 PM
DEFINE CLASS bloqueia AS botao


	Top = 32
	Left = 10
	Height = 18
	Width = 67
	Caption = "Bloqueia"
	Name = "bt_bloq"
	Visible = .T.
	Enabled = .T.


	PROCEDURE Click
		IF Thisformset.p_tool_status = 'A' 

			IF ! Thisformset.pp_anm_perm_bloq_prod_prog 
				MESSAGEBOX("Voc� n�o tem permiss�o de bloquear produto",64,"Aviso!")
				return .f.
			ENDIF
		ELSE
			IF Thisformset.p_tool_status $ 'I,A' 
				o_gs.l_marca_todos('v_producao_programa_00_prod','anm_op_liberada','.t.')
			ENDIF
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bloqueia
**************************************************

**************************************************
*-- Class:        desbloqueia (c:\users\julio.cesar\onedrive - fabula confeccao e comercio de roupas ltda - epp\julio\classes\desbloqueia.vcx)
*-- ParentClass:  botao (c:\linx grupo soma\linx\exclusivos\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/29/17 05:36:03 PM
DEFINE CLASS desbloqueia AS botao


	Top = 32
	Left = 78
	Height = 18
	Width = 67
	Caption = "Desbloqueia"
	Name = "bt_desbloq"
	Visible = .T.
	Enabled = .T.

	PROCEDURE Click
		IF Thisformset.p_tool_status $ 'I,A' 
			o_gs.l_marca_todos('v_producao_programa_00_prod','anm_op_liberada','.f.')
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: desbloqueia
**************************************************
**************************************************
*-- Class:        btn_importa_prog (e:\linx_sql_fontecompleta\class pessoal\btn_importa_prog.vcx)
*-- ParentClass:  botao (e:\linx_sql_fontecompleta\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/25/17 06:02:01 PM
*
*#INCLUDE "e:\linx\exclusivos\formtool\lx_const.h"
*
DEFINE CLASS btn_importa_prog AS botao

 
	Top = 60
	Left = 579
	Height = 25
	Width = 132
	Caption = "Importar Programa��o"
	ToolTipText = [Importar Programa��o]
	Name = "btn_importa_prog"
	Visible = .T.

	PROCEDURE Click
		strcaminho = getfile("xls?","Importar Arquivo","Importar",0,"Importar Arquivo")

		if empty(NVL(strcaminho,''))
			messagebox("Opera��o Cancelada!",0+64,"Arquivo Inv�lido!")
			return .f.
		endif

		F_wait("Importando as informa��es, Aguarde...")

		if used("CUR_IMPORT")
			use in CUR_IMPORT
		endif

		TEXT TO xCUR_IMPORT TEXTMERGE NOSHOW
			
			SELECT CAST(PROGRAMACAO as varchar(40)) as PROGRAMACAO, CAST('' AS VARCHAR(25)) AS FILIAL, CAST('' AS VARCHAR(70)) AS COLECAO, CAST('' AS NUMERIC(2,0)) AS REDE_LOJAS, 
			CAST('' AS VARCHAR(3)) AS LIBERADO, CAST('' AS VARCHAR(70)) AS TIPO_PROGRAMACAO,
			CAST(ANM_OP_LIBERADA AS INT) AS BLOQUEIA, PRODUTO, COR_PRODUTO, ENTREGA_INICIAL AS ENTREGA, ENTREGA_FINAL AS LIMITE, QTDE_PROGRAMADA AS QTDE, 
			P1 as T1, P2 as T2, P3 AS T3, P4 AS T4, P5 AS T5, P6 AS T6, P7 AS T7, P8 AS T8, P9 AS T9, P10 AS T10, P11 AS T11, P12 AS T12, P13 AS T13, P14 AS T14, 
			P15 AS T15, P16 AS T16, ENTREGA_INICIAL AS ENTREGA_NOVA, ENTREGA_FINAL AS LIMITE_NOVA, CAST(MATAR_SALDO_PROGRAMACAO AS INT) AS MATAR_SALDO
			FROM PRODUCAO_PROG_PROD					
			where 1=2
							
		ENDTEXT
							
		f_select(xCUR_IMPORT,"CUR_IMPORT")

		try
						objxls 			= createobject("excel.application")
						objworkbook 	= objxls.workbooks.open(strcaminho)
						objsheet 		= objworkbook.sheets(1)
						iRowsSheet 		= objsheet.Rows.Count
						iPermitido 	    = 65000
						iImatrizIni		= 2 
						iImatrizFim		= iPermitido 
						iPercorrido     = 1 

						IF (MOD(iRowsSheet , iPermitido ) > 0 )
							iPercorrer = (ROUND(iRowsSheet/iPermitido,0))+1
						ELSE 
							iPercorrer = (iRowsSheet/iPermitido)
						ENDIF

						IF  upper(alltrim(objsheet.cells(1,1).text)) <> "PROGRAMACAO" OR ;
							upper(alltrim(objsheet.cells(1,2).text)) <> "FILIAL" OR ;
						 	upper(alltrim(objsheet.cells(1,3).text)) <> "COLECAO" OR ;
							upper(alltrim(objsheet.cells(1,4).text)) <> "REDE_LOJAS" OR ;
							upper(alltrim(objsheet.cells(1,5).text)) <> "LIBERADO" OR ;
							upper(alltrim(objsheet.cells(1,6).text)) <> "TIPO_PROGRAMACAO" OR ;
							upper(alltrim(objsheet.cells(1,7).text)) <> "BLOQUEIA" OR ;
								upper(alltrim(objsheet.cells(1,8).text))<> "PRODUTO" OR ;
									upper(alltrim(objsheet.cells(1,9).text))<> "COR_PRODUTO" OR ;
										upper(alltrim(objsheet.cells(1,10).text))<> "ENTREGA" OR ;
											upper(alltrim(objsheet.cells(1,11).text))<> "LIMITE" OR ;
												upper(alltrim(objsheet.cells(1,12).text))<> "QTDE" OR ;
														upper(alltrim(objsheet.cells(1,13).text))<> "T1" OR upper(alltrim(objsheet.cells(1,14).text))<> "T2" OR ;
														upper(alltrim(objsheet.cells(1,15).text))<> "T3" OR upper(alltrim(objsheet.cells(1,16).text))<> "T4" OR ;
														upper(alltrim(objsheet.cells(1,17).text))<> "T5" OR upper(alltrim(objsheet.cells(1,18).text))<> "T6" OR ;
														upper(alltrim(objsheet.cells(1,19).text))<> "T7" OR upper(alltrim(objsheet.cells(1,20).text))<> "T8" OR ;
														upper(alltrim(objsheet.cells(1,21).text))<> "T9" OR upper(alltrim(objsheet.cells(1,22).text))<> "T10" OR ;
														upper(alltrim(objsheet.cells(1,23).text))<> "T11" OR upper(alltrim(objsheet.cells(1,24).text))<> "T12" OR ;
														upper(alltrim(objsheet.cells(1,25).text))<> "T13" OR upper(alltrim(objsheet.cells(1,26).text))<> "T14" OR ;
														upper(alltrim(objsheet.cells(1,27).text))<> "T15" OR upper(alltrim(objsheet.cells(1,28).text))<> "T16" OR ;
														upper(alltrim(objsheet.cells(1,29).text))<> "ENTREGA_NOVA" OR upper(alltrim(objsheet.cells(1,30).text))<> "LIMITE_NOVA" OR ;
														upper(alltrim(objsheet.cells(1,31).text))<> "MATAR_SALDO"
							MESSAGEBOX("O Layout do Arquivo � Inv�lido, O Cabe�alho deve Conter as Seguintes Informa��es:"+CHR(10)+"PROGRAMACAO C�lula A"+CHR(10)+;
										"FILIAL C�lula B"+CHR(10)+"COLECAO C�lula C"+CHR(10)+"REDE_LOJAS C�lula D"+CHR(10)+"LIBERADO C�lula E"+CHR(10)+;
										"TIPO_PROGRAMACAO C�lula F"+CHR(10)+"BLOQUEIA C�lula G"+CHR(10)+"PRODUTO C�lula H"+CHR(10)+"COR_PRODUTO C�lula I"+CHR(10)+"ENTREGA C�lula J"+CHR(10)+;
										"LIMITE C�lula K"+CHR(10)+"QTDE C�lula L"+CHR(10)+"T1 C�lula M"+CHR(10)+"T2 C�lula N"+CHR(10)+;
										"T3 C�lula O"+CHR(10)+"T4 C�lula P"+CHR(10)+"T5 C�lula Q"+CHR(10)+"T6 C�lula R"+CHR(10)+;
										"T7 C�lula S"+CHR(10)+"T8 C�lula T"+CHR(10)+"T9 C�lula U"+CHR(10)+"T10 C�lula V"+CHR(10)+;
										"T11 C�lula W"+CHR(10)+"T12 C�lula X"+CHR(10)+"T13 C�lula Y"+CHR(10)+"T14 C�lula Z"+CHR(10)+;
										"T15 C�lula AA"+CHR(10)+"T16 C�lula AB"+CHR(10)+"ENTREGA_NOVA C�lula AC"+CHR(10)+"LIMITE_NOVA C�lula AD"+CHR(10)+;
										"MATAR_SALDO C�lula AE",0+16,"Obj - Layout Inv�lido")
							return .f.
							*GO to oexception
						ENDIF

						IF f_vazio(alltrim(objsheet.cells(iPermitido,1).text)) 
							objsheetRange   = objsheet.range(objsheet.cells(iImatrizIni,1),objsheet.cells(iImatrizFim,31)).value
							SELECT CUR_IMPORT
							APPEND FROM array objsheetRange   
						ELSE 
							DO WHILE iPercorrer >= iPercorrido      

								objsheetRange   = objsheet.range(objsheet.cells(iImatrizIni,1),objsheet.cells(iImatrizFim,31)).value

								SELECT CUR_IMPORT
								APPEND FROM array objsheetRange

								iPercorrido = iPercorrido + 1
								iImatrizIni = IIF(iImatrizIni==2,1 + iPermitido,iImatrizIni + iPermitido)
								iImatrizFim = IIF((iImatrizFim + iPermitido) < iRowsSheet, iImatrizFim + iPermitido, iRowsSheet )
							ENDDO

						ENDIF


						objworkbook.close()
						release objsheet
						release objworkbook
						release objxls 


					catch to oexception

						objworkbook.close()
						release objsheet
						release objworkbook
						release objxls 
					ENDTRY


					if type("oexception") = "O"
						f_wait()
						return.f.
					ENDIF
				
				f_wait()
				
				CurCartaoNaoImportado = ""
				xCartaoNaoImportado = 0
				xGetDate = DTOS(DATE())
				xCountReg = 0
				xTRit = 0
				xMsgErro = ''
				xMsgCabe = ''
				xProduto = ''
				xCorProd = ''

				SELECT cur_import
				DELETE FROM cur_import WHERE f_vazio(PRODUTO)
				
				*** Incluindo Programa��o - Modo Incluir
				If o_008006.lx_form1.btn_importa_prog.Caption='Incluir Programa��o'	
					F_wait("Validando as informa��es do Cabe�alho, Aguarde...")
					*** Verifica Programa��o ***
					SELECT DISTINCT PROGRAMACAO FROM cur_import where !f_vazio(PROGRAMACAO) INTO CURSOR CUR_PROG_DUPL
					If RECCOUNT("CUR_PROG_DUPL") > 1
						xMsgCabe = xMsgCabe + CHR(13)+"- Existe mais de uma programa��o informada na planilha !"+CHR(13)
					ELSE
						f_select("select * from producao_programa where programacao=?CUR_PROG_DUPL.programacao","CurProgEx")
						If RECCOUNT("CurProgEx")>0
							xMsgCabe = xMsgCabe + CHR(13)+"- Nome da programa��o j� existe no banco de dados !"+CHR(13)
						Endif
					Endif
					
					*** Verifica Datas ****
					SELECT DISTINCT ENTREGA FROM cur_import WHERE !f_vazio(PRODUTO) AND DTOC(entrega)='  /  /       :  :   AM' INTO CURSOR CUR_PROG_ENTR 										
					If RECCOUNT("CUR_PROG_ENTR") > 0
						xMsgCabe = xMsgCabe + CHR(13)+"- Entrega est� em branco!"+CHR(13)
					Endif
					
					SELECT DISTINCT LIMITE FROM cur_import WHERE !f_vazio(PRODUTO) AND DTOC(limite)='  /  /       :  :   AM' INTO CURSOR CUR_PROG_LIM										
					If RECCOUNT("CUR_PROG_LIM") > 0
						xMsgCabe = xMsgCabe + CHR(13)+"- Limite est� em branco!"+CHR(13)
					Endif
					*** Fim Verifica Datas ***
					
					*** Verificar Filial ***
					SELECT DISTINCT FILIAL FROM cur_import where !f_vazio(FILIAL) INTO CURSOR CUR_PROG_FIL
					If RECCOUNT("CUR_PROG_FIL") > 1
						xMsgCabe = xMsgCabe + CHR(13)+"- Existe mais de um registro Filial informado na planilha !"+CHR(13)
					ELSE
						f_select("select a.* from filiais a join cadastro_cli_for b on a.filial = b.nome_clifor where b.inativo = 0 and a.CTRL_PRODUCAO_PRODUTO = 1 and filial=?CUR_PROG_FIL.FILIAL","CurProgFil")
						If RECCOUNT("CurProgFil")=0
							xMsgCabe = xMsgCabe + CHR(13)+"- Filial Informada n�o pode ser preenchida !"+CHR(13)
						Endif
					Endif
	 
					*** Verifica Programa��o ***
					SELECT DISTINCT LEN(ALLTRIM(PROGRAMACAO)) AS QTD_CAMPO FROM cur_import where !f_vazio(PROGRAMACAO) AND LEN(ALLTRIM(PROGRAMACAO)) > 25 INTO CURSOR CUR_PROG_QTD
					If RECCOUNT("CUR_PROG_QTD") > 0
						xMsgCabe = xMsgCabe + CHR(13)+"- Nome da programa��o maior que o permitido, o m�ximo � 25 caracteres !"+CHR(13)
					Endif
					
					*** Verificar Colecao
					SELECT DISTINCT COLECAO FROM cur_import where !f_vazio(COLECAO) INTO CURSOR CUR_PROG_COL
					If RECCOUNT("CUR_PROG_COL") > 1
						xMsgCabe = xMsgCabe + CHR(13)+"- Existe mais de uma cole��o informada na planilha !"+CHR(13)
					ELSE
						f_select("SELECT VALOR_PROPRIEDADE AS COLECAO FROM PROPRIEDADE_VALIDA WHERE PROPRIEDADE='00060' AND VALOR_PROPRIEDADE=?CUR_PROG_COL.COLECAO","CurProgCol")
						If RECCOUNT("CurProgCol")=0
							xMsgCabe = xMsgCabe + CHR(13)+"- Nome da Cole��o n�o existe no banco de dados !"+CHR(13)
						Endif
					Endif
					
					*** Verificar Propriedade Rede Loja***
					SELECT DISTINCT REDE_LOJAS FROM cur_import where !f_vazio(REDE_LOJAS) INTO CURSOR CUR_PROG_RL
					If RECCOUNT("CUR_PROG_RL") > 1
						xMsgCabe = xMsgCabe + CHR(13)+"- Existe mais de uma rede_lojas informada na planilha !"+CHR(13)
					ELSE
						f_select("SELECT REDE_LOJAS FROM LOJAS_REDE WHERE REDE_LOJAS=?CUR_PROG_RL.REDE_LOJAS","CurProgExRL")
						If RECCOUNT("CurProgExRL")=0
							xMsgCabe = xMsgCabe + CHR(13)+"- Rede Loja n�o existe no banco de dados !"+CHR(13)
						Endif
					Endif

					*** Verificar Propriedade Liberado***
					SELECT DISTINCT LIBERADO FROM cur_import where !f_vazio(LIBERADO) INTO CURSOR CUR_PROG_LIB
					If RECCOUNT("CUR_PROG_LIB") > 1
						xMsgCabe = xMsgCabe + CHR(13)+"- Existe mais de um registro Liberado informado na planilha !"+CHR(13)
					ELSE
						f_select("SELECT VALOR_PROPRIEDADE AS LIBERADO FROM PROPRIEDADE_VALIDA WHERE PROPRIEDADE='00181' AND VALOR_PROPRIEDADE=?CUR_PROG_LIB.LIBERADO","CurProgExLib")
						If RECCOUNT("CurProgExLib")=0
							xMsgCabe = xMsgCabe + CHR(13)+"- Liberado informado n�o existe no banco de dados !"+CHR(13)
						Endif
					Endif
					
					*** Verificar Tipo Programa��o***
					SELECT DISTINCT TIPO_PROGRAMACAO FROM cur_import where !f_vazio(TIPO_PROGRAMACAO) INTO CURSOR CUR_PROG_TIPO
					If RECCOUNT("CUR_PROG_TIPO") > 1
						xMsgCabe = xMsgCabe + CHR(13)+"- Existe mais de um registro Tipo_Programa��o informado na planilha !"+CHR(13)
					ELSE
						f_select("SELECT VALOR_PROPRIEDADE AS TIPO_PROGRAMACAO FROM PROPRIEDADE_VALIDA WHERE PROPRIEDADE='00038' AND VALOR_PROPRIEDADE=?CUR_PROG_TIPO.TIPO_PROGRAMACAO","CurProgExTP")
						If RECCOUNT("CurProgExTP")=0
							xMsgCabe = xMsgCabe + CHR(13)+"- Tipo de Programa��o informado n�o existe no banco de dados !"+CHR(13)
						Endif
					Endif
					
					If !F_Vazio(xMsgCabe)
						If USED("CUR_PROG_DUPL")
							USE IN CUR_PROG_DUPL
						Endif
							
						If USED("CurProgEx")
							USE IN CurProgEx
						Endif
						
						If USED("CUR_PROG_FIL")
							USE IN CUR_PROG_FIL
						Endif
						
						If USED("CurProgFil")
							USE IN CurProgFil
						Endif
										
						If USED("CUR_PROG_QTD")
							USE IN CUR_PROG_QTD
						Endif
						
						If USED("CUR_PROG_COL")
							USE IN CUR_PROG_COL
						Endif
							
						If USED("CurProgCol")
							USE IN CurProgCol
						Endif
						
						If USED("CUR_PROG_RL")
							USE IN CUR_PROG_RL
						Endif
							
						If USED("CurProgExRL")
							USE IN CurProgExRL
						Endif
						
						If USED("CUR_PROG_LIB")
							USE IN CUR_PROG_LIB
						Endif
							
						If USED("CurProgExLib")
							USE IN CurProgExLib
						Endif
						
						If USED("CUR_PROG_TIPO")
							USE IN CUR_PROG_TIPO
						Endif
						
						If USED("CurProgExTP")
							USE IN CurProgExTP
						Endif
						
						If USED("CUR_PROG_ENTR")
							USE IN CUR_PROG_ENTR
						Endif
						
						If USED("CUR_PROG_LIM")
							USE IN CUR_PROG_LIM
						Endif
						
						f_wait()
						
						MESSAGEBOX("N�o foi poss�vel montar o cabe�alho da programa��o, cont�m os erros abaixo: "+CHR(13)+xMsgCabe+CHR(13)+;
								   "Favor acertar na planilha !!!",0+16,"Cabe�alho")
						Return .F.		   
					Endif
					
					*** Verifica��o de Produto e Cor ***
					F_wait("Validando as informa��es do Produto, Aguarde...")
					
					If !DIRECTORY("C:\TEMP\IMPORT_PROGRAMACAO") 
						MD "C:\TEMP\IMPORT_PROGRAMACAO"
					ENDIF
					
					If USED("CurVerProd")
						USE IN CurVerProd
					Endif

					If USED("CurProdCor")
						USE IN CurProdCor
					Endif
					
					If USED("vErroProdCor")
						USE IN vErroProdCor
					Endif

					f_select("select produto, cor_produto from PRODUTO_CORES (nolock)","CurProdCor")
					Sele CurProdCor
					
					Sele cur_import
					DELETE FROM cur_import WHERE f_vazio(produto)
					
					
					Select a.produto, a.cor_produto, 'PRODUTO/COR INCORRETO' AS OBS;
					FROM cur_import a LEFT JOIN CurProdCor b ON a.produto = b.produto AND a.cor_produto = b.cor_produto ;
					where b.produto is null ;
					INTO cursor CurVerProd READWRITE 
					
					If RECCOUNT("CurVerProd")>0
						xMsgErro = xMsgErro + CHR(13)+"- Existe(m) produto(s)/cor informado incorreto, nome do arquivo: Erro_Produto_Cor"+CHR(13)
							
						SELECT produto, cor_produto, obs from CurVerProd WHERE !f_vazio(PRODUTO) INTO CURSOR vErroProdCor READWRITE 
						
						Sele vErroProdCor
						DELETE FROM vErroProdCor WHERE f_vazio(PRODUTO)
						COPY TO c:\temp\import_programacao\erro_prod_cor xl5

					Endif

					*** Verifica��o de arquivo Grade***

					If USED("CurVerGrade")
						USE IN CurVerGrade
					Endif

					If USED("CurGrade")
						USE IN CurGrade
					Endif

					If USED("CurTamanhos")
						USE IN CurTamanhos
					Endif

					f_select("select produto, CAST('' as varchar(25)) as obs from produtos (nolock) where 1=2","CurVerGrade")
					
					Sele cur_import
					DELETE FROM cur_import WHERE f_vazio(produto)
					
					
					Select a.* ;
					FROM cur_import a LEFT JOIN CurProdCor b ON a.produto = b.produto AND a.cor_produto = b.cor_produto ;
					where b.produto is not null ;
					INTO cursor CurVerProdGrade READWRITE 
					
					Sele CurVerProdGrade
					Go Top
					Scan					
						TEXT TO xTamanhos TEXTMERGE NOSHOW
							Select a.produto,c.* 
							FROM produtos (nolock) a
							join PRODUTO_CORES (nolock) b
							ON a.produto = b.produto
							join produtos_tamanhos (nolock) c
							ON a.grade = c.grade
							where b.produto='<<CurVerProdGrade.produto>>'
							and b.cor_produto='<<CurVerProdGrade.cor_produto>>'
						ENDTEXT 
						
						f_Select(xTamanhos,"CurTamanhos")
						Sele CurTamanhos

						If RECCOUNT("CurTamanhos") > 0
						
							IF (CurVerProdGrade.t1 > 0 AND F_Vazio(CurTamanhos.tamanho_1) OR CurVerProdGrade.t2 > 0 AND F_Vazio(CurTamanhos.tamanho_2) OR ;
								CurVerProdGrade.t3 > 0 AND F_Vazio(CurTamanhos.tamanho_3) OR CurVerProdGrade.t4 > 0 AND F_Vazio(CurTamanhos.tamanho_4) OR ;
								CurVerProdGrade.t5 > 0 AND F_Vazio(CurTamanhos.tamanho_5) OR CurVerProdGrade.t6 > 0 AND F_Vazio(CurTamanhos.tamanho_6) OR ;
								CurVerProdGrade.t7 > 0 AND F_Vazio(CurTamanhos.tamanho_7) OR CurVerProdGrade.t8 > 0 AND F_Vazio(CurTamanhos.tamanho_8) OR ;
								CurVerProdGrade.t9 > 0 AND F_Vazio(CurTamanhos.tamanho_9) OR CurVerProdGrade.t10 > 0 AND F_Vazio(CurTamanhos.tamanho_10) OR ;
								CurVerProdGrade.t11 > 0 AND F_Vazio(CurTamanhos.tamanho_11) OR CurVerProdGrade.t12 > 0 AND F_Vazio(CurTamanhos.tamanho_12) OR ;
								CurVerProdGrade.t13 > 0 AND F_Vazio(CurTamanhos.tamanho_13) OR CurVerProdGrade.t14 > 0 AND F_Vazio(CurTamanhos.tamanho_14) OR ;
								CurVerProdGrade.t15 > 0 AND F_Vazio(CurTamanhos.tamanho_15) OR CurVerProdGrade.t16 > 0 AND F_Vazio(CurTamanhos.tamanho_16);
								)	
								INSERT INTO CurVerGrade(produto, obs) SELECT produto, 'ERRO DE GRADE' as obs FROM CurVerProdGrade WHERE produto = CurTamanhos.produto
							Endif
						Endif
					Sele CurVerProdGrade
					ENDSCAN
	 
					If RECCOUNT("CurVerGrade")>0					
						xMsgErro = xMsgErro + CHR(13)+"- Existe(m) produto(s) no arquivo Com Grade Incorreta, nome do arquivo: Erro_Grade"+CHR(13)
							
						Select distinct produto, obs from CurVerGrade INTO CURSOR xErroGrade readwrite
						
						Sele xErroGrade
						=cursorset('buffering',3)
						COPY TO c:\temp\import_programacao\erro_grade xl5
					Endif
					
					
					IF USED("vErroProdCor") and USED("xErroGrade") 
						f_wait()
						If RECCOUNT("vErroProdCor") > 0 AND RECCOUNT("xErroGrade") > 0
						
							If USED("CurProdErrosJuntos")
								USE IN CurProdErrosJuntos
							Endif
							
							SELECT produto, cor_produto, obs FROM vErroProdCor;
							UNION ALL ;
							SELECT produto, '', obs FROM xErroGrade ;
							INTO CURSOR CurProdErrosJuntos READWRITE 
							
							Sele CurProdErrosJuntos
							DELETE FROM CurProdErrosJuntos WHERE f_vazio(PRODUTO)
							
							=cursorset('buffering',3)
							COPY TO c:\temp\import_programacao\erro_geral xl5
						Endif	
					Endif
						
					If !F_Vazio(xMsgErro)
						
						IF USED("CurProdErrosJuntos")
							IF MESSAGEBOX("FAVOR VERIFICAR NO CAMINHO: "+"'"+"C:\TEMP\IMPORT_PROGRAMACAO\"+"'"+" O ERRO!!!"+CHR(13)+"Deseja abrir o arquivo Erro_Geral.xls ?",4+16,"Importa��o")=6
								f_wait()

									system.file.FileOpen("c:\temp\import_programacao\erro_geral.xls")
									
									release CurProdErrosJuntos

									Return .F.
							Else
								F_wait()
								Return .F.
							Endif
						ELSE
							IF MESSAGEBOX("FAVOR VERIFICAR NO CAMINHO: "+"'"+"C:\TEMP\IMPORT_PROGRAMACAO\"+"'"+" OS ERROS!!!"+CHR(13)+xMsgErro+CHR(13)+"Deseja abrir os arquivos ?",4+16,"Importa��o")=6								
								If RECCOUNT("CurVerProd")>0
									f_wait()
									
									system.file.FileOpen("c:\temp\import_programacao\erro_prod_cor.xls")
									release CurVerProd
										
									If USED("CurVerProd")
										USE IN CurVerProd
									Endif

									If USED("CurProdCor")
										USE IN CurProdCor
									Endif
									
									If USED("vErroProdCor")
										USE IN vErroProdCor
									Endif
								Else
									F_wait()
									release CurVerProd
							
									If USED("CurVerProd")
										USE IN CurVerProd
									Endif

									If USED("CurProdCor")
										USE IN CurProdCor
									Endif
								Endif
								
								IF RECCOUNT("xErroGrade") > 0
										f_wait()
										
										release xErroGrade
										
										If USED("CurVerGrade")
											USE IN CurVerGrade
										Endif

										If USED("CurGrade")
											USE IN CurGrade
										Endif

										If USED("CurTamanhos")
											USE IN CurTamanhos
										Endif
										
										system.file.FileOpen("c:\temp\import_programacao\erro_grade.xls")
								Else
										F_wait()
										release xErroGrade
										
										If USED("CurVerGrade")
											USE IN CurVerGrade
										Endif

										If USED("CurGrade")
											USE IN CurGrade
										Endif

										If USED("CurTamanhos")
											USE IN CurTamanhos
										Endif
								Endif
							Endif
							F_wait()
							Return .F.
						ENDIF
					Endif
					F_wait("Importando as informa��es !!!, Aguarde...")
					
					**** Importa��o Cabecalho
					Sele v_producao_programa_00
					
					Sele cur_import
					LOCATE FOR !f_vazio(cur_import.programacao)
					Replace v_producao_programa_00.programacao WITH UPPER(cur_import.programacao)
					
					Sele cur_import
					LOCATE FOR !f_vazio(cur_import.filial)
					Replace v_producao_programa_00.filial WITH UPPER(cur_import.filial)
					
					Sele curpropproducaoprograma
					LOCATE FOR curpropproducaoprograma.propriedade='00060'				
					Sele cur_import
					LOCATE FOR !f_vazio(cur_import.colecao)
					replace curpropproducaoprograma.valor_propriedade with UPPER(cur_import.colecao)
					   
					Sele curpropproducaoprograma
					LOCATE FOR curpropproducaoprograma.propriedade='01005'
					Sele cur_import
					LOCATE FOR !f_vazio(cur_import.rede_lojas)				
					replace curpropproducaoprograma.valor_propriedade with ALLTRIM(STR(cur_import.rede_lojas))
					
					Sele curpropproducaoprograma
					LOCATE FOR curpropproducaoprograma.propriedade='00181'
					Sele cur_import
					LOCATE FOR !f_vazio(cur_import.liberado)	
					replace curpropproducaoprograma.valor_propriedade with UPPER(cur_import.liberado)
					
					Sele curpropproducaoprograma
					LOCATE FOR curpropproducaoprograma.propriedade='00038'
					Sele cur_import
					LOCATE FOR !f_vazio(cur_import.tipo_programacao)
					replace curpropproducaoprograma.valor_propriedade with UPPER(cur_import.tipo_programacao)
					**** Importa��o Produtos
					Sele cur_import
					Go Top
					SCAN
						o_008006.lx_form1.lx_pageframe1.page2.lX_TOOL_GRID_FILHA1.cmDINCLUIRFILHA.Click
						
						sele v_producao_programa_00_prod
						
						replace v_producao_programa_00_prod.anm_op_liberada WITH IIF(cur_import.bloqueia=1,.T.,.F.)
						
						replace v_producao_programa_00_prod.produto WITH cur_import.produto
						o_008006.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_TV_PRODUTO.tv_PRODUTO.Value=cur_import.produto

						replace v_producao_programa_00_prod.cor_produto WITH cur_import.cor_produto
						o_008006.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_tv_COR_PRODUTO.tv_COR_PRODUTO.Value=cur_import.cor_produto
						o_008006.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.COL_TV_COR_PRODUTO.tv_COR_PRODUTO.l_desenhista_recalculo()
						
						replace v_producao_programa_00_prod.entrega_inicial WITH cur_import.entrega
						o_008006.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_tx_ENTREGA_INICIAL.tx_ENTREGA_INICIAL.Value=cur_import.entrega
						
						replace v_producao_programa_00_prod.entrega_final WITH cur_import.limite
						o_008006.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_tx_ENTREGA_FINAL.tx_ENTREGA_FINAL.Value=cur_import.limite
						
						replace v_producao_programa_00_prod.p1  with cur_import.t1
						replace v_producao_programa_00_prod.p2  with cur_import.t2
						replace v_producao_programa_00_prod.p3  with cur_import.t3
						replace v_producao_programa_00_prod.p4  with cur_import.t4
						replace v_producao_programa_00_prod.p5  with cur_import.t5
						replace v_producao_programa_00_prod.p6  with cur_import.t6
						replace v_producao_programa_00_prod.p7  with cur_import.t7
						replace v_producao_programa_00_prod.p8  with cur_import.t8
						replace v_producao_programa_00_prod.p8  with cur_import.t9
						replace v_producao_programa_00_prod.p10 with cur_import.t10
						replace v_producao_programa_00_prod.p11 with cur_import.t11
						replace v_producao_programa_00_prod.p12 with cur_import.t12
						replace v_producao_programa_00_prod.p13 with cur_import.t13
						replace v_producao_programa_00_prod.p14 with cur_import.t14
						replace v_producao_programa_00_prod.p15 with cur_import.t15
						replace v_producao_programa_00_prod.p16 with cur_import.t16
						
						o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
						 
						Sele cur_import
					Endscan
					
					f_wait()
				Endif	

			**************************************** 
			****************************************
			****************************************
			****************************************						
			*** Incluindo Programa��o - Modo Alterar
				If o_008006.lx_form1.btn_importa_prog.Caption='Alterar Programa��o'	
				xImport=1
					F_wait("Validando as informa��es do Cabe�alho, Aguarde...")
					*** Verifica Programa��o ***
					SELECT DISTINCT PROGRAMACAO FROM cur_import where !f_vazio(PROGRAMACAO) INTO CURSOR CUR_PROG_DUPL
					If RECCOUNT("CUR_PROG_DUPL") > 1
						xMsgCabe = xMsgCabe + CHR(13)+"- Existe mais de uma programa��o informada na planilha !"+CHR(13)
					Endif

					xProgCorr=0
					SELECT DISTINCT PROGRAMACAO FROM cur_import where !f_vazio(PROGRAMACAO) INTO CURSOR CUR_PROG_CORR
					Sele CUR_PROG_CORR
					Go Top
					Scan
						If CUR_PROG_CORR.programacao != v_producao_programa_00.programacao and xProgCorr = 0
							xProgCorr = 1
							xMsgCabe = xMsgCabe + CHR(13)+"- Programa��o informada n�o corresponde a programa��o selecionada !"+CHR(13)
						Endif
					EndScan
					
					*** Verifica Data ***
					SELECT DISTINCT ENTREGA FROM cur_import WHERE !f_vazio(PRODUTO) AND DTOC(entrega)='  /  /       :  :   AM' INTO CURSOR CUR_PROG_ENTR
					Sele CUR_PROG_ENTR
					If RECCOUNT("CUR_PROG_ENTR") > 0
						xMsgCabe = xMsgCabe + CHR(13)+"- Entrega est� em branco!"+CHR(13)
					Endif
						
					SELECT DISTINCT LIMITE FROM cur_import WHERE !f_vazio(PRODUTO) AND DTOC(limite)='  /  /       :  :   AM' INTO CURSOR CUR_PROG_LIM										
					If RECCOUNT("CUR_PROG_LIM") > 0
						xMsgCabe = xMsgCabe + CHR(13)+"- Limite est� em branco!"+CHR(13)
					Endif
					
					*** Verifica Data Entrega Nova maior que o limite ***
					xProgDataNova=0
					SELECT DISTINCT ENTREGA_NOVA, LIMITE, LIMITE_NOVA FROM cur_import WHERE !f_vazio(PRODUTO) AND DTOC(entrega_nova)<>'  /  /       :  :   AM' INTO CURSOR CUR_ENTR_NOVA
					If RECCOUNT("CUR_ENTR_NOVA") > 0
						Sele CUR_ENTR_NOVA
						Go Top
						Scan				
							If DTOC(CUR_ENTR_NOVA.limite_nova)='  /  /       :  :   AM' and xProgDataNova=0
								If CUR_ENTR_NOVA.entrega_nova > CUR_ENTR_NOVA.limite
									xProgDataNova=1
									xMsgCabe = xMsgCabe + CHR(13)+"- Data de Entrega Maior que a Data Limite existente !"+CHR(13)
								Endif
							Else
								If CUR_ENTR_NOVA.entrega_nova > CUR_ENTR_NOVA.limite_nova and xProgDataNova=0
									xProgDataNova=1
									xMsgCabe = xMsgCabe + CHR(13)+"- Data de Entrega Maior que a Data Limite Nova !"+CHR(13)
								Endif
							Endif
						Sele CUR_ENTR_NOVA
						EndScan
					Endif
					
					If !F_Vazio(xMsgCabe)
						If USED("CUR_PROG_DUPL")
							USE IN CUR_PROG_DUPL
						Endif
						
						If USED("CUR_PROG_ENTR")
							USE IN CUR_PROG_ENTR
						Endif
						
						If USED("CUR_PROG_LIM")
							USE IN CUR_PROG_LIM
						Endif					
					
						f_wait()
						
						MESSAGEBOX("N�o foi poss�vel montar o cabe�alho da programa��o, cont�m os erros abaixo: "+CHR(13)+xMsgCabe+CHR(13)+;
								   "Favor acertar na planilha !!!",0+16,"Cabe�alho")
						Return .F.		   
					Endif
					
					*** Verifica��o de Produto e Cor ***
					F_wait("Validando as informa��es do Produto, Aguarde...")
					
					If !DIRECTORY("C:\TEMP\IMPORT_PROGRAMACAO") 
						MD "C:\TEMP\IMPORT_PROGRAMACAO"
					ENDIF
					
					If USED("CurVerProd")
						USE IN CurVerProd
					Endif

					If USED("CurProdCor")
						USE IN CurProdCor
					Endif
					
					If USED("vErroProdCor")
						USE IN vErroProdCor
					Endif
					
					If USED("CUR_PROG_ENTR")
						USE IN CUR_PROG_ENTR
					Endif
						
					If USED("CUR_PROG_LIM")
						USE IN CUR_PROG_LIM
					Endif
					
					f_select("select produto, cor_produto from PRODUTO_CORES (nolock)","CurProdCor")
					Sele CurProdCor
					
					Sele cur_import
					DELETE FROM cur_import WHERE f_vazio(produto)
					
					
					Select a.produto, a.cor_produto, 'PRODUTO/COR INCORRETO' AS OBS;
					FROM cur_import a LEFT JOIN CurProdCor b ON a.produto = b.produto AND a.cor_produto = b.cor_produto ;
					where b.produto is null ;
					INTO cursor CurVerProd READWRITE 
					
					If RECCOUNT("CurVerProd")>0
						xMsgErro = xMsgErro + CHR(13)+"- Existe(m) produto(s)/cor informado incorreto, nome do arquivo: Erro_Produto_Cor"+CHR(13)
							
						SELECT produto, cor_produto, obs from CurVerProd WHERE !f_vazio(PRODUTO) INTO CURSOR vErroProdCor READWRITE 
						
						Sele vErroProdCor
						DELETE FROM vErroProdCor WHERE f_vazio(PRODUTO)
						COPY TO c:\temp\import_programacao\erro_prod_cor xl5

					Endif

					*** Verifica��o de arquivo Grade***

					If USED("CurVerGrade")
						USE IN CurVerGrade
					Endif

					If USED("CurGrade")
						USE IN CurGrade
					Endif

					If USED("CurTamanhos")
						USE IN CurTamanhos
					Endif

					f_select("select produto, CAST('' as varchar(25)) as obs from produtos (nolock) where 1=2","CurVerGrade")
					
					Sele cur_import
					DELETE FROM cur_import WHERE f_vazio(produto)
					
					
					Select a.* ;
					FROM cur_import a LEFT JOIN CurProdCor b ON a.produto = b.produto AND a.cor_produto = b.cor_produto ;
					where b.produto is not null ;
					INTO cursor CurVerProdGrade READWRITE 
					
					Sele CurVerProdGrade
					Go Top
					Scan					
						TEXT TO xTamanhos TEXTMERGE NOSHOW
							Select a.produto,c.* 
							FROM produtos (nolock) a
							join PRODUTO_CORES (nolock) b
							ON a.produto = b.produto
							join produtos_tamanhos (nolock) c
							ON a.grade = c.grade
							where b.produto='<<CurVerProdGrade.produto>>'
							and b.cor_produto='<<CurVerProdGrade.cor_produto>>'
						ENDTEXT 
						
						f_Select(xTamanhos,"CurTamanhos")
						Sele CurTamanhos

						If RECCOUNT("CurTamanhos") > 0
						
							IF (CurVerProdGrade.t1 > 0 AND F_Vazio(CurTamanhos.tamanho_1) OR CurVerProdGrade.t2 > 0 AND F_Vazio(CurTamanhos.tamanho_2) OR ;
								CurVerProdGrade.t3 > 0 AND F_Vazio(CurTamanhos.tamanho_3) OR CurVerProdGrade.t4 > 0 AND F_Vazio(CurTamanhos.tamanho_4) OR ;
								CurVerProdGrade.t5 > 0 AND F_Vazio(CurTamanhos.tamanho_5) OR CurVerProdGrade.t6 > 0 AND F_Vazio(CurTamanhos.tamanho_6) OR ;
								CurVerProdGrade.t7 > 0 AND F_Vazio(CurTamanhos.tamanho_7) OR CurVerProdGrade.t8 > 0 AND F_Vazio(CurTamanhos.tamanho_8) OR ;
								CurVerProdGrade.t9 > 0 AND F_Vazio(CurTamanhos.tamanho_9) OR CurVerProdGrade.t10 > 0 AND F_Vazio(CurTamanhos.tamanho_10) OR ;
								CurVerProdGrade.t11 > 0 AND F_Vazio(CurTamanhos.tamanho_11) OR CurVerProdGrade.t12 > 0 AND F_Vazio(CurTamanhos.tamanho_12) OR ;
								CurVerProdGrade.t13 > 0 AND F_Vazio(CurTamanhos.tamanho_13) OR CurVerProdGrade.t14 > 0 AND F_Vazio(CurTamanhos.tamanho_14) OR ;
								CurVerProdGrade.t15 > 0 AND F_Vazio(CurTamanhos.tamanho_15) OR CurVerProdGrade.t16 > 0 AND F_Vazio(CurTamanhos.tamanho_16);
								)	
								INSERT INTO CurVerGrade(produto, obs) SELECT produto, 'ERRO DE GRADE' as obs FROM CurVerProdGrade WHERE produto = CurTamanhos.produto
							Endif
						Endif
					Sele CurVerProdGrade
					ENDSCAN
	 
					If RECCOUNT("CurVerGrade")>0					
						xMsgErro = xMsgErro + CHR(13)+"- Existe(m) produto(s) no arquivo Com Grade Incorreta, nome do arquivo: Erro_Grade"+CHR(13)
							
						Select distinct produto, obs from CurVerGrade INTO CURSOR xErroGrade readwrite
						
						Sele xErroGrade
						=cursorset('buffering',3)
						COPY TO c:\temp\import_programacao\erro_grade xl5
					Endif
					
					
					IF USED("vErroProdCor") and USED("xErroGrade") 
						f_wait()
						If RECCOUNT("vErroProdCor") > 0 AND RECCOUNT("xErroGrade") > 0
						
							If USED("CurProdErrosJuntos")
								USE IN CurProdErrosJuntos
							Endif
							
							SELECT produto, cor_produto, obs FROM vErroProdCor;
							UNION ALL ;
							SELECT produto, '', obs FROM xErroGrade ;
							INTO CURSOR CurProdErrosJuntos READWRITE 
							
							Sele CurProdErrosJuntos
							DELETE FROM CurProdErrosJuntos WHERE f_vazio(PRODUTO)
							
							=cursorset('buffering',3)
							COPY TO c:\temp\import_programacao\erro_geral xl5
						Endif	
					Endif
						
					If !F_Vazio(xMsgErro)
						
						IF USED("CurProdErrosJuntos")
							IF MESSAGEBOX("FAVOR VERIFICAR NO CAMINHO: "+"'"+"C:\TEMP\IMPORT_PROGRAMACAO\"+"'"+" O ERRO!!!"+CHR(13)+"Deseja abrir o arquivo Erro_Geral.xls ?",4+16,"Importa��o")=6
								f_wait()

									system.file.FileOpen("c:\temp\import_programacao\erro_geral.xls")
									
									release CurProdErrosJuntos

									Return .F.
							Else
								F_wait()
								Return .F.
							Endif
						ELSE
							IF MESSAGEBOX("FAVOR VERIFICAR NO CAMINHO: "+"'"+"C:\TEMP\IMPORT_PROGRAMACAO\"+"'"+" OS ERROS!!!"+CHR(13)+xMsgErro+CHR(13)+"Deseja abrir os arquivos ?",4+16,"Importa��o")=6								
								If RECCOUNT("CurVerProd")>0
									f_wait()
									
									system.file.FileOpen("c:\temp\import_programacao\erro_prod_cor.xls")
									release CurVerProd
										
									If USED("CurVerProd")
										USE IN CurVerProd
									Endif

									If USED("CurProdCor")
										USE IN CurProdCor
									Endif
									
									If USED("vErroProdCor")
										USE IN vErroProdCor
									Endif
								Else
									F_wait()
									release CurVerProd
							
									If USED("CurVerProd")
										USE IN CurVerProd
									Endif

									If USED("CurProdCor")
										USE IN CurProdCor
									Endif
								Endif
								
								IF RECCOUNT("xErroGrade") > 0
										f_wait()
										
										release xErroGrade
										
										If USED("CurVerGrade")
											USE IN CurVerGrade
										Endif

										If USED("CurGrade")
											USE IN CurGrade
										Endif

										If USED("CurTamanhos")
											USE IN CurTamanhos
										Endif
										
										system.file.FileOpen("c:\temp\import_programacao\erro_grade.xls")
								Else
										F_wait()
										release xErroGrade
										
										If USED("CurVerGrade")
											USE IN CurVerGrade
										Endif

										If USED("CurGrade")
											USE IN CurGrade
										Endif

										If USED("CurTamanhos")
											USE IN CurTamanhos
										Endif
								Endif
							Endif
							F_wait()
							Return .F.
						ENDIF
					Endif
					F_wait("Importando as informa��es !!!, Aguarde...")
					
					**** Importa��o Produtos
					Sele cur_import 	
					DELETE FROM cur_import WHERE f_vazio(PRODUTO)
					
					*** Altera��o de grade ***
					IF USED("vProdNaoExiste")
						USE IN vProdNaoExiste
					Endif
					
					SELECT a.* FROM cur_import a JOIN v_producao_programa_00_prod b ;
					ON a.produto = b.produto AND a.cor_produto = b.cor_produto AND a.entrega = b.entrega_inicial ;
					INTO CURSOR vProdAltGrade					
					*WHERE b.qtde_em_op = 0 
					 
					If RECCOUNT("vProdAltGrade") > 0
						Sele vProdAltGrade
						GO TOP 
						Scan
							*If v_producao_programa_00_prod.qtde_em_op = 0
								Sele v_producao_programa_00_prod
								LOCATE FOR produto = vProdAltGrade.produto ;
									   AND cor_produto = vProdAltGrade.cor_produto ;
								   	   AND entrega_inicial= vProdAltGrade.entrega
								   	   
								   	   If !F_Vazio(vProdAltGrade.bloqueia) AND (IIF(vProdAltGrade.bloqueia=1,.T.,.F.) != v_producao_programa_00_prod.anm_op_liberada)
								   	   		replace v_producao_programa_00_prod.anm_op_liberada WITH IIF(cur_import.bloqueia=1,.T.,.F.)
								   	   		o_008006.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_OP_LIBERADA.CK_LIBERAR_OP.Value=vProdAltGrade.bloqueia
								   	   Endif 
								   	   
								   	   If !f_vazio(vProdAltGrade.entrega_nova) AND v_producao_programa_00_prod.entrega_inicial <> vProdAltGrade.entrega_nova
								   	   		replace v_producao_programa_00_prod.entrega_inicial WITH vProdAltGrade.entrega_nova
											o_008006.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_tx_ENTREGA_INICIAL.tx_ENTREGA_INICIAL.Value=vProdAltGrade.entrega_nova
								   	   Endif
								   	   
								   	   If !f_vazio(vProdAltGrade.limite_nova) AND v_producao_programa_00_prod.entrega_final <> vProdAltGrade.limite_nova
								   	  	 	replace v_producao_programa_00_prod.entrega_final WITH vProdAltGrade.limite_nova
											o_008006.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_tx_ENTREGA_FINAL.tx_ENTREGA_FINAL.Value=vProdAltGrade.limite_nova
								   	   Endif
								   	   
								   	   If !F_Vazio(vProdAltGrade.matar_saldo) AND (IIF(vProdAltGrade.matar_saldo=1,.T.,.F.) != v_producao_programa_00_prod.matar_saldo_programacao)
								   	   	   replace v_producao_programa_00_prod.matar_saldo_programacao WITH IIF(vProdAltGrade.matar_saldo=1,.T.,.F.)
										   o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_ck_MATAR_SALDO_PROGRAMACAO.ck_MATAR_SALDO_PROGRAMACAO.Value=IIF(vProdAltGrade.matar_saldo=1,.T.,.F.)
										   o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
										   o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_ck_MATAR_SALDO_PROGRAMACAO.ck_MATAR_SALDO_PROGRAMACAO.When 
										   If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif	
									   Endif
									   
									   If vProdAltGrade.t1 != v_producao_programa_00_prod.p1
									   		replace v_producao_programa_00_prod.p1 WITH vProdAltGrade.t1
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_1.Value=vProdAltGrade.t1
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_1.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif						
									   
									   If vProdAltGrade.t2 != v_producao_programa_00_prod.p2
									   		
									   		replace v_producao_programa_00_prod.p2 WITH vProdAltGrade.t2
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_2.Value=vProdAltGrade.t2
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_2.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif 
									   
									   If vProdAltGrade.t3 != v_producao_programa_00_prod.p3
									   		replace v_producao_programa_00_prod.p3 WITH vProdAltGrade.t3
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_3.Value=vProdAltGrade.t3
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_3.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif						
									   
									   If vProdAltGrade.t4 != v_producao_programa_00_prod.p4
									   		
									   		replace v_producao_programa_00_prod.p4 WITH vProdAltGrade.t4
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_4.Value=vProdAltGrade.t4
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_4.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif 
									   
									   If vProdAltGrade.t5 != v_producao_programa_00_prod.p5
									   		replace v_producao_programa_00_prod.p5 WITH vProdAltGrade.t5
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_5.Value=vProdAltGrade.t5
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_5.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif						
									   
									   If vProdAltGrade.t6 != v_producao_programa_00_prod.p6
									   		
									   		replace v_producao_programa_00_prod.p6 WITH vProdAltGrade.t6
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_6.Value=vProdAltGrade.t6
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_6.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif 	
									   
									   If vProdAltGrade.t7 != v_producao_programa_00_prod.p7
									   		replace v_producao_programa_00_prod.p7 WITH vProdAltGrade.t7
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_7.Value=vProdAltGrade.t7
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_7.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif						
									   
									   If vProdAltGrade.t8 != v_producao_programa_00_prod.p8
									   		
									   		replace v_producao_programa_00_prod.p8 WITH vProdAltGrade.t8
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_8.Value=vProdAltGrade.t8
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_8.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif 
									   
									   If vProdAltGrade.t9 != v_producao_programa_00_prod.p9
									   		replace v_producao_programa_00_prod.p9 WITH vProdAltGrade.t9
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_9.Value=vProdAltGrade.t9
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_9.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif						
									   
									   If vProdAltGrade.t10 != v_producao_programa_00_prod.p10
									   		
									   		replace v_producao_programa_00_prod.p10 WITH vProdAltGrade.t10
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_10.Value=vProdAltGrade.t10
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_10.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif 
									   
									   If vProdAltGrade.t11 != v_producao_programa_00_prod.p11
									   		replace v_producao_programa_00_prod.p11 WITH vProdAltGrade.t11
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_11.Value=vProdAltGrade.t11
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_11.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif						
									   
									   If vProdAltGrade.t12 != v_producao_programa_00_prod.p12
									   		
									   		replace v_producao_programa_00_prod.p12 WITH vProdAltGrade.t12
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_12.Value=vProdAltGrade.t12
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_12.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif  
									   
									   If vProdAltGrade.t13 != v_producao_programa_00_prod.p13
									   		replace v_producao_programa_00_prod.p13 WITH vProdAltGrade.t13
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_13.Value=vProdAltGrade.t13
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_13.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif						
									   
									   If vProdAltGrade.t14 != v_producao_programa_00_prod.p14
									   		
									   		replace v_producao_programa_00_prod.p14 WITH vProdAltGrade.t14
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_14.Value=vProdAltGrade.t14
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_2.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif  
									   
									   If vProdAltGrade.t15 != v_producao_programa_00_prod.p15
									   
									   		replace v_producao_programa_00_prod.p15 WITH vProdAltGrade.t15
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_15.Value=vProdAltGrade.t15
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_15.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif						
									   
									   If vProdAltGrade.t16 != v_producao_programa_00_prod.p16
									   		
									   		replace v_producao_programa_00_prod.p16 WITH vProdAltGrade.t16
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_16.Value=vProdAltGrade.t16
									   		o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
									   		o_008006.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.col_TX_QTDE_PROGRAMADA.Lx_grade48_1.GRADE.tx_16.When
									   		If xErroImport = 1
									   			f_wait()
									   			RETURN .f.
									   		Endif
									   Endif 
							
							*Endif
						Sele v_producao_programa_00_prod	
						Endscan	
					Endif
					
					*** Fim - Altera��o de grade ***
					
					**** Inclui Produto que n�o existe na programa��o ****
					Sele cur_import 	
					DELETE FROM cur_import WHERE f_vazio(PRODUTO)
					
					IF USED("vProdNaoExiste")
						USE IN vProdNaoExiste
					Endif
					
					SELECT a.* FROM cur_import a LEFT JOIN v_producao_programa_00_prod b ;
					ON a.produto = b.produto AND a.cor_produto = b.cor_produto AND a.entrega = b.entrega_inicial ;
					WHERE b.produto is null INTO CURSOR vProdNaoExiste
					
					If RECCOUNT("vProdNaoExiste") > 0
						Sele vProdNaoExiste
						Go Top
						Scan
							o_008006.lx_form1.lx_pageframe1.page2.lX_TOOL_GRID_FILHA1.cmDINCLUIRFILHA.Click
						
							sele v_producao_programa_00_prod
							
							replace v_producao_programa_00_prod.anm_op_liberada WITH IIF(vProdNaoExiste.bloqueia=1,.T.,.F.)
							o_008006.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_OP_LIBERADA.CK_LIBERAR_OP.Value=vProdNaoExiste.bloqueia
							
							replace v_producao_programa_00_prod.produto WITH vProdNaoExiste.produto
							o_008006.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_TV_PRODUTO.tv_PRODUTO.Value=vProdNaoExiste.produto

							replace v_producao_programa_00_prod.cor_produto WITH vProdNaoExiste.cor_produto
							o_008006.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_tv_COR_PRODUTO.tv_COR_PRODUTO.Value=vProdNaoExiste.cor_produto
							o_008006.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.COL_TV_COR_PRODUTO.tv_COR_PRODUTO.l_desenhista_recalculo()
							
							replace v_producao_programa_00_prod.entrega_inicial WITH vProdNaoExiste.entrega
							o_008006.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_tx_ENTREGA_INICIAL.tx_ENTREGA_INICIAL.Value=vProdNaoExiste.entrega
						
							replace v_producao_programa_00_prod.entrega_final WITH vProdNaoExiste.limite
							o_008006.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_tx_ENTREGA_FINAL.tx_ENTREGA_FINAL.Value=vProdNaoExiste.limite
							
							replace v_producao_programa_00_prod.p1  with vProdNaoExiste.t1
							replace v_producao_programa_00_prod.p2  with vProdNaoExiste.t2
							replace v_producao_programa_00_prod.p3  with vProdNaoExiste.t3
							replace v_producao_programa_00_prod.p4  with vProdNaoExiste.t4
							replace v_producao_programa_00_prod.p5  with vProdNaoExiste.t5
							replace v_producao_programa_00_prod.p6  with vProdNaoExiste.t6
							replace v_producao_programa_00_prod.p7  with vProdNaoExiste.t7
							replace v_producao_programa_00_prod.p8  with vProdNaoExiste.t8
							replace v_producao_programa_00_prod.p8  with vProdNaoExiste.t9
							replace v_producao_programa_00_prod.p10 with vProdNaoExiste.t10
							replace v_producao_programa_00_prod.p11 with vProdNaoExiste.t11
							replace v_producao_programa_00_prod.p12 with vProdNaoExiste.t12
							replace v_producao_programa_00_prod.p13 with vProdNaoExiste.t13
							replace v_producao_programa_00_prod.p14 with vProdNaoExiste.t14
							replace v_producao_programa_00_prod.p15 with vProdNaoExiste.t15
							replace v_producao_programa_00_prod.p16 with vProdNaoExiste.t16
						
							o_008006.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_tx_qtde_programada.lx_grade48_1.l_somargrade()
							
						Sele vProdNaoExiste	
						EndScan
						
						IF USED("vProdNaoExiste")
							USE IN vProdNaoExiste
						Endif	
						
						****Fim -  Inclui Produto que n�o existe na programa��o ****
					Endif
					
					f_wait()
				Endif
				
	
	
	ENDPROC
	
ENDDEFINE
*
*-- EndDefine: btn_importa_prog
**************************************************
**************************************************
*-- Class:        btn_ajuda (e:\linx_sql_fontecompleta\class pessoal\btn_ajuda.vcx)
*-- ParentClass:  botao (e:\linx_sql_fontecompleta\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/25/17 06:02:07 PM
*
*#INCLUDE "e:\linx\exclusivos\formtool\lx_const.h"
*
DEFINE CLASS btn_ajuda AS botao


	Top = 60
	Left = 710
	Height = 25
	Width = 26
	Picture = ("botao_ajuda.jpg")
	ToolTipText = [Ajuda]
	Caption = ""
	Name = "btn_ajuda"
	Visible = .T.
	
	PROCEDURE CLICK
	
		If MESSAGEBOX("Deseja abrir o manual de importar programa��o ?",4+32,"Importar") = 6
			system.file.FileOpen(wdir+"\Linx\Tutoriais\Manual Importar Programa��o.pdf")
		Endif

	ENDPROC	

ENDDEFINE
*
*-- EndDefine: btn_ajuda
**************************************************