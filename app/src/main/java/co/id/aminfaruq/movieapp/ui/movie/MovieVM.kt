package co.id.aminfaruq.movieapp.ui.movie

import androidx.lifecycle.MutableLiveData
import co.id.aminfaruq.core.domain.model.Popular
import co.id.aminfaruq.core.domain.usecase.movie.MovieUseCase
import co.id.aminfaruq.core.ui.BaseViewModel
import co.id.aminfaruq.core.utils.Constants
import co.id.aminfaruq.core.utils.RxUtils

class MovieVM(private val movieUseCase: MovieUseCase): BaseViewModel() {
    val postPopularData = MutableLiveData<List<Popular>>()
    val messageData = MutableLiveData<String>()
    val showProgressBar = MutableLiveData<Boolean>()

    fun getPopular() {
        showProgressBar.value = true
        compositeDisposable.add(
            movieUseCase.getPopular(Constants.API_KEY, Constants.LANG, 1)
                .compose(RxUtils.applySingleAsync())
                .subscribe({ result ->
                    if (result.isNotEmpty()) {
                        postPopularData.value = result
                    } else {
                        messageData.value = "Data Kosong"
                    }
                }, this::onError)
        )
    }

    override fun onError(error: Throwable) {
        messageData.value = error.message
    }

}