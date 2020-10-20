package co.id.aminfaruq.core.ui.grouphie

import co.id.aminfaruq.core.R
import co.id.aminfaruq.core.domain.model.SimilarMovie
import co.id.aminfaruq.core.utils.Constants
import com.xwray.groupie.kotlinandroidextensions.Item
import com.xwray.groupie.kotlinandroidextensions.ViewHolder


class SimilarItemView(val data: SimilarMovie) : Item() {

    override fun bind(viewHolder: ViewHolder, position: Int) {

//        val itemLayout = viewHolder.itemView
//
//        itemLayout.img_backdrop_similiar.load(Constants.URL_IMAGE + data.poster_path)
//        itemLayout.tv_title_similiar.text = data.original_title
//        itemLayout.tv_date_lang_similiar.text = "${data.release_date} . ${data.original_language}"
//        itemLayout.tv_rate_similiar.text = data.vote_average.toString()
//        itemLayout.tv_popularity_similiar.text = data.popularity.toString()
    }

    override fun getLayout(): Int = R.layout.item_similiar
}