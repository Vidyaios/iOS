//
//  NotiListViewController.swift
//  AirFipro
//
//  Created by iexm01 on 26/12/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit

class notiListViewCell: UITableViewCell {
    @IBOutlet var notiAlertTypeImg: UIImageView!
    @IBOutlet var notiListDateLabel: UILabel!
    @IBOutlet var notiListTimeLabel: UILabel!
    @IBOutlet var notiListDeptNameLabel: UILabel!
    @IBOutlet var notiListMachineNameLabel: UILabel!
    @IBOutlet var notiListAlertLabel: UILabel!
    @IBOutlet var notiListDoneButton: UIButton!
    @IBOutlet var notiDividerView: UIView!
    @IBOutlet var notiDividerView1: UIView!
}


class NotiListViewController: SliderLibViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Variable Declaration
    var swipeGesture = UISwipeGestureRecognizer()
    var arrAllNotiAlertList = NSMutableArray()
    var arrDepartment = NSArray()
    var arrSystem = NSArray()
    var buttonTag = Int()
    
    @IBOutlet var notiListMenuButton: UIButton!
    @IBOutlet var notiListTableView: UITableView!
    
    
    //MARk: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        notiList_widget_initialSetup()
        if Common.reachabilityChanged() == true {
            Common.startPinwheelProcessing()
            self.getDeptListAPINotiList()
        } else {
            Common.showCustomAlert(message: NWCONNECTION)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.incomingPushNotificationList), name: NSNotification.Name(rawValue: "PushMessageReceivedNotification"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func incomingPushNotificationList(_ notification: Notification) {
        if notification.object! as! String == "YES" {
            if Common.reachabilityChanged() == true {
                Common.startPinwheelProcessing()
                arrAllNotiAlertList = NSMutableArray()
                notiListTableView.reloadData()
                self.getDeptListAPINotiList()
            } else {
                Common.showCustomAlert(message: NWCONNECTION)
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - UISwipeGestureDelegate Method
    @objc func handleSwipePreference(_ sender: UITapGestureRecognizer) {
        print("pan gesture called")
        onSlideMenuButtonPressed(sender: notiListMenuButton)
    }

    //MARK: - User Defined Methods
    func notiList_widget_initialSetup() {
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipePreference(_:)))
        swipeGesture.delegate = self
        swipeGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    //MARK: - IBAction
    @IBAction func notificationList_widget_action(_ sender: UIButton) {
        onSlideMenuButtonPressed(sender: notiListMenuButton)
    }
    
    //MARK: - API Implementation
    func getDeptListAPINotiList() -> Void {
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
                var dictResponseDept = NSDictionary()
                dictResponseDept = responseObject! as NSDictionary
                if (code == CODE200) {
                    self.arrDepartment = NSArray()
                    self.arrDepartment = dictResponseDept.value(forKey: RESULTS) as! NSArray
                    print(self.arrDepartment.count)
                    if (self.arrDepartment.count > 0) {
                        self.getSystemListAPIForNotiList()
                    } else {
                        Common.stopPinwheelProcessing()
                        Common.showCustomAlert(message: NORECORDSFOUND)
                    }
                } else if (code == CODE204) {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: NORECORDSFOUND)
                } else {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: dictResponseDept))
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }
    
    func getSystemListAPIForNotiList() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        let methodName = "\(SYSTEM_METHOD_NAME)"+QUERYMARK+GET_PARAM_ORGANIZATIONID+QUERYSYMBOL+oID
        print(methodName)
        ServiceConnector.serviceConnectorGET(methodName) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResponseSystem = NSDictionary()
                dictResponseSystem = responseObject! as NSDictionary
                print(dictResponseSystem)
                if (code == CODE200) {
                    self.arrSystem = NSArray()
                    self.arrSystem = dictResponseSystem.value(forKey: RESULTS) as! NSArray
                    if self.arrSystem.count > 0 {
                        self.getNotiAlertList()
                    } else {
                        Common.stopPinwheelProcessing()
                        Common.showCustomAlert(message: NORECORDSFOUND)
                    }
                } else if (code == CODE204) {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: NORECORDSFOUND)
                } else {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: dictResponseSystem))
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }
    
    func getNotiAlertList() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        let methodName = "\(NOTIFICATIONLIST_METHOD_NAME)"+QUERYMARK+GET_PARAM_ORGANIZATIONID+QUERYSYMBOL+oID+QUERYJOIN+GET_PARAM_OFFSET+QUERYSYMBOL+"0"+QUERYJOIN+GET_PARAM_LIMIT+QUERYSYMBOL+"1000"
        print(methodName)
        ServiceConnector.serviceConnectorGET(methodName) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResponseSystem = NSDictionary()
                dictResponseSystem = responseObject! as NSDictionary
                print(dictResponseSystem)
                if (code == CODE200) {
                    var arrNotiTemp = NSArray()
                    arrNotiTemp = dictResponseSystem.value(forKey: RESULTS) as! NSArray
                    print(arrNotiTemp)
                    self.arrAllNotiAlertList = NSMutableArray()
                    self.arrAllNotiAlertList = arrNotiTemp.mutableCopy() as! NSMutableArray
                    print(self.arrAllNotiAlertList)
                    if self.arrAllNotiAlertList.count > 0 {
                        print(self.arrAllNotiAlertList)
                        print(self.arrAllNotiAlertList.count)
                        self.notiListTableView.delegate = self
                        self.notiListTableView.dataSource = self
                        self.notiListTableView.reloadData()
                    } else {
                        Common.stopPinwheelProcessing()
                        Common.showCustomAlert(message: NORECORDSFOUND)
                    }
                } else if (code == CODE204) {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: NORECORDSFOUND)
                } else {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: dictResponseSystem))
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }
    
    func updateNotiList() -> Void {
        let dict = NSMutableDictionary()
        dict.setValue((self.arrAllNotiAlertList[buttonTag] as AnyObject).object(forKey: "id") as! String, forKey: RID)
        dict.setValue(UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String, forKey: RORGANIZATIONID)
        dict.setValue((self.arrAllNotiAlertList[buttonTag] as AnyObject).object(forKey: "departmentId") as! String, forKey: DEPARTMENTID)
        dict.setValue((self.arrAllNotiAlertList[buttonTag] as AnyObject).object(forKey: "systemId") as! String, forKey: SYSTEMID)
        dict.setValue((self.arrAllNotiAlertList[buttonTag] as AnyObject).object(forKey: "controllerId") as! String, forKey: CONTROLLERID)
        dict.setValue("DONE", forKey: STATE)
        dict.setValue((self.arrAllNotiAlertList[buttonTag] as AnyObject).object(forKey: "type") as! String, forKey: RTYPE)
        
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
                    let results = dictResponseSystem.value(forKey: RESULTS) as! NSDictionary
                    print(results)
                    self.arrAllNotiAlertList.replaceObject(at: self.buttonTag, with: results)
                    print(self.arrAllNotiAlertList)
                    self.notiListTableView.delegate = self
                    self.notiListTableView.dataSource = self
                    self.notiListTableView.reloadData()
                } else {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: dictResponseSystem))
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : notiListViewCell = tableView.dequeueReusableCell(withIdentifier: "notiListViewCell")! as! notiListViewCell
        // Dept Name
        for dindex in 0..<self.arrDepartment.count {
            if (self.arrAllNotiAlertList[indexPath.row] as AnyObject).object(forKey: "departmentId") as! String == (self.arrDepartment[dindex] as AnyObject).object(forKey: "id") as! String {
                cell.notiListDeptNameLabel.text = (self.arrDepartment[dindex] as AnyObject).object(forKey: "name") as? String
                
                /***********************************/
                cell.notiListDeptNameLabel.frame.size.width =  cell.notiListDeptNameLabel.intrinsicContentSize.width
                /***********************************/
                
                break
            }
        }
        
        /***********************************/
        cell.notiDividerView1.frame.origin.x = cell.notiListDeptNameLabel.frame.origin.x + cell.notiListDeptNameLabel.frame.size.width + 10
        /***********************************/
        
        // System Name
        for sindex in 0..<self.arrSystem.count {
            if (self.arrAllNotiAlertList[indexPath.row] as AnyObject).object(forKey: "systemId") as! String == (self.arrSystem[sindex] as AnyObject).object(forKey: "id") as! String {
                cell.notiListMachineNameLabel.text = (self.arrSystem[sindex] as AnyObject).object(forKey: "name") as? String
                
                /***********************************/
                cell.notiListMachineNameLabel.frame.size.width =  cell.notiListMachineNameLabel.intrinsicContentSize.width
                cell.notiListMachineNameLabel.frame.origin.x = cell.notiDividerView1.frame.origin.x + cell.notiDividerView1.frame.size.width + 10
                /***********************************/
                
                break
            }
        }
        
        // Description
        var arrNotiKey = NSArray()
        arrNotiKey = (self.arrAllNotiAlertList[indexPath.row] as AnyObject).object(forKey: "keyValues") as! NSArray
        print("arr values \(arrNotiKey)")
        print("arr count \(arrNotiKey.count)")
        var dictNotiKeyValues = NSMutableDictionary()
        dictNotiKeyValues = Common.parseTypeCollection(strTypeCollection: MACHINETYPECOLLECTION, arrKeyValues: arrNotiKey)
        print(dictNotiKeyValues)
        cell.notiListAlertLabel.text = dictNotiKeyValues.value(forKey: RDESCRIPTION) as? String
        
        if (self.arrAllNotiAlertList[indexPath.row] as AnyObject).object(forKey: "state") as! String == "DONE" {
            cell.notiListDoneButton.isHidden = true
        } else {
            cell.notiListDoneButton.isHidden = false
        }
        cell.notiListDoneButton.addTarget(self, action: #selector(NotiListViewController.notiListDoneAction), for: .touchUpInside)
        cell.notiListDoneButton.tag = indexPath.row
        if dictNotiKeyValues.value(forKey: DATETIME) != nil {
            cell.notiListDateLabel.text = Common.convertDateFormater(Common.UTCToLocal_DateTime(date: dictNotiKeyValues.value(forKey: DATETIME)! as! String))
            
            /***********************************/
            cell.notiListDateLabel.frame.size.width =  cell.notiListDateLabel.intrinsicContentSize.width
            cell.notiDividerView.frame.origin.x = cell.notiListDateLabel.frame.origin.x + cell.notiListDateLabel.frame.size.width + 10
            /***********************************/
            
            cell.notiListTimeLabel.text = Common.parseDateAndTimeReports(curDate: Common.UTCToLocal_DateTime(date: dictNotiKeyValues.value(forKey: DATETIME)! as! String))
          
            /***********************************/
            cell.notiListTimeLabel.frame.size.width =  cell.notiListTimeLabel.intrinsicContentSize.width
            cell.notiListTimeLabel.frame.origin.x = cell.notiDividerView.frame.origin.x + cell.notiDividerView.frame.size.width + 10
            /***********************************/

        }
        if dictNotiKeyValues.value(forKey: ALERTTYPE) != nil {
            if dictNotiKeyValues.value(forKey: ALERTTYPE) as! String == "INFO" {
                cell.notiAlertTypeImg.image = UIImage(named: "info")
            } else if dictNotiKeyValues.value(forKey: ALERTTYPE) as! String == "URGENT" {
                cell.notiAlertTypeImg.image = UIImage(named: "urgent")
            } else if dictNotiKeyValues.value(forKey: ALERTTYPE) as! String == "WARN" {
                cell.notiAlertTypeImg.image = UIImage(named: "warning")
            }
        }
        Common.stopPinwheelProcessing()
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    
    @objc func notiListDoneAction(sender: UIButton) {
        buttonTag = sender.tag
        print(sender.tag)
        if Common.reachabilityChanged() == true {
            Common.startPinwheelProcessing()
            self.updateNotiList()
        } else {
            Common.showCustomAlert(message: NWCONNECTION)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected Cell \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAllNotiAlertList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
