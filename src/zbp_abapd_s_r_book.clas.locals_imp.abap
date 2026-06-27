CLASS lhc_book DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF status,
        available    TYPE c LENGTH 2 VALUE 'A',
        out_of_stock TYPE c LENGTH 2 VALUE 'O',
        discontinued TYPE c LENGTH 2 VALUE 'D',
      END OF status.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Book RESULT result.
    METHODS setDefaults FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Book~setDefaults.
    METHODS validateRating FOR VALIDATE ON SAVE
      IMPORTING keys FOR Book~validateRating.
    METHODS validateTitle FOR VALIDATE ON SAVE
      IMPORTING keys FOR Book~validateTitle.
    METHODS markFeatured FOR MODIFY
      IMPORTING keys FOR ACTION Book~markFeatured RESULT result.
    METHODS unmarkFeatured FOR MODIFY
      IMPORTING keys FOR ACTION Book~unmarkFeatured RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Book RESULT result.
ENDCLASS.

CLASS lhc_book IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD setDefaults.
    READ ENTITIES OF zabapd_s_r_book IN LOCAL MODE
      ENTITY Book FIELDS ( Status Rating CurrencyCode )
      WITH CORRESPONDING #( keys ) RESULT DATA(books).
    DATA upd TYPE TABLE FOR UPDATE zabapd_s_r_book.
    LOOP AT books INTO DATA(book).
      IF book-Status IS INITIAL OR book-Rating IS INITIAL OR book-CurrencyCode IS INITIAL.
        APPEND VALUE #( %tky = book-%tky
                        Status       = COND #( WHEN book-Status IS INITIAL THEN status-available ELSE book-Status )
                        Rating       = COND #( WHEN book-Rating IS INITIAL THEN 3 ELSE book-Rating )
                        CurrencyCode = COND #( WHEN book-CurrencyCode IS INITIAL THEN 'USD' ELSE book-CurrencyCode )
                      ) TO upd.
      ENDIF.
    ENDLOOP.
    CHECK upd IS NOT INITIAL.
    MODIFY ENTITIES OF zabapd_s_r_book IN LOCAL MODE
      ENTITY Book UPDATE FIELDS ( Status Rating CurrencyCode ) WITH upd.
  ENDMETHOD.

  METHOD validateRating.
    READ ENTITIES OF zabapd_s_r_book IN LOCAL MODE
      ENTITY Book FIELDS ( Rating ) WITH CORRESPONDING #( keys ) RESULT DATA(books).
    LOOP AT books INTO DATA(book).
      APPEND VALUE #( %tky = book-%tky %state_area = 'VALIDATE_RATING' ) TO reported-book.
      IF book-Rating < 1 OR book-Rating > 5.
        APPEND VALUE #( %tky = book-%tky ) TO failed-book.
        APPEND VALUE #( %tky = book-%tky
                        %state_area = 'VALIDATE_RATING'
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Rating must be between 1 and 5' )
                        %element-Rating = if_abap_behv=>mk-on ) TO reported-book.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateTitle.
    READ ENTITIES OF zabapd_s_r_book IN LOCAL MODE
      ENTITY Book FIELDS ( Title ) WITH CORRESPONDING #( keys ) RESULT DATA(books).
    LOOP AT books INTO DATA(book).
      APPEND VALUE #( %tky = book-%tky %state_area = 'VALIDATE_TITLE' ) TO reported-book.
      IF book-Title IS INITIAL.
        APPEND VALUE #( %tky = book-%tky ) TO failed-book.
        APPEND VALUE #( %tky = book-%tky
                        %state_area = 'VALIDATE_TITLE'
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Title is required' )
                        %element-Title = if_abap_behv=>mk-on ) TO reported-book.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD markFeatured.
    MODIFY ENTITIES OF zabapd_s_r_book IN LOCAL MODE
      ENTITY Book UPDATE FIELDS ( Featured )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Featured = 'X' ) )
      FAILED failed REPORTED reported.
    READ ENTITIES OF zabapd_s_r_book IN LOCAL MODE
      ENTITY Book ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(books).
    result = VALUE #( FOR book IN books ( %tky = book-%tky %param = book ) ).
  ENDMETHOD.

  METHOD unmarkFeatured.
    MODIFY ENTITIES OF zabapd_s_r_book IN LOCAL MODE
      ENTITY Book UPDATE FIELDS ( Featured )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Featured = ' ' ) )
      FAILED failed REPORTED reported.
    READ ENTITIES OF zabapd_s_r_book IN LOCAL MODE
      ENTITY Book ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(books).
    result = VALUE #( FOR book IN books ( %tky = book-%tky %param = book ) ).
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zabapd_s_r_book IN LOCAL MODE
      ENTITY Book FIELDS ( Featured ) WITH CORRESPONDING #( keys ) RESULT DATA(books).
    result = VALUE #( FOR book IN books
                      ( %tky = book-%tky
                        %action-markFeatured   = COND #( WHEN book-Featured = 'X'
                                                         THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
                        %action-unmarkFeatured = COND #( WHEN book-Featured = 'X'
                                                         THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )
                      ) ).
  ENDMETHOD.
ENDCLASS.
