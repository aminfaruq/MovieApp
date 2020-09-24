package co.id.aminfaruq.movieapp.di

import co.id.aminfaruq.core.domain.usecase.HomeIteractor
import co.id.aminfaruq.core.domain.usecase.HomeUseCase
import co.id.aminfaruq.movieapp.ui.home.HomeVM
import org.koin.android.viewmodel.dsl.viewModel
import org.koin.dsl.module

val useCaseModule = module {
    factory<HomeUseCase> { HomeIteractor(get()) }
}

val viewModelModule = module {
    viewModel { HomeVM(get()) }
}