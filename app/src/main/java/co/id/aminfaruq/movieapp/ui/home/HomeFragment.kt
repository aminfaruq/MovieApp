package co.id.aminfaruq.movieapp.ui.home

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import co.id.aminfaruq.core.ui.DiscoverAdapter
import co.id.aminfaruq.core.ui.TopRatedAdapter
import co.id.aminfaruq.movieapp.R
import kotlinx.android.synthetic.main.fragment_home.*
import org.koin.android.ext.android.inject

class HomeFragment : Fragment() {

    private val viewModel: HomeVM by inject()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_home, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        val topRatedAdapter = TopRatedAdapter()
        val discoverAdapter = DiscoverAdapter()

        viewModel.getTopRated()
        viewModel.getDiscoverMovie(28)
        with(viewModel) {
            postTopRatedData.observe(viewLifecycleOwner, Observer {
                topRatedAdapter.setTopRatedData(it)
            })

            postDiscoverData.observe(viewLifecycleOwner, Observer {
                discoverAdapter.setDiscoverMovieData(it)
            })

            messageData.observe(viewLifecycleOwner, Observer { messageInfo ->
                Toast.makeText(context, messageInfo, Toast.LENGTH_SHORT).show()
                Log.e("HomeFragment", messageInfo.toString())
            })

            showProgressbar.observe(viewLifecycleOwner, Observer {

            })
        }


        with(rv_top_rated) {
            layoutManager = LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false)
            adapter = topRatedAdapter
            setHasFixedSize(true)
        }

        with(rv_discover) {
            layoutManager = LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false)
            adapter = discoverAdapter
            setHasFixedSize(true)
        }


    }

}