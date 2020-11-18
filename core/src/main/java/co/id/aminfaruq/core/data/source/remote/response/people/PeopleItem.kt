package co.id.aminfaruq.core.data.source.remote.response.people

data class PeopleItem(
    val adult: Boolean?,
    val gender: Int?,
    val id: Int?,
    val known_for: List<KnownFor>,
    val known_for_department: String?,
    val name: String?,
    val popularity: Double?,
    val profile_path: String?
)