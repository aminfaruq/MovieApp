package co.id.aminfaruq.core.data.source.remote.network

import co.id.aminfaruq.core.data.source.remote.response.discover.ResponseDiscover
import co.id.aminfaruq.core.data.source.remote.response.topRated.ResponseTopRated
import io.reactivex.Single
import retrofit2.http.GET
import retrofit2.http.Query

interface ApiService {

    @GET("movie/top_rated")
    fun getTopRated(
        @Query("api_key") api_key: String,
        @Query("language") language: String,
        @Query("page") page: Int
    ): Single<ResponseTopRated>

    @GET("discover/movie")
    fun discoverMovie(
        @Query("api_key") api_key: String,
        @Query("language") language: String,
        @Query("sort_by") sort_by: String,
        @Query("include_adult") include_adult: Boolean,
        @Query("include_video") include_video: Boolean,
        @Query("page") page: Int,
        @Query("with_genres") with_genres: Int
    ): Single<ResponseDiscover>
}