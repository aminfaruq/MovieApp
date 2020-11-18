package co.id.aminfaruq.core.data.mapper

import co.id.aminfaruq.core.data.source.remote.response.similar.SimilarItem
import co.id.aminfaruq.core.domain.model.SimilarMovie

class SimilarMapper : BaseMapper<SimilarItem , SimilarMovie> {
    override fun mapToDomain(model: SimilarItem): SimilarMovie {
        return SimilarMovie(
            model.adult,
            model.backdrop_path,
            model.genre_ids,
            model.id,
            model.original_language,
            model.original_title,
            model.overview,
            model.popularity,
            model.poster_path,
            model.release_date,
            model.original_title,
            model.video,
            model.vote_average,
            model.vote_count
        )
    }

    override fun mapToModel(domain: SimilarMovie): SimilarItem {
        return SimilarItem(
            domain.adult,
            domain.backdrop_path,
            domain.genre_ids,
            domain.id,
            domain.original_language,
            domain.original_title,
            domain.overview,
            domain.popularity,
            domain.poster_path,
            domain.release_date,
            domain.original_title,
            domain.video,
            domain.vote_average,
            domain.vote_count
        )
    }
}