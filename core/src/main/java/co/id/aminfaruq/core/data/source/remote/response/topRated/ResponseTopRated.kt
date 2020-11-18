package co.id.aminfaruq.core.data.source.remote.response.topRated

data class ResponseTopRated(
    val page: Int,
    val results: List<TopRatedItem>,
    val total_pages: Int,
    val total_results: Int
)