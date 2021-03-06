//
//  FWLoginVC.swift
//  Fileworx_Patrick
//
//  Created by indianic on 03/01/17.
//  Copyright © 2017 indianic. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Toast_Swift


class FWLoginVC: UIViewController {
    
    //  MARK: -
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnLoginAsGuest: UIButton!
    
    let objWeb:WebService = WebService()
    
    var amutArrayData : [Any]?
    var objMobileSettingModel : FWMobileSettingModel?
    var objAvailableModules : FWAvailableModules?
    var objUserModel : FWUserModel?
    
    var aMutArrayAvailableModule:[Any]?
    let arrayLanguages = Localisator.sharedInstance.getArrayAvailableLanguages()    // 1) without Restart Method

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.borderColor = UIColor.white.cgColor
        
        self.txtUserName.text = "root"
        self.txtPassword.text = "root"
        
        self.navigationController?.isNavigationBarHidden = true
        
//        let pickerArray = ["1","2","3","4","5"]
//        
//        FWUtility.sharedInstance.addPicker(self, onTextField: self.txtUserName, typePicker: "", pickerArray: pickerArray, setMaxDate:true) { (picker,buttonindex,firstindex) in
//            
//            if (picker != nil)
//            {
//                
//                print("picker Data \(pickerArray[firstindex])")
//                let datePicker = picker as! UIPickerView
//                
////                let strDate = Utility.sharedInstance.getStringFromDate(Constant.kDateFormat_DDMMYYYY, date: datePicker.date)
//                
////                self.txtUserName = strDate
//                
////                print(strDate)
//            }
//            self.txtUserName!.resignFirstResponder()
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
//        UtilityUserDefault().setUDObject(ObjectToSave: arrayLanguages[1] as AnyObject?, KeyToSave: "Language")
       
       
        
        if let language :String =   UtilityUserDefault().getUDObject(KeyToReturnValye: "Language") as? String
        {
            
            print("language is \(language)")
            
            
            if language == "ar" {
                
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                self.txtUserName.textAlignment = NSTextAlignment.right
                self.txtPassword.textAlignment = NSTextAlignment.right
                UtilityUserDefault().setUDObject(ObjectToSave: arrayLanguages[3] as AnyObject?, KeyToSave: "Language")
            }
            else
            {
                UtilityUserDefault().setUDObject(ObjectToSave: arrayLanguages[1] as AnyObject?, KeyToSave: "Language")
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                self.txtUserName.textAlignment = NSTextAlignment.left
                self.txtPassword.textAlignment = NSTextAlignment.left
                
            }
        }
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        
        self.validationCheck()
//        self.CallAPILogin()
//        FWUtilityDrawer().loginToDrawerFrom(self, animated: false)

        
        
    }
    @IBAction func btnLoginAsGuestClicked(_ sender: Any) {
    }
    
    
    func validationCheck(){
        
//        guard let userName  = self.txtUserName.text , userName != "", isValidEmail(testStr: userName)  else{
//            print("Please Enter Name")
//            return
//        }
//        
//        guard let passwrod  = self.txtPassword.text , passwrod != "" else{
//            print("Please Enter Password")
//            return
//        }
        FWUtilityDrawer().loginToDrawerFrom(self, animated: false)

        
    
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}


extension FWLoginVC{
    

    func CallAPIMobileSetting()
    {
        objWeb.callWebService("http://212.118.26.115/FileworxMobileServer/api/Application/MobileSettings",aView:self.view,  param: nil) { json in
            
            debugPrint(json)
            
            print(json["RestResponse"])
            self.objMobileSettingModel =  FWMobileSettingModel(json: json)
            
            
            print("Message is \(self.objMobileSettingModel?.message)")
            print("Message is \(self.objMobileSettingModel?.data?.globalMobileSetttings?.allowAnonymousAccess)")
            
        }
        
    }
    
    func CallAPILogin(){
        
        let json: [String: Any] = ["userName": self.txtUserName.text!, "Password":self.txtPassword.text!,"LastLoginLanguageID":"2","AuthenticationType":"0"];
    
        
        WebService().callWebServiceWithURLSession(loginAPIUrl, param: json) { json
            in
            
            print("json \(json)")
            self.objUserModel  = FWUserModel(json:json)
            
            
            
            print("Result -> \((self.objUserModel?.data)!)")
            
            if self.objUserModel?.result == 0
            {
                
                UtilityUserDefault().setUDObject(ObjectToSave: self.objUserModel?.message as AnyObject?, KeyToSave: "user")
                UtilityUserDefault().setUDBool(true,key: "pratik")

                FWUtilityDrawer().loginToDrawerFrom(self, animated: false)

//                let controller = Constants.Storyboard.kLoginAndSplashStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//                self.navigationController?.pushViewController(controller, animated: true)
                
            }else
            {
                self.view.makeToast((self.objUserModel?.message)!, duration: 3.0, position: .bottom)
            }
            
        }
    }

}
