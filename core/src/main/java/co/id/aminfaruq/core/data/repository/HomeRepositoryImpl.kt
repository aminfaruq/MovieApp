package co.id.aminfaruq.core.data.repository

import co.id.aminfaruq.core.data.mapper.DiscoverMapper
import co.id.aminfaruq.core.data.mapper.PeopleMapper
import co.id.aminfaruq.core.data.mapper.TopRatedMapper
import co.id.aminfaruq.core.data.mapper.UpcomingMapper
import co.id.aminfaruq.core.data.source.remote.network.ApiService
import co.id.aminfaruq.core.domain.model.Discover
import co.id.aminfaruq.core.domain.model.People
import co.id.aminfaruq.core.domain.model.TopRated
import co.id.aminfaruq.core.domain.model.Upcoming
import co.id.aminfaruq.core.domain.repository.HomeRepository
import io.reactivex.Single

class HomeRepositoryImpl(
    private val apiService: ApiService,
    private val itemTopRatedMapper: TopRatedMapper,
    private val itemDiscoverMapper: DiscoverMapper,
    private val itemUpcomingMapper: UpcomingMapper,
    private val itemPeopleMapper: PeopleMapper
) : HomeRepository {
    override fun getTopRated(api_key: String, language: String, page: Int): Single<List<TopRated>> {
        return apiService.getTopRated(api_key, language, page).map {
            itemTopRatedMapper.mapToListDomain(it.results)
        }
    }

    override fun getDiscoverMovie(
        api_key: String,
        language: String,
        sort_by: String,
        include_adult: Boolean,
        include_video: Boolean,
        page: Int,
        with_genres: Int
    ): Single<List<Discover>> {
        return apiService.discoverMovie(
            api_key,
            language,
            sort_by,
            include_adult,
            include_video,
            page,
            with_genres
        ).map {
            itemDiscoverMapper.mapToListDomain(it.results)
        }
    }

    override fun getUpcomingMovie(
        api_key: String,
        language: String,
        page: Int
    ): Single<List<Upcoming>> {
        return apiService.upcomingMovie(
            api_key, language, page
        ).map {
            itemUpcomingMapper.mapToListDomain(it.results)
        }

    }

    override fun getPeoplePopular(
        api_key: String,
        language: String,
        page: Int
    ): Single<List<People>> {
        return apiService.peoplePopular(
            api_key, language, page
        ).map {
            itemPeopleMapper.mapToListDomain(it.results)
        }
    }

}