//
//  SectionsSquareGrid.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.04.23.
//

import SwiftUI
import CoreData

struct SectionsSquareGrid<ItemType: NSManagedObject, Content: View>: View {
    
    var sections: [NSManagedObjectsSection<ItemType>]
    @ViewBuilder var content: (ItemType) -> Content
    
    var body: some View {
        
        SquareGrid {
            ForEach(sections, id: \.id) { section in
                Section {
                    ForEach(section.items, id: \.self) { item in
                        content(item)
                    }
                } header: {
                    HeaderView(section.title)
                }
            }
        }
        
    }
}

struct SquareGrid<Content: View>: View {
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        LazyVGrid(columns: [SquareView.gridItem],
                  alignment: .leading,
                  spacing: 8) {
            content()
        }
        
    }
}
