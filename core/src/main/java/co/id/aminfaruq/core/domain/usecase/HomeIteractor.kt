package co.id.aminfaruq.core.domain.usecase

import co.id.aminfaruq.core.domain.repository.HomeRepository

class HomeIteractor(private val homeRepository: HomeRepository) : HomeUseCase {
    override fun getTopRated(api_key: String, language: String, page: Int) =
        homeRepository.getTopRated(api_key, language, page)

    override fun getDiscoverMovie(
        api_key: String,
        language: String,
        sort_by: String,
        include_adult: Boolean,
        include_video: Boolean,
        page: Int,
        with_genres: Int
    ) = homeRepository.getDiscoverMovie(
        api_key,
        language,
        sort_by,
        include_adult,
        include_video,
        page,
        with_genres
    )
}