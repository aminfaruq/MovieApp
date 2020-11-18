package co.id.aminfaruq.core.data.source.remote.response.people

data class ResponsePeople(
    val page: Int,
    val results: List<PeopleItem>,
    val total_pages: Int,
    val total_results: Int
)