//
//  TrackableScrollView.swift
//  TrackableScrollView
//
//  Created by Huynh Tan Phu on 3/30/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI

struct TrackableScrollView<Content>: View where Content: View {
    let axis: Axis.Set
    let showIndicators: Bool
    @Binding var contentOffset: CGFloat
    let content: Content
    
    init(axis: Axis.Set = .vertical, showIndicators: Bool = true, contentOffset: Binding<CGFloat>, @ViewBuilder content: ()-> Content) {
        
        self.axis = axis
        self.showIndicators = showIndicators
        self._contentOffset = contentOffset
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { outProxy in
            ScrollView(self.axis, showsIndicators: self.showIndicators) {
                GeometryReader { inProxy in
                    ZStack(alignment: self.axis == .vertical ? .top : .leading) {
                        Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: [ScrollOffsetPreferenceData(offset: self.offset(outProxy, inProxy))])
                    }
                }
                VStack {
                    self.content
                }
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { (preferences) in
                self.contentOffset = preferences[0].offset
            }
        }
    }
    
    func offset(_ outProxy: GeometryProxy, _ inProxy: GeometryProxy) -> CGFloat {
        return self.axis == .vertical ?
                inProxy.frame(in: .global).minY - outProxy.frame(in: .global).minY :
                inProxy.frame(in: .global).minX - outProxy.frame(in: .global).minX
    }
    
    
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [ScrollOffsetPreferenceData]
    
    static var defaultValue: [ScrollOffsetPreferenceData] = []
    
    static func reduce(value: inout [ScrollOffsetPreferenceData], nextValue: () -> [ScrollOffsetPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

private struct ScrollOffsetPreferenceData: Equatable {
    let offset: CGFloat
}
