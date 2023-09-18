*&---------------------------------------------------------------------*
*& Include zgensrp_forms_in_srp
*&---------------------------------------------------------------------*

FORM call_static_method
    USING
      class_name  TYPE seoclsname
      method_name TYPE seocmpname
      parameters  TYPE abap_parmbind_tab
    RAISING
      cx_static_check
      cx_dynamic_check.

  CALL METHOD (class_name)=>(method_name)
    PARAMETER-TABLE parameters.

ENDFORM.


FORM create_object
    USING
      class_name  TYPE seoclsname
      parameters  TYPE abap_parmbind_tab
    CHANGING
      result      TYPE REF TO object
    RAISING
      cx_static_check
      cx_dynamic_check.

  " EXCEPTION-TABLE is required by kernels before note 2866213, even if no specific need.
  " NB: note 2866213 - ABAP short dump RUNT_ILLEGAL_SWITCH at CREATE OBJECT ... PARAMETER-TABLE
  " at https://me.sap.com/notes/2866213/E.
  DATA(dummy_exception_table) = VALUE abap_excpbind_tab( ).
  CREATE OBJECT result TYPE (class_name)
                        PARAMETER-TABLE parameters
                        EXCEPTION-TABLE dummy_exception_table.

ENDFORM.
