package co.id.aminfaruq.movieapp

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import co.id.aminfaruq.movieapp.ui.adapter.SectionPagerAdapter
import com.google.android.material.tabs.TabLayout
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(findViewById(R.id.toolbar))

        val sectionPagerAdapter = SectionPagerAdapter(this, supportFragmentManager)

        view_pager.adapter = sectionPagerAdapter
        tabs.setupWithViewPager(view_pager)
    }
}