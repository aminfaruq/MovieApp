package co.id.aminfaruq.core.ui

import android.annotation.SuppressLint
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Filter
import android.widget.Filterable
import android.widget.ImageButton
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import co.id.aminfaruq.core.R
import co.id.aminfaruq.core.domain.model.Discover
import co.id.aminfaruq.core.utils.Constants
import coil.load
import kotlinx.android.synthetic.main.item_movie_watchlist.view.*

class DiscoverAdapter(private val context: Context, private val onItemClick: OnItemClick) :
    RecyclerView.Adapter<DiscoverAdapter.ViewHolder>() {

    lateinit var buttonWatchlist: ImageButton

    // TODO: 26/09/20 discover
    private val discoverData = ArrayList<Discover>()

    fun setDiscoverMovieData(newListData: List<Discover>?) {
        if (newListData == null) return
        discoverData.clear()
        discoverData.addAll(newListData)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder =
        ViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.item_movie_watchlist, parent, false)
        )


    override fun getItemCount(): Int = discoverData.size

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = discoverData[position]
        holder.bind(data)
    }

    inner class ViewHolder(val view: View) : RecyclerView.ViewHolder(view) {

        @SuppressLint("SetTextI18n")
        fun bind(data: Discover) {
            with(itemView) {
                buttonWatchlist = btn_discover_watchlist

                onItemClick.checkDiscover(data.id).takeIf {
                    setButtonWatchListed()
                }.takeUnless {
                    setButtonWatchList()
                }

                tv_vote.text = data.vote_average.toString()
                img_movie.load(Constants.URL_IMAGE + data.poster_path)
                tv_name_movie.text = data.title
                tv_date_time.text = " ${data.release_date} . ${data.original_language}"


                btn_discover_watchlist.setOnClickListener {
                    if (btn_discover_watchlist.background.constantState == ContextCompat.getDrawable(
                            view.context,
                            R.drawable.ic_btn_watchlist
                        )!!.constantState
                    ) {
                        onItemClick.onSaveDiscover(data)
                        btn_discover_watchlist.background = ContextCompat.getDrawable(
                            context,
                            R.drawable.ic_btn_watchlisted
                        )
                    } else {
                        data.id?.let { it1 -> onItemClick.onRemoveDiscover(it1) }
                        btn_discover_watchlist.background = ContextCompat.getDrawable(
                            context,
                            R.drawable.ic_btn_watchlist
                        )
                    }
                }
                view.setOnClickListener {
                    onItemClick.onClick(data)
                }


            }
        }

    }

    fun setButtonWatchList() : Boolean{
        buttonWatchlist.background = ContextCompat.getDrawable(
            context,
            R.drawable.ic_btn_watchlist
        )
        return false
    }

    fun setButtonWatchListed(): Boolean {
        buttonWatchlist.background = ContextCompat.getDrawable(
            context,
            R.drawable.ic_btn_watchlisted
        )
        return true
    }

    interface OnItemClick {
        fun onClick(item: Discover)
        fun onSaveDiscover(discover: Discover)
        fun onRemoveDiscover(id: Int)
        fun checkDiscover(id: Int?)
    }


}