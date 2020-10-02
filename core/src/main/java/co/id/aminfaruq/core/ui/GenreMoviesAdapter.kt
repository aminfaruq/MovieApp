package co.id.aminfaruq.core.ui

import android.content.Context
import android.content.res.Resources
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import co.id.aminfaruq.core.R
import co.id.aminfaruq.core.domain.model.Genre
import kotlinx.android.synthetic.main.item_genres_detail.view.*

class GenreMoviesAdapter: RecyclerView.Adapter<GenreMoviesAdapter.ViewHolder>() {

    private val genreMovieData = ArrayList<Genre>()

    fun setGenreMovieData(list: List<Genre>?) {
        if (list == null) return
        genreMovieData.clear()
        genreMovieData.addAll(list)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): GenreMoviesAdapter.ViewHolder =
        ViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.item_genres_detail, parent, false)
        )

    override fun onBindViewHolder(holder: GenreMoviesAdapter.ViewHolder, position: Int) {
        val data = genreMovieData[position]
        holder.bind(data)


    }

//    private fun dpToPx(dp: Int): Int {
//        val px = dp *
//        return px.toInt()
//    }

    override fun getItemCount(): Int = genreMovieData.size

    class ViewHolder(view: View): RecyclerView.ViewHolder(view) {
        fun bind(data: Genre) {
            with(itemView) {
                tv_genres_name.text = data.name
            }
        }
    }

}