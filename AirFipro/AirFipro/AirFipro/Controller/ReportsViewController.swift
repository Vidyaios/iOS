//
//  ReportsViewController.swift
//  AirFipro
//
//  Created by iexm01 on 18/11/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit

class commentTableViewCell: UITableViewCell {
    @IBOutlet var commentTimeLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
}

class ReportsViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    //MARK: - Variable Declaration
    var reportContainerView = [UIView](repeating: UIView(), count: 1000)
    var deptNameLabel = [UILabel](repeating: UILabel(), count: 1000)
    var dateLabel = [UILabel](repeating: UILabel(), count: 1000)
    var shiftLabel = [UILabel](repeating: UILabel(), count: 1000)
    var shiftTimeLabel = [UILabel](repeating: UILabel(), count: 1000)
    
    var reportListView = [UIView](repeating: UIView(), count: 1000)
    var machineNameLabel = [UILabel](repeating: UILabel(), count: 1000)
    var cfmLabel = [UILabel](repeating: UILabel(), count: 1000)
    var lblConstTypeValue = [UILabel](repeating: UILabel(), count: 1000)
    var lblWeftValue = [UILabel](repeating: UILabel(), count: 1000)
    var lblWrapValue = [UILabel](repeating: UILabel(), count: 1000)
    var previewButton = [UIButton](repeating: UIButton(), count: 1000)
    var lblAverageValue = [UILabel](repeating: UILabel(), count: 1000)
    
    @IBOutlet var reportMenuButton: UIButton!
    @IBOutlet var reportScrollView: UIScrollView!
    @IBOutlet var dcommentTableView: UITableView!
    @IBOutlet var dcommentDetailView: UIView!
    @IBOutlet var reportDividerView: UIView!
    @IBOutlet var rdatePickerView: UIView!
    @IBOutlet var reportDatePicker: UIDatePicker!
    @IBOutlet var txtfldReportPicker: UITextField!
    @IBOutlet var reportDateButton: UIButton!
    @IBOutlet var reportPickerButton: UIButton!
    
    var arrReportList = NSMutableArray()
    var arrShiftList = NSMutableArray()
    var arrShiftData = NSArray()
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
    var yCoord : CGFloat = 0
    var height : CGFloat = 0
    var yCoordList : CGFloat = 0
    var drawIndex: Int = 0
    var swipeGesture = UISwipeGestureRecognizer()
    var commentTag = -1
    var arrComments = NSMutableArray()
    var arrSelectedComment = NSMutableArray()
    var strSelectedDate = ""
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reports_InitialSetup()
        if Common.reachabilityChanged() == true {
            Common.startPinwheelProcessing()
            self.getShiftDataAPI()
        } else {
            Common.showCustomAlert(message: NWCONNECTION)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - IBAction
    @IBAction func report_widget_action(_ sender: UIButton) {
        print("btnTag==\(sender.tag)")
        switch sender.tag {
        case 0: // back
            let _ = self.navigationController?.popViewController(animated: true)
            break
        case 1: // close
            dcommentDetailView.isHidden = true
            break
        case 2: // picker button
            self.reportDateButton.isUserInteractionEnabled = false
            self.reportDateButton.alpha = 0.6
            txtfldReportPicker.text = ""
            set_reportDatePicker_widget()
            break
        case 3: // OK
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DATEFORMAT
            let strDate = dateFormatter.string(from: reportDatePicker.date)
            print("current date == \(strDate)")
            txtfldReportPicker.text = strDate
            self.reportDateButton.isUserInteractionEnabled = true
            self.reportDateButton.alpha = 1.0
            reset_reportDatePicker_widget()
            break
        case 4: // Cancel
            reset_reportDatePicker_widget()
            break
        case 5: // submit
            let subViews = self.reportScrollView.subviews
            for subView in subViews {
                subView.removeFromSuperview()
            }
            yCoord = 0
            height = 0
            yCoordList = 0
            drawIndex = 0
            commentTag = -1
            arrComments = NSMutableArray()
            if Common.reachabilityChanged() == true {
                strSelectedDate = txtfldReportPicker.text!
                Common.startPinwheelProcessing()
                self.parseDailyReports()
            } else {
                Common.showCustomAlert(message: NWCONNECTION)
            }
            break
        default:
            print("deafult")
        }
    }
    
    //MARK: - User Defined Methods
    func reports_InitialSetup() {
        dcommentDetailView.isHidden = true
//        reportDatePicker.setValue(UIColor.init(red: 58.0/255.0, green: 76.0/255.0, blue: 102.0/255.0, alpha: 1), forKeyPath: TEXTCOLOR)
        reportDatePicker.maximumDate = Date()
        
        txtfldReportPicker.delegate = self
        txtfldReportPicker.clearButtonMode = .whileEditing
        txtfldReportPicker.underlined()
        self.reportDateButton.isUserInteractionEnabled = false
        self.reportDateButton.alpha = 0.6
        
        reportPickerButton.isUserInteractionEnabled = false
    }
    
    func set_reportDatePicker_widget() {
        self.view.bringSubview(toFront: rdatePickerView)
        txtfldReportPicker.underlinedBlue()
        reportScrollView.isUserInteractionEnabled = false
        self.view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.rdatePickerView.frame = CGRect(x: self.rdatePickerView.frame.origin.x, y: self.view.frame.height - self.rdatePickerView.frame.size.height, width: self.rdatePickerView.frame.size.width, height: self.rdatePickerView.frame.size.height)
        }, completion: { finished in
            print("view visible")
//            self.rdatePickerView.isHidden = false
        })
    }
    
    func reset_reportDatePicker_widget() {
        txtfldReportPicker.underlined()
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.rdatePickerView.frame = CGRect(x: self.rdatePickerView.frame.origin.x, y: 1500, width: self.rdatePickerView.frame.size.width, height: self.rdatePickerView.frame.size.height)
            self.reportScrollView.contentOffset = CGPoint.zero
        }, completion: { finished in
            print("view visible")
            self.reportScrollView.isUserInteractionEnabled = true
        })
    }
    
    func renderingDailyReport() -> Void {
        reportScrollView.delegate = self
        reportScrollView.isUserInteractionEnabled = true
        reportScrollView.scrollsToTop = false

        reportScrollView.frame.origin.y = reportDividerView.frame.origin.y + reportDividerView.frame.size.height
        
        if Common.deviceType() == "iPhone5" {
            self.reportScrollView.frame.size.height = self.reportScrollView.frame.size.height + 10
        } else if Common.deviceType() == "iPhoneX" {
            self.reportScrollView.frame.origin.y = self.reportScrollView.frame.origin.y + 20
        }
        print(self.arrDepartment.count)
        print(self.arrShiftList.count)
        print(self.arrReport.count)
        for dindex in 0..<self.arrDepartment.count {
           
            print((self.arrDepartment[dindex] as AnyObject).object(forKey: "id") as! String)
            print((self.arrDepartment[dindex] as AnyObject).object(forKey: "name") as! String)
            let dIndexDeptID = (self.arrDepartment[dindex] as AnyObject).object(forKey: "id") as! String
            let dIndexDeptName = (self.arrDepartment[dindex] as AnyObject).object(forKey: "name") as! String
            for sindex in 0..<self.arrShiftList.count {
                let shiftDict = self.arrShiftList[sindex] as! NSMutableDictionary
                print(shiftDict)
                print(shiftDict.value(forKey: "id") as! String)
                let sIndexShiftID = shiftDict.value(forKey: "id") as! String
                let sIndexShiftName = shiftDict.value(forKey: "shiftName") as! String
                let sIndexShiftStTime = Common.parseShiftTimeFormat(time: Common.UTCToLocal_Time(date: shiftDict.value(forKey: "startTime") as! String))
                let sIndexShiftEndTime = Common.parseShiftTimeFormat(time: Common.UTCToLocal_Time(date: shiftDict.value(forKey: "endTime") as! String))
                var containerFlag = ""
                var arrReportAvgCount = 0
                var totalAvg = 0.0
              
                
                for yIndex in 0..<self.arrReport.count {
                    print((arrReport[yIndex] as AnyObject))
                    print("start time \((self.arrReport[yIndex] as AnyObject).object(forKey: "startTime") as! String)")
                    print("end time \((self.arrReport[yIndex] as AnyObject).object(forKey: "endTime") as! String)")
                    print("Selected Dept ID \(dIndexDeptID)")
                    print("Current Dept ID \((self.arrReport[yIndex] as AnyObject).object(forKey: "departmentId") as! String)")
                    print("Selected Shift ID \(sIndexShiftID)")
                    print("Current Shift Pref ID \((self.arrReport[yIndex] as AnyObject).object(forKey: "preferenceId") as! String)")
                    if dIndexDeptID == (self.arrReport[yIndex] as AnyObject).object(forKey: "departmentId") as! String && sIndexShiftID == (self.arrReport[yIndex] as AnyObject).object(forKey: "preferenceId") as! String {
                 
                        print("MATCH")
                        arrReportAvgCount = arrReportAvgCount + 1
                        //Header Start
                        if containerFlag == "" {
                            
                            print("start time \((self.arrReport[yIndex] as AnyObject).object(forKey: "startTime") as! String)")
                            print("start time \(Common.UTCToLocal_DateTime(date: (self.arrReport[yIndex] as AnyObject).object(forKey: "startTime") as! String))")
                            let str = Common.UTCToLocal_DateTime(date: (self.arrReport[yIndex] as AnyObject).object(forKey: "startTime") as! String)
                            print("start time \(Common.parseTimestampDate(curDate: str))")
                            strSelectedDate = Common.parseTimestampDate(curDate: str)
                            
                            reportContainerView[dindex] = UIView()
                            reportContainerView[dindex].autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
                            reportContainerView[dindex].backgroundColor = UIColor.clear
                            
                            let headerView = UIView()
                            headerView.backgroundColor = UIColor.clear
                            headerView.autoresizingMask = .flexibleWidth
                            
                            deptNameLabel[dindex] = UILabel()
                            deptNameLabel[dindex].frame = CGRect.init(x: 16, y: 19, width: 344, height: 21)
                            deptNameLabel[dindex].textColor = UIColor.init(hexString: "848484")
                            deptNameLabel[dindex].font = UIFont.init(name: "ProximaNova-Semibold", size: 17.0)
                            deptNameLabel[dindex].text = dIndexDeptName
                            deptNameLabel[dindex].textAlignment = .left
                            deptNameLabel[dindex].autoresizingMask = .flexibleWidth
                            headerView.addSubview(deptNameLabel[dindex])
                            
                            dateLabel[dindex] = UILabel()
                            dateLabel[dindex].frame = CGRect.init(x: 16, y: deptNameLabel[dindex].frame.origin.y + deptNameLabel[dindex].frame.size.height + 4, width: 80, height: 21)
                            dateLabel[dindex].textColor = UIColor.init(hexString: "4576B9")
                            dateLabel[dindex].font = UIFont.init(name: "ProximaNova-Regular", size: 15.0)
//                            let strResult = Common.convertStringToDate_compare(startTime: Common.UTCToLocal_Time(date: shiftDict.value(forKey: "startTime") as! String), endTIme: Common.UTCToLocal_Time(date: shiftDict.value(forKey: "endTime") as! String))
                            let strResult = Common.convertStringToDateTime_compare(startTime: "\(strSelectedDate) \(shiftDict.value(forKey: "startTime") as! String)", endTIme: "\(strSelectedDate) \(shiftDict.value(forKey: "endTime") as! String)")
                            print(strResult)
                            
//                            print("\(strSelectedDate) \(shiftDict.value(forKey: "startTime") as! String)")
//                            let str = "\(strSelectedDate) \(shiftDict.value(forKey: "startTime") as! String)"
//                            print("\(Common.UTCToLocal_DateTime(date: str))")

                            
                            if strResult == "CURRENTDATE" {
                                print("current date")
                                dateLabel[dindex].text = strSelectedDate
                            } else {
                                print("next date")
//                                dateLabel[dindex].text = Common.getNextDate(dateString: strSelectedDate)
//                                strSelectedDate = dateLabel[dindex].text!
                                dateLabel[dindex].text = strSelectedDate
                                strSelectedDate = Common.getNextDate(dateString: strSelectedDate)
                            }
                            

                            
                            dateLabel[dindex].textAlignment = .left
                            dateLabel[dindex].autoresizingMask = .flexibleWidth
                            headerView.addSubview(dateLabel[dindex])
                            
                            let bar = UIView()
                            bar.frame = CGRect.init(x: dateLabel[dindex].frame.origin.x + dateLabel[dindex].frame.size.width + 5, y: dateLabel[dindex].frame.origin.y, width: 2, height: dateLabel[dindex].frame.size.height)
                            bar.backgroundColor = UIColor.init(hexString: "4576B9")
                            headerView.addSubview(bar)
                            
                            shiftLabel[dindex] = UILabel()
                            shiftLabel[dindex].frame = CGRect.init(x: bar.frame.origin.x + bar.frame.size.width + 5, y: dateLabel[dindex].frame.origin.y, width: 100, height: 21)
                            shiftLabel[dindex].textColor = UIColor.init(hexString: "4576B9")
                            shiftLabel[dindex].font = UIFont.init(name: "ProximaNova-Regular", size: 15.0)
                            shiftLabel[dindex].text = sIndexShiftName
                            shiftLabel[dindex].textAlignment = .center
                            headerView.addSubview(shiftLabel[dindex])
                            
                            let bar1 = UIView()
                            bar1.frame = CGRect.init(x: shiftLabel[dindex].frame.origin.x + shiftLabel[dindex].frame.size.width + 5, y: shiftLabel[dindex].frame.origin.y, width: 2, height: dateLabel[dindex].frame.size.height)
                            bar1.backgroundColor = UIColor.init(hexString: "4576B9")
                            headerView.addSubview(bar1)
                            
                            shiftTimeLabel[dindex] = UILabel()
                            shiftTimeLabel[dindex].frame = CGRect.init(x: bar1.frame.origin.x + bar1.frame.size.width + 10, y: shiftLabel[dindex].frame.origin.y, width: 50, height: 21)
                            shiftTimeLabel[dindex].textColor = UIColor.init(hexString: "4576B9")
                            shiftTimeLabel[dindex].font = UIFont.init(name: "ProximaNova-Regular", size: 15.0)
                            shiftTimeLabel[dindex].text = "\(sIndexShiftStTime) - \(sIndexShiftEndTime)"
                            shiftTimeLabel[dindex].textAlignment = .left
                            shiftTimeLabel[dindex].autoresizingMask = .flexibleWidth
                            headerView.addSubview(shiftTimeLabel[dindex])
                            
                            let viewDivider1 = UIView()
                            viewDivider1.frame = CGRect.init(x: 0, y: shiftLabel[dindex].frame.origin.y+shiftLabel[dindex].frame.size.height + 10, width: self.view.frame.size.width, height: 2)
                            viewDivider1.backgroundColor = UIColor.init(hexString: "DFE6EE")
                            headerView.addSubview(viewDivider1)
                            
                            let machineLabel = UILabel()
                            machineLabel.frame = CGRect.init(x: 16, y: viewDivider1.frame.origin.y+viewDivider1.frame.size.height + 5, width: 75, height: 35)
                            machineLabel.textColor = UIColor.init(hexString: "545454")
                            machineLabel.font = UIFont.init(name: "ProximaNova-Regular", size: 16.0)
                            machineLabel.textAlignment = .left
                            machineLabel.numberOfLines = 2
                            machineLabel.text = "Machine Name"
                            headerView.addSubview(machineLabel)
                            
                            let cfmHeaderLabel = UILabel()
                            if Common.deviceType() == "iPhone5" {
                                cfmHeaderLabel.frame = CGRect.init(x: machineLabel.frame.origin.x + machineLabel.frame.size.width + 30, y: machineLabel.frame.origin.y, width: 40, height: 21)
                            } else if Common.deviceType() == "iPhone6plus" {
                                cfmHeaderLabel.frame = CGRect.init(x: machineLabel.frame.origin.x + machineLabel.frame.size.width + 60, y: machineLabel.frame.origin.y, width: 40, height: 21)
                            } else if Common.deviceType() == "iPhone6" || Common.deviceType() == "iPhoneX" {
                                cfmHeaderLabel.frame = CGRect.init(x: machineLabel.frame.origin.x + machineLabel.frame.size.width + 40, y: machineLabel.frame.origin.y, width: 40, height: 21)
                            }
                            
                            cfmHeaderLabel.textColor = UIColor.init(hexString: "545454")
                            cfmHeaderLabel.font = UIFont.init(name: "ProximaNova-Regular", size: 16.0)
                            cfmHeaderLabel.textAlignment = .center
                            cfmHeaderLabel.text = "CFM"
                            headerView.addSubview(cfmHeaderLabel)
                            
                            let constTypeLabel = UILabel()
                            if Common.deviceType() == "iPhone5" {
                                constTypeLabel.frame = CGRect.init(x: cfmHeaderLabel.frame.origin.x + cfmHeaderLabel.frame.size.width + 30, y: machineLabel.frame.origin.y, width: 96, height: 21)
                            } else if Common.deviceType() == "iPhone6plus" {
                                constTypeLabel.frame = CGRect.init(x: cfmHeaderLabel.frame.origin.x + cfmHeaderLabel.frame.size.width + 60, y: machineLabel.frame.origin.y, width: 96, height: 21)
                            } else if Common.deviceType() == "iPhone6" || Common.deviceType() == "iPhoneX" {
                                constTypeLabel.frame = CGRect.init(x: cfmHeaderLabel.frame.origin.x + cfmHeaderLabel.frame.size.width + 40, y: machineLabel.frame.origin.y, width: 96, height: 21)
                            }
                            
                            constTypeLabel.textColor = UIColor.init(hexString: "545454")
                            constTypeLabel.font = UIFont.init(name: "ProximaNova-Regular", size: 16.0)
                            constTypeLabel.textAlignment = .left
                            constTypeLabel.text = "Const. Type"
                            headerView.addSubview(constTypeLabel)
                            
                            let viewDivider2 = UIView()
                            viewDivider2.frame = CGRect.init(x: constTypeLabel.frame.origin.x, y: constTypeLabel.frame.origin.y+constTypeLabel.frame.size.height + 2, width: constTypeLabel.frame.size.width, height: 2)
                            viewDivider2.backgroundColor = UIColor.init(hexString: "DFE6EE")
                            headerView.addSubview(viewDivider2)
                            
                            let weftLabel = UILabel()
                            weftLabel.frame = CGRect.init(x: constTypeLabel.frame.origin.x, y: viewDivider2.frame.origin.y + viewDivider2.frame.size.height + 2, width: 48, height: 21)
                            weftLabel.textColor = UIColor.init(hexString: "4576B9")
                            weftLabel.font = UIFont.init(name: "ProximaNova-Regular", size: 16.0)
                            weftLabel.textAlignment = .left
                            weftLabel.text = "WEFT"
                            headerView.addSubview(weftLabel)
                            
                            let warpLabel = UILabel()
                            warpLabel.frame = CGRect.init(x: weftLabel.frame.origin.x+weftLabel.frame.size.width, y: viewDivider2.frame.origin.y + viewDivider2.frame.size.height + 2, width: 48, height: 21)
                            warpLabel.textColor = UIColor.init(hexString: "E2912C")
                            warpLabel.font = UIFont.init(name: "ProximaNova-Regular", size: 16.0)
                            warpLabel.textAlignment = .right
                            warpLabel.text = "WARP"
                            headerView.addSubview(warpLabel)
                            
                            let viewDivider3 = UIView()
                            viewDivider3.frame = CGRect.init(x: 0, y: warpLabel.frame.origin.y+warpLabel.frame.size.height + 5, width: self.reportScrollView.frame.size.width, height: 2)
                            viewDivider3.backgroundColor = UIColor.init(hexString: "DFE6EE")
                            headerView.addSubview(viewDivider3)
                            
                            headerView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: viewDivider3.frame.origin.y + viewDivider3.frame.size.height)
                            reportContainerView[dindex].addSubview(headerView)
                            yCoordList = headerView.frame.origin.y + headerView.frame.size.height
                            print("yCoordList \(yCoordList)")
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
                        arrComments.add(dict)
                        print("arr coments == \(arrComments)")
                        
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
                            
                            totalAvg =  totalAvg + Double(macAvg)!
                            print(totalAvg)
                        }
                        
                        for zindex in 0..<self.arrSystem.count {
                            print((self.arrSystem[zindex] as AnyObject).object(forKey: "id") as! String)
                            if (self.arrSystem[zindex] as AnyObject).object(forKey: "id") as! String == systemID {
                                print((self.arrSystem[zindex] as AnyObject).object(forKey: "name") as! String)
                                machName = (self.arrSystem[zindex] as AnyObject).object(forKey: "name") as! String
                                break
                            }
                        }
                        
                        reportListView[yIndex] = UIView()
                        reportListView[yIndex].frame = CGRect.init(x: 0, y: yCoordList, width: self.reportScrollView.frame.width, height: 0)
                        reportListView[yIndex].autoresizingMask = .flexibleWidth
                        reportListView[yIndex].backgroundColor = UIColor.clear
                        
                        machineNameLabel[yIndex] = UILabel()
                        machineNameLabel[yIndex].frame = CGRect.init(x: 16, y: 8, width: 85, height: 42)
                        machineNameLabel[yIndex].textColor = UIColor.init(hexString: "545454")
                        machineNameLabel[yIndex].font = UIFont.init(name: "ProximaNova-Light", size: 16.0)
                        machineNameLabel[yIndex].textAlignment = .left
                        machineNameLabel[yIndex].numberOfLines = 3
                        machineNameLabel[yIndex].text = machName
                        reportListView[yIndex].addSubview(machineNameLabel[yIndex])
                        
                        cfmLabel[yIndex] = UILabel()
                        if Common.deviceType() == "iPhone5" {
                            cfmLabel[yIndex].frame = CGRect.init(x: Int(machineNameLabel[yIndex].frame.origin.x + machineNameLabel[yIndex].frame.size.width + 20), y: Int(8), width: 60, height: 21)
                        } else if Common.deviceType() == "iPhone6plus" {
                            cfmLabel[yIndex].frame = CGRect.init(x: Int(machineNameLabel[yIndex].frame.origin.x + machineNameLabel[yIndex].frame.size.width + 50), y: Int(8), width: 60, height: 21)
                        } else if Common.deviceType() == "iPhone6" || Common.deviceType() == "iPhoneX" {
                            cfmLabel[yIndex].frame = CGRect.init(x: Int(machineNameLabel[yIndex].frame.origin.x + machineNameLabel[yIndex].frame.size.width + 30), y: Int(8), width: 60, height: 21)
                        }
                        
                        cfmLabel[yIndex].textColor = UIColor.init(hexString: "545454")
                        cfmLabel[yIndex].font = UIFont.init(name: "ProximaNova-Regular", size: 16.0)
                        cfmLabel[yIndex].textAlignment = .left
                        cfmLabel[yIndex].text = macAvg
                        reportListView[yIndex].addSubview(cfmLabel[yIndex])
                        
                        lblConstTypeValue[yIndex] = UILabel()
                        let nWidth = Int(reportListView[yIndex].frame.size.width - 5) - Int(cfmLabel[yIndex].frame.origin.x + cfmLabel[yIndex].frame.size.width + 10)
                        if Common.deviceType() == "iPhone5" {
                            lblConstTypeValue[yIndex].frame = CGRect.init(x: Int(cfmLabel[yIndex].frame.origin.x + cfmLabel[yIndex].frame.size.width + 10), y: Int(8), width: Int(nWidth), height: 21)
                        } else if Common.deviceType() == "iPhone6plus" {
                            lblConstTypeValue[yIndex].frame = CGRect.init(x: Int(cfmLabel[yIndex].frame.origin.x + cfmLabel[yIndex].frame.size.width + 40), y: Int(8), width: Int(nWidth), height: 21)
                        } else if Common.deviceType() == "iPhone6" || Common.deviceType() == "iPhoneX" {
                            lblConstTypeValue[yIndex].frame = CGRect.init(x: Int(cfmLabel[yIndex].frame.origin.x + cfmLabel[yIndex].frame.size.width + 20), y: Int(8), width: Int(nWidth), height: 21)
                        }
                        lblConstTypeValue[yIndex].textColor = UIColor.init(hexString: "545454")
                        lblConstTypeValue[yIndex].font = UIFont.init(name: "ProximaNova-Regular", size: 16.0)
                        lblConstTypeValue[yIndex].textAlignment = .left
                        reportListView[yIndex].addSubview(lblConstTypeValue[yIndex])
                        
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
                        
                        lblConstTypeValue[yIndex].text = constructionName
                        lblWeftValue[yIndex] = UILabel()
                        lblWeftValue[yIndex].frame = CGRect.init(x: Int(lblConstTypeValue[yIndex].frame.origin.x), y: Int(lblConstTypeValue[yIndex].frame.origin.y + lblConstTypeValue[yIndex].frame.size.height + 6), width: 48, height: 21)
                        lblWeftValue[yIndex].textColor = UIColor.init(hexString: "4576B9")
                        lblWeftValue[yIndex].font = UIFont.init(name: "ProximaNova-Regular", size: 16.0)
                        lblWeftValue[yIndex].textAlignment = .left
                        lblWeftValue[yIndex].text = weftStr
                        reportListView[yIndex].addSubview(lblWeftValue[yIndex])
                        
                        lblWrapValue[yIndex] = UILabel()
                        lblWrapValue[yIndex].frame = CGRect.init(x: Int(lblWeftValue[yIndex].frame.origin.x + lblWeftValue[yIndex].frame.size.width) , y: Int(lblConstTypeValue[yIndex].frame.origin.y + lblConstTypeValue[yIndex].frame.size.height + 6), width: 48, height: 21)
                        lblWrapValue[yIndex].textColor = UIColor.init(hexString: "E58F26")
                        lblWrapValue[yIndex].font = UIFont.init(name: "ProximaNova-Regular", size: 16.0)
                        lblWrapValue[yIndex].textAlignment = .left
                        lblWrapValue[yIndex].text = warpStr
                        reportListView[yIndex].addSubview(lblWrapValue[yIndex])
                        
                        previewButton[yIndex] = UIButton(type: .custom)
                        if Common.deviceType() == "iPhone5" {
                            previewButton[yIndex].frame = CGRect(x: CGFloat(lblWrapValue[yIndex].frame.origin.x + lblWrapValue[yIndex].frame.size.width - 12), y: CGFloat(lblWrapValue[yIndex].frame.origin.y-10), width: CGFloat(44), height: CGFloat(40))
                        } else if Common.deviceType() == "iPhone6plus" || Common.deviceType() == "iPhone6" || Common.deviceType() == "iPhoneX" {
                            previewButton[yIndex].frame = CGRect(x: CGFloat(lblWrapValue[yIndex].frame.origin.x + lblWrapValue[yIndex].frame.size.width + 20), y: CGFloat(lblWrapValue[yIndex].frame.origin.y - 10), width: CGFloat(44), height: CGFloat(40))
                        }
                        commentTag = commentTag + 1
                        previewButton[yIndex].tag = commentTag //yIndex
                        if arrTempComments.count > 0 {
                            previewButton[yIndex].setImage(UIImage.init(named: "shiftwisePreviewSelected"), for: .normal)
                            previewButton[yIndex].isUserInteractionEnabled = true
                        } else {
                            previewButton[yIndex].setImage(UIImage.init(named: "shiftWisePreview"), for: .normal)
                            previewButton[yIndex].isUserInteractionEnabled = false
                        }
                        previewButton[yIndex].addTarget(self, action: #selector(ReportsViewController.reportspreviewAction), for: .touchUpInside)
                        reportListView[yIndex].addSubview(previewButton[yIndex])
                        
                        let viewDivider4 = UIView()
                        viewDivider4.frame = CGRect.init(x: 0, y: lblWrapValue[yIndex].frame.origin.y+lblWrapValue[yIndex].frame.size.height + 8, width: self.reportScrollView.frame.size.width, height: 1)
                        viewDivider4.backgroundColor = UIColor.init(hexString: "DFE6EE")
                        reportListView[yIndex].addSubview(viewDivider4)
                        
                        reportListView[yIndex].frame = CGRect.init(x: 0, y: yCoordList, width: self.reportScrollView.frame.width, height: viewDivider4.frame.origin.y + viewDivider4.frame.size.height)
                        reportContainerView[dindex].addSubview(reportListView[yIndex])
                        
                        yCoordList = reportListView[yIndex].frame.origin.y + reportListView[yIndex].frame.size.height
                        height = yCoordList
                        print("yCoordList \(yCoordList)")
                        //Body Section End
                    }
                }
                // Footer Start
                if containerFlag == "YES" {
                    let lblAverage = UILabel()
                    lblAverage.frame = CGRect.init(x: 16, y: yCoordList + 8, width: 150, height: 21)
                    lblAverage.textColor = UIColor.init(hexString: "4576B9")
                    lblAverage.font = UIFont.init(name: "ProximaNova-Semibold", size: 17.0)
                    lblAverage.textAlignment = .left
                    lblAverage.text = "Average CFM"
                    reportContainerView[dindex].addSubview(lblAverage)
                    
                    lblAverageValue[dindex] = UILabel()
                    lblAverageValue[dindex].frame = CGRect.init(x: Int(self.view.frame.size.width - 120), y: Int(lblAverage.frame.origin.y), width: 105, height: 21)
                    lblAverageValue[dindex].textColor = UIColor.init(hexString: "4576B9")
                    lblAverageValue[dindex].font = UIFont.init(name: "ProximaNova-Semibold", size: 17.0)
                    lblAverageValue[dindex].textAlignment = .right
                    let  avgStr : Double = Double(totalAvg) / Double(arrReportAvgCount)
                    lblAverageValue[dindex].text = String(format:"%.2f", avgStr)
                    reportContainerView[dindex].addSubview(lblAverageValue[dindex])
                    
                    let viewDivider5 = UIView()
                    viewDivider5.frame = CGRect.init(x: 0, y: lblAverage.frame.origin.y+lblAverage.frame.size.height + 8, width: self.reportScrollView.frame.size.width, height: 2)
                    viewDivider5.backgroundColor = UIColor.init(hexString: "DFE6EE")
                    reportContainerView[dindex].addSubview(viewDivider5)
                    
                    height = viewDivider5.frame.origin.y + viewDivider5.frame.size.height
                    
                    reportContainerView[dindex].frame = CGRect.init(x: 0, y: yCoord, width: self.reportScrollView.frame.size.width, height: height)
                    
                    yCoord = reportContainerView[dindex].frame.origin.y + reportContainerView[dindex].frame.size.height + 25
                    
                    reportScrollView.addSubview(reportContainerView[dindex])
                    reportScrollView.contentSize = CGSize.init(width: reportScrollView.contentSize.width, height: reportContainerView[dindex].frame.origin.y+reportContainerView[dindex].frame.size.height+50)
                }//Footer End
            }
        }
        Common.stopPinwheelProcessing()
    }
    
    @objc func reportspreviewAction(sender: UIButton) {
        print("sender tag \(sender.tag)")
        print(arrComments[sender.tag])
        arrSelectedComment = NSMutableArray()
        let dictComment = arrComments[sender.tag] as! NSDictionary
        print(dictComment)
        let arrCom = dictComment.value(forKey: "COMMENTS") as! NSArray
        for index in 0 ..< arrCom.count {
            let dict: NSDictionary = arrCom[index] as! NSDictionary
            print(dict.value(forKey: "startDateTime") as! String)
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
        dcommentTableView.delegate = self
        dcommentTableView.dataSource = self
        dcommentTableView.tableFooterView = UIView()
        dcommentTableView.reloadData()
        dcommentDetailView.isHidden = false
    }
    

    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSelectedComment.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : commentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "commentTableViewCell")! as! commentTableViewCell
        cell.commentTimeLabel.text = (self.arrSelectedComment[indexPath.row] as AnyObject).object(forKey: "CommentTime") as? String
        cell.commentLabel.text = (self.arrSelectedComment[indexPath.row] as AnyObject).object(forKey: RCOMMENTS) as? String
//        cell.commentLabel.text = (self.arrSelectedComment[indexPath.row] as AnyObject).object(forKey: COMMENTS) as? String
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
    
    //MARK: - Shift API Implementation
    func getShiftDataAPI() -> Void {
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
                        self.arrShiftList = NSMutableArray()
                        for index in 0 ..< self.arrShiftData.count {
                            self.arrShiftList.add(Common.parseShiftDataTiming(arrShift: self.arrShiftData, index: index))
                        }
                        print(self.arrShiftList)
                        print(self.arrShiftList[0])
                        self.getDepartmentListAPIReport()
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
    
    func getDepartmentListAPIReport() -> Void {
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
                    self.reportPickerButton.isUserInteractionEnabled = true
                    self.arrDepartment = NSArray()
                    self.arrDepartment = dictResponseDept.value(forKey: RESULTS) as! NSArray
                    print(self.arrDepartment.count)
                    print(self.arrDepartment)
                    if (self.arrDepartment.count > 0) {
                        self.getSystemListAPIForReport()
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
    func getSystemListAPIForReport() -> Void {
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
                    print(self.arrSystem)
                    if self.arrSystem.count > 0 {
                        self.reportPickerButton.isUserInteractionEnabled = true
                        self.getConstructionBasicReport()
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
    func getConstructionBasicReport() -> Void {
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
//                    self.parseDailyReports()
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
    // Remove Function and put logic directly on fn cl
    func parseDailyReports() -> Void {
        print(self.arrDepartment.count)
        print(self.arrShiftData.count)
        print(self.arrSystem.count)
        totalDeptCount = self.arrDepartment.count
        totalShiftCount = self.arrShiftData.count
        totalSystemCount = self.arrSystem.count
        if totalShiftCount > 0 && totalSystemCount > 0 {
            currentDeptIndex = 0;
            currentShiftIndex = 0;
            self.getDailyReportAPI()
        } else {
            Common.stopPinwheelProcessing()
        }
    }
    
    func getDailyReportAPI() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        let dictReports = NSMutableDictionary()
        dictReports.setValue(oID, forKey: RORGANIZATIONID)
        dictReports.setValue("", forKey: DEPARTMENTID)
        dictReports.setValue("", forKey: SYSTEMID)
        dictReports.setValue("", forKey: CONTROLLERID)
        dictReports.setValue(GET_AGGREGATE, forKey: GET_CURRENT_TYPE)
        dictReports.setValue("", forKey: GET_PARAM_SUBTYPE)
        let arrShiftTimePayLoad = NSMutableArray()
        for index in 0 ..< self.arrShiftList.count {
            print((self.arrShiftList[index] as AnyObject).object(forKey: "startTime") as! String)
            print((self.arrShiftList[index] as AnyObject).object(forKey: "endTime") as! String)
            var dshiftStartTime = (self.arrShiftList[index] as AnyObject).object(forKey: "startTime") as! String
            var dshiftEndTime = (self.arrShiftList[index] as AnyObject).object(forKey: "endTime") as! String
//            let strResult = Common.convertStringToDateTime_compare(startTime: "\(txtfldReportPicker.text!) \(dshiftStartTime)", endTIme: "\(txtfldReportPicker.text!) \(dshiftEndTime)")
            let strResult = Common.convertStringToDateTime_compare(startTime: "\(strSelectedDate) \(dshiftStartTime)", endTIme: "\(strSelectedDate) \(dshiftEndTime)")
            print(strResult)
//            dshiftStartTime = "\(txtfldReportPicker.text!) \(dshiftStartTime)"
            dshiftStartTime = "\(strSelectedDate) \(dshiftStartTime)"
            print(dshiftStartTime)
            if strResult == "CURRENTDATE" {
                print("current date")
//                dshiftEndTime = "\(txtfldReportPicker.text!) \(dshiftEndTime)"
                dshiftEndTime = "\(strSelectedDate) \(dshiftEndTime)"
                print(dshiftEndTime)
            } else {
                print("next date")
//                dshiftEndTime = "\(Common.getNextDate(dateString: txtfldReportPicker.text!)) \(dshiftEndTime)"
                dshiftEndTime = "\(Common.getNextDate(dateString: strSelectedDate)) \(dshiftEndTime)"
                strSelectedDate = Common.getNextDate(dateString: strSelectedDate)
                print(dshiftEndTime)
            }
            arrShiftTimePayLoad.add(Common.payloadShiftForming(stTime: dshiftStartTime, endTime: dshiftEndTime, prefID: (self.arrShiftList[index] as AnyObject).object(forKey: "id") as! String))
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
                        self.strSelectedDate = self.txtfldReportPicker.text! // Jan8
                        self.renderingDailyReport()
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
    
}

