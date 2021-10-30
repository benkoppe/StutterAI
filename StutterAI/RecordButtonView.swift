//
//  RecordButtonView.swift
//  StutterAI
//
//  Created by Ben K on 10/5/21.
//

import SwiftUI

struct RecordButtonView: View {
    @Binding var isRecording: Bool
    
    let buttonPress: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height
            
            ZStack {
               Circle()
                    .stroke(Color.white, lineWidth: geo.size.height * (height * 0.0009))
                
                Button {
                    buttonPress()
                    isRecording.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: isRecording ? (height * 0.05) : (height * 0.5))
                            .fill(Color.red)
                            .frame(width: isRecording ? (height * 0.4) : (height * 0.85), height: isRecording ? (height * 0.4) : (height * 0.85))
                            .animation(.easeInOut(duration: 0.3), value: isRecording)
                }
            }
        }
    }
}

struct RecordButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RecordButtonView(isRecording: .constant(false)) {}.preferredColorScheme(.dark)
            .frame(width: 65, height: 65)
    }
}
