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
        guard session.inputs.isEmpty else { 
            print("Video session already configured")
            return 
        }

        // Check camera authorization status first
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .notDetermined:
            print("Camera authorization not determined, requesting access...")
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if !granted {
                print("Camera access denied by user")
                return
            }
        case .denied, .restricted:
            print("Camera access denied or restricted")
            return
        case .authorized:
            break
        @unknown default:
            print("Unknown camera authorization status")
            return
        }

        // Acquire the default video device.
        guard let device = AVCaptureDevice.default(for: .video) else {
            print("No video device available")
            return
        }
        
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            print("Failed to create video device input")
            return
        }
        
        guard session.canAddInput(input) else {
            print("Cannot add video input to session")
            return
        }
        
        guard session.canAddOutput(movieOutput) else {
            print("Cannot add movie output to session")
            return
        }

        session.beginConfiguration()
        session.addInput(input)
        session.addOutput(movieOutput)
        session.commitConfiguration()

        // Check if session can start running
        if !session.isRunning {
            session.startRunning()
        }
        
        // Verify session is actually running before starting recording
        guard session.isRunning else {
            print("Failed to start capture session")
            return
        }

        let url = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("golfshot.mov")
        outputURL = url
        
        // Additional safety check before starting recording
        guard !movieOutput.isRecording else {
            print("Movie output is already recording")
            return
        }
        
        movieOutput.startRecording(to: url, recordingDelegate: self)
        print("Started video recording to \(url.path)")
    }

    /// Stops recording and ends the capture session.
    func stopRecording() async {
        if movieOutput.isRecording {
            print("Stopping video recording...")
            movieOutput.stopRecording()
        } else {
            print("No active recording to stop")
        }
        
        if session.isRunning {
            session.stopRunning()
            print("Capture session stopped")
        }
    }

    // MARK: - AVCaptureFileOutputRecordingDelegate

    nonisolated func fileOutput(_ output: AVCaptureFileOutput,
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
