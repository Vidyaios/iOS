//
//  PeriodicalViewController.swift
//  AirFipro
//
//  Created by iexm01 on 28/11/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit

class reportTableViewCell: UITableViewCell {
    @IBOutlet var reportTimeLabel: UILabel!
    @IBOutlet var commentLabel: MarqueeLabel!
}


class PeriodicalViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Varaiable Declaration
    var preportContainerView = [UIView](repeating: UIView(), count: 1000)
    var pdeptNameLabel = [UILabel](repeating: UILabel(), count: 1000)
    var pdateLabel = [UILabel](repeating: UILabel(), count: 1000)
    var pshiftLabel = [UILabel](repeating: UILabel(), count: 1000)
    var periodicTimetLabel = [UILabel](repeating: UILabel(), count: 1000)
    
    var preportListView = [UIView](repeating: UIView(), count: 1000)
    var pmachineNameLabel = [UILabel](repeating: UILabel(), count: 1000)
    var pcfmLabel = [UILabel](repeating: UILabel(), count: 1000)
    var plblConstTypeValue = [UILabel](repeating: UILabel(), count: 1000)
    var plblWeftValue = [UILabel](repeating: UILabel(), count: 1000)
    var plblWrapValue = [UILabel](repeating: UILabel(), count: 1000)
    var ppreviewButton = [UIButton](repeating: UIButton(), count: 1000)

    
    @IBOutlet var reportHeaderLabel: UILabel!
    @IBOutlet var reportDateHeaderView: UIView!
    @IBOutlet var reportScrollView: UIScrollView!
    @IBOutlet var periodicDatePickerView: UIView!
    @IBOutlet var periodicDatePicker: UIDatePicker!
    @IBOutlet var dateFromTextfield: UITextField!
    @IBOutlet var dateToTextfield: UITextField!
    
    @IBOutlet var commentTableView: UITableView!
    @IBOutlet var commentDetailView: UIView!
    @IBOutlet var dateSubmitButton: UIButton!
    
    var strSelectedPicker = ""
    var strStDateStatus = ""
    var strEndDateStatus = ""
    var arrShiftData = NSArray()
    var arrShiftList = NSMutableArray()
    var arrDepartment = NSArray()
    var arrSystem = NSArray()
    var arrConstruction = NSArray()
    var arrReport = NSArray()
    var totalDeptCount: Int = -1
    var totalShiftCount: Int = -1
    var totalSystemCount: Int = -1
    var currentDeptIndex: Int = -1
    var currentShiftIndex: Int = -1
    var startTime: String = ""
    var endTime: String = ""
    var shiftName: String = ""
    var drawIndex: Int = 0
    var yCoordList : CGFloat = 0
    var yCoord : CGFloat = 0
    var height : CGFloat = 0
    var strReportHeader = ""
    var pcommentTag = -1
    var arrPeriodicComments = NSMutableArray()
    var testCount: Int = 0;
    var arrSelectedComment = NSMutableArray()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        periodicReport_initialSetup()
        if Common.reachabilityChanged() == true {
            Common.startPinwheelProcessing()
            self.getShiftDataAPIPeriodic()
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
    func periodicReport_initialSetup() {
        commentDetailView.isHidden = true
        dateFromTextfield.delegate = self
        dateToTextfield.delegate = self
        dateFromTextfield.underlined()
        dateToTextfield.underlined()
        periodicDatePickerView.isHidden = true
        periodicDatePicker.maximumDate = Date()
        self.dateSubmitButton.isUserInteractionEnabled = false
        self.dateSubmitButton.alpha = 0.6
        if strReportHeader == "PERIODIC" {
            reportHeaderLabel.text = "MACHINE PERFORMANCE PERIODICAL REPORT"
        } else {
            reportHeaderLabel.text = "MACHINE PERFORMANCE STOPPAGE REPORT"
        }
    }
    
    func set_periodicDatePicker_widget() {
        self.view.bringSubview(toFront: periodicDatePickerView)
        reportScrollView.isUserInteractionEnabled = false
        self.view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.periodicDatePickerView.frame = CGRect(x: self.periodicDatePickerView.frame.origin.x, y: self.view.frame.height - self.periodicDatePickerView.frame.size.height, width: self.periodicDatePickerView.frame.size.width, height: self.periodicDatePickerView.frame.size.height)
        }, completion: { finished in
            print("view visible")
            self.periodicDatePickerView.isHidden = false
        })
    }
    
    func reset_periodicDatePicker_widget() {
        dateFromTextfield.underlined()
        dateToTextfield.underlined()
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.periodicDatePickerView.frame = CGRect(x: self.periodicDatePickerView.frame.origin.x, y: 1500, width: self.periodicDatePickerView.frame.size.width, height: self.periodicDatePickerView.frame.size.height)
            self.reportScrollView.contentOffset = CGPoint.zero
        }, completion: { finished in
            print("view visible")
            self.periodicDatePickerView.isUserInteractionEnabled = true
            self.strSelectedPicker = ""
        })
    }
    
    func checkReportParsingCompletedPeroidic() -> Void {
        print(self.totalShiftCount)
        print(self.currentShiftIndex)
        print(self.totalDeptCount)
        print(self.currentDeptIndex)
        if self.totalShiftCount-1 != self.currentShiftIndex {
            self.currentShiftIndex = self.currentShiftIndex + 1
            self.aggregateApiDailyReportPeroidic()
        } else {
            if self.totalDeptCount-1 != self.currentDeptIndex {
                self.currentDeptIndex = self.currentDeptIndex + 1
                self.currentShiftIndex = 0;
                self.aggregateApiDailyReportPeroidic()
            } else {
                Common.stopPinwheelProcessing()
            }
        }
    }
    
    //MARK: - IBAction
    @IBAction func periodical_Report_widget_action(_ sender: UIButton) {
        print("btnTag==\(sender.tag)")
        switch sender.tag {
        case 0: // back
            let _ = self.navigationController?.popViewController(animated: true)
        case 1: // Date from
            dateFromTextfield.underlinedBlue()
            dateToTextfield.underlined()
            strSelectedPicker = "FROM"
            dateFromTextfield.text = ""
            set_periodicDatePicker_widget()
            self.dateSubmitButton.isUserInteractionEnabled = false
            self.dateSubmitButton.alpha = 0.6
            break
        case 2: // date to
            dateToTextfield.underlinedBlue()
            dateFromTextfield.underlined()
            strSelectedPicker = "TO"
            dateToTextfield.text = ""
            set_periodicDatePicker_widget()
            self.dateSubmitButton.isUserInteractionEnabled = false
            self.dateSubmitButton.alpha = 0.6
            break
        case 3: // done
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DATEFORMAT
            let strDate = dateFormatter.string(from: periodicDatePicker.date)
            print("current date == \(strDate)")
            reset_periodicDatePicker_widget()
            if strSelectedPicker == "FROM" {
                if dateToTextfield.text != "" && strDate > dateToTextfield.text!{
                    Common.showCustomAlert(message: NOTIFICATIONVALIDATION)
                    return
                }
                dateFromTextfield.text = strDate
            } else {
                if dateFromTextfield.text == "" {
                    Common.showCustomAlert(message: DATEFROMERROR)
                    return
                } else if strDate < dateFromTextfield.text! {
                    Common.showCustomAlert(message: NOTIFICATIONVALIDATION)
                    return
                }
                dateToTextfield.text = strDate
            }
            if dateFromTextfield.text != "" && dateToTextfield.text != "" {
                self.dateSubmitButton.isUserInteractionEnabled = true
                self.dateSubmitButton.alpha = 1.0
            }
            break
        case 4: // cancel
            reset_periodicDatePicker_widget()
            break
        case 5: // Date Submit button
            let subViews = self.reportScrollView.subviews
            for subView in subViews {
                subView.removeFromSuperview()
            }
            drawIndex = 0
            yCoordList = 0
            yCoord = 0
            height = 0
            pcommentTag = -1
            arrPeriodicComments = NSMutableArray()
            if Common.reachabilityChanged() == true {
                Common.startPinwheelProcessing()
                self.parseDailyReportsPeroidic()
            } else {
                Common.showCustomAlert(message: NWCONNECTION)
            }
            break
        case 6: // Comments
            commentDetailView.isHidden = true
            break
        default:
            print("default")
        }
    }
    
    //MARK: - Shift API Implementation
    func getShiftDataAPIPeriodic() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        print(oID)
        let methodName = "\(PREFERENCE_METHOD_NAME)"+QUERYMARK+GET_PARAM_ORGANIZATIONID+QUERYSYMBOL+oID+QUERYJOIN+GET_TYPE+QUERYSYMBOL+GET_PARAM_SHIFT
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
                        //Checking
                        self.arrShiftList = NSMutableArray()
                        for index in 0 ..< self.arrShiftData.count {
                            self.arrShiftList.add(Common.parseShiftDataTiming(arrShift: self.arrShiftData, index: index))
                        }
                        print(self.arrShiftList)
                        print(self.arrShiftList[0])
                        self.getDepartmentListAPIReportPeriodic()
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
    
    func getDepartmentListAPIReportPeriodic() -> Void {
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
                        self.getSystemListAPIForReportPeroidic()
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
    
    func getSystemListAPIForReportPeroidic() -> Void {
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
                        self.getConstructionBasicReportPeroidic()
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
    
    func getConstructionBasicReportPeroidic() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        print(oID)
        let methodName = "\(PREFERENCE_METHOD_NAME)"+QUERYMARK+GET_PARAM_ORGANIZATIONID+QUERYSYMBOL+oID+QUERYJOIN+GET_TYPE+QUERYSYMBOL+CONSTRUCTION
        print(methodName)
        ServiceConnector.serviceConnectorGET(methodName) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResponseConstruction = NSDictionary()
                dictResponseConstruction = responseObject! as NSDictionary
                if (code == CODE200) {
                    self.arrConstruction = dictResponseConstruction.value(forKey: RESULTS) as! NSArray
                    print(self.arrConstruction)
                    if self.arrConstruction.count > 0 {
                    } else {
                    }
                    Common.stopPinwheelProcessing()
                } else if (code == CODE204) {
                    Common.stopPinwheelProcessing()
                } else {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: dictResponseConstruction))
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
            }
        }
    }
    
    func parseDailyReportsPeroidic() -> Void {
        print(self.arrDepartment.count)
        print(self.arrShiftData.count)
        print(self.arrSystem.count)
        totalDeptCount = self.arrDepartment.count
        totalShiftCount = self.arrShiftData.count
        totalSystemCount = self.arrSystem.count
        if totalShiftCount > 0 && totalSystemCount > 0 {
            currentDeptIndex = 0;
            currentShiftIndex = 0;
            self.getDailyReportAPIPeroidic()
        } else {
            Common.stopPinwheelProcessing()
        }
    }
    
    func aggregateApiDailyReportPeroidic() -> Void {
        print(currentShiftIndex)
        var arrParseShift = (self.arrShiftData[currentShiftIndex] as AnyObject).object(forKey: "preferenceItem") as! NSArray
        if arrParseShift.count > 0 {
            print((arrParseShift[0] as AnyObject).object(forKey: "name") as! String)
            self.shiftName = (arrParseShift[0] as AnyObject).object(forKey: "name") as! String
            arrParseShift = (arrParseShift[0] as AnyObject).object(forKey: "keyValues") as! NSArray
            print(arrParseShift.count)
            if arrParseShift.count >= 2 {
                if (arrParseShift[0] as AnyObject).object(forKey: "key") as! String == "TIME_FROM" {
                    let arrData = (arrParseShift[0] as AnyObject).object(forKey: "values") as! NSArray
                    startTime = arrData[0] as! String
                }
                if (arrParseShift[1] as AnyObject).object(forKey: "key") as! String == "TIME_TO" {
                    let arrData = (arrParseShift[1] as AnyObject).object(forKey: "values") as! NSArray
                    endTime = arrData[0] as! String
                }
                print(startTime)
                print(endTime)
                let deptNameStr = (arrDepartment[currentDeptIndex] as AnyObject).object(forKey: "name") as! String
                print(deptNameStr)
                let deptIDStr = (arrDepartment[currentDeptIndex] as AnyObject).object(forKey: "id") as! String
                print(deptIDStr)
                return
            }
        }
        Common.stopPinwheelProcessing()
    }
    
    func getDailyReportAPIPeroidic() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        let dictReports = NSMutableDictionary()
        dictReports.setValue(oID, forKey: RORGANIZATIONID)
        dictReports.setValue("", forKey: DEPARTMENTID)
        dictReports.setValue("", forKey: SYSTEMID)
        dictReports.setValue("", forKey: CONTROLLERID)
        dictReports.setValue(GET_AGGREGATE, forKey: GET_CURRENT_TYPE)
        if strReportHeader == "PERIODIC" {
            dictReports.setValue("", forKey: GET_PARAM_SUBTYPE)
        } else {
            dictReports.setValue(COMMENTS, forKey: GET_PARAM_SUBTYPE)
        }
        
        dictReports.setValue(self.dateFromTextfield.text!, forKey: GET_PARAM_ST_DATE)
        dictReports.setValue(self.dateToTextfield.text!, forKey: GET_PARAM_END_DATE)
        let arrShiftTimePayLoad = NSMutableArray()
        for index in 0 ..< self.arrShiftList.count {
            print((self.arrShiftList[index] as AnyObject).object(forKey: "startTime") as! String)
            print((self.arrShiftList[index] as AnyObject).object(forKey: "startTime") as! String)
            var pshiftStartTime = (self.arrShiftList[index] as AnyObject).object(forKey: "startTime") as! String
            var pshiftEndTime = (self.arrShiftList[index] as AnyObject).object(forKey: "endTime") as! String
            let strResult = Common.convertStringToDateTime_compare(startTime: "\(self.dateToTextfield.text!) \(pshiftStartTime)", endTIme: "\(self.dateToTextfield.text!) \(pshiftEndTime)")
            print(strResult)
            pshiftStartTime = "\(self.dateFromTextfield.text!) \(pshiftStartTime)"
            print(pshiftStartTime)
            if strResult == "CURRENTDATE" {
                print("current date")
                pshiftEndTime = "\(self.dateToTextfield.text!) \(pshiftEndTime)"
                print(pshiftEndTime)
            } else {
                print("next date")
                pshiftEndTime = "\(Common.getNextDate(dateString: self.dateToTextfield.text!)) \(pshiftEndTime)"
                print(pshiftEndTime)
            }
            arrShiftTimePayLoad.add(Common.payloadShiftForming(stTime: pshiftStartTime, endTime: pshiftEndTime, prefID: (self.arrShiftList[index] as AnyObject).object(forKey: "id") as! String))
        }
        dictReports.setValue(arrShiftTimePayLoad, forKey: "duration")
        print(dictReports)
        let parameters: NSDictionary = ServiceConnector.setReportParameter(dictReport: dictReports)
        print("Dict JSON Formation Daily Reports\(parameters)")
   
        ServiceConnector.serviceConnectorPOST(DAILYREPORT_METHOD_NAME, inputParam: parameters as! NSMutableDictionary) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResponseDailyReport = NSDictionary()
                dictResponseDailyReport = responseObject! as NSDictionary
                if (code == CODE201) {
                    self.arrReport = NSArray()
                    self.arrReport = dictResponseDailyReport.value(forKey: RESULTS) as! NSArray
                    print(self.arrReport.count)
                    print(self.arrReport)
                    if self.arrReport.count > 0 {
                        self.renderingDailyReportPeroidic()
                    } else {
                        Common.stopPinwheelProcessing()
                        Common.showCustomAlert(message: NORECORDSFOUND)
                    }
                } else if (code == CODE204) {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: NORECORDSFOUND)
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
    
    func renderingDailyReportPeroidic() -> Void {
        reportScrollView.delegate = self
        reportScrollView.isUserInteractionEnabled = true
        reportScrollView.scrollsToTop = false
        reportScrollView.frame.origin.y = reportDateHeaderView.frame.origin.y + reportDateHeaderView.frame.size.height
        
        for dindex in 0..<self.arrDepartment.count {
            print((self.arrDepartment[dindex] as AnyObject).object(forKey: "id") as! String)
            print((self.arrDepartment[dindex] as AnyObject).object(forKey: "name") as! String)
            let dIndexDeptID = (self.arrDepartment[dindex] as AnyObject).object(forKey: "id") as! String
            let dIndexDeptName = (self.arrDepartment[dindex] as AnyObject).object(forKey: "name") as! String
            for sindex in 0..<self.arrShiftList.count {
                let shiftDict = self.arrShiftList[sindex] as! NSMutableDictionary
                print(shiftDict.value(forKey: "id") as! String)
                let sIndexShiftID = shiftDict.value(forKey: "id") as! String
                let sIndexShiftName = shiftDict.value(forKey: "shiftName") as! String
                var containerFlag = ""
                var totalAvg = 0.0 // not need
                for yIndex in 0..<self.arrReport.count {
                    print("Selected Dept ID \(dIndexDeptID)")
                    print("Current Dept ID \((self.arrReport[yIndex] as AnyObject).object(forKey: "departmentId") as! String)")
                    print("Selected Shift ID \(sIndexShiftID)")
                    print("Current Shift Pref ID \((self.arrReport[yIndex] as AnyObject).object(forKey: "preferenceId") as! String)")
                    if dIndexDeptID == (self.arrReport[yIndex] as AnyObject).object(forKey: "departmentId") as! String && sIndexShiftID == (self.arrReport[yIndex] as AnyObject).object(forKey: "preferenceId") as! String {
                        print("MATCH")
                        if containerFlag == "" {
                            // Header Start
                            preportContainerView[dindex] = UIView()
                            preportContainerView[dindex].autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
                            preportContainerView[dindex].backgroundColor = UIColor.clear
                            
                            let headerView = UIView()
                            headerView.backgroundColor = UIColor.clear
                            headerView.autoresizingMask = .flexibleWidth
                            headerView.backgroundColor = UIColor.init(hexString: "FAFAFA")
                            
                            pdeptNameLabel[dindex] = UILabel()
                            pdeptNameLabel[dindex].frame = CGRect.init(x: 16, y: 10, width: 100, height: 21)
                            pdeptNameLabel[dindex].textColor = UIColor.init(hexString: "848484")
                            pdeptNameLabel[dindex].font = UIFont.init(name: "ProximaNova-Semibold", size: 17.0)
                            pdeptNameLabel[dindex].text = dIndexDeptName
                            pdeptNameLabel[dindex].textAlignment = .left
                            pdeptNameLabel[dindex].sizeToFit()
                            headerView.addSubview(pdeptNameLabel[dindex])
                            
                            let bar = UIView()
                            bar.frame = CGRect.init(x: pdeptNameLabel[dindex].frame.origin.x + pdeptNameLabel[dindex].frame.size.width + 5, y: pdeptNameLabel[dindex].frame.origin.y, width: 2, height: pdeptNameLabel[dindex].frame.size.height)
                            bar.backgroundColor = UIColor.init(hexString: "848484")
                            headerView.addSubview(bar)
                            
                            pshiftLabel[dindex] = UILabel()
                            pshiftLabel[dindex].frame = CGRect.init(x: bar.frame.origin.x + bar.frame.size.width + 5, y: pdeptNameLabel[dindex].frame.origin.y, width: 100, height: 21)
                            pshiftLabel[dindex].textColor = UIColor.init(hexString: "848484")
                            pshiftLabel[dindex].font = UIFont.init(name: "ProximaNova-Regular", size: 15.0)
                            pshiftLabel[dindex].text = sIndexShiftName
                            pshiftLabel[dindex].textAlignment = .left
                            headerView.addSubview(pshiftLabel[dindex])
                            
                            headerView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: pshiftLabel[dindex].frame.origin.y+pshiftLabel[dindex].frame.size.height + 10)
                            
                            preportContainerView[dindex].addSubview(headerView)
                            
                            yCoordList = headerView.frame.origin.y + headerView.frame.size.height
                            
                            containerFlag = "YES"
                        } // Header End
                        // Body Section Start
                        let currentCID = (self.arrReport[yIndex] as AnyObject).object(forKey: "controllerId") as! String
                        print(currentCID)
                        let systemID = (self.arrReport[yIndex] as AnyObject).object(forKey: "systemId") as! String
                        print(systemID)
                        var machName = ""
                        var macAvg = ""
                        let cfmAvg = (self.arrReport[yIndex] as AnyObject).object(forKey: "keyValues") as! NSArray
                        print(cfmAvg)
                        
                        let dict = NSMutableDictionary()
                        dict.setValue((self.arrReport[yIndex] as AnyObject).object(forKey: "controllerId") as! String, forKey: CONTROLLERID)
                        dict.setValue((self.arrReport[yIndex] as AnyObject).object(forKey: "departmentId") as! String, forKey: DEPARTMENTID)
                        dict.setValue((self.arrReport[yIndex] as AnyObject).object(forKey: "id") as! String, forKey: RID)
                        var arrTempComments: NSArray = []
                        arrTempComments = (self.arrReport[yIndex] as AnyObject).object(forKey: "comments") as! NSArray
                        dict.setValue(arrTempComments, forKey: "COMMENTS")
                        arrPeriodicComments.add(dict)
                        print("arr coments == \(arrPeriodicComments)")
                        
                        if cfmAvg.count > 0 {
                            for index in 0..<cfmAvg.count {
                                if (cfmAvg[index] as AnyObject).value(forKey: "key") as! String == "TOTAL_CFM_AVG" {
                                    let cfmKeyValue = (cfmAvg[index] as AnyObject).value(forKey: "values") as! NSArray
                                    macAvg = cfmKeyValue[0] as! String
                                }
                            }
                            print(macAvg)
                            let cfmFloat: Float = Float(macAvg)!
                            print(cfmFloat)
                            macAvg = String(format: "%.2f", cfmFloat)
                            print(macAvg)
                        }
                        for zindex in 0..<self.arrSystem.count {
                            print((self.arrSystem[zindex] as AnyObject).object(forKey: "id") as! String)
                            if (self.arrSystem[zindex] as AnyObject).object(forKey: "id") as! String == systemID {
                                print((self.arrSystem[zindex] as AnyObject).object(forKey: "name") as! String)
                                machName = (self.arrSystem[zindex] as AnyObject).object(forKey: "name") as! String
                                break
                            }
                        }
                        preportListView[yIndex] = UIView()
                        preportListView[yIndex].frame = CGRect.init(x: 0, y: yCoordList, width: self.reportScrollView.frame.width, height: 0)
                        preportListView[yIndex].autoresizingMask = .flexibleWidth
                        preportListView[yIndex].backgroundColor = UIColor.clear
                        
                        pmachineNameLabel[yIndex] = UILabel()
                        pmachineNameLabel[yIndex].frame = CGRect.init(x: 16, y: 8, width: 125, height: 21)
                        pmachineNameLabel[yIndex].textColor = UIColor.init(hexString: "545454")
                        pmachineNameLabel[yIndex].font = UIFont.init(name: "ProximaNova-Light", size: 16.0)
                        pmachineNameLabel[yIndex].textAlignment = .left
                        pmachineNameLabel[yIndex].numberOfLines = 2
                        pmachineNameLabel[yIndex].text = machName
                        preportListView[yIndex].addSubview(pmachineNameLabel[yIndex])
                        
                        print(Common.convertDateFormater((self.arrReport[yIndex] as AnyObject).object(forKey: "startTime") as! String))
                        periodicTimetLabel[yIndex] = UILabel()
                        periodicTimetLabel[yIndex].frame = CGRect.init(x: 16, y: pmachineNameLabel[yIndex].frame.origin.y + pmachineNameLabel[yIndex].frame.size.height + 6, width: 75, height: 21)
                        periodicTimetLabel[yIndex].textColor = UIColor.init(hexString: "545454")
                        periodicTimetLabel[yIndex].font = UIFont.init(name: "ProximaNova-Light", size: 16.0)
                        periodicTimetLabel[yIndex].textAlignment = .left
                        periodicTimetLabel[yIndex].numberOfLines = 1
                        periodicTimetLabel[yIndex].text = Common.convertDateFormater((self.arrReport[yIndex] as AnyObject).object(forKey: "startTime") as! String)
                        preportListView[yIndex].addSubview(periodicTimetLabel[yIndex])
                        
                        pcfmLabel[yIndex] = UILabel()
                        if Common.deviceType() == "iPhone5" {
                            pcfmLabel[yIndex].frame = CGRect.init(x: Int(pmachineNameLabel[yIndex].frame.origin.x + pmachineNameLabel[yIndex].frame.size.width), y: Int(8), width: 60, height: 21)
                        } else if Common.deviceType() == "iPhone6plus" {
                            pcfmLabel[yIndex].frame = CGRect.init(x: Int(pmachineNameLabel[yIndex].frame.origin.x + pmachineNameLabel[yIndex].frame.size.width + 10), y: Int(8), width: 60, height: 21)
                        } else if Common.deviceType() == "iPhone6" || Common.deviceType() == "iPhoneX" {
                            pcfmLabel[yIndex].frame = CGRect.init(x: Int(pmachineNameLabel[yIndex].frame.origin.x + pmachineNameLabel[yIndex].frame.size.width + 10), y: Int(8), width: 60, height: 21)
                        }
                        pcfmLabel[yIndex].textColor = UIColor.init(hexString: "545454")
                        pcfmLabel[yIndex].font = UIFont.init(name: "ProximaNova-Regular", size: 16.0)
                        pcfmLabel[yIndex].textAlignment = .left
                        pcfmLabel[yIndex].text = macAvg
                        preportListView[yIndex].addSubview(pcfmLabel[yIndex])
                        
                        plblConstTypeValue[yIndex] = UILabel()
                        let nWidth = Int(preportListView[yIndex].frame.size.width - 5) - Int(pcfmLabel[yIndex].frame.origin.x + pcfmLabel[yIndex].frame.size.width + 10)
                        if Common.deviceType() == "iPhone5" {
                            plblConstTypeValue[yIndex].frame = CGRect.init(x: Int(pcfmLabel[yIndex].frame.origin.x + pcfmLabel[yIndex].frame.size.width + 10), y: Int(8), width: nWidth, height: 21)
                        } else if Common.deviceType() == "iPhone6plus" {
                            plblConstTypeValue[yIndex].frame = CGRect.init(x: Int(pcfmLabel[yIndex].frame.origin.x + pcfmLabel[yIndex].frame.size.width + 20), y: Int(8), width: nWidth, height: 21)
                        } else if Common.deviceType() == "iPhone6" || Common.deviceType() == "iPhoneX" {
                            plblConstTypeValue[yIndex].frame = CGRect.init(x: Int(pcfmLabel[yIndex].frame.origin.x + pcfmLabel[yIndex].frame.size.width + 20), y: Int(8), width: nWidth, height: 21)
                        }
                        plblConstTypeValue[yIndex].textColor = UIColor.init(hexString: "545454")
                        plblConstTypeValue[yIndex].font = UIFont.init(name: "ProximaNova-Regular", size: 16.0)
                        plblConstTypeValue[yIndex].textAlignment = .left
                        preportListView[yIndex].addSubview(plblConstTypeValue[yIndex])
                        
                        var weftStr = ""
                        var warpStr = ""
                        var constructionName = ""
                        for kindex in 0..<self.arrConstruction.count {
                            print(systemID)
                            print((self.arrConstruction[kindex] as AnyObject).object(forKey: "systemId") as! String)
                            
                            if (self.arrConstruction[kindex] as AnyObject).object(forKey: "systemId") as! String == systemID {
                                var arrConsDetails = (self.arrConstruction[kindex] as AnyObject).object(forKey: "preferenceItem") as! NSArray
                                if arrConsDetails.count > 0 {
                                    print((arrConsDetails[0] as AnyObject).object(forKey: "name") as! String)
                                    constructionName = (arrConsDetails[0] as AnyObject).object(forKey: "name") as! String
                                    arrConsDetails = (arrConsDetails[0] as AnyObject).object(forKey: "keyValues") as! NSArray
                                    
                                    if arrConsDetails.count > 0 && arrConsDetails.count == 5 {
                                        print(arrConsDetails.count)
                                        if (arrConsDetails[0] as AnyObject).object(forKey: KEY) as! String == "WEFT"{
                                            let arrValues = (arrConsDetails[0] as AnyObject).object(forKey: "values") as! NSArray
                                            weftStr = arrValues[0] as! String
                                        }
                                        if (arrConsDetails[1] as AnyObject).object(forKey: KEY) as! String == "WARP"{
                                            let arrValues = (arrConsDetails[1] as AnyObject).object(forKey: "values") as! NSArray
                                            warpStr = arrValues[0] as! String
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                        
                        plblConstTypeValue[yIndex].text = constructionName
                        plblWeftValue[yIndex] = UILabel()
                        plblWeftValue[yIndex].frame = CGRect.init(x: Int(plblConstTypeValue[yIndex].frame.origin.x), y: Int(plblConstTypeValue[yIndex].frame.origin.y + plblConstTypeValue[yIndex].frame.size.height + 6), width: 48, height: 21)
                        plblWeftValue[yIndex].textColor = UIColor.init(hexString: "4576B9")
                        plblWeftValue[yIndex].font = UIFont.init(name: "ProximaNova-Regular", size: 16.0)
                        plblWeftValue[yIndex].textAlignment = .left
                        plblWeftValue[yIndex].text = weftStr
                        preportListView[yIndex].addSubview(plblWeftValue[yIndex])
                        
                        plblWrapValue[yIndex] = UILabel()
                        if Common.deviceType() == "iPhone6plus" {
                            plblWrapValue[yIndex].frame = CGRect.init(x: Int(plblWeftValue[yIndex].frame.origin.x + plblWeftValue[yIndex].frame.size.width) + 20, y: Int(plblConstTypeValue[yIndex].frame.origin.y + plblConstTypeValue[yIndex].frame.size.height + 6), width: 48, height: 21)
                        } else if Common.deviceType() == "iPhone5" {
                            plblWrapValue[yIndex].frame = CGRect.init(x: Int(plblWeftValue[yIndex].frame.origin.x + plblWeftValue[yIndex].frame.size.width) - 5, y: Int(plblConstTypeValue[yIndex].frame.origin.y + plblConstTypeValue[yIndex].frame.size.height + 6), width: 48, height: 21)
                        } else {
                            plblWrapValue[yIndex].frame = CGRect.init(x: Int(plblWeftValue[yIndex].frame.origin.x + plblWeftValue[yIndex].frame.size.width) , y: Int(plblConstTypeValue[yIndex].frame.origin.y + plblConstTypeValue[yIndex].frame.size.height + 6), width: 48, height: 21)
                        }
                        plblWrapValue[yIndex].textColor = UIColor.init(hexString: "E58F26")
                        plblWrapValue[yIndex].font = UIFont.init(name: "ProximaNova-Regular", size: 16.0)
                        plblWrapValue[yIndex].textAlignment = .left
                        plblWrapValue[yIndex].text = warpStr
                        preportListView[yIndex].addSubview(plblWrapValue[yIndex])
                        
                        ppreviewButton[yIndex] = UIButton(type: .custom)
                        if Common.deviceType() == "iPhone5" {
                            ppreviewButton[yIndex].frame = CGRect(x: CGFloat(plblWrapValue[yIndex].frame.origin.x + plblWrapValue[yIndex].frame.size.width - 12), y: CGFloat(plblWrapValue[yIndex].frame.origin.y-10), width: CGFloat(44), height: CGFloat(40))
                        } else if Common.deviceType() == "iPhone6plus"  || Common.deviceType() == "iPhoneX" {
                            ppreviewButton[yIndex].frame = CGRect(x: CGFloat(plblWrapValue[yIndex].frame.origin.x + plblWrapValue[yIndex].frame.size.width + 10), y: CGFloat(plblWrapValue[yIndex].frame.origin.y - 10), width: CGFloat(44), height: CGFloat(40))
                        } else if Common.deviceType() == "iPhone6" {
                            ppreviewButton[yIndex].frame = CGRect(x: CGFloat(plblWrapValue[yIndex].frame.origin.x + plblWrapValue[yIndex].frame.size.width + 5), y: CGFloat(plblWrapValue[yIndex].frame.origin.y - 10), width: CGFloat(44), height: CGFloat(40))
                        }
                        pcommentTag = pcommentTag + 1
                        ppreviewButton[yIndex].tag = pcommentTag //yIndex
                        if arrTempComments.count > 0 {
                            ppreviewButton[yIndex].setImage(UIImage.init(named: "shiftwisePreviewSelected"), for: .normal)
                            ppreviewButton[yIndex].isUserInteractionEnabled = true
                        } else {
                            ppreviewButton[yIndex].setImage(UIImage.init(named: "shiftWisePreview"), for: .normal)
                            ppreviewButton[yIndex].isUserInteractionEnabled = false
                        }
                        ppreviewButton[yIndex].addTarget(self, action: #selector(PeriodicalViewController.periodic_report_previewAction), for: .touchUpInside)
                        preportListView[yIndex].addSubview(ppreviewButton[yIndex])
                        
                        let viewDivider4 = UIView()
                        viewDivider4.frame = CGRect.init(x: 0, y: plblWrapValue[yIndex].frame.origin.y+plblWrapValue[yIndex].frame.size.height + 8, width: self.reportScrollView.frame.size.width, height: 1)
                        viewDivider4.backgroundColor = UIColor.init(hexString: "DFE6EE")
                        preportListView[yIndex].addSubview(viewDivider4)
                        
                        preportListView[yIndex].frame = CGRect.init(x: 0, y: yCoordList, width: self.reportScrollView.frame.width, height: viewDivider4.frame.origin.y + viewDivider4.frame.size.height)
                        preportContainerView[dindex].addSubview(preportListView[yIndex])
                        
                        yCoordList = preportListView[yIndex].frame.origin.y + preportListView[yIndex].frame.size.height
                        height = yCoordList
                    } // Body Section End
                }
                // Footer Start
                if containerFlag == "YES" {
                    preportContainerView[dindex].frame = CGRect.init(x: 0, y: yCoord, width: self.reportScrollView.frame.size.width, height: height)
                    
                    yCoord = preportContainerView[dindex].frame.origin.y + preportContainerView[dindex].frame.size.height
                    
                    reportScrollView.addSubview(preportContainerView[dindex])
                    reportScrollView.contentSize = CGSize.init(width: reportScrollView.contentSize.width, height: preportContainerView[dindex].frame.origin.y+preportContainerView[dindex].frame.size.height+50)
                }//Footer End
            }
        }
        Common.stopPinwheelProcessing()
    }
    
    @objc func periodic_report_previewAction(sender: UIButton) {
        print("sender tag \(sender.tag)")
        print(arrPeriodicComments[sender.tag])
        arrSelectedComment = NSMutableArray()
        let dictComment = arrPeriodicComments[sender.tag] as! NSDictionary
        print(dictComment)
        let arrCom = dictComment.value(forKey: "COMMENTS") as! NSArray
        for index in 0 ..< arrCom.count {
            let dict: NSDictionary = arrCom[index] as! NSDictionary
            print(dict.value(forKey: "startDateTime") as! String)
            print(dict.value(forKey: "endDateTime") as! String)
            var arrCommentKey = NSArray()
            arrCommentKey = dict.value(forKey: RKEYVALUES) as! NSArray
            print("arr values \(arrCommentKey)")
            print("arr count \(arrCommentKey.count)")
            var dictCommentKeyValues = NSMutableDictionary()
            dictCommentKeyValues = Common.parseTypeCollection(strTypeCollection: MACHINETYPECOLLECTION, arrKeyValues: arrCommentKey)
            dictCommentKeyValues.setValue("\(Common.parseDateAndTimeReports(curDate: Common.UTCToLocal_DateTime(date: dict.value(forKey: "startDateTime") as! String))) - \(Common.parseDateAndTimeReports(curDate: Common.UTCToLocal_DateTime(date: dict.value(forKey: "endDateTime") as! String)))" , forKey: "CommentTime")
            print(dictCommentKeyValues)
            arrSelectedComment.add(dictCommentKeyValues)
        }
        print(arrSelectedComment)
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.tableFooterView = UIView()
        commentTableView.reloadData()
        commentDetailView.isHidden = false
    }
    
    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSelectedComment.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : reportTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reportTableViewCell")! as! reportTableViewCell
        cell.reportTimeLabel.text = (self.arrSelectedComment[indexPath.row] as AnyObject).object(forKey: "CommentTime") as? String
       
        cell.commentLabel.type = .continuous
        cell.commentLabel.animationCurve = .easeInOut
        cell.commentLabel.speed = .duration(10.0)
        cell.commentLabel.text = (self.arrSelectedComment[indexPath.row] as AnyObject).object(forKey: RCOMMENTS) as? String
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected Cell \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
