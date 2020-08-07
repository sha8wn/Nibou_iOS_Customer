//
//  WalkthroughParentViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/8/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class WalkthroughParentViewController: BaseViewController {

    /**
     MARK: - Properties
     */
    @IBOutlet weak var scrollView       : UIScrollView!
    @IBOutlet weak var btnBack          : UIButton!
    @IBOutlet weak var btnNext          : UIButton!
    @IBOutlet weak var pageControl      : UIPageControl!
    var pageArray                       : Array<Any>!
    var count                           : Int!
    var xOffSet                         : Int = 0
    //end

    var letsBeginAttributedString: NSAttributedString!

    var nextAttributedString: NSAttributedString!
              
              
            
    
    /**
     MARK: - All View Will Load Here
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInset = UIEdgeInsets.zero;
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        self.scrollView.frame = self.view.frame
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.size.height)
        
        let buttonAttributes = [
              NSAttributedString.Key.font : UIFont(name: "Ubuntu-Bold", size: 16.0),
              NSAttributedString.Key.foregroundColor : UIColor.white,
          ]
        self.letsBeginAttributedString = NSAttributedString(string: "LETS_BEGIN".localized(), attributes: buttonAttributes as [NSAttributedString.Key : Any])

        self.nextAttributedString = NSAttributedString(string: "NEXT".localized(), attributes: buttonAttributes as [NSAttributedString.Key : Any])
        
        self.btnNext.titleLabel?.textAlignment = .center
        self.btnNext.titleLabel?.lineBreakMode = .byCharWrapping
        self.btnNext.setAttributedTitle(nextAttributedString, for: .normal)
        
//        self.btnNext.setTitle("NEXT".localized(), for: UIControl.State.normal)
        self.btnBack.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setUpWalkthroughView()
    }
    
    
    
    /**
     MARK: - Set up WalkthroughView function
     */
    func setUpWalkthroughView(){
        //Set up scrollView
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false

        let dictView1 = ["imageDesc" : "WALKTHROUGH_DESC_VIEW1".localized(),
                         "imageURL"  : "ic_Walkthrough_View1",
                         "title"     : "WALKTHROUGH_TITLE_VIEW1".localized()]
        
        let dictView2 = ["imageDesc" : "WALKTHROUGH_DESC_VIEW2".localized(),
                         "imageURL"  : "ic_Walkthrough_View2",
                         "title"     : "WALKTHROUGH_TITLE_VIEW2".localized()]
        
        let dictView3 = ["imageDesc" : "WALKTHROUGH_DESC_VIEW3".localized(),
                         "imageURL"  : "ic_Walkthrough_View3",
                         "title"     : "WALKTHROUGH_TITLE_VIEW3".localized()]
        
        let dictView4 = ["imageDesc" : "WALKTHROUGH_DESC_VIEW4".localized(),
                         "imageURL"  : "ic_Walkthrough_View4",
                         "title"     : "WALKTHROUGH_TITLE_VIEW4".localized()]
        

        self.pageArray = [dictView1, dictView2, dictView3, dictView4]
        

        self.count = 0
        var xAsix : CGFloat = 0.0
        for i in 0  ..< self.pageArray.count  {
            let Views = UIView()
            Views.frame = CGRect(x: xAsix, y: 0.0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            let introDict = pageArray[i] as! NSDictionary
            let viewControl = getViewOfWalkthrough(dict: introDict, index: i) as UIViewController
            Views.addSubview(viewControl.view)
            self.scrollView.addSubview(Views)
            xAsix = xAsix + self.view.frame.width
        }
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(self.pageArray.count), height: self.scrollView.frame.size.height)
        self.pageControl.numberOfPages = self.pageArray.count
    }

    
    /**
     MARK: - Get View Of Walkthrough
     - Function to Get and Set View Controller on UIScrollView
     - Returns: WalkthroughViewController
     */
    func getViewOfWalkthrough(dict: NSDictionary, index: Int) -> WalkthroughViewController{
        let vc = walkthroughStoryboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as! WalkthroughViewController
        vc.imageUrl = dict.value(forKey: "imageURL") as! String
        vc.titleStr = dict.value(forKey: "title") as! String
        vc.descStr = dict.value(forKey: "imageDesc") as! String
        return vc
    }
    
    /**
     MARK: - Button Back Tapped
    */
    @IBAction func btnBackTapped(){
        if(self.pageArray.count != self.count){
            self.count = self.count - 1
            xOffSet = self.pageArray.count * Int(self.view.frame.width)
            UIView.animate(withDuration: 0.5) {
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width * CGFloat(self.count), y: 0)
                self.pageControl.currentPage = self.count
            }
            
            if(self.count == self.pageArray.count - 1){
                self.btnNext.setAttributedTitle(letsBeginAttributedString, for: .normal)
//                self.btnNext.setTitle("LETS_BEGIN".localized(), for: UIControl.State.normal)
            }else{
                self.btnNext.setAttributedTitle(nextAttributedString, for: .normal)
//                self.btnNext.setTitle("NEXT".localized(), for: UIControl.State.normal)
            }
        }
    }
    
    /**
     MARK: - Button Next Tapped
     */
    @IBAction func btnNextTapped(){
        if self.count == self.pageArray.count - 1{
            let viewController = loginAndSignupStoryboard.instantiateViewController(withIdentifier: "ChooseUserTypeViewController") as! ChooseUserTypeViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            if(self.pageArray.count != self.count){
                xOffSet = self.count * Int(self.view.frame.width)
                self.count = self.count + 1
                UIView.animate(withDuration: 0.5) {
                    self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width * CGFloat(self.count), y: 0)
                    self.pageControl.currentPage = self.count
                }
                if(self.count == self.pageArray.count - 1){
                    self.btnNext.setAttributedTitle(letsBeginAttributedString, for: .normal)
//                    self.btnNext.setTitle("LETS_BEGIN".localized(), for: UIControl.State.normal)
                }else{
                    self.btnNext.setAttributedTitle(nextAttributedString, for: .normal)
//                    self.btnNext.setTitle("NEXT".localized(), for: UIControl.State.normal)
                }
            }else{
            }
        }
    }

}
//end

/**
 MARK: - Extension of WalkthroughViewController with UIScrollViewDelegate
*/
extension WalkthroughParentViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.pageArray != nil{
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(self.pageArray.count), height: self.scrollView.frame.size.height)
            self.pageControl.numberOfPages = self.pageArray.count
            let page : Int = Int(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
            if page == 0{
                self.btnBack.isHidden = true
            }else{
                self.btnBack.isHidden = false
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page : Int = Int(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
        xOffSet = page * Int(self.view.frame.width)
        if page == self.pageArray.count - 1 {
            self.btnNext.setAttributedTitle(letsBeginAttributedString, for: .normal)
//            self.btnNext.setTitle("LETS_BEGIN".localized(), for: UIControl.State.normal)
        }
        else {
            if page == 0{
                self.btnBack.isHidden = true
            }else{
                self.btnBack.isHidden = false
            }
            self.btnNext.setAttributedTitle(nextAttributedString, for: .normal)
//            self.btnNext.setTitle("NEXT".localized(), for: UIControl.State.normal)
        }
        self.pageControl.currentPage = page
        self.count = page
    }
}
//end
