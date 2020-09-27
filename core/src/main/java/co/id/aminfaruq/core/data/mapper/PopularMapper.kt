package co.id.aminfaruq.core.data.mapper

import co.id.aminfaruq.core.data.source.remote.response.popular.PopularItem
import co.id.aminfaruq.core.domain.model.Popular

class PopularMapper : BaseMapper<PopularItem , Popular> {
    override fun mapToDomain(model: PopularItem): Popular {
        return Popular(
            model.overview,
            model.originalLanguage,
            model.originalTitle,
            model.video,
            model.title,
            model.genreIds,
            model.posterPath,
            model.backdropPath,
            model.releaseDate,
            model.popularity,
            model.voteAverage,
            model.id,
            model.adult,
            model.voteCount
        )
    }

    override fun mapToModel(domain: Popular): PopularItem {
        return PopularItem(
            domain.overview,
            domain.originalLanguage,
            domain.originalTitle,
            domain.video,
            domain.title,
            domain.genreIds,
            domain.posterPath,
            domain.backdropPath,
            domain.releaseDate,
            domain.popularity,
            domain.voteAverage,
            domain.id,
            domain.adult,
            domain.voteCount
        )
    }

}