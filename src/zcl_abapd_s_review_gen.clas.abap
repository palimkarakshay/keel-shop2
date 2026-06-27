CLASS zcl_abapd_s_review_gen DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PRIVATE SECTION.
    TYPES: BEGIN OF t_spec, bi TYPE i, ci TYPE i, rating TYPE i, ago TYPE i, comment TYPE c LENGTH 255, END OF t_spec.
ENDCLASS.

CLASS zcl_abapd_s_review_gen IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM zabapd_s_review.
    DATA now TYPE timestampl. GET TIME STAMP FIELD now.
    DATA(user) = cl_abap_context_info=>get_user_technical_name( ).
    DATA(today) = cl_abap_context_info=>get_system_date( ).
    SELECT book_uuid, title FROM zabapd_s_book ORDER BY title INTO TABLE @DATA(books).
    SELECT customer_uuid, name FROM zabapd_s_cust ORDER BY name INTO TABLE @DATA(custs).
    IF books IS INITIAL OR custs IS INITIAL.
      out->write( 'Seed books and customers first.' ). RETURN.
    ENDIF.
    DATA specs TYPE STANDARD TABLE OF t_spec.
    specs = VALUE #(
      ( bi = 1 ci = 1 rating = 5 ago = 30 comment = 'Brilliant, changed how I write software.' )
      ( bi = 1 ci = 4 rating = 4 ago = 22 comment = 'A classic every developer should read.' )
      ( bi = 2 ci = 2 rating = 5 ago = 18 comment = 'Timeless advice, beautifully written.' )
      ( bi = 3 ci = 3 rating = 5 ago = 12 comment = 'Dense but rewarding - a masterpiece on systems.' )
      ( bi = 4 ci = 5 rating = 5 ago = 40 comment = 'The best science fiction novel ever written.' )
      ( bi = 4 ci = 6 rating = 4 ago = 9 comment = 'Epic world-building, a bit slow in places.' )
      ( bi = 5 ci = 7 rating = 4 ago = 27 comment = 'Quietly profound and humane.' )
      ( bi = 6 ci = 8 rating = 4 ago = 15 comment = 'Mind-bending scope, loved it.' )
      ( bi = 7 ci = 9 rating = 5 ago = 5 comment = 'Could not put it down - clever and funny.' )
      ( bi = 7 ci = 1 rating = 5 ago = 3 comment = 'Andy Weir at his very best.' )
      ( bi = 8 ci = 2 rating = 5 ago = 33 comment = 'Gorgeous prose, an instant favourite.' )
      ( bi = 9 ci = 3 rating = 4 ago = 20 comment = 'Made me rethink my own thinking.' )
      ( bi = 10 ci = 4 rating = 4 ago = 11 comment = 'Sweeping and thought-provoking.' )
      ( bi = 2 ci = 5 rating = 4 ago = 7 comment = 'Pragmatic and still relevant.' )
      ( bi = 3 ci = 6 rating = 5 ago = 2 comment = 'Required reading for backend engineers.' )
      ( bi = 4 ci = 8 rating = 5 ago = 50 comment = 'Re-read it every year.' )
      ( bi = 9 ci = 10 rating = 3 ago = 6 comment = 'Good, but a tough read at times.' )
      ( bi = 8 ci = 7 rating = 5 ago = 1 comment = 'Magical. The prose sings.' )
      ( bi = 1 ci = 9 rating = 4 ago = 14 comment = 'Practical wisdom in every chapter.' )
      ( bi = 5 ci = 10 rating = 5 ago = 19 comment = 'A genuinely original imagination.' )
    ).
    DATA reviews TYPE STANDARD TABLE OF zabapd_s_review.
    LOOP AT specs INTO DATA(sp).
      DATA(bk) = books[ ( ( sp-bi - 1 ) MOD lines( books ) ) + 1 ].
      DATA(cu) = custs[ ( ( sp-ci - 1 ) MOD lines( custs ) ) + 1 ].
      DATA uuid TYPE sysuuid_x16.
      TRY.
          uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
      ENDTRY.
      APPEND VALUE #( review_uuid = uuid
                      book_uuid = bk-book_uuid book_title = bk-title
                      customer_uuid = cu-customer_uuid customer_name = cu-name
                      rating = sp-rating comment_text = sp-comment review_date = today - sp-ago
                      created_by = user created_at = now last_changed_by = user
                      last_changed_at = now local_last_changed_at = now ) TO reviews.
    ENDLOOP.
    INSERT zabapd_s_review FROM TABLE @reviews.
    COMMIT WORK.
    out->write( |Inserted { lines( reviews ) } reviews into ZABAPD_S_REVIEW.| ).
  ENDMETHOD.
ENDCLASS.
