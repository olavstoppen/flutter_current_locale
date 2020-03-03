package no.olavstoppen.flutter_current_locale

import android.content.Context
import android.icu.text.DecimalFormatSymbols
import android.telephony.TelephonyManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*

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
    when
    {
      call.method == "getCurrentLanguage" -> result.success(getCurrentLanguage())
      call.method == "getCurrentCountryCode" -> result.success(getCurrentCountryCode() ?: fallbackCountryCode())
      call.method == "getCurrentLocale" -> {

        val identifier = getIdentifier()
        val decimalSeparator = getDecimalSeparator()

        val language = mapOf(
                "phone" to getCurrentLanguage(),
                "locale" to getCurrentLanguage()
        )

        val country = mapOf(
                "phone" to getCurrentCountryCode(),
                "locale" to fallbackCountryCode(),
                "region" to getRegion()
        )

        result.success(mapOf(
                "identifier" to identifier,
                "decimals" to decimalSeparator,
                "language" to language,
                "country" to country
        ))
      }
      else -> result.notImplemented()
    }
  }

  private fun getCurrentCountryCode(): String?
  {    
    val manager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
    if (manager != null)
    {
      val countryId = manager.simCountryIso
      if (countryId != null && countryId.isNotEmpty())
      {
        return countryId.toUpperCase()
      }
    }
    return null
  }

  private fun fallbackCountryCode(): String?
  {
    val configuration = context.resources.configuration
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N)
    {
      val list = configuration.locales
      if (list.size() > 0)
      {
        val locale = list.get(0)
        return locale.country.toUpperCase()
      }
      return null
    }
    else
    {
      @Suppress("DEPRECATION") val current = context.resources.configuration.locale
      return current.country.toUpperCase()
    }
  }

  private fun getIdentifier() : String?
  {
    val configuration = context.resources.configuration
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N)
    {
      val list = configuration.locales
      if (list.size() > 0)
      {
        val locale = list.get(0)
        return locale.toLanguageTag()
      }
      return null
    }
    else
    {
      @Suppress("DEPRECATION")
      val current = context.resources.configuration.locale
      return current.toLanguageTag()
    }
  }

  private fun getRegion() : String?
  {
    val configuration = context.resources.configuration
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N)
    {
      val list = configuration.locales
      if (list.size() > 0)
      {
        val locale = list.get(0)
        return locale.country.toUpperCase()
      }
      return null
    }
    else
    {
      @Suppress("DEPRECATION")
      val current = context.resources.configuration.locale
      return current.country.toUpperCase()
    }
  }

  private fun getDecimalSeparator(): String?
  {
    val configuration = context.resources.configuration
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N)
    {
      val list = configuration.locales
      if (list.size() > 0)
      {
        val locale = list.get(0)
        val symbols = DecimalFormatSymbols(locale)
        return symbols.decimalSeparator.toString()
      }
      return null
    }
    else
    {
      val symbols = DecimalFormatSymbols()
      return symbols.decimalSeparator.toString()
    }
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
