*&---------------------------------------------------------------------*
*& Include zgensrp_forms_in_srp
*&---------------------------------------------------------------------*

FORM call_static_method
    USING
      class_name  TYPE seoclsname
      method_name TYPE seocmpname
      parameters  TYPE abap_parmbind_tab
    RAISING
      cx_root.

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
      cx_root.

  CREATE OBJECT result TYPE (class_name)
    PARAMETER-TABLE parameters.

ENDFORM.
