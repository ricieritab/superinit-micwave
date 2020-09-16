//
//  MicSampler.swift
//  MicWave
//
//  Created by Felipe Ricieri on 16/09/2020.
//  Copyright © 2020 Kin + Carta Create (Europe). All rights reserved.
//

import Foundation
import AVFoundation

final class MicSampler {
  
  private let audioSessionManager: AudioSessionManager
  private let micRecorder: MicRecorder
  
  // MARK: - Init
  
  init(numberOfSamples: Int = 10, monitoringInterval: TimeInterval = 1) {
    self.audioSessionManager = AudioSessionManager()
    self.micRecorder = MicRecorder(numberOfSamples: numberOfSamples, monitoringInterval: monitoringInterval)
  }
  
  deinit {
    micRecorder.stop()
  }
  
  // MARK: - Features
  
  func start() {
    audioSessionManager.requestPermissionIfNeeded { [weak self] in
      self?.startRecording()
    }
  }
  
  func subscribe(onNext: @escaping ([Float]) -> Void) {
    micRecorder.onNext = onNext
  }
  
  // MARK: - Private methods
  
  private func startRecording() {
    do {
      try micRecorder.prepareToRecord()
      try audioSessionManager.prepareAudioSessionToRecord()
      micRecorder.start()
    } catch let error {
      fatalError("😬 Oops - \(error.localizedDescription)")
    }
  }
}
