//
//  NotificationViewController.swift
//  AirFipro
//
//  Created by ixm1 on 11/17/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITextFieldDelegate,UIGestureRecognizerDelegate, BSKeyboardControlsDelegate {

    //MARK: - Varaiable Declaration
    @IBOutlet var lblNoti1: UILabel!
    @IBOutlet var lblNoti2: UILabel!
    @IBOutlet var lblNoti3: UILabel!
    @IBOutlet var lblNoti4: UILabel!
    @IBOutlet var lblNoti5: UILabel!
    @IBOutlet var lblNoti6: UILabel!
    @IBOutlet var lblNoti7: UILabel!
    @IBOutlet var lblNoti8: UILabel!
    
    @IBOutlet var lblRangeclr1: UILabel!
    @IBOutlet var lblRangeclr2: UILabel!
    @IBOutlet var lblRangeclr3: UILabel!
    @IBOutlet var lblRangeclr4: UILabel!
    @IBOutlet var lblRangeclr5: UILabel!
    @IBOutlet var lblRangeclr6: UILabel!
    @IBOutlet var lblRangeclr7: UILabel!
    @IBOutlet var lblRangeclr8: UILabel!
    
    @IBOutlet var txtfldRangemin1: UITextField!
    @IBOutlet var txtfldRangemax1: UITextField!
    @IBOutlet var txtfldRangemin2: UITextField!
    @IBOutlet var txtfldRangemax2: UITextField!
    @IBOutlet var txtfldRangemin3: UITextField!
    @IBOutlet var txtfldRangemax3: UITextField!
    @IBOutlet var txtfldRangemin4: UITextField!
    @IBOutlet var txtfldRangemax4: UITextField!
    @IBOutlet var txtfldRangemin5: UITextField!
    @IBOutlet var txtfldRangemax5: UITextField!
    @IBOutlet var txtfldRangemin6: UITextField!
    @IBOutlet var txtfldRangemax6: UITextField!
    @IBOutlet var txtfldRangemin7: UITextField!
    @IBOutlet var txtfldRangemax7: UITextField!
    @IBOutlet var txtfldRangemin8: UITextField!
    @IBOutlet var txtfldRangemax8: UITextField!
    
    var currentTextfield: UITextField!
    
    @IBOutlet var btnRemarks1: UIButton!
    @IBOutlet var btnRemarks2: UIButton!
    @IBOutlet var btnRemarks3: UIButton!
    @IBOutlet var btnRemarks4: UIButton!
    @IBOutlet var btnRemarks5: UIButton!
    @IBOutlet var btnRemarks6: UIButton!
    @IBOutlet var btnRemarks7: UIButton!
    @IBOutlet var btnRemarks8: UIButton!
    
    @IBOutlet var btnMenuNotification: UIButton!
    @IBOutlet var notificationSwitch: UISwitch!
    
    var dictResponseNotification = NSDictionary()
    var keyboardControls: BSKeyboardControls?
    var arrAllNotiList = NSMutableArray()
    var arrUpdatedNotiList = NSMutableArray()
    var strNotiType = ""
    var strId = ""
    
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        widgetConfigurationNotification()
        if Common.reachabilityChanged() == true {
            Common.startPinwheelProcessing()
            getPreferenceBasicDetails()
        } else {
            Common.showCustomAlert(message: NWCONNECTION)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - User Defined Method
    func widgetConfigurationNotification() -> Void {
        txtfldRangemin1.delegate = self
        txtfldRangemin2.delegate = self
        txtfldRangemin3.delegate = self
        txtfldRangemin4.delegate = self
        txtfldRangemin5.delegate = self
        txtfldRangemin6.delegate = self
        txtfldRangemin7.delegate = self
        txtfldRangemin8.delegate = self
        txtfldRangemax1.delegate = self
        txtfldRangemax2.delegate = self
        txtfldRangemax3.delegate = self
        txtfldRangemax4.delegate = self
        txtfldRangemax5.delegate = self
        txtfldRangemax6.delegate = self
        txtfldRangemax7.delegate = self
        txtfldRangemax8.delegate = self
        
        txtfldRangemin1.clearButtonMode = .whileEditing
        txtfldRangemin2.clearButtonMode = .whileEditing
        txtfldRangemin3.clearButtonMode = .whileEditing
        txtfldRangemin4.clearButtonMode = .whileEditing
        txtfldRangemin5.clearButtonMode = .whileEditing
        txtfldRangemin6.clearButtonMode = .whileEditing
        txtfldRangemin7.clearButtonMode = .whileEditing
        txtfldRangemin8.clearButtonMode = .whileEditing
        txtfldRangemax1.clearButtonMode = .whileEditing
        txtfldRangemax2.clearButtonMode = .whileEditing
        txtfldRangemax3.clearButtonMode = .whileEditing
        txtfldRangemax4.clearButtonMode = .whileEditing
        txtfldRangemax5.clearButtonMode = .whileEditing
        txtfldRangemax6.clearButtonMode = .whileEditing
        txtfldRangemax7.clearButtonMode = .whileEditing
        txtfldRangemax8.clearButtonMode = .whileEditing
        
        let fields = NSArray(array:[txtfldRangemin1, txtfldRangemax1, txtfldRangemin2, txtfldRangemax2, txtfldRangemin3, txtfldRangemax3, txtfldRangemin4, txtfldRangemax4, txtfldRangemin5, txtfldRangemax5, txtfldRangemin6, txtfldRangemax6, txtfldRangemin7, txtfldRangemax7, txtfldRangemin8, txtfldRangemax8])
        keyboardControls = BSKeyboardControls(fields: fields as [AnyObject])
        keyboardControls?.delegate = self
        
        lblRangeclr1.layer.masksToBounds = true
        lblRangeclr1.layer.cornerRadius = lblRangeclr1.frame.width/2
        
        lblRangeclr2.layer.masksToBounds = true
        lblRangeclr2.layer.cornerRadius = lblRangeclr2.frame.width/2
        
        lblRangeclr3.layer.masksToBounds = true
        lblRangeclr3.layer.cornerRadius = lblRangeclr3.frame.width/2
        
        lblRangeclr4.layer.masksToBounds = true
        lblRangeclr4.layer.cornerRadius = lblRangeclr4.frame.width/2
        
        lblRangeclr5.layer.masksToBounds = true
        lblRangeclr5.layer.cornerRadius = lblRangeclr5.frame.width/2
        
        lblRangeclr6.layer.masksToBounds = true
        lblRangeclr6.layer.cornerRadius = lblRangeclr6.frame.width/2
        
        lblRangeclr7.layer.masksToBounds = true
        lblRangeclr7.layer.cornerRadius = lblRangeclr7.frame.width/2
        
        lblRangeclr8.layer.masksToBounds = true
        lblRangeclr8.layer.cornerRadius = lblRangeclr8.frame.width/2
        
        print(appDelegate.preferencePermission)
        notificationSwitch.setOn(false, animated: true)
        notificationSwitch.isSelected = false
        notificationSwitch.thumbTintColor = UIColor.init(hexString: "FFFFFF")
        notificationSwitch.backgroundColor = UIColor.init(hexString: "A0AAB9")
        notificationSwitch.tintColor = UIColor.init(hexString: "A0AAB9")
        notificationSwitch.layer.masksToBounds = true
        notificationSwitch.layer.cornerRadius = 16.0

        if appDelegate.preferencePermission == "YES" {
            notificationSwitch.setOn(true, animated: true)
            notificationSwitch.isSelected = true
            notificationSwitch.onTintColor = UIColor.init(hexString: "4574B8")
        } else {
            notificationSwitch.backgroundColor = UIColor.init(hexString: "A0AAB9")
        }
        btnRemarks1.isUserInteractionEnabled = false
        btnRemarks2.isUserInteractionEnabled = false
        btnRemarks3.isUserInteractionEnabled = false
        btnRemarks4.isUserInteractionEnabled = false
        btnRemarks5.isUserInteractionEnabled = false
        btnRemarks6.isUserInteractionEnabled = false
        btnRemarks7.isUserInteractionEnabled = false
        btnRemarks8.isUserInteractionEnabled = false
    }
    
    //MARK: - UITextfield Delegate Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keyboardControls?.activeField = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("\(textField.frame.origin.y)")
        self.currentTextfield = textField
        currentTextfield.underlinedWhite()
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
            if textField == self.txtfldRangemin6 || textField == self.txtfldRangemin7 || textField == self.txtfldRangemin8 || textField == self.txtfldRangemax6 || textField == self.txtfldRangemax7 || textField == self.txtfldRangemax8 || textField == self.txtfldRangemin5 || textField == self.txtfldRangemax5 {
                self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: -170, width: self.view.frame.size.width, height: self.view.frame.size.height)
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
            let inverseSet = NSCharacterSet(charactersIn:ACCEPTABLE_CHARACTERSDECIMAL).inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            return string == filtered && newLength <= MAX_LIMIT_NUMBER
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            let value = NumberFormatter().number(from: textField.text!)?.floatValue
            let str = String(format: "%05.2f", value!)
            textField.text = "\(str)"
            print(textField.text!)
        }
    }
    
    func checkFromToRangeValidation(min: String, max: String, currentText: UITextField) {
        if min == "" {
            currentText.text = ""
            Common.showCustomAlert(message: NOTIFICATIONTOVALIDATION)
            return
        } else if max <= min {
            currentText.text = ""
            Common.showCustomAlert(message: NOTIFICATIONVALIDATION)
            return
        }
    }
    
    // MARK: - BSKeyboard Delegate Method
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) -> Void {
        self.view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
        self.view.endEditing(true)
    }
    
    func notificationWidgetValidation() {
        if txtfldRangemin1.text == "" {
            txtfldRangemin1.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemin2.text == "" {
            txtfldRangemin2.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemin3.text == "" {
            txtfldRangemin3.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemin4.text == "" {
            txtfldRangemin4.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemin5.text == "" {
            txtfldRangemin5.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemin6.text == "" {
            txtfldRangemin6.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemin7.text == "" {
            txtfldRangemin7.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemin8.text == "" {
            txtfldRangemin8.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemax1.text == "" {
            txtfldRangemax1.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemax2.text == "" {
            txtfldRangemax2.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemax3.text == "" {
            txtfldRangemax3.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemax4.text == "" {
            txtfldRangemax4.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemax5.text == "" {
            txtfldRangemax5.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemax6.text == "" {
            txtfldRangemax6.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemax7.text == "" {
            txtfldRangemax7.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemax8.text == "" {
            txtfldRangemax8.underlinedRed()
            Common.showCustomAlert(message: ALLFIELDVALIDATION)
            return
        } else if txtfldRangemax1.text! < txtfldRangemin1.text! {
            txtfldRangemax1.underlinedRed()
            Common.showCustomAlert(message: NOTIFICATIONVALIDATION)
            return
        } else if txtfldRangemax2.text! < txtfldRangemin2.text! {
            txtfldRangemax2.underlinedRed()
            Common.showCustomAlert(message: NOTIFICATIONVALIDATION)
            return
        } else if txtfldRangemax3.text! < txtfldRangemin3.text! {
            txtfldRangemax3.underlinedRed()
            Common.showCustomAlert(message: NOTIFICATIONVALIDATION)
            return
        } else if txtfldRangemax4.text! < txtfldRangemin4.text! {
            txtfldRangemax4.underlinedRed()
            Common.showCustomAlert(message: NOTIFICATIONVALIDATION)
            return
        } else if txtfldRangemax5.text! < txtfldRangemin5.text! {
            txtfldRangemax5.underlinedRed()
            Common.showCustomAlert(message: NOTIFICATIONVALIDATION)
            return
        } else if txtfldRangemax6.text! < txtfldRangemin6.text! {
            txtfldRangemax6.underlinedRed()
            Common.showCustomAlert(message: NOTIFICATIONVALIDATION)
            return
        } else if txtfldRangemax7.text! < txtfldRangemin7.text! {
            txtfldRangemax7.underlinedRed()
            Common.showCustomAlert(message: NOTIFICATIONVALIDATION)
            return
        } else if txtfldRangemax8.text! < txtfldRangemin8.text! {
            txtfldRangemax8.underlinedRed()
            Common.showCustomAlert(message: NOTIFICATIONVALIDATION)
            return
        }
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
            self.createNotificationDetails()
        }
        _ = alert.addButton("CANCEL") {
            print("Second button tapped")
        }
        
        let icon = SCLAlertViewStyleKit.imageOfWarning
        let color = UIColor.init(hexString: "4574B9")
        
        _ = alert.showCustom(WARNING, subTitle: "Are you sure you want to update Notification details?", color: color, icon: icon)
    }
    
    
    //MARK: - IBActions
    @IBAction func notification_widget_Action(_ sender: UIButton) {
        let tempArray: NSArray = UserDefaults.standard.array(forKey: SENSORNOTIFICATION)! as NSArray
        arrAllNotiList = tempArray.mutableCopy() as! NSMutableArray
        print(arrAllNotiList)
        print("btnTag==\(sender.tag)")
        view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(view.frame.size.width), height: CGFloat(view.frame.size.height))
        switch sender.tag {
        case 0: // Menu
            if let currentTextfield = currentTextfield {
                currentTextfield.resignFirstResponder()
            }
            let _ = self.navigationController?.popViewController(animated: true)
            break
        case 1: // SUBMIT
            notificationWidgetValidation()
            break
        case 2: // CANCEL
            break
        case 3: // Remarks Content 1
            print(arrAllNotiList)
            Common.showCustomAlertWithHeader(header: (arrAllNotiList[0] as AnyObject).object(forKey: ALERTTYPE) as! String, message: (arrAllNotiList[0] as AnyObject).object(forKey: RDESCRIPTION) as! String)
            break;
        case 4: // Remarks Content 2
            Common.showCustomAlertWithHeader(header: (arrAllNotiList[1] as AnyObject).object(forKey: ALERTTYPE) as! String, message: (arrAllNotiList[1] as AnyObject).object(forKey: RDESCRIPTION) as! String)
            break;
        case 5: // Remarks Content 3
            Common.showCustomAlertWithHeader(header: (arrAllNotiList[2] as AnyObject).object(forKey: ALERTTYPE) as! String, message: (arrAllNotiList[2] as AnyObject).object(forKey: RDESCRIPTION) as! String)
            break;
        case 6: // Remarks Content 4
            Common.showCustomAlertWithHeader(header: (arrAllNotiList[3] as AnyObject).object(forKey: ALERTTYPE) as! String, message: (arrAllNotiList[3] as AnyObject).object(forKey: RDESCRIPTION) as! String)
            break;
        case 7: // Remarks Content 5
            Common.showCustomAlertWithHeader(header: (arrAllNotiList[4] as AnyObject).object(forKey: ALERTTYPE) as! String, message: (arrAllNotiList[4] as AnyObject).object(forKey: RDESCRIPTION) as! String)
            break;
        case 8: // Remarks Content 6
            Common.showCustomAlertWithHeader(header: (arrAllNotiList[5] as AnyObject).object(forKey: ALERTTYPE) as! String, message: (arrAllNotiList[5] as AnyObject).object(forKey: RDESCRIPTION) as! String)
            break;
        case 9: // Remarks Content 7
            Common.showCustomAlertWithHeader(header: (arrAllNotiList[6] as AnyObject).object(forKey: ALERTTYPE) as! String, message: (arrAllNotiList[6] as AnyObject).object(forKey: RDESCRIPTION) as! String)
            break;
        case 10: // Remarks Content 8
            Common.showCustomAlertWithHeader(header: (arrAllNotiList[7] as AnyObject).object(forKey: ALERTTYPE) as! String, message: (arrAllNotiList[7] as AnyObject).object(forKey: RDESCRIPTION) as! String)
            break;
        default:
            print("default")
        }
    }
    
    @IBAction func notificationSwitch_Action(_ sender: UISwitch) {
        if sender.isOn && !sender.isSelected {
            print("switch on")
            sender.setOn(true, animated: true)
            sender.isSelected = true
            notificationSwitch.onTintColor = UIColor.init(hexString: "4574B8")
            if Common.reachabilityChanged() == true {
                Common.startPinwheelProcessing()
                changeNoti_OnOffStatus_Service(strNotiStatus: "ACTIVE")
            } else {
                Common.showCustomAlert(message: NWCONNECTION)
                notificationSwitch.backgroundColor = UIColor.init(hexString: "A0AAB9")
            }
        } else if !sender.isOn && sender.isSelected {
            print("switch off")
            sender.setOn(false, animated: true)
            sender.isSelected = false
            notificationSwitch.backgroundColor = UIColor.init(hexString: "A0AAB9")
            if Common.reachabilityChanged() == true {
                Common.startPinwheelProcessing()
                changeNoti_OnOffStatus_Service(strNotiStatus: "BLOCKED")
            } else {
                Common.showCustomAlert(message: NWCONNECTION)
                notificationSwitch.onTintColor = UIColor.init(hexString: "4574B8")
            }
        }
    }

    
    //MARK: - API Implementation
    func getPreferenceBasicDetails() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        print(oID)
        let methodName = "\(PREFERENCE_METHOD_NAME)"+QUERYMARK+GET_PARAM_ORGANIZATIONID+QUERYSYMBOL+oID+QUERYJOIN+GET_TYPE+QUERYSYMBOL+PREFERENCETYPE
        print(methodName)
        ServiceConnector.serviceConnectorGET(methodName) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                self.dictResponseNotification = NSDictionary()
                self.dictResponseNotification = responseObject! as NSDictionary
                print(self.dictResponseNotification)
                if (code == CODE200) {
                    let results = self.dictResponseNotification.value(forKey: RESULTS) as! NSArray
                    print(results)
                    if results.count > 0 {
                        self.strId = (results[0] as AnyObject).value(forKey: RID) as! String
                        print("id == \(self.strId)")
                        let arrItem: NSArray = results.value(forKey: PREFERENCEITEM) as! NSArray
                        print(arrItem[0])
                        if arrItem.count > 0 {
                            self.parseNotificationList(arrNotiList: arrItem[0] as! NSArray)
                        }
                        self.strNotiType = MACHINEACTIONEDIT
                    } else {
                        let tempArray: NSArray = UserDefaults.standard.array(forKey: SENSORNOTIFICATION)! as NSArray
                        let arrSensorList = tempArray.mutableCopy() as! NSMutableArray
                        for index in 0 ..< arrSensorList.count {
                            self.parseNotificationDetails(index: index, dictKeyValues: arrSensorList[index] as! NSMutableDictionary)
                        }
                        self.strNotiType = MACHINEACTIONADD
                    }
                    Common.stopPinwheelProcessing()
                } else if (code == CODE204) {
                    self.strNotiType = MACHINEACTIONADD
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: NORECORDSFOUND)
                } else {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: self.dictResponseNotification))
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }

    func parseNotificationList(arrNotiList: NSArray) -> Void {
        arrAllNotiList = NSMutableArray()
        print(arrNotiList)
        print(arrNotiList.count)
        for index in 0 ..< arrNotiList.count {
            let dictNoti: NSDictionary = arrNotiList[index] as! NSDictionary
            print(dictNoti.value(forKey: RNAME) as! String)
            var arrNotiKey = NSArray()
            arrNotiKey = dictNoti.value(forKey: RKEYVALUES) as! NSArray
            print("arr values \(arrNotiKey)")
            print("arr count \(arrNotiKey.count)")
            var dictNotiKeyValues = NSMutableDictionary()
            dictNotiKeyValues = Common.parseTypeCollection(strTypeCollection: MACHINETYPECOLLECTION, arrKeyValues: arrNotiKey)
            print(dictNotiKeyValues)
            dictNotiKeyValues.setValue(dictNoti.value(forKey: RNAME) as! String, forKey: RNAME)
            arrAllNotiList.add(dictNotiKeyValues)
            print(arrAllNotiList)
            appDelegate.arrDeptNotiList = arrAllNotiList
            UserDefaults.standard.setValue(arrAllNotiList, forKey: SENSORNOTIFICATION)
            parseNotificationDetails(index: index, dictKeyValues: dictNotiKeyValues)
        }
    }

    func parseNotificationDetails(index: Int, dictKeyValues: NSMutableDictionary) -> Void {
        print(dictKeyValues)
        let fromvalue = NumberFormatter().number(from: (dictKeyValues.value(forKey: RANGEFROM) as? String)!)?.floatValue
        let tovalue = NumberFormatter().number(from: (dictKeyValues.value(forKey: RANGETO) as? String)!)?.floatValue
        var strFrom = "", strTo = ""
        if fromvalue != nil {
            strFrom = String(format: "%05.2f", fromvalue!)
        }
        if tovalue != nil {
            strTo = String(format: "%05.2f", tovalue!)
        }
        if index == 0 {
            lblNoti1.text = dictKeyValues.value(forKey: RNAME) as? String
            txtfldRangemin1.text = strFrom
            txtfldRangemax1.text = strTo
            lblRangeclr1.backgroundColor = UIColor.init(hexString: dictKeyValues.value(forKey: COLORCODE) as! String)
            if dictKeyValues.value(forKey: RDESCRIPTION) as! String != "" {
                btnRemarks1.setImage(UIImage.init(named: "shiftwisePreviewSelected"), for: .normal)
                btnRemarks1.isUserInteractionEnabled = true
            }
        } else if index == 1 {
            lblNoti2.text = dictKeyValues.value(forKey: RNAME) as? String
            txtfldRangemin2.text = strFrom
            txtfldRangemax2.text = strTo
            lblRangeclr2.backgroundColor = UIColor.init(hexString: dictKeyValues.value(forKey: COLORCODE) as! String)
            if dictKeyValues.value(forKey: RDESCRIPTION) as! String != "" {
                btnRemarks2.setImage(UIImage.init(named: "shiftwisePreviewSelected"), for: .normal)
                btnRemarks2.isUserInteractionEnabled = true
            }
        } else if index == 2 {
            lblNoti3.text = dictKeyValues.value(forKey: RNAME) as? String
            txtfldRangemin3.text = strFrom
            txtfldRangemax3.text = strTo
            lblRangeclr3.backgroundColor = UIColor.init(hexString: dictKeyValues.value(forKey: COLORCODE) as! String)
            if dictKeyValues.value(forKey: RDESCRIPTION) as! String != "" {
                btnRemarks3.setImage(UIImage.init(named: "shiftwisePreviewSelected"), for: .normal)
                btnRemarks3.isUserInteractionEnabled = true
            }
        } else if index == 3 {
            lblNoti4.text = dictKeyValues.value(forKey: RNAME) as? String
            txtfldRangemin4.text = strFrom
            txtfldRangemax4.text = strTo
            lblRangeclr4.backgroundColor = UIColor.init(hexString: dictKeyValues.value(forKey: COLORCODE) as! String)
            if dictKeyValues.value(forKey: RDESCRIPTION) as! String != "" {
                btnRemarks4.setImage(UIImage.init(named: "shiftwisePreviewSelected"), for: .normal)
                btnRemarks4.isUserInteractionEnabled = true
            }
        } else if index == 4 {
            lblNoti5.text = dictKeyValues.value(forKey: RNAME) as? String
            txtfldRangemin5.text = strFrom
            txtfldRangemax5.text = strTo
            lblRangeclr5.backgroundColor = UIColor.init(hexString: dictKeyValues.value(forKey: COLORCODE) as! String)
            if dictKeyValues.value(forKey: RDESCRIPTION) as! String != "" {
                btnRemarks5.setImage(UIImage.init(named: "shiftwisePreviewSelected"), for: .normal)
                btnRemarks5.isUserInteractionEnabled = true
            }
        } else if index == 5 {
            lblNoti6.text = dictKeyValues.value(forKey: RNAME) as? String
            txtfldRangemin6.text = strFrom
            txtfldRangemax6.text = strTo
            lblRangeclr6.backgroundColor = UIColor.init(hexString: dictKeyValues.value(forKey: COLORCODE) as! String)
            if dictKeyValues.value(forKey: RDESCRIPTION) as! String != "" {
                btnRemarks6.setImage(UIImage.init(named: "shiftwisePreviewSelected"), for: .normal)
                btnRemarks6.isUserInteractionEnabled = true
            }
        } else if index == 6 {
            lblNoti7.text = dictKeyValues.value(forKey: RNAME) as? String
            txtfldRangemin7.text = strFrom
            txtfldRangemax7.text = strTo
            lblRangeclr7.backgroundColor = UIColor.init(hexString: dictKeyValues.value(forKey: COLORCODE) as! String)
            if dictKeyValues.value(forKey: RDESCRIPTION) as! String != "" {
                btnRemarks7.setImage(UIImage.init(named: "shiftwisePreviewSelected"), for: .normal)
                btnRemarks7.isUserInteractionEnabled = true
            }
        } else if index == 7 {
            lblNoti8.text = dictKeyValues.value(forKey: RNAME) as? String
            txtfldRangemin8.text = strFrom
            txtfldRangemax8.text = strTo
            lblRangeclr8.backgroundColor = UIColor.init(hexString: dictKeyValues.value(forKey: COLORCODE) as! String)
            if dictKeyValues.value(forKey: RDESCRIPTION) as! String != "" {
                btnRemarks8.setImage(UIImage.init(named: "shiftwisePreviewSelected"), for: .normal)
                btnRemarks8.isUserInteractionEnabled = true
            }
        }
    }
    
    func createNotificationDetails() {
        let dict = NSMutableDictionary()
        if strNotiType == MACHINEACTIONEDIT {
            dict.setValue(self.strId, forKey: RID)
        } else {
            dict.setValue("", forKey: RID)
        }
        dict.setValue(appDelegate.deptId, forKey: DEPARTMENTID)
        dict.setValue(UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String, forKey: RORGANIZATIONID)
        dict.setValue("", forKey: SYSTEMID)
        dict.setValue("", forKey: CONTROLLERID)
        dict.setValue(SENSORNOTIFICATION, forKey: RTYPE)
        arrUpdatedNotiList = NSMutableArray()
        for index in 0 ..< 8 {
            if index == 0 {
                formNotificationKeyValues(strFromRange: txtfldRangemin1.text!, strToRange: txtfldRangemax1.text!, index: index)
            } else if index == 1 {
                formNotificationKeyValues(strFromRange: txtfldRangemin2.text!, strToRange: txtfldRangemax2.text!, index: index)
            } else if index == 2 {
                formNotificationKeyValues(strFromRange: txtfldRangemin3.text!, strToRange: txtfldRangemax3.text!, index: index)
            } else if index == 3 {
                formNotificationKeyValues(strFromRange: txtfldRangemin4.text!, strToRange: txtfldRangemax4.text!, index: index)
            } else if index == 4 {
                formNotificationKeyValues(strFromRange: txtfldRangemin5.text!, strToRange: txtfldRangemax5.text!, index: index)
            } else if index == 5 {
               formNotificationKeyValues(strFromRange: txtfldRangemin6.text!, strToRange: txtfldRangemax6.text!, index: index)
            } else if index == 6 {
                formNotificationKeyValues(strFromRange: txtfldRangemin7.text!, strToRange: txtfldRangemax7.text!, index: index)
            } else if index == 7 {
                formNotificationKeyValues(strFromRange: txtfldRangemin8.text!, strToRange: txtfldRangemax8.text!, index: index)
            }
        }
        print("final array ==\(arrUpdatedNotiList)")
        dict.setValue(arrUpdatedNotiList, forKey: RPREFERENCES)
        let parameters: NSDictionary = ServiceConnector.setNotificationRequestParameter(dictNotification: dict)
        print("Dict JSON Formation add notification\(parameters)")
        
        if strNotiType == MACHINEACTIONEDIT {
            ServiceConnector.serviceConnectorPUT(PREFERENCE_METHOD_NAME, inputParam: parameters as! NSMutableDictionary) {
                responseObject,error,statusCode in
                if (error == nil) {
                    let code: Int = statusCode!
                    NSLog("\(code)")
                    print(code)
                    var dictResponse = NSDictionary()
                    dictResponse = responseObject! as NSDictionary
                    if code == CODE200 {
                        let results = dictResponse.value(forKey: RESULTS) as! NSDictionary
                        print(results)
                        if results.count > 0 {
                            self.updateNotificationList(results: results)
                        }
                        Common.stopPinwheelProcessing()
                        _ = SCLAlertView().showInfo(SUCCESS, subTitle: "Notification details has been updated successfully!")
                    } else {
                        Common.stopPinwheelProcessing()
                        Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: dictResponse))
                    }
                } else {
                    print("error = \(String(describing: error))")
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: error! as String)
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
                        let results = dictResponse.value(forKey: RESULTS) as! NSDictionary
                        print(results)
                        if results.count > 0 {
                            self.updateNotificationList(results: results)
                        }
                        Common.stopPinwheelProcessing()
                        _ = SCLAlertView().showInfo(SUCCESS, subTitle: "Notification details has been updated successfully!")
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
    
    func updateNotificationList(results: NSDictionary) {
        let arrItem: NSArray = results.value(forKey: PREFERENCEITEM) as! NSArray
        print(arrItem)
        if arrItem.count > 0 {
            let arrTempList = NSMutableArray()
            for index in 0 ..< arrItem.count {
                let dictNoti: NSDictionary = arrItem[index] as! NSDictionary
                print(dictNoti.value(forKey: RNAME) as! String)
                var arrNotiKey = NSArray()
                arrNotiKey = dictNoti.value(forKey: RKEYVALUES) as! NSArray
                print("arr values \(arrNotiKey)")
                print("arr count \(arrNotiKey.count)")
                var dictNotiKeyValues = NSMutableDictionary()
                dictNotiKeyValues = Common.parseTypeCollection(strTypeCollection: MACHINETYPECOLLECTION, arrKeyValues: arrNotiKey)
                print(dictNotiKeyValues)
                dictNotiKeyValues.setValue(dictNoti.value(forKey: RNAME) as! String, forKey: RNAME)
                arrTempList.add(dictNotiKeyValues)
            }
            print(arrTempList)
            appDelegate.arrDeptNotiList = arrTempList
            UserDefaults.standard.setValue(arrTempList, forKey: SENSORNOTIFICATION)
        }
    }
    
    func formNotificationKeyValues(strFromRange: String, strToRange: String, index: Int)  {
        var arrSensorList = NSMutableArray()
        if arrAllNotiList.count > 0 {
            arrSensorList = arrAllNotiList as NSMutableArray
        } else {
            let tempArray: NSArray = UserDefaults.standard.array(forKey: SENSORNOTIFICATION)! as NSArray
            arrSensorList = tempArray.mutableCopy() as! NSMutableArray
        }
        let arrKeyValues = NSMutableArray()
        arrKeyValues.add(Common.payloadKeyValue(strKey: RANGEFROM, strValue: strFromRange))
        arrKeyValues.add(Common.payloadKeyValue(strKey: RANGETO, strValue: strToRange))
        arrKeyValues.add(Common.payloadKeyValue(strKey: ALERTTYPE, strValue: (arrSensorList[index] as AnyObject).value(forKey: ALERTTYPE) as! String))
        arrKeyValues.add(Common.payloadKeyValue(strKey: RDESCRIPTION, strValue: (arrSensorList[index] as AnyObject).value(forKey: RDESCRIPTION) as! String))
        arrKeyValues.add(Common.payloadKeyValue(strKey: COLORNAME, strValue: (arrSensorList[index] as AnyObject).value(forKey: COLORNAME) as! String))
        arrKeyValues.add(Common.payloadKeyValue(strKey: COLORCODE, strValue: (arrSensorList[index] as AnyObject).value(forKey: COLORCODE) as! String))
        arrKeyValues.add(Common.payloadKeyValue(strKey: STATE, strValue: (arrSensorList[index] as AnyObject).value(forKey: STATE) as! String))
        let dict = NSMutableDictionary()
        dict.setValue(arrKeyValues, forKey: RKEYVALUES)
        dict.setValue((arrSensorList[index] as AnyObject).value(forKey: RNAME) as! String, forKey: RNAME)
        arrUpdatedNotiList.add(dict)
        print(arrUpdatedNotiList)
    }
    
    func changeNoti_OnOffStatus_Service(strNotiStatus: String) {
        let dictNotiStatus = NSMutableDictionary()
        dictNotiStatus.setValue(UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String, forKey: RORGANIZATIONID)
        dictNotiStatus.setValue(UserDefaults.standard.object(forKey: RUSERID) as! String, forKey: RUSERID)
        let arrKeyValues = NSMutableArray()
        arrKeyValues.add(Common.payloadKeyValue(strKey: NOTIFICATIONSTATE, strValue: strNotiStatus))
        dictNotiStatus.setValue(arrKeyValues, forKey: KEYVALUE)
       
        let parameters: NSDictionary = ServiceConnector.setNotiOnOffStatusRequestParameter(dictNotification: dictNotiStatus)
        print("Dict JSON Formation on/off notification\(parameters)")

        ServiceConnector.serviceConnectorPUT(NOTIFICATION_METHOD_NAME, inputParam: parameters as! NSMutableDictionary) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResponse = NSDictionary()
                dictResponse = responseObject! as NSDictionary
                if code == CODE200 {
                    if strNotiStatus == "BLOCKED" {
                        appDelegate.preferencePermission = "NO"
                    } else {
                        appDelegate.preferencePermission = "YES"
                    }
                    Common.stopPinwheelProcessing()
                } else {
                    if strNotiStatus == "BLOCKED" {
                        self.notificationSwitch.setOn(true, animated: true)
                        self.notificationSwitch.isSelected = true
                        self.notificationSwitch.onTintColor = UIColor.init(hexString: "4574B8")
                    } else {
                        self.notificationSwitch.setOn(false, animated: true)
                        self.notificationSwitch.isSelected = false
                        self.notificationSwitch.backgroundColor = UIColor.init(hexString: "A0AAB9")
                    }
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: dictResponse))
                }
            } else {
                if strNotiStatus == "BLOCKED" {
                    self.notificationSwitch.setOn(true, animated: true)
                    self.notificationSwitch.isSelected = true
                    self.notificationSwitch.onTintColor = UIColor.init(hexString: "4574B8")
                } else {
                    self.notificationSwitch.setOn(false, animated: true)
                    self.notificationSwitch.isSelected = false
                    self.notificationSwitch.backgroundColor = UIColor.init(hexString: "A0AAB9")
                }
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }

}
