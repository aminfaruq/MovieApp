package co.id.aminfaruq.core.domain.usecase.movie

import co.id.aminfaruq.core.domain.model.Popular
import io.reactivex.Single

interface MovieUseCase {

    fun getPopular(
        api_key: String,
        language: String,
        page: Int
    ): Single<List<Popular>>
}