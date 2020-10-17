package co.id.aminfaruq.movieapp

import android.app.Application
import co.id.aminfaruq.core.di.*
import co.id.aminfaruq.movieapp.di.useCaseModule
import co.id.aminfaruq.movieapp.di.viewModelModule
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.core.context.startKoin
import timber.log.Timber

class MyApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        Timber.plant(Timber.DebugTree())
        startKoin {
            androidLogger()
            androidContext(this@MyApplication)
            modules(
                listOf(
                    databaseModule,
                    networkModule,
                    repositoryModule,
                    useCaseModule,
                    viewModelModule,
                    mapperModule,
                    entityMapperModule
                )
            )
        }
    }
}