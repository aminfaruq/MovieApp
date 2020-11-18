package co.id.aminfaruq.core.data.mapper

import co.id.aminfaruq.core.data.source.remote.response.people.PeopleItem
import co.id.aminfaruq.core.domain.model.People

class PeopleMapper : BaseMapper<PeopleItem , People> {
    override fun mapToDomain(model: PeopleItem): People {
        return People(
            model.adult,
            model.gender,
            model.id,
            model.known_for,
            model.known_for_department,
            model.name,
            model.popularity,
            model.profile_path
        )
    }

    override fun mapToModel(domain: People): PeopleItem {
        return PeopleItem(
            domain.adult,
            domain.gender,
            domain.id,
            domain.known_for,
            domain.known_for_department,
            domain.name,
            domain.popularity,
            domain.profile_path
        )
    }
}