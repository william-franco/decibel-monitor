package br.com.williamfranco.decibel_monitor

import android.Manifest
import android.content.pm.PackageManager
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {
    private val CHANNEL = "br.com.williamfranco.decibel_monitor/decibel"
    private val PERMISSION_REQUEST_CODE = 1
    private var permissionResult: MethodChannel.Result? = null

    private var isListening = false
    private var audioRecord: AudioRecord? = null
    private val sampleRate = 44100
    private val bufferSize = AudioRecord.getMinBufferSize(
        sampleRate,
        android.media.AudioFormat.CHANNEL_IN_MONO,
        android.media.AudioFormat.ENCODING_PCM_16BIT
    )

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val messenger = flutterEngine?.dartExecutor?.binaryMessenger
            ?: throw IllegalStateException("FlutterEngine is not initialized")

        MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkAndRequestPermission" -> {
                    permissionResult = result
                    checkAndRequestMicrophonePermission()
                }
                "startListening" -> {
                    if (startListening()) {
                        result.success(null)
                    } else {
                        result.error("INIT_ERROR", "Failed to initialize AudioRecord", null)
                    }
                }
                "stopListening" -> {
                    stopListening()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun checkAndRequestMicrophonePermission() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
            == PackageManager.PERMISSION_GRANTED
        ) {
            permissionResult?.success(true)
        } else {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.RECORD_AUDIO),
                PERMISSION_REQUEST_CODE
            )
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQUEST_CODE) {
            val granted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
            permissionResult?.success(granted)
        }
    }

    private fun startListening(): Boolean {
        if (isListening) return true

        if (bufferSize == AudioRecord.ERROR || bufferSize == AudioRecord.ERROR_BAD_VALUE) {
            return false
        }

        audioRecord = AudioRecord(
            MediaRecorder.AudioSource.MIC,
            sampleRate,
            android.media.AudioFormat.CHANNEL_IN_MONO,
            android.media.AudioFormat.ENCODING_PCM_16BIT,
            bufferSize
        )

        if (audioRecord?.state != AudioRecord.STATE_INITIALIZED) {
            return false
        }

        audioRecord?.startRecording()
        isListening = true

        thread {
            val buffer = ShortArray(bufferSize)
            val handler = Handler(Looper.getMainLooper())

            while (isListening) {
                val read = audioRecord?.read(buffer, 0, buffer.size) ?: 0
                if (read > 0) {
                    val rms = buffer.take(read).map { it * it }.average().let { Math.sqrt(it) }
                    
                    val decibels = if (rms > 0.0) {
                        20 * Math.log10(rms / Short.MAX_VALUE)
                    } else {
                        0.0
                    }

                    val safeDecibels = if (decibels.isFinite()) decibels else 0.0

                    handler.post {
                        MethodChannel(
                            flutterEngine?.dartExecutor?.binaryMessenger!!,
                            CHANNEL
                        ).invokeMethod("updateDecibel", safeDecibels)
                    }
                }

                Thread.sleep(100)
            }
        }

        return true
    }

    private fun stopListening() {
        isListening = false
        audioRecord?.stop()
        audioRecord?.release()
        audioRecord = null
    }
}
