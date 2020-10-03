package co.id.aminfaruq.core.ui

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.recyclerview.widget.RecyclerView
import co.id.aminfaruq.core.R
import co.id.aminfaruq.core.domain.model.Genre
import kotlinx.android.synthetic.main.item_genres_detail.view.*
import kotlinx.android.synthetic.main.item_movie_genre.view.*

class GenreMoviesAdapter: RecyclerView.Adapter<GenreMoviesAdapter.ViewHolder>() {

    private val genreMovieData = ArrayList<Genre>()

    private lateinit var context: Context

    fun setGenreMovieData(list: List<Genre>?) {
        if (list == null) return
        genreMovieData.clear()
        genreMovieData.addAll(list)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val inflater = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_movie_genre, parent, false)
        context = parent.context
        return ViewHolder(inflater)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val marginLeft = dpToPx(6)
        val marginTop = dpToPx(6)
        val marginRight = dpToPx(6)
        val marginBottom = dpToPx(6)

        val newLayoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.WRAP_CONTENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )

//        android:layout_width="152dp"
//        android:layout_height="91dp"

        newLayoutParams.setMargins(marginLeft, marginTop, marginRight, marginBottom)
        holder.itemView.layoutParams = newLayoutParams
        val data = genreMovieData[position]
        holder.bind(data)
    }

    private fun dpToPx(dp: Int): Int {
        val px = dp * context.resources.displayMetrics.density
        return px.toInt()
    }

    override fun getItemCount(): Int = genreMovieData.size

    class ViewHolder(view: View): RecyclerView.ViewHolder(view) {
        fun bind(data: Genre) {
            with(itemView) {
                tv_genre_name_item.text = data.name
            }
        }
    }

}

