package co.id.aminfaruq.movieapp.detail.ui

import android.annotation.SuppressLint
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import co.id.aminfaruq.core.ui.CreditsAdapter
import co.id.aminfaruq.core.ui.GenresAdapter
import co.id.aminfaruq.core.ui.TrailerAdapter
import co.id.aminfaruq.core.utils.Constants
import co.id.aminfaruq.movieapp.detail.R
import co.id.aminfaruq.movieapp.detail.di.detailInject
import co.id.aminfaruq.movieapp.utils.BUNDLE_KEY
import coil.load
import kotlinx.android.synthetic.main.layout_clip.*
import kotlinx.android.synthetic.main.layout_credits.*
import kotlinx.android.synthetic.main.layout_information.*
import kotlinx.android.synthetic.main.layout_overview.*
import kotlinx.android.synthetic.main.layout_rated_detail.*
import org.koin.android.ext.android.inject
import org.koin.core.context.loadKoinModules

class DetailActivity : AppCompatActivity() {

    private val viewModel: DetailVM by inject()

    @SuppressLint("SetTextI18n")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_detail)
        loadKoinModules(detailInject)

        val data = intent.getStringExtra(BUNDLE_KEY)
        viewModel.getDetailMovie(data.toString())
        viewModel.getTrailerMovie(data.toString())
        viewModel.getCredit(data.toString())

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

    }


}