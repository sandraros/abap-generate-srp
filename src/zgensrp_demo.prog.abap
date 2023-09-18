*&---------------------------------------------------------------------*
*& Report zgensrp_demo
*&---------------------------------------------------------------------*
*&
*& This demonstration code is same as local test classes in class pool ZCL_GENSRP.
*&
*&---------------------------------------------------------------------*
REPORT zgensrp_demo.

CLASS ltc_demo DEFINITION
      FOR TESTING
      DURATION SHORT
      RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS zgensrp_forms_in_srp FOR TESTING RAISING cx_static_check.
*    METHODS local_class FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltc_demo IMPLEMENTATION.

  METHOD zgensrp_forms_in_srp.

    DATA(gensrp) = zcl_gensrp=>zif_gensrp~generate_subroutine_pool( VALUE #(
        ( |PROGRAM.| )
        ( |INCLUDE zgensrp_forms_in_srp.| )
        ( |CLASS lcl_app DEFINITION.| )
        ( |PUBLIC SECTION.| )
        ( |METHODS main RETURNING VALUE(result) TYPE string.| )
        ( |ENDCLASS.| )
        ( |CLASS lcl_app IMPLEMENTATION.| )
        ( |METHOD main.| )
        ( |result = 'hello world'.| )
        ( |ENDMETHOD.| )
        ( |ENDCLASS.| ) ) ).

    DATA(instance) = gensrp->create_object( class_name = 'LCL_APP' ).
    DATA(string) = VALUE string( ).
    CALL METHOD instance->('MAIN') RECEIVING result = string.

    cl_abap_unit_assert=>assert_equals(
        act = string
        exp = 'hello world' ).

  ENDMETHOD.

ENDCLASS.
*TRY.
*
*
*  CATCH zcx_gensrp INTO DATA(error).
*    MESSAGE error TYPE 'I' DISPLAY LIKE 'E'.
*ENDTRY.
