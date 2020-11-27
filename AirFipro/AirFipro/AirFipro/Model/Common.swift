//
//  Common.swift
//  AirFipro
//
//  Created by ixm1 on 11/8/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

class Common: NSObject {
//    class func showAlert (header: String, message: String) {
//        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
//    }
    class func md5(string: String) -> Data? {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData
    }
    ////dec 11
    class func showCustomAlert (message: String) {
        let appearance = SCLAlertView.SCLAppearance(
            kTextFont: UIFont(name: "ProximaNova-Semibold", size: 14)!,
            kButtonFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
            showCircularIcon: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showWarning(WARNING, subTitle: message)
    }
    
    class func showCustomAlertSuccess (message: String) {
        let appearance = SCLAlertView.SCLAppearance(
            kTextFont: UIFont(name: "ProximaNova-Semibold", size: 14)!,
            kButtonFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
            showCircularIcon: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showSuccess(SUCCESS, subTitle: message)
    }
    
    class func showCustomAlertWithHeader (header: String, message: String) {
        let appearance = SCLAlertView.SCLAppearance(
            kTextFont: UIFont(name: "ProximaNova-Semibold", size: 14)!,
            kButtonFont: UIFont(name: "ProximaNova-Regular", size: 14)!,
            showCircularIcon: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showWarning(header, subTitle: message)
    }
    
    class func startPinwheelProcessing () {
        let appearance = SCLAlertView.SCLAppearance(
            kTextFont: UIFont(name: "ProximaNova-Semibold", size: 16)!,
            showCloseButton: false
        )
        
        appDelegate.alert = SCLAlertView(appearance: appearance).showWait("", subTitle: "\n Loading... please wait \n", closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.noAnimation)
    }
    
    class func stopPinwheelProcessing () {
        appDelegate.alert.close()
    }
    
    class func fetchSSIDInfo() ->  String? {
        if let interfaces = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                
                if let unsafeInterfaceData = unsafeInterfaceData as? Dictionary<AnyHashable, Any> {
                    return unsafeInterfaceData["SSID"] as? String
                }
            }
        }
        return nil
    }
    
    class func currentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        print(result)
        return result
    }
    class func currentDateAgg() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        print(result)
        return result
    }
    
    class func getNextDate(dateString : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let myDate = dateFormatter.date(from: dateString)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate)
        let nextdate = dateFormatter.string(from: tomorrow!)
        print("your next Date is \(nextdate)")
        return nextdate
    }

    class func parseDateAndTime(curDate: String) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter1.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter1.date(from: curDate)
        print(date ?? "")
        dateFormatter1.dateFormat = "HH:mm"
        let startTime = dateFormatter1.string(from: date!)
        print(startTime)
        dateFormatter1.dateFormat = "HH"
        let strHour = dateFormatter1.string(from: date!)
        print(strHour)
        var endTime = "\(Int(strHour)! + 1)"
        print(endTime)
        if endTime.characters.count == 1 {
            endTime = "0\(endTime):00"
        } else {
            endTime = "\(endTime):00"
        }
        let finalTime = "\(startTime) - \(endTime)"
        print(finalTime)
        return finalTime
    }
    
    class func parseDateAndTimeReports(curDate: String) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter1.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter1.date(from: curDate)
        print(date ?? "")
//        dateFormatter1.dateFormat = "HH:mm"
        dateFormatter1.dateFormat = "h:mm a"
        let startTime = dateFormatter1.string(from: date!)
        print(startTime)
        return startTime
    }
    class func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return  dateFormatter.string(from: date!)
    }
    
    class func convertTimeStampDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
    }

    class func parseShiftTimeFormat(time: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let dateresult = formatter.date(from: time)
        formatter.dateFormat = "h:mm a"
        let result = formatter.string(from: dateresult!)
        print(result)
        return result
    }

    
    class func deviceType() -> String {
        var strDeviceType = ""
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        print("screen height \(screenHeight)")
        if screenHeight > 480.0 && screenHeight <= 568.0 {
            strDeviceType = "iPhone5"
        } else if screenHeight > 568.0 && screenHeight <= 667.0 {
            strDeviceType = "iPhone6"
        } else if screenHeight > 667.0 && screenHeight <= 736.0 {
            strDeviceType = "iPhone6plus"
        } else {
            strDeviceType = "iPhoneX"
        }
        return strDeviceType
    }
    class func emailValidation(strMailString: String) -> String {
        print(strMailString)
        var strEmailVal_status: String = ""
        let emailRegEx = "(?:(?:\\r\\n)?[ \\t])*(?:(?:(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*))*@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*|(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)*\\<(?:(?:\\r\\n)?[ \\t])*(?:@(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*(?:,@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*)*:(?:(?:\\r\\n)?[ \\t])*)?(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*))*@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*\\>(?:(?:\\r\\n)?[ \\t])*)|(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)*:(?:(?:\\r\\n)?[ \\t])*(?:(?:(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*))*@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*|(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)*\\<(?:(?:\\r\\n)?[ \\t])*(?:@(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*(?:,@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*)*:(?:(?:\\r\\n)?[ \\t])*)?(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*))*@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*\\>(?:(?:\\r\\n)?[ \\t])*)(?:,\\s*(?:(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*))*@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*|(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)*\\<(?:(?:\\r\\n)?[ \\t])*(?:@(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*(?:,@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*)*:(?:(?:\\r\\n)?[ \\t])*)?(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*))*@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*\\>(?:(?:\\r\\n)?[ \\t])*))*)?;\\s*)" as String
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: strMailString) == true {
            strEmailVal_status = "YES"
        } else {
            strEmailVal_status = "NO"
        }
        return strEmailVal_status
    }
    
    class func reachabilityChanged() -> Bool {
        let reach = Reachability(hostname: "www.google.com")
        if (reach?.isReachable())! {
            print("Notification Says Reachable")
            return true
        }
        else {
            print("Notification Says Unreachable")
            return false
        }
    }

    class func payloadKeyValue(strKey: String, strValue: String) -> NSMutableDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(strKey as String, forKey: KEY)
        var arrValue = NSArray()
        arrValue = ["\(strValue)"]
        dict.setValue(arrValue, forKey: VALUE)
        NSLog("\(dict as NSMutableDictionary)")
        return dict
    }
    class func payloadShiftForming(stTime: String, endTime: String, prefID: String) -> NSMutableDictionary {
        let dict = NSMutableDictionary()
//        dict.setValue(stTime, forKey: "startTime")
//        dict.setValue(endTime, forKey: "endTime")
        dict.setValue(stTime, forKey: "startDateTime")
        dict.setValue(endTime, forKey: "endDateTime")
        dict.setValue(prefID, forKey: "preferenceId")
        NSLog("\(dict as NSMutableDictionary)")
        return dict
    }
    
    
    class func basicAuth() -> String {
        let user = AUTHUSER
        let password = AUTHPASSWORD
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        var base64Credentials = credentialData.base64EncodedString(options: [])
        base64Credentials = "Basic \(base64Credentials)"
        print("credentail \(base64Credentials)")
        return base64Credentials
    }
    
    class func parseJSONResponseErrors(code: Int, respDict: NSDictionary) -> String {
        print(respDict)
        var arrResponseError = NSArray()
        var errorMsg: String = INTERNALSERVER
        print(code)
        if (code == CODE304  || code == CODE400 || code == CODE401 || code == CODE403 || code == CODE409) {
            let dictError = respDict.value(forKey: ERRORS) as! NSDictionary
            print(dictError)
            errorMsg = dictError.value(forKey: MESSAGE) as! String
        } else if (code == CODE404 || code == CODE405 || code == CODE406 || code == CODE412 || code == CODE415 || code == CODE440 || code == CODE500) {
            arrResponseError = respDict.value(forKey: ERRORS) as! NSArray
            if arrResponseError.count > 0 {
                errorMsg = arrResponseError[0] as! String
            }
        }
        return errorMsg
    }
    
    class func checkViewControllerStack() -> Void {
        if let viewControllers = appDelegate.window?.rootViewController?.presentedViewController
        {
          print(viewControllers)
        } else if let viewControllers = appDelegate.window?.rootViewController?.childViewControllers {
            print(viewControllers)
        }
    }
    
    class func parseTypeCollection(strTypeCollection: String, arrKeyValues: NSArray) -> NSMutableDictionary {
        let dict = NSMutableDictionary()
        for index in 0..<(arrKeyValues.count) {
            var dictJSONKeyValues = NSDictionary()
            dictJSONKeyValues = arrKeyValues[index] as! NSDictionary
            print(dictJSONKeyValues)
            var arrValue = NSArray()
            arrValue = dictJSONKeyValues.value(forKey: VALUE) as! NSArray
            if dictJSONKeyValues.value(forKey: KEY) as! String == PURCHASEDATE {
                dict.setValue(arrValue[0] as! String, forKey: PURCHASEDATE)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == WARRANTYENDDATE {
                dict.setValue(arrValue[0] as! String, forKey: WARRANTYENDDATE)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == MAKE {
                dict.setValue(arrValue[0] as! String, forKey: MAKE)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == MODEL {
                dict.setValue(arrValue[0] as! String, forKey: MODEL)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == CONTROLLERCONFIGSTATUS {
                dict.setValue(arrValue[0] as! String, forKey: CONTROLLERCONFIGSTATUS)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == CONTROLLERSERIALNUMBER {
                dict.setValue(arrValue[0] as! String, forKey: CONTROLLERSERIALNUMBER)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == CONTROLLERCONFIGID {
                dict.setValue(arrValue[0] as! String, forKey: CONTROLLERCONFIGID)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == RANGEFROM {
                var strData = ""
                strData = arrValue[0] as! String
                if strData.count <= 4 {
                    let value = NumberFormatter().number(from: strData)?.floatValue
                    strData = String(format: "%05.2f", value!)
                    print(strData)
                }
                dict.setValue(strData, forKey: RANGEFROM)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == RANGETO {
                var strData = ""
                strData = arrValue[0] as! String
                if strData.count <= 4 {
                    let value = NumberFormatter().number(from: strData)?.floatValue
                    strData = String(format: "%05.2f", value!)
                    print(strData)
                }
                dict.setValue(strData, forKey: RANGETO)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == COLORCODE {
                dict.setValue(arrValue[0] as! String, forKey: COLORCODE)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == ALERTTYPE {
                dict.setValue(arrValue[0] as! String, forKey: ALERTTYPE)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == DESCRIPTION {
                dict.setValue(arrValue[0] as! String, forKey: DESCRIPTION)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == COLORNAME {
                dict.setValue(arrValue[0] as! String, forKey: COLORNAME)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == STATE {
                dict.setValue(arrValue[0] as! String, forKey: STATE)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == RDESCRIPTION {
                dict.setValue(arrValue[0] as! String, forKey: RDESCRIPTION)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == WEFT {
                dict.setValue(arrValue[0] as! String, forKey: WEFT)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == WARP {
                dict.setValue(arrValue[0] as! String, forKey: WARP)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == MINIMUM {
                dict.setValue(arrValue[0] as! String, forKey: MINIMUM)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == MAXIMUM {
                dict.setValue(arrValue[0] as! String, forKey: MAXIMUM)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == PICKS {
                dict.setValue(arrValue[0] as! String, forKey: PICKS)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == COMMENTS {
                dict.setValue(arrValue[0] as! String, forKey: RCOMMENTS)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == CONTACTPERSONKEY {
                dict.setValue(arrValue[0] as! String, forKey: CONTACTPERSONKEY)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == CONTACTEMAILKEY {
                dict.setValue(arrValue[0] as! String, forKey: CONTACTEMAILKEY)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == FEEDBACKORGNOKEY {
                dict.setValue(arrValue[0] as! String, forKey: FEEDBACKORGNOKEY)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == INDUSTRYTYPEKEY {
                dict.setValue(arrValue[0] as! String, forKey: INDUSTRYTYPEKEY)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == TIMEZONEID {
                UserDefaults.standard.setValue(arrValue[0] as! String, forKey: TIMEZONE)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == DATETIME {
                dict.setValue(arrValue[0] as! String, forKey: DATETIME)
            } else if dictJSONKeyValues.value(forKey: KEY) as! String == RCOMMENTS {
                dict.setValue(arrValue[0] as! String, forKey: RCOMMENTS)
            }
        }
        print(dict)
        return dict
    }
    
    class func dynmaicPopUpMessage(strMsg: String, strType: String) -> String {
        var strMessage = ""
        if strType == CONFIRMATION {
            strMessage = "Are you sure you want to update \(strMsg) details?"
        } else if strType == UPDATEMESSAGE {
            strMessage = "\(strMsg) details has been updated successfully!"
        } else if strType == DELETESUCCESS {
            strMessage = "\(strMsg) has been deleted!"
        } else if strType == DELETECONFIRMATION {
            strMessage = "Are you sure you want to delete \(strMsg) details?"
        } else if strType == ADDMESSAGE {
            strMessage = "\(strMsg) details has been added successfully!"
        } else if strType == DEVICERESET {
            strMessage = "Are you sure you want to reset \(strMsg)?"
        }
        return strMessage
    }
    
    class func parseSpecificTypeCollection(dictData: NSDictionary) -> NSMutableDictionary {
        let dict = NSMutableDictionary()
        let arrResponseError = dictData.value(forKey: VALUE) as! NSArray
        if arrResponseError.count > 0 {
            dict.setValue(arrResponseError[0] as! String, forKey: dictData.value(forKey: KEY) as! String)
        } else {
            dict.setValue("00.00", forKey: dictData.value(forKey: KEY) as! String)
        }
        return dict
    }
    
    
    class func decodeProtoBufDeviceMQTT(response: String) -> ControllerData {
        var responseArray = [UInt8]()
        responseArray = response.hexa2Bytes
        print(response)
        let decodedFromByteArray = NSData(bytes: responseArray, length: responseArray.count)
        print("decoded from byte array\(decodedFromByteArray)")
        let decodedFromByteSize = try! ControllerData.parseFrom(data: decodedFromByteArray as Data)
        print("decoded from byte size\(decodedFromByteSize)")
        return decodedFromByteSize
    }
    
    class func decodeProtoBufDeleteMQTT(response: String) -> ControllerDelete {
        var responseArray = [UInt8]()
        responseArray = response.hexa2Bytes
        print(response)
        let decodedFromByteArray = NSData(bytes: responseArray, length: responseArray.count)
        print("decoded from byte array\(decodedFromByteArray)")
        let decodedFromByteSize = try! ControllerDelete.parseFrom(data: decodedFromByteArray as Data)
        print("decoded from byte size\(decodedFromByteSize)")
        return decodedFromByteSize
    }

    
    class func checkTypeCollection() -> Int {
        if UserDefaults.standard.object(forKey: TYPECOLLECTION) == nil {
            return 0
        }
        let arrayTypeCollection = UserDefaults.standard.object(forKey: TYPECOLLECTION) as! NSArray
        return arrayTypeCollection.count
    }
    
    class func parseTypeCollectionNotification(arrType: NSArray) -> Void {
        print(arrType)
        print(arrType.count)
        if arrType.count > 0 {
            for index in 0..<(arrType.count) {
                print((arrType[index] as AnyObject).value(forKey: TYPECATEGORY) as! String)
                if (arrType[index] as AnyObject).value(forKey: TYPECATEGORY) as! String == SENSORNOTIFICATION && (arrType[index] as AnyObject).value(forKey: TYPEVALUE) as! String == SETTINGTYPEVALUE {
                    print(arrType[index])
                    var arrNotiKey = NSArray()
                    arrNotiKey = (arrType[index] as AnyObject).value(forKey: RKEYVALUES) as! NSArray
                    print(arrNotiKey)
                    print("arr count \(arrNotiKey.count)")
                    let arrSensorNotiList = NSMutableArray()
                    for index in 0..<(arrNotiKey.count) {
                        var arrJSONKeyValues = NSArray()
                        arrJSONKeyValues = (arrNotiKey[index] as AnyObject).value(forKey: VALUE) as! NSArray
                        print(arrJSONKeyValues)
                        print(arrJSONKeyValues[0])
                        let dict = NSMutableDictionary()
                        dict.setValue(arrJSONKeyValues[0] as! String, forKey: RNAME)
                        let fromvalue = NumberFormatter().number(from: (arrJSONKeyValues[1] as! String))?.floatValue
                        let tovalue = NumberFormatter().number(from: (arrJSONKeyValues[2] as! String))?.floatValue
                        var strFrom = "", strTo = ""
                        if fromvalue != nil {
                            strFrom = String(format: "%05.2f", fromvalue!)
                        }
                        if tovalue != nil {
                            strTo = String(format: "%05.2f", tovalue!)
                        }
                        dict.setValue(strFrom, forKey: RANGEFROM)
                        dict.setValue(strTo, forKey: RANGETO)
                        dict.setValue(arrJSONKeyValues[3] as! String, forKey: ALERTTYPE)
                        dict.setValue(arrJSONKeyValues[4] as! String, forKey: RDESCRIPTION)
                        dict.setValue(arrJSONKeyValues[5] as! String, forKey: COLORNAME)
                        dict.setValue(arrJSONKeyValues[6] as! String, forKey: COLORCODE)
                        dict.setValue(arrJSONKeyValues[7] as! String, forKey: STATE)
                        arrSensorNotiList.add(dict)
                    }
                    print(arrSensorNotiList)
                    UserDefaults.standard.setValue(arrSensorNotiList, forKey: SENSORNOTIFICATION)
                } else if (arrType[index] as AnyObject).value(forKey: TYPECATEGORY) as! String == SYSTEMTYPE && (arrType[index] as AnyObject).value(forKey: TYPEVALUE) as! String == RTYPE {
                    print("system type")
                    print(arrType[index])
                    var arrNotiKey = NSArray()
                    arrNotiKey = (arrType[index] as AnyObject).value(forKey: RKEYVALUES) as! NSArray
                    print(arrNotiKey)
                    print("arr count \(arrNotiKey.count)")
                    let arrSystemTypeList = NSMutableArray()
                    for index in 0..<(arrNotiKey.count) {
                        arrSystemTypeList.add((arrNotiKey[index] as AnyObject).value(forKey: KEY) as! String)
                    }
                    print(arrSystemTypeList)
                    UserDefaults.standard.setValue(arrSystemTypeList, forKey: SYSTEMTYPE)
                } else if (arrType[index] as AnyObject).value(forKey: TYPECATEGORY) as! String == RMACHINETYPE && (arrType[index] as AnyObject).value(forKey: TYPEVALUE) as! String == STATE {
                    print("system")
                    print(arrType[index])
                    var arrNotiKey = NSArray()
                    arrNotiKey = (arrType[index] as AnyObject).value(forKey: RKEYVALUES) as! NSArray
                    print(arrNotiKey)
                    print("arr count \(arrNotiKey.count)")
                    let arrSystemList = NSMutableArray()
                    for index in 0..<(arrNotiKey.count) {
                        arrSystemList.add((arrNotiKey[index] as AnyObject).value(forKey: KEY) as! String)
                    }
                    print(arrSystemList)
                    UserDefaults.standard.setValue(arrSystemList, forKey: STATE)
                }
            }
        }
    }
    
    class func mappingControllerWithMachine(systemId: String, arrController: NSArray) -> NSDictionary {
        var dictResults = NSDictionary()
        for index in 0 ..< arrController.count {
            print((arrController[index] as AnyObject).object(forKey: SYSTEMID) as! String)
            if systemId == (arrController[index] as AnyObject).object(forKey: SYSTEMID) as! String {
                dictResults = arrController[index] as! NSDictionary
                break
            }
        }
        
        return dictResults
    }
    class func parseShiftDataTiming(arrShift: NSArray, index: Int) -> NSMutableDictionary {
        let dictParser = NSMutableDictionary()
        dictParser.setValue((arrShift[index] as AnyObject).object(forKey: "id") as! String, forKey: "id")
        let arrParseShift = (arrShift[index] as AnyObject).object(forKey: "preferenceItem") as! NSArray
        if arrParseShift.count > 0 {
            print((arrParseShift[0] as AnyObject).object(forKey: "name") as! String)
            dictParser.setValue((arrParseShift[0] as AnyObject).object(forKey: "name") as! String, forKey: "shiftName")
            let arrParseShift = (arrParseShift[0] as AnyObject).object(forKey: "keyValues") as! NSArray
            print(arrParseShift.count)
            if arrParseShift.count >= 2 {
                if (arrParseShift[0] as AnyObject).object(forKey: "key") as! String == "TIME_FROM" {
                    let arrData = (arrParseShift[0] as AnyObject).object(forKey: "values") as! NSArray
                    dictParser.setValue(arrData[0] as! String, forKey: "startTime")
                }
                if (arrParseShift[1] as AnyObject).object(forKey: "key") as! String == "TIME_TO" {
                    let arrData = (arrParseShift[1] as AnyObject).object(forKey: "values") as! NSArray
                    dictParser.setValue(arrData[0] as! String, forKey: "endTime")
                }
            }
        }
        return dictParser
    }
    
    class func currentTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.calendar = NSCalendar.current
        formatter.timeZone = TimeZone.current
        let result = formatter.string(from: date)
        print("current time \(result)")
        return result
    }
    class func localToUTC_DateTime(date:String) -> String {
        print(UserDefaults.standard.string(forKey: TIMEZONE)! as String)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "\(UserDefaults.standard.string(forKey: TIMEZONE)! as String)")

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: dt!)
    }
    
    class func UTCToLocal_DateTime(date:String) -> String {
        print(UserDefaults.standard.string(forKey: TIMEZONE)! as String)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(identifier: "\(UserDefaults.standard.string(forKey: TIMEZONE)! as String)")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: dt!)
    }
    
    class func localToUTC_Time(date:String) -> String {
        print(UserDefaults.standard.string(forKey: TIMEZONE)! as String)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "\(UserDefaults.standard.string(forKey: TIMEZONE)! as String)")

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: dt!)
    }
    
    class func localToUTC_Date(date:String) -> String {
        print(UserDefaults.standard.string(forKey: TIMEZONE)! as String)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "\(UserDefaults.standard.string(forKey: TIMEZONE)! as String)")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: dt!)
    }

    
    class func UTCToLocal_Time(date:String) -> String {
        print(UserDefaults.standard.string(forKey: TIMEZONE)! as String)
        print(date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let dt = dateFormatter.date(from: date)
//        dateFormatter.timeZone = TimeZone(abbreviation: UserDefaults.standard.string(forKey: TIMEZONE)! as String)
        dateFormatter.timeZone = TimeZone(identifier: UserDefaults.standard.string(forKey: TIMEZONE)! as String)
        dateFormatter.dateFormat = "HH:mm:ss"
        print(dateFormatter.string(from: dt!))
        return dateFormatter.string(from: dt!)
    }
    
    class func convertStringToDate_compare(startTime: String, endTIme: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let startdate = dateFormatter.date(from: startTime)
        print(startdate!)
        let enddate = dateFormatter.date(from: endTIme)
        print(enddate!)
       
        var strCompare = ""
        let date1 : NSDate = startdate! as NSDate
        let date2 : NSDate = enddate! as NSDate
        let compareResult = date1.compare(date2 as Date)
        print(compareResult)
        switch date1.compare(date2 as Date) {
        case .orderedAscending:
            print("Date 1 is earlier than date 2")
            strCompare = "CURRENTDATE"
        case .orderedSame:
            print("The two dates are the same")
            strCompare = "CURRENTDATE"
        case .orderedDescending:
            print("Date 1 is later than date 2")
            strCompare = "NEXTDATE"
        }
        return strCompare
    }
    
    class func convertStringToDateTime_compare(startTime: String, endTIme: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startdate = dateFormatter.date(from: startTime)
        print(startdate!)
        let enddate = dateFormatter.date(from: endTIme)
        print(enddate!)
        
        var strCompare = ""
        let date1 : NSDate = startdate! as NSDate
        let date2 : NSDate = enddate! as NSDate
        let compareResult = date1.compare(date2 as Date)
        print(compareResult)
        switch date1.compare(date2 as Date) {
        case .orderedAscending:
            print("Date 1 is earlier than date 2")
            strCompare = "CURRENTDATE"
        case .orderedSame:
            print("The two dates are the same")
            strCompare = "CURRENTDATE"
        case .orderedDescending:
            print("Date 1 is later than date 2")
            strCompare = "NEXTDATE"
        }
        return strCompare
    }
    
    class func parseTimestampDate(curDate: String) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter1.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter1.date(from: curDate)
        print(date ?? "")
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let startTime = dateFormatter1.string(from: date!)
        print(startTime)
        return startTime
    }

    class func parseTimestampTime(curDate: String) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter1.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter1.date(from: curDate)
        print(date ?? "")
        //        dateFormatter1.dateFormat = "HH:mm"
        dateFormatter1.dateFormat = "h:mm a"
        let startTime = dateFormatter1.string(from: date!)
        print(startTime)
        return startTime
    }
    
    class func viwwFadein(view: UIView) {
        let transition = CATransition()
        transition.duration = 0.8
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFade
        view.layer.add(transition, forKey: nil)
    }

}

