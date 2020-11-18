package co.id.aminfaruq.core.ui

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import co.id.aminfaruq.core.R
import co.id.aminfaruq.core.data.source.remote.response.detail.Genre
import kotlinx.android.synthetic.main.item_genres_detail.view.*
import java.util.*

class GenresAdapter : RecyclerView.Adapter<GenresAdapter.ViewHolder>() {

    private var genreData = ArrayList<Genre>()

    fun setPeopleData(newListData: List<Genre>?) {
        if (newListData == null) return
        genreData.clear()
        genreData.addAll(newListData)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder =
        ViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.item_genres_detail, parent, false)
        )

    override fun getItemCount(): Int {
        return genreData.size
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = genreData[position]
        holder.bind(data)
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        fun bind(data: Genre) {
            with(itemView) {
                tv_genres_name.text = data.name
            }
        }
    }
}