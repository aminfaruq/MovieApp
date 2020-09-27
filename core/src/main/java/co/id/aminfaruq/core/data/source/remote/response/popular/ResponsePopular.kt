package co.id.aminfaruq.core.data.source.remote.response.popular

data class ResponsePopular(
    val page: Int,
    val totalPages: Int,
    val results: List<PopularItem>,
    val totalResults: Int
)

