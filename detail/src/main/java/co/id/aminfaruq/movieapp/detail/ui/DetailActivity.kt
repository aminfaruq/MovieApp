package co.id.aminfaruq.movieapp.detail.ui

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import co.id.aminfaruq.movieapp.detail.R
import co.id.aminfaruq.movieapp.detail.di.detailInject
import org.koin.android.ext.android.inject
import org.koin.core.context.loadKoinModules

class DetailActivity : AppCompatActivity() {

    private val detailVM : DetailVM by inject()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_detail)
        loadKoinModules(detailInject)
    }
}