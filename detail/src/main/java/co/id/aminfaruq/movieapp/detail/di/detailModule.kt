package co.id.aminfaruq.movieapp.detail.di

import co.id.aminfaruq.core.domain.usecase.detail.DetailInteractor
import co.id.aminfaruq.core.domain.usecase.detail.DetailUseCase
import co.id.aminfaruq.movieapp.detail.ui.DetailVM
import org.koin.dsl.module

val detailUseCase = module {
    factory<DetailUseCase> {
        DetailInteractor(
            get()
        )
    }
}

val detailModule = module {
    single { DetailVM(get()) }
}

val detailInject = listOf(detailUseCase, detailModule)