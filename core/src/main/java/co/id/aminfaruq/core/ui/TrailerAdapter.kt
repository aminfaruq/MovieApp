package co.id.aminfaruq.core.ui

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import co.id.aminfaruq.core.R
import co.id.aminfaruq.core.domain.model.Trailer
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.YouTubePlayer
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.listeners.AbstractYouTubePlayerListener
import kotlinx.android.synthetic.main.item_trailer.view.*
import java.util.*

class TrailerAdapter : RecyclerView.Adapter<TrailerAdapter.ViewHolder>() {

    private var trailerData = ArrayList<Trailer>()

    fun setTopRatedData(newListData: List<Trailer>?) {
        if (newListData == null) return
        trailerData.clear()
        trailerData.addAll(newListData)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder =
        ViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.item_trailer, parent, false)
        )

    override fun getItemCount(): Int {
        return trailerData.size
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = trailerData[position]
        holder.bind(data)
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {

        fun bind(data: Trailer) {
            with(itemView) {
                youtube_trailer.addYouTubePlayerListener(object : AbstractYouTubePlayerListener() {
                    override fun onReady(youTubePlayer: YouTubePlayer) {
                        youTubePlayer.cueVideo(data.key.toString(), 0F)
                    }
                })

                tv_name_trailer.text = data.name
                tv_type_name.text = data.type
            }
        }
    }
}