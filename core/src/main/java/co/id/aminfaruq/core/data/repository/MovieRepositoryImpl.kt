package co.id.aminfaruq.core.data.repository

import co.id.aminfaruq.core.data.mapper.*
import co.id.aminfaruq.core.data.source.remote.network.ApiService
import co.id.aminfaruq.core.domain.model.*
import co.id.aminfaruq.core.domain.repository.MovieRepository
import io.reactivex.Single

class MovieRepositoryImpl(
    private val apiService: ApiService,
    private val itemPopularMapper: PopularMapper,
    private val itemTopRatedMapper: TopRatedMapper,
    private val itemUpcomingMapper: UpcomingMapper,
    private val itemNowPlaying: NowPlayingMapper,
    private val itemGenre: GenreMapper
): MovieRepository {
    override fun getTopRated(api_key: String, language: String, page: Int): Single<List<TopRated>> {
        return apiService.getTopRated(api_key, language, page).map {
            itemTopRatedMapper.mapToListDomain(it.results)
        }
    }

    override fun getPopular(api_key: String, language: String, page: Int): Single<List<Popular>> {
        return apiService.popularMovie(
            api_key, language, page).map {
            itemPopularMapper.mapToListDomain(it.results)
        }
    }

    override fun getUpcoming(api_key: String, language: String, page: Int): Single<List<Upcoming>> {
        return apiService.upcomingMovie(api_key, language, page).map {
            itemUpcomingMapper.mapToListDomain(it.results)
        }
    }

    override fun getNowPlaying(api_key: String, language: String, page: Int): Single<List<NowPlaying>> {
        return apiService.nowPlaying(api_key, language, page).map {
            itemNowPlaying.mapToListDomain(it.results)
        }
    }

    override fun getGenre(api_key: String, language: String): Single<List<Genre>> {
        return apiService.genres(api_key, language).map {
            itemGenre.mapToListDomain(it.genres)
        }
    }


}