//
//  ServiceConnector.swift
//  AirFipro
//
//  Created by ixm1 on 11/8/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit
import Alamofire

class ServiceConnector: NSObject {
    static var responseDict = NSDictionary()
    static var statusCode: Int?
    class func serviceConnectorGET(_ methodName: String, callback : @escaping (NSDictionary?, NSString?, Int?) -> ())
    {
        let baseURL = "\(APPBASEURL)\(methodName)" as String
        NSLog("baseURL \(baseURL)")
        var statusC = ""
        print(baseURL)
        var request = URLRequest(url: NSURL.init(string: baseURL)! as URL)
        request.httpMethod = GETMETHOD
        request.setValue(APPLICATIONXWWW, forHTTPHeaderField: CONTENTTYPE)
        request.setValue(APPLICATIONJSON, forHTTPHeaderField: ACCEPT)
        request.setValue(DEVICETYPE, forHTTPHeaderField: REFERREDBY)
        request.setValue(UserDefaults.standard.string(forKey: ROAUTHKEY), forHTTPHeaderField: OAUTH)
        request.setValue(Common.basicAuth(), forHTTPHeaderField: BASICAUTH)
        request.timeoutInterval = 20
        Alamofire.request(request).responseJSON {
            response in
            print(response)
            statusCode = response.response?.statusCode
            switch (response.result) {
            case .success:
                print(response)
                let code: Int = statusCode!
                print(code)
                if( code == CODE204) {
                    callback(responseDict,nil,statusCode)
                    return
                }
                if let JSON = response.result.value {
                    print("JSON: \(response)")
                    NSLog("JSON \(response)")
                    responseDict = JSON as! NSDictionary
                    print("responseObject = \(responseDict)")
                    NSLog("responseObject \(responseDict)")
                    callback(responseDict,nil,statusCode)
                }
                break
            case .failure(let error):
                print(error)
                // callback(nil,error)
                if error._code == NSURLErrorTimedOut {
                    print(error)
                    statusC = error.localizedDescription
                    callback(nil,statusC as NSString?,statusCode)
                } else {
                    statusC = error.localizedDescription
                    callback(nil,statusC as NSString?,statusCode)
                }
                print("\n\nAuth request failed with error:\n \(error)")
                break
            }
        }
    }
    
    class func serviceConnectorGETTest(_ methodName: String, callback : @escaping (NSDictionary?, NSString?, Int?) -> ())
    {
        let baseURL = "\(APPBASEURL)\(methodName)" as String
        NSLog("baseURL \(baseURL)")
        var statusC = ""
        print(baseURL)
        var request = URLRequest(url: NSURL.init(string: baseURL)! as URL)
        request.httpMethod = GETMETHOD
        request.setValue(APPLICATIONXWWW, forHTTPHeaderField: CONTENTTYPE)
        request.setValue(APPLICATIONJSON, forHTTPHeaderField: ACCEPT)
        request.setValue(DEVICETYPE, forHTTPHeaderField: REFERREDBY)
        request.setValue("5a141b053fb55e33ec60e3b0", forHTTPHeaderField: OAUTH)
        request.setValue(Common.basicAuth(), forHTTPHeaderField: BASICAUTH)
        request.timeoutInterval = 20
        Alamofire.request(request).responseJSON {
            response in
            print(response)
            statusCode = response.response?.statusCode
            switch (response.result) {
            case .success:
                print(response)
                let code: Int = statusCode!
                print(code)
                if( code == CODE204) {
                    callback(responseDict,nil,statusCode)
                    return
                }
                if let JSON = response.result.value {
                    print("JSON: \(response)")
                    NSLog("JSON \(response)")
                    responseDict = JSON as! NSDictionary
                    print("responseObject = \(responseDict)")
                    NSLog("responseObject \(responseDict)")
                    callback(responseDict,nil,statusCode)
                }
                break
            case .failure(let error):
                print(error)
                // callback(nil,error)
                if error._code == NSURLErrorTimedOut {
                    print(error)
                    statusC = error.localizedDescription
                    callback(nil,statusC as NSString?,statusCode)
                } else {
                    statusC = error.localizedDescription
                    callback(nil,statusC as NSString?,statusCode)
                }
                print("\n\nAuth request failed with error:\n \(error)")
                break
            }
        }
    }
    
    class func serviceConnectorPOST(_ methodName: String,inputParam: NSMutableDictionary, callback : @escaping (NSDictionary?, NSString?, Int? ) -> ())
    {
        var statusC = ""
        print(inputParam)
        let baseURL = "\(APPBASEURL)\(methodName)" as String
        print(baseURL)
        print(Common.basicAuth())
        var request = URLRequest(url: NSURL.init(string: baseURL)! as URL)
        request.httpMethod = POSTMETHOD
        request.setValue(APPLICATIONJSON, forHTTPHeaderField: CONTENTTYPE)
        request.setValue(APPLICATIONJSON, forHTTPHeaderField: ACCEPT)
        request.setValue(DEVICETYPE, forHTTPHeaderField: REFERREDBY)
        request.setValue(UserDefaults.standard.string(forKey: ROAUTHKEY), forHTTPHeaderField: OAUTH)
        request.setValue(Common.basicAuth(), forHTTPHeaderField: BASICAUTH)
        request.timeoutInterval = TimeInterval(API_INTERVAL)
        request.httpBody = try! JSONSerialization.data(withJSONObject: inputParam, options: [])
        print(request.allHTTPHeaderFields as Any)
        print(request.httpBody as Any)
        Alamofire.request(request).responseJSON {
            response in
            print(response)
            statusCode = response.response?.statusCode
            switch (response.result) {
            case .success:
                print(response)
                print("\(String(describing: statusCode))")
                if let JSON = response.result.value  {
                    print("JSON: \(response)")
                    responseDict = JSON as! NSDictionary
                    print("responseObject = \(responseDict)")
                    callback(responseDict,nil,statusCode)
                }
                break
            case .failure(let error):
                print(error)
                // callback(nil,error)
                if error._code == NSURLErrorTimedOut {
                    print(error)
                    statusC = error.localizedDescription
                    callback(nil,statusC as NSString?,statusCode)
                } else {
                    statusC = error.localizedDescription
                    callback(nil,statusC as NSString?,statusCode)
                }
                print("\n\nAuth request failed with error:\n \(error)")
                break
            }
        }
    }
 
    /*
    class func serviceConnectorPOST(_ methodName: String,inputParam: NSMutableDictionary, callback : @escaping (NSDictionary?, NSString?, Int?) -> ())
    {
        var statusC = ""
        print(inputParam)
        let baseURL = "\(APPBASEURL)\(methodName)" as String
        print(baseURL)
        
        let user = "ixmtexapiv0.1"
        let password = "ixmtexapi2017"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        NSLog("credentail \(base64Credentials)")
        
        var request = URLRequest(url: NSURL.init(string: baseURL)! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("IOS", forHTTPHeaderField: "Referred-By")
        request.setValue("", forHTTPHeaderField: "OAuth-Key")
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 20
        request.httpBody = try! JSONSerialization.data(withJSONObject: inputParam, options: [])
        
        Alamofire.request(request).responseJSON {
            response in
            print(response)
            switch (response.result) {
            case .success:
                statusCode = response.response?.statusCode
                print("\(String(describing: statusCode))")
                
                print(response)
                if let JSON = response.result.value  {
                    print("JSON: \(response)")
                    responseDict = JSON as! NSDictionary
                    print("responseObject = \(responseDict)")
                    callback(responseDict,nil,statusCode)
                }
                break
            case .failure(let error):
                print(error)
                // callback(nil,error)
                if error._code == NSURLErrorTimedOut {
                    print(error)
                    statusC = error.localizedDescription
                    callback(nil,statusC as NSString?,statusCode)
                } else {
                    statusC = error.localizedDescription
                    callback(nil,statusC as NSString?,statusCode)
                }
                print("\n\nAuth request failed with error:\n \(error)")
                break
            }
        }
    }
 */
    class func serviceConnectorPUT(_ methodName: String,inputParam: NSMutableDictionary, callback : @escaping (NSDictionary?, NSString?, Int? ) -> ())
    {
        var statusC = ""
        print(inputParam)
        let baseURL = "\(APPBASEURL)\(methodName)" as String
        print(baseURL)
        print(Common.basicAuth())
        var request = URLRequest(url: NSURL.init(string: baseURL)! as URL)
        request.httpMethod = PUTMETHOD
        request.setValue(APPLICATIONJSON, forHTTPHeaderField: CONTENTTYPE)
        request.setValue(APPLICATIONJSON, forHTTPHeaderField: ACCEPT)
        request.setValue(DEVICETYPE, forHTTPHeaderField: REFERREDBY)
        request.setValue(UserDefaults.standard.string(forKey: ROAUTHKEY), forHTTPHeaderField: OAUTH)
        request.setValue(Common.basicAuth(), forHTTPHeaderField: BASICAUTH)
        request.timeoutInterval = TimeInterval(API_INTERVAL)
        request.httpBody = try! JSONSerialization.data(withJSONObject: inputParam, options: [])
        Alamofire.request(request).responseJSON {
            response in
            print(response)
            statusCode = response.response?.statusCode
            switch (response.result) {
            case .success:
                print(response)
                if let JSON = response.result.value  {
                    print("JSON: \(response)")
                    responseDict = JSON as! NSDictionary
                    print("responseObject = \(responseDict)")
                    callback(responseDict,nil,statusCode)
                }
                break
            case .failure(let error):
                print(error)
                // callback(nil,error)
                if error._code == NSURLErrorTimedOut {
                    print(error)
                    statusC = error.localizedDescription
                    callback(nil,statusC as NSString?,statusCode)
                } else {
                    statusC = error.localizedDescription
                    callback(nil,statusC as NSString?,statusCode)
                }
                print("\n\nAuth request failed with error:\n \(error)")
                break
            }
        }
    }
    
    class func serviceConnectorDELETE(_ methodName: String, callback : @escaping (NSDictionary?, NSString?, Int?) -> ())
    {
        let baseURL = "\(APPBASEURL)\(methodName)" as String
        NSLog("baseURL \(baseURL)")
        var statusC = ""
        print(baseURL)
        print(Common.basicAuth())
        
        var request = URLRequest(url: NSURL.init(string: baseURL)! as URL)
        request.httpMethod = DELETEMETHOD
        request.setValue(APPLICATIONJSON, forHTTPHeaderField: ACCEPT)
        request.setValue(DEVICETYPE, forHTTPHeaderField: REFERREDBY)
        request.setValue(UserDefaults.standard.string(forKey: ROAUTHKEY), forHTTPHeaderField: OAUTH)
        request.timeoutInterval = TimeInterval(API_INTERVAL)
        print(request.allHTTPHeaderFields as Any)
        print(request.httpBody as Any)
        Alamofire.request(request).responseJSON { response in
            statusCode = response.response?.statusCode
            switch (response.result) {
            case .success:
                print(response)
                if let JSON = response.result.value  {
                    print("JSON: \(response)")
                    NSLog("JSON \(response)")
                    responseDict = JSON as! NSDictionary
                    print("responseObject = \(responseDict)")
                    NSLog("responseObject \(responseDict)")
                    callback(responseDict,nil,statusCode)
                }
                break
            case .failure(let error):
                print(error)
                if error._code == NSURLErrorTimedOut {
                    print(error)
                    statusC = error as! String
                    callback(nil,statusC as NSString?,statusCode)
                } else {
                    statusC = error as! String
                    callback(nil,statusC as NSString?,statusCode)
                }
                print("\n\nAuth request failed with error:\n \(error)")
                break
            }
        }
    }
    
    
    //MARK: - JSON Request
    class func setLoginRequestParameter(dictLogin: NSDictionary) -> NSMutableDictionary {
        var parameters = NSMutableDictionary()
        parameters = ["userName" :  dictLogin.value(forKey: EMAILID) as AnyObject,
                      "password" : dictLogin.value(forKey: PASSWORD) as AnyObject,
                      "keyValues" : dictLogin.value(forKey: KEYVALUE) as AnyObject
        ]
        print("parameter \(parameters)")
        return parameters
    }
    
    class func setReportParameter(dictReport: NSDictionary) -> NSMutableDictionary {
        var parameters = NSMutableDictionary()
        parameters = ["organizationId" :  dictReport.value(forKey: RORGANIZATIONID) as AnyObject,
                      "departmentId" : dictReport.value(forKey: DEPARTMENTID) as AnyObject,
                      "systemId" : dictReport.value(forKey: SYSTEMID) as AnyObject,
                      "controllerId" :  dictReport.value(forKey: CONTROLLERID) as AnyObject,
//                      "startDate" : dictReport.value(forKey: GET_PARAM_ST_DATE) as AnyObject,
//                      "endDate" : dictReport.value(forKey: GET_PARAM_END_DATE) as AnyObject,
                      "duration" :  dictReport.value(forKey: "duration") as AnyObject,
                      "type" : dictReport.value(forKey: GET_CURRENT_TYPE) as AnyObject,
                      "subType" : dictReport.value(forKey: GET_PARAM_SUBTYPE) as AnyObject
        ]
        print("parameter \(parameters)")
        return parameters
    }
    
    class func setAddMachineRequestParameter(dictLogin: NSDictionary) -> NSMutableDictionary {
        var parameters = NSMutableDictionary()
        parameters = ["description" :  dictLogin.value(forKey: DESCRIPTION) as AnyObject,
                      "id" : dictLogin.value(forKey: RID) as AnyObject,
                      "name" : dictLogin.value(forKey: RNAME) as AnyObject,
                      "organizationId" : dictLogin.value(forKey: RORGANIZATIONID) as AnyObject,
                      "departmentId" : dictLogin.value(forKey: DEPARTMENTID) as AnyObject,
                      "type" : dictLogin.value(forKey: RTYPE) as AnyObject,
                      "state" : dictLogin.value(forKey: STATE) as AnyObject,
                      "characteristics" : dictLogin.value(forKey: KEYVALUE) as AnyObject
        ]
        print("parameter \(parameters)")
        return parameters
    }
    
    class func setConstructionRequestParameter(dictConstruct: NSDictionary) -> NSMutableDictionary {
        var parameters = NSMutableDictionary()
        parameters = ["systemId" :  dictConstruct.value(forKey: SYSTEMID) as AnyObject,
                      "controllerId" : dictConstruct.value(forKey: CONTROLLERID) as AnyObject,
                      "departmentId" : dictConstruct.value(forKey: DEPARTMENTID) as AnyObject,
                      "id" : dictConstruct.value(forKey: RID) as AnyObject,
                      "organizationId" : dictConstruct.value(forKey: RORGANIZATIONID) as AnyObject,
                      "type" : dictConstruct.value(forKey: RTYPE) as AnyObject,
                      "preferenceItem" : dictConstruct.value(forKey: RPREFERENCES) as AnyObject
        ]
        print("parameter \(parameters)")
        return parameters
    }
    
    class func setNotificationRequestParameter(dictNotification: NSDictionary) -> NSMutableDictionary {
        var parameters = NSMutableDictionary()
        parameters = ["systemId" :  dictNotification.value(forKey: SYSTEMID) as AnyObject,
                      "controllerId" : dictNotification.value(forKey: CONTROLLERID) as AnyObject,
                      "departmentId" : dictNotification.value(forKey: DEPARTMENTID) as AnyObject,
                      "id" : dictNotification.value(forKey: RID) as AnyObject,
                      "organizationId" : dictNotification.value(forKey: RORGANIZATIONID) as AnyObject,
                      "type" : dictNotification.value(forKey: RTYPE) as AnyObject,
                      "preferenceItem" : dictNotification.value(forKey: RPREFERENCES) as AnyObject
        ]
        print("parameter \(parameters)")
        return parameters
    }
    
    class func setNotiOnOffStatusRequestParameter(dictNotification: NSDictionary) -> NSMutableDictionary {
        var parameters = NSMutableDictionary()
        parameters = ["userId" : dictNotification.value(forKey: RUSERID) as AnyObject,
                      "organizationId" : dictNotification.value(forKey: RORGANIZATIONID) as AnyObject,
                      "keyValues" : dictNotification.value(forKey: KEYVALUE) as AnyObject
        ]
        print("parameter \(parameters)")
        return parameters
    }
    
    class func changePassword_request_parameter(dictSettings: NSDictionary) -> NSMutableDictionary {
        var parameters = NSMutableDictionary()
        parameters = ["type" : dictSettings.value(forKey: RTYPE) as AnyObject,
                      "keyValues" : dictSettings.value(forKey: KEYVALUE) as AnyObject
        ]
        print("parameter \(parameters)")
        return parameters
    }
    
    class func updateNotiListRequestParameter(dictUpdateList: NSDictionary) -> NSMutableDictionary {
        var parameters = NSMutableDictionary()
        parameters = ["id" : dictUpdateList.value(forKey: RID) as AnyObject,
                      "organizationId" : dictUpdateList.value(forKey: RORGANIZATIONID) as AnyObject,
                      "departmentId" : dictUpdateList.value(forKey: DEPARTMENTID) as AnyObject,
                      "systemId" :  dictUpdateList.value(forKey: SYSTEMID) as AnyObject,
                      "controllerId" : dictUpdateList.value(forKey: CONTROLLERID) as AnyObject,
                      "state" : dictUpdateList.value(forKey: STATE) as AnyObject,
                      "type" : dictUpdateList.value(forKey: RTYPE) as AnyObject
        ]
        print("parameter \(parameters)")
        return parameters
    }
}
