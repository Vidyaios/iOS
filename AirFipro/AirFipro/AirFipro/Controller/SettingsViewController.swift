//
//  SettingsViewController.swift
//  AirFipro
//
//  Created by iexm01 on 24/11/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate, BSKeyboardControlsDelegate {

    //MARK: - Variable Declaration
    @IBOutlet var oldPswdTextfield: UITextField!
    @IBOutlet var newPswdTextfield: UITextField!
    @IBOutlet var confirmPswdTextfield: UITextField!
    
    var keyboardControls: BSKeyboardControls?
    var currentTextfield: UITextField!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settings_widget_configuration()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - User Defined Methods
    func settings_widget_configuration() {
        
        oldPswdTextfield.delegate = self
        newPswdTextfield.delegate = self
        confirmPswdTextfield.delegate = self

        oldPswdTextfield.clearButtonMode = .whileEditing
        newPswdTextfield.clearButtonMode = .whileEditing
        confirmPswdTextfield.clearButtonMode = .whileEditing

        oldPswdTextfield.underlined()
        newPswdTextfield.underlined()
        confirmPswdTextfield.underlined()

        let fields = NSArray(array:[oldPswdTextfield, newPswdTextfield, confirmPswdTextfield])
        keyboardControls = BSKeyboardControls(fields: fields as [AnyObject])
        keyboardControls?.delegate = self
    }
    
    //MARK: - UITextfield Delegate Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keyboardControls?.activeField = textField
        textField.underlinedBlue()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("\(textField.frame.origin.y)")
        self.currentTextfield = textField
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            if Common.deviceType() == "iPhone5" && self.currentTextfield == self.confirmPswdTextfield {
                self.view.frame = CGRect(x: CGFloat(0), y: CGFloat(-100), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
            }
        }, completion: { finished in
            print("view visible")
        })
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
        if textField == textField {
            let newLength = (textField.text?.characters.count)! + (string.characters.count) - range.length
            let inverseSet = NSCharacterSet(charactersIn:ACCEPTABLE_CHARACTERSAlphaNumeric).inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            return string == filtered && newLength <= MAX_LIMIT_PNUMBER
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == oldPswdTextfield {
            oldPswdTextfield.underlined()
            oldPswdTextfield.text =  oldPswdTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if textField == newPswdTextfield {
            newPswdTextfield.underlined()
            newPswdTextfield.text =  newPswdTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if textField == confirmPswdTextfield {
            confirmPswdTextfield.underlined()
            confirmPswdTextfield.text =  confirmPswdTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    // MARK: - BSKeyboard Delegate Method
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) -> Void {
        self.view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
        self.view.endEditing(true)
    }
    
    //MARK: - IBAction
    @IBAction func settings_widget_action(_ sender: UIButton) {
        switch sender.tag {
        case 0: // Menu
            if let currentTextfield = currentTextfield {
                currentTextfield.resignFirstResponder()
            }
            let _ = self.navigationController?.popViewController(animated: true)
            break
        case 1: // Submit
            if oldPswdTextfield.text == "" && newPswdTextfield.text == "" && confirmPswdTextfield.text == "" {
                Common.showCustomAlert(message: ALLFIELDVALIDATION)
                return
            } else if oldPswdTextfield.text == "" {
                Common.showCustomAlert(message: OLDPWDEMPTY)
                return
            } else if newPswdTextfield.text == "" {
                Common.showCustomAlert(message: NEWPWDEMPTY)
                return
            } else if confirmPswdTextfield.text == "" {
                Common.showCustomAlert(message: CNFRMPWDEMPTY)
                return
            } else if oldPswdTextfield.text != "" && (oldPswdTextfield.text?.count)! < 6 {
                Common.showCustomAlert(message: OLDPSWDLIMITVALIDATION)
                return
            } else if newPswdTextfield.text != "" && (newPswdTextfield.text?.count)! < 6 {
                Common.showCustomAlert(message: NEWPSWDLIMITVALIDATION)
                return
            } else if confirmPswdTextfield.text != "" && (confirmPswdTextfield.text?.count)! < 6 {
                Common.showCustomAlert(message: CONFIRMPSWDLIMITVALIDATION)
                return
            } else if oldPswdTextfield.text == newPswdTextfield.text {
                Common.showCustomAlert(message: OLDPSWDNEWPSWDMATCHVALIDATION)
                return
            } else if newPswdTextfield.text != confirmPswdTextfield.text {
                Common.showCustomAlert(message: NEWPSWDMATCHVALIDATION)
                return
            }
            if Common.reachabilityChanged() == true {
                Common.startPinwheelProcessing()
                self.settings_changePassword_Service()
            } else {
                Common.showCustomAlert(message: NWCONNECTION)
            }
            break
        default:
            break
        }
    }
    
    //MARK: - API Implementation
    func settings_changePassword_Service() {
        let hashPWDData = Common.md5(string: oldPswdTextfield.text! as String)
        let oldPassword =  hashPWDData!.map { String(format: "%02hhx", $0) }.joined()
        print("hash string \(oldPassword)")

        let hashPWDData1 = Common.md5(string: newPswdTextfield.text! as String)
        let newPassword =  hashPWDData1!.map { String(format: "%02hhx", $0) }.joined()
        print("hash string \(newPassword)")

        let dictSettings = NSMutableDictionary()
        dictSettings.setValue(CHANGEPASSWORDKEY, forKey: RTYPE)
        let arrSettings = NSMutableArray()
        arrSettings.add(Common.payloadKeyValue(strKey: OLDPASSWORDKEY, strValue: oldPassword))
        arrSettings.add(Common.payloadKeyValue(strKey: NEWPASSWORDKEY, strValue: newPassword))
        dictSettings.setValue(arrSettings, forKey: KEYVALUE)
        let parameters: NSDictionary = ServiceConnector.changePassword_request_parameter(dictSettings: dictSettings)
        print("Dict JSON Formation change password \(parameters)")
        ServiceConnector.serviceConnectorPUT(SETTINGS_METHOD_NAME, inputParam: parameters as! NSMutableDictionary) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResponse = NSDictionary()
                dictResponse = responseObject! as NSDictionary
                if code == CODE200 {
                    Common.stopPinwheelProcessing()
                    appDelegate.strUserPassword = self.newPswdTextfield.text!
                    let appearance = SCLAlertView.SCLAppearance(
                        kTextFont: UIFont(name: "ProximaNova-Semibold", size: 14)!,
                        kButtonFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
                        showCloseButton: false,
                        showCircularIcon: true
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    _ = alertView.addButton("OK") {
                        appDelegate.selectedMenu = 0
                        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: INITIALVIEW)
                        let newStack = [destViewController]
                        self.navigationController!.setViewControllers(newStack, animated: false)
                    }
                    _ = alertView.showSuccess(SUCCESS, subTitle: "Your password has been changed successfully!")
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
