package co.id.aminfaruq.core.data.source.remote.response.nowPlaying

data class ResponseNowPlaying(
    val dates: Dates,
    val page: Int,
    val results: List<NowPlayingItem>,
    val total_pages: Int,
    val total_results: Int
)