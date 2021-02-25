//
//  ImagePicker.swift
//  TelemedPatient
//
//  Created by Galieva on 23.12.2020.
//

import SwiftUI
import Photos

struct NamedUIImage: Equatable {
    
    var image: UIImage
    var name: String?
}

struct ImagePicker: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let uiImage = info[.originalImage] as? UIImage else {
                parent.image = nil
                return
            }
            
            var namedImage = NamedUIImage(image: uiImage)
            
            if let asset = info[.phAsset] as? PHAsset {
                if let fileName = asset.value(forKey: "filename") as? String{
                    namedImage.name = fileName
                }
            }
            
            parent.image = namedImage
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: NamedUIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}
