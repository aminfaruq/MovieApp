package co.id.aminfaruq.core.data.mapper

import co.id.aminfaruq.core.data.source.remote.response.discover.DiscoverItem
import co.id.aminfaruq.core.domain.model.Discover

class DiscoverMapper : BaseMapper<DiscoverItem , Discover> {
    override fun mapToDomain(model: DiscoverItem): Discover {
        return Discover(
            model.id,
            model.adult,
            model.backdrop_path,
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

    override fun mapToModel(domain: Discover): DiscoverItem {
        return DiscoverItem(
            domain.id,
            domain.adult,
            domain.backdrop_path,
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