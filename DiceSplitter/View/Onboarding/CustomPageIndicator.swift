//
//  CustomPageIndicator.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct CustomPageIndicator: View {
    @Binding var currentPage: Int
    let pageCount: Int
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<pageCount, id: \.self) { index in
                Capsule()
                    .fill(currentPage == index ? ColorTheme.primary : ColorTheme.tertiaryText)
                    .frame(width: currentPage == index ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: currentPage)
            }
        }
    }
}

#Preview {
    CustomPageIndicator(currentPage: .constant(2), pageCount: 6)
}
