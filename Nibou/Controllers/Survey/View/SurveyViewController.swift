//
//  SurveyViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/13/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

enum SurveyOpenFrom{
    case appDelegate
    case login
    case register
    case other
    case home
    case switchExpert
}

class SurveyViewController: BaseViewController {

    /**
     MARK: - Properties
    */
    @IBOutlet weak var btnBack              : UIButton!
    @IBOutlet weak var btnLogout            : UIButton!
    @IBOutlet weak var lblStaticHeader      : UILabel!
    @IBOutlet weak var collectionView       : UICollectionView!
    @IBOutlet weak var lblStaticDesc        : UILabel!
    @IBOutlet weak var btnContinue          : UIButton!
    var isOpenFrom                          : SurveyOpenFrom!
    var isAddedNewSurveySuccess             : Bool                   = false
    var selectedCellArray                   : [Bool]                 = []
    var dataArray                           : [String]               = []
    var modelArray                          : [SurveyData]!
    var isAPIError                          : Bool                   = false
    //end
    
    /**
     MARK: - UIViewController
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.callGetSurveyDataApi()
        // Do any additional setup after loading the view.
    }
    //end

    /**
     MARK: - Setup UI
     */
    func setUpView(){
        self.lblStaticHeader.text = "SURVEY_HEADER".localized()
        self.lblStaticDesc.text = "SURVEY_DESC".localized()
        self.btnContinue.setTitle("CONTINUE".localized(), for: .normal)
        self.lblStaticDesc.textColor = UIColor.white.withAlphaComponent(0.6)
        self.collectionView?.register(UINib(nibName: "SuveyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SuveyCollectionViewCell")
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.bounces = true
        self.btnContinue.isHidden = true
        if self.isOpenFrom == .appDelegate || self.isOpenFrom == .login || self.isOpenFrom == .register{
            self.btnBack.isHidden = true
            self.btnLogout.isHidden = false
            self.btnLogout.setTitle("LOGOUT".localized(), for: .normal)
        }else{
            self.btnBack.isHidden = false
            self.btnLogout.isHidden = true
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLogoutTapped(_ sender: Any){
        self.callLogOutApi()
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        if checkNumberOfSelectedItem() > 0{
            var selectedArray: [String] = []
            for i in 0...self.selectedCellArray.count - 1{
                if self.selectedCellArray[i] == true{
                    let data = self.modelArray[i]
                    selectedArray.append(data.id!)
                }
            }
            let viewController = surveyStoryboard.instantiateViewController(withIdentifier: "SelectPreferenceViewController") as! SelectPreferenceViewController
            viewController.selectedSuverArray = selectedArray
            viewController.isOpenFrom = self.isOpenFrom
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            self.showAlert(viewController: self, alertMessage: "SURVEY_DESC".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
        }
    }
}

/**
 MARK: - Extension SurveyViewController of UICollectionView Delegates, DataSource and Functions
 */
extension SurveyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataArray.count > 0 && self.selectedCellArray.count > 0{
            return self.dataArray.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuveyCollectionViewCell", for: indexPath) as! SuveyCollectionViewCell
        cell.configureCell(array: self.selectedCellArray, index: indexPath.item, dataArray: self.dataArray)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // your code here
        return CGSize(width: self.view.frame.width/2 - 25, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.dataArray.count - 1{
            if self.dataArray[indexPath.row] == "+"{
                self.showAlert(viewController: self, alertTitle: "SURVEY_ALERT_HEADER".localized(), alertType: .textfieldWithOneButton, singleButtonTitle: "OK".localized())
            }else{
                if self.selectedCellArray[indexPath.item] == true{
                    self.selectedCellArray[indexPath.item] = false
                }else{
                    self.selectedCellArray[indexPath.item] = true
                }
                self.dataArray.append("+")
                self.selectedCellArray.append(false)
                self.collectionView.reloadData()
            }
        }else{
            if self.checkNumberOfSelectedItem() == 2{
                if self.selectedCellArray[indexPath.item] == true{
                    self.selectedCellArray[indexPath.item] = false
                }else{
                    self.selectedCellArray[indexPath.item] = true
                }
                self.collectionView.reloadItems(at: [indexPath])
                if self.dataArray[self.dataArray.count - 1] == "+"{
                    self.dataArray[self.dataArray.count - 1] = ""
                    self.collectionView.reloadItems(at: [IndexPath(item: self.dataArray.count - 1, section: 0)])
                }else{
                    
                }
            }else{
                if self.selectedCellArray[indexPath.item] == true{
                    self.selectedCellArray[indexPath.item] = false
                    self.collectionView.reloadItems(at: [indexPath])
                    if self.dataArray[self.dataArray.count - 1] == ""{
                        self.dataArray[self.dataArray.count - 1] = "+"
                        self.collectionView.reloadItems(at: [IndexPath(item: self.dataArray.count - 1, section: 0)])
                    }
                }else{
                    if self.checkNumberOfSelectedItem() < 3{
                        self.selectedCellArray[indexPath.item] = true
                        self.collectionView.reloadItems(at: [indexPath])
                        if self.dataArray[self.dataArray.count - 1] == ""{
                            self.dataArray[self.dataArray.count - 1] = "+"
                            self.collectionView.reloadItems(at: [IndexPath(item: self.dataArray.count - 1, section: 0)])
                        }
                    }else{
                        
                    }
                }
            }
            
            if self.checkNumberOfSelectedItem() > 0{
                self.btnContinue.isHidden = false
            }else{
                self.btnContinue.isHidden = true
            }
            
        }
    }
    
    func checkNumberOfSelectedItem() -> Int{
        var number: Int = 0
        for i in 0...self.selectedCellArray.count - 1{
            if self.selectedCellArray[i] ==  true{
                number = number + 1
            }else{
                
            }
        }
        return number
    }
    
}
//end


/**
 MARK: - Extension SurveyViewController of AlertDelegate
 */
extension SurveyViewController: AlertDelegate{
    func alertOkTextFieldTapped(text: String) {
        if text != ""{
            self.callAddSurveyApi(title: text)
        }
    }
    
    func alertOkTapped() {
        if self.isAddedNewSurveySuccess{
            self.isAddedNewSurveySuccess = false
            self.collectionView.reloadData()
        }else if self.isAPIError{
            self.isAPIError = false
            
        }
    }
}
//end
