package co.id.aminfaruq.movieapp.detail.ui

import androidx.lifecycle.MutableLiveData
import co.id.aminfaruq.core.domain.model.Detail
import co.id.aminfaruq.core.domain.model.Trailer
import co.id.aminfaruq.core.domain.usecase.DetailUseCase
import co.id.aminfaruq.core.ui.BaseViewModel
import co.id.aminfaruq.core.utils.Constants
import co.id.aminfaruq.core.utils.RxUtils

class DetailVM(private val detailUseCase: DetailUseCase) : BaseViewModel() {

    val postDetailMovieData = MutableLiveData<Detail>()
    val postTrailerMovieData = MutableLiveData<List<Trailer>>()
    val showProgressbar = MutableLiveData<Boolean>()
    val messageData = MutableLiveData<String>()

    fun getDetailMovie(idMovie: String) {
        showProgressbar.value = true
        compositeDisposable.add(
            detailUseCase.getDetailMovie(idMovie, Constants.API_KEY, Constants.LANG)
                .compose(RxUtils.applySingleAsync())
                .subscribe({ result ->
                    if (result != null) {
                        postDetailMovieData.value = result
                    } else {
                        messageData.value = "Tidak ada data"
                    }
                }, this::onError)
        )
    }

    fun getTrailerMovie(idMovie: String) {
        showProgressbar.value = true
        compositeDisposable.add(
            detailUseCase.getDetailTrailer(idMovie, Constants.API_KEY, Constants.LANG)
                .compose(RxUtils.applySingleAsync())
                .subscribe({ result ->
                    if (result.isNotEmpty()) {
                        postTrailerMovieData.value = result
                    } else {
                        messageData.value = "Tidak ada data"
                    }
                }, this::onError)
        )
    }

    override fun onError(error: Throwable) {
        messageData.value = error.message
    }
}