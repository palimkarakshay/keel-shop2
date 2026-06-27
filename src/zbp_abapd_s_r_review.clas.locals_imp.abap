CLASS lhc_review DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Review RESULT result.
    METHODS validateRating FOR VALIDATE ON SAVE
      IMPORTING keys FOR Review~validateRating.
ENDCLASS.

CLASS lhc_review IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD validateRating.
    READ ENTITIES OF zabapd_s_r_review IN LOCAL MODE
      ENTITY Review FIELDS ( Rating ) WITH CORRESPONDING #( keys ) RESULT DATA(reviews).
    LOOP AT reviews INTO DATA(rev).
      APPEND VALUE #( %tky = rev-%tky %state_area = 'VALIDATE_RATING' ) TO reported-review.
      IF rev-Rating < 1 OR rev-Rating > 5.
        APPEND VALUE #( %tky = rev-%tky ) TO failed-review.
        APPEND VALUE #( %tky = rev-%tky
                        %state_area = 'VALIDATE_RATING'
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Rating must be between 1 and 5' )
                        %element-Rating = if_abap_behv=>mk-on ) TO reported-review.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
