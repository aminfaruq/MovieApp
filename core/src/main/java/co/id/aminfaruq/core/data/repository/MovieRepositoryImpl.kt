package co.id.aminfaruq.core.data.repository

import co.id.aminfaruq.core.data.mapper.PopularMapper
import co.id.aminfaruq.core.data.source.remote.network.ApiService
import co.id.aminfaruq.core.domain.model.Popular
import co.id.aminfaruq.core.domain.repository.MovieRepository
import io.reactivex.Single

class MovieRepositoryImpl(
    private val apiService: ApiService,
    private val itemPopularMapper: PopularMapper
): MovieRepository {
    override fun getPopular(api_key: String, language: String, page: Int): Single<List<Popular>> {
        return apiService.popularMovie(
            api_key, language, page).map {
            itemPopularMapper.mapToListDomain(it.results)
        }
    }

}