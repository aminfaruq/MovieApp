package co.id.aminfaruq.core.data.repository

import co.id.aminfaruq.core.data.mapper.DetailMapper
import co.id.aminfaruq.core.data.mapper.TrailerMapper
import co.id.aminfaruq.core.data.source.remote.network.ApiService
import co.id.aminfaruq.core.domain.model.Detail
import co.id.aminfaruq.core.domain.model.Trailer
import co.id.aminfaruq.core.domain.repository.DetailRepository
import io.reactivex.Single

class DetailRepositoryImpl(
    private val apiService: ApiService,
    private val itemDetailMapper: DetailMapper,
    private val itemTrailerMapper: TrailerMapper
) : DetailRepository {
    override fun getDetailMovie(
        movie_id: String,
        api_key: String,
        language: String
    ): Single<Detail> {
        return apiService.detailMovie(movie_id, api_key, language).map {
            itemDetailMapper.mapToDomain(it)
        }
    }

    override fun getDetailTrailer(
        movie_id: String,
        api_key: String,
        language: String
    ): Single<List<Trailer>> {
        return apiService.detailTrailer(movie_id, api_key, language).map {
            itemTrailerMapper.mapToListDomain(it.results)
        }
    }
}