package co.id.aminfaruq.core.domain.usecase.movie

import co.id.aminfaruq.core.domain.model.*
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

    fun getUpcoming(
        api_key: String,
        language: String,
        page: Int
    ): Single<List<Upcoming>>

    fun getNowPlaying(
        api_key: String,
        language: String,
        page: Int
    ): Single<List<NowPlaying>>

}