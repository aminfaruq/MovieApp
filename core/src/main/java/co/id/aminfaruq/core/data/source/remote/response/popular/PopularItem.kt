package co.id.aminfaruq.core.data.source.remote.response.popular

data class PopularItem(
    val overview: String?,
    val originalLanguage: String?,
    val originalTitle: String?,
    val video: Boolean?,
    val title: String?,
    val genreIds: List<Int>?,
    val posterPath: String?,
    val backdropPath: String?,
    val releaseDate: String?,
    val popularity: Double?,
    val voteAverage: Double?,
    val id: Int?,
    val adult: Boolean?,
    val voteCount: Int?
)