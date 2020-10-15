package co.id.aminfaruq.core.domain.repository

import co.id.aminfaruq.core.domain.model.Credits
import co.id.aminfaruq.core.domain.model.Detail
import co.id.aminfaruq.core.domain.model.SimilarMovie
import co.id.aminfaruq.core.domain.model.Trailer
import io.reactivex.Single

interface DetailRepository {

    fun getDetailMovie(
        movie_id: String,
        api_key: String,
        language: String,
    ): Single<Detail>

    fun getDetailTrailer(
        movie_id: String,
        api_key: String,
        language: String,
    ): Single<List<Trailer>>

    fun getDetailCredits(
        movie_id: String,
        api_key: String,
    ): Single<List<Credits>>

    fun getSimilarMovie(
        movie_id: String,
        api_key: String,
        language: String,
        page: Int
    ): Single<List<SimilarMovie>>


}