*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AP_136                           vrs 001 �
*� VRS 001        : Desenvolvimento                          �
*� FINALIDADE     : Tabela de Areas de Competencia           �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            �
*� DATA CRIACAO   : 17/01/1995                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

SELECT 2
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA8,DBISOCA9
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("AREAC")
   SET INDEX TO DBIAREA1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("GC136")
cOpHelp1 := "1"; cOpHelp2 := "30"

SETKEY(K_F4,NIL)
SETKEY(K_F5,NIL)
AP136_0()
SETKEY(K_F4,{|| Calculadora(calc_lin,calc_col,YCORMENU)})
SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
DBCLOSEALL(); RETURN
*嬪様様様様様様様様様様様様様様様様様様�
*� Cadastrar Areas de Competencia      �
*塒様様様様様様様様様様様様様様様様様様�
PROCEDURE AP136_0()
   LOCAL tela := SAVESCREEN(2,0,24,79)
   LOCAL aCab[2], aCam[2], aPic[2]

   Area_Dados()
   LinhaMsg(4)

   aCab[1] := "Area"
   aCab[2] := "Descri��o"
   *
   aCam[1] := "AREACOMP"
   aCam[2] := "DESCR"
   *
   aPic[1] := "@!"
   aPic[2] := "@!"
   msg     := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")
   *
   Browser(1,1,6,3,16,75,aCab,aCam,aPic,.T.,.T.,"Areas de Compet�ncia",msg)
   RESTSCREEN(2,0,24,79,tela)
   RETURN
