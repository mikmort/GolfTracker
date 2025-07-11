# GolfTracker

An experimental iOS app that records golf shots and predicts ball flight.

## Features

- Connects to the Foresight GCQuad launch monitor (placeholder implementation).
- Records the GPS location of each shot using CoreLocation.
- Retrieves real-time wind information from the Open-Meteo API.
- Predicts the landing position of the ball using the GCQuad carry distance and
  a simple wind adjustment.
- Allows video recording of the swing using AVFoundation.

This project is structured as a Swift Package so it can be developed in VS Code.
Open the folder in VS Code with the Swift extension installed. Xcode can also be
used for running on device or simulator.

## Building

```bash
swift build
```

Running the package on macOS or iOS will launch the simple command-line app that
performs a single shot capture cycle.
