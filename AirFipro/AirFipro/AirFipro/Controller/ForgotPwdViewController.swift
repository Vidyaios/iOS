//
//  ForgotPwdViewController.swift
//  AirFipro
//
//  Created by iexm01 on 27/11/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit

class ForgotPwdViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Variable Declaration
    @IBOutlet var forgotPwdEmailTextfield: UITextField!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotPwd_widget_InitialSetup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - User Defined Methods
    func forgotPwd_widget_InitialSetup() {
        forgotPwdEmailTextfield.delegate = self
        forgotPwdEmailTextfield.clearButtonMode = .whileEditing
        forgotPwdEmailTextfield.underlined()
    }
    
    // MARK: - UITextfield Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("\(textField.frame.origin.y)")
        textField.underlinedBlue()
        if Common.deviceType() == "iPhone5" {
            view.frame = CGRect(x: CGFloat(0), y: CGFloat(-160), width: CGFloat(view.frame.size.width), height: CGFloat(view.frame.size.height))
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
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == forgotPwdEmailTextfield) {
            forgotPwdEmailTextfield.underlined()
            forgotPwdEmailTextfield.text =  forgotPwdEmailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    //MARK: - IBAction
    @IBAction func forgotPwd_Widget_Action(_ sender: UIButton) {
        print("btnTag==\(sender.tag)")
        switch sender.tag {
        case 0: // Back
            let _ = self.navigationController?.popViewController(animated: true)
            break
        case 1: // Submit
            if forgotPwdEmailTextfield.text == "" {
                Common.showCustomAlert(message: EMAILIDVALIDATION)
                return
            } else if forgotPwdEmailTextfield.text != "" && Common.emailValidation(strMailString: forgotPwdEmailTextfield.text!) == "NO" {
                Common.showCustomAlert(message: INVALIDEMAILID)
                return
            }
            if Common.reachabilityChanged() == true {
                Common.startPinwheelProcessing()
                forgotPassword_Service()
            } else {
                Common.showCustomAlert(message: NWCONNECTION)
            }
            break
        default:
            print("default")
        }
    }
    
    //MARK: - API Implementation
    func forgotPassword_Service() {
        let dictForgotPswd = NSMutableDictionary()
        dictForgotPswd.setValue(FORGOTPSWDKEY, forKey: RTYPE)
        let arrForgotPswd = NSMutableArray()
        arrForgotPswd.add(Common.payloadKeyValue(strKey: EMAILADDRKEY, strValue: forgotPwdEmailTextfield.text!))
        dictForgotPswd.setValue(arrForgotPswd, forKey: KEYVALUE)
        let parameters: NSDictionary = ServiceConnector.changePassword_request_parameter(dictSettings: dictForgotPswd)
        print("Dict JSON Formation reset password \(parameters)")
        ServiceConnector.serviceConnectorPOST(FORGOTPSWD_METHOD_NAME, inputParam: parameters as! NSMutableDictionary) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResponse = NSDictionary()
                dictResponse = responseObject! as NSDictionary
                if code == CODE201 {
                    Common.stopPinwheelProcessing()
                    let appearance = SCLAlertView.SCLAppearance(
                        kTextFont: UIFont(name: "ProximaNova-Semibold", size: 14)!,
                        kButtonFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
                        showCloseButton: false,
                        showCircularIcon: true
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    _ = alertView.addButton("OK") {
                        let _ = self.navigationController?.popViewController(animated: true)
                    }
                    _ = alertView.showSuccess(SUCCESS, subTitle: FORGOTPSWDSUCCESS)
                } else {
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: dictResponse))
                    Common.stopPinwheelProcessing()
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }
    
}
