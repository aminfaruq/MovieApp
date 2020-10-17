package co.id.aminfaruq.core.data.mapper.entityMapper

import co.id.aminfaruq.core.data.mapper.BaseMapper
import co.id.aminfaruq.core.data.source.local.entity.DiscoverEntity
import co.id.aminfaruq.core.domain.model.Discover

class DiscoverEntityMapper : BaseMapper<DiscoverEntity , Discover> {
    override fun mapToDomain(model: DiscoverEntity): Discover {
        return Discover(
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
            model.title,
            model.video,
            model.vote_average,
            model.vote_count
        )
    }

    override fun mapToModel(domain: Discover): DiscoverEntity {
        return DiscoverEntity(
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
            domain.title,
            domain.video,
            domain.vote_average,
            domain.vote_count
        )
    }
}