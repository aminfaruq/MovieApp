package co.id.aminfaruq.core.ui

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import co.id.aminfaruq.core.R
import co.id.aminfaruq.core.domain.model.TopRated
import co.id.aminfaruq.core.utils.Constants
import coil.load
import kotlinx.android.synthetic.main.item_top_rated.view.*
import java.util.*

class TopRatedAdapter : RecyclerView.Adapter<TopRatedAdapter.ViewHolder>() {

    // TODO: 26/09/20 :  Top rated
    private var topRatedData = ArrayList<TopRated>()

    fun setTopRatedData(newListData: List<TopRated>?) {
        if (newListData == null) return
        topRatedData.clear()
        topRatedData.addAll(newListData)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) =
        ViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.item_top_rated, parent, false)
        )


    override fun getItemCount(): Int {
        return topRatedData.size
    }

    override fun onBindViewHolder(holder: TopRatedAdapter.ViewHolder, position: Int) {
        val data = topRatedData[position]
        holder.bind(data)
    }

    inner class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        fun bind(data: TopRated) {
            with(itemView) {
                img_backgroud_top_rated.load(Constants.URL_IMAGE + data.backdrop_path)
                img_top_rated.load(Constants.URL_IMAGE + data.poster_path)
                tv_name_top_rated.text = data.original_title
                tv_kind_top_rated.text = "Trailer"
                btn_top_rated_watchlist.setOnClickListener {

                }
            }
        }
    }

}