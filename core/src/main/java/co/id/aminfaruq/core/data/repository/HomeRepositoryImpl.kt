package co.id.aminfaruq.core.data.repository

import co.id.aminfaruq.core.data.mapper.TopRatedMapper
import co.id.aminfaruq.core.data.source.remote.network.ApiService
import co.id.aminfaruq.core.domain.model.TopRated
import co.id.aminfaruq.core.domain.repository.HomeRepository
import io.reactivex.Single

class HomeRepositoryImpl(
    private val apiService: ApiService,
    private val itemTopRatedMapper: TopRatedMapper
) : HomeRepository {
    override fun getTopRated(api_key: String, language: String, page: Int): Single<List<TopRated>> {
        return apiService.getTopRated(api_key, language, page).map {
            itemTopRatedMapper.mapToListDomain(it.results)
        }
    }

}