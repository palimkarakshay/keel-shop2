@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bookstore - author projection'
@Metadata.allowExtensions: true
define root view entity ZABAPD_S_C_AUTHOR
  provider contract transactional_query
  as projection on ZABAPD_S_R_AUTHOR
{
  key AuthorUuid,
      Name,
      Country,
      BornYear,
      Bio,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
