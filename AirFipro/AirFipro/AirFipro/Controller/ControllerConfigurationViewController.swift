//
//  ControllerConfigurationViewController.swift
//  AirFipro
//
//  Created by ixm1 on 11/15/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit

class ControllerConfigurationViewController: UIViewController, UITextFieldDelegate, BSKeyboardControlsDelegate {
    
    //MARK: - Variable Declaration
    @IBOutlet var ssidTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var showPswdButton: UIButton!
    
    var keyboardControls: BSKeyboardControls?
    var configSystemId = ""
    let host = SOCKETURL
    let port = SOCKETHOST
    var client: TCPClient?
    var strDeptId = ""
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.strDeptId)
        wifiConfiguration_IntialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("****************************************")
        Common.checkViewControllerStack()
    }

    //MARK: - User Defined Methods
    func wifiConfiguration_IntialSetup() -> Void {
        appDelegate.strSocketTimeout = ""
        ssidTextfield.delegate = self
        passwordTextfield.delegate = self
        ssidTextfield.clearButtonMode = .whileEditing
        passwordTextfield.clearButtonMode = .whileEditing
        ssidTextfield.underlined()
        passwordTextfield.underlined()
        
        let fields = NSArray(array:[ssidTextfield, passwordTextfield])
        keyboardControls = BSKeyboardControls(fields: fields as [AnyObject])
        keyboardControls?.delegate = self
        
        if showPswdButton.currentImage == UIImage.init(named: "uncheck"){
            passwordTextfield.isSecureTextEntry = true
        } else {
            passwordTextfield.isSecureTextEntry = false
        }
        Common.showCustomAlert(message: CONFIGVALIDATION)
        
        SwiftEventBus.onMainThread(self, name: "CONFIGERROR") { result in
            print("wowmagic")
            Common.stopPinwheelProcessing()
        }
    }
    
    
    //MARK: - IBAction
    @IBAction func back_Configuration_Action(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submit_WifiConfiguration_Action(_ sender: UIButton) {
        print("btnTag==\(sender.tag)")
        switch sender.tag {
        case 0: // Submit
            break
        case 1: // Cancel
            let _ = self.navigationController?.popViewController(animated: true)
            break
        case 2: // Show Password Button
            if sender.currentImage == UIImage.init(named: "uncheck") {
                sender.setImage(UIImage.init(named: "checkbox"), for: .normal)
                passwordTextfield.isSecureTextEntry = false
            } else {
                sender.setImage(UIImage.init(named: "uncheck"), for: .normal)
                passwordTextfield.isSecureTextEntry = true
            }
            break
        default:
            break
        }
    }
    
    @IBAction func submit_Configuration_Action(_ sender: UIButton) {
        if ssidTextfield.text == "" {
            Common.showCustomAlert(message: SSIDVALIDATION)
            return
        } else if passwordTextfield.text == "" {
            Common.showCustomAlert(message: PASSWORDVALIDATION)
            return
        }
        Common.startPinwheelProcessing()
        
        let dispatchTimeout = DispatchTime.now() + .seconds(10)
        DispatchQueue.main.asyncAfter(deadline: dispatchTimeout) {
            print("timeout")
            if appDelegate.strSocketTimeout != "YES" {
                Common.showCustomAlert(message: "Connection Timeout")
            }
            Common.stopPinwheelProcessing()
            self.client?.close()
        }
        
        let dispatchTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            print("entered")
            self.client = TCPClient(address: self.host, port: Int32(self.port))
            switch self.client?.connect(timeout: 2) {
            case .success?:
                print("Connected to host \(String(describing: self.client?.address))")
                let socketInput = "ADD,\(self.ssidTextfield.text!),\(self.passwordTextfield.text!),\(UserDefaults.standard.string(forKey: RUSERID)! as String),\(UserDefaults.standard.object(forKey: RORGANIZATIONID)! as! String),\(self.configSystemId),\(self.strDeptId)"
                print("SOCKET INPUT \(socketInput)")
                switch self.client?.send(string: socketInput) {
                case .success?:
                    guard let data = self.client?.read(1024*10) else { return }
                    if let response = String(bytes: data, encoding: .utf8) {
                        print(response)
                        Common.stopPinwheelProcessing()
                        if response as String == "SUCCESS" {
                            print("configuration success")
                            appDelegate.strSocketTimeout = "YES"
                            let RWVC = self.storyboard?.instantiateViewController(withIdentifier: RETRYWIFIVIEW) as? RetryWifiViewController
                            RWVC?.retryDeptId = self.strDeptId
                            RWVC?.retrySystemId = self.configSystemId
                            self.navigationController?.pushViewController(RWVC!, animated: true)
                        }
                    }
                case .failure(let error)?:
                    appDelegate.strSocketTimeout = "YES"
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: String(describing: error))
                    print(String(describing: error))
                case .none:
                    appDelegate.strSocketTimeout = "YES"
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: "Socket connection failed")
                }
            case .failure(let error)?:
                appDelegate.strSocketTimeout = "YES"
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: String(describing: error))
                print(String(describing: error))
            case .none:
                appDelegate.strSocketTimeout = "YES"
                Common.stopPinwheelProcessing()
                Common.showCustomAlert(message: "Socket connection failed")
            }
        }
    }
    
    // MARK: - UITextfield Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keyboardControls?.activeField = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("\(textField.frame.origin.y)")
        textField.underlinedBlue()
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            if textField == self.passwordTextfield {
                    self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: -50, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        }, completion: { finished in
            print("view visible")
        })
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(view.frame.size.width), height: CGFloat(view.frame.size.height))
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " " || range.location == 0 && string == "'" {
            print("empty string not allowed")
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == ssidTextfield {
            ssidTextfield.underlined()
        } else if textField == passwordTextfield {
            passwordTextfield.underlined()
        }
    }
    
    // MARK: - BSKeyboard Delegate Method
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) -> Void {
        self.view.endEditing(true)
        view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(view.frame.size.width), height: CGFloat(view.frame.size.height))
    }
}
