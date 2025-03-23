//
//  MosaicPattern.swift
//  Count
//
//  Created by AI on 2/19/25.
//

import SwiftUI

struct MosaicPattern: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) / 4
            
            VStack(spacing: 0) {
                ForEach(0..<4) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<4) { column in
                            Rectangle()
                                .fill((row + column) % 2 == 0 ? Color.white.opacity(0.7) : Color.white.opacity(0.3))
                                .frame(width: size, height: size)
                        }
                    }
                }
            }
            .clipShape(Circle())
        }
    }
}

#Preview {
    MosaicPattern()
        .frame(width: 100, height: 100)
        .background(Color.blue)
}