package co.id.aminfaruq.movieapp.ui.home

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import co.id.aminfaruq.core.domain.model.Discover
import co.id.aminfaruq.core.ui.DiscoverAdapter
import co.id.aminfaruq.core.ui.PeopleAdapter
import co.id.aminfaruq.core.ui.TopRatedAdapter
import co.id.aminfaruq.core.ui.UpcomingAdapter
import co.id.aminfaruq.movieapp.R
import co.id.aminfaruq.movieapp.utils.openDetailActivity
import kotlinx.android.synthetic.main.fragment_home.*
import kotlinx.android.synthetic.main.layout_actor.*
import kotlinx.android.synthetic.main.layout_coming_soon.*
import kotlinx.android.synthetic.main.layout_top_pick.*
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

        viewModel.getTopRated()
        viewModel.getUpcomingMovie()
        viewModel.getActorMovie()
        viewModel.getDiscoverMovie(10770)


        btn_action.setOnClickListener {
            btn_action.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_click)
            btn_action.setTextColor(resources.getColor(android.R.color.white))
            btn_drama.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_def)
            btn_horror.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_def)
            btn_thriler.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_def)
            viewModel.getDiscoverMovie(28)
        }

        btn_drama.setOnClickListener {
            btn_drama.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_click)
            btn_drama.setTextColor(resources.getColor(android.R.color.white))
            btn_action.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_def)
            btn_horror.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_def)
            btn_thriler.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_def)
            viewModel.getDiscoverMovie(18)
        }

        btn_horror.setOnClickListener {
            btn_horror.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_click)
            btn_horror.setTextColor(resources.getColor(android.R.color.white))
            btn_action.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_def)
            btn_drama.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_def)
            btn_thriler.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_def)
            viewModel.getDiscoverMovie(27)
        }

        btn_thriler.setOnClickListener {
            btn_thriler.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_click)
            btn_thriler.setTextColor(resources.getColor(android.R.color.white))
            btn_action.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_def)
            btn_drama.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_def)
            btn_horror.background =
                ContextCompat.getDrawable(context!!, R.drawable.corner_button_def)
            viewModel.getDiscoverMovie(53)
        }

    }

    override fun onResume() {
        super.onResume()
        val topRatedAdapter = TopRatedAdapter()
        val discoverAdapter = DiscoverAdapter(object : DiscoverAdapter.OnItemClick {
            override fun onClick(item: Discover) {
                item.id?.let { openDetailActivity(context!!, it.toString()) }
            }
        })
        val upcomingAdapter = UpcomingAdapter()
        val actorAdapter = PeopleAdapter()


        with(viewModel) {
            postTopRatedData.observe(viewLifecycleOwner, Observer {
                topRatedAdapter.setTopRatedData(it)
            })

            postDiscoverData.observe(viewLifecycleOwner, Observer {
                discoverAdapter.setDiscoverMovieData(it)
            })

            postUpcomingData.observe(viewLifecycleOwner, Observer {
                upcomingAdapter.setUpcomingMovieData(it)
            })

            postPeopleData.observe(viewLifecycleOwner, Observer {
                actorAdapter.setPeopleData(it)
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
        with(rv_coming_soon) {
            layoutManager = LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false)
            adapter = upcomingAdapter
            setHasFixedSize(true)
        }

        with(rv_actor) {
            layoutManager = LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false)
            adapter = actorAdapter
            setHasFixedSize(true)
        }

    }

}