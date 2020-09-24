package co.id.aminfaruq.core.data.source.remote.response.discover

data class ResponseDiscover(
    val page: Int,
    val results: List<DiscoverItem>,
    val total_pages: Int,
    val total_results: Int
)