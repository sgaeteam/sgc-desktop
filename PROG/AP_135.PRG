*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AP_135                           vrs 001 �
*� VRS 001        : Desenvolvimento                          �
*� FINALIDADE     : Tabela de Unidade de Lota��o             �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            �
*� DATA CRIACAO   : 30/11/1994                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

SELECT 2
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("UNIDADE")
   SET INDEX TO DBIUNID1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("GC135")
cOpHelp1 := "1"; cOpHelp2 := "30"

SETKEY(K_F4,NIL)
SETKEY(K_F5,NIL)
AP135_0()
SETKEY(K_F4,{|| Calculadora(calc_lin,calc_col,YCORMENU)})
SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
DBCLOSEALL(); RETURN
*嬪様様様様様様様様様様様様様様様様様様�
*� Cadastrar Fun��o existente no clube �
*塒様様様様様様様様様様様様様様様様様様�
PROCEDURE AP135_0()
   LOCAL tela := SAVESCREEN(2,0,24,79)
   LOCAL aCab[2], aCam[2], aPic[2]

   Area_Dados()
   LinhaMsg(4)

   aCab[1] := "Descri��o"
   *
   aCam[1] := "DESCR"
   *
   aPic[1] := "@!"
   msg     := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")
   *
   Browser(1,1,6,3,16,75,aCab,aCam,aPic,.T.,.T.,"Unidades",msg)
   RESTSCREEN(2,0,24,79,tela)
   RETURN
