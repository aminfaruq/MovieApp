package co.id.aminfaruq.core.domain.usecase.movie

import co.id.aminfaruq.core.domain.model.Popular
import co.id.aminfaruq.core.domain.model.TopRated
import io.reactivex.Single

interface MovieUseCase {

    fun getTopRated(
        api_key: String,
        language: String,
        page: Int
    ): Single<List<TopRated>>

    fun getPopular(
        api_key: String,
        language: String,
        page: Int
    ): Single<List<Popular>>
}