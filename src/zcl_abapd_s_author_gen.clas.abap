CLASS zcl_abapd_s_author_gen DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_abapd_s_author_gen IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM zabapd_s_author.
    DATA now TYPE timestampl.
    GET TIME STAMP FIELD now.
    DATA(user) = cl_abap_context_info=>get_user_technical_name( ).
    DATA authors TYPE STANDARD TABLE OF zabapd_s_author.
    authors = VALUE #(
      ( name = 'Andy Weir' country = 'USA' born_year = 1972 bio = 'Software engineer turned hard-sci-fi novelist (The Martian, Project Hail Mary).' )
      ( name = 'Frank Herbert' country = 'USA' born_year = 1920 bio = 'Author of Dune, a landmark of ecological science fiction.' )
      ( name = 'Ursula K. Le Guin' country = 'USA' born_year = 1929 bio = 'Celebrated for the Earthsea and Hainish cycles.' )
      ( name = 'Liu Cixin' country = 'China' born_year = 1963 bio = 'Hugo-winning author of the Three-Body trilogy.' )
      ( name = 'Patrick Rothfuss' country = 'USA' born_year = 1973 bio = 'Fantasy author of the Kingkiller Chronicle.' )
      ( name = 'Robert C. Martin' country = 'USA' born_year = 1952 bio = 'Software engineer and author (Uncle Bob), wrote Clean Code.' )
      ( name = 'Martin Kleppmann' country = 'UK' born_year = 1983 bio = 'Researcher and author of Designing Data-Intensive Applications.' )
      ( name = 'Daniel Kahneman' country = 'Israel' born_year = 1934 bio = 'Nobel-laureate psychologist, author of Thinking, Fast and Slow.' )
      ( name = 'Yuval Noah Harari' country = 'Israel' born_year = 1976 bio = 'Historian and author of Sapiens.' )
      ( name = 'Andrew Hunt' country = 'USA' born_year = 1964 bio = 'Co-author of The Pragmatic Programmer.' )
      ( name = 'David Thomas' country = 'UK' born_year = 1956 bio = 'Co-author of The Pragmatic Programmer.' )
      ( name = 'N. K. Jemisin' country = 'USA' born_year = 1972 bio = 'Three-time Hugo winner for the Broken Earth trilogy.' )
    ).
    LOOP AT authors ASSIGNING FIELD-SYMBOL(<a>).
      TRY.
          <a>-author_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
      ENDTRY.
      <a>-created_by = user. <a>-created_at = now.
      <a>-last_changed_by = user. <a>-last_changed_at = now. <a>-local_last_changed_at = now.
    ENDLOOP.
    INSERT zabapd_s_author FROM TABLE @authors.
    COMMIT WORK.
    out->write( |Inserted { lines( authors ) } authors into ZABAPD_S_AUTHOR.| ).
  ENDMETHOD.
ENDCLASS.
