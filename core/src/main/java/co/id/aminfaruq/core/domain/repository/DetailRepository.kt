package co.id.aminfaruq.core.domain.repository

import co.id.aminfaruq.core.domain.model.Detail
import io.reactivex.Single

interface DetailRepository {

    fun getDetailMovie(
        movie_id: String,
        api_key: String,
        language: String,
    ): Single<Detail>

}