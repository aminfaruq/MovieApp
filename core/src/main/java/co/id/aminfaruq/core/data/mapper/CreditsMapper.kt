package co.id.aminfaruq.core.data.mapper

import co.id.aminfaruq.core.data.source.remote.response.credits.CreditsItem
import co.id.aminfaruq.core.domain.model.Credits

class CreditsMapper : BaseMapper<CreditsItem, Credits> {
    override fun mapToDomain(model: CreditsItem): Credits {
        return Credits(
            model.cast_id,
            model.character,
            model.credit_id,
            model.gender,
            model.id,
            model.name,
            model.order,
            model.profile_path
        )
    }

    override fun mapToModel(domain: Credits): CreditsItem {
        return CreditsItem(
            domain.cast_id,
            domain.character,
            domain.credit_id,
            domain.gender,
            domain.id,
            domain.name,
            domain.order,
            domain.profile_path

        )
    }
}