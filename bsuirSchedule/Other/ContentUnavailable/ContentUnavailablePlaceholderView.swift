//
//  ContentUnavailablePlaceholderView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 8.06.23.
//

import SwiftUI

struct ContentUnavailablePlaceholderView: View {
    var systemName: String
    var title: String
    var subtitle: String?
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: systemName)
                .padding(.bottom)
                .foregroundColor(Color.gray)
                .imageScale(.large)
                .font(.largeTitle)
                .bold()
            
            Text(title)
                .font(.title2)
                .bold()
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
        }
        
        .multilineTextAlignment(.center)
        
    }
}

struct ContentUnavailablePlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        ContentUnavailablePlaceholderView(systemName: "magnifyingglass",
                                          title: "No Results for Async Await",
                                          subtitle: "Check the spelling or try a new search")
    }
}
