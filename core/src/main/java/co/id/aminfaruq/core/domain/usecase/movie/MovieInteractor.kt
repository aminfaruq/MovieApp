package co.id.aminfaruq.core.domain.usecase.movie

import co.id.aminfaruq.core.domain.model.TopRated
import co.id.aminfaruq.core.domain.repository.MovieRepository
import io.reactivex.Single

class MovieInteractor(private val movieRepository: MovieRepository): MovieUseCase {
    override fun getTopRated(api_key: String, language: String, page: Int): Single<List<TopRated>> =
        movieRepository.getTopRated(api_key, language, page)

    override fun getPopular(api_key: String, language: String, page: Int) =
        movieRepository.getPopular(api_key, language, page)

}