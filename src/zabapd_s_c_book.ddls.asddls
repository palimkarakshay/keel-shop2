@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bookstore - book projection'
@Metadata.allowExtensions: true
define root view entity ZABAPD_S_C_BOOK
  provider contract transactional_query
  as projection on ZABAPD_S_R_BOOK
{
  key BookUuid,
      Title, Author, Genre, ReleaseYear, Price, CurrencyCode,
      Rating, Status, StatusCriticality, Featured,
      CreatedBy, CreatedAt, LastChangedBy, LastChangedAt, LocalLastChangedAt
}
