package co.id.aminfaruq.movieapp.ui.movie

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import co.id.aminfaruq.core.ui.*
import co.id.aminfaruq.movieapp.R
import kotlinx.android.synthetic.main.fragment_movie.*
import kotlinx.android.synthetic.main.layout_popular_movie.*
import kotlinx.android.synthetic.main.layout_top_rated_movie.*
import kotlinx.android.synthetic.main.layout_nowplaying_movie.*
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

        loadUi()
    }

    override fun onResume() {
        super.onResume()

    }

    private fun loadUi() {
        val popularMovieAdapter = PopularAdapter()
        val topRatedAdapter = TopRatedAdapter()
        val topRatedMovieAdapter = TopRatedMovieAdapter()
        val nowPlayingAdapter = NowPlayingAdapter()

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

    }


}

