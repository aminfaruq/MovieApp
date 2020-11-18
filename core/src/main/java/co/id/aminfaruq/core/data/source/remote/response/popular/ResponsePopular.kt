package co.id.aminfaruq.core.data.source.remote.response.popular

data class ResponsePopular(
    val page: Int,
    val results: List<PopularItem>,
    val total_pages: Int,
    val total_results: Int
)