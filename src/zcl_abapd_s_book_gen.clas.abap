CLASS zcl_abapd_s_book_gen DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_abapd_s_book_gen IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM zabapd_s_book.
    DATA now TYPE timestampl.
    GET TIME STAMP FIELD now.
    DATA(user) = cl_abap_context_info=>get_user_technical_name( ).
    DATA books TYPE STANDARD TABLE OF zabapd_s_book.
    books = VALUE #(
      ( title = 'The Pragmatic Programmer' author = 'Hunt & Thomas' genre = 'Software' release_year = 1999 price = '49.99' currency_code = 'USD' rating = 5 status = 'A' featured = 'X' )
      ( title = 'Clean Code' author = 'Robert C. Martin' genre = 'Software' release_year = 2008 price = '42.50' currency_code = 'USD' rating = 5 status = 'A' featured = ' ' )
      ( title = 'Designing Data-Intensive Apps' author = 'Martin Kleppmann' genre = 'Software' release_year = 2017 price = '55.00' currency_code = 'USD' rating = 5 status = 'A' featured = 'X' )
      ( title = 'Dune' author = 'Frank Herbert' genre = 'Sci-Fi' release_year = 1965 price = '18.99' currency_code = 'USD' rating = 5 status = 'A' featured = 'X' )
      ( title = 'The Left Hand of Darkness' author = 'Ursula K. Le Guin' genre = 'Sci-Fi' release_year = 1969 price = '16.00' currency_code = 'USD' rating = 4 status = 'A' featured = ' ' )
      ( title = 'The Three-Body Problem' author = 'Liu Cixin' genre = 'Sci-Fi' release_year = 2008 price = '17.50' currency_code = 'USD' rating = 4 status = 'D' featured = ' ' )
      ( title = 'Project Hail Mary' author = 'Andy Weir' genre = 'Sci-Fi' release_year = 2021 price = '21.00' currency_code = 'USD' rating = 5 status = 'A' featured = 'X' )
      ( title = 'The Name of the Wind' author = 'Patrick Rothfuss' genre = 'Fantasy' release_year = 2007 price = '19.99' currency_code = 'USD' rating = 5 status = 'A' featured = ' ' )
      ( title = 'Thinking, Fast and Slow' author = 'Daniel Kahneman' genre = 'Non-Fiction' release_year = 2011 price = '22.00' currency_code = 'USD' rating = 4 status = 'O' featured = ' ' )
      ( title = 'Sapiens' author = 'Yuval Noah Harari' genre = 'Non-Fiction' release_year = 2011 price = '24.99' currency_code = 'USD' rating = 4 status = 'O' featured = ' ' )
    ).
    LOOP AT books ASSIGNING FIELD-SYMBOL(<b>).
      TRY.
          <b>-book_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
      ENDTRY.
      <b>-created_by = user. <b>-created_at = now.
      <b>-last_changed_by = user. <b>-last_changed_at = now. <b>-local_last_changed_at = now.
    ENDLOOP.
    INSERT zabapd_s_book FROM TABLE @books.
    COMMIT WORK.
    out->write( |Inserted { lines( books ) } books into ZABAPD_S_BOOK.| ).
  ENDMETHOD.
ENDCLASS.
