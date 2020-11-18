package co.id.aminfaruq.movieapp.ui.home

import androidx.lifecycle.MutableLiveData
import co.id.aminfaruq.core.domain.model.Discover
import co.id.aminfaruq.core.domain.model.People
import co.id.aminfaruq.core.domain.model.TopRated
import co.id.aminfaruq.core.domain.model.Upcoming
import co.id.aminfaruq.core.domain.usecase.home.HomeUseCase
import co.id.aminfaruq.core.ui.BaseViewModel
import co.id.aminfaruq.core.utils.Constants
import co.id.aminfaruq.core.utils.RxUtils
import co.id.aminfaruq.movieapp.R
import timber.log.Timber

class HomeVM(private val homeUseCase: HomeUseCase) : BaseViewModel() {

    val postTopRatedData = MutableLiveData<List<TopRated>>()
    val postDiscoverData = MutableLiveData<List<Discover>>()
    val postUpcomingData = MutableLiveData<List<Upcoming>>()
    val postPeopleData = MutableLiveData<List<People>>()
    val showProgressbar = MutableLiveData<Boolean>()
    val messageData = MutableLiveData<String>()

    fun getTopRated() {
        showProgressbar.value = true
        compositeDisposable.add(
            homeUseCase.getTopRated(Constants.API_KEY, Constants.LANG, 1)
                .compose(RxUtils.applySingleAsync())
                .subscribe({ result ->
                    if (result.isNotEmpty()) {
                        postTopRatedData.value = result
                        showProgressbar.value = false
                    } else {
                        messageData.value = "Tidak ada data"
                        Timber.e("${R.string.error}")
                    }
                }, this::onError)
        )
    }

    fun getDiscoverMovie(genres: Int) {
        showProgressbar.value = true
        compositeDisposable.add(
            homeUseCase.getDiscoverMovie(
                Constants.API_KEY,
                Constants.LANG,
                Constants.SORT_BY,
                Constants.ADULT,
                Constants.VIDEO,
                1,
                genres
            ).compose(RxUtils.applySingleAsync())
                .subscribe({ result ->
                    if (result.isNotEmpty()) {
                        postDiscoverData.value = result
                        showProgressbar.value = false
                    } else {
                        messageData.value = "Tidak ada data"
                        Timber.e("${R.string.error}")
                    }
                }, this::onError)
        )
    }

    fun getUpcomingMovie() {
        showProgressbar.value = true
        compositeDisposable.add(
            homeUseCase.getUpcomingMovie(Constants.API_KEY, Constants.LANG, 1)
                .compose(RxUtils.applySingleAsync())
                .subscribe({ result ->
                    if (result.isNotEmpty()) {
                        postUpcomingData.value = result
                        showProgressbar.value = false
                    } else {
                        messageData.value = "Tidak ada data"
                        Timber.e("${R.string.error}")
                    }
                }, this::onError)
        )
    }

    fun getActorMovie() {
        showProgressbar.value = true
        compositeDisposable.add(
            homeUseCase.getPeoplePopular(Constants.API_KEY, Constants.LANG, 1)
                .compose(RxUtils.applySingleAsync())
                .subscribe({ result ->
                    if (result.isNotEmpty()) {
                        postPeopleData.value = result
                        showProgressbar.value = false
                    } else {
                        messageData.value = "Tidak ada data"
                        Timber.e("${R.string.error}")
                    }
                }, this::onError)
        )
    }


    override fun onError(error: Throwable) {
        messageData.value = error.message
    }
}