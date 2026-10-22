
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

val media3Version = "1.11.1"
val exifInterfaceVersion = "1.4.2"
val coroutinesVersion = "1.11.0"
val junitVersion = "6.1.3"
val mockitoVersion = "5.24.0"

extensions.configure<LibraryExtension>("android") {
    namespace = "ch.waio.pro_video_editor"

    compileSdk = 37

    defaultConfig {
        minSdk = 24
        consumerProguardFiles("consumer-rules.pro")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    sourceSets {
        getByName("main") {
            java.directories.add("src/main/kotlin")
        }

        getByName("test") {
            java.directories.add("src/test/kotlin")
        }
    }

    testOptions {
        unitTests.isReturnDefaultValues = true

        unitTests.all { test: Test ->
            test.useJUnitPlatform()

            test.testLogging {
                events(
                    "passed",
                    "skipped",
                    "failed",
                    "standardOut",
                    "standardError"
                )

                showStandardStreams = true
            }

            test.outputs.upToDateWhen { false }
        }
    }
}

dependencies {
    // Kotlin tests with JUnit 5
    testImplementation(kotlin("test-junit5"))

    // JUnit Jupiter
    testImplementation("org.junit.jupiter:junit-jupiter-api:$junitVersion")
    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:$junitVersion")

    // Mockito
    testImplementation("org.mockito:mockito-core:$mockitoVersion")

    // AndroidX Media3
    implementation("androidx.media3:media3-common:$media3Version")
    implementation("androidx.media3:media3-transformer:$media3Version")
    implementation("androidx.media3:media3-inspector-frame:$media3Version")
    implementation("androidx.media3:media3-effect:$media3Version")
    implementation("androidx.media3:media3-muxer:$media3Version")

    // Image EXIF metadata
    implementation(
        "androidx.exifinterface:exifinterface:$exifInterfaceVersion"
    )

    // Kotlin Coroutines
    implementation(
        "org.jetbrains.kotlinx:kotlinx-coroutines-android:$coroutinesVersion"
    )
    implementation(
        "org.jetbrains.kotlinx:kotlinx-coroutines-core:$coroutinesVersion"
    )
}
