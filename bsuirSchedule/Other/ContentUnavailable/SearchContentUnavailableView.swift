//
//  SearchContentUnavailableView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 8.06.23.
//

import SwiftUI

struct SearchContentUnavailableView: View {
    var searchText: String
    
    var body: some View {
        ContentUnavailablePlaceholderView(systemName: "magnifyingglass",
                                          title: "По «\(searchText)» ничего не найдено",
                                          subtitle: "Проверьте написание или попробуйте снова.")
    }
}

struct SearchContentUnavailableView_Previews: PreviewProvider {
    static var previews: some View {
        SearchContentUnavailableView(searchText: "Глицевич")
    }
}
