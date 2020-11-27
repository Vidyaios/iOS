//
//  RetryWifiViewController.swift
//  AirFipro
//
//  Created by ixm1 on 11/15/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit
import KDCircularProgress

class RetryWifiViewController: UIViewController {

    //MARK: - Variable Declaration
    @IBOutlet var progress: KDCircularProgress!
    @IBOutlet var retryProgressView: UIView!
    @IBOutlet var progressLabel: UILabel!
    
    var strProgress = 0
    var myTimer: Timer? = nil
    var serviceTimer: Timer? = nil
    var retrySystemId = ""
    var retryDeptId = ""

    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        retryWifi_InitialSetup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - User Defined Methods
    func retryWifi_InitialSetup() -> Void {
        print("system id == \(self.retrySystemId)")
        print("dept id == \(self.retryDeptId)")
        Common.showCustomAlert(message: CHANGENETWORKMESSAGE)
        progressLabel.text = "\(strProgress)"
        retryProgressView.isHidden = true
    }
    
    @objc func countDownTick() {
        print("timer called")
        strProgress = strProgress + 1
        progressLabel.text = "\(strProgress)"
    }
    
    func resetProgressSetup() {
        progress.startAngle = -90
        progress.pauseAnimation()
        self.myTimer!.invalidate()
        self.myTimer=nil
        self.serviceTimer!.invalidate()
        self.myTimer=nil
        retryProgressView.isHidden = false
    }
    
    //MARK: - IBAction
    @IBAction func retry_WifiConnection_Action(_ sender: UIButton) {
        if Common.reachabilityChanged() == true {
            retryProgressView.isHidden = false
            myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownTick), userInfo: nil, repeats: true)
            progress.animate(fromAngle: 0, toAngle: 360, duration: 100) { completed in
                if completed {
                    print("animation stopped, completed")
                    self.resetProgressSetup()
                   
                    let alertController = UIAlertController(title: WARNING, message: RETRYCONFIGVALIDATION, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                        print("OK")
                        print("navigate to the bin list screen")
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: SystemListViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)

                } else {
                    print("animation stopped, was interrupted")
                }
            }
            getControllerStatusDetails()
            serviceTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.getControllerStatusDetails), userInfo: nil, repeats: true)
        } else {
            Common.showCustomAlert(message: NWCONNECTION)
        }
    }
    
    //MARK: - API Implementation
    @objc func getControllerStatusDetails() -> Void {
        let oID = UserDefaults.standard.object(forKey: RORGANIZATIONID) as! String
        print(oID)
        let methodName = "\(CONTROLLER_METHOD_NAME)"+QUERYMARK+GET_PARAM_ORGANIZATIONID+QUERYSYMBOL+"\(UserDefaults.standard.object(forKey: RORGANIZATIONID)! as! String)"+QUERYJOIN+GET_PARAM_DEPARTMENTID+QUERYSYMBOL+self.retryDeptId+QUERYJOIN+GET_PARAM_SYSTEMID+QUERYSYMBOL+self.retrySystemId
        print(methodName)
        ServiceConnector.serviceConnectorGET(methodName) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResponseRetry = NSDictionary()
                dictResponseRetry = responseObject! as NSDictionary
                print(dictResponseRetry)
                if (code == CODE200) {
                    var arrTempList: NSArray = []
                    arrTempList = dictResponseRetry.value(forKey: RESULTS) as! NSArray
                    if arrTempList.count > 0 {
                        self.resetProgressSetup()
                        appDelegate.machineAddedStatus = "YES"
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: SystemListViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    }
                } else {
                }
            } else {
                print("error = \(String(describing: error))")
                Common.showCustomAlert(message: error! as String)
            }
        }
    }
    
}
