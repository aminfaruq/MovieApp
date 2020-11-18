package co.id.aminfaruq.core.ui

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import co.id.aminfaruq.core.R
import co.id.aminfaruq.core.domain.model.TopRated
import co.id.aminfaruq.core.utils.Constants
import coil.load
import kotlinx.android.synthetic.main.item_movie_watchlist.view.*
import java.util.*

class TopRatedMovieAdapter(val onItemClick: OnItemClick): RecyclerView.Adapter<TopRatedMovieAdapter.ViewHolder>() {

    private var topRatedData = ArrayList<TopRated>()

    fun setTopRatedData(newListData: List<TopRated>?) {
        if (newListData == null) return
        topRatedData.clear()
        topRatedData.addAll(newListData)
        notifyDataSetChanged()
    }


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder =
        ViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.item_movie_watchlist, parent, false)
        )

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = topRatedData[position]
        holder.bind(data)
    }

    override fun getItemCount(): Int = topRatedData.size


    inner class ViewHolder(val view: View) : RecyclerView.ViewHolder(view){
        @SuppressLint("SetTextI18n")
        fun bind(data : TopRated) {
            with(itemView) {
                tv_vote.text = data.vote_average.toString()
                img_movie.load(Constants.URL_IMAGE + data.poster_path)
                tv_name_movie.text = data.title
                tv_date_time.text = " ${data.release_date} . ${data.original_language}"

                view.setOnClickListener {
                    onItemClick.onClick(data)
                }
            }
        }
    }

    interface OnItemClick{
        fun onClick(item : TopRated)
    }
}