*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AP_132                           vrs 001 �
*� VRS 001        : Desenvolvimento                          �
*� FINALIDADE     : Tabela de Atividades                     �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            �
*� DATA CRIACAO   : 27/09/1994                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

SELECT 2
IF NetUse("USUATIV")
   SET INDEX TO DBIUSAT3
ELSE
   DBCLOSEALL()
   RETURN
ENDIF

SELECT 1
IF NetUse("ATIV","ATIVIDADE")
   SET INDEX TO DBIATIV1,DBIATIV2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("GC132")
cOpHelp1 := "1"; cOpHelp2 := "30"

SETKEY(K_F4,NIL)
SETKEY(K_F5,NIL)
AP132_0()
SETKEY(K_F4,{|| Calculadora(calc_lin,calc_col,YCORMENU)})
SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
DBCLOSEALL(); RETURN
*嬪様様様様様様様様様様様様様様邑
*� Cadastrar Atividades do Clube�
*塒様様様様様様様様様様様様様様余
PROCEDURE AP132_0()
   LOCAL tela := SAVESCREEN(2,0,24,79)
   LOCAL aCab[3], aCam[3], aPic[3]

   Area_Dados()
   LinhaMsg(4)

   aCab[1] := "C�digo"
   aCab[2] := "Atividade"
   aCab[3] := "Mensalidade"
   *
   aCam[1] := "CODATIV"
   aCam[2] := "DESCR"
   aCam[3] := "MENSALID"
   *
   aPic[1] := "99"
   aPic[2] := "@!"
   aPic[3] := "@E 999,999,999.99"
   msg     := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")
   *
   Browser(1,1,6,3,16,75,aCab,aCam,aPic,.T.,.T.,"Atividades",msg)
   RESTSCREEN(2,0,24,79,tela)
   RETURN
