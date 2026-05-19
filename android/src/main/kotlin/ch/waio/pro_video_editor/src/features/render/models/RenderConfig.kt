package ch.waio.pro_video_editor.src.features.render.models

import PACKAGE_TAG
import ch.waio.pro_video_editor.src.shared.logging.PluginLog as Log
import io.flutter.plugin.common.MethodCall

/**
 * Represents a video clip segment with optional trimming.
 * 
 * @property inputPath Absolute path to video file
 * @property startUs Start time in microseconds (null = from beginning)
 * @property endUs End time in microseconds (null = until end)
 * @property volume Volume multiplier for this clip (null = unchanged, 0.0=mute, 1.0=original)
 * @property playbackSpeed Speed multiplier for this clip (null = unchanged, 0.5=half, 2.0=double)
 */
data class VideoClip(
    val inputPath: String,
    val startUs: Long?,
    val endUs: Long?,
    val volume: Float? = null,
    val playbackSpeed: Float? = null
)

/**
 * Represents a color filter with optional time range.
 *
 * @property matrix 4x5 color transformation matrix (20 elements)
 * @property startUs Start time in microseconds when the filter should be active (null = from start)
 * @property endUs End time in microseconds when the filter should stop (null = until end)
 */
data class ColorFilterConfig(
    val matrix: List<Double>,
    val startUs: Long?,
    val endUs: Long?
) {
    companion object {
        fun fromMap(map: Map<String, Any?>): ColorFilterConfig {
            @Suppress("UNCHECKED_CAST")
            val matrix = (map["matrix"] as? List<*>)?.map {
                (it as Number).toDouble()
            } ?: emptyList()
            return ColorFilterConfig(
                matrix = matrix,
                startUs = (map["startUs"] as? Number)?.toLong(),
                endUs = (map["endUs"] as? Number)?.toLong()
            )
        }
    }
}

/**
 * Represents a blur effect with optional time range.
 *
 * @property blur Blur intensity
 * @property startUs Start time in microseconds when the blur should be active
 * @property endUs End time in microseconds when the blur should stop
 */
data class BlurFilterConfig(
    val blur: Double,
    val startUs: Long?,
    val endUs: Long?
) {
    companion object {
        fun fromMap(map: Map<String, Any?>): BlurFilterConfig {
            return BlurFilterConfig(
                blur = (map["blur"] as? Number)?.toDouble() ?: 0.0,
                startUs = (map["startUs"] as? Number)?.toLong(),
                endUs = (map["endUs"] as? Number)?.toLong()
            )
        }
    }
}

/**
 * Represents a custom audio track with timing and volume configuration.
 *
 * @property path Absolute path to the audio file
 * @property volume Volume multiplier (0.0=silent, 1.0=unchanged, >1.0=amplified)
 * @property loop Whether to loop the audio if shorter than the video
 * @property audioStartUs Start offset within the audio file in microseconds
 * @property audioEndUs End offset within the audio file in microseconds (null = until end)
 * @property startUs Composition start time in microseconds (when in the video timeline this track starts)
 * @property endUs Composition end time in microseconds (when in the video timeline this track ends)
 */
data class AudioTrackConfig(
    val path: String,
    val volume: Float = 1.0f,
    val loop: Boolean = false,
    val audioStartUs: Long? = null,
    val audioEndUs: Long? = null,
    val startUs: Long? = null,
    val endUs: Long? = null
) {
    companion object {
        fun fromMap(map: Map<String, Any?>): AudioTrackConfig {
            return AudioTrackConfig(
                path = map["path"] as String,
                volume = (map["volume"] as? Number)?.toFloat() ?: 1.0f,
                loop = map["loop"] as? Boolean ?: false,
                audioStartUs = (map["audioStartUs"] as? Number)?.toLong(),
                audioEndUs = (map["audioEndUs"] as? Number)?.toLong(),
                startUs = (map["startUs"] as? Number)?.toLong(),
                endUs = (map["endUs"] as? Number)?.toLong()
            )
        }
    }
}

/**
 * Represents a single animation configuration for an image layer.
 *
 * @property type The kind of animation: "fade", "slide", or "scale"
 * @property phase When the animation plays: "animateIn", "animateOut", or "animateInOut"
 * @property durationUs Duration of the animation in microseconds
 * @property curve Easing curve name (e.g. "linear", "easeIn", "bounceOut")
 * @property slideDirection Slide direction: "left", "right", "top", or "bottom"
 * @property scaleFrom Starting scale factor for scale animations
 */
data class LayerAnimationConfig(
    val type: String,
    val phase: String,
    val durationUs: Long,
    val curve: String = "linear",
    val slideDirection: String? = null,
    val scaleFrom: Double? = null
) {
    companion object {
        fun fromMap(map: Map<String, Any?>): LayerAnimationConfig {
            return LayerAnimationConfig(
                type = map["type"] as String,
                phase = map["phase"] as String,
                durationUs = (map["durationUs"] as Number).toLong(),
                curve = map["curve"] as? String ?: "linear",
                slideDirection = map["slideDirection"] as? String,
                scaleFrom = (map["scaleFrom"] as? Number)?.toDouble()
            )
        }
    }
}

/**
 * Represents an image overlay layer with timing information.
 *
 * @property imageData The image data as a byte array
 * @property startUs Start time in microseconds when the layer should appear
 * @property endUs End time in microseconds when the layer should disappear (-1 = until end of video)
 * @property x Horizontal offset in pixels (null = stretch to fill)
 * @property y Vertical offset in pixels (null = stretch to fill)
 * @property width Target width in pixels (null = original width)
 * @property height Target height in pixels (null = original height)
 * @property animations List of animations to apply to this layer
 * @property rotation Clockwise rotation in degrees
 * @property opacity Layer opacity from 0.0 to 1.0
 * @property zIndex Draw order. Higher values render above lower values.
 * @property anchorX Normalized horizontal anchor point (0.0 left, 1.0 right)
 * @property anchorY Normalized vertical anchor point (0.0 top, 1.0 bottom)
 * @property blendMode Blend mode intent. Android currently uses source-over.
 */
data class ImageLayer(
    val imageData: ByteArray,
    val startUs: Long,
    val endUs: Long,
    val x: Int? = null,
    val y: Int? = null,
    val width: Double? = null,
    val height: Double? = null,
    val animations: List<LayerAnimationConfig> = emptyList(),
    val rotation: Float = 0f,
    val opacity: Float = 1f,
    val zIndex: Int = 0,
    val anchorX: Float? = null,
    val anchorY: Float? = null,
    val blendMode: String = "sourceOver"
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false
        other as ImageLayer
        return imageData.contentEquals(other.imageData) &&
                startUs == other.startUs &&
                endUs == other.endUs &&
                x == other.x &&
                y == other.y &&
                width == other.width &&
                height == other.height &&
                animations == other.animations &&
                rotation == other.rotation &&
                opacity == other.opacity &&
                zIndex == other.zIndex &&
                anchorX == other.anchorX &&
                anchorY == other.anchorY &&
                blendMode == other.blendMode
    }

    override fun hashCode(): Int {
        var result = imageData.contentHashCode()
        result = 31 * result + startUs.hashCode()
        result = 31 * result + endUs.hashCode()
        result = 31 * result + (x?.hashCode() ?: 0)
        result = 31 * result + (y?.hashCode() ?: 0)
        result = 31 * result + (width?.hashCode() ?: 0)
        result = 31 * result + (height?.hashCode() ?: 0)
        result = 31 * result + animations.hashCode()
        result = 31 * result + rotation.hashCode()
        result = 31 * result + opacity.hashCode()
        result = 31 * result + zIndex.hashCode()
        result = 31 * result + (anchorX?.hashCode() ?: 0)
        result = 31 * result + (anchorY?.hashCode() ?: 0)
        result = 31 * result + blendMode.hashCode()
        return result
    }
}

/**
 * Shared timing and placement values for native-rasterized visual layers.
 */
data class VisualLayerStyleConfig(
    val startUs: Long = -1L,
    val endUs: Long = -1L,
    val x: Double = 0.0,
    val y: Double = 0.0,
    val width: Double? = null,
    val height: Double? = null,
    val rotation: Float = 0f,
    val opacity: Float = 1f,
    val zIndex: Int = 0,
    val anchorX: Float = 0.5f,
    val anchorY: Float = 0.5f,
    val blendMode: String = "sourceOver"
) {
    companion object {
        fun fromMap(map: Map<String, Any?>): VisualLayerStyleConfig {
            return VisualLayerStyleConfig(
                startUs = (map["startUs"] as? Number)?.toLong() ?: -1L,
                endUs = (map["endUs"] as? Number)?.toLong() ?: -1L,
                x = (map["x"] as? Number)?.toDouble() ?: 0.0,
                y = (map["y"] as? Number)?.toDouble() ?: 0.0,
                width = (map["width"] as? Number)?.toDouble(),
                height = (map["height"] as? Number)?.toDouble(),
                rotation = (map["rotation"] as? Number)?.toFloat() ?: 0f,
                opacity = (map["opacity"] as? Number)?.toFloat()?.coerceIn(0f, 1f) ?: 1f,
                zIndex = (map["zIndex"] as? Number)?.toInt() ?: 0,
                anchorX = (map["anchorX"] as? Number)?.toFloat() ?: 0.5f,
                anchorY = (map["anchorY"] as? Number)?.toFloat() ?: 0.5f,
                blendMode = map["blendMode"] as? String ?: "sourceOver"
            )
        }
    }
}

data class TextLayerConfig(
    val text: String,
    val style: VisualLayerStyleConfig,
    val fontFamily: String? = null,
    val fontSize: Float = 24f,
    val color: String = "#FFFFFFFF",
    val backgroundColor: String? = null,
    val align: String = "left",
    val bold: Boolean = false,
    val italic: Boolean = false,
    val letterSpacing: Float = 0f,
    val lineHeight: Float? = null
) {
    companion object {
        fun fromMap(map: Map<String, Any?>): TextLayerConfig {
            return TextLayerConfig(
                text = map["text"] as? String ?: "",
                style = VisualLayerStyleConfig.fromMap(map),
                fontFamily = map["fontFamily"] as? String,
                fontSize = (map["fontSize"] as? Number)?.toFloat() ?: 24f,
                color = map["color"] as? String ?: "#FFFFFFFF",
                backgroundColor = map["backgroundColor"] as? String,
                align = map["align"] as? String ?: "left",
                bold = map["bold"] as? Boolean ?: false,
                italic = map["italic"] as? Boolean ?: false,
                letterSpacing = (map["letterSpacing"] as? Number)?.toFloat() ?: 0f,
                lineHeight = (map["lineHeight"] as? Number)?.toFloat()
            )
        }
    }
}

data class ShapeLayerConfig(
    val type: String,
    val style: VisualLayerStyleConfig,
    val fillColor: String? = null,
    val strokeColor: String = "#FFFFFFFF",
    val strokeWidth: Float = 2f,
    val cornerRadius: Float = 0f
) {
    companion object {
        fun fromMap(map: Map<String, Any?>): ShapeLayerConfig {
            return ShapeLayerConfig(
                type = map["type"] as? String ?: "rectangle",
                style = VisualLayerStyleConfig.fromMap(map),
                fillColor = map["fillColor"] as? String,
                strokeColor = map["strokeColor"] as? String ?: "#FFFFFFFF",
                strokeWidth = (map["strokeWidth"] as? Number)?.toFloat() ?: 2f,
                cornerRadius = (map["cornerRadius"] as? Number)?.toFloat() ?: 0f
            )
        }
    }
}

data class StickerLayerConfig(
    val value: String,
    val style: VisualLayerStyleConfig,
    val pack: String? = null,
    val label: String? = null
) {
    companion object {
        fun fromMap(map: Map<String, Any?>): StickerLayerConfig {
            return StickerLayerConfig(
                value = map["value"] as? String ?: "",
                style = VisualLayerStyleConfig.fromMap(map),
                pack = map["pack"] as? String,
                label = map["label"] as? String
            )
        }
    }
}

/**
 * Typed colour-grading adjustments passed from Flutter.
 *
 * All fields are nullable — a null value means that adjustment is not applied.
 */
data class AdjustmentConfig(
    val brightness: Double?,
    val contrast: Double?,
    val saturation: Double?,
    val exposure: Double?,
    val warmth: Double?,
    val tint: Double?,
    val sharpen: Double?
) {
    companion object {
        fun fromMap(map: Map<String, Any?>): AdjustmentConfig {
            return AdjustmentConfig(
                brightness = (map["brightness"] as? Number)?.toDouble(),
                contrast = (map["contrast"] as? Number)?.toDouble(),
                saturation = (map["saturation"] as? Number)?.toDouble(),
                exposure = (map["exposure"] as? Number)?.toDouble(),
                warmth = (map["warmth"] as? Number)?.toDouble(),
                tint = (map["tint"] as? Number)?.toDouble(),
                sharpen = (map["sharpen"] as? Number)?.toDouble()
            )
        }
    }
}

data class RenderConfig(
    val videoClips: List<VideoClip>,
    val imageLayers: List<ImageLayer> = emptyList(),
    val textLayers: List<TextLayerConfig> = emptyList(),
    val shapeLayers: List<ShapeLayerConfig> = emptyList(),
    val stickerLayers: List<StickerLayerConfig> = emptyList(),
    val outputFormat: String,
    val outputPath: String? = null,
    val rotateTurns: Int? = null,
    val flipX: Boolean = false,
    val flipY: Boolean = false,
    val cropWidth: Int? = null,
    val cropHeight: Int? = null,
    val cropX: Int? = null,
    val cropY: Int? = null,
    val scaleX: Float? = null,
    val scaleY: Float? = null,
    val bitrate: Int? = null,
    val enableAudio: Boolean = true,
    val playbackSpeed: Float? = null,
    val colorFilters: List<ColorFilterConfig> = emptyList(),
    val blurFilters: List<BlurFilterConfig> = emptyList(),
    val audioTracks: List<AudioTrackConfig> = emptyList(),
    val replaceOriginalAudioPath: String? = null,
    val blur: Double? = null,
    /** Global start time in microseconds for trimming the final composition */
    val startUs: Long? = null,
    /** Global end time in microseconds for trimming the final composition */
    val endUs: Long? = null,
    /** Whether to optimize the video for network streaming (fast start). */
    val shouldOptimizeForNetworkUse: Boolean = true,
    /** Whether to apply cropping to the image overlay along with the video. */
    val imageBytesWithCropping: Boolean = false,
    /** Typed colour-grading adjustments (brightness, contrast, etc.). */
    val adjustment: AdjustmentConfig? = null
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false
        other as RenderConfig
        return videoClips == other.videoClips &&
                imageLayers == other.imageLayers &&
                textLayers == other.textLayers &&
                shapeLayers == other.shapeLayers &&
                stickerLayers == other.stickerLayers &&
                replaceOriginalAudioPath == other.replaceOriginalAudioPath &&
                outputFormat == other.outputFormat &&
                outputPath == other.outputPath
    }

    override fun hashCode(): Int {
        var result = videoClips.hashCode()
        result = 31 * result + imageLayers.hashCode()
        result = 31 * result + textLayers.hashCode()
        result = 31 * result + shapeLayers.hashCode()
        result = 31 * result + stickerLayers.hashCode()
        result = 31 * result + (replaceOriginalAudioPath?.hashCode() ?: 0)
        result = 31 * result + outputFormat.hashCode()
        result = 31 * result + (outputPath?.hashCode() ?: 0)
        return result
    }

    companion object {
        /**
         * Creates a RenderConfig from a Flutter MethodCall.
         *
         * @param call The MethodCall containing all render parameters
         * @throws IllegalArgumentException if required videoClips are missing or invalid
         */
        fun fromMethodCall(call: MethodCall): RenderConfig {
            // Parse video clips (required)
            val videoClipsRaw = call.argument<List<Map<String, Any>>>("videoClips")

            Log.d(PACKAGE_TAG, "Received videoClipsRaw: ${videoClipsRaw?.size ?: 0} clips")

            if (videoClipsRaw.isNullOrEmpty()) {
                throw IllegalArgumentException("videoClips is required and cannot be empty")
            }

            val videoClips: List<VideoClip> = videoClipsRaw.mapIndexed { index, clipMap ->
                val clip = VideoClip(
                    inputPath = clipMap["inputPath"] as String,
                    startUs = (clipMap["startUs"] as? Number)?.toLong(),
                    endUs = (clipMap["endUs"] as? Number)?.toLong(),
                    volume = (clipMap["volume"] as? Number)?.toFloat(),
                    playbackSpeed = (clipMap["playbackSpeed"] as? Number)?.toFloat()
                )
                Log.d(
                    PACKAGE_TAG,
                    "Clip $index: path=${clip.inputPath}, start=${clip.startUs}, end=${clip.endUs}, volume=${clip.volume}, speed=${clip.playbackSpeed}"
                )
                clip
            }

            // Parse image layers
            val imageLayersRaw = call.argument<List<Map<String, Any>>>("imageLayers")
            val imageLayers: List<ImageLayer> = imageLayersRaw?.mapNotNull { layerMap ->
                val imageData = layerMap["imageData"] as? ByteArray
                val startUs = (layerMap["startUs"] as? Number)?.toLong() ?: -1L
                val endUs = (layerMap["endUs"] as? Number)?.toLong() ?: -1L
                val x = (layerMap["x"] as? Number)?.toInt()
                val y = (layerMap["y"] as? Number)?.toInt()
                val width = (layerMap["width"] as? Number)?.toDouble()
                val height = (layerMap["height"] as? Number)?.toDouble()
                val rotation = (layerMap["rotation"] as? Number)?.toFloat() ?: 0f
                val opacity = (layerMap["opacity"] as? Number)?.toFloat()?.coerceIn(0f, 1f)
                    ?: 1f
                val zIndex = (layerMap["zIndex"] as? Number)?.toInt() ?: 0
                val anchorX = (layerMap["anchorX"] as? Number)?.toFloat()
                val anchorY = (layerMap["anchorY"] as? Number)?.toFloat()
                val blendMode = layerMap["blendMode"] as? String ?: "sourceOver"

                // Parse animations
                @Suppress("UNCHECKED_CAST")
                val animationsRaw = layerMap["animations"] as? List<Map<String, Any?>>
                val animations = animationsRaw?.map { LayerAnimationConfig.fromMap(it) } ?: emptyList()

                if (imageData == null || imageData.isEmpty()) {
                    null
                } else {
                    ImageLayer(
                        imageData,
                        startUs,
                        endUs,
                        x,
                        y,
                        width,
                        height,
                        animations,
                        rotation,
                        opacity,
                        zIndex,
                        anchorX,
                        anchorY,
                        blendMode
                    )
                }
            }?.sortedBy { it.zIndex } ?: emptyList()

            Log.d(PACKAGE_TAG, "Parsed ${imageLayers.size} image layer(s)")

            @Suppress("UNCHECKED_CAST")
            val textLayersRaw = call.argument<List<Map<String, Any?>>>("textLayers")
            val textLayers = textLayersRaw
                ?.map { TextLayerConfig.fromMap(it) }
                ?.filter { it.text.isNotEmpty() }
                ?: emptyList()
            Log.d(PACKAGE_TAG, "Parsed ${textLayers.size} text layer(s)")

            @Suppress("UNCHECKED_CAST")
            val shapeLayersRaw = call.argument<List<Map<String, Any?>>>("shapeLayers")
            val shapeLayers = shapeLayersRaw
                ?.map { ShapeLayerConfig.fromMap(it) }
                ?: emptyList()
            Log.d(PACKAGE_TAG, "Parsed ${shapeLayers.size} shape layer(s)")

            @Suppress("UNCHECKED_CAST")
            val stickerLayersRaw = call.argument<List<Map<String, Any?>>>("stickerLayers")
            val stickerLayers = stickerLayersRaw
                ?.map { StickerLayerConfig.fromMap(it) }
                ?.filter { it.value.isNotEmpty() }
                ?: emptyList()
            Log.d(PACKAGE_TAG, "Parsed ${stickerLayers.size} sticker layer(s)")

            // Parse color filters
            @Suppress("UNCHECKED_CAST")
            val colorFiltersRaw = call.argument<List<Map<String, Any?>>>("colorFilters")
            val colorFilters = colorFiltersRaw?.map { ColorFilterConfig.fromMap(it) } ?: emptyList()
            Log.d(PACKAGE_TAG, "Parsed ${colorFilters.size} color filter(s)")

            // Parse blur filters
            @Suppress("UNCHECKED_CAST")
            val blurFiltersRaw = call.argument<List<Map<String, Any?>>>("blurFilters")
            val blurFilters = blurFiltersRaw?.map { BlurFilterConfig.fromMap(it) } ?: emptyList()
            Log.d(PACKAGE_TAG, "Parsed ${blurFilters.size} blur filter(s)")

            // Parse audio tracks
            @Suppress("UNCHECKED_CAST")
            val audioTracksRaw = call.argument<List<Map<String, Any?>>>("audioTracks")
            val audioTracks = audioTracksRaw?.map { AudioTrackConfig.fromMap(it) } ?: emptyList()
            Log.d(PACKAGE_TAG, "Parsed ${audioTracks.size} audio track(s)")

            // Parse all other parameters
            return RenderConfig(
                videoClips = videoClips,
                imageLayers = imageLayers,
                textLayers = textLayers,
                shapeLayers = shapeLayers,
                stickerLayers = stickerLayers,
                outputFormat = call.argument<String>("outputFormat") ?: "mp4",
                outputPath = call.argument<String>("outputPath"),
                rotateTurns = call.argument<Number>("rotateTurns")?.toInt(),
                flipX = call.argument<Boolean>("flipX") ?: false,
                flipY = call.argument<Boolean>("flipY") ?: false,
                cropWidth = call.argument<Number>("cropWidth")?.toInt(),
                cropHeight = call.argument<Number>("cropHeight")?.toInt(),
                cropX = call.argument<Number>("cropX")?.toInt(),
                cropY = call.argument<Number>("cropY")?.toInt(),
                scaleX = call.argument<Number>("scaleX")?.toFloat(),
                scaleY = call.argument<Number>("scaleY")?.toFloat(),
                bitrate = call.argument<Number>("bitrate")?.toInt(),
                enableAudio = call.argument<Boolean>("enableAudio") ?: true,
                playbackSpeed = call.argument<Number>("playbackSpeed")?.toFloat(),
                colorFilters = colorFilters,
                blurFilters = blurFilters,
                audioTracks = audioTracks,
                replaceOriginalAudioPath = call.argument<String>("replaceOriginalAudioPath"),
                blur = call.argument<Number>("blur")?.toDouble(),
                startUs = call.argument<Number?>("startUs")?.toLong(),
                endUs = call.argument<Number?>("endUs")?.toLong(),
                shouldOptimizeForNetworkUse = call.argument<Boolean>("shouldOptimizeForNetworkUse")
                    ?: true,
                imageBytesWithCropping = call.argument<Boolean>("imageBytesWithCropping") ?: false,
                adjustment = call.argument<Map<String, Any?>>("adjustment")
                    ?.let { AdjustmentConfig.fromMap(it) }
            )
        }
    }
}
