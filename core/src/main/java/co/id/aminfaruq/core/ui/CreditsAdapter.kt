package co.id.aminfaruq.core.ui

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import co.id.aminfaruq.core.R
import co.id.aminfaruq.core.domain.model.Credits
import co.id.aminfaruq.core.utils.Constants
import coil.load
import kotlinx.android.synthetic.main.item_movie_credits.view.*
import java.util.*

class CreditsAdapter : RecyclerView.Adapter<CreditsAdapter.ViewHolder>() {

    private var creditsData = ArrayList<Credits>()

    fun setCreditsData(newListData: List<Credits>?) {
        if (newListData == null) return
        creditsData.clear()
        creditsData.addAll(newListData)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder =
        ViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.item_movie_credits, parent, false)
        )

    override fun getItemCount(): Int {
        return creditsData.size
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = creditsData[position]
        holder.bind(data)
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        fun bind(data: Credits) {
            with(itemView) {
                img_credit_actor.load(Constants.URL_IMAGE + data.profile_path)
                tv_name_actor_cr.text = data.name
                tv_character.text = data.character
            }
        }
    }

}