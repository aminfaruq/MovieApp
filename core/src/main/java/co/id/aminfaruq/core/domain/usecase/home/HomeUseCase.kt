package co.id.aminfaruq.core.domain.usecase.home

import co.id.aminfaruq.core.domain.model.Discover
import co.id.aminfaruq.core.domain.model.People
import co.id.aminfaruq.core.domain.model.TopRated
import co.id.aminfaruq.core.domain.model.Upcoming
import io.reactivex.Single

interface HomeUseCase {

    fun getTopRated(
        api_key: String,
        language: String,
        page: Int
    ): Single<List<TopRated>>

    fun getDiscoverMovie(
        api_key: String,
        language: String,
        sort_by: String,
        include_adult: Boolean,
        include_video: Boolean,
        page: Int,
        with_genres: Int
    ) : Single<List<Discover>>

    fun getUpcomingMovie(
        api_key: String,
        language: String,
        page: Int
    ): Single<List<Upcoming>>

    fun getPeoplePopular(
        api_key: String,
        language: String,
        page: Int
    ): Single<List<People>>
}