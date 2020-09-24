package co.id.aminfaruq.core.ui

import co.id.aminfaruq.core.R
import co.id.aminfaruq.core.domain.model.TopRated
import co.id.aminfaruq.core.utils.Constants
import coil.load
import com.xwray.groupie.kotlinandroidextensions.Item
import com.xwray.groupie.kotlinandroidextensions.ViewHolder
import kotlinx.android.synthetic.main.item_top_rated.view.*

class TopRatedItemView(val topRated: TopRated) : Item() {
    override fun bind(viewHolder: ViewHolder, position: Int) {

        val imageBackground = viewHolder.itemView.img_backgroud_top_rated
        val imgView = viewHolder.itemView.img_top_rated
        val tvName = viewHolder.itemView.tv_name_top_rated
        val tvKind = viewHolder.itemView.tv_kind_top_rated
        val btnWatchList = viewHolder.itemView.btn_top_rated_watchlist

        imageBackground.load(Constants.URL_IMAGE + topRated.backdrop_path)
        imgView.load(Constants.URL_IMAGE + topRated.poster_path)
        tvName.text = topRated.original_title
        tvKind.text = "Trailer"
        btnWatchList.setOnClickListener {
            
        }

    }

    override fun getLayout(): Int = R.layout.item_top_rated
}