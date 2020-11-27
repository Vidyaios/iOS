//
//  ConstructionViewController.swift
//  AirFipro
//
//  Created by ixm1 on 17/11/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit

class ConstructionViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, BSKeyboardControlsDelegate {

    //MARK: - Variable Declaration
    @IBOutlet var constructNameTextfield: UITextField!
    @IBOutlet var weftTextfield: UITextField!
    @IBOutlet var warpTextfield: UITextField!
    @IBOutlet var minTextfield: UITextField!
    @IBOutlet var maxTextfield: UITextField!
    @IBOutlet var picksTextfield: UITextField!
    @IBOutlet var constructSubmitButton: UIButton!
    @IBOutlet var constructCancelButton: UIButton!
    @IBOutlet var constructScrollView: UIScrollView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var lblConstructionHeader: UILabel!
    
    var keyboardControls: BSKeyboardControls?
    var currentTextfield: UITextField!
    var dictResponseConstruction = NSDictionary()
    var strConstructionType: String = ""
    var constructionSystemId = ""
    var strDeptId = ""
    var strControllerId = ""
    var strConstructId = ""
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        construction_initialSetup()
        if Common.reachabilityChanged() == true {
            Common.startPinwheelProcessing()
            getConstructionBasicDetails()
        } else {
            Common.showCustomAlert(message: NWCONNECTION)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - User Defined Methods
    func construction_initialSetup() -> Void {
        constructNameTextfield.delegate = self
        weftTextfield.delegate = self
        warpTextfield.delegate = self
        minTextfield.delegate = self
        maxTextfield.delegate = self
        picksTextfield.delegate = self
        
        constructNameTextfield.clearButtonMode = .whileEditing
        weftTextfield.clearButtonMode = .whileEditing
        warpTextfield.clearButtonMode = .whileEditing
        minTextfield.clearButtonMode = .whileEditing
        maxTextfield.clearButtonMode = .whileEditing
        picksTextfield.clearButtonMode = .whileEditing
        
        let fields = NSArray(array:[constructNameTextfield, weftTextfield, warpTextfield, minTextfield, maxTextfield, picksTextfield])
        keyboardControls = BSKeyboardControls(fields: fields as [AnyObject])
        keyboardControls?.delegate = self
        
        constructNameTextfield.underlined()
        weftTextfield.underlined()
        warpTextfield.underlined()
        minTextfield.underlined()
        maxTextfield.underlined()
        picksTextfield.underlined()
        
        constructScrollView.isUserInteractionEnabled = true
        constructScrollView.delegate = self
        constructScrollView.scrollsToTop = false
        constructScrollView.contentSize = CGSize.init(width: constructScrollView.contentSize.width, height: constructSubmitButton.frame.origin.y+constructSubmitButton.frame.size.height+50)
        
        self.editButton.isHidden = true
        self.constructSubmitButton.isHidden = true
        self.constructCancelButton.isHidden = true
    }
    
    func enableConstructionWidget() -> Void {
        constructNameTextfield.isUserInteractionEnabled = true
        weftTextfield.isUserInteractionEnabled = true
        warpTextfield.isUserInteractionEnabled = true
        minTextfield.isUserInteractionEnabled = true
        maxTextfield.isUserInteractionEnabled = true
        picksTextfield.isUserInteractionEnabled = true
        constructSubmitButton.isUserInteractionEnabled = true // not need
        constructCancelButton.isUserInteractionEnabled = true // not need
        constructSubmitButton.isHidden = false
        constructCancelButton.isHidden = false
    }
    
    func disableConstructionWidget() -> Void {
        constructNameTextfield.isUserInteractionEnabled = false
        weftTextfield.isUserInteractionEnabled = false
        warpTextfield.isUserInteractionEnabled = false
        minTextfield.isUserInteractionEnabled = false
        maxTextfield.isUserInteractionEnabled = false
        picksTextfield.isUserInteractionEnabled = false
        constructSubmitButton.isUserInteractionEnabled = false // not need
        constructCancelButton.isUserInteractionEnabled = false // not need
        constructSubmitButton.isHidden = true
        constructCancelButton.isHidden = true
    }
    
    // MARK: - UITextfield Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keyboardControls?.activeField = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("\(textField.frame.origin.y)")
        self.currentTextfield = textField
        textField.underlinedBlue()
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            if self.currentTextfield == self.warpTextfield || self.currentTextfield == self.warpTextfield || self.currentTextfield == self.minTextfield || self.currentTextfield == self.maxTextfield || self.currentTextfield == self.picksTextfield {
                if Common.deviceType() == "iPhone5" {
                    self.constructScrollView.contentOffset = CGPoint(x: 0, y: CGFloat(self.currentTextfield.frame.origin.y-40))
                } else if Common.deviceType() == "iPhone6" {
                    self.constructScrollView.contentOffset = CGPoint(x: 0, y: CGFloat(self.currentTextfield.frame.origin.y-150))
                } else if Common.deviceType() == "iPhone6plus" {
                    self.constructScrollView.contentOffset = CGPoint(x: 0, y: CGFloat(self.currentTextfield.frame.origin.y-150))
                }
            }
        }, completion: { finished in
            print("view visible")
        })
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.constructScrollView.contentOffset = CGPoint.zero
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
        if textField == constructNameTextfield {
            let newLength = (textField.text?.characters.count)! + (string.characters.count) - range.length
            let inverseSet = NSCharacterSet(charactersIn:ACCEPTABLE_CHARACTERSAlphaNumeric).inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            return string == filtered && newLength <= MAX_LIMIT_NAME
        } else if textField == weftTextfield || textField == warpTextfield {
            let newLength = (textField.text?.characters.count)! + (string.characters.count) - range.length
            let inverseSet = NSCharacterSet(charactersIn:ACCEPTABLE_CHARACTERSNumbers).inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            return string == filtered && newLength <= MAX_LIMIT_THREEDIGIT
        } else if textField == minTextfield || textField == maxTextfield {
            if range.location == 0 && string == "." {
                print("empty string not allowed")
                return false
            }
            let text = (textField.text ?? "") as NSString
            let newText = text.replacingCharacters(in: range, with: string)
            if let regex = try? NSRegularExpression(pattern: "^([0-9]{0,2})((\\.)[0-9]{0,2})?$", options: .caseInsensitive) {
                return regex.numberOfMatches(in: newText, options: .reportProgress, range: NSRange(location: 0, length: (newText as NSString).length)) > 0
            }
        } else if textField == picksTextfield {
            let newLength = (textField.text?.characters.count)! + (string.characters.count) - range.length
            let inverseSet = NSCharacterSet(charactersIn:ACCEPTABLE_CHARACTERSNumbers).inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            return string == filtered && newLength <= MAX_LIMIT_TWODIGIT
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == constructNameTextfield {
            constructNameTextfield.underlined()
            constructNameTextfield.text =  constructNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if textField == weftTextfield {
            weftTextfield.underlined()
        } else if textField == warpTextfield {
            warpTextfield.underlined()
        } else if textField == minTextfield {
            minTextfield.underlined()
            if minTextfield.text != "" {
                let value = NumberFormatter().number(from: textField.text!)?.floatValue
                let str = String(format: "%05.2f", value!)
                textField.text = "\(str)"
            }
        } else if textField == maxTextfield {
            maxTextfield.underlined()
            if maxTextfield.text != "" {
                let value = NumberFormatter().number(from: textField.text!)?.floatValue
                let str = String(format: "%05.2f", value!)
                textField.text = "\(str)"
            }
        } else if textField == picksTextfield {
            picksTextfield.underlined()
        }
    }
    
    // MARK: - BSKeyboard Delegate Method
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) -> Void {
        self.constructScrollView.contentOffset = CGPoint.zero
        self.view.endEditing(true)
    }

    //MARK: - IBActions
    @IBAction func construction_widget_Action(_ sender: UIButton) {
        print("btnTag==\(sender.tag)")
        switch sender.tag {
        case 0: // back
            let _ = self.navigationController?.popViewController(animated: true)
            break
        case 1: // SUBMIT
            if constructNameTextfield.text == "" && weftTextfield.text == "" && warpTextfield.text == "" && minTextfield.text == "" && maxTextfield.text == "" && picksTextfield.text == "" {
                Common.showCustomAlert(message: ALLFIELDVALIDATION)
                return
            } else if constructNameTextfield.text == "" {
                Common.showCustomAlert(message: CONSTRUCTIONNAMEVALIDATION)
                return
            } else if weftTextfield.text == "" {
                Common.showCustomAlert(message: WEFTVALIDATION)
                return
            } else if warpTextfield.text == "" {
                Common.showCustomAlert(message: WARPVALIDATION)
                return
            } else if minTextfield.text == "" {
                Common.showCustomAlert(message: MINIMUMVALIDATION)
                return
            } else if maxTextfield.text == "" {
                Common.showCustomAlert(message: MAXIMUMVALIDATION)
                return
            } else if picksTextfield.text == "" {
                Common.showCustomAlert(message: PICKSVALIDATION)
                return
            }
            if (constructNameTextfield.text?.count)! < 5 {
                Common.showCustomAlert(message: CONSVALIDATION)
                return
            } else if weftTextfield.text == "0" || weftTextfield.text == "00" || weftTextfield.text == "000"{
                Common.showCustomAlert(message: WEFTMINVALIDATION)
                return
            } else if warpTextfield.text == "0" || warpTextfield.text == "00" || warpTextfield.text == "000" {
                Common.showCustomAlert(message: WARPMINVALIDATION)
                return
            } else if minTextfield.text == "00.00" {
                Common.showCustomAlert(message: MINIMUMLIMITVALIDATION)
                return
            } else if maxTextfield.text == "00.00" {
                Common.showCustomAlert(message: MAXIMUMLIMITVALIDATION)
                return
            } else if picksTextfield.text == "0" || picksTextfield.text == "00" {
                Common.showCustomAlert(message: PICKSLIMITVALIDATION)
                return
            }
            if strConstructionType != MACHINEACTIONADD {
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "ProximaNova-Semibold", size: 20)!,
                    kTextFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
                    kButtonFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
                    showCloseButton: false,
                    dynamicAnimatorActive: true,
                    buttonsLayout: .horizontal
                )
                let alert = SCLAlertView(appearance: appearance)
                _ = alert.addButton("OK") {
                    Common.startPinwheelProcessing()
                    self.createConstructionDetails()
                }
                _ = alert.addButton("CANCEL") {
                    print("Second button tapped")
                }
                
                let icon = SCLAlertViewStyleKit.imageOfWarning
                let color = UIColor.init(hexString: "4574B9")
                
                _ = alert.showCustom(WARNING, subTitle: Common.dynmaicPopUpMessage(strMsg: "\(constructNameTextfield.text!)", strType: CONFIRMATION), color: color, icon: icon)
                return
            }
            if Common.reachabilityChanged() == true {
                Common.startPinwheelProcessing()
                createConstructionDetails()
            } else {
                Common.showCustomAlert(message: NWCONNECTION)
            }
            break
        case 2: // CANCEL
            let _ = self.navigationController?.popViewController(animated: true)
            break
        default:
            print("default")
        }
    }
    
    @IBAction func edit_construct_action(_ sender: UIButton) {
        if (sender.currentImage == UIImage.init(named: "machineEdit")) {
            self.enableConstructionWidget()
            self.editButton.setImage(UIImage.init(named: "editUnselect"), for: .normal)
        }
    }
    
    //MARK: - API Implementation
    func getConstructionBasicDetails() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        print(oID)
        let methodName = "\(PREFERENCE_METHOD_NAME)"+QUERYMARK+GET_PARAM_ORGANIZATIONID+QUERYSYMBOL+oID+QUERYJOIN+GET_PARAM_SYSTEMID+QUERYSYMBOL+constructionSystemId+QUERYJOIN+GET_TYPE+QUERYSYMBOL+CONSTRUCTION+QUERYJOIN+GET_PARAM_CONTROLLERID+QUERYSYMBOL+strControllerId
        print(methodName)
        ServiceConnector.serviceConnectorGET(methodName) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                self.dictResponseConstruction = NSDictionary()
                self.dictResponseConstruction = responseObject! as NSDictionary
                print(self.dictResponseConstruction)
                if (code == CODE200) {
                    let results = self.dictResponseConstruction.value(forKey: RESULTS) as! NSArray
                    print(results)
                    if results.count > 0 {
                        let arrItem: NSArray = results.value(forKey: PREFERENCEITEM) as! NSArray
                        print(arrItem[0])
                        self.parseConstructionDetails(arrDetails: arrItem[0] as! NSArray)
                        self.strConstructionType = MACHINEACTIONEDIT
                        self.strConstructId = (results[0] as AnyObject).value(forKey: RID) as! String
                        print("id == \(self.strConstructId)")
                        self.editButton.setImage(UIImage.init(named: "machineEdit"), for: .normal)
                        self.disableConstructionWidget()
                        self.lblConstructionHeader.text = "CONSTRUCTION DETAILS"
                        self.editButton.isHidden = false
                    } else {
                        self.strConstructionType = MACHINEACTIONADD
                        self.enableConstructionWidget()
                    }
                    Common.stopPinwheelProcessing()
                } else if (code == CODE204) {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: NORECORDSFOUND)
                } else {
                    self.strConstructionType = MACHINEACTIONADD
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: self.dictResponseConstruction))
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }
    
    func parseConstructionDetails(arrDetails: NSArray) -> Void {
        print(arrDetails)
        print(arrDetails.count)
        let dict: NSDictionary = arrDetails[0] as! NSDictionary
        print(dict.value(forKey: RNAME) as! String)
        var arrKey = NSArray()
        arrKey = dict.value(forKey: RKEYVALUES) as! NSArray
        print("arr values \(arrKey)")
        print("arr count \(arrKey.count)")
        var dictKeyValues = NSMutableDictionary()
        dictKeyValues = Common.parseTypeCollection(strTypeCollection: MACHINETYPECOLLECTION, arrKeyValues: arrKey)
        print(dictKeyValues)
        constructNameTextfield.text = dict.value(forKey: RNAME) as? String
        weftTextfield.text = dictKeyValues.value(forKey: WEFT) as? String
        warpTextfield.text = dictKeyValues.value(forKey: WARP) as? String
        minTextfield.text = dictKeyValues.value(forKey: MINIMUM) as? String
        maxTextfield.text = dictKeyValues.value(forKey: MAXIMUM) as? String
        picksTextfield.text = dictKeyValues.value(forKey: PICKS) as? String
    }

    
    func createConstructionDetails() -> Void {
        let dictConstruction = NSMutableDictionary()
        if strConstructionType == MACHINEACTIONEDIT {
            dictConstruction.setValue(self.strConstructId, forKey: RID)
        } else {
            dictConstruction.setValue("", forKey: RID)
        }
        dictConstruction.setValue(self.strControllerId, forKey: CONTROLLERID)
        dictConstruction.setValue(self.strDeptId, forKey: DEPARTMENTID)
        dictConstruction.setValue(UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String, forKey: RORGANIZATIONID)
        dictConstruction.setValue(constructionSystemId, forKey: SYSTEMID)
        dictConstruction.setValue(CONSTRUCTION, forKey: RTYPE)
        let arrConstructionPayLoad = NSMutableArray()
        arrConstructionPayLoad.add(Common.payloadKeyValue(strKey: WEFT, strValue: weftTextfield.text!))
        arrConstructionPayLoad.add(Common.payloadKeyValue(strKey: WARP, strValue: warpTextfield.text!))
        arrConstructionPayLoad.add(Common.payloadKeyValue(strKey: MINIMUM, strValue: minTextfield.text!))
        arrConstructionPayLoad.add(Common.payloadKeyValue(strKey: MAXIMUM, strValue: maxTextfield.text!))
        arrConstructionPayLoad.add(Common.payloadKeyValue(strKey: PICKS, strValue: picksTextfield.text!))
        let dict = NSMutableDictionary()
        dict.setValue(arrConstructionPayLoad, forKey: RKEYVALUES)
        dict.setValue(constructNameTextfield.text!, forKey: RNAME)
        let arrPayLoad = NSMutableArray()
        arrPayLoad.add(dict)
        dictConstruction.setValue(arrPayLoad, forKey: RPREFERENCES)
        
        let parameters: NSDictionary = ServiceConnector.setConstructionRequestParameter(dictConstruct: dictConstruction)
        print("Dict JSON Formation add construction\(parameters)")
        
        if strConstructionType == MACHINEACTIONEDIT {
            ServiceConnector.serviceConnectorPUT(PREFERENCE_METHOD_NAME, inputParam: parameters as! NSMutableDictionary) {
                responseObject,error,statusCode in
                if (error == nil) {
                    let code: Int = statusCode!
                    NSLog("\(code)")
                    print(code)
                    var dictResponse = NSDictionary()
                    dictResponse = responseObject! as NSDictionary
                    print(dictResponse)
                    if code == CODE200 {
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
                        _ = alertView.showSuccess(SUCCESS, subTitle: Common.dynmaicPopUpMessage(strMsg: "\(self.constructNameTextfield.text!)", strType: UPDATEMESSAGE))
                    } else {
                        Common.showCustomAlert(message: NORECORDSFOUND)
                        Common.stopPinwheelProcessing()
                    }
                } else {
                    print("error = \(String(describing: error))")
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: NORECORDSFOUND)
                }
            }
        } else {
            ServiceConnector.serviceConnectorPOST(PREFERENCE_METHOD_NAME, inputParam: parameters as! NSMutableDictionary) {
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
                        _ = alertView.showSuccess(SUCCESS, subTitle: Common.dynmaicPopUpMessage(strMsg: "\(self.constructNameTextfield.text!)", strType: ADDMESSAGE))
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
    
}
