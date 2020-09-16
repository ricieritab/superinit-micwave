//
//  AudioSessionManager.swift
//  MicWave
//
//  Created by Felipe Ricieri on 16/09/2020.
//  Copyright © 2020 Kin + Carta Create (Europe). All rights reserved.
//

import Foundation
import AVFoundation

final class AudioSessionManager {
  
  private lazy var audioSession = AVAudioSession.sharedInstance()
  
  // MARK: - Features
  
  func requestPermissionIfNeeded(completion: @escaping () -> Void) {
    audioSession.requestRecordPermission { granted in
      guard granted else {
        fatalError("Please grant the app the microphone permission 🙏")
      }
      DispatchQueue.main.async {
        completion()
      }
    }
  }
  
  func prepareAudioSessionToRecord() throws {
    try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
  }
}
