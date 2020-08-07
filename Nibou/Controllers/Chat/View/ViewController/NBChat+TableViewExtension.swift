//
//  NBChat+TableViewExtension.swift
//  Nibou
//
//  Created by Himanshu Goyal on 11/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Alamofire

//MARK: - TableView Extension
extension NBChatVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.chatModel != nil && self.chatModel.count > 0{
            let listModel: List<ChatData> = self.chatModel[0].data
            return listModel.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.chatModel != nil && self.chatModel.count > 0{
            let listModel: List<ChatData> = self.chatModel[0].data
            let model: ChatData! = listModel[section]
            if model.showHeader == true{
                return 80
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.chatModel != nil && self.chatModel.count > 0{
            let listModel: List<ChatData> = self.chatModel[0].data
            let model: ChatData! = listModel[section]
            if model.showHeader == true{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NBTimeTableCell") as! NBTimeTableCell
                let strDate = model.timeStamp
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let date = dateFormatter.date(from: strDate)
                if model.showHeaderForToday{
                    cell.lbl_time.text = "\(convertDateFormater(date: date!, format: "EEEE, HH:mm"))"
                }else{
                    cell.lbl_time.text = "\(convertDateFormater(date: date!, format: "EEEE, dd MMM"))"
                }
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                return cell
            }
        }else{
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.table_view.separatorColor = UIColor.clear
        self.table_view.tableFooterView = UIView()
        
        if self.chatModel != nil && self.chatModel.count > 0{
            let listModel: List<ChatData> = self.chatModel[0].data
            let model: ChatData! = listModel[indexPath.section]
            if "\(model.fromUserId)" == getLoggedInUserId(){
                if model.message != ""{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NBRightMessageTableCell", for: indexPath) as! NBRightMessageTableCell
                    cell.lbl_text.text = model.message
                    
                    cell.lblTime.text = getTimeForMessage(time: model.timeStamp)
                    
                    if model.localId == ""{
                        cell.activityIndicator.stopAnimating()
                        cell.activityIndicator.isHidden = true
                    }else{
                        cell.activityIndicator.startAnimating()
                        cell.activityIndicator.isHidden = false
                    }
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NBRightImageTableViewCell", for: indexPath) as! NBRightImageTableViewCell
                    cell.lblTime.text = getTimeForMessage(time: model.timeStamp)
                    if model.localImageUrl != ""{
                        cell.button.setImage(nil, for: .normal)
                        if let image = self.getImageFromDirectory("\(model.localImageUrl)"){
                            cell.imgView.image = image
                        }else{
                            
                        }
                    }else{
                        cell.setUpCell(imageURL: model.imageUrl, isDownloaded: false, indexPath: indexPath)
                    }
                    cell.button.tag = indexPath.section
                    cell.button.addTarget(self, action: #selector(btnImageTapped(sender:)), for: .touchUpInside)
                    return cell
                }
            }else{
                if model.message != ""{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NBLeftMessageTableCell", for: indexPath) as! NBLeftMessageTableCell
                    cell.lbl_text.text = model.message
                    cell.lblTime.text = getTimeForMessage(time: model.timeStamp)
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NBLeftImageTableViewCell", for: indexPath) as! NBLeftImageTableViewCell
                    if model.localImageUrl != ""{
                        cell.button.setImage(nil, for: .normal)
                        if let image = self.getImageFromDirectory("\(model.localImageUrl)"){
                            cell.imgView.image = image
                        }else{
                            
                        }
                    }else{
                        cell.setUpCell(imageURL: model.imageUrl, isDownloaded: false, indexPath: indexPath)
                    }
                    cell.lblTime.text = getTimeForMessage(time: model.timeStamp)
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.isHidden = true
                    cell.button.tag = indexPath.section
                    cell.button.addTarget(self, action: #selector(btnImageTapped(sender:)), for: .touchUpInside)
                    return cell
                }
            }
        }else{
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    @objc func btnImageTapped(sender: UIButton){
        if self.chatModel != nil && self.chatModel.count > 0{
            let listModel: List<ChatData> = self.chatModel[0].data
            let model: ChatData! = listModel[sender.tag]
            if model.localImageUrl == ""{
                let imageFileName = "\(self.roomId)" + "_" + String(Int.random(in: 0 ... 1000)) as NSString
                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    documentsURL.appendPathComponent("\(imageFileName).png")
                    return (documentsURL, [.removePreviousFile])
                }
                let imageUrl = kBaseURL + model.imageUrl
                Alamofire.download(imageUrl, to: destination).response { response in
                    if response.destinationURL != nil {
                        let mainModel = self.relamDB.objects(ChatModel.self).filter("roomId = %@", self.roomId)
                        let dataModel = mainModel[0].data.filter("chatId = %@", "\(model.chatId)")
                        if let dataModel = dataModel.first{
                            try! self.relamDB.write {
                                dataModel.localId = ""
                                dataModel.localImageUrl = imageFileName as String
                            }
                        }
                        self.chatModel = self.getDataFromDatabase(roomId: self.roomId)
                        self.table_view.reloadSections([sender.tag], with: .none)
                    }
                }
            }else{
                let imageViewer = commonStoryboard.instantiateViewController(withIdentifier: "ImageViewerViewController") as! ImageViewerViewController
                imageViewer.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                if model.localImageUrl != ""{
                    imageViewer.imageType = .local
                    imageViewer.localImageName = model.localImageUrl
                }else{
                    imageViewer.imageType = .url
                    imageViewer.imageUrl = model.imageUrl
                }
                self.present(imageViewer, animated: false, completion: nil)
            }
        }else{
            
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
    
    func getTimeForMessage(time: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let date = dateFormatter.date(from: time)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm"
        dateFormatter1.locale = .current
        dateFormatter1.timeZone = .current
        let date1 = dateFormatter1.string(from: date ?? Date())
        return date1
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        let date = dateFormatter.date(from: time)
//        return "\(convertDateFormater(date: date ?? Date(), format: "HH:mm"))"
    }
}



