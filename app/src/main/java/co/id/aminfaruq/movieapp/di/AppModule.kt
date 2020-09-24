package co.id.aminfaruq.movieapp.di

import co.id.aminfaruq.core.domain.usecase.HomeIteractor
import co.id.aminfaruq.core.domain.usecase.HomeUseCase
import org.koin.dsl.module

val useCaseModule = module {
    factory<HomeUseCase> { HomeIteractor(get()) }
}

val viewModelModule = module {

}