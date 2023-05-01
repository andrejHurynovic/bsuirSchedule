////
////  ImagesViewModel.swift
////  bsuirSchedule
////
////  Created by Andrej Hurynovič on 1.11.21.
////
//
//import SwiftUI
//
//class ImagesViewModel: ObservableObject {
//    @Published var images: [UIImage] = []
//    @Published var selection: UIImage?
//    
//    @Published var isPresented = false
//    
//    @Published var verticalOffset: CGSize = .zero
//    @Published var backgroundOpacity: Double = 0
//    
//    
//    
//    func present(selectedImage: UIImage) {
//        withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.9)) {
//            selection = selectedImage
//            isPresented = true
//            backgroundOpacity = 1
//        }
//    }
//    
//    func onDragChange(value: CGSize) {
//        verticalOffset = value
//
//        let halfScreenHeight = UIScreen.main.bounds.height / 2
//    
//        let progress = verticalOffset.height / halfScreenHeight
//        
//            backgroundOpacity = Double(1 -  abs(progress))
//    }
//    
//    func onDragEnded(value: DragGesture.Value) {
//        //Dissmiss moment
//        if abs(value.translation.height) < UIScreen.main.bounds.height / 5 {
//            withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.9)) {
//                verticalOffset = .zero
//                backgroundOpacity = 1
//            }
//        } else {
//            withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.9)) {
//                isPresented = false
//                verticalOffset = .zero
//                backgroundOpacity = .zero
//            }
//        }
//    }
//    
//}
