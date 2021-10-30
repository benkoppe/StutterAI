/*
See LICENSE folder for this sample’s licensing information.
*/

import AVFoundation
import Foundation
import Speech
import SwiftUI
import SoundAnalysis

/// A helper for transcribing speech to text using AVAudioEngine.
struct SpeechRecognizer {
    private class SpeechAssist {
        var audioEngine: AVAudioEngine?
        var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
        var recognitionTask: SFSpeechRecognitionTask?
        let speechRecognizer = SFSpeechRecognizer()
        
        var resultsObserver = ResultsObserver()

        deinit {
            reset()
        }

        func reset() {
            recognitionTask?.cancel()
            audioEngine?.stop()
            audioEngine = nil
            recognitionRequest = nil
            recognitionTask = nil
        }
    }

    private let assistant = SpeechAssist()

    /**
        Begin transcribing audio.
     
        Creates a `SFSpeechRecognitionTask` that transcribes speech to text until you call `stopRecording()`.
        The resulting transcription is continuously written to the provided text binding.
     
        -  Parameters:
            - speech: A binding to a string where the transcription is written.
     */
    func record(to speech: Binding<String>) {
        relay(speech, message: "Requesting access")
        canAccess { authorized in
            guard authorized else {
                relay(speech, message: "Access denied")
                return
            }

            relay(speech, message: "Access granted")

            assistant.audioEngine = AVAudioEngine()
            guard let audioEngine = assistant.audioEngine else {
                fatalError("Unable to create audio engine")
            }
            assistant.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = assistant.recognitionRequest else {
                fatalError("Unable to create request")
            }
            recognitionRequest.shouldReportPartialResults = true

            do {
                relay(speech, message: "Booting audio subsystem")

                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                let inputNode = audioEngine.inputNode
                relay(speech, message: "Found input node")

                let inputFormat = inputNode.inputFormat(forBus: 0)
                let recordingFormat = inputNode.outputFormat(forBus: 0)
                
                let soundClassifier = try StutterDetector(configuration: MLModelConfiguration())
                
                let request = try SNClassifySoundRequest(mlModel: soundClassifier.model)
                let analyzer = SNAudioStreamAnalyzer(format: inputFormat)
                try analyzer.add(request, withObserver: assistant.resultsObserver)
                
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                    recognitionRequest.append(buffer)
                    
                    DispatchQueue(label: "com.apple.AnalysisQueue").async {
                        analyzer.analyze(buffer, atAudioFramePosition: when.sampleTime)
                    }
                }
                
                relay(speech, message: "Preparing audio engine")
                audioEngine.prepare()
                try audioEngine.start()
                assistant.recognitionTask = assistant.speechRecognizer?.recognitionTask(with: recognitionRequest) { (result, error) in
                    var isFinal = false
                    if let result = result {
                        relay(speech, message: result.bestTranscription.formattedString)
                        isFinal = result.isFinal
                    }

                    if error != nil || isFinal {
                        audioEngine.stop()
                        inputNode.removeTap(onBus: 0)
                        self.assistant.recognitionRequest = nil
                    }
                }
                relay(speech, message: "")
            } catch {
                print("Error transcibing audio: " + error.localizedDescription)
                assistant.reset()
            }
        }
    }
    
    /// Stop transcribing audio.
    func stopRecording() {
        assistant.reset()
    }
    
    private func canAccess(withHandler handler: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            if status == .authorized {
                AVAudioSession.sharedInstance().requestRecordPermission { authorized in
                    handler(authorized)
                }
            } else {
                handler(false)
            }
        }
    }
    
    private func relay(_ binding: Binding<String>, message: String) {
        DispatchQueue.main.async {
            binding.wrappedValue = message
        }
    }
}
