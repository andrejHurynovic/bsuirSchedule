//
//  FavoriteGroupView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 27.10.21.
//

import SwiftUI

struct FavoriteGroupView: View {
    var group: Group
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(primaryMaterial())
            .aspectRatio(contentMode: .fill)
            .overlay {
                VStack(alignment: .leading) {
                    Text(group.id)
                        .font(Font.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.primary)
                    Spacer(minLength: 0)
                    Text(group.nickname ?? group.speciality!.abbreviation)
                        .minimumScaleFactor(0.01)
                        .lineLimit(1...2)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.primary)
                    HStack {
                        Text(String(group.speciality!.faculty!.abbreviation!))
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName: String(group.course) + ".circle.fill")
                            .foregroundColor(Color.gray)
                    }
                }
                .padding(14)
            }
        
    }
}
