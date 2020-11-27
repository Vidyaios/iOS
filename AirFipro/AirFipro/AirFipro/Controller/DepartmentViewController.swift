//
//  DepartmentViewController.swift
//  AirFipro
//
//  Created by ixm1 on 11/11/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit
class departmentViewCell: UITableViewCell {
    @IBOutlet var deptName: UILabel!
    @IBOutlet var deptSelctionImg: UIImageView!
}

class DepartmentViewController: SliderLibViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    //MARK: - Varaiable Declaration
    var swipeGesture = UISwipeGestureRecognizer()
    @IBOutlet var tableViewDepartment: UITableView!
    @IBOutlet var lblMillName: UILabel!
    @IBOutlet var btnBackDept: UIButton!
    @IBOutlet var btnSliderDept: UIButton!
    var dictResponseDept = NSDictionary()
    var arrResponseDept: NSArray = []
    var selectedTag = Int()
    var selectdDept = ""
    var selectedMachineSetupTag = -1
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        widget_Configuration_Dept()
        if appDelegate.strPushNotiLoaded == "" {
            self.appDelegate.strPushNotiLoaded = "YES"
            SwiftEventBus.onMainThread(target as AnyObject, name: "ALERTHANDLER") { result in
                NSLog("color code \(self.appDelegate.strColorCode)")
                NSLog("Alert Type \(self.appDelegate.strPushAlertType)")
                NSLog("Push Desc \(self.appDelegate.strPushDesc)")
                NSLog("Push ID \(self.appDelegate.strPushNID)")
                NSLog("Arr Stack \(self.appDelegate.arrPushGlobal)")
                let dictPush = NSMutableDictionary()
                dictPush.setValue(self.appDelegate.strPushNID, forKey: "id")
                dictPush.setValue(self.appDelegate.strPushSID, forKey: "sid")
                dictPush.setValue(self.appDelegate.strPushDID, forKey: "did")
                dictPush.setValue(self.appDelegate.strPushCID, forKey: "cid")
                dictPush.setValue(self.appDelegate.strPushType, forKey: "ptype")
                dictPush.setValue(self.appDelegate.strPushOID, forKey: "oid")
                self.appDelegate.arrPushGlobal.add(dictPush)
                self.receiveMessage()
            }
        }
        if Common.reachabilityChanged() == true {
            Common.startPinwheelProcessing()
            if UserDefaults.standard.object(forKey: "ORGNAME") as! String != ""{
                self.lblMillName.text = UserDefaults.standard.object(forKey: "ORGNAME") as? String
                getDepartmentListService()
            } else {
                getOrganizationDetails()
            }
            print(appDelegate.viewController_Navigation_Type)
        } else {
            Common.showCustomAlert(message: NWCONNECTION)
        }
    }

    
    func receiveMessage()-> Void {
        NSLog("color code \(appDelegate.strColorCode)")
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "ProximaNova-Semibold", size: 20)!,
            kTextFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
            kButtonFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
            showCloseButton: false,
            dynamicAnimatorActive: true,
            buttonsLayout: .horizontal
        )
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("DONE") {
            NSLog("ok button tapped")
            print("ok button tapped")
            let lastIndex = self.appDelegate.arrPushGlobal.count - 1
            Common.startPinwheelProcessing()
            self.updateNotiListRead(index: lastIndex)
            
        }
        _ = alert.addButton("IGNORE") {
            NSLog("Second button tapped")
            print("Second button tapped")
            self.appDelegate.arrPushGlobal.removeLastObject()
            NSLog("After Remove It\(self.appDelegate.arrPushGlobal)")
            if self.appDelegate.arrPushGlobal.count == 0 {
                NotificationCenter.default.post(name: NSNotification.Name("PushMessageReceivedNotification"), object: "YES")
            }
        }
        
        let icon = SCLAlertViewStyleKit.imageOfWarning
        let color = UIColor.init(hexString: "\(appDelegate.strColorCode)")
        
        _ = alert.showCustom(appDelegate.strPushAlertType, subTitle: appDelegate.strPushDesc, color: color, icon: icon)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("****************************************")
        Common.checkViewControllerStack()
        if appDelegate.viewController_Navigation_Type == NAVIGATIONTYPESYSTEM {
            self.tableViewDepartment.reloadData()
        }
    }
    //MARK: - User Defined Method
    func widget_Configuration_Dept() -> Void {
        if appDelegate.viewController_Navigation_Type == NAVIGATIONTYPESIGNIN {
            self.btnBackDept.isHidden = true
            self.btnSliderDept.isHidden = true
        } else if appDelegate.viewController_Navigation_Type == NAVIGATIONTYPEDEPT {
            self.btnSliderDept.isHidden = true
        } else if appDelegate.viewController_Navigation_Type == NAVIGATIONTYPESYSTEM {
            self.btnBackDept.isHidden = true
            swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeDept(_:)))
            swipeGesture.delegate = self
            swipeGesture.direction = UISwipeGestureRecognizerDirection.right
            self.view.addGestureRecognizer(swipeGesture)
        }
    }
    func assignDeptSelectedData(selIndex: Int) -> Void {
        appDelegate.deptId = (self.arrResponseDept[selIndex] as AnyObject).object(forKey: RID) as! String
        appDelegate.deptName = (self.arrResponseDept[selIndex] as AnyObject).object(forKey: RNAME) as! String
    }
    //MARK: - UISwipeGestureDelegate Method
    @objc func handleSwipeDept(_ sender: UITapGestureRecognizer) {
        print("pan gesture called")
        onSlideMenuButtonPressed(sender: btnSliderDept)
    }
    //MARK: - IBAction
    @IBAction func backDepartmentAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sliderDepartmentAction(_ sender: UIButton) {
        onSlideMenuButtonPressed(sender: sender)
    }
    
    @IBAction func dashboard_refresh_action(_ sender: UIButton) {
        if Common.reachabilityChanged() == true {
            Common.startPinwheelProcessing()
            if self.arrResponseDept.count > 0 {
                self.arrResponseDept = NSArray()
                tableViewDepartment.reloadData()
            }
            if UserDefaults.standard.object(forKey: "ORGNAME") as! String != ""{
                self.lblMillName.text = UserDefaults.standard.object(forKey: "ORGNAME") as? String
                getDepartmentListService()
            } else {
                getOrganizationDetails()
            }
        } else {
            Common.showCustomAlert(message: NWCONNECTION)
        }
    }
    
    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : departmentViewCell = tableView.dequeueReusableCell(withIdentifier: "departmentViewCell")! as! departmentViewCell
        cell.deptName.text = (self.arrResponseDept[indexPath.row] as AnyObject).object(forKey: RNAME) as? String
        if appDelegate.viewController_Navigation_Type == NAVIGATIONTYPESIGNIN {
            cell.deptSelctionImg.image = UIImage(named: "departmentUnSelect")
        } else if appDelegate.viewController_Navigation_Type == NAVIGATIONTYPESYSTEM {
            if selectedMachineSetupTag == indexPath.row {
                cell.deptSelctionImg.image = UIImage(named: "departmentSelect")
            } else {
                cell.deptSelctionImg.image = UIImage(named: "departmentUnSelect")
            }
        } else {
            if appDelegate.deptId == (self.arrResponseDept[indexPath.row] as AnyObject).object(forKey: RID) as? String {
                cell.deptSelctionImg.image = UIImage(named: "departmentSelect")
            } else {
                cell.deptSelctionImg.image = UIImage(named: "departmentUnSelect")
            }
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected Cell \(indexPath.row)")
        selectedTag = indexPath.row
        print("Selected Cell \(selectedTag)")
        selectedMachineSetupTag = selectedTag
        selectdDept = (self.arrResponseDept[indexPath.row] as AnyObject).object(forKey: RID) as! String
        if Common.reachabilityChanged() == true {
            Common.startPinwheelProcessing()
            getNotificationBasicDetails()
        } else {
            Common.showCustomAlert(message: NWCONNECTION)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrResponseDept.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43
    }
    
    //MARK: - API Implementation    
    func getDepartmentListService() -> Void {
        print(UserDefaults.standard.object(forKey: RUSERID) as! String)
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        print(oID)
        let methodName = "\(DEPARTMENT_METHOD_NAME)"+QUERYMARK+GET_PARAM_ORGANIZATIONID+QUERYSYMBOL+oID
        print(methodName)
        ServiceConnector.serviceConnectorGET(methodName) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                self.dictResponseDept = NSDictionary()
                self.dictResponseDept = responseObject! as NSDictionary
                print(self.dictResponseDept)
                if (code == CODE200) {
                   self.arrResponseDept = NSArray()
                   self.arrResponseDept = self.dictResponseDept.value(forKey: RESULTS) as! NSArray
                    print(self.arrResponseDept.count)
                    print(self.arrResponseDept)
                    if (self.arrResponseDept.count > 0) {
                        Common.stopPinwheelProcessing()
                        self.tableViewDepartment.delegate = self
                        self.tableViewDepartment.dataSource = self
                        self.tableViewDepartment.reloadData()
                    } else {
                        Common.stopPinwheelProcessing()
                        Common.showCustomAlert(message: NORECORDSFOUND)
                    }
                } else if (code == CODE204) {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: NORECORDSFOUND)
                } else {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: self.dictResponseDept))
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }
    
    func getNotificationBasicDetails() -> Void {
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
                var dictResponse = NSDictionary()
                dictResponse = responseObject! as NSDictionary
                print(dictResponse)
                if (code == CODE200) {
                    let results = dictResponse.value(forKey: RESULTS) as! NSArray
                    print(results)
                    if results.count > 0 {
                        let arrItem: NSArray = results.value(forKey: PREFERENCEITEM) as! NSArray
                        print(arrItem[0])
                        if arrItem.count > 0 {
                            self.parseNotificationList(arrNotiList: arrItem[0] as! NSArray)
                            return
                        }
                    }
                    Common.stopPinwheelProcessing()
                    self.navigateDashBorad()
                } else {
                    Common.stopPinwheelProcessing()
                    self.navigateDashBorad()
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                self.navigateDashBorad()
            }
        }
    }
    
    func parseNotificationList(arrNotiList: NSArray) -> Void {
        appDelegate.arrDeptNotiList = NSMutableArray()
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
            appDelegate.arrDeptNotiList.add(dictNotiKeyValues)
            print(appDelegate.arrDeptNotiList)
        }
        Common.stopPinwheelProcessing()
        self.navigateDashBorad()
    }
    
    func navigateDashBorad() -> Void {
        if appDelegate.viewController_Navigation_Type == NAVIGATIONTYPESIGNIN {
            self.assignDeptSelectedData(selIndex: selectedTag)
            let DVC : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "DashboardViewController")
            let newStack = [DVC]
            self.navigationController!.setViewControllers(newStack, animated: true)
        } else if appDelegate.viewController_Navigation_Type == NAVIGATIONTYPEDEPT {
            if (self.arrResponseDept[selectedTag] as AnyObject).object(forKey: RID) as! String == appDelegate.deptId {
                self.navigationController?.popViewController(animated: true)
                return
            }
            appDelegate.deptStatus = "YES"
            self.assignDeptSelectedData(selIndex: selectedTag)
            self.navigationController?.popViewController(animated: true)
        } else if appDelegate.viewController_Navigation_Type == NAVIGATIONTYPESYSTEM {
            let systemListVC = self.storyboard?.instantiateViewController(withIdentifier: SYSTEMLISTVIEW) as? SystemListViewController
            systemListVC?.strDeptName = ((self.arrResponseDept[selectedTag] as AnyObject).object(forKey: RNAME) as? String)!
            systemListVC?.strDeptId = ((self.arrResponseDept[selectedTag] as AnyObject).object(forKey: RID) as? String)!
            self.navigationController?.pushViewController(systemListVC!, animated: true)
        }
    }
    func getOrganizationDetails() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        print(oID)
        let methodName = "\(ORGANIZATION_METHOD_NAME)"+QUERYMARK+DELETE_PARAMID+QUERYSYMBOL+oID
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
                    if results.count > 0 {
                        print((results[0] as AnyObject).object(forKey: "name") as! String)
                        UserDefaults.standard.setValue((results[0] as AnyObject).object(forKey: "name") as! String, forKey: "ORGNAME")
                        let arrKeyValues = (results[0] as AnyObject).object(forKey: "keyValues") as! NSArray
                        print(arrKeyValues)
                        var dictOrgDetails = NSMutableDictionary()
                        dictOrgDetails = Common.parseTypeCollection(strTypeCollection: MACHINETYPECOLLECTION, arrKeyValues: arrKeyValues)
                        print(dictOrgDetails)
                        let arrAddress = (results[0] as AnyObject).object(forKey: "addresses") as! NSArray
                        print(arrAddress)
                        print(arrAddress.count)
                        print(UserDefaults.standard.string(forKey: TIMEZONE)! as String)
                        let arrStreet = (arrAddress[0] as AnyObject).object(forKey: "streets") as! NSArray
                        print(arrStreet[0])
                        print((arrAddress[0] as AnyObject).object(forKey: "country") as! String)
                        let strAddress = "\(arrStreet[0]),\((arrAddress[0] as AnyObject).object(forKey: "city") as! String),\((arrAddress[0] as AnyObject).object(forKey: "state") as! String),\((arrAddress[0] as AnyObject).object(forKey: "country") as! String)-\((arrAddress[0] as AnyObject).object(forKey: "postalCode") as! String)"
                        print(strAddress)
                        dictOrgDetails.setValue(strAddress, forKey: FEEDBACKADDRKEY)
                        print(dictOrgDetails)
                        UserDefaults.standard.set(strAddress, forKey: FEEDBACKADDRKEY)
                        self.lblMillName.text = (results[0] as AnyObject).object(forKey: "name") as? String
                        self.getDepartmentListService()
                    } else {
                        Common.stopPinwheelProcessing()
                        Common.showCustomAlert(message: NORECORDSFOUND)
                    }
                } else if (code == CODE204) {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: NORECORDSFOUND)

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
    
    func updateNotiListRead(index: Int) -> Void {
        let dict = NSMutableDictionary()
        dict.setValue((appDelegate.arrPushGlobal[index] as AnyObject).object(forKey: "id") as! String, forKey: RID)
        dict.setValue((appDelegate.arrPushGlobal[index] as AnyObject).object(forKey: "oid") as! String, forKey: RORGANIZATIONID)
        dict.setValue((appDelegate.arrPushGlobal[index] as AnyObject).object(forKey: "did") as! String, forKey: DEPARTMENTID)
        dict.setValue((appDelegate.arrPushGlobal[index] as AnyObject).object(forKey: "sid") as! String, forKey: SYSTEMID)
        dict.setValue((appDelegate.arrPushGlobal[index] as AnyObject).object(forKey: "cid") as! String, forKey: CONTROLLERID)
        dict.setValue("DONE", forKey: STATE)
        dict.setValue((appDelegate.arrPushGlobal[index] as AnyObject).object(forKey: "ptype") as! String, forKey: RTYPE)
        appDelegate.arrPushGlobal.removeLastObject()
        NSLog("After Remove It\(appDelegate.arrPushGlobal)")
        let parameters: NSDictionary = ServiceConnector.updateNotiListRequestParameter(dictUpdateList: dict)
        print("Dict JSON Formation update notification list \(parameters)")
        ServiceConnector.serviceConnectorPUT(NOTIFICATIONLIST_METHOD_NAME, inputParam: parameters as! NSMutableDictionary) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResponseSystem = NSDictionary()
                dictResponseSystem = responseObject! as NSDictionary
                print(dictResponseSystem)
                if (code == CODE200) {
                    Common.stopPinwheelProcessing()
                } else {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: dictResponseSystem))
                }
                if self.appDelegate.arrPushGlobal.count == 0 {
                    NotificationCenter.default.post(name: NSNotification.Name("PushMessageReceivedNotification"), object: "YES")
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
                if self.appDelegate.arrPushGlobal.count == 0 {
                    NotificationCenter.default.post(name: NSNotification.Name("PushMessageReceivedNotification"), object: "YES")
                }
            }
        }
    }
   
}
