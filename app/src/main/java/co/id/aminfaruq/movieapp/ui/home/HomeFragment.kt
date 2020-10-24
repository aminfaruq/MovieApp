package co.id.aminfaruq.movieapp.ui.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.DefaultItemAnimator
import androidx.recyclerview.widget.LinearLayoutManager
import co.id.aminfaruq.core.domain.model.Discover
import co.id.aminfaruq.core.domain.model.Upcoming
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
    var idDiscover = 0

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_home, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

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
        viewModel.getTopRated()
        viewModel.getUpcomingMovie()
        viewModel.getActorMovie()
        viewModel.getDiscoverMovie(18)
        loadUi()

    }

    private fun loadUi() {
        val topRatedAdapter = TopRatedAdapter()
        val discoverAdapter = DiscoverAdapter(context!!, object : DiscoverAdapter.OnItemClick {
            override fun onClick(item: Discover) {
                openDetailActivity(context!!, item.id.toString())
            }

            override fun onSaveDiscover(discover: Discover) {
                viewModel.saveMovieDiscover(discover)
            }

            override fun onRemoveDiscover(id: Int) {
                viewModel.removeMovieDiscover(id)
            }

            override fun checkDiscover(id: Int?) {
                if (id != null) {
                    idDiscover = id
                }

                viewModel.checkDiscover(idDiscover)
            }
        })
        val upcomingAdapter = UpcomingAdapter(object : UpcomingAdapter.OnItemClick {
            override fun onClick(item: Upcoming) {
                openDetailActivity(context!!, item.id.toString())
            }
        })
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
            })

            showProgressbar.observe(viewLifecycleOwner, Observer {

            })

            saveDataDiscover.observe(viewLifecycleOwner, Observer {
                Toast.makeText(
                    context,
                    "Saved",
                    Toast.LENGTH_SHORT
                ).show()
            })

            removeDataDiscover.observe(viewLifecycleOwner, Observer {
                Toast.makeText(
                    context,
                    "Removed",
                    Toast.LENGTH_SHORT
                ).show()
            })

            favDiscoverDataFound.observe(viewLifecycleOwner, Observer { discover ->
                discover.map {
                    if (it.id == idDiscover) {
                        discoverAdapter.setButtonWatchListed()
                    } else {
                        discoverAdapter.setButtonWatchList()
                    }
                }
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
            itemAnimator = DefaultItemAnimator()
            isNestedScrollingEnabled = true
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