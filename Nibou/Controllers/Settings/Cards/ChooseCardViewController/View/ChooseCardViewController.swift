//
//  ChooseCardViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 20/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

protocol CardAddedSuccessfullyDelegate {
    func cardAdded()
}

extension CardAddedSuccessfullyDelegate{
    func cardAdded(){}
}

class ChooseCardViewController: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var btnSetDefaultHeightCons: NSLayoutConstraint!
    @IBOutlet weak var lblNoCard            : UILabel!
    @IBOutlet weak var tableView            : UITableView!
    @IBOutlet weak var lblHeader            : UILabel!
    @IBOutlet weak var btnBack              : UIButton!
    @IBOutlet weak var btnAddCard           : UIButton!
    @IBOutlet weak var btnSetDefault        : UIButton!
    var isComeFrom                          : String!               = ""
    var cardModel                           : [CardIncluded]!       = []
    var isDeleteCard                        : Bool                  = false
    var cardId                              : String                = ""
    var cardDelegate                        : CardAddedSuccessfullyDelegate!
    //end
    
    //MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
        
    }
    
    //MARK: - Set Up View
    func setup(){
        self.tableView.estimatedRowHeight = 180
        self.tableView.register(UINib(nibName: "CardTableViewCell", bundle: nil), forCellReuseIdentifier: "CardTableViewCell")
        
        self.btnAddCard.setTitle("ADD_CARD".localized(), for: .normal)
        if self.isComeFrom == "Home"{
            self.btnSetDefault.isHidden = false
            self.btnSetDefaultHeightCons.constant = 44
            self.lblHeader.text = "PAYMENT_INFO_HEADER".localized()
            self.btnAddCard.isHidden = true
            self.tableView.isHidden = true
            self.btnSetDefault.setTitle("ADD_CREDIT_CARD".localized(), for: .normal)
            self.lblNoCard.isHidden = false
            self.lblNoCard.text = "NO_CARD_DESC".localized()
            self.btnBack.isHidden = false
        }else if self.isComeFrom == "Launch"{
            self.btnSetDefault.isHidden = false
            self.btnSetDefaultHeightCons.constant = 44
            self.lblHeader.text = "PAYMENT_INFO_HEADER".localized()
            self.btnAddCard.isHidden = true
            self.tableView.isHidden = true
            self.btnSetDefault.setTitle("ADD_CREDIT_CARD".localized(), for: .normal)
            self.lblNoCard.isHidden = false
            self.lblNoCard.text = "NO_CARD_DESC".localized()
            self.btnBack.isHidden = true
        }else{
            self.btnSetDefault.isHidden = true
            self.btnSetDefaultHeightCons.constant = 0
            self.lblHeader.text = "CHOOSE_CARD_HEADER".localized()
            self.lblHeader.isHidden = false
            self.btnAddCard.isHidden = false
            self.tableView.isHidden = false
            self.btnSetDefault.setTitle("SET_DEFAULT_CARD".localized(), for: .normal)
            self.lblNoCard.isHidden = true
            self.btnBack.isHidden = false
            self.callGetCardList()
        }
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

    @IBAction func btnBackTapped(_ sender: Any) {
        if self.isComeFrom == "Home" || self.isComeFrom == "Launch"{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnSetDefaultTapped(_ sender: Any) {

        if self.isComeFrom == "Home" || self.isComeFrom == "Launch"{
            let viewController = commonStoryboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            viewController.urlString = "data"
            viewController.delegate = self
            self.present(viewController, animated: true, completion: nil)
        }else{
            if self.cardId != ""{
                self.callMakeCardDefaultAPi(id: self.cardId)
            }else{
                self.showAlert(viewController: self,alertTitle: "ERROR".localized() , alertMessage: "ERROR_PLEASE_SELECT_CARD".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    @IBAction func btnAddCardTapped(_ sender: Any) {
        let addCardVC = mainStoryboard.instantiateViewController(withIdentifier: "AddCardViewController") as! AddCardViewController
        addCardVC.openFrom = .chooseCard
        self.navigationController?.pushViewController(addCardVC, animated: true)
    }
}

//MARK: - UITableView Delegate and DataSource
extension ChooseCardViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.cardModel != nil{
            if self.cardModel.count > 0{
                return self.cardModel.count
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell", for: indexPath) as! CardTableViewCell
        let model = self.cardModel[indexPath.row]
        if indexPath.row == 0{
            cell.cellBGView.backgroundColor = UIColor.white
            cell.btnDelete.isHidden = true
            cell.imgViewError.isHidden = true
        }else{
            cell.btnDelete.isHidden = false
            cell.imgViewError.isHidden = false
        }
        
        if model.isSelected == true{
            cell.cellBGView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }else{
            cell.cellBGView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.05)
        }
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        cell.setUpCell(indexPath: indexPath, model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedModel = self.cardModel[indexPath.row]
        self.cardId = selectedModel.id!
        for i in 0...self.cardModel.count - 1{
            var model = self.cardModel[i]
            if model.isSelected == true{
                model.isSelected = false
            }else{
                model.isSelected = false
            }
            self.cardModel[i] = model
        }
        selectedModel.isSelected = true
        self.cardModel[indexPath.row] = selectedModel
        self.tableView.reloadData()
        if indexPath.row != 0 {
            self.btnSetDefault.isHidden = false
            self.btnSetDefaultHeightCons.constant = 44
        }else{
//            if self.btnSetDefault.isHidden == true{
//                self.btnSetDefault.isHidden = false
//                self.btnSetDefaultHeightCons.constant = 44
//            }else{
                self.btnSetDefault.isHidden = true
                self.btnSetDefaultHeightCons.constant = 0
//            }
        }
    }
    
    @objc func deleteButtonTapped(sender: UIButton){
        let model = self.cardModel[sender.tag]
        self.cardId = model.id!
        self.isDeleteCard = true
        self.showAlert(viewController: self, alertTitle: "", alertMessage: "WANT_TO_DELETE_CARD".localized(), alertType: AlertType.twoButton, okTitleString: "YES".localized(), cancelTitleString: "NO".localized())
    }
}

extension ChooseCardViewController: AlertDelegate{
    func alertOkTapped() {
        if self.isDeleteCard{
            self.isDeleteCard = false
            self.callDeleteCardApi(cardId: self.cardId)
        }
    }
}

extension ChooseCardViewController: CardAddedSuccessfullyDelegate{
    func cardAdded() {
        self.dismiss(animated: false) {
            self.cardDelegate.cardAdded()
        }
    }
}

extension ChooseCardViewController: WebViewDelegate{
    func btnRightTapped() {
        let addCardVC = mainStoryboard.instantiateViewController(withIdentifier: "AddCardViewController") as! AddCardViewController
        addCardVC.cardDelegate = self
        addCardVC.openFrom = .home
        self.present(addCardVC, animated: true, completion: nil)
    }
}
