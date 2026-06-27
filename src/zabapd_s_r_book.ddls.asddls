@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bookstore - book root view'
define root view entity ZABAPD_S_R_BOOK
  as select from zabapd_s_book as Book
{
  key book_uuid as BookUuid,
      title         as Title,
      author        as Author,
      genre         as Genre,
      release_year  as ReleaseYear,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price         as Price,
      currency_code as CurrencyCode,
      rating        as Rating,
      status        as Status,
      case status when 'A' then 3 when 'O' then 2 else 1 end as StatusCriticality,
      featured      as Featured,
      @Semantics.user.createdBy: true
      created_by    as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at    as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
