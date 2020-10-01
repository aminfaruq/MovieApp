package co.id.aminfaruq.core.domain.usecase

import co.id.aminfaruq.core.domain.model.Detail
import co.id.aminfaruq.core.domain.model.Trailer
import io.reactivex.Single

interface DetailUseCase {

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
}