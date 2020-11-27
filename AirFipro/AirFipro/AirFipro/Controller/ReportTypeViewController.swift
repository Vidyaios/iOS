//
//  ReportTypeViewController.swift
//  AirFipro
//
//  Created by iexm01 on 27/11/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import UIKit

class reportTypeViewCell: UITableViewCell {
    @IBOutlet var reportTypeName: UILabel!
    @IBOutlet var reportSelctionImg: UIImageView!
}

class ReportTypeViewController: SliderLibViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Variable Declaration
    var swipeGesture = UISwipeGestureRecognizer()
    var arrReportType = NSArray()
    var selectedReportTag = -1
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var reportTypeTableView: UITableView!
    @IBOutlet var reportTypeMenuButton: UIButton!
    
    //MARk: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reportType_widget_initialSetup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reportTypeTableView.reloadData()
    }
    
    
    //MARK: - UISwipeGestureDelegate Method
    @objc func handleSwipePreference(_ sender: UITapGestureRecognizer) {
        print("pan gesture called")
        onSlideMenuButtonPressed(sender: reportTypeMenuButton)
    }
    
    //MARK: - User Defined Methods
    func reportType_widget_initialSetup() {
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipePreference(_:)))
        swipeGesture.delegate = self
        swipeGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeGesture)
        if appDelegate.selectedMenu == 2 {
            headerLabel.text = "SETTINGS"
            arrReportType = ["Change Password", "Configuration"]
        } else {
            headerLabel.text = "REPORTS"
//            arrReportType = ["Daily Report", "Periodical Report", "Stoppage Report"]
            arrReportType = ["Daily Report"]
        }
        self.reportTypeTableView.delegate = self
        self.reportTypeTableView.dataSource = self
        reportTypeTableView.tableFooterView = UIView()
        self.reportTypeTableView.reloadData()
    }
    
    //MARK: - IBAction
    @IBAction func reportType_Widget_Action(_ sender: UIButton) {
        onSlideMenuButtonPressed(sender: reportTypeMenuButton)
    }
    
    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : reportTypeViewCell = tableView.dequeueReusableCell(withIdentifier: "reportTypeViewCell")! as! reportTypeViewCell
        cell.reportTypeName.text = (self.arrReportType[indexPath.row] as! String)
        if indexPath.row == selectedReportTag {
            cell.reportSelctionImg.image = UIImage(named: "departmentSelect")
        } else {
            cell.reportSelctionImg.image = UIImage(named: "departmentUnSelect")
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected Cell \(indexPath.row)")
        selectedReportTag = indexPath.row
        if indexPath.row == 0 {
            if appDelegate.selectedMenu == 2 {
                NSLog("change password selected")
                let SVC = self.storyboard?.instantiateViewController(withIdentifier: SETTINGSVIEW) as? SettingsViewController
                self.navigationController?.pushViewController(SVC!, animated: true)
            } else {
                NSLog("daily report selected")
                let RVC = self.storyboard?.instantiateViewController(withIdentifier: DAILYREPORTVIEW) as? ReportsViewController
                self.navigationController?.pushViewController(RVC!, animated: true)
            }
        } else if indexPath.row == 1 {
            if appDelegate.selectedMenu == 2 {
                NSLog("noti configuration selected")
                let NVC = self.storyboard?.instantiateViewController(withIdentifier: NOTIFICATIONVIEW) as? NotificationViewController
                self.navigationController?.pushViewController(NVC!, animated: true)
            } else {
                NSLog("periodic report selected")
                let PRVC = self.storyboard?.instantiateViewController(withIdentifier: PERIODICALVIEW) as? PeriodicalViewController
                PRVC?.strReportHeader = "PERIODIC"
                self.navigationController?.pushViewController(PRVC!, animated: true)
            }
        } else {
            NSLog("stoppage report selected")
            let PRVC = self.storyboard?.instantiateViewController(withIdentifier: PERIODICALVIEW) as? PeriodicalViewController
            PRVC?.strReportHeader = "STOPPAGE"
            self.navigationController?.pushViewController(PRVC!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrReportType.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43
    }
}
