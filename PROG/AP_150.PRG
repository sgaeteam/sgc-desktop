*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AP_150                           vrs 001 �
*� VRS 001        : Desenvolvimento                          �
*� FINALIDADE     : Cadastrar Senhas                         �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            �
*� DATA CRIACAO   : 27/08/1994                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

Telas(8,20,11,31,1,YCORMENU,.T.)
LinhaMsg(2)
WHILE .T.
   SETCURSOR(0)
   SETCOLOR(YCORMENU)
   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   cOpHelp1 := "1"
   cOpHelp2 := "50"
   cPrg     := "AP150"
   ProgName(cPrg)

   @ 09,21 PROMPT " Usu�rios " MESSAGE Msg("Cadastrar/Atualizar Tabela de Senhas/Usu�rio")
   @ 10,21 PROMPT " Acessos  " MESSAGE Msg("Atualizar N�veis de Acesso de Usu�rios")
   MENU TO nMenu_3

   IF nMenu_3 = 0
      Rest_Tela()
      LinhaMsg(1)
      RETURN
   ENDIF

   SETKEY(K_LEFT,NIL)
   SETKEY(K_RIGHT,NIL)


   IF nMenu_3 = 1
      IF Acesso(3)
         AP_151()
      ENDIF
   ELSEIF nMenu_3 = 2
      IF Acesso(9)
         AP_152()
      ENDIF
   ENDIF
ENDDO
