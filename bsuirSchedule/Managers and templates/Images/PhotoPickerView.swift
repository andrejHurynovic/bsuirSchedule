//
//  PhotoPickerView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 31.10.21.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: UIViewControllerRepresentable {
    
    @Binding var images: [UIImage]
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0    //infinity 
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
        let photoPicker: PhotoPickerView
        
        init(photoPicker: PhotoPickerView) {
            self.photoPicker = photoPicker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            photoPicker.isPresented = false
            
            for image in results {
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                        guard let image = image else {
                            print(error as Any)
                            return
                        }
                        DispatchQueue.main.async {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9)) {
                                self.photoPicker.images.append(image as! UIImage)
                            }
                        }
                    })
                }
            }
        }
        
    }

}
