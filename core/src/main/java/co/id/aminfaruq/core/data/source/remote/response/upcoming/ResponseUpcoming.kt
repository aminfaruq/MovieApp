package co.id.aminfaruq.core.data.source.remote.response.upcoming

data class ResponseUpcoming(
    val dates: Dates,
    val page: Int,
    val results: List<UpcomingItem>,
    val total_pages: Int,
    val total_results: Int
)