//
//  DrawerViewController.swift
//  AirFipro
//
//  Created by ixm1 on 11/13/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class drawerTableViewCell: UITableViewCell {
    @IBOutlet var menuCellImageView: UIImageView!
    @IBOutlet var menuCellLabel: UILabel!
}
class DrawerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    //MARK: - Variable Declaration
    @IBOutlet var viewButton: UIButton!
    @IBOutlet var menuListTableView: UITableView!
    var arrayMenuOptions = [Dictionary<String,String>]()
    var delegate : SlideMenuDelegate?
    var btnMenu : UIButton!
    var swipeDrawerGesture = UISwipeGestureRecognizer()
    @IBOutlet var drawerContainerView: UIView!

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        menuList_Setup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBAction
    @IBAction func onCloseMenuClick(_ sender: UIButton) {
        closeSetup(sender: sender)
    }
    
    //MARK: - User Defined Methods
    func menuList_Setup() -> Void {
        swipeDrawerGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleDrawerSwipe(_:)))
        swipeDrawerGesture.delegate = self
        swipeDrawerGesture.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeDrawerGesture)
        
        drawerContainerView.layer.shadowColor = UIColor.black.cgColor
        drawerContainerView.layer.shadowOpacity = 0.8
        drawerContainerView.layer.shadowOffset = CGSize.zero
        drawerContainerView.layer.shadowRadius = 50
        drawerContainerView.layer.shadowPath = UIBezierPath(rect: drawerContainerView.bounds).cgPath
        drawerContainerView.layer.shouldRasterize = true
        drawerContainerView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        
        menuListTableView.delegate = self
        menuListTableView.dataSource = self
        menuListTableView.tableFooterView = UIView()
        arrayMenuOptions.append(["title":"Dashboard", "icon":"dashboardMenu", "selectedIcon":"selDashboardMenu"])
        arrayMenuOptions.append(["title":"Machine Setup", "icon":"sysSetupMenu", "selectedIcon":"selSysSetUpMenu"])
        arrayMenuOptions.append(["title":"Settings", "icon":"settingMenu", "selectedIcon":"selSettingMenu"])
        arrayMenuOptions.append(["title":"Reports", "icon":"reportMenu", "selectedIcon":"selReportMenu"])
        arrayMenuOptions.append(["title":"Notification", "icon":"notiMenu", "selectedIcon":"selNotiMenu"])
        arrayMenuOptions.append(["title":"Feedback", "icon":"feedbackMenu", "selectedIcon":"selFeedbackMenu"])
        arrayMenuOptions.append(["title":"Logout", "icon":"logoutMenu", "selectedIcon":"selLogoutMenu"])
        menuListTableView.reloadData()
        
    }
    
    func closeSetup(sender: UIButton) -> Void {
        btnMenu.tag = 0
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    func dismissOnMenuClick(sender: UIButton) -> Void {
        btnMenu.tag = 0
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            if (self.delegate != nil) {
                var index = Int32(sender.tag)
                if(sender == self.viewButton){
                    index = -1
                }
                self.delegate?.slideMenuItemSelectedAtIndex(index)
            }
        })
    }
    
    //MARK: - UISwipeGesture Delegate Method
    @objc func handleDrawerSwipe(_ sender: UITapGestureRecognizer) {
        print("pan gesture called")
        closeSetup(sender: viewButton)
    }
    
    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : drawerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "drawerTableViewCell")! as! drawerTableViewCell
        cell.menuCellLabel.text = arrayMenuOptions[indexPath.row]["title"]!
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.selectedMenu == indexPath.row {
            cell.menuCellImageView?.image = UIImage(named: arrayMenuOptions[indexPath.row]["selectedIcon"]!)
            cell.backgroundColor = UIColor.init(red: 69.0/255.0, green: 116.0/255.0, blue: 184.0/255.0, alpha: 1)
            cell.menuCellLabel.textColor = UIColor.white
        } else {
            cell.menuCellImageView.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
            cell.backgroundColor = UIColor.clear
            cell.menuCellLabel.textColor = UIColor.init(red: 58.0/255.0, green: 76.0/255.0, blue: 102.0/255.0, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let selectedMenu = appDelegate.selectedMenu
        print("selected menu \(selectedMenu)")
        
        if indexPath.row == 6 {
            appDelegate.selectedMenu = 6
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let cell = self.menuListTableView.cellForRow(at: indexPath) as! drawerTableViewCell
            cell.menuCellImageView?.image = UIImage(named: arrayMenuOptions[indexPath.row]["selectedIcon"]!)
            cell.backgroundColor = UIColor.init(red: 69.0/255.0, green: 116.0/255.0, blue: 184.0/255.0, alpha: 1)
            cell.menuCellLabel.textColor = UIColor.white

            let indexPath1 = IndexPath(row: selectedMenu, section: 0)
            let cell1 = self.menuListTableView.cellForRow(at: indexPath1) as! drawerTableViewCell
            cell1.menuCellImageView.image = UIImage(named: arrayMenuOptions[indexPath1.row]["icon"]!)
            cell1.backgroundColor = UIColor.clear
            cell1.menuCellLabel.textColor = UIColor.init(red: 58.0/255.0, green: 76.0/255.0, blue: 102.0/255.0, alpha: 1)
            
            if Common.reachabilityChanged() == true {
                Common.startPinwheelProcessing()
                logoutUserService()
            } else {
                Common.showCustomAlert(message: NWCONNECTION)
            }
            return
        }

        if indexPath.row == appDelegate.selectedMenu {
            closeSetup(sender: btn)
            return
        }
        self.dismissOnMenuClick(sender: btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    //MARK: - API Implementation
    func logoutUserService() {
        ServiceConnector.serviceConnectorDELETE(LOGIN_METHOD_NAME) {
            responseObject,error,statusCode in
            if (error == nil) {
                let code: Int = statusCode!
                NSLog("\(code)")
                print(code)
                var dictResponse = NSDictionary()
                dictResponse = responseObject! as NSDictionary
                print(dictResponse)
                if (code == CODE202) {
                    Common.stopPinwheelProcessing()
                    UserDefaults.standard.set("", forKey: "ORGNAME")
                    UserDefaults.standard.set([], forKey: TYPECOLLECTION)
                    UserDefaults.standard.set("", forKey: APPLAUNCHSTATUS)
                    UserDefaults.standard.set("", forKey: EMAILID)
                    UserDefaults.standard.set("", forKey: PASSWORD)
                    appDelegate.arrDeptNotiList = NSMutableArray()
                    SwiftEventBus.unregister(self)
                    appDelegate.selectedMenu = 0
                    let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: INITIALVIEW)
                    let newStack = [destViewController]
                    self.navigationController!.setViewControllers(newStack, animated: false)
                } else if (code == CODE400) {
                    Common.stopPinwheelProcessing()
                    Common.showCustomAlert(message: APIFAILURE)
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
}
