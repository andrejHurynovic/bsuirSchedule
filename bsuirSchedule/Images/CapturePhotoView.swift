//
//  CapturePhotoView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 2.11.21.
//

import SwiftUI

struct CapturePhotoView: UIViewControllerRepresentable {
    
    @Binding var images: [UIImage]
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(CapturePhotoView: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let capturePhotoView: CapturePhotoView
        
        init(CapturePhotoView: CapturePhotoView) {
            self.capturePhotoView = CapturePhotoView
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                DispatchQueue.main.async {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9)) {
                        self.capturePhotoView.images.append(image)
                    }
                }
            } else {
                
            }
            picker.dismiss(animated: true)
        }
    }
    
}
