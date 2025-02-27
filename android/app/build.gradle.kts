plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.raw_absen"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    signingConfigs {
        create("release") {
            storeFile = file("bengkelly.jks")
            storePassword = "Tth@bengkelly"
            keyAlias = "bengkellyalias"
            keyPassword = "Tth@bengkelly"
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.raw_absen"
        minSdk = 21
        targetSdk = 35
        versionCode = 5
        versionName = "4.2"
    }

    ndkVersion = "27.0.12077973"

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            // Kamu bisa menambahkan opsi lain seperti minifyEnabled atau shrinkResources jika diperlukan
        }
    }
}

flutter {
    source = "../.."
}
