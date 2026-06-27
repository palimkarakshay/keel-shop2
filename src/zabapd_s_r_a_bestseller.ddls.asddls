@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Analytics - bestsellers'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZABAPD_S_R_A_BESTSELLER
  as select from zabapd_s_oitem as Item
    inner join zabapd_s_order as Ord on Item.order_uuid = Ord.order_uuid
{
  key Item.book_uuid     as BookUuid,
  key Item.currency_code as CurrencyCode,
      max( Item.book_title ) as BookTitle,
      sum( Item.quantity )   as UnitsSold,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      sum( Item.line_amount ) as Revenue
}
where Ord.status <> 'X'
group by Item.book_uuid, Item.currency_code
