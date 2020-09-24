package co.id.aminfaruq.core.domain.usecase

import co.id.aminfaruq.core.domain.model.TopRated
import io.reactivex.Single

interface HomeUseCase {
    fun getTopRated(api_key : String , language : String , page : Int): Single<List<TopRated>>
}