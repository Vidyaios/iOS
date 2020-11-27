//
//  AddMachineViewController.swift
//  AirFipro
//
//  Created by iexm01 on 14/11/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit

class typeListViewCell: UITableViewCell {
    
    @IBOutlet var typeListLabel: UILabel!
}

class AddMachineViewController: UIViewController, UITextFieldDelegate, BSKeyboardControlsDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Variable Declaration
    @IBOutlet var txtfldMachineNumber: UITextField!
    @IBOutlet var txtfldType: UITextField!
    @IBOutlet var txtfldDescription: UITextField!
    @IBOutlet var txtfldMake: UITextField!
    @IBOutlet var txtfldModel: UITextField!
    @IBOutlet var txtfldDOPurchase: UITextField!
    @IBOutlet var txtfldWarrantyEndDate: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var addMachineScrollView: UIScrollView!
    @IBOutlet var datePickerView: UIView!
    @IBOutlet var machineDatePicker: UIDatePicker!
    @IBOutlet var typeListTableView: UITableView!
    @IBOutlet var machineTypeButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var warrantyEndPickerView: UIView!
    @IBOutlet var warrantyEndPicker: UIDatePicker!
    @IBOutlet var machineHeaderLabel: UILabel!
    @IBOutlet var txtfldMachineState: UITextField!
    @IBOutlet var machineStateButton: UIButton!
    
    var keyboardControls: BSKeyboardControls?
    var currentTextfield: UITextField!
    var strDeptId = ""
    var arrTypeList = NSArray()
    var strMachineActionType = ""
    var dictMachineAction = NSMutableDictionary()
    var dictParserKeyValResponse = NSMutableDictionary()
    var selectedTag = -1
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addMachine_Widget_Configuration()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - User Defined Methods
    func addMachine_Widget_Configuration() -> Void {
        txtfldMachineNumber.delegate = self
        txtfldType.delegate = self
        txtfldDescription.delegate = self
        txtfldMake.delegate = self
        txtfldModel.delegate = self
        txtfldDOPurchase.delegate = self
        txtfldWarrantyEndDate.delegate = self
        
        txtfldMachineNumber.clearButtonMode = .whileEditing
        txtfldType.clearButtonMode = .whileEditing
        txtfldDescription.clearButtonMode = .whileEditing
        txtfldMake.clearButtonMode = .whileEditing
        txtfldModel.clearButtonMode = .whileEditing
        txtfldDOPurchase.clearButtonMode = .whileEditing
        txtfldWarrantyEndDate.clearButtonMode = .whileEditing

        let fields = NSArray(array:[txtfldMachineNumber, txtfldMake, txtfldModel, txtfldDescription])
        keyboardControls = BSKeyboardControls(fields: fields as [AnyObject])
        keyboardControls?.delegate = self

        txtfldMachineNumber.underlined()
        txtfldType.underlined()
        txtfldMachineState.underlined()
        txtfldDescription.underlined()
        txtfldMake.underlined()
        txtfldModel.underlined()
        txtfldDOPurchase.underlined()
        txtfldWarrantyEndDate.underlined()
        
        addMachineScrollView.isUserInteractionEnabled = true
        addMachineScrollView.delegate = self
        addMachineScrollView.scrollsToTop = false
        addMachineScrollView.contentSize = CGSize.init(width: addMachineScrollView.contentSize.width, height: submitButton.frame.origin.y+submitButton.frame.size.height+50)
        
        machineDatePicker.setValue(UIColor.init(red: 58.0/255.0, green: 76.0/255.0, blue: 102.0/255.0, alpha: 1), forKeyPath: TEXTCOLOR)
        warrantyEndPicker.setValue(UIColor.init(red: 58.0/255.0, green: 76.0/255.0, blue: 102.0/255.0, alpha: 1), forKeyPath: TEXTCOLOR)
        machineDatePicker.maximumDate = Date()
        
        typeListTableView.isHidden = true
        typeListTableView.layer.borderWidth = 2
        typeListTableView.layer.borderColor = UIColor.init(hexString: "F0F0F0").cgColor
        typeListTableView.layer.cornerRadius = 3.0
        typeListTableView.layer.masksToBounds = true
        
        if strMachineActionType != MACHINEACTIONADD {
            machineActionTypeSetup()
        }
    }

    func machineActionTypeSetup() -> Void {
        print("dict == \(dictMachineAction)")
        var arrMachineKey = NSArray()
        arrMachineKey = self.dictMachineAction.value(forKey: CHARACTERISTICS) as! NSArray
        print("arr values \(arrMachineKey)")
        print("arr count \(arrMachineKey.count)")
        txtfldMachineNumber.text = self.dictMachineAction.value(forKey: RNAME) as? String
        txtfldType.text = self.dictMachineAction.value(forKey: RTYPE) as? String
        txtfldMachineState.text = self.dictMachineAction.value(forKey: RSTATE) as? String
        txtfldDescription.text = self.dictMachineAction.value(forKey: RDESCRIPTION) as? String
        if arrMachineKey.count > 0 {
           dictParserKeyValResponse = NSMutableDictionary()
           dictParserKeyValResponse = Common.parseTypeCollection(strTypeCollection: MACHINETYPECOLLECTION, arrKeyValues: arrMachineKey)
            if (dictParserKeyValResponse.object(forKey: PURCHASEDATE) != nil) {
                print(dictParserKeyValResponse.value(forKey: PURCHASEDATE)!)
                txtfldDOPurchase.text = dictParserKeyValResponse.value(forKey: PURCHASEDATE)! as? String
            }
            if (dictParserKeyValResponse.object(forKey: WARRANTYENDDATE) != nil) {
                print(dictParserKeyValResponse.value(forKey: WARRANTYENDDATE)!)
                txtfldWarrantyEndDate.text = dictParserKeyValResponse.value(forKey: WARRANTYENDDATE)! as? String
            }
            if (dictParserKeyValResponse.object(forKey: MAKE) != nil) {
                print(dictParserKeyValResponse.value(forKey: MAKE)!)
                txtfldMake.text = dictParserKeyValResponse.value(forKey: MAKE)! as? String
            }
            if (dictParserKeyValResponse.object(forKey: MODEL) != nil) {
                print(dictParserKeyValResponse.value(forKey: MODEL)!)
                txtfldModel.text = dictParserKeyValResponse.value(forKey: MODEL)! as? String
            }
        }
        if strMachineActionType == MACHINEACTIONVIEW {
            txtfldMachineNumber.isUserInteractionEnabled = false
            txtfldType.isUserInteractionEnabled = false
            txtfldMachineState.isUserInteractionEnabled = false
            txtfldDescription.isUserInteractionEnabled = false
            txtfldMake.isUserInteractionEnabled = false
            txtfldModel.isUserInteractionEnabled = false
            txtfldDOPurchase.isUserInteractionEnabled = false
            txtfldWarrantyEndDate.isUserInteractionEnabled = false
            self.submitButton.isUserInteractionEnabled = false
            submitButton.isHidden = true
            cancelButton.isHidden = true
            machineTypeButton.isHidden = true
            machineStateButton.isHidden = true
            machineHeaderLabel.text = MACHINEVIEWHEADER
        } else if strMachineActionType == MACHINEACTIONEDIT {
            machineHeaderLabel.text = MACHINEEDITHEADER
        }
    }
    
    func set_datePicker_widget() {
        self.view.bringSubview(toFront: datePickerView)
        txtfldDOPurchase.underlinedBlue()
        addMachineScrollView.isUserInteractionEnabled = false
        self.view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.datePickerView.frame = CGRect(x: self.datePickerView.frame.origin.x, y: self.view.frame.height - self.datePickerView.frame.size.height, width: self.datePickerView.frame.size.width, height: self.datePickerView.frame.size.height)
        }, completion: { finished in
            print("view visible")
            self.datePickerView.isHidden = false
        })
    }
    
    func set_warrantyEnd_datePicker_widget() {
        self.view.bringSubview(toFront: warrantyEndPickerView)
        txtfldWarrantyEndDate.underlinedBlue()
        addMachineScrollView.isUserInteractionEnabled = false
        self.view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.warrantyEndPickerView.frame = CGRect(x: self.warrantyEndPickerView.frame.origin.x, y: self.view.frame.height - self.warrantyEndPickerView.frame.size.height, width: self.warrantyEndPickerView.frame.size.width, height: self.warrantyEndPickerView.frame.size.height)
        }, completion: { finished in
            print("view visible")
            self.warrantyEndPickerView.isHidden = false
        })
    }
    
    func reset_datePicker_widget() {
        txtfldDOPurchase.underlined()
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.datePickerView.frame = CGRect(x: self.datePickerView.frame.origin.x, y: 1500, width: self.datePickerView.frame.size.width, height: self.datePickerView.frame.size.height)
            self.addMachineScrollView.contentOffset = CGPoint.zero
        }, completion: { finished in
            print("view visible")
            self.addMachineScrollView.isUserInteractionEnabled = true
        })
    }
    
    func reset_warrantyEnd_datePicker_widget() {
        txtfldWarrantyEndDate.underlined()
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.warrantyEndPickerView.frame = CGRect(x: self.warrantyEndPickerView.frame.origin.x, y: 1500, width: self.warrantyEndPickerView.frame.size.width, height: self.warrantyEndPickerView.frame.size.height)
            self.addMachineScrollView.contentOffset = CGPoint.zero
        }, completion: { finished in
            print("view visible")
            self.addMachineScrollView.isUserInteractionEnabled = true
        })
    }
    
    // MARK: - UITextfield Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keyboardControls?.activeField = textField
        if(textField == txtfldDOPurchase || textField == txtfldWarrantyEndDate){
            currentTextfield.resignFirstResponder()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("\(textField.frame.origin.y)")
        self.currentTextfield = textField
        textField.underlinedBlue()
        if typeListTableView.isHidden == false {
            typeListTableView.isHidden = true
            txtfldType.underlined()
            txtfldMachineState.underlined()
        }
        if currentTextfield == txtfldDOPurchase {
            warrantyEndPickerView.isHidden = true
            set_datePicker_widget()
        }
        if currentTextfield == txtfldWarrantyEndDate {
            datePickerView.isHidden = true
            set_warrantyEnd_datePicker_widget()
        }
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            if self.currentTextfield == self.txtfldMake || self.currentTextfield == self.txtfldModel || self.currentTextfield == self.txtfldDOPurchase || self.currentTextfield == self.txtfldWarrantyEndDate || self.currentTextfield == self.txtfldDescription {
                if Common.deviceType() == "iPhone5" {
                    self.addMachineScrollView.contentOffset = CGPoint(x: 0, y: CGFloat(self.currentTextfield.frame.origin.y-40))
                } else if Common.deviceType() == "iPhone6" {
                    self.addMachineScrollView.contentOffset = CGPoint(x: 0, y: CGFloat(self.currentTextfield.frame.origin.y-150))
                } else if Common.deviceType() == "iPhone6plus" {
                    self.addMachineScrollView.contentOffset = CGPoint(x: 0, y: CGFloat(self.currentTextfield.frame.origin.y-150))
                }
            }
        }, completion: { finished in
            print("view visible")
        })
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(view.frame.size.width), height: CGFloat(view.frame.size.height))
        self.addMachineScrollView.contentOffset = CGPoint.zero
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
        if textField == txtfldMachineNumber {
            let newLength = (textField.text?.count)! + (string.count) - range.length
            let inverseSet = NSCharacterSet(charactersIn:ACCEPTABLE_CHARACTERSName).inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            return string == filtered && newLength <= MAX_LIMIT_FNAME
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtfldMachineNumber {
            txtfldMachineNumber.underlined()
        } else if textField == txtfldType {
            txtfldType.underlined()
        } else if textField == txtfldMachineState {
            txtfldMachineState.underlined()
        } else if textField == txtfldDescription {
            txtfldDescription.underlined()
            txtfldDescription.text =  txtfldDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if textField == txtfldMake {
            txtfldMake.underlined()
            txtfldMake.text =  txtfldMake.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if textField == txtfldModel {
            txtfldModel.underlined()
            txtfldModel.text =  txtfldModel.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if textField == txtfldDOPurchase {
        } else if textField == txtfldWarrantyEndDate {
        }
    }
    
    // MARK: - BSKeyboard Delegate Method
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) -> Void {
        self.view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
        self.addMachineScrollView.contentOffset = CGPoint.zero
        self.view.endEditing(true)
    }
    
    //MARK: - IBAction
    @IBAction func datePicker_Action(_ sender: UIButton) {
        print("btnTag==\(sender.tag)")
        switch sender.tag {
        case 0: // OK
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DATEFORMAT
            let strDate = dateFormatter.string(from: machineDatePicker.date)
            print("current date == \(strDate)")
            currentTextfield.text = strDate
            reset_datePicker_widget()
            break
        case 1: // Cancel
            reset_datePicker_widget()
            break
        case 2: // warranty end picker DONE
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DATEFORMAT
            let strDate = dateFormatter.string(from: warrantyEndPicker.date)
            print("current date == \(strDate)")
            currentTextfield.text = strDate
            reset_warrantyEnd_datePicker_widget()
            break
        case 3: // warranty end CANCEL
            reset_warrantyEnd_datePicker_widget()
            break
        default:
            break
        }
    }
    
    @IBAction func typeSelect_Action(_ sender: UIButton) {
        print("btnTag==\(sender.tag)")
        selectedTag = sender.tag
        if let currentTextfield = currentTextfield {
            currentTextfield.resignFirstResponder()
        }
        if datePickerView.isHidden == false {
            reset_datePicker_widget()
        }
        if !typeListTableView.isHidden {
            typeListTableView.isHidden = true
            txtfldType.underlined()
            txtfldMachineState.underlined()
        }
        typeListTableView.delegate = self
        typeListTableView.dataSource = self
        switch sender.tag {
        case 0: // Type
            txtfldType.underlinedBlue()
            arrTypeList = NSArray()
            let tempArray: NSArray = UserDefaults.standard.array(forKey: SYSTEMTYPE)! as NSArray
            arrTypeList = tempArray.mutableCopy() as! NSMutableArray
            typeListTableView.reloadData()
            typeListTableView.frame = CGRect.init(x: txtfldType.frame.origin.x, y: txtfldType.frame.origin.y + txtfldType.frame.size.height, width: typeListTableView.frame.size.width, height: typeListTableView.frame.size.height)
            typeListTableView.isHidden = false
            break
        case 1: // State
            txtfldMachineState.underlinedBlue()
            arrTypeList = NSArray()
            let tempArray: NSArray = UserDefaults.standard.array(forKey: STATE)! as NSArray
            arrTypeList = tempArray.mutableCopy() as! NSMutableArray
            typeListTableView.reloadData()
            typeListTableView.frame = CGRect.init(x: txtfldMachineState.frame.origin.x, y: txtfldMachineState.frame.origin.y + txtfldMachineState.frame.size.height, width: typeListTableView.frame.size.width, height: typeListTableView.frame.size.height)
            typeListTableView.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func machineAdd_Submit_Cancel_Action(_ sender: UIButton) {
        print("btnTag==\(sender.tag)")
        if let currentTextfield = currentTextfield {
            currentTextfield.resignFirstResponder()
        }
        self.addMachineScrollView.contentOffset = CGPoint.zero
        switch sender.tag {
        case 0: // Submit
            if typeListTableView.isHidden == false {
                typeListTableView.isHidden = true
                txtfldType.underlined()
                txtfldMachineState.underlined()
            }
            if txtfldMachineNumber.text == "" {
                Common.showCustomAlert(message: MACHINENAMEVALIDATION)
                return
            } else if txtfldType.text == "" {
                Common.showCustomAlert(message: MACHINETYPEVALIDATION)
                return
            } else if txtfldMachineState.text == "" {
                Common.showCustomAlert(message: MACHINESTATEVALIDATION)
                return
            } else if txtfldMachineNumber.text != "" && ((txtfldMachineNumber.text?.count)! < 3) {
                Common.showCustomAlert(message: MACHINENUMBERVALIDATION)
                return
            } else if txtfldMake.text != "" && ((txtfldMake.text?.count)! < 1 || (txtfldMake.text?.count)! > 25) {
                Common.showCustomAlert(message: MAKEVALIDATION)
                return
            } else if txtfldModel.text != "" && ((txtfldModel.text?.count)! < 5 || (txtfldModel.text?.count)! > 15) {
                Common.showCustomAlert(message: MODELVALIDATION)
                return
            } else if txtfldDOPurchase.text != "" && txtfldWarrantyEndDate.text != "" && (txtfldWarrantyEndDate.text! < txtfldDOPurchase.text!) {
                Common.showCustomAlert(message: "Please select Warranty end date more than Date of Purchase")
                return
            } else if txtfldDescription.text != "" && ((txtfldDescription.text?.count)! < 8 || (txtfldDescription.text?.count)! > 100) {
                Common.showCustomAlert(message: DESCRIPTIONVALIDATION)
                return
            }
            if strMachineActionType == MACHINEACTIONEDIT {
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
                    self.createMachineService()
                }
                _ = alert.addButton("CANCEL") {
                    print("Second button tapped")
                }
                
                let icon = SCLAlertViewStyleKit.imageOfWarning
                let color = UIColor.init(hexString: "4574B9")
                
                _ = alert.showCustom(WARNING, subTitle: Common.dynmaicPopUpMessage(strMsg: "\(self.txtfldMachineNumber.text!)", strType: CONFIRMATION), color: color, icon: icon)
                return
            }
            if Common.reachabilityChanged() == true {
                Common.startPinwheelProcessing()
                createMachineService()
            } else {
                Common.showCustomAlert(message: NWCONNECTION)
            }
            break
        case 1: // Cancel
            let _ = self.navigationController?.popViewController(animated: true)
            break
        default:
            break
        }
    }
    
    @IBAction func back_AddMachine_Action(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : typeListViewCell = tableView.dequeueReusableCell(withIdentifier: "typeListViewCell")! as! typeListViewCell
        cell.typeListLabel.text = (self.arrTypeList[indexPath.row] as AnyObject) as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        typeListTableView.isHidden = true
        if selectedTag == 0 {
            txtfldType.underlined()
            txtfldType.text = arrTypeList.object(at: (indexPath as NSIndexPath).row) as? String
        } else {
            txtfldMachineState.underlined()
            txtfldMachineState.text = arrTypeList.object(at: (indexPath as NSIndexPath).row) as? String
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTypeList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: - Webservice Implementation
    func createMachineService() {
        let dictAddMachine = NSMutableDictionary()
        dictAddMachine.setValue(txtfldDescription.text!, forKey: DESCRIPTION)
        if strMachineActionType == MACHINEACTIONEDIT {
            dictAddMachine.setValue(self.dictMachineAction.value(forKey: RID) as? String, forKey: RID)
        } else {
            dictAddMachine.setValue("", forKey: RID)
        }
        
        dictAddMachine.setValue(txtfldMachineNumber.text!, forKey: RNAME)
        dictAddMachine.setValue(UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String, forKey: RORGANIZATIONID)
        dictAddMachine.setValue(self.strDeptId, forKey: DEPARTMENTID)
        dictAddMachine.setValue(txtfldType.text!, forKey: RTYPE)
        dictAddMachine.setValue(txtfldMachineState.text!, forKey: STATE)
        let arrAddMachinePayLoad = NSMutableArray()
        if txtfldMake.text != "" {
            arrAddMachinePayLoad.add(Common.payloadKeyValue(strKey: MAKE, strValue: txtfldMake.text!))
        }
        if txtfldModel.text != "" {
            arrAddMachinePayLoad.add(Common.payloadKeyValue(strKey: MODEL, strValue: txtfldModel.text!))
        }
        if txtfldDOPurchase.text != "" {
            arrAddMachinePayLoad.add(Common.payloadKeyValue(strKey: PURCHASEDATE, strValue: txtfldDOPurchase.text!))
        }
        if txtfldWarrantyEndDate.text != "" {
            arrAddMachinePayLoad.add(Common.payloadKeyValue(strKey: WARRANTYENDDATE, strValue: txtfldWarrantyEndDate.text!))
        }
        
        dictAddMachine.setValue(arrAddMachinePayLoad, forKey: KEYVALUE)
        print("Dict add machine\(dictAddMachine)")
        
        let parameters: NSDictionary = ServiceConnector.setAddMachineRequestParameter(dictLogin: dictAddMachine)
        print("Dict JSON Formation add machine\(parameters)")
        if strMachineActionType == MACHINEACTIONEDIT {
            ServiceConnector.serviceConnectorPUT(SYSTEM_METHOD_NAME, inputParam: parameters as! NSMutableDictionary) {
                responseObject,error,statusCode in
                if (error == nil) {
                    let code: Int = statusCode!
                    NSLog("\(code)")
                    print(code)
                    var dictResponse = NSDictionary()
                    dictResponse = responseObject! as NSDictionary
                    if code == 200 {
                        appDelegate.machineAddedStatus = "YES"
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
                        _ = alertView.showSuccess(SUCCESS, subTitle: Common.dynmaicPopUpMessage(strMsg: "\(self.txtfldMachineNumber.text!)", strType: UPDATEMESSAGE))
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
        } else {
            ServiceConnector.serviceConnectorPOST(SYSTEM_METHOD_NAME, inputParam: parameters as! NSMutableDictionary) {
                responseObject,error,statusCode in
                if (error == nil) {
                    let code: Int = statusCode!
                    NSLog("\(code)")
                    print(code)
                    var dictResponse = NSDictionary()
                    dictResponse = responseObject! as NSDictionary
                    if code == CODE201 {
                        appDelegate.machineAddedStatus = "YES"
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
                        _ = alertView.showSuccess(SUCCESS, subTitle: Common.dynmaicPopUpMessage(strMsg: "\(self.txtfldMachineNumber.text!)", strType: ADDMESSAGE))
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
