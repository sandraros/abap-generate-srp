# abap-generate-srp
Helper to make Generate SubRoutine Pool work with ABAP OO.

```
GENERATE SUBROUTINE POOL abap_code NAME DATA(srp_name).
```

Few people know that a SubRoutine Pool may contain not only subroutines (`FORM` ... `ENDFORM`) but also local classes, which can be useful in case a developer wants the code to be well organized.

There are 2 ways to instantiate a local class from a generated subroutine pool (its name is stored in the variable `srp_name` in the examples below):
1. Either using a subroutine:
   ```abap
   PERFORM create_object IN PROGRAM (srp_name) USING ... local_class_name ... CHANGING ... = obj ...
   ```
1. Or using the absolute local class name, provided that the local class permits a public instantiation (`CLASS ... DEFINITION ... CREATE PUBLIC ...`):
   ```abap
   DATA(absolute_local_class_name) = |\\PROGRAM={ srp_name }\\CLASS={ local_class_name }|.
   CREATE OBJECT obj TYPE (absolute_local_class_name) ...
   ```

The caller program will have to use this code:
```abap
DATA(abap_code) = VALUE string_table(
  ( |PROGRAM.| ) ).
DATA(gensrp) = zcl_gensrp=>generate_subroutine_pool( abap_code ).
DATA(obj) = gensrp->create_object( ).
```

The subroutine pool will have to start with these 2 lines:
```abap
PROGRAM.
INCLUDE zgensrp_forms.
```
