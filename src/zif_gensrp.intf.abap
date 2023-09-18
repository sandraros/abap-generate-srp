INTERFACE zif_gensrp
  PUBLIC .

  TYPES : BEGIN OF ty_result_object,
            parameter_name TYPE string,
            bound_optional TYPE abap_bool,
          END OF ty_result_object.

  DATA srp_name TYPE syrepid READ-ONLY.
  DATA message TYPE string READ-ONLY.
  DATA line TYPE i READ-ONLY.
  DATA word TYPE string READ-ONLY.
  DATA include TYPE string READ-ONLY.
  DATA message_id TYPE trmsg_key READ-ONLY.
  DATA offset TYPE i READ-ONLY.
  DATA shortdump_id TYPE string READ-ONLY.
  DATA trace_file TYPE string READ-ONLY.

  METHODS call_static_method
    IMPORTING
      class_name    TYPE seoclsname
      method_name   TYPE seocmpname
      parameters    TYPE abap_parmbind_tab OPTIONAL
      result_object TYPE ty_result_object OPTIONAL
    RETURNING
      VALUE(result) TYPE REF TO object
    RAISING
      cx_static_check
      cx_dynamic_check.

  METHODS create_object
    IMPORTING
      class_name    TYPE seoclsname
      parameters    TYPE abap_parmbind_tab OPTIONAL
      via_perform   TYPE abap_bool DEFAULT abap_false
    RETURNING
      VALUE(result) TYPE REF TO object
    RAISING
      cx_static_check
      cx_dynamic_check.

  CLASS-METHODS generate_subroutine_pool
    IMPORTING
      abap_code     TYPE string_table
    RETURNING
      VALUE(result) TYPE REF TO zif_gensrp
    RAISING
      zcx_gensrp.

ENDINTERFACE.
