//
//  NBChat+ImagePicker.swift
//  Nibou
//
//  Created by Himanshu Goyal on 13/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension NBChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentImagePicker(){
        self.checkPermission()
        let alert: UIAlertController = UIAlertController(title: "CHOOSE_IMAGE".localized(), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "CAMERA".localized(), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "GALLERY".localized(), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "CANCEL".localized(), style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Open Camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    //end
    
    //MARK: - Open Gallary
    func openGallary()
    {
        self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    //end
    
    
    private func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        default:
            print("")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var imageLocalURL: String!
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        imageLocalURL = "\(self.roomId)" + "_" + String(Int.random(in: 0 ... 1000))

        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("\(String(describing: imageLocalURL!)).png")
            if let pngImageData = image.pngData() {
                try pngImageData.write(to: fileURL, options: .atomic)
            }
        } catch { }
    
        
        picker.dismiss(animated: true) {
            DispatchQueue.main.async {
                if self.chatModel != nil && self.chatModel.count > 0{
                    self.updateDataBaseWithTempData(chatId: "\(self.chatModel.count + 1)", localId: "\(self.chatModel[0].data.count + 1)", localPathURL: "\(imageLocalURL!.description)")
                }else{
                    self.updateDataBaseWithTempData(chatId: "\(self.roomId)", localId: "\(self.roomId)", localPathURL: "\(imageLocalURL!.description)")
                }
                
            }
            
            var dataArray: [Data] = []
            var fileNameArray: [String] = []
            var paramsArray: [String] = []
            var mineTypeArray: [String] = []
            
            let imageData = image.jpegData(compressionQuality: 0.25)
            dataArray.append(imageData!)
            fileNameArray.append(String(format: "Chat_%@.jpeg", self.roomId))
            paramsArray.append("images[]")
            mineTypeArray.append("image/jpeg")
            
            self.callSendMessageAPi(roomId: self.roomId, fileData: dataArray, fileName: fileNameArray, paramsArray: paramsArray, mineType: mineTypeArray)
            
//            let queue = DispatchQueue(label: "\(self.tempChatModel.data.count)", qos: .background)
//            queue.async {
//
//                var dataArray: [Data] = []
//                var fileNameArray: [String] = []
//                var paramsArray: [String] = []
//                var mineTypeArray: [String] = []
//
//                let imageData = image.jpegData(compressionQuality: 0.25)
//                dataArray.append(imageData!)
//                fileNameArray.append(String(format: "Chat_%@.jpeg", self.roomId))
//                paramsArray.append("images[]")
//                mineTypeArray.append("image/jpeg")
//
//                self.callSendMessageAPi(roomId: self.roomId, fileData: dataArray, fileName: fileNameArray, paramsArray: paramsArray, mineType: mineTypeArray, completion: { (result) in
//                    if result == .Success{
////                        self.tempChatModel.data.remove(at: self.tempChatModel.data.count - 1)
//                    }else{
//
//                    }
//                })
//            }
        }
    }

}

