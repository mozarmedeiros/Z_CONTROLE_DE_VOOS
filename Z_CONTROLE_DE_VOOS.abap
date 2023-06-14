*&---------------------------------------------------------------------*
*& Module Pool      Z_CONTROLE_DE_VOOS
*&---------------------------------------------------------------------*
*Criando um projeto desde a criação do pacote, geração da request até o desenvolvimento da aplicação.
* Projeto de controle de voos contem:
*  seleção de dados com tela de seleção, onde podemos filtrar por companhia,
*    acrescentar companhias,
*    classes de mensagem,
*    estrutura de banco de dados,
*    join de duas tabelas,
*    ALV o qual podemos ordenar,
*      localizar,
*      filtrar,
*      sumarizar,
*      exportar.
* ---------------------------------------------------------------------*
* BY Mozar Lima.
*&---------------------------------------------------------------------*


PROGRAM z_controle_de_voos.


************************************************************************
*Referenciando a tabela SPFLI
************************************************************************

DATA spfli TYPE spfli.

DATA: custom_container TYPE REF TO cl_gui_custom_container,
      alv              TYPE REF TO cl_gui_alv_grid,
      fieldcat         TYPE lvc_t_fcat.
DATA it_spfli TYPE STANDARD TABLE OF spfli .

SELECTION-SCREEN: BEGIN OF SCREEN 9999 AS SUBSCREEN.
SELECTION-SCREEN: BEGIN OF BLOCK bloco1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS s_carrid FOR spfli-carrid   NO INTERVALS.
SELECT-OPTIONS s_connid FOR spfli-connid   NO INTERVALS.
SELECT-OPTIONS s_cityfr FOR spfli-cityfrom NO INTERVALS.
SELECT-OPTIONS s_cityto FOR spfli-cityto   NO INTERVALS.

SELECTION-SCREEN: END OF BLOCK bloco1.
SELECTION-SCREEN: END OF SCREEN 9999.
*&---------------------------------------------------------------------*
*& Module CRIA_ALV OUTPUT
*&---------------------------------------------------------------------*

MODULE cria_alv OUTPUT.

  DATA coluna LIKE LINE OF fieldcat .

  CREATE OBJECT custom_container
    EXPORTING
      container_name = 'CC_ALV'.
  CREATE OBJECT alv
    EXPORTING
*
      i_parent = custom_container.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'SPFLI'
    CHANGING
      ct_fieldcat      = fieldcat.

  LOOP AT fieldcat INTO coluna .

    IF coluna-fieldname = 'DISTANCE'
      OR coluna-fieldname = 'DISTID'
       OR coluna-fieldname = 'FLTYOE'
         OR coluna-fieldname = 'PERIOD' .

      coluna-no_out = 'X'.
      MODIFY fieldcat FROM coluna.

    ENDIF.
    ENDLOOP .


    CALL METHOD alv->set_table_for_first_display
      CHANGING
        it_outtab       = it_spfli
        it_fieldcatalog = fieldcat.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_PFSTATUS OUTPUT
*&---------------------------------------------------------------------*

MODULE set_pfstatus OUTPUT.
 SET PF-STATUS '1000'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PEGA_EVENTOS_PFSTATUS  INPUT
*&---------------------------------------------------------------------*

MODULE pega_eventos_pfstatus INPUT.

CASE sy-ucomm.
  WHEN 'VOLTAR' or 'CANCELAR' or 'SAIR'.
   LEAVE PROGRAM .
ENDCASE.
ENDMODULE.
