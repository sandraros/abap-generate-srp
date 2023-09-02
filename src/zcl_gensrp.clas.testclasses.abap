*"* use this source file for your ABAP unit test classes

CLASS ltc_create_object DEFINITION
      FOR TESTING
      DURATION SHORT
      RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS via_perform FOR TESTING RAISING cx_static_check.
    METHODS via_create_object_absolute FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltc_create_object IMPLEMENTATION.

  METHOD via_create_object_absolute.

    DATA(gensrp) = zcl_gensrp=>generate_subroutine_pool( VALUE #(
        ( |PROGRAM.| )
        ( || )
        ( |CLASS lcl_app DEFINITION.| )
        ( |ENDCLASS.| )
        ( || ) ) ).

    DATA(object) = gensrp->create_object( 'LCL_APP' ).

    cl_abap_unit_assert=>assert_bound( object ).
    DATA(rtti) = cl_abap_typedescr=>describe_by_object_ref( object ).
    cl_abap_unit_assert=>assert_char_cp( act = rtti->absolute_name exp = '\PROGRAM=*\CLASS=LCL_APP' ).

  ENDMETHOD.


  METHOD via_perform.

    DATA(gensrp) = zcl_gensrp=>generate_subroutine_pool( VALUE #(
        ( |PROGRAM.| )
        ( |INCLUDE zgensrp_forms_in_srp.| )
        ( |CLASS lcl_app DEFINITION.| )
        ( |ENDCLASS.| ) ) ).

    DATA(object) = gensrp->create_object( class_name = 'LCL_APP' via_perform = abap_true ).

    cl_abap_unit_assert=>assert_bound( object ).
    DATA(rtti) = cl_abap_typedescr=>describe_by_object_ref( object ).
    cl_abap_unit_assert=>assert_char_cp( act = rtti->absolute_name exp = '\PROGRAM=*\CLASS=LCL_APP' ).

  ENDMETHOD.

ENDCLASS.
