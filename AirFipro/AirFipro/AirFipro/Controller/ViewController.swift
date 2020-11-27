//
//  ViewController.swift
//  AirFipro
//
//  Created by ixm1 on 11/7/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate, BSKeyboardControlsDelegate {

    // MARK: - Varaiable Declaration
    @IBOutlet var viewSignInBox: UIView!
    @IBOutlet var txtfldEmail: UITextField!
    @IBOutlet var txtfldPassword: UITextField!
    @IBOutlet var lblSignIn: UILabel!
    
    var keyboardControls: BSKeyboardControls?
    var currentTextfield: UITextField!
    var macAddress: String = ""
    var deviceToken: String = ""
    var dictResponseSignin = NSDictionary()
    var player: AVAudioPlayer!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        wigetConfigurationSignin()
        if Common.checkTypeCollection() == 0 {
            Common.startPinwheelProcessing()
            self.getTypeCollection()
        }
//        test()
    }
    
//    func test() {
//        let arrTemp: NSArray = ["1","2","3","4","5"]
//        var lastIndex = arrTemp.count
//        UserDefaults.standard.setValue("YES", forKey: "ALERTSTATUS")
//        for index in 0..<(arrTemp.count) {
//            print("appdelegate index \(appDelegate.alertStatus)")
//            print("index \(index)")
//            var appearance = SCLAlertView.SCLAppearance()
//            if appDelegate.alertStatus == "YES" {
//                appDelegate.alertStatus = "NO"
//                appearance = SCLAlertView.SCLAppearance (
//                    kDefaultShadowOpacity: 1.0,
//                    kTitleFont: UIFont(name: "ProximaNova-Semibold", size: 20)!,
//                    kTextFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
//                    kButtonFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
//                    showCloseButton: false,
//                    dynamicAnimatorActive: true,
//                    buttonsLayout: .horizontal
//                )
//            } else if appDelegate.alertStatus == "NO" {
//                appearance = SCLAlertView.SCLAppearance (
//                    kDefaultShadowOpacity: 0.7,
//                    kTitleFont: UIFont(name: "ProximaNova-Semibold", size: 20)!,
//                    kTextFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
//                    kButtonFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
//                    showCloseButton: false,
//                    dynamicAnimatorActive: true,
//                    buttonsLayout: .horizontal
//                )
//            }
//            let alert = SCLAlertView(appearance: appearance)
//            _ = alert.addButton("DONE") {
//                NSLog("ok button tapped")
//                print("ok button tapped")
//                lastIndex = lastIndex - 1
//                print("last index \(lastIndex)")
//                if lastIndex == -1 {
//                    appDelegate.alertStatus = "YES"
//                    print("appdelegate index \(appDelegate.alertStatus)")
//                }
//            }
//            _ = alert.addButton("IGNORE") {
//                NSLog("Second button tapped")
//                print("Second button tapped")
//                lastIndex = lastIndex - 1
//                print("last index \(lastIndex)")
//                if lastIndex == -1 {
//                    appDelegate.alertStatus = "YES"
//                    print("appdelegate index \(appDelegate.alertStatus)")
//                }
//            }
//
//            let icon = SCLAlertViewStyleKit.imageOfWarning
//            let color = UIColor.init(hexString: "\(appDelegate.strColorCode)")
//
//            _ = alert.showCustom(appDelegate.strPushAlertType, subTitle: appDelegate.strPushDesc, color: color, icon: icon)
//        }
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("****************************************")
        Common.checkViewControllerStack()
//        self.txtfldEmail.text = "unittwo@gmail.com"
//        self.txtfldPassword.text = "123456"
    }

    // MARK: - IBAction
    @IBAction func passwordAction(_ sender: Any) {
        let FPVC = self.storyboard?.instantiateViewController(withIdentifier: FORGOTPWDVIEW) as? ForgotPwdViewController
        self.navigationController?.pushViewController(FPVC!, animated: true)
    }
    
    @IBAction func signinAction(_ sender: Any) {
        if let currentTextfield = currentTextfield {
            currentTextfield.resignFirstResponder()
        }
        self.view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
        if txtfldEmail.text == "" && txtfldPassword.text == "" {
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldEmail.text == "" {
            Common.showCustomAlert(message: EMAILIDVALIDATION)
            return
        } else if txtfldPassword.text == "" {
            Common.showCustomAlert(message: PASSWORDVALIDATION)
            return
        } else if txtfldEmail.text != "" && Common.emailValidation(strMailString: txtfldEmail.text!) == "NO" {
            Common.showCustomAlert(message: INVALIDEMAIL)
            return
        } else if txtfldPassword.text != "" && (txtfldPassword.text?.characters.count)! < 6 {
            Common.showCustomAlert(message: INVALIDPWD)
            return
        }
        if Common.reachabilityChanged() == true {
            Common.startPinwheelProcessing()
            userLoginService()
        } else {
            Common.showCustomAlert(message: NWCONNECTION)
        }
    }
    
    // MARK: - User Define Method
    func wigetConfigurationSignin() -> Void {
        txtfldEmail.delegate = self
        txtfldPassword.delegate = self
        txtfldEmail.clearButtonMode = .whileEditing
        txtfldPassword.clearButtonMode = .whileEditing
        txtfldEmail.underlined()
        txtfldPassword.underlined()
        let fields = NSArray(array:[txtfldEmail, txtfldPassword])
        keyboardControls = BSKeyboardControls(fields: fields as [AnyObject])
        keyboardControls?.delegate = self
        viewSignInBox.layer.shadowColor = UIColor.black.cgColor
        viewSignInBox.layer.shadowOpacity = 0.3
        viewSignInBox.layer.shadowOffset = CGSize.zero
        viewSignInBox.layer.shadowRadius = 3
        
        viewSignInBox.layer.shadowPath = UIBezierPath(rect: viewSignInBox.bounds).cgPath
        viewSignInBox.layer.shouldRasterize = true
        viewSignInBox.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        
        if Common.deviceType() == "iPhone5" {
            lblSignIn.frame = CGRect(x: CGFloat(lblSignIn.frame.origin.x), y: CGFloat(lblSignIn.frame.origin.y - 20), width: CGFloat(lblSignIn.frame.size.width), height: CGFloat(lblSignIn.frame.size.height))
        }
    }
    
    // MARK: - UITextfield Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keyboardControls?.activeField = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("\(textField.frame.origin.y)")
        currentTextfield = textField
        textField.underlinedBlue()
        if Common.deviceType() == "iPhone5" {
            view.frame = CGRect(x: CGFloat(0), y: CGFloat(-150), width: CGFloat(view.frame.size.width), height: CGFloat(view.frame.size.height))
        } else {
            view.frame = CGRect(x: CGFloat(0), y: CGFloat(-110), width: CGFloat(view.frame.size.width), height: CGFloat(view.frame.size.height))
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(view.frame.size.width), height: CGFloat(view.frame.size.height))
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " " || range.location == 0 && string == "'" {
            print("empty string not allowed")
            return false
        }
        if textField == txtfldPassword {
            let newLength = (textField.text?.characters.count)! + (string.characters.count) - range.length
            let inverseSet = NSCharacterSet(charactersIn:ACCEPTABLE_CHARACTERSAlphaNumeric).inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            return string == filtered && newLength <= MAX_LIMIT_PNUMBER
        }

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == txtfldEmail) {
            txtfldEmail.underlined()
            txtfldEmail.text =  txtfldEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            txtfldPassword.underlined()
            txtfldPassword.text =  txtfldPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    // MARK: - BSKeyboard Delegate Method
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) -> Void {
        self.view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
        self.view.endEditing(true)
    }
    // MARK: - API Implementation
    func userLoginService() -> Void {
        let hashPWDData = Common.md5(string: txtfldPassword.text! as String)
        let hashPWD =  hashPWDData!.map { String(format: "%02hhx", $0) }.joined()
        print("hash string \(hashPWD)")
        if appDelegate.appDeviceToken != "" {
            macAddress = appDelegate.appDeviceToken
        } else {
            macAddress = "30A92AB042E5F53F13541AEDF2BBC45C05115D5829D5EB13DDE764AC3AEF2A15"
        }
        let dictSignIn = NSMutableDictionary()
        dictSignIn.setValue(txtfldEmail.text! as String, forKey: EMAILID)
        dictSignIn.setValue(hashPWD as String, forKey: PASSWORD)
        let arrSignInPayLoad = NSMutableArray()
        arrSignInPayLoad.add(Common.payloadKeyValue(strKey: DEVICE_MAC_ADDRESS, strValue: macAddress))
        arrSignInPayLoad.add(Common.payloadKeyValue(strKey: DEVICE_TOKEN, strValue: macAddress))
        dictSignIn.setValue(arrSignInPayLoad, forKey: KEYVALUE)
        print("Dict SignIn\(dictSignIn)")
        let parameters: NSDictionary = ServiceConnector.setLoginRequestParameter(dictLogin: dictSignIn)
        print("Dict JSON Formation SingIn\(parameters)")
        
        ServiceConnector.serviceConnectorPOST(LOGIN_METHOD_NAME, inputParam: parameters as! NSMutableDictionary) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                self.dictResponseSignin = NSDictionary()
                self.dictResponseSignin = responseObject! as NSDictionary
                if (code == CODE201) {
                    self.dictResponseSignin = self.dictResponseSignin.value(forKey: RESULTS) as! NSDictionary
                    print(self.dictResponseSignin.object(forKey: "oauthKey") as! String)
                    let dictUser: NSDictionary = self.dictResponseSignin.value(forKey: RUSER) as! NSDictionary
                    UserDefaults.standard.setValue(self.dictResponseSignin.object(forKey: ROAUTHKEY) as! String, forKey: ROAUTHKEY)
                    UserDefaults.standard.setValue(dictUser.object(forKey: RID) as! String, forKey: RUSERID)
                    UserDefaults.standard.setValue(dictUser.object(forKey: RORGANIZATIONID) as! String, forKey: RORGANIZATIONID)
                    UserDefaults.standard.setValue("YES", forKey: APPLAUNCHSTATUS)
                    UserDefaults.standard.setValue(self.txtfldEmail.text! as String, forKey: EMAILID)
                    UserDefaults.standard.setValue(hashPWD as String, forKey: PASSWORD)
                    var arrKeyValue = NSArray()
                    arrKeyValue = dictUser.object(forKey: RKEYVALUES) as! NSArray
                    print(arrKeyValue)
                    if arrKeyValue.count > 0 {
                        print(arrKeyValue.count)
                        print(arrKeyValue[0] as AnyObject)
                        for index in 0 ..< arrKeyValue.count {
                            var dictKeyValues = NSDictionary()
                            dictKeyValues = arrKeyValue[index] as! NSDictionary
                            if dictKeyValues.value(forKey: KEY) as! String == NOTIFICATIONSTATE {
                                let arrValues = dictKeyValues.value(forKey: VALUE) as! NSArray
                                if arrValues[0] as! String == "ACTIVE" {
                                    appDelegate.preferencePermission = "YES"
                                    break
                                }
                                appDelegate.preferencePermission = "NO"
                            }
                        }
                    }
                    appDelegate.strUserPassword = self.txtfldPassword.text!
                    let DVC = self.storyboard?.instantiateViewController(withIdentifier: DEPARTMENTVIEW) as? DepartmentViewController
                    appDelegate.viewController_Navigation_Type = NAVIGATIONTYPESIGNIN
                    self.navigationController?.pushViewController(DVC!, animated: true)
                    Common.stopPinwheelProcessing()
                } else {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: self.dictResponseSignin))
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }
    func getTypeCollection() -> Void {
        let methodName = "\(TYPECOLLECTION_METHOD_NAME)"+QUERYMARK+GET_PARAM_OFFSET+QUERYSYMBOL+"0"+QUERYJOIN+GET_PARAM_LIMIT+QUERYSYMBOL+"1000"
        ServiceConnector.serviceConnectorGET(methodName) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                self.dictResponseSignin = NSDictionary()
                self.dictResponseSignin = responseObject! as NSDictionary
                print(self.dictResponseSignin)
                if (code == CODE200) {
                    var arrTempList: NSArray = []
                    arrTempList = self.dictResponseSignin.value(forKey: RESULTS) as! NSArray
                    print(arrTempList)
                    print(arrTempList.count)
                    UserDefaults.standard.setValue(arrTempList, forKey: TYPECOLLECTION)
                    Common.parseTypeCollectionNotification(arrType: arrTempList)
                    Common.stopPinwheelProcessing()
                } else {
                    Common.stopPinwheelProcessing()
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
            }
        }
    }
}
