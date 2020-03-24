//
//  SwiftUI Speech.swift
//  Speech to Text
//
//  Created by Joel Joseph on 3/22/20.
//  Copyright © 2020 Joel Joseph. All rights reserved.
//

import Speech
import SwiftUI
import Foundation

public class SwiftUISpeech: ObservableObject{
    init(){
        
        //Requests auth from User
        SFSpeechRecognizer.requestAuthorization{ authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                    case .authorized:
                        break

                    case .denied:
                        break
                    
                    case .restricted:
                        break
                      
                    case .notDetermined:
                        break
                      
                    default:
                        break
                }
            }
        }// end of auth request
        
        recognitionTask?.cancel()
        self.recognitionTask = nil

    }
    
    func showStatus()-> some View{
        
        if(self.getSpeechStatus() == "Authorized"){// If the user Accepts the promt
            let text = Text("\(self.getSpeechStatus())")
                .foregroundColor(.green)
                .padding(.top, 15)
            return text
        }
        if(self.getSpeechStatus() == "Not yet Determined"){// if for some reason the pop up failed
            let text = Text("\(self.getSpeechStatus())")
                .foregroundColor(.yellow)
                .padding(.top, 15)
            return text
        }
        if(self.getSpeechStatus() == "Denied - Close the App"){// if the user denies access
            let text = Text("\(self.getSpeechStatus())")
                .foregroundColor(.red)
                .padding(.top, 15)
            return text
        }
        if(self.getSpeechStatus() == "Restricted - Close the App"){// if the user denies access
            let text = Text("\(self.getSpeechStatus())")
                .foregroundColor(.yellow)
                .padding(.top, 15)
            return text
        }
        if(self.getSpeechStatus() == "ERROR: No Status Defined"){// if the user denies access
            let text = Text("\(self.getSpeechStatus())")
                .foregroundColor(.red)
                .padding(.top, 15)
            return text
        }
        return Text("ERROR").foregroundColor(.red).padding(.top,15)
        
    }
    
    func getButton()->SpeechButton{
        return button
    }// gets the button
    
    func startRecording(){
        
        // restarts the text
        outputText = "";
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        let inputNode = audioEngine.inputNode
        
        // try catch to start audio session
        do{
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        }catch{
            print("ERROR: - Audio Session Failed!")
        }
        
        // Configure the microphone input and request auth
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do{
            try audioEngine.start()
        }catch{
            print("ERROR: - Audio Engine failed to start")
        }
        
        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Create a recognition task for the speech recognition session.
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest){ result, error in
            if (result != nil){
                self.outputText = (result?.transcriptions[0].formattedString)!
            }
            if let result = result{
                // Update the text view with the results.
                self.outputText = result.transcriptions[0].formattedString
            }
            if error != nil {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
            }
        }
    }
    
    func stopRecording(){// end recording
        
        audioEngine.stop()
        recognitionRequest?.endAudio()
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.recognitionTask?.cancel()
        self.recognitionTask = nil
        
    }// restarts the variables
    
    
    func getSpeechStatus()->String{// gets the status of authorization
        
        switch authStat{
            
            case .authorized:
                return "Authorized"
            
            case .notDetermined:
                return "Not yet Determined"
            
            case .denied:
                return "Denied - Close the App"
            
            case .restricted:
                return "Restricted - Close the App"
            
            default:
                return "ERROR: No Status Defined"
    
        }// end of switch
        
    }// end of get speech status
    
    @Published var isRecording:Bool = false
    @Published var button = SpeechButton()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private let authStat = SFSpeechRecognizer.authorizationStatus()
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    public var outputText:String = "";
    
    
}
