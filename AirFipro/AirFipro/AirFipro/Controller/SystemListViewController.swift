//
//  SystemListViewController.swift
//  AirFipro
//
//  Created by ixm1 on 11/14/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit
import CocoaMQTT

class systemListViewCell: UITableViewCell {
    @IBOutlet var systemName: UILabel!
    @IBOutlet var contollerSno: UILabel!
    @IBOutlet var systemDetailsBtn: UIButton!
}
class SystemListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Varaiable Declaration
    @IBOutlet var tabelViewSystem: UITableView!
    @IBOutlet var lblDeptName: UILabel!
    @IBOutlet var viewPreview: UIView!
    @IBOutlet var constructionView: UIView!
    @IBOutlet var resetView: UIView!
    
    var strDeptName: String = ""
    var strDeptId: String = ""
    var dictResponseSystem = NSDictionary()
    var dictControllerSpcDetails = NSDictionary()
    var arrMachineList = NSMutableArray()
    var arrControllerList = NSArray()
    var actionButton: ActionButton!
    var systemId: String = ""
    var buttonTag = Int()
    var strControllerId = ""
    var strControllerUniqueCode = ""
    var mqtt: CocoaMQTT?
    var strControllerMode = ""
    var strMQTTPublishTopic = ""
    var mqttTimeout = ""
    var mqttConnectStatus = ""
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.widget_Configuration_System()
        self.lblDeptName.text = self.strDeptName
        if Common.reachabilityChanged() == true {
            Common.startPinwheelProcessing()
            self.getSystemListAPIForDept()
        } else {
            Common.showCustomAlert(message: NWCONNECTION)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.didReceiveMemoryWarning()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("****************************************")
        if appDelegate.machineAddedStatus == "YES" {
            appDelegate.machineAddedStatus = ""
            Common.startPinwheelProcessing()
            arrMachineList = NSMutableArray()
            tabelViewSystem.reloadData()
            self.getSystemListAPIForDept()
        }
    }
    
    //MARK: - User Defined Method
    func widget_Configuration_System() -> Void {
        viewPreview.isHidden = true
        actionButton = ActionButton(attachedToView: self.view, items: [])
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("+", forState: UIControlState())
        actionButton.backgroundColor = UIColor.init(red: 69/255, green: 116/255, blue:184/255, alpha: 1.0)
        SwiftEventBus.onMainThread(self, name: "ADDMACHINESB") { result in
            print("wowmagic")
            if self.viewPreview.isHidden {
                self.navigateAddMachine()
            }
        }
    }
    func navigateAddMachine() -> Void {
        print("Add Machine Called")
        let AMVC = self.storyboard?.instantiateViewController(withIdentifier: ADDMACHINEVIEW) as? AddMachineViewController
        AMVC?.strDeptId = self.strDeptId
        AMVC?.strMachineActionType = MACHINEACTIONADD
        self.navigationController?.pushViewController(AMVC!, animated: true)
    }
    
    func resetSelectedWidget(tag: Int, strImage: String) -> Void {
        let indexPath = IndexPath(row: tag, section: 0)
        print(indexPath)
        let cell = self.tabelViewSystem.cellForRow(at: indexPath) as! systemListViewCell
        cell.systemDetailsBtn.setImage(UIImage.init(named: strImage), for: .normal)
    }
    func parseTypeCollectionSystem(tagIndex: Int) -> Void {
        print(arrMachineList[tagIndex])
        if (arrMachineList[tagIndex] as AnyObject).value(forKey: CONTROLLERID) as! String != "" {
            self.constructionView.isUserInteractionEnabled = true
            self.constructionView.alpha = 1.0
            self.resetView.isUserInteractionEnabled = true
            self.resetView.alpha = 1.0
            strControllerId = (arrMachineList[tagIndex] as AnyObject).value(forKey: CONTROLLERID) as! String
            strControllerUniqueCode = (arrMachineList[tagIndex] as AnyObject).value(forKey: RUNIQUECODE) as! String
            print("controller id == \(strControllerId)")
        } else {
            strControllerId = ""
            self.constructionView.isUserInteractionEnabled = false
            self.constructionView.alpha = 0.5
            self.resetView.isUserInteractionEnabled = false
            self.resetView.alpha = 0.5
        }
    }
    
    func mappingController() -> Void {
        print(arrMachineList)
        for index in 0..<arrMachineList.count {
            print(((self.arrMachineList[index] as AnyObject).object(forKey: RID) as! String))
            dictControllerSpcDetails = NSDictionary()
            dictControllerSpcDetails = Common.mappingControllerWithMachine(systemId: (self.arrMachineList[index] as AnyObject).object(forKey: RID) as! String, arrController: arrControllerList)
            print(dictControllerSpcDetails)
            if dictControllerSpcDetails.count > 0 {
                let dict = NSMutableDictionary()
                dict.setValue(dictControllerSpcDetails.value(forKey: RUNIQUECODE) as? String, forKey: RUNIQUECODE)
                dict.setValue(dictControllerSpcDetails.value(forKey: RID) as? String, forKey: CONTROLLERID)
                
                dict.setValue(dictControllerSpcDetails.value(forKey: RNAME) as? String, forKey: RCNAME)
                dict.setValue((arrMachineList[index] as AnyObject).value(forKey: RID) as! String, forKey: RID)
                dict.setValue((arrMachineList[index] as AnyObject).value(forKey: RNAME) as! String, forKey: RNAME)
                dict.setValue((arrMachineList[index] as AnyObject).value(forKey: CHARACTERISTICS), forKey: CHARACTERISTICS)
                dict.setValue((arrMachineList[index] as AnyObject).object(forKey: RTYPE) as! String, forKey: RTYPE)
                dict.setValue((arrMachineList[index] as AnyObject).object(forKey: RDESCRIPTION) as! String, forKey: RDESCRIPTION)
                dict.setValue((arrMachineList[index] as AnyObject).object(forKey: RSTATE) as! String, forKey: RSTATE)
                arrMachineList.replaceObject(at: index, with: dict)
            }
        }
        print(arrMachineList)
        self.tabelViewSystem.delegate = self
        self.tabelViewSystem.dataSource = self
        self.tabelViewSystem.reloadData()
//        Common.stopPinwheelProcessing()
    }
    
    // MARK: - MQTT Certificate Verification
    func selfSignedSSLSetting_SystemList() {
        let clientID = "CocoaMQTT-IOS-" + appDelegate.appDeviceToken
        mqtt = CocoaMQTT(clientID: clientID, host: MQTT_HOST, port: UInt16(MQTT_PORT))
        mqtt!.username = ""
        mqtt!.password = ""
        mqtt!.keepAlive = 60
        mqtt!.delegate = self as CocoaMQTTDelegate
        mqtt!.enableSSL = false
        mqtt!.autoReconnect = true
        
        let clientCertArray = getClientCertFromP12File(certName: MQTT_CERT, certPassword: MQTT_PSWD)
        
        var sslSettings: [String: NSObject] = [:]
        sslSettings[kCFStreamSSLCertificates as String] = clientCertArray
        
        mqtt!.sslSettings = sslSettings
        print(mqtt!.sslSettings as Any)
        if (mqtt!.sslSettings! != [:]) {
            mqtt!.connect()
        } else {
            print("ssl error")
        }
    }
    
    func getClientCertFromP12File(certName: String, certPassword: String) -> CFArray? {
        // get p12 file path
        let resourcePath = Bundle.main.path(forResource: certName, ofType: ".p12")
        
        guard let filePath = resourcePath, let p12Data = NSData(contentsOfFile: filePath) else {
            print("Failed to open the certificate file: \(certName).p12")
            return nil
        }
        
        // create key dictionary for reading p12 file
        let key = kSecImportExportPassphrase as String
        let options : NSDictionary = [key: certPassword]
        
        var items : CFArray?
        let securityError = SecPKCS12Import(p12Data, options, &items)
        
        guard securityError == errSecSuccess else {
            if securityError == errSecAuthFailed {
                print("ERROR: SecPKCS12Import returned errSecAuthFailed. Incorrect password?")
            } else {
                print("Failed to open the certificate file: \(certName).p12")
            }
            return nil
        }
        
        guard let theArray = items, CFArrayGetCount(theArray) > 0 else {
            return nil
        }
        
        let dictionary = (theArray as NSArray).object(at: 0)
        guard let identity = (dictionary as AnyObject).value(forKey: kSecImportItemIdentity as String) else {
            return nil
        }
        let certArray = [identity] as CFArray
        
        return certArray
    }
    
    //MARK: - IBAction
    @IBAction func backSystemAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func previewSystemAction(_ sender: UIButton) {
        print("btnTag==\(sender.tag)")
        viewPreview.isHidden = true
        print(arrMachineList[buttonTag] as! NSMutableDictionary)

        switch sender.tag {
        case 0: // view
            resetSelectedWidget(tag: buttonTag, strImage: MACHINEMORENORAML)
            let AMVC = self.storyboard?.instantiateViewController(withIdentifier: ADDMACHINEVIEW) as? AddMachineViewController
            AMVC?.strDeptId = self.strDeptId
            AMVC?.strMachineActionType = MACHINEACTIONVIEW
            AMVC?.dictMachineAction = arrMachineList[buttonTag] as! NSMutableDictionary
            self.navigationController?.pushViewController(AMVC!, animated: true)
            break
        case 1: // edit
            resetSelectedWidget(tag: buttonTag, strImage: MACHINEMORENORAML)
            let AMVC = self.storyboard?.instantiateViewController(withIdentifier: ADDMACHINEVIEW) as? AddMachineViewController
            AMVC?.strDeptId = self.strDeptId
            AMVC?.strMachineActionType = MACHINEACTIONEDIT
            AMVC?.dictMachineAction = arrMachineList[buttonTag] as! NSMutableDictionary
            self.navigationController?.pushViewController(AMVC!, animated: true)
            break
        case 2: // Delete
            resetSelectedWidget(tag: buttonTag, strImage: MACHINEMORENORAML)
            strControllerMode = "DELETE"
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
                self.mqttConnectStatus = ""
                if self.strControllerId != "" {
                    if Common.reachabilityChanged() == true {
                        Common.startPinwheelProcessing()
                        self.selfSignedSSLSetting_SystemList()
                    } else {
                        Common.showCustomAlert(message: "")
                    }
                } else {
                    if Common.reachabilityChanged() == true {
                        Common.startPinwheelProcessing()
                        self.deleteMachineService()
                    } else {
                        Common.showCustomAlert(message: NWCONNECTION)
                    }
                }
            }
            _ = alert.addButton("CANCEL") {
                print("Second button tapped")
            }
            
            let icon = SCLAlertViewStyleKit.imageOfWarning//UIImage(named:"")
            let color = UIColor.init(hexString: "4574B9")
            
            _ = alert.showCustom(WARNING, subTitle: Common.dynmaicPopUpMessage(strMsg: "\((self.arrMachineList[buttonTag] as AnyObject).object(forKey: RNAME) as! String)", strType: DELETECONFIRMATION), color: color, icon: icon)
            break
        case 3: // Configuration
            resetSelectedWidget(tag: buttonTag, strImage: MACHINEMORENORAML)
            let CCVC = self.storyboard?.instantiateViewController(withIdentifier: CONTROLLERCONFIGVIEW) as? ControllerConfigurationViewController
            CCVC?.configSystemId = systemId
            CCVC?.strDeptId = strDeptId
            self.navigationController?.pushViewController(CCVC!, animated: true)
            break
        case 4: // Construction
            resetSelectedWidget(tag: buttonTag, strImage: MACHINEMORENORAML)
            let CVC = self.storyboard?.instantiateViewController(withIdentifier: CONSTRUCTIONVIEW) as? ConstructionViewController
            CVC?.constructionSystemId = systemId
            CVC?.strDeptId = self.strDeptId
            CVC?.strControllerId = self.strControllerId
            self.navigationController?.pushViewController(CVC!, animated: true)
            break
        case 5: //reset
            resetSelectedWidget(tag: buttonTag, strImage: MACHINEMORENORAML)
            strControllerMode = "RESET"
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
                if Common.reachabilityChanged() == true {
                    Common.startPinwheelProcessing()
                    self.selfSignedSSLSetting_SystemList()
                } else {
                    Common.showCustomAlert(message: "")
                }
            }
            _ = alert.addButton("CANCEL") {
                print("Second button tapped")
            }
            
            let icon = SCLAlertViewStyleKit.imageOfWarning
            let color = UIColor.init(hexString: "4574B9")
            
            _ = alert.showCustom(WARNING, subTitle: Common.dynmaicPopUpMessage(strMsg: "\((self.arrMachineList[buttonTag] as AnyObject).object(forKey: RNAME) as! String)", strType: DEVICERESET), color: color, icon: icon)
            break
        case 6: // close
            resetSelectedWidget(tag: buttonTag, strImage: MACHINEMORENORAML)
            self.viewPreview.isHidden = true
            break
        case 7: // Refresh
            if Common.reachabilityChanged() == true {
                if arrMachineList.count > 0 {
                    arrMachineList = NSMutableArray()
                    tabelViewSystem.reloadData()
                }
                Common.startPinwheelProcessing()
                self.getSystemListAPIForDept()
            } else {
                Common.showCustomAlert(message: NWCONNECTION)
            }
            break
        default:
            break
        }
    }
    
    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : systemListViewCell = tableView.dequeueReusableCell(withIdentifier: "systemListViewCell")! as! systemListViewCell
        cell.systemName.text = (self.arrMachineList[indexPath.row] as AnyObject).object(forKey: RNAME) as? String
        if (self.arrMachineList[indexPath.row] as AnyObject).object(forKey: RUNIQUECODE) as? String != "" {
            cell.contollerSno.text = (self.arrMachineList[indexPath.row] as AnyObject).object(forKey: RCNAME) as? String
        } else {
            cell.contollerSno.text = ""
        }
        
        cell.contollerSno.tag = indexPath.row
        cell.backgroundColor = UIColor.clear
        cell.systemDetailsBtn.addTarget(self, action: #selector(SystemListViewController.previewAction), for: .touchUpInside)
        cell.systemDetailsBtn.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (tableView.indexPathsForVisibleRows?.last)?.row {
            Common.stopPinwheelProcessing()
        }
    }

    @objc func previewAction(sender: UIButton) {
        buttonTag = sender.tag
        print(buttonTag)
        self.parseTypeCollectionSystem(tagIndex: buttonTag)
        viewPreview.isHidden = false
        systemId = ((self.arrMachineList[buttonTag] as AnyObject).object(forKey: RID) as? String)!
        print(systemId)
        resetSelectedWidget(tag: buttonTag, strImage: MACHINEMORESELECTED)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected Cell \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMachineList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    //MARK: - API Implementation
    func getSystemListAPIForDept() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        let methodName = "\(SYSTEM_METHOD_NAME)"+QUERYMARK+GET_PARAM_ORGANIZATIONID+QUERYSYMBOL+oID+QUERYJOIN+GET_PARAM_DEPARTMENTID+QUERYSYMBOL+self.strDeptId
        print(methodName)
        ServiceConnector.serviceConnectorGET(methodName) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                self.dictResponseSystem = NSDictionary()
                self.dictResponseSystem = responseObject! as NSDictionary
                print(self.dictResponseSystem)
                if (code == CODE200) {
                    self.strControllerMode = ""
                    var arrTempList: NSArray = []
                    arrTempList = self.dictResponseSystem.value(forKey: RESULTS) as! NSArray
                    if arrTempList.count > 0 {
                        self.arrMachineList = NSMutableArray()
                        for index in 0 ..< arrTempList.count {
                            let dictMachineList = NSMutableDictionary()
                            print((arrTempList[index] as AnyObject).object(forKey: RID) as! String)
                            print((arrTempList[index] as AnyObject).object(forKey: RNAME) as! String)
                            var arrTempChar: NSArray = []
                            arrTempChar = (arrTempList[index] as AnyObject).object(forKey: CHARACTERISTICS) as! NSArray
                            if arrTempChar.count > 0 {
                                dictMachineList.setValue(arrTempChar, forKey: CHARACTERISTICS)
                            } else {
                                dictMachineList.setValue(arrTempChar, forKey: CHARACTERISTICS)
                            }
                            dictMachineList.setValue((arrTempList[index] as AnyObject).object(forKey: RID) as! String, forKey: RID)
                            dictMachineList.setValue((arrTempList[index] as AnyObject).object(forKey: RNAME) as! String, forKey: RNAME)
                            dictMachineList.setValue("", forKey: RUNIQUECODE)
                            dictMachineList.setValue("", forKey: CONTROLLERID)
                            dictMachineList.setValue("", forKey: RCNAME)
                            dictMachineList.setValue((arrTempList[index] as AnyObject).object(forKey: ADDMACHINETYPE) as! String, forKey: RTYPE)
                            dictMachineList.setValue((arrTempList[index] as AnyObject).object(forKey: RSTATE) as! String, forKey: RSTATE)
                            dictMachineList.setValue((arrTempList[index] as AnyObject).object(forKey: DESCRIPTION) as! String, forKey: RDESCRIPTION)
                            self.arrMachineList.add(dictMachineList)
                        }
                        print(self.arrMachineList)
                        if self.arrMachineList.count > 0 {
//                            Common.stopPinwheelProcessing()
//                            Common.startPinwheelProcessing()
                            self.getControllerDetailsSystem()
                        } else {
                            Common.stopPinwheelProcessing()
                            Common.showCustomAlert(message: NOMACHINEAVAILABLE)
                        }
                    } else {
                        Common.stopPinwheelProcessing()
                        Common.showCustomAlert(message: NOMACHINEAVAILABLE)
                    }
//                    Common.stopPinwheelProcessing()
                } else if (code == CODE204) {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: NOMACHINEAVAILABLE)
                } else {
//                    SwiftEventBus.unregister(SystemListViewController.self, name: "ADDMACHINESB")
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: self.dictResponseSystem))
                }
            } else {
//                SwiftEventBus.unregister(SystemListViewController.self, name: "ADDMACHINESB")
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }
    
    func deleteMachineService() {
        print("system id == \(systemId)")
        let methodName = "\(SYSTEM_METHOD_NAME)"+QUERYMARK+DELETE_PARAMID+QUERYSYMBOL+systemId
        ServiceConnector.serviceConnectorDELETE(methodName) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                self.dictResponseSystem = NSDictionary()
                self.dictResponseSystem = responseObject! as NSDictionary
                print(self.dictResponseSystem)
                if (code == CODE202) {
                    self.strControllerMode = ""
                    Common.stopPinwheelProcessing()
                    let appearance = SCLAlertView.SCLAppearance(
                        kTextFont: UIFont(name: "ProximaNova-Semibold", size: 14)!,
                        kButtonFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
                        showCloseButton: false,
                        showCircularIcon: true
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    _ = alertView.addButton("OK") {
                        Common.startPinwheelProcessing()
                        self.arrMachineList = NSMutableArray()
                        self.tabelViewSystem.reloadData()
                        self.getSystemListAPIForDept()
                    }
                    _ = alertView.showSuccess(SUCCESS, subTitle: Common.dynmaicPopUpMessage(strMsg: "\((self.arrMachineList[self.buttonTag] as AnyObject).object(forKey: RNAME) as! String)", strType: DELETESUCCESS))

                } else if (code == CODE400) {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: APIFAILURE)
                } else {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: self.dictResponseSystem))
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }
    
    func getControllerDetailsSystem() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        let methodName = "\(CONTROLLER_METHOD_NAME)"+QUERYMARK+GET_PARAM_ORGANIZATIONID+QUERYSYMBOL+oID+QUERYJOIN+GET_PARAM_DEPARTMENTID+QUERYSYMBOL+self.strDeptId
        print(methodName)
        ServiceConnector.serviceConnectorGET(methodName) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResponse = NSDictionary()
                dictResponse = responseObject! as NSDictionary
                print(dictResponse)
                if (code == CODE200) {
                    let results = dictResponse.value(forKey: RESULTS) as! NSArray
                    print(results)
                    self.arrControllerList = NSArray()
                    self.arrControllerList = dictResponse.value(forKey: RESULTS) as! NSArray
                    if self.arrControllerList.count > 0 {
                        print((self.arrControllerList[0] as AnyObject).object(forKey: RID) as! String)
                        self.mappingController()
                    } else {
//                        Common.stopPinwheelProcessing()
                        self.tabelViewSystem.delegate = self
                        self.tabelViewSystem.dataSource = self
                        self.tabelViewSystem.reloadData()
                    }
                } else if (code == CODE204) {
//                    Common.stopPinwheelProcessing()
                    self.tabelViewSystem.delegate = self
                    self.tabelViewSystem.dataSource = self
                    self.tabelViewSystem.reloadData()
                } else {
//                    Common.stopPinwheelProcessing()
                    self.tabelViewSystem.delegate = self
                    self.tabelViewSystem.dataSource = self
                    self.tabelViewSystem.reloadData()
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
            }
        }
    }
    
    func deleteControllerService() {
        print("system id == \(systemId)")
        let methodName = "\(CONTROLLER_METHOD_NAME)"+QUERYMARK+DELETE_PARAMID+QUERYSYMBOL+strControllerId
        print(methodName)
        ServiceConnector.serviceConnectorDELETE(methodName) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResponse = NSDictionary()
                dictResponse = responseObject! as NSDictionary
                print(dictResponse)
                if (code == CODE202) {
                    Common.stopPinwheelProcessing()
                    if self.strControllerMode == "DELETE" {
                        if Common.reachabilityChanged() == true {
                            Common.startPinwheelProcessing()
                            self.deleteMachineService()
                        } else {
                            Common.showCustomAlert(message: NWCONNECTION)
                        }
                    } else {
                        if Common.reachabilityChanged() == true {
                            Common.startPinwheelProcessing()
                            self.getSystemListAPIForDept()
                        } else {
                            Common.showCustomAlert(message: NWCONNECTION)
                        }
                    }
                } else if (code == CODE400) {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: APIFAILURE)
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
    }
    
    //MARK: - Protobuf Parsing
    func parseControllerDeleteDetails(responseString: String) {
        print(responseString)
        let response = Common.decodeProtoBufDeleteMQTT(response: responseString)
        print(response)
        print(response.cmd!)
        if response.cmd! == "DELETECALLED" {
            if Common.reachabilityChanged() == true {
                Common.startPinwheelProcessing()
                deleteControllerService()
            } else {
                Common.showCustomAlert(message: NWCONNECTION)
            }
        }
    }
    
}

// MARK: - MQTT Delegate Methods
extension SystemListViewController: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("didConnect \(host):\(port)")
    }
    
    // Optional ssl CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnectAck: \(ack)，rawValue: \(ack.rawValue)")
        if ack == .accept {
            print("connect ack")
            mqttConnectStatus = "CONNECT"
            let cntrlDelete = ControllerDelete.Builder()
            cntrlDelete.cmd = "RESET"
            /********* ENCODE **********/
            let deleteData = try!cntrlDelete.build()
            let binaryData = deleteData.data()
            print("protobuf data \(binaryData)")

            var array = [UInt8](binaryData)
            array = binaryData.withUnsafeBytes {
                [UInt8](UnsafeBufferPointer(start: $0, count: binaryData.count))
            }
            print("protobuf bytes \(array)")
            
            /********* CONVERT BYTE ARRAY TO HEXASTRING **********/
            let data = Data(bytes: array)
            print(data.hexEncodedString())
            var strDeleteData = data.hexEncodedString()
            print("protobuf data \(strDeleteData)")
            print(strDeleteData.count)
            strDeleteData = strDeleteData.inserting(separator: ":", every: 2)
            print(strDeleteData)
            
            strMQTTPublishTopic = MQTT_CONTROLLER_DELETE_PREFIX+"\(strControllerUniqueCode)"
            print(strMQTTPublishTopic)
            mqtt.subscribe(strMQTTPublishTopic+MQTT_CONTROLLER_DELETE_SUFFIX)
            mqtt.publish(strMQTTPublishTopic, withString: strDeleteData, qos: CocoaMQTTQOS.qos1, retained: true, dup: false)
            mqtt.publish(strMQTTPublishTopic, withString: "", qos: CocoaMQTTQOS.qos1, retained: true, dup: false)
            let dispatchTime = DispatchTime.now() + .seconds(10)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                Common.stopPinwheelProcessing()
                mqtt.disconnect()
                mqtt.unsubscribe(self.strMQTTPublishTopic+MQTT_CONTROLLER_DELETE_SUFFIX)
                if self.mqttTimeout != "YES" {
                    Common.showCustomAlert(message: MQTTCONNECITONERROR)
                }
            }
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage with message: \(message.string!)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck with id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("didReceivedMessage: \(message.string!) with id \(id)")
        NSLog("didReceivedMessage: \(message.string!) with id \(id)")
        Common.stopPinwheelProcessing()
        mqtt.unsubscribe(strMQTTPublishTopic+MQTT_CONTROLLER_DELETE_SUFFIX)
        mqtt.disconnect()
        mqttTimeout = "YES"
        if message.topic == strMQTTPublishTopic+MQTT_CONTROLLER_DELETE_SUFFIX {
            parseControllerDeleteDetails(responseString: message.string!)
        } else {
            parseControllerDeleteDetails(responseString: message.string!)
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic to \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic to \(topic)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("didPing")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        _console("didReceivePong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        Common.stopPinwheelProcessing()
        if self.mqttConnectStatus != "CONNECT" {
            Common.showCustomAlert(message: MQTTCONNECITONERROR)
        }
        _console("mqttDidDisconnect")
    }
    
    func _console(_ info: String) {
        print("Delegate: \(info)")
    }
}
