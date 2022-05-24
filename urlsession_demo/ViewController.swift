//
//  ViewController.swift
//  urlsession_demo
//
//  Created by Apple on 20/05/22.
//

import UIKit
//import MobileCoreServices
//import Photos
//import AVFAudio
//import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    // MARK: Outlets and varibles
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var lblSeletedType: UILabel!
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    // MARK: Button Actions
    @IBAction func actionSheetAction(_ sender: UIButton) {
        self.openActionSheet(sender)
    }
        
    func openActionSheet(_ sender: UIButton) {
        let alert = UIAlertController(title: "Title", message: "Please select an option to upload", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Audio", style: .default , handler:{ (UIAlertAction)in
            print("User click Audio button")
           // self.selectSongs(sender)
            self.openAudio()
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            print("User click Camera button")
           if UIImagePickerController.isSourceTypeAvailable(.camera) {
               self.imagePicker.pickerController.sourceType = .camera
            } else {
                self.imagePicker.pickerController.sourceType = .photoLibrary
            }
            self.imagePicker.presentationController?.present(self.imagePicker.pickerController, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Document", style: .default, handler:{ (UIAlertAction)in
            print("User click Document button")
            self.openDocument()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            print("User click Gallery button")
            self.imagePicker.pickerController.sourceType = .photoLibrary
            self.imagePicker.presentationController?.present(self.imagePicker.pickerController, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Video", style: .default , handler:{ (UIAlertAction)in
            print("User click Video button")
            self.imagePicker.pickerController.sourceType = .savedPhotosAlbum
            self.imagePicker.presentationController?.present(self.imagePicker.pickerController, animated: true)
        }))
                
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
                
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController:  ImagePickerDelegate {
    func didSelect(image: UIImage?, videoData: Data?) {
        if image != nil {
            self.imageView.image = image
            self.apiCalling(data: (image?.pngData())!)
        } else if videoData != nil {
            self.apiCalling(data: videoData!)
        } else {
            print("Image and videoData is nil")
        }
    }
}

// MARK: UIDocumentPickerDelegate
extension ViewController : UIDocumentPickerDelegate {
    
    func openDocument() {
        var documentPicker: UIDocumentPickerViewController!
                 if #available(iOS 14, *) {
                     let supportedTypes: [UTType] = [UTType.data]
                     documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
                 } else {
                     let supportedTypes: [String] = ["public.item"] //[kUTTypeImage as String]
                     documentPicker = UIDocumentPickerViewController(documentTypes: supportedTypes, in: .import)
                 }
                 documentPicker.delegate = self
                 documentPicker.allowsMultipleSelection = true
                 documentPicker.modalPresentationStyle = .formSheet
                 self.present(documentPicker, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        do {
        let fileData = try Data.init(contentsOf: URL(fileURLWithPath: urls.first?.path ?? "abc"))
            self.apiCalling(data: fileData)
        }catch{
            print("unable to get document path")
        }
    }
}

// MARK: Api calling
extension ViewController: WebserviceDelegate {
    
    func apiCalling(data: Data) {
        let param: [String:Any] = [
            "habit_type": "group",
            "name": "group habit test 1",
            "color_theme": "red",
            "description": "group description",
            "days": "tuesday,wednesday",
            "icon": "sports",
            "timer":"1638440460.0",
            "reminders": true
    ]
        WebserviceManager.shared.multipartRequest(url: "https://9b58-223-236-31-234.ngrok.io/api/v1/habits/add_habit", imageName: "clips[]", imageData: [data], keyForImage: "clips[]", parameters: param, delegate: self) { httpStatus, response in
            print(response?.description ?? "")
        } onFailure: { httpStatus, response in
            print(response?.description ?? "")
        }
    }
    
    func didGetUploadPercent(_ percent: Float) {
       print("percent is \(percent)")
    }
}

// MARK: Audio picker
extension ViewController: MPMediaPickerControllerDelegate {
    
    
    func openAudio() {
        var documentPicker: UIDocumentPickerViewController!
                 if #available(iOS 14, *) {
                     let supportedTypes: [UTType] = [UTType.audio]
                     documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
                 } else {
                     let supportedTypes: [String] = ["public.item"] //[kUTTypeImage as String]
                     documentPicker = UIDocumentPickerViewController(documentTypes: supportedTypes, in: .import)
                 }
                 documentPicker.delegate = self
                 documentPicker.allowsMultipleSelection = true
                 documentPicker.modalPresentationStyle = .formSheet
                 self.present(documentPicker, animated: true)
    }
    
     func selectSongs(_ sender: UIButton) {
         self.dismiss(animated: false)
         let controller = MPMediaPickerController(mediaTypes: .any)
        controller.allowsPickingMultipleItems = true
        controller.popoverPresentationController?.sourceView = sender
        controller.delegate = self
         self.navigationController?.present(controller, animated: true)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController,
                     didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        musicPlayer.setQueue(with: mediaItemCollection)
        mediaPicker.dismiss(animated: true)
        musicPlayer.play()
    }

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true)
    }
}
