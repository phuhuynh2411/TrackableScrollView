//
//  ContentView.swift
//  TrackableScrollView
//
//  Created by Huynh Tan Phu on 3/30/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var contentOffSet: CGFloat = 0
    
    var body: some View {
        VStack {
            Text("Content offset: \(self.contentOffSet)")
            TrackableScrollView(contentOffset: $contentOffSet) {
            //ScrollView {
                ForEach(0..<100) { index in
                    Text("Item \(index)")
                    .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
