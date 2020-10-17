package co.id.aminfaruq.core.domain.usecase.home

import co.id.aminfaruq.core.domain.model.Discover
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

    override fun getUpcomingMovie(
        api_key: String,
        language: String,
        page: Int
    ) = homeRepository.getUpcomingMovie(api_key, language, page)

    override fun getPeoplePopular(
        api_key: String,
        language: String,
        page: Int
    ) = homeRepository.getPeoplePopular(api_key, language, page)

    override fun saveDiscovery(discover: Discover) = homeRepository.saveDiscovery(discover)

    override fun removeDiscover(id: Int) = homeRepository.removeDiscover(id)

    override fun checkDiscover(id: Int) = homeRepository.checkDiscover(id)
}