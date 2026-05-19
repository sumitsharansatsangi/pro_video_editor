import androidx.media3.common.Effect
import androidx.media3.common.util.UnstableApi
import androidx.media3.effect.Contrast
import androidx.media3.effect.HslAdjustment
import androidx.media3.effect.RgbAdjustment
import ch.waio.pro_video_editor.src.features.render.models.AdjustmentConfig
import ch.waio.pro_video_editor.src.shared.logging.PluginLog as Log

/**
 * Applies colour-grading adjustments (brightness, contrast, saturation, etc.)
 * using Media3's built-in GL effects.
 *
 * Mapping of [AdjustmentConfig] fields to Media3 effects:
 * - brightness → [RgbAdjustment] with uniform R/G/B multiplication
 * - contrast    → [Contrast]
 * - saturation  → [HslAdjustment].adjustSaturation
 * - exposure    → [RgbAdjustment] with exposure-stop multiplication
 * - warmth      → [RgbAdjustment] shifting red/blue channels
 * - tint        → [RgbAdjustment] shifting green channel
 * - sharpen     → currently unsupported by Media3; logged and skipped
 */
@UnstableApi
fun applyAdjustment(
    videoEffects: MutableList<Effect>,
    adjustment: AdjustmentConfig?
) {
    if (adjustment == null) return

    // Brightness: multiply all channels uniformly.
    // Input range -1..1 → scale 0..2 (1.0 = neutral).
    adjustment.brightness?.let { b ->
        val scale = (b.toFloat() + 1f).coerceIn(0f, 2f)
        Log.d(RENDER_TAG, "Applying brightness: input=$b, scale=$scale")
        videoEffects += RgbAdjustment.Builder()
            .scaleRed(scale)
            .scaleGreen(scale)
            .scaleBlue(scale)
            .build()
    }

    // Contrast: Media3 Contrast takes a value in [-1, 1].
    adjustment.contrast?.let { c ->
        Log.d(RENDER_TAG, "Applying contrast: $c")
        videoEffects += Contrast(c.toFloat())
    }

    // Saturation via HslAdjustment. Media3 uses [-1, 1] range.
    adjustment.saturation?.let { s ->
        Log.d(RENDER_TAG, "Applying saturation: $s")
        videoEffects += HslAdjustment.Builder()
            .adjustSaturation(s.toFloat())
            .build()
    }

    // Exposure in EV stops (range -3..3).
    // Each EV stop doubles/halves luminance → scale = 2^EV.
    adjustment.exposure?.let { e ->
        val scale = Math.pow(2.0, e).toFloat()
        Log.d(RENDER_TAG, "Applying exposure: $e EV, scale=$scale")
        videoEffects += RgbAdjustment.Builder()
            .scaleRed(scale)
            .scaleGreen(scale)
            .scaleBlue(scale)
            .build()
    }

    // Warmth: shift red up / blue down (positive = warm, negative = cool).
    adjustment.warmth?.let { w ->
        val wf = w.toFloat()
        Log.d(RENDER_TAG, "Applying warmth: $wf")
        videoEffects += RgbAdjustment.Builder()
            .scaleRed((1f + wf * 0.3f).coerceIn(0f, 2f))
            .scaleBlue((1f - wf * 0.3f).coerceIn(0f, 2f))
            .build()
    }

    // Tint: green channel shift (positive = magenta, negative = green).
    adjustment.tint?.let { t ->
        val tf = t.toFloat()
        Log.d(RENDER_TAG, "Applying tint: $tf")
        videoEffects += RgbAdjustment.Builder()
            .scaleGreen((1f - tf * 0.3f).coerceIn(0f, 2f))
            .build()
    }

    // Sharpen: Media3 does not provide a built-in sharpening effect.
    if (adjustment.sharpen != null) {
        Log.d(RENDER_TAG, "Sharpen requested but not supported on Android; skipped.")
    }
}
