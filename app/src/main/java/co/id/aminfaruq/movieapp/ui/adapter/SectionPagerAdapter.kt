package co.id.aminfaruq.movieapp.ui.adapter

import android.content.Context
import androidx.annotation.StringRes
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentPagerAdapter
import co.id.aminfaruq.movieapp.R
import co.id.aminfaruq.movieapp.ui.home.HomeFragment
import co.id.aminfaruq.movieapp.ui.movie.MovieFragment
import co.id.aminfaruq.movieapp.ui.tv.TvShowFragment

class SectionPagerAdapter(private val context: Context, fragmentManager: FragmentManager):
    FragmentPagerAdapter(fragmentManager, BEHAVIOR_RESUME_ONLY_CURRENT_FRAGMENT) {

    @StringRes
    private val tabTitle = intArrayOf(
        R.string.tab_home,
        R.string.tab_movies,
        R.string.tab_tv_shows
    )

    override fun getItem(position: Int): Fragment {
        var fragment: Fragment? = null
        when(position) {
            0 -> fragment = HomeFragment()
            1 -> fragment = MovieFragment()
            2 -> fragment = TvShowFragment()
        }
        return fragment as Fragment
    }

    override fun getPageTitle(position: Int): CharSequence? {
        return context.resources.getString(tabTitle[position])
    }

    override fun getCount(): Int = 3


}