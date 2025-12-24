plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.productivityapp"
    // CHANGED: Must be 36 to satisfy plugin requirements
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.productivityapp"
        minSdk = flutter.minSdkVersion
        targetSdk = 34 // This can remain 34 or be updated to 35/36
        versionCode = 1
        versionName = "1.0.0"

        multiDexEnabled = true
    }

    compileOptions {
        // REQUIRED: Enables support for newer Java APIs used by notifications
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase Dependencies
    implementation(platform("com.google.firebase:firebase-bom:33.7.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")

    // REQUIRED: Core Library Desugaring Dependency
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}