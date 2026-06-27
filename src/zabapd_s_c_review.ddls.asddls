@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bookstore - review projection'
@Metadata.allowExtensions: true
define root view entity ZABAPD_S_C_REVIEW
  provider contract transactional_query
  as projection on ZABAPD_S_R_REVIEW
{
  key ReviewUuid,
      BookUuid, BookTitle, CustomerUuid, CustomerName, Rating, RatingCriticality, Comment, ReviewDate,
      CreatedBy, CreatedAt, LastChangedBy, LastChangedAt, LocalLastChangedAt
}
