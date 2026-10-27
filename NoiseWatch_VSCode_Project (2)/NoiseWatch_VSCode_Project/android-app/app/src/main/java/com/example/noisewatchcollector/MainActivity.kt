package com.example.noisewatchcollector

import android.os.Bundle
import android.view.Gravity
import android.widget.Button
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import androidx.activity.ComponentActivity
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.PermissionController
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.HeartRateRecord
import androidx.health.connect.client.records.StepsRecord
import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.time.TimeRangeFilter
import org.json.JSONArray
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import java.time.Instant
import java.time.temporal.ChronoUnit
import java.util.concurrent.Executors

class MainActivity : ComponentActivity() {
  companion object {
    // Replace with laptop Wi-Fi IPv4, e.g. http://192.168.1.10:8000
    private const val API_BASE_URL = "http://192.168.1.10:8000"
    private val REQUIRED_PERMISSIONS = setOf(HealthPermission.getReadPermission(StepsRecord::class), HealthPermission.getReadPermission(HeartRateRecord::class))
  }
  private lateinit var status: TextView
  private val executor = Executors.newSingleThreadExecutor()
  private var client: HealthConnectClient? = null
  private val permissionLauncher = registerForActivityResult(PermissionController.createRequestPermissionResultContract()) { granted -> status.text = if (granted.containsAll(REQUIRED_PERMISSIONS)) "Permissions granted. Tap Read & Upload." else "Allow Steps and Heart Rate permissions in Health Connect." }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    client = try { HealthConnectClient.getOrCreate(this) } catch (e: Exception) { null }
    val title = TextView(this).apply { text = "Noise Watch Health Collector"; textSize = 23f; gravity = Gravity.CENTER; setPadding(16,28,16,12) }
    status = TextView(this).apply { text = "1) Sync watch with NoiseFit\n2) Check Health Connect data\n3) Grant permissions and upload."; textSize = 16f; setPadding(20,18,20,18) }
    val permissionButton = Button(this).apply { text = "Request Health Permissions"; setOnClickListener { if (client == null) status.text = "Health Connect unavailable. Install/enable it first." else permissionLauncher.launch(REQUIRED_PERMISSIONS) } }
    val uploadButton = Button(this).apply { text = "Read & Upload"; setOnClickListener { readAndUpload() } }
    val layout = LinearLayout(this).apply { orientation = LinearLayout.VERTICAL; addView(title); addView(status); addView(permissionButton); addView(uploadButton); setPadding(12,12,12,12) }
    setContentView(ScrollView(this).apply { addView(layout) })
  }

  private fun readAndUpload() {
    val hc = client ?: run { status.text = "Health Connect unavailable on this phone."; return }
    status.text = "Reading Health Connect..."
    executor.execute {
      try {
        if (!hc.permissionController.getGrantedPermissions().containsAll(REQUIRED_PERMISSIONS)) { runOnUiThread { status.text = "Tap Request Health Permissions first." }; return@execute }
        val end = Instant.now(); val start = end.minus(1, ChronoUnit.DAYS); val range = TimeRangeFilter.between(start,end); val array = JSONArray()
        val steps = hc.readRecords(ReadRecordsRequest(StepsRecord::class, timeRangeFilter=range)).records
        for (r in steps) { val o=JSONObject(); o.put("record_type","steps"); o.put("value",r.count); o.put("unit","count"); o.put("start_time",r.startTime.toString()); o.put("end_time",r.endTime.toString()); o.put("source",r.metadata.dataOrigin.packageName); array.put(o) }
        val hrs = hc.readRecords(ReadRecordsRequest(HeartRateRecord::class, timeRangeFilter=range)).records
        for (r in hrs) for (s in r.samples) { val o=JSONObject(); o.put("record_type","heart_rate"); o.put("value",s.beatsPerMinute); o.put("unit","bpm"); o.put("start_time",s.time.toString()); o.put("end_time",s.time.toString()); o.put("source",r.metadata.dataOrigin.packageName); array.put(o) }
        if (array.length()==0) { runOnUiThread { status.text = "No records in last 24 hours. Sync NoiseFit and verify Health Connect has data." }; return@execute }
        val body=JSONObject(); body.put("device_id",android.os.Build.MODEL); body.put("records",array); val response=postJson("$API_BASE_URL/api/health-records",body.toString())
        runOnUiThread { status.text = "Upload complete. Records sent: ${array.length()}\nAPI: $response" }
      } catch (e: Exception) { runOnUiThread { status.text = "Error: ${e.message}\nCheck laptop IP, Wi-Fi, API and permissions." } }
    }
  }
  private fun postJson(urlString:String, body:String):String { val c=URL(urlString).openConnection() as HttpURLConnection; try { c.requestMethod="POST"; c.connectTimeout=10000; c.readTimeout=15000; c.doOutput=true; c.setRequestProperty("Content-Type","application/json; charset=utf-8"); c.outputStream.use { it.write(body.toByteArray(Charsets.UTF_8)) }; val code=c.responseCode; val stream=if(code in 200..299)c.inputStream else c.errorStream; val response=stream.bufferedReader().use{it.readText()}; if(code !in 200..299) throw IllegalStateException("HTTP $code: $response"); return response } finally { c.disconnect() } }
  override fun onDestroy(){ executor.shutdown(); super.onDestroy() }
}
