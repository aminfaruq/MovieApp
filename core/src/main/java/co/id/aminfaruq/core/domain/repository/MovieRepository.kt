package co.id.aminfaruq.core.domain.repository

import co.id.aminfaruq.core.domain.model.Popular
import io.reactivex.Single

interface MovieRepository {

    fun getPopular(
        api_key: String,
        language: String,
        page: Int
    ): Single<List<Popular>>
}