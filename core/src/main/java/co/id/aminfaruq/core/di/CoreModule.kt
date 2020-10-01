package co.id.aminfaruq.core.di

import co.id.aminfaruq.core.data.mapper.*
import co.id.aminfaruq.core.data.repository.DetailRepositoryImpl
import co.id.aminfaruq.core.data.repository.HomeRepositoryImpl
import co.id.aminfaruq.core.data.source.remote.network.ApiService
import co.id.aminfaruq.core.domain.repository.DetailRepository
import co.id.aminfaruq.core.domain.repository.HomeRepository
import co.id.aminfaruq.core.utils.Constants
import okhttp3.CertificatePinner
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import org.koin.dsl.module
import retrofit2.Retrofit
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.Executor
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

val databaseModule = module {
    single { getExecutor() }

}

val networkModule = module {
    single {
        val hostname = "api.themoviedb.org"
        val certificatePinner = CertificatePinner.Builder()
            .add(hostname, "sha256/HkCBucsA3Tgiby96X7vjb/ojHaE1BrjvZ2+LRdJJd0E=")
            .add(hostname, "sha256/nKWcsYrc+y5I8vLf1VGByjbt+Hnasjl+9h8lNKJytoE=")
            .add(hostname, "sha256/r/mIkG3eEpVdm+u/ko/cwxzOMo1bk4TyHIlByibiA5E=")
            .build()
        OkHttpClient.Builder()
            .addInterceptor(HttpLoggingInterceptor().setLevel(HttpLoggingInterceptor.Level.BODY))
            .connectTimeout(120, TimeUnit.SECONDS)
            .readTimeout(120, TimeUnit.SECONDS)
            .certificatePinner(certificatePinner)
            .build()
    }

    single {
        val retrofit = Retrofit.Builder()
            .baseUrl(Constants.BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
            .client(get())
            .build()
        retrofit.create(ApiService::class.java)

    }
}

fun getExecutor(): Executor {
    return Executors.newFixedThreadPool(2)
}


val repositoryModule = module {
    single {
        HomeRepositoryImpl(
            get(),
            get(),
            get(),
            get(),
            get()
        ) as HomeRepository
    }

    single {
        DetailRepositoryImpl(
            get(),
            get(),
            get()
        ) as DetailRepository
    }


}

val mapperModule = module {
    single { TopRatedMapper() }
    single { DiscoverMapper() }
    single { UpcomingMapper() }
    single { PeopleMapper() }
    single { DetailMapper() }
    single { TrailerMapper() }
}