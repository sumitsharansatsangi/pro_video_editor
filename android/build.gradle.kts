import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.library")
    kotlin("android")
}

group = "ch.waio.pro_video_editor"
version = "1.0-SNAPSHOT"

repositories {
    google()
    mavenCentral()
}

val media3Version = "1.10.1"

android {

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
            java.srcDirs("src/main/kotlin")
        }

        getByName("test") {
            java.srcDirs("src/test/kotlin")
        }
    }

    testOptions {
        unitTests.all {

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

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_21)
    }
}

dependencies {

    testImplementation(kotlin("test"))
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