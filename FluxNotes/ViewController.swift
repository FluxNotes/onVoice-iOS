//
//  ViewController.swift
//  FluxNotes
//
//  Created by Horn III, Robert E on 8/17/18.
//  Copyright © 2018 Robert Horn. All rights reserved.
//

import UIKit
import AVFoundation
import googleapis

let SAMPLE_RATE = 16000

class ViewController: UIViewController, AudioControllerDelegate {
    
    var audioData: NSMutableData!

    override func viewDidLoad() {
        super.viewDidLoad()
        AudioController.sharedInstance.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    @IBAction func alertClicked(_ sender: UIBarButtonItem) {
        print("clicked")
    }
    
    @IBAction func recordAudio(_ sender: UIBarButtonItem) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
        } catch { }
        
        audioData = NSMutableData()
        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
        SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
        _ = AudioController.sharedInstance.start()
    }
    
    @IBAction func stopAudio(_ sender: Any) {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
    }
    
    // MARK: - Delegate Functions
    func processSampleData(_ data: Data) {
        audioData.append(data)
        
        let chunkSize : Int = Int(0.1
            * Double(SAMPLE_RATE)
            * 2);
        
        if (audioData.length > chunkSize) {
            SpeechRecognitionService.sharedInstance.streamAudioData(audioData) { [weak self](response, error) in
                guard let strongSelf = self else {
                    return
                }
                
                if let error = error {
                    print(error.localizedDescription)
                } else if let response = response {
                    var finished = false
                    for result in response.resultsArray! {
                        if let result = result as? StreamingRecognitionResult {
                            if result.isFinal {
                                finished = true
                                //print(response.description)
                                print(result)
                            }
                        }
                    }
                    if finished {
                        //strongSelf.stopAudio(strongSelf)
                        SpeechRecognitionService.sharedInstance.stopStreaming()
                    }
                }
            }
            self.audioData = NSMutableData()
        }
    }
}

