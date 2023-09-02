CLASS zcl_gensrp DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

    TYPES : BEGIN OF ty_result_object,
              parameter_name TYPE string,
              bound_optional TYPE abap_bool,
            END OF ty_result_object.

    DATA srp_name     TYPE syrepid READ-ONLY.
    DATA message      TYPE string READ-ONLY.
    DATA line         TYPE i READ-ONLY.
    DATA word         TYPE string READ-ONLY.
    DATA include      TYPE string READ-ONLY.
    DATA message_id   TYPE trmsg_key READ-ONLY.
    DATA offset       TYPE i READ-ONLY.
    DATA shortdump_id TYPE string READ-ONLY.
    DATA trace_file   TYPE string READ-ONLY.

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
        VALUE(result) TYPE REF TO zcl_gensrp
      RAISING
        zcx_gensrp.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_gensrp IMPLEMENTATION.

  METHOD call_static_method.
    FIELD-SYMBOLS <parameters> TYPE abap_parmbind_tab.

    "=============
    " Preparation
    "=============
    IF result_object-parameter_name IS NOT INITIAL
        AND NOT line_exists( parameters[ name = result_object-parameter_name ] ).
      DATA(parameters_local) = VALUE abap_parmbind_tab(
                      BASE parameters
                      ( name = result_object-parameter_name value = NEW dba_object_ref( ) ) ).
      ASSIGN parameters_local TO <parameters>.
    ELSE.
      ASSIGN parameters TO <parameters>.
    ENDIF.

    "=============
    " Execution
    "=============
    PERFORM call_static_method IN PROGRAM (srp_name)
      USING class_name
            method_name
            <parameters>.

    "=============
    " Follow-up
    "=============
    IF result_object-parameter_name IS NOT INITIAL.

      DATA(ref_returning_parameter) = REF #( <parameters>[ name = result_object-parameter_name ] OPTIONAL ).
      ASSERT ref_returning_parameter IS BOUND.

      ASSIGN ref_returning_parameter->value->* TO FIELD-SYMBOL(<object>).
      TRY.
          result = <object>.
        CATCH cx_sy_move_cast_error.
          RAISE EXCEPTION TYPE zcx_gensrp
            EXPORTING
              text  = 'Receiving variable is of type &1 (must be REF TO OBJECT)'(001)
              msgv1 = cl_abap_typedescr=>describe_by_data( <object> )->absolute_name.
      ENDTRY.

      IF result_object-bound_optional = abap_false
            AND result IS NOT BOUND.
        RAISE EXCEPTION TYPE zcx_gensrp
          EXPORTING
            text = 'Result is not bound'(002).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD create_object.
    FIELD-SYMBOLS <parameters> TYPE abap_parmbind_tab.

    IF via_perform = abap_false.

      DATA(absolute_name) = |\\PROGRAM={ srp_name }\\CLASS={ class_name }|.
      CREATE OBJECT result TYPE (absolute_name) PARAMETER-TABLE parameters.

    ELSE.

      PERFORM create_object IN PROGRAM (srp_name)
        USING    class_name
                 parameters
        CHANGING result.

    ENDIF.

    IF result IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_gensrp
        EXPORTING
          text = 'Result is not bound'(002).
    ENDIF.

  ENDMETHOD.


  METHOD generate_subroutine_pool.

    result = NEW zcl_gensrp( ).

    GENERATE SUBROUTINE POOL abap_code
        NAME         result->srp_name
        MESSAGE      result->message
        LINE         result->line
        WORD         result->word
        INCLUDE      result->include
        MESSAGE-ID   result->message_id
        OFFSET       result->offset
        SHORTDUMP-ID result->shortdump_id.

    IF sy-subrc <> 0.

      RAISE EXCEPTION TYPE zcx_gensrp
        EXPORTING
          text  = 'Generation error &1 at line &2: &3'(003)
          msgv1 = |{ sy-subrc }|
          msgv2 = |{ result->line }|
          msgv3 = result->message.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
