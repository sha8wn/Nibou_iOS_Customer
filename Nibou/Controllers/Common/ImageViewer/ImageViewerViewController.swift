//
//  ImageViewerViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 18/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import SDWebImage

enum ImageType{
    case url
    case local
}

class ImageViewerViewController: UIViewController {

    @IBOutlet weak var imageView    : UIImageView!
    @IBOutlet weak var btnClose     : UIButton!
    var imageUrl                    : String = ""
    var localImageName              : String = ""
    var imageType                   : ImageType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.imageType == .local{
            if let image = self.getImageFromDirectory("\(localImageName)"){
                self.imageView.image = image
            }else{
                
            }
        }else{
            self.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            self.imageView.sd_setShowActivityIndicatorView(true)
//            self.imageView.sd_setIndicatorStyle(.gray)
            if self.imageUrl != ""{
                self.imageView.sd_setImage(with: URL(string: self.imageUrl), completed: nil)
            }else{

            }
        }
    }
    
    func getImageFromDirectory (_ imageName: String) -> UIImage? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(String(describing: imageName)).png").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)
        }
        return nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

}
