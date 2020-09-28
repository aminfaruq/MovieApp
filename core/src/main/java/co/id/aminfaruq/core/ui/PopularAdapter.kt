package co.id.aminfaruq.core.ui

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import co.id.aminfaruq.core.R
import co.id.aminfaruq.core.domain.model.Popular
import co.id.aminfaruq.core.utils.Constants
import coil.load
import kotlinx.android.synthetic.main.item_movie_watchlist.view.*

class PopularAdapter : RecyclerView.Adapter<PopularAdapter.ViewHolder>() {
    private var popularData = ArrayList<Popular>()

    fun setPopularData(list: List<Popular>?) {
        if (list == null) return
        popularData.clear()
        popularData.addAll(list)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder =
        ViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.item_movie_watchlist, parent, false)
        )

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = popularData[position]
        holder.bind(data)
    }

    override fun getItemCount(): Int = popularData.size

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view){

        @SuppressLint("SetTextI18n")
        fun bind(data : Popular) {
            with(itemView) {
                tv_vote.text = data.vote_average.toString()
                img_movie.load(Constants.URL_IMAGE + data.poster_path)
                tv_name_movie.text = data.title
                tv_date_time.text = " ${data.release_date} . ${data.original_language}"

            }
        }
    }
}