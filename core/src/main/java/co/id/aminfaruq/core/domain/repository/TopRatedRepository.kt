package co.id.aminfaruq.core.domain.repository

import co.id.aminfaruq.core.domain.model.TopRated
import io.reactivex.Single

interface TopRatedRepository {

    fun getTopRated(api_key : String , language : String , page : Int): Single<List<TopRated>>
}