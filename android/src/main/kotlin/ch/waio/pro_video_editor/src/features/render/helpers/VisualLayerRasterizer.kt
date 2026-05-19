package ch.waio.pro_video_editor.src.features.render.helpers

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.RectF
import android.graphics.Typeface
import ch.waio.pro_video_editor.src.features.render.models.ShapeLayerConfig
import ch.waio.pro_video_editor.src.features.render.models.StickerLayerConfig
import ch.waio.pro_video_editor.src.features.render.models.TextLayerConfig
import ch.waio.pro_video_editor.src.features.render.models.VisualLayerStyleConfig
import java.io.ByteArrayOutputStream
import kotlin.math.ceil
import kotlin.math.max

/**
 * Rasterizes structured visual layers into transparent PNG overlays.
 *
 * Media3 already has a robust bitmap overlay path in this plugin. Text, shape,
 * and sticker layers are converted into bitmap overlays so they inherit the
 * existing timing, opacity, rotation, anchor, animation, and z-index handling.
 */
object VisualLayerRasterizer {
    fun rasterizeText(layer: TextLayerConfig): VideoSequenceBuilder.ImageLayerConfig? {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = parseColor(layer.color, Color.WHITE)
            textSize = layer.fontSize
            letterSpacing = if (textSize > 0f) layer.letterSpacing / textSize else 0f
            typeface = Typeface.create(
                layer.fontFamily,
                when {
                    layer.bold && layer.italic -> Typeface.BOLD_ITALIC
                    layer.bold -> Typeface.BOLD
                    layer.italic -> Typeface.ITALIC
                    else -> Typeface.NORMAL
                }
            )
        }

        val lines = layer.text.split('\n')
        val fontMetrics = paint.fontMetrics
        val lineHeight = (fontMetrics.descent - fontMetrics.ascent) *
                (layer.lineHeight ?: 1.0f)
        val measuredWidth = lines.maxOfOrNull { paint.measureText(it) } ?: 1f
        val bitmapWidth = layer.style.width?.toInt()
            ?: ceil(measuredWidth).toInt().coerceAtLeast(1)
        val bitmapHeight = layer.style.height?.toInt()
            ?: ceil(lineHeight * lines.size).toInt().coerceAtLeast(1)

        val bitmap = Bitmap.createBitmap(bitmapWidth, bitmapHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)

        layer.backgroundColor?.let { color ->
            canvas.drawColor(parseColor(color, Color.TRANSPARENT))
        }

        val textAlign = when (layer.align) {
            "center" -> Paint.Align.CENTER
            "right" -> Paint.Align.RIGHT
            else -> Paint.Align.LEFT
        }
        paint.textAlign = textAlign

        val x = when (textAlign) {
            Paint.Align.CENTER -> bitmapWidth / 2f
            Paint.Align.RIGHT -> bitmapWidth.toFloat()
            else -> 0f
        }

        var baseline = -fontMetrics.ascent
        for (line in lines) {
            canvas.drawText(line, x, baseline, paint)
            baseline += lineHeight
        }

        return bitmap.toLayerConfig(layer.style)
    }

    fun rasterizeShape(layer: ShapeLayerConfig): VideoSequenceBuilder.ImageLayerConfig? {
        val strokePadding = max(1f, layer.strokeWidth / 2f)
        val bitmapWidth = layer.style.width?.toInt()?.coerceAtLeast(1) ?: 120
        val bitmapHeight = layer.style.height?.toInt()?.coerceAtLeast(1) ?: 80
        val bitmap = Bitmap.createBitmap(bitmapWidth, bitmapHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        val rect = RectF(
            strokePadding,
            strokePadding,
            bitmapWidth - strokePadding,
            bitmapHeight - strokePadding
        )

        val fillPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.FILL
            color = parseColor(layer.fillColor, Color.TRANSPARENT)
        }
        val strokePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            strokeWidth = layer.strokeWidth
            strokeCap = Paint.Cap.ROUND
            strokeJoin = Paint.Join.ROUND
            color = parseColor(layer.strokeColor, Color.WHITE)
        }

        when (layer.type) {
            "circle" -> {
                if (layer.fillColor != null) canvas.drawOval(rect, fillPaint)
                if (layer.strokeWidth > 0f) canvas.drawOval(rect, strokePaint)
            }
            "line" -> {
                canvas.drawLine(
                    strokePadding,
                    bitmapHeight - strokePadding,
                    bitmapWidth - strokePadding,
                    strokePadding,
                    strokePaint
                )
            }
            "arrow" -> drawArrow(canvas, rect, strokePaint)
            "highlightBox" -> {
                val highlightPaint = Paint(fillPaint).apply {
                    color = parseColor(layer.fillColor, 0x66FFFF00)
                }
                canvas.drawRoundRect(rect, layer.cornerRadius, layer.cornerRadius, highlightPaint)
                if (layer.strokeWidth > 0f) {
                    canvas.drawRoundRect(rect, layer.cornerRadius, layer.cornerRadius, strokePaint)
                }
            }
            else -> {
                if (layer.fillColor != null) {
                    canvas.drawRoundRect(rect, layer.cornerRadius, layer.cornerRadius, fillPaint)
                }
                if (layer.strokeWidth > 0f) {
                    canvas.drawRoundRect(rect, layer.cornerRadius, layer.cornerRadius, strokePaint)
                }
            }
        }

        return bitmap.toLayerConfig(layer.style)
    }

    fun rasterizeSticker(layer: StickerLayerConfig): VideoSequenceBuilder.ImageLayerConfig? {
        val size = layer.style.width?.toInt()
            ?: layer.style.height?.toInt()
            ?: 64
        val bitmapWidth = (layer.style.width?.toInt() ?: size).coerceAtLeast(1)
        val bitmapHeight = (layer.style.height?.toInt() ?: size).coerceAtLeast(1)
        val bitmap = Bitmap.createBitmap(bitmapWidth, bitmapHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.WHITE
            textSize = minOf(bitmapWidth, bitmapHeight) * 0.82f
            textAlign = Paint.Align.CENTER
            typeface = Typeface.DEFAULT
        }
        val baseline = bitmapHeight / 2f - (paint.descent() + paint.ascent()) / 2f
        canvas.drawText(layer.value, bitmapWidth / 2f, baseline, paint)
        return bitmap.toLayerConfig(layer.style)
    }

    private fun drawArrow(canvas: Canvas, rect: RectF, paint: Paint) {
        val startX = rect.left
        val startY = rect.bottom
        val endX = rect.right
        val endY = rect.top
        canvas.drawLine(startX, startY, endX, endY, paint)

        val headSize = max(12f, paint.strokeWidth * 4f)
        val path = Path().apply {
            moveTo(endX, endY)
            lineTo(endX - headSize, endY + headSize * 0.25f)
            lineTo(endX - headSize * 0.25f, endY + headSize)
            close()
        }
        val fill = Paint(paint).apply { style = Paint.Style.FILL }
        canvas.drawPath(path, fill)
    }

    private fun Bitmap.toLayerConfig(
        style: VisualLayerStyleConfig
    ): VideoSequenceBuilder.ImageLayerConfig? {
        val bytes = ByteArrayOutputStream().use { stream ->
            compress(Bitmap.CompressFormat.PNG, 100, stream)
            stream.toByteArray()
        }
        recycle()
        if (bytes.isEmpty()) return null

        return VideoSequenceBuilder.ImageLayerConfig(
            imageBytes = bytes,
            scaleX = null,
            scaleY = null,
            withCropping = false,
            startUs = style.startUs,
            endUs = style.endUs,
            x = style.x.toInt(),
            y = style.y.toInt(),
            width = style.width,
            height = style.height,
            rotation = style.rotation,
            opacity = style.opacity,
            zIndex = style.zIndex,
            anchorX = style.anchorX,
            anchorY = style.anchorY,
            blendMode = style.blendMode
        )
    }

    private fun parseColor(value: String?, fallback: Int): Int {
        if (value.isNullOrBlank()) return fallback
        return try {
            Color.parseColor(value)
        } catch (_: IllegalArgumentException) {
            fallback
        }
    }

}
