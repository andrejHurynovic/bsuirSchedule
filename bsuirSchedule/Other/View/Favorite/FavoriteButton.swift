//
//  FavoriteButton.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.04.23.
//

import SwiftUI

struct FavoriteButton<FavoredType: Favored>: View {
    @ObservedObject var item: FavoredType
    var circle: Bool = false
    
    var labelString: String {
        item.favorite ? "Убрать из избранных" : "Добавить в избранные"
    }
    var imageString: String {
        item.favorite ? "star.slash" : "star.fill"
    }
    
    var body: some View {
        Button {
            withAnimation() {
                toggle()
            }
        } label: {
            if circle {
                Label(labelString, systemImage: imageString)
                    .toolbarCircle()
            } else {
                Label(labelString, systemImage: imageString)
            }
        }
    }
    
    func toggle() {
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        
        if let backgroundItem = backgroundContext.object(with: item.objectID) as? FavoredType {
            backgroundItem.favorite.toggle()
            
            backgroundContext.perform {
                try! backgroundContext.save()
            }
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        let auditories: [Auditorium] = Auditorium.getAll()
        
        if let auditorium = auditories.first {
            FavoriteButton(item: auditorium, circle: false)
            FavoriteButton(item: auditorium, circle: true)
            NavigationView {
                Text("")
                    .toolbar {
                        FavoriteButton(item: auditorium, circle: false)
                        FavoriteButton(item: auditorium, circle: true)
                    }
            }
        }
        
    }
}
