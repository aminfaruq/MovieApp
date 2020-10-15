package co.id.aminfaruq.core.domain.usecase.detail

import co.id.aminfaruq.core.domain.repository.DetailRepository

class DetailInteractor(private val detailRepository: DetailRepository) :
    DetailUseCase {

    override fun getDetailMovie(movie_id: String, api_key: String, language: String) =
        detailRepository.getDetailMovie(movie_id, api_key, language)

    override fun getDetailTrailer(
        movie_id: String,
        api_key: String,
        language: String
    ) = detailRepository.getDetailTrailer(movie_id, api_key, language)

    override fun getDetailCredits(movie_id: String, api_key: String) =
        detailRepository.getDetailCredits(movie_id, api_key)

    override fun getSimilarMovie(
        movie_id: String,
        api_key: String,
        language: String,
        page: Int
    ) = detailRepository.getSimilarMovie(movie_id, api_key, language, page)
}