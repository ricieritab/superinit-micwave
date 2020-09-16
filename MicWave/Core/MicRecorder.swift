//
//  MicRecorder.swift
//  MicWave
//
//  Created by Felipe Ricieri on 16/09/2020.
//  Copyright © 2020 Kin + Carta Create (Europe). All rights reserved.
//

import Foundation
import AVFoundation

final class MicRecorder {
  
  var onNext: (([Float]) -> Void)?
  
  private var latestSamples: [Float]
  private var currentSample: Int
  private var timer: Timer?
  private var audioRecorder: AVAudioRecorder!
  
  private let monitoringInterval: TimeInterval
  private let numberOfSamples: Int
  private let settings = MicRecorderSettings()
  
  // MARK: - Init
  
  init(numberOfSamples: Int, monitoringInterval: TimeInterval) {
    self.numberOfSamples = numberOfSamples
    self.latestSamples = [Float](repeating: .zero, count: numberOfSamples)
    self.currentSample = 0
    self.monitoringInterval = monitoringInterval
  }
  
  deinit {
      timer?.invalidate()
      audioRecorder.stop()
  }
  
  // MARK: - Features
  
  func prepareToRecord() throws {
    audioRecorder = try AVAudioRecorder(micRecorderSettings: settings)
  }
  
  func start() {
    audioRecorder.isMeteringEnabled = true
    audioRecorder.record()
    
    timer = Timer.scheduledTimer(withTimeInterval: monitoringInterval, repeats: true, block: { [weak self] _ in
      self?.updateState()
    })
  }
  
  func stop() {
    audioRecorder.stop()
  }
  
  // MARK: - Private methods
  
  private func updateState() {
    audioRecorder.updateMeters()
    latestSamples[currentSample] = audioRecorder.averagePower(forChannel: settings.channel)
    currentSample = (currentSample + 1) % numberOfSamples
    
    onNext?(latestSamples)
  }
}

// MARK: - Helpers

private struct MicRecorderSettings {
  let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
  let channel:  Int = 0
  let options: [String: Any] = [
    AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
    AVSampleRateKey: 44200.0,
    AVNumberOfChannelsKey: 1,
    AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
  ]
}

private extension AVAudioRecorder {
  convenience init(micRecorderSettings: MicRecorderSettings) throws {
    try self.init(url: micRecorderSettings.url, settings: micRecorderSettings.options)
  }
}
