@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bookstore - customer projection'
@Metadata.allowExtensions: true
define root view entity ZABAPD_S_C_CUSTOMER
  provider contract transactional_query
  as projection on ZABAPD_S_R_CUSTOMER
{
  key CustomerUuid,
      CustomerNo,
      Name,
      Email,
      City,
      Country,
      LoyaltyTier,
      LoyaltyCriticality,
      Since,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
