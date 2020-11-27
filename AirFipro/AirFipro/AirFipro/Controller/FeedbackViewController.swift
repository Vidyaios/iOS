//
//  FeedbackViewController.swift
//  AirFipro
//
//  Created by ixm1 on 11/22/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit

class FeedbackViewController: SliderLibViewController, BSKeyboardControlsDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    //MARK: - Variable Declaration
    @IBOutlet var orgNameTextfield: UITextField!
    @IBOutlet var contactPersonTextfield: UITextField!
    @IBOutlet var addressTextfield: UITextField!
    @IBOutlet var contactNoTextfield: UITextField!
    @IBOutlet var emailAddrTextfield: UITextField!
    @IBOutlet var feedbackTextfield: UITextField!
    @IBOutlet var feedbackScrollView: UIScrollView!
    @IBOutlet var feedbackSubmitButton: UIButton!
    @IBOutlet var feedbackMenuButton: UIButton!
    var keyboardControls: BSKeyboardControls?
    var swipeGesture = UISwipeGestureRecognizer()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        feedback_widget_configurarion()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UISwipeGestureDelegate Method
    @objc func handleSwipePreference(_ sender: UITapGestureRecognizer) {
        print("pan gesture called")
        onSlideMenuButtonPressed(sender: feedbackMenuButton)
    }
    
    //MARK: - User Defined Methods
    func feedback_widget_configurarion() -> Void {
        if UserDefaults.standard.object(forKey: "ORGNAME") as! String != ""{
            self.orgNameTextfield.text = UserDefaults.standard.object(forKey: "ORGNAME") as? String
        }
        print(UserDefaults.standard.object(forKey: FEEDBACKADDRKEY) as! String)
//        addressTextfield.text = appDelegate.dictOrgDetails.value(forKey: FEEDBACKADDRKEY)! as? String
        addressTextfield.text = UserDefaults.standard.object(forKey: FEEDBACKADDRKEY) as? String
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipePreference(_:)))
        swipeGesture.delegate = self
        swipeGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeGesture)
        
        orgNameTextfield.delegate = self
        contactPersonTextfield.delegate = self
        addressTextfield.delegate = self
        contactNoTextfield.delegate = self
        emailAddrTextfield.delegate = self
        feedbackTextfield.delegate = self
        
        orgNameTextfield.clearButtonMode = .whileEditing
        contactPersonTextfield.clearButtonMode = .whileEditing
        addressTextfield.clearButtonMode = .whileEditing
        contactNoTextfield.clearButtonMode = .whileEditing
        emailAddrTextfield.clearButtonMode = .whileEditing
        feedbackTextfield.clearButtonMode = .whileEditing

        let fields = NSArray(array:[contactNoTextfield, feedbackTextfield])
        keyboardControls = BSKeyboardControls(fields: fields as [AnyObject])
        keyboardControls?.delegate = self
        
        orgNameTextfield.underlined()
        contactPersonTextfield.underlined()
        addressTextfield.underlined()
        contactNoTextfield.underlined()
        emailAddrTextfield.underlined()
        feedbackTextfield.underlined()
        
        feedbackScrollView.isUserInteractionEnabled = true
        feedbackScrollView.delegate = self
        feedbackScrollView.scrollsToTop = false
        feedbackScrollView.contentSize = CGSize.init(width: feedbackScrollView.contentSize.width, height: feedbackSubmitButton.frame.origin.y+feedbackSubmitButton.frame.size.height+50)
    }
    
    // MARK: - UITextfield Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keyboardControls?.activeField = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("\(textField.frame.origin.y)")
        textField.underlinedBlue()
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            if textField == self.contactNoTextfield || textField == self.feedbackTextfield {
                if Common.deviceType() == "iPhone5" {
                    self.feedbackScrollView.contentOffset = CGPoint(x: 0, y: CGFloat(textField.frame.origin.y-40))
                } else if Common.deviceType() == "iPhone6" {
                    self.feedbackScrollView.contentOffset = CGPoint(x: 0, y: CGFloat(textField.frame.origin.y-150))
                } else if Common.deviceType() == "iPhone6plus" {
                    self.feedbackScrollView.contentOffset = CGPoint(x: 0, y: CGFloat(textField.frame.origin.y-150))
                }
            }
        }, completion: { finished in
            print("view visible")
        })
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.feedbackScrollView.contentOffset = CGPoint.zero
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
        if textField == contactPersonTextfield {
            let newLength = (textField.text?.characters.count)! + (string.characters.count) - range.length
            let inverseSet = NSCharacterSet(charactersIn:ACCEPTABLE_CHARACTERSAlphabets).inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            return string == filtered && newLength <= MAX_LIMIT_FNAME
        } else if textField == contactNoTextfield {
            let newLength = (textField.text?.characters.count)! + (string.characters.count) - range.length
            let inverseSet = NSCharacterSet(charactersIn:ACCEPTABLE_CHARACTERSNumbers).inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            return string == filtered && newLength <= MAX_LIMIT_PNUMBER
        } else if textField == feedbackTextfield {
            let newLength = (textField.text?.characters.count)! + (string.characters.count) - range.length
            let inverseSet = NSCharacterSet(charactersIn:ACCEPTABLE_CHARACTERSAddress).inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            return string == filtered && newLength <= MAX_LIMIT_EMAIL
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == orgNameTextfield {
            orgNameTextfield.underlined()
            orgNameTextfield.text =  orgNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if textField == contactPersonTextfield {
            contactPersonTextfield.underlined()
            contactPersonTextfield.text =  contactPersonTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if textField == addressTextfield {
            addressTextfield.underlined()
            addressTextfield.text =  addressTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if textField == contactNoTextfield {
            contactNoTextfield.underlined()
        } else if textField == emailAddrTextfield {
            emailAddrTextfield.underlined()
            emailAddrTextfield.text =  emailAddrTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if textField == feedbackTextfield {
            feedbackTextfield.underlined()
            feedbackTextfield.text =  feedbackTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    // MARK: - BSKeyboard Delegate Method
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) -> Void {
        self.feedbackScrollView.contentOffset = CGPoint.zero
        self.view.endEditing(true)
    }
    
    //MARK: - IBAction
    @IBAction func feedback_widget_action(_ sender: UIButton) {
        if let currentTextfield = feedbackTextfield {
            currentTextfield.resignFirstResponder()
        }
        self.feedbackScrollView.contentOffset = CGPoint.zero
        switch sender.tag {
        case 0: // Menu
            onSlideMenuButtonPressed(sender: sender)
            break
        case 1: // Submit
            if contactPersonTextfield.text == "" {
                Common.showCustomAlert(message: CONTACTPERSONEMPTYVALIDATION)
                return
            }
//            else if contactNoTextfield.text == "" {
//                Common.showCustomAlert(message: CONTACTNUMBEREMPTYVALIDATION)
//                return
//            }
            else if feedbackTextfield.text == "" {
                Common.showCustomAlert(message: FEEDBACKVALIDATION)
                return
            } else if contactPersonTextfield.text != "" && (contactPersonTextfield.text?.count)! < 4 {
                Common.showCustomAlert(message: CONTACTPERSONVALIDATION)
                return
            } else if emailAddrTextfield.text != "" && Common.emailValidation(strMailString: emailAddrTextfield.text!) == "NO" {
                Common.showCustomAlert(message: INVALIDEMAILVALIDATION)
                return
            }
            if Common.reachabilityChanged() == true {
                Common.startPinwheelProcessing()
                self.userFeedback_Service()
            } else {
                Common.showCustomAlert(message: NWCONNECTION)
            }
            break
        default:
            print("default")
        }
    }
    
    
    //MARK: - API Implementation
    func userFeedback_Service() {
        let dictFeedback = NSMutableDictionary()
        dictFeedback.setValue(FEEDBACKTYPEKEY, forKey: RTYPE)
        let arrFeedback = NSMutableArray()
        arrFeedback.add(Common.payloadKeyValue(strKey: FEEDBACKNAMEKEY, strValue: contactPersonTextfield.text!))
        arrFeedback.add(Common.payloadKeyValue(strKey: FEEDBACKADDRKEY, strValue: addressTextfield.text!))
        arrFeedback.add(Common.payloadKeyValue(strKey: FEEDBACKORGNAMEKEY, strValue: orgNameTextfield.text!))
        arrFeedback.add(Common.payloadKeyValue(strKey: FEEDBACKORGNOKEY, strValue: contactNoTextfield.text!))
        arrFeedback.add(Common.payloadKeyValue(strKey: EMAILADDRKEY, strValue: emailAddrTextfield.text!))
        arrFeedback.add(Common.payloadKeyValue(strKey: FEEDBACKCONTENTKEY, strValue: feedbackTextfield.text!))
        dictFeedback.setValue(arrFeedback, forKey: KEYVALUE)
        let parameters: NSDictionary = ServiceConnector.changePassword_request_parameter(dictSettings: dictFeedback)
        print("Dict JSON Formation feedback \(parameters)")
        ServiceConnector.serviceConnectorPOST(FEEDBACK_METHOD_NAME, inputParam: parameters as! NSMutableDictionary) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResponse = NSDictionary()
                dictResponse = responseObject! as NSDictionary
                if code == CODE201 {
                    Common.stopPinwheelProcessing()
                    let appearance = SCLAlertView.SCLAppearance (
                        kTextFont: UIFont(name: "ProximaNova-Semibold", size: 14)!,
                        kButtonFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
                        showCloseButton: false,
                        showCircularIcon: true
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    _ = alertView.addButton("OK") {
                        self.appDelegate.selectedMenu = 0
                        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: DASHBOARDVIEW)
                        let newStack = [destViewController]
                        self.navigationController!.setViewControllers(newStack, animated: false)
                    }
                    _ = alertView.showSuccess(SUCCESS, subTitle: FEEDBACKSUCCESS)
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
