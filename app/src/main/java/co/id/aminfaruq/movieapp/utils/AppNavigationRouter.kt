package co.id.aminfaruq.movieapp.utils

import android.content.Context
import android.content.Intent
import android.util.Log
import timber.log.Timber

const val PARENT_PACKAGE = "co.id.aminfaruq.movieapp"

const val BUNDLE_KEY = "bundle_key"

const val PACKAGE_DETAIL = "$PARENT_PACKAGE.detail"

const val PACKAGE_SEARCH = "com.masuwes.search"

fun openDetailActivity(context: Context, movie_id: String) {
    try {
        val intent = Intent(
            context,
            Class.forName("$PACKAGE_DETAIL.ui.DetailActivity")
        )
        intent.putExtra(BUNDLE_KEY, movie_id)
        context.startActivity(intent)
    } catch (e: Exception) {
        Log.d("Navigation","Activity not found")
    }
}

fun openSearchActivity(context: Context) {
    try {
        val intent = Intent(
            context,
            Class.forName("$PACKAGE_SEARCH.ui.SearchActivity")
        )
        context.startActivity(intent)

    } catch (e: Exception) {
        Log.d("Navigation","Activity not found")
    }
}


















