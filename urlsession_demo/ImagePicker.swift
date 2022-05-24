//
//  ImagePicker.swift
//  urlsession_demo
//
//  Created by Apple on 20/05/22.
//

import UIKit
import Photos

public protocol ImagePickerDelegate {
    func didSelect(image: UIImage? , videoData: Data?)
}

open class ImagePicker: NSObject {

     let pickerController: UIImagePickerController
     weak var presentationController: UIViewController?
    private var delegate: ImagePickerDelegate?
   // var videoURL: NSURL?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image","public.movie"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

//    public func present() {
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        if let action = self.action(for: .camera, title: "Take photo") {
//            alertController.addAction(action)
//        }
//        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
//            alertController.addAction(action)
//        }
//        if let action = self.action(for: .photoLibrary, title: "Photo library") {
//            alertController.addAction(action)
//        }
//
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        self.presentationController?.present(alertController, animated: true)
//    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage? ) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image, videoData: nil)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker ,didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if self.pickerController.sourceType != .savedPhotosAlbum {
          guard let image = info[.editedImage] as? UIImage else {
              return self.pickerController(picker, didSelect: nil)
          }
          self.pickerController(picker, didSelect: image)
        } else {
            let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            if let url = videoUrl {
              do {
                  let videoData = try Data(contentsOf: url as URL)
                  self.delegate?.didSelect(image: nil, videoData: videoData)
                  pickerController.dismiss(animated: true, completion: nil)
                  return
                 } catch let error {
                     print("error is \(error)")
                 }
            }
            self.pickerController(picker, didSelect: nil)
        }
    }
}
