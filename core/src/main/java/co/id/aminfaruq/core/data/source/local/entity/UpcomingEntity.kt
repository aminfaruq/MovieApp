package co.id.aminfaruq.core.data.source.local.entity

import androidx.room.Entity
import androidx.room.Ignore

@Entity(tableName = "upcomingHome")
data class UpcomingEntity (
    val adult: Boolean?,
    val backdrop_path: String?,
    @Ignore
    val genre_ids: List<Int>,
    val id: Int?,
    val original_language: String?,
    val original_title: String?,
    val overview: String?,
    val popularity: Double?,
    val poster_path: String?,
    val release_date: String?,
    val title: String?,
    val video: Boolean?,
    val vote_average: Double?,
    val vote_count: Int?
)