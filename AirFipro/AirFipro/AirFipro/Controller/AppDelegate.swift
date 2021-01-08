//
//  AppDelegate.swift
//  AirFipro
//
//  Created by ixm1 on 11/7/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var imageViewSplash = UIImageView()
    var viewController: UIViewController?
    var selectedMenu = 0
    var deptName: String = ""
    var deptId: String = ""
    var deptStatus: String = ""
    var viewController_Navigation_Type: String = ""
    var machineAddedStatus = ""
    var preferencePermission: String = ""
    var arrDeptNotiList = NSMutableArray()
    var arrControllerListGlobal = NSMutableArray() // not need
    var orgName: String = ""
    var strUserPassword = ""
    var appDeviceToken = ""
    var strSocketTimeout = ""
    var dictOrgDetails = NSMutableDictionary()
    var  alert = SCLAlertViewResponder.init(alertview: SCLAlertView()) 
    var strTimeZone = ""
    var strColorCode = ""
    var strPushCID = ""
    var strPushOID = ""
    var strPushNID = ""
    var strPushDID = ""
    var strPushSID = ""
    var strPushType = ""
    var strPushDesc = ""
    var strPushAlertType = ""
    var arrPushGlobal = NSMutableArray()
    var strPushNotiLoaded = ""
    var player: AVAudioPlayer!
    var badgeCount = 0
    var alertStatus = "YES"
    
    //MARK: - APP Life Cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotifications(application: application)
        arrPushGlobal = NSMutableArray()
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(red: 69.0/255.0, green: 116.0/255.0, blue: 184.0/255.0, alpha: 1)
        UIApplication.shared.statusBarStyle = .lightContent
        imageViewSplash.frame = (self.window?.bounds)!
//        imageViewSplash.image = UIImage.gif(name: "Airfiprosplashplus")
        imageViewSplash.image = UIImage.gif(name: "AirfiprosplashplusNew")
        self.window?.addSubview(imageViewSplash)
        perform(#selector(self.removeSplash), with: imageViewSplash, afterDelay: 5)
        
        if  let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            NSLog("Current Date Notifications \(userInfo)")
            let aps = userInfo["aps"] as! NSDictionary
            NSLog("aps Notifications \(aps)")
            
            badgeCount = badgeCount + 1
            UIApplication.shared.applicationIconBadgeNumber = badgeCount + 1
            NSLog("***********************************************1")
            NSLog("badge count \(badgeCount)")
            
            let message = userInfo["data"] as! String
            NSLog("Notifications \(message)")
            if let data = message.data(using: .utf8) {
                do {
                    let dictData = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    NSLog("Notifications data \(dictData))")
                    print("Notifications data \(dictData))")
                    NSLog("***********************************************1")
                    NSLog("alert type \(dictData.value(forKey: ALERTTYPE) as! String)")
//                    NSLog("color code \(dictData.value(forKey: COLORCODE) as! String)")
//                    strColorCode = dictData.value(forKey: COLORCODE) as! String
                    NSLog("color code \(dictData.value(forKey: PUSHCOLORCODE) as! String)")
                    strColorCode = dictData.value(forKey: PUSHCOLORCODE) as! String
                    NSLog("***********************************************1")
                    NSLog("alert description \(dictData.value(forKey: RDESCRIPTION) as! String)")
                    SwiftEventBus.post("ALERTHANDLER")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - User Defined Method
    func registerForPushNotifications(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
            if (granted) {
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            } else{
                //Do stuff if unsuccessful...
            }
        })
    }
    @objc func removeSplash() -> Void {
        if UserDefaults.standard.string(forKey: APPLAUNCHSTATUS) == "YES" {
            if Common.reachabilityChanged() == true {
                Common.startPinwheelProcessing()
                userAutoLoginService()
            } else {
                Common.showCustomAlert(message: NWCONNECTION)
                imageViewSplash.removeFromSuperview()
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                viewController = mainStoryboard.instantiateViewController(withIdentifier: INITIALVIEW) as! ViewController
                let rootViewController = self.window!.rootViewController as! UINavigationController
                rootViewController.pushViewController(viewController!, animated: false)
                self.window?.rootViewController?.navigationController?.isNavigationBarHidden = true
            }
        } else {
            UserDefaults.standard.setValue("", forKey: ROAUTHKEY)
            UserDefaults.standard.setValue("", forKey: "ORGNAME")
            preferencePermission = "YES"
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            viewController = mainStoryboard.instantiateViewController(withIdentifier: INITIALVIEW) as! ViewController
            let rootViewController = self.window!.rootViewController as! UINavigationController
            Common.viwwFadein(view: rootViewController.view)
            rootViewController.pushViewController(viewController!, animated: true)
            self.window?.rootViewController?.navigationController?.isNavigationBarHidden = true
        }
//        imageViewSplash.removeFromSuperview()
//        UserDefaults.standard.setValue("", forKey: ROAUTHKEY)
//        UserDefaults.standard.setValue("", forKey: "ORGNAME")
//        preferencePermission = "YES"
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        viewController = mainStoryboard.instantiateViewController(withIdentifier: INITIALVIEW) as! ViewController
//        let rootViewController = self.window!.rootViewController as! UINavigationController
//        rootViewController.pushViewController(viewController!, animated: false)
//        self.window?.rootViewController?.navigationController?.isNavigationBarHidden = true
    }
    //MARK: - Push Notification Delegates
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
        NSLog("push notification device token\(deviceTokenString)")
        appDeviceToken = deviceTokenString
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
        
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        print("Push notification received: \(data)")
        NSLog("***********************************************1")
        NSLog("Push notification received Siraj: \(data)")
        let dictData = data as [AnyHashable: Any]! as NSDictionary!
        let aps = dictData?["aps"] as! NSDictionary
        NSLog("Siraj Notifications \(aps)")
        if (application.applicationState == UIApplicationState.active) {
            NSLog("Push notification received Siraj Active forground dictData\(String(describing: dictData))")
            NSLog("Push notification received Siraj Active forground")
            guard let url = Bundle.main.url(forResource: "apple_sms", withExtension: "mp3") else {
                print("error")
                return
            }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: url)
                guard let player = player else { return }
                player.numberOfLoops = 0
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
            
            let message = dictData?["data"] as! String
            NSLog("Notifications \(message)")
            if let data = message.data(using: .utf8) {
                do {
                    let dictData = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    NSLog("Notifications data \(dictData)")
                    print("Notifications data \(dictData)")
                    NSLog("***********************************************1")
                    NSLog("alert type \(dictData.value(forKey: ALERTTYPE) as! String)")
//                    NSLog("color code \(dictData.value(forKey: COLORCODE) as! String)")
                    NSLog("color code \(dictData.value(forKey: PUSHCOLORCODE) as! String)")
//                    strColorCode = dictData.value(forKey: COLORCODE) as! String
                    strColorCode = dictData.value(forKey: PUSHCOLORCODE) as! String
                    NSLog("***********************************************1")
                    NSLog("alert description \(dictData.value(forKey: RDESCRIPTION) as! String)")
                    strPushNID = dictData.value(forKey: "N_ID") as! String
                    strPushAlertType = dictData.value(forKey: "ALERT_TYPE") as! String
                    strPushDesc = dictData.value(forKey: RDESCRIPTION) as! String
                    strPushDID = dictData.value(forKey: "D_ID") as! String
                    strPushSID = dictData.value(forKey: "S_ID") as! String
                    strPushCID = dictData.value(forKey: "C_ID") as! String
                    strPushType = dictData.value(forKey: "TYPE") as! String
                    strPushOID = dictData.value(forKey: "O_ID") as! String
                    SwiftEventBus.post("ALERTHANDLER")
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            NSLog("***********************************************11")
            NSLog("Push notification received Siraj Active BACKGROUND dictData\(String(describing: dictData))")
        }
    }
    
    // MARK: - API Implementation
    func userAutoLoginService() -> Void {
        var macAddress = ""
        if appDelegate.appDeviceToken != "" {
            macAddress = appDelegate.appDeviceToken
        } else {
            macAddress = "30A92AB042E5F53F13541AEDF2BBC45C05115D5829D5EB13DDE764AC3AEF2A15"
        }
        let dictSignIn = NSMutableDictionary()
        dictSignIn.setValue(UserDefaults.standard.object(forKey: EMAILID) as! String, forKey: EMAILID)
        dictSignIn.setValue(UserDefaults.standard.object(forKey: PASSWORD) as! String, forKey: PASSWORD)
        let arrSignInPayLoad = NSMutableArray()
        arrSignInPayLoad.add(Common.payloadKeyValue(strKey: DEVICE_MAC_ADDRESS, strValue: macAddress))
        arrSignInPayLoad.add(Common.payloadKeyValue(strKey: DEVICE_TOKEN, strValue: macAddress))
        dictSignIn.setValue(arrSignInPayLoad, forKey: KEYVALUE)
        print("Dict SignIn\(dictSignIn)")
        let parameters: NSDictionary = ServiceConnector.setLoginRequestParameter(dictLogin: dictSignIn)
        print("Dict JSON Formation SingIn\(parameters)")
        
        ServiceConnector.serviceConnectorPOST(LOGIN_METHOD_NAME, inputParam: parameters as! NSMutableDictionary) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResAutoLogin = NSDictionary()
                dictResAutoLogin = responseObject! as NSDictionary
                if (code == CODE201) {
                    dictResAutoLogin = dictResAutoLogin.value(forKey: RESULTS) as! NSDictionary
                    print(dictResAutoLogin.object(forKey: "oauthKey") as! String)
                    let dictUser: NSDictionary = dictResAutoLogin.value(forKey: RUSER) as! NSDictionary
                    UserDefaults.standard.setValue(dictResAutoLogin.object(forKey: ROAUTHKEY) as! String, forKey: ROAUTHKEY)
                    UserDefaults.standard.setValue(dictUser.object(forKey: RID) as! String, forKey: RUSERID)
                    UserDefaults.standard.setValue(dictUser.object(forKey: RORGANIZATIONID) as! String, forKey: RORGANIZATIONID)
                    var arrKeyValue = NSArray()
                    arrKeyValue = dictUser.object(forKey: RKEYVALUES) as! NSArray
                    print(arrKeyValue)
                    if arrKeyValue.count > 0 {
                        print(arrKeyValue.count)
                        print(arrKeyValue[0] as AnyObject)
                        for index in 0 ..< arrKeyValue.count {
                            var dictKeyValues = NSDictionary()
                            dictKeyValues = arrKeyValue[index] as! NSDictionary
                            if dictKeyValues.value(forKey: KEY) as! String == NOTIFICATIONSTATE {
                                let arrValues = dictKeyValues.value(forKey: VALUE) as! NSArray
                                if arrValues[0] as! String == "ACTIVE" {
                                    appDelegate.preferencePermission = "YES"
                                    break
                                }
                                appDelegate.preferencePermission = "NO"
                            }
                        }
                    }
                    appDelegate.strUserPassword = UserDefaults.standard.object(forKey: PASSWORD) as! String
                    self.imageViewSplash.removeFromSuperview()
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let DVC = mainStoryboard.instantiateViewController(withIdentifier: DEPARTMENTVIEW) as? DepartmentViewController
                    appDelegate.viewController_Navigation_Type = NAVIGATIONTYPESIGNIN
//                    self.navigationController?.pushViewController(DVC!, animated: true)
                    let rootViewController = self.window!.rootViewController as! UINavigationController
                    rootViewController.pushViewController(DVC!, animated: false)
                    self.window?.rootViewController?.navigationController?.isNavigationBarHidden = true
                    Common.stopPinwheelProcessing()
                } else {
                    Common.stopPinwheelProcessing()
                    self.imageViewSplash.removeFromSuperview()
                    Common.showCustomAlert(message: Common.parseJSONResponseErrors(code: code, respDict: dictResAutoLogin))
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    self.viewController = mainStoryboard.instantiateViewController(withIdentifier: INITIALVIEW) as! ViewController
                    let rootViewController = self.window!.rootViewController as! UINavigationController
                    rootViewController.pushViewController(self.viewController!, animated: false)
                    self.window?.rootViewController?.navigationController?.isNavigationBarHidden = true
                }
            } else {
                print("error = \(String(describing: error))")
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: error! as String)
                self.imageViewSplash.removeFromSuperview()
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                self.viewController = mainStoryboard.instantiateViewController(withIdentifier: INITIALVIEW) as! ViewController
                let rootViewController = self.window!.rootViewController as! UINavigationController
                rootViewController.pushViewController(self.viewController!, animated: false)
                self.window?.rootViewController?.navigationController?.isNavigationBarHidden = true
            }
        }
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
