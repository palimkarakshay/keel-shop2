@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Analytics - sales by genre'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZABAPD_S_R_A_GENRE
  as select from zabapd_s_oitem as Item
    inner join zabapd_s_order as Ord on Item.order_uuid = Ord.order_uuid
    inner join zabapd_s_book  as Bk  on Item.book_uuid  = Bk.book_uuid
{
  key Bk.genre           as Genre,
  key Item.currency_code as CurrencyCode,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      sum( Item.line_amount ) as Revenue,
      sum( Item.quantity )    as Units,
      count( * )              as LineItems
}
where Ord.status <> 'X'
group by Bk.genre, Item.currency_code
