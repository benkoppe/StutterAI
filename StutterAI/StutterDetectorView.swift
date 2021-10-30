//
//  StutterDetectorView.swift
//  StutterAI
//
//  Created by Ben K on 10/4/21.
//

import SwiftUI

struct StutterDetectorView: View {
    let speechRecognizer = SpeechRecognizer()
    @State private var transcript = ""
    @State private var isRecognizing = false
    
    @State private var isRecording = false
    @State private var isStuttering = false
    @State private var identifier = ""
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        Text("\(Image(systemName: "exclamationmark.triangle")) Stutter Caught")
                            .bold()
                    }
                    .font(.title3)
                    .foregroundColor(.red)
                    .opacity(isStuttering ? 1 : 0.1)
                    .padding(.top)
                    
                    let padding: CGFloat = 10
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.red, lineWidth: 5)
                            .opacity(isStuttering ? 0.5 : 0.1)
                        
                        ScrollView {
                            if !transcript.isEmpty {
                                Text(transcript)
                                    .padding(padding + 5)
                            } else if !isRecording {
                                Text("Press the record button to start.")
                                    .foregroundColor(.secondary)
                                    .padding(padding + 5)
                            } else {
                                Text("Begin speaking to start.")
                                    .foregroundColor(.secondary)
                                    .padding(padding + 5)
                            }
                        }
                    }
                    .padding()
                }
                .padding(.top)
                
                RecordButtonView(isRecording: $isRecording) {
                    toggleRecognizer()
                }
                .frame(height: 60)
                .scaleEffect(0.95)
                .padding()
                .background(Color.secondarySystemBackground)
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("StutterResult"))) { result in
                if let identifier = result.object as? String {
                    self.identifier = identifier
                    
                    if identifier == "NoStutteredWords" {
                        isStuttering = false
                    } else {
                        isStuttering = true
                    }
                }
            }
            .navigationTitle("StutterAI")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func toggleRecognizer() {
        if isRecognizing {
            speechRecognizer.stopRecording()
            isRecognizing = false
        } else {
            speechRecognizer.record(to: $transcript)
            isRecognizing = true
        }
    }
}

struct StutterDetectorView_Previews: PreviewProvider {
    static var previews: some View {
        StutterDetectorView().preferredColorScheme(.dark)
    }
}
