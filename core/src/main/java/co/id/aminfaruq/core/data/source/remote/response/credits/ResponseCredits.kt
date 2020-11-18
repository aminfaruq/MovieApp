package co.id.aminfaruq.core.data.source.remote.response.credits

data class ResponseCredits(
    val cast: List<CreditsItem>,
    val crew: List<Crew>,
    val id: Int
)