//
//  SectionIndexesView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.06.23.
//

import SwiftUI

struct SectionIndexesView: View {
    var titles: [String]
    
    @Binding var scrollTargetID: String
    
    var body: some View {
        GeometryReader { geometryProxy in
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    content(geometryProxy: geometryProxy)
                    Spacer()
                }
                
            }
            
        }
    }
    
    private func content(geometryProxy: GeometryProxy) -> some View {
        let letterHeight = (UIFont.preferredFont(forTextStyle: .caption1).pointSize)
        let spacing: CGFloat = 2.2
        let titleHeight = letterHeight + spacing
        
        let geometryHeight = geometryProxy.size.height - 90
        
        let (reducedTitles, numberOfChunks) = reducedTitles(geometryHeight: geometryHeight,
                                          titleHeight: titleHeight)
        
        return VStack(spacing: 0) {
            
            ForEach(reducedTitles, id: \.self) { title in
                Text(title)
                    .bold()
                    .font(.caption)
                    .foregroundColor(.accentColor)
            }
        }
        
        .highPriorityGesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged({ value in
                    onDragGesture(numberOfChunks: numberOfChunks,
                                  titleHeight: titleHeight,
                                  value: value)
                })
        )
    }
    
    private func reducedTitles(geometryHeight: CGFloat,
                               titleHeight: CGFloat) -> (reducedTitles: [String], numberOfChunks: Int) {
        let maximalNumberOfTitles = Int(geometryHeight / titleHeight)
        
        guard titles.count > maximalNumberOfTitles else { return (self.titles, 1) }
        let numberOfChunks = titles.count / maximalNumberOfTitles
        var reducedTitles = titles.chunked(into: numberOfChunks)
            .map { $0.first! }
        
        for index in reducedTitles.indices.filter ({ $0 % 2 == 1 }) {
            reducedTitles[index] = "●"
        }
        
        return (reducedTitles,
                numberOfChunks)
        
    }
    
    private func onDragGesture(numberOfChunks: Int,
                               titleHeight: CGFloat,
                               value: DragGesture.Value) {
        
        let titleHeight = titleHeight / CGFloat(numberOfChunks)
        
        let locationHeight = value.location.y
        let position = Int(locationHeight / titleHeight)
        
        guard position >= 0 else {
            scrollTargetID = titles.first ?? ""
            return
        }
        
        guard titles.count > position else {
            scrollTargetID = titles.last ?? ""
            return
        }
        scrollTargetID = titles[position]
    }
    
}

struct SectionIndexesView_Previews: PreviewProvider {
    static var previews: some View {
        SectionIndexesView(titles: Constants.alphabet, scrollTargetID: .constant(""))
    }
}
