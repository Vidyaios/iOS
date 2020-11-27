//
//  ControllerDataViewController.swift
//  AirFipro
//
//  Created by ixm1 on 11/16/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit

class controllerDataTableViewCell: UITableViewCell {
    @IBOutlet var lblDateCell: UILabel!
    @IBOutlet var lblTimeCell: UILabel!
    @IBOutlet var lblCFMValueCell: UILabel!
    @IBOutlet var reportDataCellButton: UIButton!
}

class ControllerDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    //MARK: - Varaiable Declaration
    @IBOutlet var lblMachineName: UILabel!
    @IBOutlet var controllerDateHeaderView: UIView!
    @IBOutlet var lblDeptName: UILabel!
    @IBOutlet var lblShiftName: UILabel!
    @IBOutlet var dataAverageView: UIView!
    @IBOutlet var lblAverageCFMValue: UILabel!
    @IBOutlet var controllerDataTableView: UITableView!
    
    @IBOutlet var cntrlDataCommentView: UIView!
    @IBOutlet var cntrlCommentTimeLabel: UILabel!
    
    @IBOutlet var cntrlCommentLabel: UILabel!
    
    var strSelectedMachineName = ""
    var arrControllerData = NSMutableArray()
    var arrShiftList = NSMutableArray()
    var dictControllerData = NSDictionary()
    var arrReport = NSArray()
    var strSystemID = ""
    var strControllerID = ""
    var shiftDate = ""
    var shiftStTime = ""
    var shiftEndTime = ""
    var shiftName = ""
    var avgData: Float = 0
    var totalAvgData: Float = 0.0
    var arrShiftData = NSArray()
    var loadStatus = ""
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerData_InitialSetup()
        Common.startPinwheelProcessing()
        self.getCurrentShiftDataAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - User Defined Methods
    func controllerData_InitialSetup() {
        cntrlDataCommentView.isHidden = true
        lblMachineName.text = strSelectedMachineName
        lblDeptName.text = appDelegate.deptName
        controllerDataTableView.frame = CGRect.init(x: controllerDataTableView.frame.origin.x, y: controllerDateHeaderView.frame.origin.y + controllerDateHeaderView.frame.size.height, width: controllerDataTableView.frame.size.width, height: dataAverageView.frame.origin.y - (controllerDateHeaderView.frame.origin.y + controllerDateHeaderView.frame.size.height))
    }
    
    
    //MARK: - IBAction
    @IBAction func back_ControllerData_Action(_ sender: UIButton) {
        print("btnTag==\(sender.tag)")
        switch sender.tag {
        case 0: // back
            let _ = self.navigationController?.popViewController(animated: true)
            break
        case 1: // close
            cntrlDataCommentView.isHidden = true
            break
        default:
            print("default")
        }
    }
    
    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : controllerDataTableViewCell = tableView.dequeueReusableCell(withIdentifier: "controllerDataTableViewCell")! as! controllerDataTableViewCell
        cell.lblDateCell.text = self.shiftDate
        print(self.arrReport[indexPath.row])
        print((self.arrReport[indexPath.row] as AnyObject).object(forKey: "startTime") as! String)
    let timeStr = "\(Common.parseDateAndTimeReports(curDate: Common.UTCToLocal_DateTime(date: (self.arrReport[indexPath.row] as AnyObject).object(forKey: "startTime") as! String))) - \(Common.parseDateAndTimeReports(curDate: Common.UTCToLocal_DateTime(date: (self.arrReport[indexPath.row] as AnyObject).object(forKey: "endTime") as! String)))"

        print(timeStr)
        cell.lblTimeCell.text = timeStr
     
        var arrTempComments: NSArray = []
        arrTempComments = (self.arrReport[indexPath.row] as AnyObject).object(forKey: "comments") as! NSArray
        if arrTempComments.count > 0 {
            cell.reportDataCellButton.setImage(UIImage.init(named: "shiftwisePreviewSelected"), for: .normal)
            cell.reportDataCellButton.isUserInteractionEnabled = true
        } else {
            cell.reportDataCellButton.setImage(UIImage.init(named: "shiftWisePreview"), for: .normal)
            cell.reportDataCellButton.isUserInteractionEnabled = false
        }
        cell.reportDataCellButton.addTarget(self, action: #selector(ControllerDataViewController.commentpreviewAction), for: .touchUpInside)
        cell.reportDataCellButton.tag = indexPath.row
        
        var arrValues = (self.arrReport[indexPath.row] as AnyObject).object(forKey: "keyValues") as! NSArray
        arrValues = (arrValues[0] as AnyObject).object(forKey: VALUE) as! NSArray
        print(arrValues)
        print(arrValues[0])
        let cfmFloat: Float = Float(arrValues[0] as! String)!
        print(cfmFloat)
        cell.lblCFMValueCell.text = String(format: "%.2f", cfmFloat)
        print(cell.lblCFMValueCell.text!)
        return cell
    }
    
    @objc func commentpreviewAction(sender: UIButton) {
        print(sender.tag)
        print(arrReport[sender.tag])
        let dictComment = arrReport[sender.tag] as! NSDictionary
        print(dictComment)
        let arrCom = dictComment.value(forKey: "comments") as! NSArray
        let dict: NSDictionary = arrCom[0] as! NSDictionary
        print(dict.value(forKey: "startDateTime") as! String)
        var arrCommentKey = NSArray()
        arrCommentKey = dict.value(forKey: RKEYVALUES) as! NSArray
        print("arr values \(arrCommentKey)")
        print("arr count \(arrCommentKey.count)")
        var dictCommentKeyValues = NSMutableDictionary()
        dictCommentKeyValues = Common.parseTypeCollection(strTypeCollection: MACHINETYPECOLLECTION, arrKeyValues: arrCommentKey)
        dictCommentKeyValues.setValue("\(Common.parseDateAndTimeReports(curDate: Common.UTCToLocal_DateTime(date: dict.value(forKey: "startDateTime") as! String))) - \(Common.parseDateAndTimeReports(curDate: Common.UTCToLocal_DateTime(date: dict.value(forKey: "endDateTime") as! String)))" , forKey: "CommentTime")
        print(dictCommentKeyValues)
        cntrlCommentTimeLabel.text = dictCommentKeyValues.value(forKey: "CommentTime")! as? String
        cntrlCommentLabel.text = dictCommentKeyValues.value(forKey: RCOMMENTS)! as? String
        cntrlDataCommentView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected Cell \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrReport.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    //MARK: - API Implementation
    func getCurrentShiftDataAPI() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        print(oID)
        let methodName = "\(PREFERENCE_METHOD_NAME)"+QUERYMARK+GET_PARAM_ORGANIZATIONID+QUERYSYMBOL+oID+QUERYJOIN+GET_TYPE+QUERYSYMBOL+GET_PARAM_SHIFT+QUERYJOIN+GET_CURRENT_TYPE+QUERYSYMBOL+GET_PARAM_SHIFT_TYPE
        print(methodName)
        ServiceConnector.serviceConnectorGET(methodName) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResponseShift = NSDictionary()
                dictResponseShift = responseObject! as NSDictionary
                print(dictResponseShift)
                if (code == CODE200) {
                    self.arrShiftData = NSArray()
                    self.arrShiftData = dictResponseShift.value(forKey: RESULTS) as! NSArray
                    print(self.arrShiftData.count)
                    if (self.arrShiftData.count > 0) {
                        self.arrShiftList = NSMutableArray()
                        for index in 0 ..< self.arrShiftData.count {
                            self.arrShiftList.add(Common.parseShiftDataTiming(arrShift: self.arrShiftData, index: index))
                        }
                        print(self.arrShiftList)
                        self.aggregateApiCurrentReport()
                    } else {
                        Common.stopPinwheelProcessing()
                        Common.showCustomAlert(message: NORECORDSFOUND)
                    }
                } else if (code == CODE204) {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: NORECORDSFOUND)
                } else {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: dictResponseShift))
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }
    func aggregateApiCurrentReport() -> Void {
        self.shiftDate = Common.currentDateAgg()
        var arrParseShift = (self.arrShiftData[0] as AnyObject).object(forKey: "preferenceItem") as! NSArray
        if arrParseShift.count > 0 {
            print((arrParseShift[0] as AnyObject).object(forKey: "name") as! String)
            self.shiftName = (arrParseShift[0] as AnyObject).object(forKey: "name") as! String
            arrParseShift = (arrParseShift[0] as AnyObject).object(forKey: "keyValues") as! NSArray
            print(arrParseShift.count)
            if arrParseShift.count >= 2 {
                if (arrParseShift[0] as AnyObject).object(forKey: "key") as! String == "TIME_FROM" {
                    let arrData = (arrParseShift[0] as AnyObject).object(forKey: "values") as! NSArray
                    shiftStTime = arrData[0] as! String
                }
                if (arrParseShift[1] as AnyObject).object(forKey: "key") as! String == "TIME_TO" {
                    let arrData = (arrParseShift[1] as AnyObject).object(forKey: "values") as! NSArray
                    shiftEndTime = arrData[0] as! String
                }
                print(shiftStTime)
                print(shiftEndTime)
                self.lblShiftName.text = "\(self.shiftName), "+"\(Common.parseShiftTimeFormat(time: Common.UTCToLocal_Time(date: self.shiftStTime)))"+" - "+"\(Common.parseShiftTimeFormat(time: Common.UTCToLocal_Time(date: self.shiftEndTime)))"
                self.getCurrentReportAPI()
                return
            }
        }
        Common.stopPinwheelProcessing()
    }

    func getCurrentReportAPI() -> Void {
        print(shiftStTime)
        print(shiftEndTime)
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        let dictReports = NSMutableDictionary()
        dictReports.setValue(oID, forKey: RORGANIZATIONID)
        dictReports.setValue(appDelegate.deptId, forKey: DEPARTMENTID)
        dictReports.setValue(self.strSystemID, forKey: SYSTEMID)
        dictReports.setValue(self.strControllerID, forKey: CONTROLLERID)
        dictReports.setValue(GET_LIVE_AGGREGATE, forKey: GET_CURRENT_TYPE)
        dictReports.setValue("", forKey: GET_PARAM_SUBTYPE)
        let arrShiftTimePayLoad = NSMutableArray()
        for index in 0 ..< self.arrShiftList.count {
            print((self.arrShiftList[index] as AnyObject).object(forKey: "startTime") as! String)
            shiftStTime = (self.arrShiftList[index] as AnyObject).object(forKey: "startTime") as! String
            shiftEndTime = (self.arrShiftList[index] as AnyObject).object(forKey: "endTime") as! String
            let strResult = Common.convertStringToDateTime_compare(startTime: "\(Common.currentDate()) \(shiftStTime)", endTIme: "\(Common.currentDate()) \(shiftEndTime)")
            print(strResult)
            shiftStTime = "\(Common.currentDate()) \(shiftStTime)"
            print(shiftStTime)
            if strResult == "CURRENTDATE" {
                print("current date")
                shiftEndTime = "\(Common.currentDate()) \(shiftEndTime)"
                print(shiftEndTime)
            } else {
                print("next date")
                shiftEndTime = "\(Common.getNextDate(dateString: Common.currentDate())) \(shiftEndTime)"
                print(shiftEndTime)
            }
            arrShiftTimePayLoad.add(Common.payloadShiftForming(stTime: shiftStTime, endTime: shiftEndTime, prefID: (self.arrShiftList[index] as AnyObject).object(forKey: "id") as! String))
        }
        dictReports.setValue(arrShiftTimePayLoad, forKey: "duration")
        print(dictReports)
        let parameters: NSDictionary = ServiceConnector.setReportParameter(dictReport: dictReports)
        print("Dict JSON Formation Reports\(parameters)")
        ServiceConnector.serviceConnectorPOST(DAILYREPORT_METHOD_NAME, inputParam: parameters as! NSMutableDictionary) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                self.loadStatus = ""
                var dictResponseDailyReport = NSDictionary()
                dictResponseDailyReport = responseObject! as NSDictionary
                if (code == CODE201) {
                    Common.stopPinwheelProcessing()
                    self.arrReport = NSArray()
                    self.arrReport = dictResponseDailyReport.value(forKey: RESULTS) as! NSArray
                    print(self.arrReport.count)
                    print(self.arrReport)
                    if self.arrReport.count > 0 {
                        for index in 0 ..< self.arrReport.count {
                            var arrValues = (self.arrReport[index] as AnyObject).object(forKey: "keyValues") as! NSArray
                            arrValues = (arrValues[0] as AnyObject).object(forKey: VALUE) as! NSArray
                            print(arrValues)
                            print(arrValues[0])
                            let cfmFloat: Float = Float(arrValues[0] as! String)!
                            print(cfmFloat)
                            let cfmString = String(format: "%.2f", cfmFloat)
                            print(cfmString)
                            var avgT: Float = 0
                            avgT = Float(cfmString)!
                            print(avgT)
                            print(self.avgData)
                            self.avgData = self.avgData + avgT
                            print(self.avgData)
                            self.totalAvgData = self.avgData / Float(self.arrReport.count)
                            print(self.totalAvgData)
                            self.lblAverageCFMValue.text = "\(String(format: "%.2f", self.totalAvgData))"
                        }
                    } else {
                        Common.showCustomAlert(message: NORECORDSFOUND)
                        return
                    }
                    self.controllerDataTableView.delegate = self
                    self.controllerDataTableView.dataSource = self
                    self.controllerDataTableView.reloadData()
                    self.controllerDataTableView.tableFooterView = UIView()
                } else {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: dictResponseDailyReport))
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }
    
}




