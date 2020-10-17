package co.id.aminfaruq.core.data.source.local.room

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import co.id.aminfaruq.core.data.source.local.entity.DiscoverEntity
import co.id.aminfaruq.core.domain.model.Discover
import io.reactivex.Single

@Dao
interface HomeDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insertDiscover(discover: DiscoverEntity)

    @Query("DELETE FROM discoverHome WHERE id=:idDiscover ")
    fun removeDiscover(idDiscover: Int)

    @Query("SELECT * FROM discoverHome WHERE id=:idDiscover")
    fun getFavDiscoverById(idDiscover: Int): Single<List<Discover>>

    @Query("SELECT * FROM discoverHome ORDER BY id ASC")
    fun getFavDiscover(): LiveData<List<Discover>>


}