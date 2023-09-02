*&---------------------------------------------------------------------*
*& Report zgensrp_demo
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgensrp_demo.

TRY.

    DATA(gensrp) = zcl_gensrp=>generate_subroutine_pool( VALUE #(
        ( |PROGRAM.| )
        ( |INCLUDE zgensrp_forms_in_srp.| ) ) ).

    gensrp->create_object( class_name = 'LCL_APP' ).

  CATCH zcx_gensrp INTO DATA(error).
    MESSAGE error TYPE 'I' DISPLAY LIKE 'E'.
ENDTRY.
