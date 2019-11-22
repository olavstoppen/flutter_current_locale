package no.olavstoppen.flutter_current_locale

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


class FlutterCurrentLocalePlugin(private val context: Context) : MethodCallHandler
{
  companion object
  {
    @JvmStatic
    fun registerWith(registrar: Registrar)
    {
      val channel = MethodChannel(registrar.messenger(), "plugins.olavstoppen.no/current_locale")
      channel.setMethodCallHandler(FlutterCurrentLocalePlugin(registrar.context()))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result)
  {
    if (call.method == "getCurrentLanguage")
    {
      val language = getCurrentLanguage()
      if (language != null)
        result.success(language)
      else
        result.notImplemented()
    }
    else if (call.method == "getCurrentCountryCode")
    {
      val code = getCurrentCountryCode()
      if (code != null)
        result.success(code)
      else
        result.notImplemented()
    }
    else
    {
      result.notImplemented()
    }
  }

  private fun getCurrentCountryCode(): String?
  {
    // TODO: Get the country code from the phone (dont base it on the Locale as thats not going to be accurate)
    return null
  }

  private fun getCurrentLanguage(): String?
  {
    val configuration = context.resources.configuration
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N)
    {
      val list = configuration.locales
      if (list.size() > 0)
      {
        val locale = list.get(0)
        return locale.language
      }
      return null
    }
    else
    {
      @Suppress("DEPRECATION") val current = context.resources.configuration.locale
      return current.language
    }
  }
}
