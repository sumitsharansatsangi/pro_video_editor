import androidx.media3.common.Effect
import androidx.media3.common.util.UnstableApi
import androidx.media3.effect.GaussianBlur
import androidx.media3.effect.TimestampWrapper
import ch.waio.pro_video_editor.src.features.render.models.BlurFilterConfig
import ch.waio.pro_video_editor.src.shared.logging.PluginLog as Log

/**
 * Applies Gaussian blur effect to video.
 *
 * Uses GaussianBlur with sigma multiplied by 2.5 for visual consistency.
 * No effect if blur value is null or <= 0.
 *
 * @param videoEffects List to add blur effect to
 * @param blur Blur intensity (higher = more blur)
 */
@UnstableApi
fun applyBlur(
    videoEffects: MutableList<Effect>,
    blur: Double?,
    blurFilters: List<BlurFilterConfig> = emptyList()
) {
    if (blur == null || blur <= 0.0) {
        applyBlurFilters(videoEffects, blurFilters)
        return
    }

    val actualSigma = blur.toFloat() * 2.5f
    Log.d(RENDER_TAG, "Applying Gaussian blur: intensity=$blur, sigma=$actualSigma")

    val blurEffect = GaussianBlur(blur.toFloat() * 2.5f)
    videoEffects += blurEffect
    applyBlurFilters(videoEffects, blurFilters)
}

@UnstableApi
private fun applyBlurFilters(
    videoEffects: MutableList<Effect>,
    blurFilters: List<BlurFilterConfig>
) {
    for (filter in blurFilters) {
        if (filter.blur <= 0.0) continue

        val blurEffect = GaussianBlur(filter.blur.toFloat() * 2.5f)
        val startUs = filter.startUs ?: 0L
        val endUs = filter.endUs ?: Long.MAX_VALUE
        Log.d(
            RENDER_TAG,
            "Applying timed blur: intensity=${filter.blur}, ${startUs / 1000}ms - ${if (endUs == Long.MAX_VALUE) "end" else "${endUs / 1000}ms"}"
        )
        videoEffects += TimestampWrapper(blurEffect, startUs, endUs)
    }
}
