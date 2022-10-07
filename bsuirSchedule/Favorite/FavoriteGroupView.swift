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
            .fill(.background)
            .aspectRatio(contentMode: .fill)
            .standardisedShadow()
            .overlay {
                VStack(alignment: .leading) {
                    Text(group.id!)
                        .font(Font.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.01)
                        .foregroundColor(Color.primary)
                    Spacer()
                    Text(group.speciality!.abbreviation!)
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
