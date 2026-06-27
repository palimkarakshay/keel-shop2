@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bookstore - order item view'
define view entity ZABAPD_S_R_ORDERITEM
  as select from zabapd_s_oitem as Item
  association to parent ZABAPD_S_R_ORDER as _Order on $projection.OrderUuid = _Order.OrderUuid
{
  key item_uuid as ItemUuid,
      order_uuid as OrderUuid,
      book_uuid  as BookUuid,
      book_title as BookTitle,
      quantity   as Quantity,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      unit_price as UnitPrice,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      line_amount as LineAmount,
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
      _Order
}
