CLASS zcl_abapd_s_customer_gen DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_abapd_s_customer_gen IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM zabapd_s_cust.
    DATA now TYPE timestampl.
    GET TIME STAMP FIELD now.
    DATA(user) = cl_abap_context_info=>get_user_technical_name( ).
    DATA customers TYPE STANDARD TABLE OF zabapd_s_cust.
    customers = VALUE #(
      ( customer_no = 'C100001' name = 'Maya Chen' email = 'maya.chen@example.com' city = 'Toronto' country = 'Canada' loyalty_tier = 'P' since = '20210307' )
      ( customer_no = 'C100002' name = 'Liam O''Brien' email = 'liam.obrien@example.com' city = 'Dublin' country = 'Ireland' loyalty_tier = 'G' since = '20220119' )
      ( customer_no = 'C100003' name = 'Sofia Rossi' email = 'sofia.rossi@example.com' city = 'Milan' country = 'Italy' loyalty_tier = 'S' since = '20230502' )
      ( customer_no = 'C100004' name = 'Arjun Patel' email = 'arjun.patel@example.com' city = 'Mumbai' country = 'India' loyalty_tier = 'G' since = '20210914' )
      ( customer_no = 'C100005' name = 'Emma Schmidt' email = 'emma.schmidt@example.com' city = 'Berlin' country = 'Germany' loyalty_tier = 'B' since = '20240221' )
      ( customer_no = 'C100006' name = 'Noah Williams' email = 'noah.williams@example.com' city = 'Sydney' country = 'Australia' loyalty_tier = 'S' since = '20221103' )
      ( customer_no = 'C100007' name = 'Yuki Tanaka' email = 'yuki.tanaka@example.com' city = 'Osaka' country = 'Japan' loyalty_tier = 'P' since = '20200628' )
      ( customer_no = 'C100008' name = 'Olivia Martin' email = 'olivia.martin@example.com' city = 'Lyon' country = 'France' loyalty_tier = 'B' since = '20240801' )
      ( customer_no = 'C100009' name = 'Daniel Kim' email = 'daniel.kim@example.com' city = 'Seoul' country = 'South Korea' loyalty_tier = 'G' since = '20211215' )
      ( customer_no = 'C100010' name = 'Grace Nguyen' email = 'grace.nguyen@example.com' city = 'Vancouver' country = 'Canada' loyalty_tier = 'S' since = '20230610' )
    ).
    LOOP AT customers ASSIGNING FIELD-SYMBOL(<cu>).
      TRY.
          <cu>-customer_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
      ENDTRY.
      <cu>-created_by = user. <cu>-created_at = now.
      <cu>-last_changed_by = user. <cu>-last_changed_at = now. <cu>-local_last_changed_at = now.
    ENDLOOP.
    INSERT zabapd_s_cust FROM TABLE @customers.
    COMMIT WORK.
    out->write( |Inserted { lines( customers ) } customers into ZABAPD_S_CUST.| ).
  ENDMETHOD.
ENDCLASS.
