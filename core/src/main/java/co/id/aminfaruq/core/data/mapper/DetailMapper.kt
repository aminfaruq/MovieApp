package co.id.aminfaruq.core.data.mapper

import co.id.aminfaruq.core.data.source.remote.response.detail.ResponseDetail
import co.id.aminfaruq.core.domain.model.Detail

class DetailMapper : BaseMapper<ResponseDetail , Detail> {
    override fun mapToDomain(model: ResponseDetail): Detail {
        return Detail(
            model.adult,
            model.backdrop_path,
            model.budget,
            model.genres,
            model.homepage,
            model.id,
            model.imdb_id,
            model.original_language,
            model.original_title,
            model.overview,
            model.popularity,
            model.poster_path,
            model.production_companies,
            model.production_countries,
            model.release_date,
            model.revenue,
            model.runtime,
            model.spoken_languages,
            model.status,
            model.tagline,
            model.title,
            model.video,
            model.vote_average,
            model.vote_count
        )
    }

    override fun mapToModel(domain: Detail): ResponseDetail {
        return ResponseDetail(
            domain.adult,
            domain.backdrop_path,
            domain.budget,
            domain.genres,
            domain.homepage,
            domain.id,
            domain.imdb_id,
            domain.original_language,
            domain.original_title,
            domain.overview,
            domain.popularity,
            domain.poster_path,
            domain.production_companies,
            domain.production_countries,
            domain.release_date,
            domain.revenue,
            domain.runtime,
            domain.spoken_languages,
            domain.status,
            domain.tagline,
            domain.title,
            domain.video,
            domain.vote_average,
            domain.vote_count
        )
    }
}