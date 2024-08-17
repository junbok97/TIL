//
//  ContentView.swift
//  SwiftUI-Data-Flow
//
//  Created by 이준복 on 7/22/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            PlayerViewByState()
            PlayerView()
        }
    }
}

#Preview {
    ContentView()
}
