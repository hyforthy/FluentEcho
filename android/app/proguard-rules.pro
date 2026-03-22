# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Keep entry points
-keepattributes *Annotation*
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-dontwarn kotlin.**

# ExoPlayer / just_audio
-keep class com.google.android.exoplayer2.** { *; }
-keep class androidx.media3.** { *; }
-dontwarn com.google.android.exoplayer2.**
-dontwarn androidx.media3.**

# SQLite
-keep class org.sqlite.** { *; }
-keep class org.sqlite.database.** { *; }

# General
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
