CLASS lhc_author DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Author RESULT result.
    METHODS validateName FOR VALIDATE ON SAVE
      IMPORTING keys FOR Author~validateName.
ENDCLASS.

CLASS lhc_author IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD validateName.
    READ ENTITIES OF zabapd_s_r_author IN LOCAL MODE
      ENTITY Author FIELDS ( Name ) WITH CORRESPONDING #( keys ) RESULT DATA(authors).
    LOOP AT authors INTO DATA(author).
      APPEND VALUE #( %tky = author-%tky %state_area = 'VALIDATE_NAME' ) TO reported-author.
      IF author-Name IS INITIAL.
        APPEND VALUE #( %tky = author-%tky ) TO failed-author.
        APPEND VALUE #( %tky = author-%tky
                        %state_area = 'VALIDATE_NAME'
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Author name is required' )
                        %element-Name = if_abap_behv=>mk-on ) TO reported-author.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
