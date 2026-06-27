@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bookstore - order root view'
define root view entity ZABAPD_S_R_ORDER
  as select from zabapd_s_order as Ord
  composition [0..*] of ZABAPD_S_R_ORDERITEM as _Items
{
  key order_uuid as OrderUuid,
      order_no      as OrderNo,
      customer_uuid as CustomerUuid,
      customer_name as CustomerName,
      order_date    as OrderDate,
      status        as Status,
      case status when 'X' then 1 when 'N' then 2 else 3 end as StatusCriticality,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_amount  as TotalAmount,
      currency_code as CurrencyCode,
      @Semantics.user.createdBy: true
      created_by    as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at    as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      _Items
}
