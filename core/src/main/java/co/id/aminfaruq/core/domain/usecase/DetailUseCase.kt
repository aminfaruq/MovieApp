package co.id.aminfaruq.core.domain.usecase

import co.id.aminfaruq.core.domain.model.Detail
import io.reactivex.Single

interface DetailUseCase {

    fun getDetailMovie(
        movie_id: Int,
        api_key: String,
        language: String,
    ): Single<Detail>
}