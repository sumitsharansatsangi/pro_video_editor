import com.android.build.api.dsl.LibraryExtension
import org.gradle.api.tasks.testing.Test

plugins {
    id("com.android.library")
}

group = "ch.waio.pro_video_editor"
version = "1.0-SNAPSHOT"

repositories {
    google()
    mavenCentral()
}

val media3Version = "1.10.1"

extensions.configure<LibraryExtension>("android") {

    namespace = "ch.waio.pro_video_editor"

    compileSdk = 37

    defaultConfig {
        minSdk = 24
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    sourceSets {

        getByName("main") {
            java.setSrcDirs(
                listOf("src/main/kotlin")
            )
        }

        getByName("test") {
            java.setSrcDirs(
                listOf("src/test/kotlin")
            )
        }
    }

    testOptions {
        unitTests.all {

            this as Test

            useJUnitPlatform()

            testLogging {

                events(
                    "passed",
                    "skipped",
                    "failed",
                    "standardOut",
                    "standardError"
                )

                showStandardStreams = true
            }

            outputs.upToDateWhen { false }
        }
    }
}


dependencies {

    // Kotlin test
    testImplementation(kotlin("test"))

    // JUnit 5
    testImplementation("org.junit.jupiter:junit-jupiter-api:5.13.4")
    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:5.13.4")

    // Mockito
    testImplementation("org.mockito:mockito-core:5.23.0")

    // Media3
    implementation("androidx.media3:media3-common:$media3Version")
    implementation("androidx.media3:media3-transformer:$media3Version")
    implementation("androidx.media3:media3-effect:$media3Version")
    implementation("androidx.media3:media3-muxer:$media3Version")

    // Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.11.0")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.11.0")
}