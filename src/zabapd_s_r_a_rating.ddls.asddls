@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Analytics - book ratings'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZABAPD_S_R_A_RATING
  as select from zabapd_s_review as Rev
{
  key Rev.book_uuid as BookUuid,
      max( Rev.book_title )           as BookTitle,
      avg( Rev.rating as abap.dec(4,2) ) as AvgRating,
      count( * )                      as ReviewCount
}
group by Rev.book_uuid
