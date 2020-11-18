package co.id.aminfaruq.core.ui

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import co.id.aminfaruq.core.R
import co.id.aminfaruq.core.domain.model.Discover
import co.id.aminfaruq.core.domain.model.NowPlaying
import co.id.aminfaruq.core.utils.Constants
import coil.load
import kotlinx.android.synthetic.main.item_movie_watchlist.view.*

class NowPlayingAdapter (val onItemClick: OnItemClick): RecyclerView.Adapter<NowPlayingAdapter.ViewHolder>() {

    private val nowPlayingData = ArrayList<NowPlaying>()

    fun setNowPlayingData(list: List<NowPlaying>?) {
        if (list == null) return
        nowPlayingData.clear()
        nowPlayingData.addAll(list)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder =
        ViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.item_movie_watchlist, parent, false)
        )

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = nowPlayingData[position]
        holder.bind(data)
    }

    override fun getItemCount(): Int = nowPlayingData.size

    inner class ViewHolder(val view: View): RecyclerView.ViewHolder(view) {
        fun bind(data: NowPlaying) {
            with(itemView){
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
        fun onClick(item : NowPlaying)
    }

}