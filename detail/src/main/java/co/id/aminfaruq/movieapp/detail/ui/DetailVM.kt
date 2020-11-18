package co.id.aminfaruq.movieapp.detail.ui

import androidx.lifecycle.MutableLiveData
import co.id.aminfaruq.core.domain.model.Credits
import co.id.aminfaruq.core.domain.model.Detail
import co.id.aminfaruq.core.domain.model.SimilarMovie
import co.id.aminfaruq.core.domain.model.Trailer
import co.id.aminfaruq.core.domain.usecase.detail.DetailUseCase
import co.id.aminfaruq.core.ui.BaseViewModel
import co.id.aminfaruq.core.utils.Constants
import co.id.aminfaruq.core.utils.RxUtils
import co.id.aminfaruq.movieapp.R
import timber.log.Timber

class DetailVM(private val detailUseCase: DetailUseCase) : BaseViewModel() {

    object Loading
    object LastPage
    object DataNotFound
    val postDetailMovieData = MutableLiveData<Detail>()
    val postTrailerMovieData = MutableLiveData<List<Trailer>>()
    val postCreditsMoviesData = MutableLiveData<List<Credits>>()
    val postSimilarMovie = MutableLiveData<List<SimilarMovie>>()
    val showProgressbar = MutableLiveData<Boolean>()
    val messageData = MutableLiveData<String>()
    val loadingState = MutableLiveData<Loading>()
    val lastPageState = MutableLiveData<LastPage>()
    val dataNotFoundState = MutableLiveData<DataNotFound>()

    fun getDetailMovie(idMovie: String) {
        showProgressbar.value = true
        compositeDisposable.add(
            detailUseCase.getDetailMovie(idMovie, Constants.API_KEY, Constants.LANG)
                .compose(RxUtils.applySingleAsync())
                .subscribe({ result ->
                    if (result != null) {
                        postDetailMovieData.value = result
                        showProgressbar.value = false
                    } else {
                        messageData.value = "Tidak ada data"
                        Timber.e("${R.string.error}")
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
                        showProgressbar.value = false
                    } else {
                        messageData.value = "Tidak ada data"
                        Timber.e("${R.string.error}")
                    }
                }, this::onError)
        )
    }

    fun getCredit(idMovie: String) {
        showProgressbar.value = true
        compositeDisposable.add(
            detailUseCase.getDetailCredits(idMovie, Constants.API_KEY)
                .compose(RxUtils.applySingleAsync())
                .subscribe({ result ->
                    if (result.isNotEmpty()) {
                        postCreditsMoviesData.value = result
                        showProgressbar.value = false
                    } else {
                        messageData.value = "Tidak ada data"
                        Timber.e("${R.string.error}")
                    }
                }, this::onError)
        )
    }

    fun getSimilarMovie(idMovie: String, page: Int) {
//        showProgressbar.value = true
        compositeDisposable.add(
            detailUseCase.getSimilarMovie(idMovie, Constants.API_KEY, Constants.LANG, page)
                .compose(RxUtils.applySingleAsync())
                .subscribe({ result ->
                    if (result.isNotEmpty()){
                        postSimilarMovie.value = result
                        //showProgressbar.value = false
                    }else {
                       if (page == 1){
                           dataNotFoundState.value = DataNotFound
                       }else{
                           lastPageState.value = LastPage
                       }
                    }
                } , this::onError)
        )
    }

    override fun onError(error: Throwable) {
        messageData.value = error.message
    }
}