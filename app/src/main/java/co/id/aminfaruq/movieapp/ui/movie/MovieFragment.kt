package co.id.aminfaruq.movieapp.ui.movie

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import co.id.aminfaruq.core.domain.model.NowPlaying
import co.id.aminfaruq.core.domain.model.Popular
import co.id.aminfaruq.core.domain.model.TopRated
import co.id.aminfaruq.core.ui.*
import co.id.aminfaruq.movieapp.R
import co.id.aminfaruq.movieapp.utils.openDetailActivity
import kotlinx.android.synthetic.main.fragment_movie.*
import kotlinx.android.synthetic.main.layout_genre.*
import kotlinx.android.synthetic.main.layout_nowplaying_movie.*
import kotlinx.android.synthetic.main.layout_popular_movie.*
import kotlinx.android.synthetic.main.layout_top_rated_movie.*
import org.koin.android.ext.android.inject

class MovieFragment : Fragment() {

    private val viewModel: MovieVM by inject()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_movie, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        viewModel.getPopular()
        viewModel.getTopRated()
        viewModel.getNowPlaying()
        viewModel.getGenre()

        loadUi()
    }


    private fun loadUi() {
        val popularMovieAdapter = PopularAdapter(object : PopularAdapter.OnItemClick {
            override fun onClick(item: Popular) {
                openDetailActivity(context!!, item.id.toString())
            }
        })

        val nowPlayingAdapter = NowPlayingAdapter(object : NowPlayingAdapter.OnItemClick {
            override fun onClick(item: NowPlaying) {
                openDetailActivity(context!!, item.id.toString())
            }
        })

        val topRatedMovieAdapter = TopRatedMovieAdapter(object : TopRatedMovieAdapter.OnItemClick{
            override fun onClick(item: TopRated) {
                openDetailActivity(context!! , item.id.toString())
            }
        })


        val topRatedAdapter = TopRatedAdapter()
        val genreMoviesAdapter = GenreMoviesAdapter()

        with(viewModel) {
            postPopularData.observe(viewLifecycleOwner, Observer {
                popularMovieAdapter.setPopularData(it)
            })

            postTopRatedData.observe(viewLifecycleOwner, Observer {
                topRatedAdapter.setTopRatedData(it)
            })

            postTopRatedData.observe(viewLifecycleOwner, Observer {
                topRatedMovieAdapter.setTopRatedData(it)
            })

            postNowPlayingData.observe(viewLifecycleOwner, Observer {
                nowPlayingAdapter.setNowPlayingData(it)
            })

            postGenreData.observe(viewLifecycleOwner, Observer {
                genreMoviesAdapter.setGenreMovieData(it)
            })

            messageData.observe(viewLifecycleOwner, Observer { messageInfo ->
                Toast.makeText(context, messageInfo, Toast.LENGTH_SHORT).show()
                Log.e("HomeFragment", messageInfo.toString())
            })

            showProgressBar.observe(viewLifecycleOwner, Observer {

            })
        }

        with(rv_popular_movie) {
            layoutManager = LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false)
            adapter = popularMovieAdapter
            setHasFixedSize(true)
        }

        with(rv_top_rated_movie) {
            layoutManager = LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false)
            adapter = topRatedAdapter
            setHasFixedSize(true)
        }

        with(rv_nowplaying_movie) {
            layoutManager = LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false)
            adapter = nowPlayingAdapter
            setHasFixedSize(true)
        }

        with(rv_top_rated_movie_list) {
            layoutManager = LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false)
            adapter = topRatedMovieAdapter
            setHasFixedSize(true)
        }

        with(rv_movie_genres) {
            layoutManager = GridLayoutManager(context, 2, GridLayoutManager.HORIZONTAL, false)
            adapter = genreMoviesAdapter
            setHasFixedSize(true)
        }

    }


}

