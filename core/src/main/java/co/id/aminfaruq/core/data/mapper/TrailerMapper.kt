package co.id.aminfaruq.core.data.mapper

import co.id.aminfaruq.core.data.source.remote.response.trailer.TrailerItem
import co.id.aminfaruq.core.domain.model.Trailer

class TrailerMapper : BaseMapper<TrailerItem , Trailer> {
    override fun mapToDomain(model: TrailerItem): Trailer {
        return Trailer(
            model.id,
            model.iso_3166_1,
            model.iso_639_1,
            model.key,
            model.name,
            model.site,
            model.size,
            model.type
        )
    }

    override fun mapToModel(domain: Trailer): TrailerItem {
        return TrailerItem(
            domain.id,
            domain.iso_3166_1,
            domain.iso_639_1,
            domain.key,
            domain.name,
            domain.site,
            domain.size,
            domain.type
        )
    }
}