//
//  DashboardViewController.swift
//  AirFipro
//
//  Created by ixm1 on 11/13/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit
import CocoaMQTT

class DashboardViewController: SliderLibViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    //MARK: - Variable Declaration
    var swipeGesture = UISwipeGestureRecognizer()
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var lblDashboardMillName: UILabel!
    @IBOutlet var lblDashboardDepName: UILabel!
    @IBOutlet var dashboardScrollView: UIScrollView!
    
    var dictResponseSystem = NSDictionary()
    var arrMachineList = NSMutableArray()
    var dictControllerSpcDetails = NSDictionary()
    var arrControllerList = NSArray()
    var machineView = [UIView](repeating: UIView(), count: 1000)
    var unitConvButton = [UIButton](repeating: UIButton(), count: 1000)
    var previewButton = [UIButton](repeating: UIButton(), count: 1000)
    var dataLabel = [UILabel](repeating: UILabel(), count: 1000)
    var dataLPMLabel = [UILabel](repeating: UILabel(), count: 1000)
    var machineNameLabel = [UILabel](repeating: UILabel(), count: 1000)
    var mqtt: CocoaMQTT?
    var strUnitConversion = "CFM"
    let devRes = ControllerData.Builder()
    var dataHeaderLabel = [UILabel](repeating: UILabel(), count: 1000)
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboard_Widget_Configuration()
        print(appDelegate.deptName)
        print(appDelegate.deptId)
        print(appDelegate.arrDeptNotiList)
        Common.startPinwheelProcessing()
        self.getDashboardSystemListService()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("****************************************")
        UIApplication.shared.isIdleTimerDisabled = true
        Common.checkViewControllerStack()
        if UserDefaults.standard.object(forKey: "ORGNAME") as! String != ""{
            self.lblDashboardMillName.text = UserDefaults.standard.object(forKey: "ORGNAME") as? String
        }
        self.lblDashboardDepName.text = appDelegate.deptName
        if appDelegate.deptStatus == "YES" {
            let subViews = self.dashboardScrollView.subviews
            for subView in subViews {
                subView.removeFromSuperview()
            }
            appDelegate.deptStatus = ""
            Common.startPinwheelProcessing()
            self.getDashboardSystemListService()
        }
        if Common.reachabilityChanged() == true {
            selfSignedSSLSetting()
        } else {
            Common.showCustomAlert(message: "")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.didReceiveMemoryWarning()
        mqtt?.disconnect()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MQTT Certificate Verification
    func selfSignedSSLSetting() {
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
    
    //MARK: - User Defined Methods
    func dashboard_Widget_Configuration() -> Void {
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        swipeGesture.delegate = self
        swipeGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    func parseMachineList() -> Void {
//        do {
//
//        } catch  {
//            print(error.localizedDescription)
//        }
        dashboardScrollView.isUserInteractionEnabled = true
        dashboardScrollView.delegate = self
        dashboardScrollView.scrollsToTop = false
        var yCoord : CGFloat = 10
        var xCoord : CGFloat = 16
        var width : CGFloat = 0
        var height : CGFloat = 0
        var spacing : CGFloat = 0
        
        if Common.deviceType() == "iPhone5" {
            width = 90
            height = 120
            spacing = 10
            dashboardScrollView.frame.origin.x = 0
        } else {
            width = 106
            height = 134
            spacing = 14
        }
        for index in 0..<(arrMachineList.count) {
            if index == 0 {
                machineView[index] = UIView()
                machineView[index].frame = CGRect.init(x: xCoord, y: yCoord, width: width, height: height)
                xCoord = machineView[index].frame.origin.x+machineView[index].frame.size.width+spacing;
                yCoord = machineView[index].frame.origin.y
            } else {
                if index % 3 == 0 {
                    machineView[index] = UIView()
                    machineView[index].frame = CGRect.init(x: 16, y: yCoord+machineView[index-1].frame.size.height+spacing, width: width, height: height)
                    xCoord = machineView[index].frame.origin.x+machineView[index].frame.size.width+spacing;
                    yCoord = machineView[index].frame.origin.y
                } else {
                    machineView[index] = UIView()
                    machineView[index].frame = CGRect.init(x: xCoord, y: yCoord, width: width, height: height)
                    xCoord = xCoord+machineView[index-1].frame.size.width+spacing;
                    yCoord = machineView[index].frame.origin.y
                }
            }
            machineView[index].layer.borderWidth = 1
            machineView[index].layer.borderColor = UIColor.init(red: CGFloat(240.0 / 255.0), green: CGFloat(240.0 / 255.0), blue: CGFloat(240.0 / 255.0), alpha: CGFloat(1.0)).cgColor
//            machineView[index].backgroundColor = UIColor.init(hexString: "#e02f2f")
            machineView[index].backgroundColor = UIColor.init(red: 192.0/255.0, green: 120.0/255.0, blue: 62.0/255.0, alpha: 1)//UIColor.init(hexString: "c0783e")
            machineView[index].autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
            
            unitConvButton[index] = UIButton(type: .custom)
            if Common.deviceType() == "iPhone5" {
                unitConvButton[index].frame = CGRect(x: CGFloat(-5), y: CGFloat(-5), width: CGFloat(44), height: CGFloat(40))
            } else {
                unitConvButton[index].frame = CGRect(x: CGFloat(0), y: CGFloat(-3), width: CGFloat(44), height: CGFloat(40))
            }
            unitConvButton[index].backgroundColor = UIColor.clear
            unitConvButton[index].tag = index
            unitConvButton[index].autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin]
            unitConvButton[index].setImage(UIImage.init(named: "unitConversionIcon"), for: .normal)
            unitConvButton[index].addTarget(self, action: #selector(DashboardViewController.unitConversionAction), for: .touchUpInside)
            machineView[index].addSubview(unitConvButton[index])
            
            previewButton[index] = UIButton(type: .custom)
            if Common.deviceType() == "iPhone5" {
                previewButton[index].frame = CGRect(x: CGFloat(55), y: CGFloat(-5), width: CGFloat(44), height: CGFloat(40))
            } else {
                previewButton[index].frame = CGRect(x: CGFloat(65), y: CGFloat(-3), width: CGFloat(44), height: CGFloat(40))
            }
            previewButton[index].backgroundColor = UIColor.clear
            previewButton[index].tag = index
            previewButton[index].autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin]
            previewButton[index].setImage(UIImage.init(named: "view"), for: .normal)
            previewButton[index].addTarget(self, action: #selector(DashboardViewController.previewControllerDataAction), for: .touchUpInside)
            machineView[index].addSubview(previewButton[index])
            
            dataLabel[index] = UILabel()
            if Common.deviceType() == "iPhone5" {
                dataLabel[index].frame = CGRect.init(x: 0, y: 44, width: width, height: 25)
                dataLabel[index].font = UIFont.init(name: "ProximaNova-Regular", size: 28.0)
            } else {
                dataLabel[index].frame = CGRect.init(x: 0, y: 42, width: width, height: 26)
               // dataLabel[index].font = UIFont.init(name: "ProximaNova-Regular", size: 34.0)
                // SIRAJ 13/02/18
                dataLabel[index].font = UIFont.init(name: "ProximaNova-Regular", size: 23.0)
            }
            dataLabel[index].textColor = UIColor.init(hexString: "FFFFFF")
            dataLabel[index].textAlignment = .center
            dataLabel[index].text = "00.00"
            machineView[index].addSubview(dataLabel[index])
            
            dataLPMLabel[index] = UILabel()
            if Common.deviceType() == "iPhone5" {
                dataLPMLabel[index].frame = CGRect.init(x: 0, y: 44, width: width, height: 25)
                dataLPMLabel[index].font = UIFont.init(name: "ProximaNova-Regular", size: 28.0)
            } else {
                dataLPMLabel[index].frame = CGRect.init(x: 0, y: 42, width: width, height: 26)
               // dataLPMLabel[index].font = UIFont.init(name: "ProximaNova-Regular", size: 34.0)
                //SIRAJ 13/02/18
                dataLPMLabel[index].font = UIFont.init(name: "ProximaNova-Regular", size: 23.0)
            }
            dataLPMLabel[index].textColor = UIColor.init(hexString: "FFFFFF")
            dataLPMLabel[index].textAlignment = .center
            dataLPMLabel[index].text = "0"
            machineView[index].addSubview(dataLPMLabel[index])
            dataLPMLabel[index].isHidden = true
            
            // Set Machine background color
            parseMachineRangewiseColor(index: index)
            
            dataHeaderLabel[index] = UILabel()
            if Common.deviceType() == "iPhone5" {
                dataHeaderLabel[index].frame = CGRect.init(x: 0, y: 71, width: width, height: 21)
                dataHeaderLabel[index].font = UIFont.init(name: "ProximaNova-Light", size: 14.0)
            } else {
                dataHeaderLabel[index].frame = CGRect.init(x: 0, y: 78, width: width, height: 21)
                dataHeaderLabel[index].font = UIFont.init(name: "ProximaNova-Light", size: 16.0)
            }
            dataHeaderLabel[index].textColor = UIColor.init(hexString: "FFFFFF")
            dataHeaderLabel[index].textAlignment = .center
            dataHeaderLabel[index].text = "CFM"
            machineView[index].addSubview(dataHeaderLabel[index])
            
            machineNameLabel[index] = UILabel()
            if Common.deviceType() == "iPhone5" {
                machineNameLabel[index].frame = CGRect.init(x: 0, y: 93, width: width, height: 21)
                machineNameLabel[index].font = UIFont.init(name: "ProximaNova-Regular", size: 14.0)
            } else {
                machineNameLabel[index].frame = CGRect.init(x: 0, y: 109, width: width, height: 21)
                machineNameLabel[index].font = UIFont.init(name: "ProximaNova-Regular", size: 16.0)
            }
            machineNameLabel[index].textColor = UIColor.init(hexString: "FFFFFF")
            machineNameLabel[index].textAlignment = .center
            machineNameLabel[index].text = (arrMachineList[index] as AnyObject).object(forKey: RNAME) as? String
            machineView[index].addSubview(machineNameLabel[index])
            
            dashboardScrollView .addSubview(machineView[index])
            dashboardScrollView.contentSize = CGSize.init(width: dashboardScrollView.contentSize.width, height: machineView[index].frame.origin.y+machineView[index].frame.size.height+50)
        }
        self.getControllerDetails()
    }
    
    @objc func previewControllerDataAction(sender: UIButton) {
        let buttonTag = sender.tag
        mappingControllerDashboard(tag: buttonTag)
    }
    
    @objc func unitConversionAction(sender: UIButton) {
        let buttonTag = sender.tag
        if strUnitConversion == "CFM" {
            unitConvButton[buttonTag].setImage(UIImage.init(named: "cfmUnitConvertion"), for: .normal)
            strUnitConversion = "LPM"
            dataHeaderLabel[buttonTag].text = "LPM"
            dataLPMLabel[buttonTag].isHidden = false
            dataLabel[buttonTag].isHidden = true
        } else {
            unitConvButton[buttonTag].setImage(UIImage.init(named: "unitConversionIcon"), for: .normal)
            dataHeaderLabel[buttonTag].text = "CFM"
            strUnitConversion = "CFM"
            dataLPMLabel[buttonTag].isHidden = true
            dataLabel[buttonTag].isHidden = false
        }
    }
    
    func mappingControllerDashboard(tag: Int) -> Void {
        print(self.arrMachineList.count)
        print(self.arrMachineList[tag])
        if arrMachineList.count > 0 {
            print(((self.arrMachineList[tag] as AnyObject).object(forKey: RID) as! String))
            dictControllerSpcDetails = NSDictionary()
            dictControllerSpcDetails = Common.mappingControllerWithMachine(systemId: (self.arrMachineList[tag] as AnyObject).object(forKey: RID) as! String, arrController: arrControllerList)
            print(dictControllerSpcDetails)
        }
        if dictControllerSpcDetails.count == 0 || (dictControllerSpcDetails.count != 0 && dictControllerSpcDetails.value(forKey: RID) as! String == "") {
            Common.showCustomAlert(message: "Controller is not configured")
            return
        }
        let CDVC = self.storyboard?.instantiateViewController(withIdentifier: CONTROLLERDATAVIEW) as? ControllerDataViewController
        CDVC?.strSelectedMachineName = machineNameLabel[tag].text!
        CDVC?.strSystemID = ((arrMachineList[tag] as AnyObject).object(forKey: RID) as? String)!
        CDVC?.strControllerID = dictControllerSpcDetails.value(forKey: RID) as! String
        self.navigationController?.pushViewController(CDVC!, animated: true)
    }
    
    //MARK: - IBAction
    @IBAction func drawerMenu_Action(_ sender: UIButton) {
        onSlideMenuButtonPressed(sender: sender)
    }
    @IBAction func deptAction(_ sender: UIButton) {
        let DVC = self.storyboard?.instantiateViewController(withIdentifier: DEPARTMENTVIEW) as? DepartmentViewController
        appDelegate.viewController_Navigation_Type = NAVIGATIONTYPEDEPT
        self.navigationController?.pushViewController(DVC!, animated: true)
    }
    
    //MARK: - UISwipeGestureDelegate Method
    @objc func handleSwipe(_ sender: UITapGestureRecognizer) {
        print("pan gesture called")
        onSlideMenuButtonPressed(sender: menuButton)
    }
    
    //MARK: - API Imeplementation
    func getDashboardSystemListService() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        let methodName = "\(SYSTEM_METHOD_NAME)"+QUERYMARK+GET_PARAM_ORGANIZATIONID+QUERYSYMBOL+oID+QUERYJOIN+GET_PARAM_DEPARTMENTID+QUERYSYMBOL+appDelegate.deptId
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
                            }
                            dictMachineList.setValue((arrTempList[index] as AnyObject).object(forKey: RID) as! String, forKey: RID)
                             dictMachineList.setValue((arrTempList[index] as AnyObject).object(forKey: RNAME) as! String, forKey: RNAME)
                            self.arrMachineList.add(dictMachineList)
                        }
                        print(self.arrMachineList)
//                        do {
//                            try! self.parseMachineList()
//                        } catch _ {
//                            print("error")
//                        }
                        self.parseMachineList()
                    } else {
                        Common.stopPinwheelProcessing()
                        Common.showCustomAlert(message: "No Machine Available")
                    }
                    Common.stopPinwheelProcessing()
                } else if (code == CODE204) {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: "No Machine Available")
                }else {
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
    
    
    func getControllerDetails() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        let methodName = "\(CONTROLLER_METHOD_NAME)"+QUERYMARK+GET_PARAM_ORGANIZATIONID+QUERYSYMBOL+oID+QUERYJOIN+GET_PARAM_DEPARTMENTID+QUERYSYMBOL+appDelegate.deptId
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
                    Common.stopPinwheelProcessing()
                    if results.count > 0 {
                    } else {
                    }
                } else if (code == CODE204) {
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
    //MARK: - Protobuf Parsing
    func parseControllerDetails(responseString: String) {
        print(responseString)
        let response = Common.decodeProtoBufDeviceMQTT(response: responseString)
        print(response)
        print(response.sId!)
        for index in 0 ..< arrMachineList.count {
            print((arrMachineList[index] as AnyObject).object(forKey: RID) as! String)
            if response.sId! == (arrMachineList[index] as AnyObject).object(forKey: RID) as! String {
                print(response.hasCfm)
                if response.hasCfm {
                    dataLabel[index].text = String(format: "%.2f", response.cfm!)
                    dataLPMLabel[index].text = String(response.lpm)
                } else {
                    dataLabel[index].text = "00.00"
                    dataLPMLabel[index].text = "0"
                }
                    parseMachineRangewiseColor(index: index)
                    break
            }
        }
    }
    
    func parseMachineRangewiseColor(index: Int) -> Void {
        var arrSensorList = NSMutableArray()
        if appDelegate.arrDeptNotiList.count > 0 {
            arrSensorList = appDelegate.arrDeptNotiList
        } else {
            let tempArray: NSArray = UserDefaults.standard.array(forKey: SENSORNOTIFICATION)! as NSArray
            arrSensorList = tempArray.mutableCopy() as! NSMutableArray
        }
        print(arrSensorList.count)
        for yindex in 0 ..< arrSensorList.count {
            print(dataLabel[index].text!.count)
            print(dataLabel[index].text!)
            // SRI FEB 14
//            var strData = ""
//            if dataLabel[index].text!.count <= 4 {
//                let value = NumberFormatter().number(from: dataLabel[index].text!)?.floatValue
//                strData = String(format: "%05.2f", value!)
//                print(strData)
//            } else {
//                strData = dataLabel[index].text!
//            }
            print("value \(dataLabel[index].text!)")
            print("from \((arrSensorList[yindex] as AnyObject).value(forKey: RANGEFROM) as! String)")
            print("to \((arrSensorList[yindex] as AnyObject).value(forKey: RANGETO) as! String)")
//            if (strData >= (arrSensorList[yindex] as AnyObject).value(forKey: RANGEFROM) as! String) && (strData <= (arrSensorList[yindex] as AnyObject).value(forKey: RANGETO) as! String){
//                print("index \(index)")
//                machineView[index].backgroundColor = UIColor.init(hexString: (arrSensorList[yindex] as AnyObject).value(forKey: COLORCODE) as! String)
//                return
//            } else {
//                print("index \(index)")
//                machineView[index].backgroundColor = UIColor.init(hexString: "c0783e")
//                return
//            }
            // SRI FEB 14
            let value = NumberFormatter().number(from: dataLabel[index].text!)?.floatValue
            let strDataTemp = String(format: "%06.2f", value!)
            print("strDataTemp \(strDataTemp)")
            
            let valueFrom = NumberFormatter().number(from: (arrSensorList[yindex] as AnyObject).value(forKey: RANGEFROM) as! String)?.floatValue
            let strFromRange = String(format: "%06.2f", valueFrom!)
            print("strFromRange \(strFromRange)")
            
            let valueTo = NumberFormatter().number(from: (arrSensorList[yindex] as AnyObject).value(forKey: RANGETO) as! String)?.floatValue
            let strToRange = String(format: "%06.2f", valueTo!)
            print("strDataTemp \(strToRange)")
            
            if (strDataTemp >= strFromRange) && (strDataTemp <= strToRange) {
                print("index \(index)")
                machineView[index].backgroundColor = UIColor.init(hexString: (arrSensorList[yindex] as AnyObject).value(forKey: COLORCODE) as! String)
                return
            } else {
                print("index \(index)")
                machineView[index].backgroundColor = UIColor.init(hexString: "c0783e")
            }
        }
    }
}

// MARK: - MQTT Delegate Methods
extension DashboardViewController: CocoaMQTTDelegate {
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
            let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
            let subTopic = MQTT_CONTROLLER_PREFIX+"\(oID)"+MQTT_CONTROLLER_SUFFIX
            mqtt.subscribe(subTopic)
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
        parseControllerDetails(responseString: message.string!)
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
        _console("mqttDidDisconnect")
    }
    
    func _console(_ info: String) {
        print("Delegate: \(info)")
    }
}
