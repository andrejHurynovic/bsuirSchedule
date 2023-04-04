//
//  SquareView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 03.04.23. (Дзень нараджэння Кірыла).
//

import SwiftUI

struct SquareView: View {
    var title: String
    
    var firstSubtitle: String?
    var secondSubtitle: String?
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(uiColor: .secondarySystemGroupedBackground))
            .aspectRatio(contentMode: .fill)
            .overlay(
                overlay
                , alignment: .topLeading
            )
    }
    
    
    
    var overlay: some View {
        VStack(alignment: .leading) {
            titleText
            Spacer()
            firstSubtitleText
            secondSubtitleText
        }
        .padding()
        .foregroundColor(.primary)
        
        .lineLimit(2)
        .minimumScaleFactor(0.5)
        .multilineTextAlignment(.leading)
    }
    
    
    
    var titleText: some View {
        Text(title)
            .font(.system(.title3,
                          design: .rounded,
                          weight: .bold))
    }
    @ViewBuilder var firstSubtitleText: some View {
        if let firstSubtitle = firstSubtitle {
            Text(firstSubtitle)
        }
    }
    @ViewBuilder var secondSubtitleText: some View {
        if let secondSubtitle = secondSubtitle {
            Text(secondSubtitle)
                .font(.headline)
                .foregroundColor(Color.gray)
        }
    }
    
}
