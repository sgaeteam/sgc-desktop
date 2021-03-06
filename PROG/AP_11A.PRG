*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AP_11A                           vrs 001 �
*� VRS 001        : Implantacao                              �
*� FINALIDADE     : Consulta de Socios                       �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            �
*� DATA CRIACAO   : 03/03/1995                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, oTab, oSep

DBCLOSEALL()
SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SET KEY -1 TO Mostra()
ProgName("AP11A"); LinhaMsg(15)
SETCOLOR(YCOREDIT); wNomeSoc:=SPACE(50)
Telas(18,3,20,64,1,YCOREDIT,.T.)
@ 19,05 SAY "S�cio: " GET wNomeSoc PICT "@!" WHEN TeclaFuncao(.T.) VALID !EMPTY(wNomeSoc)
SETCURSOR(1); READ; SETCURSOR(0)

TeclaFuncao(); Rest_Tela()
IF LASTKEY()==K_ESC; RETURN; ENDIF

IF DBSEEK(TRIM(wNomeSoc))
   Telas(4,3,20,75,1,YCOREDIT,.T.,"� Consulta de S�cios �")
   oBr:=TBROWSEDB(5,4,19,74)
   oBr:headSep:="賃�"
   oBr:colSep:= " � "

   oCol:=TBCOLUMNNEW("N�mero"     ,{|| MATRICULA})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Nome"       ,{|| NOME})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Unidade"    ,{|| UNIDADE})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Lota��o"    ,{|| LOTACAO})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Matr.Empresa",{|| MATR2})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Endere�o"   ,{|| ENDERECO })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Bairro"     ,{|| BAIRRO})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Fone Resid.",{|| TRANSFORM(TEL,"@R (999) 999-9999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Fone Coml." ,{|| TRANSFORM(FONE,"@R (999) 999-9999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Ades�o"     ,{|| TRANSFORM(DTADESAO,"@D")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Observa��o" ,{|| OBS})
   oBr:addColumn(oCol)

   WHILE .T.
      WHILE NEXTKEY()=0 .and. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSEIF ( tecla == K_F1 )
         Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
   ENDDO
   SETCOLOR(corant); Rest_Tela(); DBCOMMITALL()
ELSE
   Aviso("S�cio n�o Localizado...",,3)
ENDIF
RETURN NIL
