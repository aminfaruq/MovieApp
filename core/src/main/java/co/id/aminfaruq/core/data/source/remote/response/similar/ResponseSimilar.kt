package co.id.aminfaruq.core.data.source.remote.response.similar

data class ResponseSimilar(
    val page: Int,
    val results: List<SimilarItem>,
    val total_pages: Int,
    val total_results: Int
)