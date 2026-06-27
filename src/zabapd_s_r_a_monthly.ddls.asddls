@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Analytics - monthly revenue'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZABAPD_S_R_A_MONTHLY
  as select from zabapd_s_order as Ord
{
  key cast( substring( cast( Ord.order_date as abap.char(8) ), 1, 6 ) as abap.char(6) ) as YearMonth,
  key Ord.currency_code as CurrencyCode,
      count( * )        as Orders,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      sum( Ord.total_amount ) as Revenue
}
where Ord.status <> 'X'
group by cast( substring( cast( Ord.order_date as abap.char(8) ), 1, 6 ) as abap.char(6) ), Ord.currency_code
