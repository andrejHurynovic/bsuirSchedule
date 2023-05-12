//
//  HomeViewGrid.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.04.23.
//

import SwiftUI
import CoreData

struct HomeViewGrid<ItemType: NSManagedObject, ItemViewContent: View, DestinationContent: View>: View {
    var items: [ItemType]
    var gridItem: GridItem = SquareTextView.gridItem
    
    var navigationLinkTitle: String
    var navigationLinkDestination: DestinationContent
    
    var itemView: (ItemType) -> ItemViewContent
    
    var body: some View {
        LazyVGrid(columns: [gridItem],
                  alignment: .leading,
                  spacing: 8) {
            Section {
                ForEach(items, id: \.self) { item in
                    itemView(item)
                }
            } header: {
                NavigationLink(destination: navigationLinkDestination) {
                    HeaderView(navigationLinkTitle, withArrow: true)
                }
            }
        }
                  .padding(.horizontal)
    }
    
}

//struct HomeViewGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeViewGrid(items: <#[NSManagedObject]#>,
//                     navigationLinkTitle: <#String#>,
//                     navigationLinkDestination: <#_#>,
//                     itemView: <#(NSManagedObject) -> _#>)
//    }
//}
