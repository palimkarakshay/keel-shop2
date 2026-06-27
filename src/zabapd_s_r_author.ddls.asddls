@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bookstore - author root view'
define root view entity ZABAPD_S_R_AUTHOR
  as select from zabapd_s_author as Author
{
  key author_uuid as AuthorUuid,
      name        as Name,
      country     as Country,
      born_year   as BornYear,
      bio         as Bio,
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
