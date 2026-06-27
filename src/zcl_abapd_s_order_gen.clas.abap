CLASS zcl_abapd_s_order_gen DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PRIVATE SECTION.
    TYPES: BEGIN OF t_spec, cust TYPE i, status TYPE c LENGTH 2, ago TYPE i, n TYPE i,
             b1 TYPE i, q1 TYPE i, b2 TYPE i, q2 TYPE i, b3 TYPE i, q3 TYPE i, END OF t_spec.
    TYPES: BEGIN OF t_li, bi TYPE i, q TYPE i, END OF t_li.
ENDCLASS.

CLASS zcl_abapd_s_order_gen IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM zabapd_s_oitem.
    DELETE FROM zabapd_s_order.
    DATA now TYPE timestampl. GET TIME STAMP FIELD now.
    DATA(user) = cl_abap_context_info=>get_user_technical_name( ).
    DATA(today) = cl_abap_context_info=>get_system_date( ).
    SELECT customer_uuid, name FROM zabapd_s_cust ORDER BY name INTO TABLE @DATA(custs).
    SELECT book_uuid, title, price, currency_code FROM zabapd_s_book ORDER BY title INTO TABLE @DATA(books).
    IF custs IS INITIAL OR books IS INITIAL.
      out->write( 'Seed customers and books first.' ). RETURN.
    ENDIF.
    DATA specs TYPE STANDARD TABLE OF t_spec.
    specs = VALUE #(
      ( cust = 1 status = 'D' ago = 38 n = 2 b1 = 1 q1 = 1 b2 = 4 q2 = 2 )
      ( cust = 2 status = 'D' ago = 31 n = 1 b1 = 7 q1 = 1 )
      ( cust = 3 status = 'S' ago = 12 n = 3 b1 = 2 q1 = 1 b2 = 9 q2 = 1 b3 = 5 q3 = 1 )
      ( cust = 4 status = 'S' ago = 9 n = 1 b1 = 8 q1 = 3 )
      ( cust = 5 status = 'K' ago = 5 n = 2 b1 = 3 q1 = 1 b2 = 6 q2 = 2 )
      ( cust = 6 status = 'P' ago = 3 n = 1 b1 = 10 q1 = 1 )
      ( cust = 7 status = 'P' ago = 2 n = 2 b1 = 1 q1 = 2 b2 = 2 q2 = 1 )
      ( cust = 8 status = 'N' ago = 1 n = 1 b1 = 5 q1 = 1 )
      ( cust = 9 status = 'N' ago = 0 n = 2 b1 = 7 q1 = 1 b2 = 8 q2 = 1 )
      ( cust = 10 status = 'X' ago = 20 n = 1 b1 = 4 q1 = 1 )
      ( cust = 2 status = 'D' ago = 60 n = 2 b1 = 6 q1 = 1 b2 = 3 q2 = 1 )
      ( cust = 4 status = 'D' ago = 75 n = 1 b1 = 9 q1 = 2 )
      ( cust = 1 status = 'S' ago = 7 n = 2 b1 = 10 q1 = 1 b2 = 1 q2 = 1 )
      ( cust = 6 status = 'P' ago = 4 n = 1 b1 = 2 q1 = 2 )
    ).
    DATA orders TYPE STANDARD TABLE OF zabapd_s_order.
    DATA items  TYPE STANDARD TABLE OF zabapd_s_oitem.
    DATA(seq) = 1000.
    LOOP AT specs INTO DATA(sp).
      seq = seq + 1.
      DATA(ouid) = cl_system_uuid=>create_uuid_x16_static( ).
      DATA(cust) = custs[ ( ( sp-cust - 1 ) MOD lines( custs ) ) + 1 ].
      DATA total TYPE p LENGTH 8 DECIMALS 2.
      CLEAR total.
      DATA li TYPE STANDARD TABLE OF t_li.
      CLEAR li.
      APPEND VALUE #( bi = sp-b1 q = sp-q1 ) TO li.
      IF sp-n >= 2. APPEND VALUE #( bi = sp-b2 q = sp-q2 ) TO li. ENDIF.
      IF sp-n >= 3. APPEND VALUE #( bi = sp-b3 q = sp-q3 ) TO li. ENDIF.
      LOOP AT li INTO DATA(l).
        DATA(bk) = books[ ( ( l-bi - 1 ) MOD lines( books ) ) + 1 ].
        DATA line TYPE p LENGTH 8 DECIMALS 2.
        line = bk-price * l-q.
        total = total + line.
        APPEND VALUE #( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) order_uuid = ouid
                        book_uuid = bk-book_uuid book_title = bk-title quantity = l-q
                        unit_price = bk-price line_amount = line currency_code = bk-currency_code
                        created_by = user created_at = now last_changed_by = user
                        last_changed_at = now local_last_changed_at = now ) TO items.
      ENDLOOP.
      APPEND VALUE #( order_uuid = ouid order_no = |SO{ seq }| customer_uuid = cust-customer_uuid
                      customer_name = cust-name order_date = today - sp-ago status = sp-status
                      total_amount = total currency_code = 'USD'
                      created_by = user created_at = now last_changed_by = user
                      last_changed_at = now local_last_changed_at = now ) TO orders.
    ENDLOOP.
    INSERT zabapd_s_order FROM TABLE @orders.
    INSERT zabapd_s_oitem FROM TABLE @items.
    COMMIT WORK.
    out->write( |Inserted { lines( orders ) } orders and { lines( items ) } items.| ).
  ENDMETHOD.
ENDCLASS.
