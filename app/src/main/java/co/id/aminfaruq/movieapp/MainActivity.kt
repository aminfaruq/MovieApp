package co.id.aminfaruq.movieapp

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import co.id.aminfaruq.movieapp.ui.adapter.SectionPagerAdapter
import co.id.aminfaruq.movieapp.utils.openSearchActivity
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

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.menu_main, menu)
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when(item.itemId) {
            R.id.action_account -> {
                return true
            }
            R.id.action_search -> {
                openSearchActivity(this)
                return true
            }
        }
        return false
    }
}





















