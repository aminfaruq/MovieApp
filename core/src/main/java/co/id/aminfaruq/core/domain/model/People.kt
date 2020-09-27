package co.id.aminfaruq.core.domain.model

import co.id.aminfaruq.core.data.source.remote.response.people.KnownFor

data class People(
    val adult: Boolean?,
    val gender: Int?,
    val id: Int?,
    val known_for: List<KnownFor>,
    val known_for_department: String?,
    val name: String?,
    val popularity: Double?,
    val profile_path: String?
)