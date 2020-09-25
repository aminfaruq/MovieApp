package co.id.aminfaruq.core.domain.usecase

import co.id.aminfaruq.core.domain.repository.HomeRepository

class HomeIteractor(private val topRatedRepository: HomeRepository) : HomeUseCase {
    override fun getTopRated(api_key: String, language: String, page: Int) =
        topRatedRepository.getTopRated(api_key, language, page)
}