-dontwarn android.window.BackEvent
-keep class com.pichillilorenzo.flutter_inappwebview.** { *; }
-keep class android.webkit.** { *; }

-keep class * extends androidx.fragment.app.Fragment{}
-keep class androidx.window.** { *; }
-keep class com.pichillilorenzo.flutter_inappwebview.** { *; }
-keepclassmembers class * extends android.webkit.WebViewClient {
    public void *(android.webkit.WebView, java.lang.String, android.graphics.Bitmap);
    public boolean *(android.webkit.WebView, java.lang.String);
}
-keepclassmembers class * extends android.webkit.WebViewClient {
    public void *(android.webkit.WebView, java.lang.String);
}