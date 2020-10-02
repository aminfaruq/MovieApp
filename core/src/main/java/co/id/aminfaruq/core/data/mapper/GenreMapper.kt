package co.id.aminfaruq.core.data.mapper

import co.id.aminfaruq.core.data.source.remote.response.genre.GenreItem
import co.id.aminfaruq.core.domain.model.Genre

class GenreMapper : BaseMapper<GenreItem, Genre> {
    override fun mapToDomain(model: GenreItem): Genre {
        return Genre(
            model.id,
            model.name
        )
    }

    override fun mapToModel(domain: Genre): GenreItem {
        return GenreItem(
            domain.id,
            domain.name
        )
    }
}