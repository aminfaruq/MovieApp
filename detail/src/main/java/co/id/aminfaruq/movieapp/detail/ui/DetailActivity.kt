package co.id.aminfaruq.movieapp.detail.ui

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import co.id.aminfaruq.core.ui.CreditsAdapter
import co.id.aminfaruq.core.ui.GenresAdapter
import co.id.aminfaruq.core.ui.TrailerAdapter
import co.id.aminfaruq.core.ui.grouphie.LoadmoreItemView
import co.id.aminfaruq.core.ui.grouphie.SimilarItemView
import co.id.aminfaruq.core.utils.Constants
import co.id.aminfaruq.core.utils.PaginationScrollListener
import co.id.aminfaruq.movieapp.detail.R
import co.id.aminfaruq.movieapp.detail.di.detailInject
import co.id.aminfaruq.movieapp.utils.BUNDLE_KEY
import coil.load
import com.xwray.groupie.GroupAdapter
//import com.xwray.groupie.ViewHolder
import kotlinx.android.synthetic.main.activity_detail.*
import kotlinx.android.synthetic.main.layout_clip.*
import kotlinx.android.synthetic.main.layout_credits.*
import kotlinx.android.synthetic.main.layout_information.*
import kotlinx.android.synthetic.main.layout_overview.*
import kotlinx.android.synthetic.main.layout_rated_detail.*
import kotlinx.android.synthetic.main.layout_similar.*
import org.koin.android.ext.android.inject
import org.koin.core.context.loadKoinModules

class DetailActivity : AppCompatActivity(), View.OnClickListener {

    private val viewModel: DetailVM by inject()
    private lateinit var idMovie: String

//    private val similarItemView = GroupAdapter<ViewHolder>()

    private var page = 1
    private var isLoadMore = false
    private var isLastPage = false

    private var loadmoreItemView = LoadmoreItemView()

    @SuppressLint("SetTextI18n")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_detail)
        loadKoinModules(detailInject)
        btn_back_form_detail.setOnClickListener(this)

        val data = intent.getStringExtra(BUNDLE_KEY)
        idMovie = data.toString()
        viewModel.getDetailMovie(data.toString())
        viewModel.getTrailerMovie(data.toString())
        viewModel.getCredit(data.toString())
        viewModel.getSimilarMovie(data.toString(), page)

        val genresAdapter = GenresAdapter()
        val trailerAdapter = TrailerAdapter()
        val creditsAdapter = CreditsAdapter()


        with(viewModel) {
            postDetailMovieData.observe(this@DetailActivity, Observer { data ->
                img_backgroud_detail.load(Constants.URL_IMAGE + data.backdrop_path)
                img_detail_image.load(Constants.URL_IMAGE + data.poster_path)
                tv_name_detail.text = data.original_title
                tv_kind_top_rated.text = " ${data.release_date} . ${data.original_language}"
                tv_overview_description.text = data.overview
                genresAdapter.setPeopleData(data.genres)
                tv_popularity.text = data.popularity.toString()
                tv_vote_average.text = data.vote_average.toString()
                tv_vote_count.text = data.vote_count.toString()
            })

            postTrailerMovieData.observe(this@DetailActivity, Observer {
                trailerAdapter.setTopRatedData(it)
            })

            postCreditsMoviesData.observe(this@DetailActivity, Observer {
                creditsAdapter.setCreditsData(it)
            })

            postSimilarMovie.observe(this@DetailActivity, Observer { similarState ->
                if (isLoadMore) {
                    //    similarItemView.remove(loadmoreItemView)
                    isLoadMore = false
                }

                if (page == 1) {
//                    similarItemView.clear()
                }

                similarState.map {
//                    similarItemView.add(SimilarItemView(it))
                }

            })

            loadingState.observe(this@DetailActivity, Observer {
                if (isLoadMore) {
                    //add loading indicator
                    //  similarItemView.add(loadmoreItemView)
                }
            })

            lastPageState.observe(this@DetailActivity, Observer {
                if (isLoadMore) {
                    // similarItemView.remove(loadmoreItemView)
                    isLoadMore = false
                    if (!isLastPage) {
                        Toast.makeText(
                            this@DetailActivity,
                            "Telah meraih halaman terakhir",
                            Toast.LENGTH_SHORT
                        ).show()
                        isLastPage = true
                    }
                }
            })

            dataNotFoundState.observe(this@DetailActivity, Observer {
//                similarItemView.clear()
            })

            showProgressbar.observe(this@DetailActivity, Observer {

            })

            messageData.observe(this@DetailActivity, Observer {

            })

        }

        with(rv_detail_genre) {
            adapter = genresAdapter
            layoutManager =
                LinearLayoutManager(this@DetailActivity, LinearLayoutManager.HORIZONTAL, false)
            setHasFixedSize(true)

        }

        with(rv_clips_detail) {
            adapter = trailerAdapter
            layoutManager =
                LinearLayoutManager(this@DetailActivity, LinearLayoutManager.HORIZONTAL, false)
            setHasFixedSize(true)
        }

        with(rv_credits_detail) {
            adapter = creditsAdapter
            layoutManager =
                LinearLayoutManager(this@DetailActivity, LinearLayoutManager.HORIZONTAL, false)
            setHasFixedSize(true)
        }

        with(rv_similar_movie) {
            val linearLayout =
                LinearLayoutManager(this@DetailActivity, LinearLayoutManager.HORIZONTAL, false)
//            adapter = similarItemView
            layoutManager = linearLayout
            addOnScrollListener(object : PaginationScrollListener(linearLayout) {
                override fun isLastPage(): Boolean {
                    return isLastPage
                }

                override fun isLoading(): Boolean {
                    return isLoadMore
                }

                override fun loadMoreItems() {
                    isLoadMore = true
                    page++

                    viewModel.getSimilarMovie(idMovie, page)
                }
            })
        }


    }

    override fun onDestroy() {
        super.onDestroy()
        finish()
    }

    override fun onClick(p0: View?) {
        when (p0?.id) {
            R.id.btn_back_form_detail -> {
                onBackPressed()
            }
        }
    }


}