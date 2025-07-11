import AVFoundation

@MainActor
/// Records video of the golf swing using ``AVFoundation``. This basic
/// implementation configures the default camera and writes a single movie file
/// to the temporary directory.
final class VideoRecorder: NSObject, AVCaptureFileOutputRecordingDelegate {
    private let session = AVCaptureSession()
    private let movieOutput = AVCaptureMovieFileOutput()
    private var outputURL: URL?

    /// Sets up the capture session and begins recording to a temporary file.
    func startRecording() async {
        guard session.inputs.isEmpty else { return }

        // Acquire the default video device.
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input),
              session.canAddOutput(movieOutput) else {
            print("Video recording setup failed")
            return
        }

        session.beginConfiguration()
        session.addInput(input)
        session.addOutput(movieOutput)
        session.commitConfiguration()

        session.startRunning()

        let url = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("golfshot.mov")
        outputURL = url
        movieOutput.startRecording(to: url, recordingDelegate: self)
    }

    /// Stops recording and ends the capture session.
    func stopRecording() async {
        if movieOutput.isRecording {
            movieOutput.stopRecording()
        }
        session.stopRunning()
    }

    // MARK: - AVCaptureFileOutputRecordingDelegate

    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        if let error = error {
            print("Recording error: \(error)")
        } else {
            print("Saved video to \(outputFileURL.path)")
        }
    }
}
