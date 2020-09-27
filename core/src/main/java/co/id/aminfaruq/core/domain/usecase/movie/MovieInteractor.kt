package co.id.aminfaruq.core.domain.usecase.movie

import co.id.aminfaruq.core.domain.repository.MovieRepository

class MovieInteractor(private val movieRepository: MovieRepository): MovieUseCase {
    override fun getPopular(api_key: String, language: String, page: Int) =
        movieRepository.getPopular(api_key, language, page)

}