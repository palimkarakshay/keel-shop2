@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bookstore - customer root view'
define root view entity ZABAPD_S_R_CUSTOMER
  as select from zabapd_s_cust as Customer
{
  key customer_uuid as CustomerUuid,
      customer_no   as CustomerNo,
      name          as Name,
      email         as Email,
      city          as City,
      country       as Country,
      loyalty_tier  as LoyaltyTier,
      case loyalty_tier when 'P' then 3 when 'G' then 3 when 'S' then 2 else 1 end as LoyaltyCriticality,
      since         as Since,
      @Semantics.user.createdBy: true
      created_by  as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at  as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
