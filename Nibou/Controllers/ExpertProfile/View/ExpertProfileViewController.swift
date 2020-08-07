//
//  ExpertProfileViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

enum ExpertProfileOpenFrom{
    case chat
    case survey
}

class ExpertProfileViewController: BaseViewController {

    
    //MARK: - Properties
    @IBOutlet weak var btnContinueHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnContinue  : UIButton!
    @IBOutlet weak var tableView    : UITableView!
    var isProfileOpenFrom           : ExpertProfileOpenFrom!
    var profileModel                : ExpertProfileModel!
    var selectedSuverArray          : [String]                  = []
    var pdfURL                      : String                    = ""
    var isOpenFrom                  : SurveyOpenFrom!
    var roomId                      : String!                   = ""
    var expertProfileDict           : NSDictionary!
    var arrayReview                 : [Reviews]                 = []
    var arrayLanguage               : [String]                  = []
    var arrayExpertises             : [String]                  = []
    var arrayTimings                : [Timings]                 = []
    var isExpertFound               : Bool                      = true
    var isError                     : Bool                      = false
    //end
    
    
    //MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.callGetExpertProfileDataAPI(expertId: self.profileModel.data!.id ?? "")
        // Do any additional setup after loading the view.
    }

    //MARK: - Set Up View
    /**
      - This function is used to configure View
     */
    func setup(){
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: "ExpertProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpertProfileTableViewCell")
        self.tableView.register(UINib(nibName: "ExpertDataTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpertDataTableViewCell")
        self.tableView.register(UINib(nibName: "TextWithButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "TextWithButtonTableViewCell")
        if self.isProfileOpenFrom == .chat{
            self.btnContinue.isHidden = true
            self.btnContinueHeightConstraint.constant = -20
        }else{
            self.btnContinue.isHidden = false
            self.btnContinueHeightConstraint.constant = 44
        }
        self.btnContinue.setTitle("CONTINUE".localized(), for: .normal)
    }
    //end

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnContinueTapped(_ sender: Any) {
        if self.profileModel != nil{
            if self.isOpenFrom == .switchExpert{
                let viewController = surveyStoryboard.instantiateViewController(withIdentifier: "CopyExpertChatViewController") as! CopyExpertChatViewController
                viewController.roomId = self.roomId
                viewController.expertId = self.profileModel.data!.id ?? ""
                viewController.isComeFrom = .switchExpert
                self.navigationController?.pushViewController(viewController, animated: true)
            }else{
                if getChatRoomCreatedFirstTime() == true{
                    let viewController = surveyStoryboard.instantiateViewController(withIdentifier: "CopyExpertChatViewController") as! CopyExpertChatViewController
                    viewController.expertId = self.profileModel.data!.id ?? ""
                    viewController.selectedSuverArray = self.selectedSuverArray
                    viewController.isComeFrom = .other
                    self.navigationController?.pushViewController(viewController, animated: true)
                }else{
                    self.callChatSessionApi(expertId: self.profileModel.data!.id ?? "", arrayExtersie: self.selectedSuverArray)
                }
            }
        }
    }
}


// MARK: - Extension of UITableView Delegate and DataSource
extension ExpertProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.expertProfileDict != nil{
            return 5
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ExpertProfileTableViewCell", for: indexPath) as! ExpertProfileTableViewCell
            cell.btnOpenPdf.addTarget(self, action: #selector(openPdfViewer), for: .touchUpInside)
//            if self.isProfileOpenFrom == .chat{
//                cell.btnBack.isHidden = false
//            }else{
//                cell.btnBack.isHidden = true
//            }
            cell.btnBack.addTarget(self, action: #selector(btnBackTapped(_:)), for: .touchUpInside)
            
            if self.profileModel != nil{
                if let pdfDict = self.profileModel.data!.attributes!.pdf{
                    if let url = pdfDict.url{
                        self.pdfURL = kBaseURL + url
                        cell.btnOpenPdf.isHidden = false
                    }else{
                        self.pdfURL = ""
                        cell.btnOpenPdf.isHidden = true
                    }
                }else{
                    self.pdfURL = ""
                    cell.btnOpenPdf.isHidden = true
                }
                cell.setupCellWithData(model: self.profileModel)
            }
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ExpertDataTableViewCell", for: indexPath) as! ExpertDataTableViewCell
            cell.lblTitle.text = "TIMINGS_HEADER".localized()
            cell.cellType = .timings
            cell.timingArray = self.arrayTimings
            cell.collectionLeadingConstraint.constant = 20
            cell.btnViewAll.isHidden = true
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            return cell
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ExpertDataTableViewCell", for: indexPath) as! ExpertDataTableViewCell
            cell.lblTitle.text = "FOCUS_HEADER".localized()
            cell.cellType = .normal
            cell.dataArray = self.arrayExpertises
            cell.collectionLeadingConstraint.constant = 20
            cell.btnViewAll.isHidden = true
            cell.setupCell()
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            return cell
        }else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ExpertDataTableViewCell", for: indexPath) as! ExpertDataTableViewCell
            cell.lblTitle.text = "LANGUAGES_HEADER".localized()
            cell.cellType = .normal
            cell.dataArray = self.arrayLanguage
            cell.collectionLeadingConstraint.constant = 20
            cell.btnViewAll.isHidden = true
            cell.setupCell()
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ExpertDataTableViewCell", for: indexPath) as! ExpertDataTableViewCell
            cell.lblTitle.text = "REVIEWS_HEADER".localized()
            cell.cellType = .review
            cell.reviewArray = self.arrayReview
            cell.collectionLeadingConstraint.constant = 0
            cell.btnViewAll.isHidden = false
            cell.btnViewAll.setTitle("VIEW_ALL".localized(), for: .normal)
            cell.setupCell()
            cell.reviewDelegate = self
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            return cell
        }
    }
    
    @objc
    func openPdfViewer(){
        self.openWebView(urlString: self.pdfURL)
    }
    
    @objc
    func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension ExpertProfileViewController: AlertDelegate{
    func alertOkTapped() {
        if self.isExpertFound == false{
            self.isExpertFound = true
            self.navigationController?.popViewController(animated: true)
        }else if self.isError == true{
            self.isError = false
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension ExpertProfileViewController: ReviewTappedDelegate{
    func reviewTapped(){
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "NBRatingsVC") as! NBRatingsVC
        viewController.expertId = self.profileModel.data!.id ?? ""
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
