import AVFoundation

/// Simple video recorder placeholder using AVFoundation.
final class VideoRecorder {
    private var session: AVCaptureSession?

    func startRecording() async {
        // TODO: Configure camera and start recording.
        session = AVCaptureSession()
        session?.startRunning()
    }

    func stopRecording() async {
        session?.stopRunning()
    }
}
