//
//  PlayerView.swift
//  SwiftUI-Data-Flow
//
//  Created by 이준복 on 7/22/24.
//

import SwiftUI

struct PlayerViewByState: View {
    @State private var isPlaying: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: isPlaying ? "play.circle" : "pause.circle")
                .resizable()
                .frame(width: 100, height: 100)
            PlayButtonByBinding(isPlaying: $isPlaying)
                .font(.system(size: 30))
                .foregroundStyle(.tint)
        }
    }
}

struct PlayButtonByBinding: View {
    @Binding var isPlaying: Bool
    
    var body: some View {
        Button(isPlaying ? "Pasue" : "Play") {
            isPlaying.toggle()
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    PlayerViewByState()
}
