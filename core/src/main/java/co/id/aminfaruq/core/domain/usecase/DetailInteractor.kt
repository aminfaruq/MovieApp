package co.id.aminfaruq.core.domain.usecase

import co.id.aminfaruq.core.domain.repository.DetailRepository

class DetailInteractor(private val detailRepository: DetailRepository) : DetailUseCase {
    override fun getDetailMovie(movie_id: Int, api_key: String, language: String) =
        detailRepository.getDetailMovie(movie_id, api_key, language)
}