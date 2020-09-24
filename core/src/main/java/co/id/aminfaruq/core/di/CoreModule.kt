package co.id.aminfaruq.core.di

import org.koin.dsl.module
import java.util.concurrent.Executor
import java.util.concurrent.Executors

val databaseModule = module {
    single { getExecutor() }

}

val networkModule = module {

}

fun getExecutor(): Executor {
    return Executors.newFixedThreadPool(2)
}


val repositoryModule = module {

}

val mapperModule = module {

}