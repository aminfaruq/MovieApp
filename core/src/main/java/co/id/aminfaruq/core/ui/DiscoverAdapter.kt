package co.id.aminfaruq.core.ui

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import co.id.aminfaruq.core.R
import co.id.aminfaruq.core.domain.model.Discover
import co.id.aminfaruq.core.utils.Constants
import coil.load
import kotlinx.android.synthetic.main.item_movie_watchlist.view.*

class DiscoverAdapter(private val onItemClick: OnItemClick) : RecyclerView.Adapter<DiscoverAdapter.ViewHolder>() {

    // TODO: 26/09/20 discover
    private val discoverData = ArrayList<Discover>()

    fun setDiscoverMovieData(newListData: List<Discover>?) {
        if (newListData == null) return
        discoverData.clear()
        discoverData.addAll(newListData)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder  =
        ViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.item_movie_watchlist, parent, false)
        )


    override fun getItemCount(): Int = discoverData.size

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = discoverData[position]
        holder.bind(data)
    }

    inner class ViewHolder(val view: View) : RecyclerView.ViewHolder(view){

        @SuppressLint("SetTextI18n")
        fun bind(data : Discover) {
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
        fun onClick(item : Discover)
    }
}