package co.id.aminfaruq.movieapp.di

import co.id.aminfaruq.core.domain.usecase.home.HomeIteractor
import co.id.aminfaruq.core.domain.usecase.home.HomeUseCase
import co.id.aminfaruq.core.domain.usecase.movie.MovieInteractor
import co.id.aminfaruq.core.domain.usecase.movie.MovieUseCase
import co.id.aminfaruq.movieapp.ui.home.HomeVM
import co.id.aminfaruq.movieapp.ui.movie.MovieVM
import org.koin.android.viewmodel.dsl.viewModel
import org.koin.dsl.module

val useCaseModule = module {
    factory<HomeUseCase> { HomeIteractor(get()) }
    factory<MovieUseCase> { MovieInteractor(get()) }
}

val viewModelModule = module {
    viewModel { HomeVM(get()) }
    viewModel { MovieVM(get()) }
}