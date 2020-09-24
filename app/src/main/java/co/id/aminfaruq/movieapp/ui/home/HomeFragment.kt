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

        viewModel.getTopRated()
        with(viewModel) {
            postData.observe(viewLifecycleOwner, Observer {
                topRatedAdapter.setData(it)
            })

            messageData.observe(viewLifecycleOwner, Observer { messageInfo ->
                Toast.makeText(context , messageInfo , Toast.LENGTH_SHORT).show()
                Log.e("HomeFragment" , messageInfo.toString())
            })

            showProgressbar.observe(viewLifecycleOwner, Observer {

            })
        }

        val linearLayout = LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false)
        with(rv_top_rated) {
            layoutManager = linearLayout
            adapter = topRatedAdapter
            setHasFixedSize(true)
        }


    }

}