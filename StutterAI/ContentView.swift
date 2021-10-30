//
//  ContentView.swift
//  StutterAI
//
//  Created by Ben K on 10/4/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        StutterDetectorView()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
