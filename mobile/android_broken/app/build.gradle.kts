plugins {
    id("com.android.application")
    id("kotlin-android")
}

// This successfully bypasses the 'generateLockfiles' AGP 9 crash
apply(plugin = "dev.flutter.flutter-gradle-plugin")

android {
    namespace = "com.example.ciro"
    ndkPath = "C:\\Users\\sohail\\AppData\\Local\\Android\\Sdk\\ndk\\28.2.13676358"
    ndkVersion = "28.2.13676358"

    // Hardcoded to standard Flutter targets to bypass the "Unresolved reference: flutter" error
    compileSdk = 35

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.ciro"
        
        // Hardcoded standard SDK values
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// Notice the flutter { source = "../.." } block is entirely deleted.

configurations.all {
    resolutionStrategy {
        force("androidx.core:core:1.13.1")
        force("androidx.core:core-ktx:1.13.1")
        force("androidx.browser:browser:1.8.0")
    }
}