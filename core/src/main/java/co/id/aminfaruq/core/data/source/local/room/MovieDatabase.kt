package co.id.aminfaruq.core.data.source.local.room

import androidx.room.Database
import androidx.room.RoomDatabase
import co.id.aminfaruq.core.data.source.local.entity.DiscoverEntity

@Database(
    entities = [DiscoverEntity::class],
    version = 1,
    exportSchema = false
)
abstract class MovieDatabase : RoomDatabase() {

    abstract fun homeDao(): HomeDao

    abstract fun movieDao(): MovieDao
}