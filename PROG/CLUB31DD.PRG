*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : CLUB31DD                         vrs 001 �
*� VRS 001        : Implantacao                              �
*� FINALIDADE     : Lista de SOCIOS DESATIVADOS              �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            �
*� DATA CRIACAO   : 11/01/1995                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf,{"NOME"       ,"C",   50,0})
AADD(aDbf,{"MATRICULA"  ,"C",    5,0})
AADD(aDbf,{"ENDERECO"   ,"C",   60,0})
AADD(aDbf,{"BAIRRO"     ,"C",   15,0})
AADD(aDbf,{"CIDADE"     ,"C",   15,0})
AADD(aDbf,{"ESTADO"     ,"C",    2,0})
AADD(aDbf,{"CEP"        ,"C",    8,0})
AADD(aDbf,{"LOTACAO"    ,"C",   25,0})
AADD(aDbf,{"FUNCAO"     ,"C",   20,0})
AADD(aDbf,{"TEL"        ,"C",   10,0})
AADD(aDbf,{"MOTIVO"     ,"C",   60,0})
WHILE .T.
   sHour:=TIME()
   cArq1:="TM"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE(cArq1,aDbf); RELEASE aDbf; EXIT
   ENDIF
ENDDO
SELECT 10
NetUse(cArq1,,"E")
INDEX ON nome TO (cArq1)

SELECT 6
IF NetUse("UNIDADE")
   SET INDEX TO DBIUNID1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 7
IF NetUse("AREAC")
   SET INDEX TO DBIAREA1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("FUNC")
   SET INDEX TO DBIFUNC2,DBIFUNC1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("CATEG")
   SET INDEX TO DBICATE1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("SOCIOSI")
   SET INDEX TO DBISOCI2,DBISOCI1,DBISOCI3
ELSE
   DelDbfNtx(); RETURN
ENDIF

ProgName("GC31D")
SET KEY -1 TO Mostra()
Telas(15,3,21,59,1,YCOREDIT,.T.)
WHILE .T.
   SETCOLOR(YCOREDIT)
   wCat     := SPACE(2) ; wFuncao := SPACE(20) ; wLotacao := SPACE(25)
   wUnidade := SPACE(8) ; wDscrArea := SPACE(30) ; wArea := SPACE(2)
   nQtdSoc  := 0 ; lAchou := .F.; wDevice:=" "; wDescr:=SPACE(30)

   Mensagem("Preencha os campos necess�rios")
   @ 16,05 SAY "Categoria:" GET wCat       PICT "99"    WHEN TeclaFuncao(.T.) ;
     VALID EMPTY(wCat).OR.PTab(wCat,2,1,"Categoria N�o Cadastrada")
   @ 17,05 SAY "     Area:" GET wArea      PICT "@!"    WHEN TeclaFuncao(.T.);
     VALID EMPTY(wArea).OR.PTab(wArea,7,1,"Area de Compet�ncia N�o Cadastrada")
   @ 18,05 SAY "  Lota��o:" GET wLotacao   PICT "@!"    WHEN TeclaFuncao()
   @ 19,05 SAY "  Unidade:" GET wUnidade   PICT "@!"    WHEN TeclaFuncao(.T.) ;
     VALID EMPTY(wUnidade).OR.PTab(wUnidade,6,1,"Unidade N�o Cadastrada")
   @ 20,05 SAY "    Sa�da:" GET wDevice    PICT "!" WHEN HTela(5) VALID VTela(5)
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      IF LEN(Telas)==4; Rest_Tela(); ENDIF
      EXIT
   ENDIF

   IF !EMPTY(wCat); wDescr:=CATEG->DESCR; ENDIF
   
   SELECT SOCIOSI; DBSETORDER(1)
   IF wDevice=="I"
      IF !EMPTY(wCat)
         SET ORDER TO 3
         lAchou := DBSEEK(wCat)
      ENDIF
      IF !EMPTY(wArea).AND.!lAchou
         SET ORDER TO 6
         lAchou := DBSEEK(wArea)
         IF !lAchou
            SET ORDER TO 7
            lAchou := DBSEEK(wArea)
         ENDIF
      ENDIF
      IF !EMPTY(wLotacao).AND.!lAchou
         DBGOTOP()
         Aguarde("Selecionando...")
         LOCATE ALL FOR RTRIM(wLotacao) $ LOTACAO
         IF FOUND()
            lAchou := .T.
         ENDIF
         Aguarde()
      ENDIF
      IF !EMPTY(wUnidade).AND.!lAchou
         SET ORDER TO  5
         lAchou := DBSEEK(wUnidade)
      ENDIF
   ELSE
      lAchou:=.T.
   ENDIF

   IF lAchou
      IF wDevice=="I"
         IF ChkImpr()
            IF !EMPTY(wArea);wDscrArea:=AREAC->DESCR;ENDIF
            continua := .T.
            Imprimindo := MsgImp()
            Gera_TXT("CL31DD.TXT")
            pg   := 0
            lCab := CabRel("LISTA DE SOCIOS DESATIVADOS")
            SOCIOSI->(DBGOTOP())
            WHILE continua.AND.!EOF()
               lOk := .T.
               IF !lCab; lCab := CabRel("LISTA DE SOCIOS DESATIVADOS"); ENDIF
               IF EMPTY(wLotacao).AND.!EMPTY(wCat).AND.!EMPTY(wUnidade)
                  IF CATEGORIA==wCat.AND.UNIDADE==wUnidade
                     IF !EMPTY(wArea)
                        IF AREA#wArea.AND.AREA2#wArea
                           lOk := .F.
                        ENDIF
                     ENDIF
                     IF lOk
                        ImpReg()
                        Cab31dd(01,007,LOTACAO)
                        Cab31dd(00,048,CIDADE)
                        Cab31dd(00,066,FUNCAO)
                        Cab31dd(00,089,CEP,"[@R XX.XXX-XXX]")
                        Cab31dd(00,111,ESTADO)
                        Cab31dd(01,000,"")
                        nQtdSoc++
                     ENDIF
                  ENDIF
               ELSEIF EMPTY(wLotacao).AND.EMPTY(wUnidade).AND.!EMPTY(wCat)
                  IF CATEGORIA==wCat
                     IF !EMPTY(wArea)
                        IF AREA#wArea.AND.AREA2#wArea
                           lOk := .F.
                        ENDIF
                     ENDIF
                     IF lOk
                        ImpReg()
                        Cab31dd(01,007,LOTACAO)
                        Cab31dd(00,035,UNIDADE)
                        Cab31dd(00,048,CIDADE)
                        Cab31dd(00,066,FUNCAO)
                        Cab31dd(00,089,CEP,"[@R XX.XXX-XXX]")
                        Cab31dd(00,111,ESTADO)
                        Cab31dd(01,000,"")
                        nQtdSoc++
                     ENDIF
                  ENDIF
               ELSEIF EMPTY(wLotacao).AND.EMPTY(wUnidade).AND.EMPTY(wCat)
                  IF !EMPTY(wArea)
                     IF AREA#wArea.AND.AREA2#wArea
                        lOk := .F.
                     ENDIF
                  ENDIF
                  IF lOk
                     ImpReg()
                     Cab31dd(01,007,LOTACAO)
                     Cab31dd(00,035,UNIDADE)
                     Cab31dd(00,048,CIDADE)
                     Cab31dd(00,066,FUNCAO)
                     Cab31dd(00,089,CEP,"[@R XX.XXX-XXX]")
                     Cab31dd(00,111,ESTADO)
                     Cab31dd(00,121,CATEGORIA)
                     Cab31dd(01,000,"")
                     nQtdSoc++
                  ENDIF
               ELSEIF EMPTY(wCat).AND.!EMPTY(wLotacao).AND.!EMPTY(wUnidade)
                  lOk := .T.
                  IF LOTACAO==wLotacao.AND.UNIDADE==wUnidade
                     IF !EMPTY(wArea)
                        IF AREA#wArea.AND.AREA2#wArea
                           lOk := .F.
                        ENDIF
                     ENDIF
                     IF lOk
                        ImpReg()
                        Cab31dd(01,048,CIDADE)
                        Cab31dd(00,066,FUNCAO)
                        Cab31dd(00,089,CEP,"[@R XX.XXX-XXX]")
                        Cab31dd(00,111,ESTADO)
                        Cab31dd(00,121,CATEGORIA)
                        Cab31dd(01,000,"")
                        nQtdSoc++
                     ENDIF
                  ENDIF
               ELSEIF EMPTY(wCat).AND.EMPTY(wLotacao).AND.!EMPTY(wUnidade)
                  lOk := .T.
                  IF UNIDADE==wUnidade
                     IF !EMPTY(wArea)
                        IF AREA#wArea.AND.AREA2#wArea
                           lOk := .F.
                        ENDIF
                     ENDIF
                     IF lOk
                        ImpReg()
                        Cab31dd(01,007,LOTACAO)
                        Cab31dd(00,048,CIDADE)
                        Cab31dd(00,066,FUNCAO)
                        Cab31dd(00,089,CEP,"[@R XX.XXX-XXX]")
                        Cab31dd(00,111,ESTADO)
                        Cab31dd(00,121,CATEGORIA)
                        Cab31dd(01,000,"")
                        nQtdSoc++
                     ENDIF
                  ENDIF
               ELSEIF EMPTY(wCat).AND.EMPTY(wUnidade).AND.!EMPTY(wLotacao)
                  lOk := .T.
                  IF LOTACAO==wLotacao
                     IF !EMPTY(wArea)
                        IF AREA#wArea.AND.AREA2#wArea
                           lOk := .F.
                        ENDIF
                     ENDIF
                     IF lOk
                        ImpReg()
                        Cab31dd(01,035,UNIDADE)
                        Cab31dd(00,048,CIDADE)
                        Cab31dd(00,066,FUNCAO)
                        Cab31dd(00,089,CEP,"[@R XX.XXX-XXX]")
                        Cab31dd(00,111,ESTADO)
                        Cab31dd(00,121,CATEGORIA)
                        Cab31dd(01,000,"")
                        nQtdSoc++
                     ENDIF
                  ENDIF
               ENDIF
               DBSKIP()
               IF PROW() > 58
                  EJECT; lCab := .F.
               ENDIF
            ENDDO
            @ PROW()+02,000 SAY "TOTAL SOCIOS => "+STR(nQtdSoc,5)
            IF continua
               @ 62,00 say "** Fim de Relatorio **"
               EJECT
            ENDIF
            Imp_Normal()
            Fim_TXT()
            SAVESCREEN(0,0,24,79)
            RUN nodosimp cl31dd.txt 80 pre
            RESTSCREEN(0,0,24,79,0)
            DELETE FILE CL31DD.TXT

            TiraMsgImp(Imprimindo)
            Beep(2)
         ENDIF
      ELSE
         /* Impressao em tela */
         lAchou:=.F.; BrowCad()
      ENDIF
   ELSE
      Aviso("N�o h� s�cios com estas especifica��es",,3)
   ENDIF
ENDDO
SETKEY(K_F2,NIL); Rest_Tela()
DelDbfNtx(); RETURN
*嬪様様様様様様様様様様様様様様邑
*� Tecla de Cancelamento        �
*塒様様様様様様様様様様様様様様余
PROCEDURE Cab31dd(nProw,nPcol,cTexto,cMascara)
   IF Continua
      Continua := EscPrint()
      IF (PROW() < 1 .OR. PROW() > 60) .AND. Continua
         pg++
         IF PROW() > 60
            EJECT
         ENDIF
      ENDIF
      IF VALTYPE( cMascara ) = "U"
         @ PROW()+nProw,nPcol SAY cTexto
      ELSE
         @ PROW()+nProw,nPcol SAY cTexto PICT &cMascara
      ENDIF
   ELSE
      Imp_Normal()
      DBGOBOTTOM()
      DBSKIP()
   ENDIF
   RETURN NIL
*嬪様様様様様様様様様様様様様様様邑
*� Browse do Cadastro             �
*塒様様様様様様様様様様様様様様様余
STATIC FUNCTION BrowCad()
   LOCAL corant:=SETCOLOR(), oBr, oCol

   Linha23("^I^-Imprime Etiquetas dos registros acima",23)
   SETCOLOR("W/N")
   Telas(2,0,5,79,1,"W/N",.F.)
   @ 03,02 SAY "Categoria: "+wDescr  PICT "@!S25"
   @ 04,02 SAY "  Unidade: "+wUnidade
   @ 03,40 SAY "   Area: "+IF(EMPTY(wDscrArea),"",wDscrArea) PICT "@!"
*   @ 03,40 SAY "   Area: "+AREAC->DESCR
   @ 04,40 SAY "Lotacao: "+wLotacao

   Telas(6,0,22,79,1,"W/N",.F.)
   oBr:=TBROWSEDB(7,1,21,78)
   oBr:headSep:="賃�"
   oBr:colSep:= " � "

   IF !EMPTY(wCat)
      DBSETORDER(3)
      lAchou := DBSEEK(wCat)
      oBr:gobottomblock = {||goto_bott(wCat)}
      oBr:gotopblock    = {||goto_top(wCat)}
      oBr:skipblock     = {|n| move_pointer(n, wCat, {|n| CATEGORIA})}
   ENDIF
   IF !EMPTY(wArea).AND.!lAchou
      Aguarde("Selecionando...")
      (cArq1)->(__DBZAP())
      SOCIOSI->(DBGOTOP())
      WHILE !SOCIOSI->(EOF())
         IF AREA==wArea.OR.AREA2==wArea
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->NOME      WITH SOCIOSI->NOME      ,;
                    (cArq1)->MATRICULA WITH SOCIOSI->MATRICULA ,;
                    (cArq1)->ENDERECO  WITH SOCIOSI->ENDERECO  ,;
                    (cArq1)->BAIRRO    WITH SOCIOSI->BAIRRO    ,;
                    (cArq1)->CIDADE    WITH SOCIOSI->CIDADE    ,;
                    (cArq1)->ESTADO    WITH SOCIOSI->ESTADO    ,;
                    (cArq1)->CEP       WITH SOCIOSI->CEP       ,;
                    (cArq1)->LOTACAO   WITH SOCIOSI->LOTACAO   ,;
                    (cArq1)->FUNCAO    WITH SOCIOSI->FUNCAO    ,;
                    (cArq1)->TEL       WITH SOCIOSI->TEL       ,;
		    (cArq1)->MOTIVO    WITH SOCIOSI->MOTIVO
         ENDIF
         SOCIOSI->(DBSKIP())
      ENDDO
      Aguarde()
      SELECT (cArq1)
      (cArq1)->(DBGOTOP())
   ENDIF
   IF !EMPTY(wLotacao).AND.!lAchou
      DBGOTOP()
      Aguarde("Selecionando...")
      SET FILTER TO RTRIM(wLotacao) $ LOTACAO
      DBGOTOP()
      IF !EOF(); lAchou := .T.; ENDIF
      Aguarde()
   ENDIF
   IF !EMPTY(wUnidade).AND.!lAchou
      DBSETORDER(5)
      lAchou := DBSEEK(wUnidade)
      oBr:gobottomblock = {||goto_bott(wUnidade)}
      oBr:gotopblock    = {||goto_top(wUnidade)}
      oBr:skipblock     = {|n| move_pointer(n, wUnidade, {|n| UNIDADE})}
   ENDIF

   oCol:=TBCOLUMNNEW("S�cio",{|| TRANSFORM(NOME,"@!S30")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Matr�cula",{|| MATRICULA})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Endere�o",{|| TRANSFORM(ENDERECO,"@!S30") })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Bairro",{|| BAIRRO })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Cidade",{|| CIDADE })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("UF",{|| ESTADO })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("CEP",{|| TRANSFORM(CEP,"@R 99.999-999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Lota��o",{|| TRANSFORM(LOTACAO,"@!S20")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Fun��o",{|| TRANSFORM(FUNCAO,"@!S20")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Fone",{|| TRANSFORM(TEL,"@R (999) 999-9999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("MOTIVO",{|| MOTIVO })
   oBr:addColumn(oCol)
   oBr:Freeze=1

   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSEIF (tecla == 73 .OR. tecla == 105)  /* Imprimir Etiquetas */
         ImpEtiq()
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela(); Rest_Tela()
  SET FILTER TO
  RETURN NIL
*嬪様様様様様様様様様様様様様様邑
*� Cabe�alho do Relatorio       �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION CabRel(cTitulo)
   pg++
   Imp_Exp()
   @ PROW(),000 SAY "Clube 2004"
   Imp_Enor()
   Imp_Normal()
   @ PROW()+01,000 SAY PADC(cTitulo,80)
   @ PROW()+02,000 SAY "Data: "+DTOC(DATE())
   @ PROW()   ,069 SAY "Pag.:"+STRZERO(pg,3)
   @ PROW()+01,000 SAY "Hora: "+TIME()
   IF EMPTY(wLotacao).AND.!EMPTY(wCat).AND.!EMPTY(wUnidade)
      @ PROW()+01,000 SAY "Categoria: "+wDescr  PICT "@!S25"
      @ PROW()   ,055 SAY "Unidade: "  +wUnidade
      @ PROW()   ,095 SAY "   Area: " +IF(EMPTY(wDscrArea),"",wDscrArea) PICT "@!"
      Imp_Compri()
      @ PROW()+01,000 SAY REPL("-",132)
      @ PROW()+01,000 SAY "MAT.   SOCIO                                    ENDERECO                                 BAIRRO                TEL"
      @ PROW()+01,000 SAY "       LOTACAO                                  CIDADE            FUNCAO                 CEP                   UF"
   ELSEIF EMPTY(wLotacao).AND.EMPTY(wUnidade).AND.!EMPTY(wCat)
      @ PROW()+01,000 SAY "Categoria: "+wDescr  PICT "@!S25"
      @ PROW()   ,055 SAY "     Area: " +IF(EMPTY(wDscrArea),"",wDscrArea) PICT "@!"
      Imp_Compri()
      @ PROW()+01,000 SAY REPL("-",132)
      @ PROW()+01,000 SAY "MAT.   SOCIO                                    ENDERECO                                 BAIRRO                TEL"
      @ PROW()+01,000 SAY "       LOTACAO                     UNIDADE      CIDADE            FUNCAO                 CEP                   UF"
   ELSEIF EMPTY(wLotacao).AND.EMPTY(wUnidade).AND.EMPTY(wCat)
      @ PROW()+01,000 SAY "Area: " +IF(EMPTY(wDscrArea),"",wDscrArea) PICT "@!"
      Imp_Compri()
      @ PROW()+01,000 SAY REPL("-",132)
      @ PROW()+01,000 SAY "MAT.   SOCIO                                    ENDERECO                                 BAIRRO                TEL"
      @ PROW()+01,000 SAY "       LOTACAO                     UNIDADE      CIDADE            FUNCAO                 CEP                   UF    CATEGORIA"
   ELSEIF EMPTY(wCat).AND.!EMPTY(wLotacao).AND.!EMPTY(wUnidade)
      @ PROW()+01,000 SAY "Lotacao: "+wLotacao
      @ PROW()   ,055 SAY "Unidade: "+wUnidade
      @ PROW()   ,095 SAY "   Area: " +IF(EMPTY(wDscrArea),"",wDscrArea) PICT "@!"
      Imp_Compri()
      @ PROW()+01,000 SAY REPL("-",132)
      @ PROW()+01,000 SAY "MAT.   SOCIO                                    ENDERECO                                 BAIRRO                TEL"
      @ PROW()+01,000 SAY "                                                CIDADE            FUNCAO                 CEP                   UF    CATEGORIA"
   ELSEIF EMPTY(wCat).AND.EMPTY(wLotacao).AND.!EMPTY(wUnidade)
      @ PROW()+01,000 SAY "Unidade: "+wUnidade
      @ PROW()   ,055 SAY "   Area: " +IF(EMPTY(wDscrArea),"",wDscrArea) PICT "@!"
      Imp_Compri()
      @ PROW()+01,000 SAY REPL("-",132)
      @ PROW()+01,000 SAY "MAT.   SOCIO                                    ENDERECO                                 BAIRRO                TEL"
      @ PROW()+01,000 SAY "       LOTACAO                                  CIDADE            FUNCAO                 CEP                   UF    CATEGORIA"
   ELSEIF EMPTY(wCat).AND.EMPTY(wUnidade).AND.!EMPTY(wLotacao)
      @ PROW()+01,000 SAY "Lotacao: "+wLotacao
      @ PROW()   ,055 SAY "   Area: " +IF(EMPTY(wDscrArea),"",wDscrArea) PICT "@!"
      Imp_Compri()
      @ PROW()+01,000 SAY REPL("-",132)
      @ PROW()+01,000 SAY "MAT.   SOCIO                                    ENDERECO                                 BAIRRO                TEL"
      @ PROW()+01,000 SAY "                                   UNIDADE      CIDADE            FUNCAO                 CEP                   UF    CATEGORIA"
   ENDIF
*                          99999  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx XXXXXXXXXXxxxxxxxxxx  (999) 999-9999
*                                 XXXXXXXXXXxxxxxxxxxxXXXXX   XXXXXXXX     XXXXXXXXXXxxxxx   XXXXXXXXXXxxxxxxxxxx   99.999-999            XX       99         XX        99
*                          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                                    1         2         3         4         5         6         7         8         9        10        11         12       13
   @ PROW()+01,000 SAY REPL("-",132)
   RETURN .T.
*嬪様様様様様様様様様様様様様様邑
*� Imprimir Registro            �
*塒様様様様様様様様様様様様様様余
STATIC PROCEDURE ImpReg()
  Cab31dd(01,000,MATRICULA)
  Cab31dd(00,007,NOME,"[@S40]")
  Cab31dd(00,048,ENDERECO,"[@S40]")
  Cab31dd(00,089,BAIRRO)
  Cab31dd(00,111,TEL,"[@R (999) 999-9999]")
  RETURN
*嬪様様様様様様様様様様様様様様様邑
*� Pesquisar Ponteiro do Browse   �
*塒様様様様様様様様様様様様様様様余
STATIC FUNCTION Goto_Top(searcher)
   DBSEEK(searcher)
   RETURN NIL
*嬪様様様様様様様様様様様様様様様邑
*� Encontrar registro mais prox.  �
*塒様様様様様様様様様様様様様様様余
STATIC FUNCTION Goto_Bott(searcher)
   LOCAL save_soft
   save_soft = SET(_SET_SOFTSEEK, .T.)
   SEEK SUBSTR(searcher, 1, LEN(searcher) - 1) + ;
        CHR(ASC(SUBSTR(searcher, LEN(searcher))) + 1)
   SKIP -1
   SET(_SET_SOFTSEEK, save_soft)
   RETURN NIL
*嬪様様様様様様様様様様様様様様様邑
*� Controla ponteiro no Browse    �
*塒様様様様様様様様様様様様様様様余
STATIC FUNCTION Move_Pointer(num_to_skip,SEARCHER,d_key_cb)
   LOCAL num_skipped := 0

   IF EOF()
   ELSEIF num_to_skip = 0
      SKIP 0
   ELSE
      WHILE !EOF() .AND. !BOF() .AND. num_skipped != num_to_skip ;
                   .AND. EVAL(d_key_cb) = searcher
         IF num_to_skip > 0
            SKIP
            num_skipped++
         ELSE
            SKIP -1
            num_skipped--
         ENDIF
      ENDDO

      IF eof()
         SKIP -1
         num_skipped--
      ELSEIF bof()
         num_skipped++
         SKIP
         SKIP -1
      ELSEIF EVAL(d_key_cb) != searcher
         IF num_to_skip > 0
            SKIP -1
            num_skipped--
         ELSE
            SKIP
            num_skipped++
         ENDIF
      ENDIF
   ENDIF
   RETURN num_skipped
*嬪様様様様様様様様様様様様様様様邑
*� Processar Tecla do Browse      �
*塒様様様様様様様様様様様様様様様余
STATIC FUNCTION ProcKey (oBr,nKey)
   STATIC aKey:= { K_DOWN,       { |oBr| oBr:down() } ,;
                   K_UP,         { |oBr| oBr:up() } ,;
                   K_PGDN,       { |oBr| oBr:pageDown() } ,;
                   K_PGUP,       { |oBr| oBr:pageUp() } ,;
                   K_CTRL_PGUP,  { |oBr| oBr:goTop() } ,;    
                   K_CTRL_PGDN,  { |oBr| oBr:goBottom() } ,;
                   K_RIGHT,      { |oBr| oBr:right() } ,;
                   K_LEFT,       { |oBr| oBr:left() } ,;
                   K_HOME,       { |oBr| oBr:home() } ,;
                   K_END,        { |oBr| oBr:end() } ,;
                   K_CTRL_LEFT,  { |oBr| oBr:panLeft() } ,;
                   K_CTRL_RIGHT, { |oBr| oBr:panRight() } ,;
                   K_CTRL_HOME,  { |oBr| oBr:panHome() } ,;
                   K_CTRL_END,   { |oBr| oBr:panEnd() } }
   LOCAL nI

   nI:=ASCAN(aKey,nKey)
   IF nI!=0
        EVAL(aKey[++nI],oBr)
   ENDIF
   RETURN NIL
*嬪様様様様様様様様様様様様様様様邑
*� Imprimir Mala Direta           �
*塒様様様様様様様様様様様様様様様余
STATIC FUNCTION ImpEtiq()
   (cArq1)->(DBGOTOP())
   IF Confirma("Deseja Imprimir Etiquetas ? ")
      IF (cArq1)->(EOF())
         Aviso("N�o h� registros...",YCORAVISO,2)
      ELSE
         IF TestImp().AND.ChkImpr()
            cAviso := MsgImp(.F.)
            SET DEVI TO PRINT
            SETPRC(0,0)
            Imp_Compri()
            WHILE !(cArq1)->(EOF())
               SETPRC(0,0)
               wNome1  :=NOME;   wEnder1 :=ENDERECO
               wBairro1:=BAIRRO; wCidade1:=CIDADE
               wEstado1:=ESTADO; wCep1   :=CEP
               wNome2 := SPACE(50); wEnder2 := SPACE(50)
               wBairro2:=SPACE(15); wCidade2:=SPACE(15)
               wEstado2:="  "; wCep2   :=SPACE(8)
               DBSKIP()

               IF !(cArq1)->(EOF())
                  wNome2 := NOME; wEnder2 := ENDERECO
                  wBairro2:=BAIRRO; wCidade2:=CIDADE
                  wEstado2:=ESTADO; wCep2   :=CEP
               ENDIF

               Cab110ET(1,02,wNome1)
               Cab110ET(0,65,wNome2)
               Cab110ET(1,02,wEnder1)
               Cab110ET(0,65,wEnder2)
               Cab110ET(1,02,wBairro1)
               Cab110ET(0,20,wCep1,"[@r 99999-999]")
               Cab110ET(0,30,wCidade1)
               Cab110ET(0,48,wEstado1)

               Cab110ET(0,65,wBairro2)
               Cab110ET(0,83,wCep2,"[@r 99999-999]")
               Cab110ET(0,93,wCidade2)
               Cab110ET(0,111,wEstado2)
               Cab110ET(3,00,"")
               DBSKIP()
            ENDDO
            Imp_Normal()
            SET DEVI TO SCREEN
            TiraMsgImp(cAviso)
            Mensagem("Fim de Impress�o! Tecle algo...")
            INKEY(0)
            Mensagem()
         ENDIF
      ENDIF
   ENDIF
   RETURN
*嬪様様様様様様様様様様様様様様邑
*� Teste de Impressao           �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION TestImp()
   if Confirma("Faz Teste de Impressao").and.chkImpr()
      cAviso := MsgImp(.F.)
      Gera_TXT("CL31DDa.TXT")
      Imp_Compri()
      while .T.
         Cab110ET(1,02,replicate("*",50))
         Cab110ET(0,65,replicate("*",50))

         Cab110ET(1,02,replicate("*",60))
         Cab110ET(0,65,Replicate("*",60))

         Cab110ET(1,02,replicate("*",15))
         Cab110ET(0,20,"99999-999")
         Cab110ET(0,30,replicate("*",15))
         Cab110ET(0,48,"**")

         Cab110ET(0,65,replicate("*",15))
         Cab110ET(0,83,"99999-999")
         Cab110ET(0,93,replicate("*",15))
         Cab110ET(0,111,"**")

         Cab110ET(3,00,"")
         Fim_TXT()
         SAVESCREEN(0,0,24,79)
         RUN nodosimp cl31dda.txt 80 pre
         RESTSCREEN(0,0,24,79,0)
         DELETE FILE CL31dda.TXT

         TiraMsgImp(cAviso)
         IF !Confirma("Continua o Teste")
            exit
         ENDIF
         cAviso := MsgImp(.F.)
         Gera_TXT("CL31DDa.TXT")
      enddo
      Imp_Normal()
      Fim_TXT()
      SAVESCREEN(0,0,24,79)
      RUN nodosimp cl31dda.txt 80 pre
      RESTSCREEN(0,0,24,79,0)
      DELETE FILE CL31dda.TXT
      TiraMsgImp(cAviso)
   endif
return .t.
