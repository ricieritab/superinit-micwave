//
//  MicViewController.swift
//  MicWave
//
//  Created by Felipe Ricieri on 16/09/2020.
//  Copyright © 2020 Kin + Carta Create (Europe). All rights reserved.
//

import UIKit

final class MicViewController: UIViewController {
  
  private lazy var micSampler = MicSampler(numberOfSamples: 10, monitoringInterval: 0.1)
  
  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: - Private methods
  
  private func setup() {
    micSampler.subscribe { latestSamples in
      print("Latest samples 🎷:", latestSamples)
    }
    
    micSampler.start()
  }
}

