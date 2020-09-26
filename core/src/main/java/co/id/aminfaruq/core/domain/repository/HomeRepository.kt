package co.id.aminfaruq.core.domain.repository

import co.id.aminfaruq.core.domain.model.Discover
import co.id.aminfaruq.core.domain.model.TopRated
import io.reactivex.Single

interface HomeRepository {

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

}