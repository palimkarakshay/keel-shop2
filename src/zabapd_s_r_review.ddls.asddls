@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bookstore - review root view'
define root view entity ZABAPD_S_R_REVIEW
  as select from zabapd_s_review as Review
{
  key review_uuid as ReviewUuid,
      book_uuid     as BookUuid,
      book_title    as BookTitle,
      customer_uuid as CustomerUuid,
      customer_name as CustomerName,
      rating        as Rating,
      case when rating >= 4 then 3 when rating = 3 then 2 else 1 end as RatingCriticality,
      comment_text  as Comment,
      review_date   as ReviewDate,
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
