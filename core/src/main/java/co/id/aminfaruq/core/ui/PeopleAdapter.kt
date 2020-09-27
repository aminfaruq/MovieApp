package co.id.aminfaruq.core.ui

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import co.id.aminfaruq.core.R
import co.id.aminfaruq.core.domain.model.People
import co.id.aminfaruq.core.utils.Constants
import coil.load
import kotlinx.android.synthetic.main.item_actor.view.*
import java.util.ArrayList

class PeopleAdapter : RecyclerView.Adapter<PeopleAdapter.ViewHolder>() {

    // TODO: 26/09/20 :  Top rated
    private var peopleData = ArrayList<People>()

    fun setPeopleData(newListData: List<People>?) {
        if (newListData == null) return
        peopleData.clear()
        peopleData.addAll(newListData)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder =
        ViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.item_actor, parent, false)
        )

    override fun getItemCount(): Int {
       return peopleData.size
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = peopleData[position]
        holder.bind(data)
    }

    inner class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        @SuppressLint("SetTextI18n")
        fun bind(data: People) {

            with(itemView) {
                img_actor.load(Constants.URL_IMAGE + data.profile_path)
                tv_name_actor.text = data.name
            }
        }
    }
}