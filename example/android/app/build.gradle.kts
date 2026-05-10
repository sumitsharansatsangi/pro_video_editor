import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // Flutter plugin must be applied after Android & Kotlin plugins
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.pro_video_editor_example"

    compileSdk = 37
    ndkVersion = "30.0.14904198"

    defaultConfig {
        applicationId = "com.example.pro_video_editor_example"

        minSdk = 24
        targetSdk = 37

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_21)
        }
    }

    buildTypes {
        release {
            // Temporary debug signing for flutter run --release
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}