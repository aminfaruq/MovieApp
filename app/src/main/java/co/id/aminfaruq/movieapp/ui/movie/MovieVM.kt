package co.id.aminfaruq.movieapp.ui.movie

import androidx.lifecycle.MutableLiveData
import co.id.aminfaruq.core.domain.model.Popular
import co.id.aminfaruq.core.domain.model.TopRated
import co.id.aminfaruq.core.domain.model.Upcoming
import co.id.aminfaruq.core.domain.usecase.movie.MovieUseCase
import co.id.aminfaruq.core.ui.BaseViewModel
import co.id.aminfaruq.core.utils.Constants
import co.id.aminfaruq.core.utils.RxUtils

class MovieVM(private val movieUseCase: MovieUseCase): BaseViewModel() {

    val postTopRatedData = MutableLiveData<List<TopRated>>()
    val postPopularData = MutableLiveData<List<Popular>>()
    val postUpcomingData = MutableLiveData<List<Upcoming>>()
    val messageData = MutableLiveData<String>()
    val showProgressBar = MutableLiveData<Boolean>()

    fun getTopRated() {
        showProgressBar.value = true
        compositeDisposable.add(
            movieUseCase.getTopRated(Constants.API_KEY, Constants.LANG, 1)
                .compose(RxUtils.applySingleAsync())
                .subscribe({ results ->
                    if (results.isNotEmpty()) {
                        postTopRatedData.value = results
                    } else {
                        messageData.value = "Data Kosong"
                    }
                }, this::onError)
        )
    }

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

    fun getUpcoming() {
        showProgressBar.value = true
        compositeDisposable.add(
            movieUseCase.getUpcoming(Constants.API_KEY, Constants.LANG, 1)
                .compose(RxUtils.applySingleAsync())
                .subscribe({ result ->
                    if (result.isNotEmpty()) {
                        postUpcomingData.value = result
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

















