//
//  SettingsViewController.m
//  NOID
//
//  Created by iExemplar on 7/8/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "SettingsViewController.h"
#import "Common.h"
#import "NetworkHomeViewController.h"
#import "TimeZoneViewController.h"
#import "Utils.h"
#import "SWRevealViewController.h"
#import "TimeLineViewController.h"
#import "MBProgressHUD.h"
#import "ServiceConnectorModel.h"
#import "Luhn.h"
#import "Base64.h"
#import "ViewController.h"
#import "MultipleNetworkViewController.h"

#define kButtonIndex 1000
#define kButtonIndexHistory 10000
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface SettingsViewController ()
{
    UIView *menuViewHistory[kButtonIndex];
    UIView *menuTapViewHistory[kButtonIndex];
    UIView *view_History_ContentView[kButtonIndex];
    UILabel *lblMsgAlert[kButtonIndex];
    UILabel *lblDateAlert[kButtonIndex];
    UIButton *btn_Chk_Network_AddUser[kButtonIndex];
    UIButton *viewButtonAlert[kButtonIndex];
    UIButton *btnHistory_Page[kButtonIndexHistory];
    UILabel *lbl_viewBillingHistory[kButtonIndex];
    UITapGestureRecognizer *tapGusters_Container,*tapGuster_Tap,*tapGuster_Slider,*tapGuster_Header;
    UISwipeGestureRecognizer *swipeDown_planoption,*swipeDown_planoption_View;
    UIButton *btnBillingHistory_Page[kButtonIndexHistory];
    
    NSMutableArray *arrBilling_New[kButtonIndex];
    UILabel *lblPlanHeader[kButtonIndex];
    UILabel *lblPlanHeaderRange[kButtonIndex];
    UILabel *lbl_Nw_Name[kButtonIndex];
    UIImageView *imgV_NW_User_Acc[kButtonIndex];
    UIImageView *imgV_NW_User_Acc_List[kButtonIndex];
    UIButton *btn_close_UserAcc[kButtonIndex];

    UIView *menu_User_Acc[kButtonIndex];
    UIView *menu_User_Acc_TapView[kButtonIndex];
    UILabel *lblAcc_Name[kButtonIndex];
    UILabel *lblAcc_LName[kButtonIndex];
    UITextField *txt_AccName[kButtonIndex];
    UITextField *txt_AccLName[kButtonIndex];
//    UILabel *lblChangeSchedule[kButtonIndex];
    UIButton *btn_Save_AccName[kButtonIndex];
    UIView *viewEdit_UserAcc_Billing[kButtonIndex];
    UIButton *btnEdit_UserAcc[kButtonIndex];
    UIView *view_User_Acc_Contentview[kButtonIndex];
    UIButton *btnChange_Schedule_ChkBox_User_Acc,*btnFull_Access_ChkBox_User_Acc,*btnViewOnly_ChkBox_User_Acc;
    UIButton *btn_Chk_Network_UserAcc[kButtonIndex];
    UIView *view_Acc_AddNwtwork;
    UIButton *btn_UserAcc_AddNW[kButtonIndex];
    UIView *viewController[kButtonIndex];
    UILabel *lbl_AccessType[kButtonIndex];
    UILabel *lbl_UserAcc_AccessType[kButtonIndex];
}

@end

@implementation SettingsViewController
@synthesize delegate;
@synthesize btn_edit1_settings,btn_edit2_settings,btn_save1_settings,btn_save2_settings,lbl_email_settings,lbl_name_settings,txtfld_email_settings,txtfld_name_settings,btn_temp1_settings,btn_temp2_settings,str_gear_Type,lbl_TimeZone,btn_close1_settings,btn_close2_settings,btn_UserManage,btn_BillingSetting,btn_HistorySetting,btn_UserSettings,current_textfield_Billing;
@synthesize settingConatinerView,settingHistoryView,settingHomeView,arrUserHistory,btnPageNext,tableViewHistory,imgUserHistroy,imgUserManagement,imgUserSettings,lbl_UserHistory,lbl_UserManagement,lbl_UserSettings,btn_Setting_Logo,btn_backArrow_setting,btn_profileName_setting,imgCheck_Network1_UserManage,imgCheck_Network2_UserManage,imgCheck_Network3_UserManage,imgCheck_Network4_UserManage,imgCheck_Network5_UserManage,imgCheck_Network6_UserManage;
@synthesize settingManageUserView,txtfld_email_userManagement,txtfld_Fname_userManagement,txtfld_Lname_userManagement,viewOnlybtn_userManage,changeSchedule_userManage,fullAccess_userManage,tableView_UserManagement,arrUserAccounts,saveNewUserView,changeNetworkView,selectNetworkView,scrollView_UserManage,userAccountView,imgUserBilling,lbl_UserBilling,alertView_userManagement,btnSave_SelectNetwork_UserManage;
@synthesize settingBillingView,scrollView_Billing,tableView_BillingHistory,tableView_Controller,arrBillingHistory,arrCellularController,arrNoStation,arrBillingAmount,updateCardView,planOptionsView,tableView_PlanOptions,arrPlanOption,alertView_Billing,settingTabView,alertView_info,settingHeaderView,txtfld_CardNo_UpdateCard,txtfld_digits_UpdateCard,txtfld_Month_UpdateCard,txtfld_Year_UpdateCard,txtfld_zipCode_UpdateCard,btnPage1_billing,btnPage2_billing,btnPageNext_billing,bodyViewScroll_UserManage,current_textfield_Usermanage,strchangeNetwork,txtfld_CardName_UpdateCard,lbl_Lname_settings,btn_timeZone_Settings,lbl_Language,strPreviousView,str_Cellular_FirstStatus,arrUserNW_Acc,txtfld_Lname_settings,scroll_History;
@synthesize btnPagePrevious,viewFooter_UserHistory,scroll_Billing_Controller,viewController_Plan,viewController_PlanOptions,scroll_Billing_History,scroll_Billing_Main_Container,view_Settings_CardControllerView,view_Settings_CardDetailView,viewBilling_History,arrBilling_History,arrUserBilling_Controller;
@synthesize lbl_CC_ExpiryDate,lbl_CC_Name,lbl_CC_Number,lbl_Plan_Controller_Cost_Detail_View,lbl_Plan_Controller_Count_MainView,lbl_Plan_Controller_Name_MainView,lbl_Plan_Name_Detail_View,lbl_Plan_Name_MainView,lbl_Plan_RenewalDate_Detail_View,lbl_Plan_RenewalDate_MainView,scrollView_PlanCard,scrollView_Planoptions,imgView_CC_Logo,imgView_Payment_American,imgView_Payment_Discover,imgView_Payment_Mastro,imgView_Payment_Visa,viewFooter_BillingHistory,viewPlan,view_SwipeDown_Payment,btn_SwipeDown_Payment,viewPayment_Alert,scrollUpdateCard,btnPagePrev_Billing,strAccessType,scroll_UserMgt_UserAcc,user_Acc_View_Mgt;
@synthesize addUser_View_Mgt,imgView_Email_UM,imgView_Name_UM,lblEmail_UM,lblLastName_UM,lblName_UM,viewPlanWifi,view_PermissionAlert,viewBilling_RenewalDate,viewAlert_PlanUpgrade_Billing,viewAlert_PlanUpgrade_Confirm_Billing,viewAlert_CVVDigit;

#pragma mark - View Life Cycle
/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Initial setup for the view
 Method Name : viewDidLoad(View Delegate Methods)
 ************************************************************************************* */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self flagSetup_Settings];
//    [self swipeGestureBilling];
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(getUserProfile_Basic_Details) withObject:self];
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
    NSLog(@"gear Type ==%@",self.str_gear_Type);
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSMutableArray *viewStackArr=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSLog(@"Stack count %lu",(unsigned long)[viewStackArr count]);
    NSLog(@"stack List == %@",viewStackArr);

    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
    else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
        NSLog(@"portrait");
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }

    [super viewWillAppear:animated];
    NSLog(@"reloaded");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Email Expression
-(NSString *)emailValidationSettings :(NSString *)strMailString
{
    NSLog(@"email string ==%@",strMailString);
    //    NSString *strEmailVal_status;
    NSString *emailRegEx =@"(?:(?:\\r\\n)?[ \\t])*(?:(?:(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*))*@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*|(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)*\\<(?:(?:\\r\\n)?[ \\t])*(?:@(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*(?:,@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*)*:(?:(?:\\r\\n)?[ \\t])*)?(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*))*@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*\\>(?:(?:\\r\\n)?[ \\t])*)|(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)*:(?:(?:\\r\\n)?[ \\t])*(?:(?:(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*))*@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*|(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)*\\<(?:(?:\\r\\n)?[ \\t])*(?:@(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*(?:,@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*)*:(?:(?:\\r\\n)?[ \\t])*)?(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*))*@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*\\>(?:(?:\\r\\n)?[ \\t])*)(?:,\\s*(?:(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*))*@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*|(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)*\\<(?:(?:\\r\\n)?[ \\t])*(?:@(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*(?:,@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*)*:(?:(?:\\r\\n)?[ \\t])*)?(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\"(?:[^\\\"\\r\\\\]|\\\\.|(?:(?:\\r\\n)?[ \\t]))*\"(?:(?:\\r\\n)?[ \\t])*))*@(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*)(?:\\.(?:(?:\\r\\n)?[ \\t])*(?:[^()<>@,;:\\\\\".\\[\\] \\000-\\031]+(?:(?:(?:\\r\\n)?[ \\t])+|\\Z|(?=[\\[\"()<>@,;:\\\\\".\\[\\]]))|\\[([^\\[\\]\\r\\\\]|\\\\.)*\\](?:(?:\\r\\n)?[ \\t])*))*\\>(?:(?:\\r\\n)?[ \\t])*))*)?;\\s*)";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    //Valid email address
    if ([emailTest evaluateWithObject:strMailString] == YES)
    {
        strEmailVal_status=@"YES";
    }
    else
    {
        strEmailVal_status=@"NO";
    }
    return strEmailVal_status;
}


#pragma mark - Protocol Settings
/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : This method calls the protocol which is triggered when the card is deleted and for reloading the reeceived card list.
 Method Name : processCompleteSettings(User Defined Methods)
 ************************************************************************************* */
- (void)processCompleteSettings
{
//    [[self delegate] processSuccessful_Back_To_NetworkHome:YES];
//    [Common viewFadeIn:self.navigationController.view];
//    [self.navigationController popViewControllerAnimated:NO];
    for (UIViewController *controller in [self.navigationController viewControllers])
    {
        if ([controller isKindOfClass:[SWRevealViewController class]])
        {
            appDelegate.strNoid_BackStatus = @"noid";
            [Common viewFadeIn:self.navigationController.view];
            [self.navigationController popToViewController:controller animated:NO];
            break;
        }
    }
}

#pragma mark - User Defined Methods

/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : initial setup for the setting view.
 Method Name : flagSetup_Settings
 ************************************************************************************* */
-(void)flagSetup_Settings
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
    strOrgTimeZone=@"";
    planExitStatus=@"";
    [settingHistoryView setHidden:YES];
    [settingManageUserView setHidden:YES];
    [settingBillingView setHidden:YES];
    selected_Settings_Tab=@"UserSettings";
    previous_Settings_tab=@"UserSettings";
    [alertView_Billing setHidden:YES];
    [alertView_userManagement setHidden:YES];
    [alertView_info setHidden:YES];
    [self initialSetup_UserSettings];
    strPayment_Selected_Tap=@"VISA";
    strPayment_PreviousTap=@"VISA";

    strEditMode=@"";
    self.viewFooter_UserHistory.hidden=YES;
    strBillingUpdateStatus=@"";
    strHistoryUpdateStatus=@"";
    strHistoryLoadedStatus=@"";
    historyStatus=YES;
    strLatitude=@"";
    strLongitude=@"";
    strBillingLoadedStatus=@"";
    strPlanStatus=@"";
    strCredit_Card_Added_Status=@"";
    self.viewController_PlanOptions.hidden=YES;
    billingHistoryStatus=YES;
    strUserAccountList_LoadedStatus=@"";
    strNetworkLoadedStatus=@"";
    
    UIBezierPath *maskPathPlan = [UIBezierPath bezierPathWithRoundedRect:viewPayment_Alert.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(16.0, 16.0)];
    CAShapeLayer *maskLayerPlan = [[CAShapeLayer alloc] init];
    maskLayerPlan.frame = self.view.bounds;
    maskLayerPlan.path  = maskPathPlan.CGPath;
    viewPayment_Alert.layer.mask = maskLayerPlan;
    arr_Networkid =[[NSMutableArray alloc]init];

    strSelectNWStatus=@"YES";
    user_Acc_View_Mgt.hidden=YES;
    selectNetworkStatus=YES;
    
    self.lblName_UM.hidden=YES;
    self.lblLastName_UM.hidden=YES;
    self.lblEmail_UM.hidden=YES;
    strEmailStatus=@"NO";
    strNameStatus=@"NO";
    strLastNameStatus=@"NO";
    mail_Flag=NO;
    
    self.viewPlanWifi.hidden=YES;
    self.view_PermissionAlert.hidden=YES;
    self.viewAlert_CVVDigit.hidden=YES;
    self.viewAlert_PlanUpgrade_Billing.hidden=YES;
    self.viewAlert_PlanUpgrade_Confirm_Billing.hidden=YES;
    strprorationTime=@"";
    strEmailAddress=@"";
    
    txtfld_digits_UpdateCard.placeholder=@"";
}

/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : initial setup for the user settings view
 Method Name : initialSetup_UserSettings
 ************************************************************************************* */
-(void)initialSetup_UserSettings
{
    [btn_save1_settings setHidden:YES];
    [btn_save2_settings setHidden:YES];
    [btn_edit1_settings setHidden:NO];
    [btn_edit2_settings setHidden:NO];
    [txtfld_email_settings setHidden:YES];
    [txtfld_name_settings setHidden:YES];
    [txtfld_Lname_settings setHidden:YES];
    [lbl_email_settings setHidden:NO];
    [lbl_name_settings setHidden:NO];
    [btn_close1_settings setHidden:YES];
    [btn_close2_settings setHidden:YES];
    
    txtfld_name_settings.delegate=self;
    txtfld_email_settings.delegate=self;
    txtfld_Lname_settings.delegate=self;
    txtfld_name_settings.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_email_settings.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_Lname_settings.clearButtonMode = UITextFieldViewModeWhileEditing;
    [txtfld_name_settings setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_Lname_settings setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_email_settings setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];

    txtfld_email_userManagement.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_Fname_userManagement.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_Lname_userManagement.clearButtonMode = UITextFieldViewModeWhileEditing;

    tempStatus=YES;
    txtfld_Fname_userManagement.delegate=self;
    txtfld_Lname_userManagement.delegate=self;
    txtfld_email_userManagement.delegate=self;
    btn_timeZone_Settings.hidden=NO;
    self.settingHomeView.hidden=YES;
    
    [txtfld_Fname_userManagement setValue:lblRGBA(64, 64, 65, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_Lname_userManagement setValue:lblRGBA(64, 64, 65, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_email_userManagement setValue:lblRGBA(64, 64, 65, 1) forKeyPath:@"_placeholderLabel.textColor"];
}

-(void)userInteraction_Settings_Disabled{
    [btn_Setting_Logo setUserInteractionEnabled:NO];
    [btn_profileName_setting setUserInteractionEnabled:NO];
    [btn_backArrow_setting setUserInteractionEnabled:NO];
    [btn_UserSettings setUserInteractionEnabled:NO];
    [btn_BillingSetting setUserInteractionEnabled:NO];
    [btn_UserManage setUserInteractionEnabled:NO];
    [btn_HistorySetting setUserInteractionEnabled:NO];
    [settingBillingView setUserInteractionEnabled:NO];
}

-(void)updateSettings
{
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(update_UserSettingsNOID) withObject:self];
        
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
}


-(void)checkSettings_Widgets_DismissedOrNot
{
    if ([txtfld_name_settings resignFirstResponder]) {
        [txtfld_name_settings resignFirstResponder];
    }
    else if ([txtfld_Lname_settings resignFirstResponder]) {
        [txtfld_Lname_settings resignFirstResponder];
    }else if ([txtfld_email_settings resignFirstResponder]) {
        [txtfld_email_settings resignFirstResponder];
    }
}

-(void)setUserInteraction_Settings_Enalbed{
    if([strAlert_Type isEqualToString:@"Payment"]){
        if([current_textfield_Billing resignFirstResponder]){
            [current_textfield_Billing resignFirstResponder];
        }
    }
    [self.scrollUpdateCard setContentOffset:CGPointZero animated:YES];
    [self.settingConatinerView removeGestureRecognizer:tapGusters_Container];
    [self.settingTabView removeGestureRecognizer:tapGuster_Tap];
    [self.settingHeaderView removeGestureRecognizer:tapGuster_Header];
    [btn_Setting_Logo setUserInteractionEnabled:YES];
    [btn_profileName_setting setUserInteractionEnabled:YES];
    [settingBillingView setUserInteractionEnabled:YES];
    [btn_backArrow_setting setUserInteractionEnabled:YES];
    [btn_UserSettings setUserInteractionEnabled:YES];
    [btn_BillingSetting setUserInteractionEnabled:YES];
    [btn_UserManage setUserInteractionEnabled:YES];
    [btn_HistorySetting setUserInteractionEnabled:YES];
    
    strAlert_Type=@"";
}


-(void)dismissKeyboard
{
    [current_textfield_Billing resignFirstResponder];
    [current_textfield_Usermanage resignFirstResponder];
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(NSString *)chkWidgetValidation
{
    //NSString *strStatus;
    if(txtfld_name_settings.text.length==0&&txtfld_Lname_settings.text.length==0){
        [Common showAlert:kAlertTitleWarning withMessage:@"Please enter the name fields"];
        return @"NO";
    }else if(txtfld_name_settings.text.length==0){
        [Common showAlert:kAlertTitleWarning withMessage:@"Please enter the first name"];
        return @"NO";
    }
    else if(txtfld_Lname_settings.text.length==0){
        [Common showAlert:kAlertTitleWarning withMessage:@"Please enter the last name"];
        return @"NO";
    }
    else if (txtfld_email_settings.text.length==0){
        [Common showAlert:kAlertTitleWarning withMessage:@"Please enter the email"];
        return @"NO";
    }
    if(![strEmailVal_status isEqualToString:@"YES"]){
        [Common showAlert:kAlertTitleWarning withMessage:@"Please enter the valid email address"];
        return @"NO";
    }
    return @"YES";
}

-(void)PreviousNextButtons_NameField_UserSettings
{
    NSArray *fields = @[txtfld_name_settings,txtfld_Lname_settings];
    [self setKeyboardControls_Billing:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls_Billing setDelegate:self];
}

-(void)PreviousNextButtons_Email_UserSettings
{
    NSArray *fields = @[txtfld_email_settings];
    [self setKeyboardControls_Billing:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls_Billing setDelegate:self];
}

#pragma mark - User Management SetUp

-(void)scrollView_Configuration_UserManagement
{
    bodyViewScroll_UserManage .showsHorizontalScrollIndicator=NO;
    bodyViewScroll_UserManage.showsVerticalScrollIndicator=NO;
    bodyViewScroll_UserManage.scrollEnabled=YES;
    bodyViewScroll_UserManage.userInteractionEnabled=YES;
    bodyViewScroll_UserManage.delegate=self;
    bodyViewScroll_UserManage.scrollsToTop=NO;
}

-(void)userAcc_Network_Datas{
    arrUserNW_Acc = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict_User_Acc_NW=[[NSMutableDictionary alloc] init];
    [dict_User_Acc_NW setObject:@"DENVAR" forKey:kNetworkName];
    [dict_User_Acc_NW setObject:@"network_image1" forKey:kNetWrokImage];
    [dict_User_Acc_NW setObject:@"9234 NORTH" forKey:kNetworkDirection];
    [arrUserNW_Acc addObject:dict_User_Acc_NW];
    
    dict_User_Acc_NW=[[NSMutableDictionary alloc] init];
    [dict_User_Acc_NW setObject:@"DENVAR" forKey:kNetworkName];
    [dict_User_Acc_NW setObject:@"network_image2" forKey:kNetWrokImage];
    [dict_User_Acc_NW setObject:@"9234 EAST" forKey:kNetworkDirection];
    [arrUserNW_Acc addObject:dict_User_Acc_NW];
    
    dict_User_Acc_NW=[[NSMutableDictionary alloc] init];
    [dict_User_Acc_NW setObject:@"DENVAR" forKey:kNetworkName];
    [dict_User_Acc_NW setObject:@"network_image3" forKey:kNetWrokImage];
    [dict_User_Acc_NW setObject:@"9234 SOUTH" forKey:kNetworkDirection];
    [arrUserNW_Acc addObject:dict_User_Acc_NW];
    
    dict_User_Acc_NW=[[NSMutableDictionary alloc] init];
    [dict_User_Acc_NW setObject:@"DENVAR" forKey:kNetworkName];
    [dict_User_Acc_NW setObject:@"network_image4" forKey:kNetWrokImage];
    [dict_User_Acc_NW setObject:@"9234 NORTH" forKey:kNetworkDirection];
    [arrUserNW_Acc addObject:dict_User_Acc_NW];
    
    dict_User_Acc_NW=[[NSMutableDictionary alloc] init];
    [dict_User_Acc_NW setObject:@"DENVAR" forKey:kNetworkName];
    [dict_User_Acc_NW setObject:@"network_image5" forKey:kNetWrokImage];
    [dict_User_Acc_NW setObject:@"9234 EAST" forKey:kNetworkDirection];
    [arrUserNW_Acc addObject:dict_User_Acc_NW];
    
    dict_User_Acc_NW=[[NSMutableDictionary alloc] init];
    [dict_User_Acc_NW setObject:@"DENVAR" forKey:kNetworkName];
    [dict_User_Acc_NW setObject:@"network_image6" forKey:kNetWrokImage];
    [dict_User_Acc_NW setObject:@"9234 WEST" forKey:kNetworkDirection];
    [arrUserNW_Acc addObject:dict_User_Acc_NW];
}

-(void)userManagementSetup{
    self.scrollView_UserManage.delegate=self;
    self.scrollView_UserManage.userInteractionEnabled=YES;
    self.scrollView_UserManage.showsVerticalScrollIndicator=YES;
    self.scrollView_UserManage.showsHorizontalScrollIndicator=YES;
    
    float x_nw=10,y_nw=0,w_nw=0,h_nw=0;
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        w_nw=88,h_nw=91;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        w_nw=110,h_nw=120;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        w_nw=100,h_nw=105;
    }
    for(int index=0;index<[arr_NetworkList count];index++){
        
        lbl_AccessType[index] = [[UILabel alloc] initWithFrame:CGRectMake(x_nw, y_nw, w_nw, 21)];
        lbl_AccessType[index].textColor = [UIColor whiteColor];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lbl_AccessType[index].font = [UIFont fontWithName:@"NexaBold" size:8.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lbl_AccessType[index].font = [UIFont fontWithName:@"NexaBold" size:11.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lbl_AccessType[index].font = [UIFont fontWithName:@"NexaBold" size:10.0];
        }
        lbl_AccessType[index].textAlignment = NSTextAlignmentCenter;
        [scrollView_UserManage addSubview:lbl_AccessType[index]];

        
        UIView *network_View=[[UIView alloc] initWithFrame:CGRectMake(x_nw, lbl_AccessType[index].frame.origin.y+lbl_AccessType[index].frame.size.height+2, w_nw, h_nw)];
        network_View.backgroundColor=[UIColor clearColor];
        [scrollView_UserManage addSubview:network_View];
        
        imgV_NW_User_Acc[index]=[[UIImageView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            imgV_NW_User_Acc[index].frame = CGRectMake(0, 0, 88, 61);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            imgV_NW_User_Acc[index].frame = CGRectMake(0, 0, 110, 80);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            imgV_NW_User_Acc[index].frame = CGRectMake(0, 0, 100, 70);
        }
        //        imgV_NW_User_Acc.image=[UIImage imageNamed:[[arrUserNW_Acc objectAtIndex:index] valueForKey:kNetWrokImage]];
        if([[[arr_NetworkList objectAtIndex:index] objectForKey:@"thumbnailImage"] isEqualToString:@""]){
            dispatch_async(kBgQueue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgV_NW_User_Acc[index].image = [UIImage imageNamed:@"noNetworkImage"];
                });
            });
        }else{
            dispatch_async(kBgQueue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgV_NW_User_Acc[index].image = [UIImage imageWithData:[Base64 decode:[[arr_NetworkList objectAtIndex:index] objectForKey:@"thumbnailImage"]]];
                });
            });
        }
        [network_View addSubview:imgV_NW_User_Acc[index]];
        //bgCameraImagei6plus
        btn_Chk_Network_AddUser[index]=[UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Chk_Network_AddUser[index].frame=CGRectMake(64, 3, 22, 22);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Chk_Network_AddUser[index].frame=CGRectMake(71, 0, 40, 40);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            btn_Chk_Network_AddUser[index].frame=CGRectMake(66, 0, 35, 35);
        }
        [btn_Chk_Network_AddUser[index] setImage:[UIImage imageNamed:@"checkBox_UserManagei6plus"] forState:UIControlStateNormal];
        btn_Chk_Network_AddUser[index].tag=index;
        [network_View addSubview:btn_Chk_Network_AddUser[index]];
        
        UIView *network_View_Footer=[[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            network_View_Footer.frame = CGRectMake(0, 61, 88, 30);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            network_View_Footer.frame = CGRectMake(0, 80, 110, 40);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            network_View_Footer.frame = CGRectMake(0, 70, 100, 30);
        }
        network_View_Footer.backgroundColor=lblRGBA(77, 77, 79, 1);
        [network_View addSubview:network_View_Footer];
        
//        UILabel *lbl_Nw_Direction = [[UILabel alloc] init];
//        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//            lbl_Nw_Direction.frame = CGRectMake(0, 5, 88, 15);
//            lbl_Nw_Direction.font = [UIFont fontWithName:@"NexaBold" size:11.0];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//            lbl_Nw_Direction.frame = CGRectMake(0, 6, 110, 19);
//            lbl_Nw_Direction.font = [UIFont fontWithName:@"NexaBold" size:13.0];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
//            lbl_Nw_Direction.frame = CGRectMake(0, 2, 100, 22);
//            lbl_Nw_Direction.font = [UIFont fontWithName:@"NexaBold" size:12.0];
//        }
//        lbl_Nw_Direction.text = @"9234 NORTH";
//        lbl_Nw_Direction.textColor = lblRGBA(255, 255, 255, 1);
//        lbl_Nw_Direction.textAlignment=NSTextAlignmentCenter;
//        [network_View_Footer addSubview:lbl_Nw_Direction];
        
//        lbl_Nw_Name[index]= [[UILabel alloc] init];
//        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//            lbl_Nw_Name[index].frame = CGRectMake(0, 15, 88, 15);
//            lbl_Nw_Name[index].font = [UIFont fontWithName:@"NexaBold" size:8.0];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//            lbl_Nw_Name[index].frame = CGRectMake(0, 19, 110, 19);
//            lbl_Nw_Name[index].font = [UIFont fontWithName:@"NexaBold" size:10.0];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
//            lbl_Nw_Name[index].frame = CGRectMake(0, 13, 100, 22);
//            lbl_Nw_Name[index].font = [UIFont fontWithName:@"NexaBold" size:9.0];
//        }
//        lbl_Nw_Name[index].textColor = lblRGBA(40, 165, 222, 1);
//        lbl_Nw_Name[index].text = [[arr_NetworkList objectAtIndex:index] objectForKey:@"name"];
//        lbl_Nw_Name[index].textAlignment=NSTextAlignmentCenter;
//        [network_View_Footer addSubview:lbl_Nw_Name[index]];
        
        lbl_Nw_Name[index]= [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lbl_Nw_Name[index].frame = CGRectMake(0, 0, 88, 30);
            lbl_Nw_Name[index].font = [UIFont fontWithName:@"NexaBold" size:11.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lbl_Nw_Name[index].frame = CGRectMake(0, 0, 110, 40);
            lbl_Nw_Name[index].font = [UIFont fontWithName:@"NexaBold" size:13.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lbl_Nw_Name[index].frame = CGRectMake(0, 0, 100, 30);
            lbl_Nw_Name[index].font = [UIFont fontWithName:@"NexaBold" size:12.0];
        }
        lbl_Nw_Name[index].textColor = lblRGBA(255, 255, 255, 1);
        lbl_Nw_Name[index].text = [[arr_NetworkList objectAtIndex:index] objectForKey:@"name"];
        lbl_Nw_Name[index].textAlignment=NSTextAlignmentCenter;
        lbl_Nw_Name[index].numberOfLines=2;
        [network_View_Footer addSubview:lbl_Nw_Name[index]];

        UIButton *btnNW_AddUser=[UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btnNW_AddUser.frame=CGRectMake(0, 0, 88, 61);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btnNW_AddUser.frame=CGRectMake(0, 0, 110, 80);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            btnNW_AddUser.frame=CGRectMake(0, 0, 100, 70);
        }
        btnNW_AddUser.tag=index;
        [btnNW_AddUser addTarget:self action:@selector(change_Add_NW_Status_SubNetwork:) forControlEvents:UIControlEventTouchUpInside];
        [network_View addSubview:btnNW_AddUser];

        x_nw=network_View.frame.origin.x+network_View.frame.size.width+3;
    }
    
    scrollView_UserManage.contentSize=CGSizeMake(x_nw, scrollView_UserManage.frame.size.height);
//    [self selectNetwork_Enable_Disable];
    [self stop_PinWheel_UserSettings];
}


-(void)loadUserAccountDatas{
    @try {
        scrollView_UserManage.userInteractionEnabled=YES;
        scrollView_UserManage.delegate=self;
        
        float y_acc=0.0,x_acc=0,h_acc=0;
        
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            h_acc=22;
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            h_acc=44;
        }else{
            h_acc=34;
        }
        
        for(int alertIndex=0;alertIndex<[arrUserManagement count];alertIndex++){
            NSLog(@"array value is ==%@",arrUserManagement);
            NSLog(@"array value is indi ==%@",[arrUserManagement objectAtIndex:alertIndex]);
            menu_User_Acc[alertIndex]=[[UIView alloc] init];
            menu_User_Acc[alertIndex].frame=CGRectMake(x_acc, y_acc, self.settingManageUserView.frame.size.width,h_acc);
            menu_User_Acc[alertIndex].backgroundColor=lblRGBA(99, 100, 102, 1);
            menu_User_Acc[alertIndex].tag=alertIndex;
            [scroll_UserMgt_UserAcc addSubview:menu_User_Acc[alertIndex]];
            
            menu_User_Acc_TapView[alertIndex] = [[UIView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                menu_User_Acc_TapView[alertIndex].frame = CGRectMake(0, 0, menu_User_Acc[alertIndex].frame.size.width, 22);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                menu_User_Acc_TapView[alertIndex].frame = CGRectMake(0, 0, menu_User_Acc[alertIndex].frame.size.width, 44);
            }else{
                menu_User_Acc_TapView[alertIndex].frame = CGRectMake(0, 0, menu_User_Acc[alertIndex].frame.size.width, 34);
            }
            menu_User_Acc_TapView[alertIndex].backgroundColor=[UIColor clearColor];
            menu_User_Acc_TapView[alertIndex].tag=alertIndex;
            [menu_User_Acc[alertIndex] addSubview:menu_User_Acc_TapView[alertIndex]];

            UITapGestureRecognizer *tapGestureView_Acc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandUserAcc_View_onClick:)];
            [menu_User_Acc_TapView[alertIndex] addGestureRecognizer:tapGestureView_Acc];
            [menu_User_Acc_TapView[alertIndex] setExclusiveTouch:YES];
            
            
            lblAcc_Name[alertIndex] = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblAcc_Name[alertIndex].frame=CGRectMake(21, 0, 105, 22);
                [lblAcc_Name[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:10]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblAcc_Name[alertIndex].frame=CGRectMake(21, 0, 150, 44);
                [lblAcc_Name[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
            }else{
                lblAcc_Name[alertIndex].frame=CGRectMake(21, 0, 130, 34);
                [lblAcc_Name[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }
            [lblAcc_Name[alertIndex] setTextColor:lblRGBA(255,255,255, 1)];
            lblAcc_Name[alertIndex].text = [[arrUserManagement objectAtIndex:alertIndex] valueForKey:kAccountName];
            [menu_User_Acc[alertIndex] addSubview:lblAcc_Name[alertIndex]];
            
            lblAcc_LName[alertIndex] = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblAcc_LName[alertIndex].frame=CGRectMake(136, 0, 105, 22);
                [lblAcc_LName[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:10]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblAcc_LName[alertIndex].frame=CGRectMake(181, 0, 150, 44);
                [lblAcc_LName[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
            }else{
                lblAcc_LName[alertIndex].frame=CGRectMake(161, 0, 130, 34);
                [lblAcc_LName[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }
            
            [lblAcc_LName[alertIndex] setTextColor:lblRGBA(255,255,255, 1)];
            lblAcc_LName[alertIndex].text = [[arrUserManagement objectAtIndex:alertIndex] valueForKey:kAccountLastName];
            [menu_User_Acc[alertIndex] addSubview:lblAcc_LName[alertIndex]];

            
            txt_AccName[alertIndex] = [[UITextField alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                txt_AccName[alertIndex].frame=CGRectMake(21, 0, 105, 22);
                [txt_AccName[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:10]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                txt_AccName[alertIndex].frame=CGRectMake(21, 0, 150, 44);
                [txt_AccName[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
            }else{
                txt_AccName[alertIndex].frame=CGRectMake(21, 0, 130, 34);
                [txt_AccName[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }
            [txt_AccName[alertIndex] setTextColor:lblRGBA(255,255,255, 1)];
            txt_AccName[alertIndex].placeholder = @"FIRST NAME";
            [txt_AccName[alertIndex] setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
            txt_AccName[alertIndex].clearButtonMode = UITextFieldViewModeWhileEditing;
            txt_AccName[alertIndex].autocapitalizationType = UITextAutocapitalizationTypeWords;
            txt_AccName[alertIndex].text =[[arrUserManagement objectAtIndex:alertIndex] valueForKey:kAccountName];
            [menu_User_Acc[alertIndex] addSubview:txt_AccName[alertIndex]];
            txt_AccName[alertIndex].delegate=self;
            txt_AccName[alertIndex].tag=alertIndex;
            [txt_AccName[alertIndex] setHidden:YES];
            
            txt_AccLName[alertIndex] = [[UITextField alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                txt_AccLName[alertIndex].frame=CGRectMake(136, 0, 105, 22);
                [txt_AccLName[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:10]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                txt_AccLName[alertIndex].frame=CGRectMake(181, 0, 150, 44);
                [txt_AccLName[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
            }else{
                txt_AccLName[alertIndex].frame=CGRectMake(161, 0, 130, 34);
                [txt_AccLName[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }
            [txt_AccLName[alertIndex] setTextColor:lblRGBA(255,255,255, 1)];
            txt_AccLName[alertIndex].placeholder = @"LAST NAME";
            [txt_AccLName[alertIndex] setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
            txt_AccLName[alertIndex].clearButtonMode = UITextFieldViewModeWhileEditing;
            txt_AccLName[alertIndex].autocapitalizationType = UITextAutocapitalizationTypeWords;
            txt_AccLName[alertIndex].text =[[arrUserManagement objectAtIndex:alertIndex] valueForKey:kAccountLastName];
            [menu_User_Acc[alertIndex] addSubview:txt_AccLName[alertIndex]];
            txt_AccLName[alertIndex].delegate=self;
            txt_AccLName[alertIndex].tag=alertIndex;
            [txt_AccLName[alertIndex] setHidden:YES];

//            lblChangeSchedule[alertIndex] = [[UILabel alloc] init];
//            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                lblChangeSchedule[alertIndex].frame=CGRectMake(141, 0, 114, 22);
//                [lblChangeSchedule[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:9]];
//            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                lblChangeSchedule[alertIndex].frame=CGRectMake(200, 0, 136, 44);
//                [lblChangeSchedule[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:11]];
//            }else{
//                lblChangeSchedule[alertIndex].frame=CGRectMake(175, 0, 122, 34);
//                [lblChangeSchedule[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:10]];
//            }
//            [lblChangeSchedule[alertIndex] setTextColor:lblRGBA(255,255,255, 1)];
//            lblChangeSchedule[alertIndex].text =[NSString stringWithFormat:@"%@",[[arrUserManagement objectAtIndex:alertIndex] valueForKey:kAccountPermission]];
//            lblChangeSchedule[alertIndex].backgroundColor=lblRGBA(184, 184, 184, 1);
//            lblChangeSchedule[alertIndex].textAlignment=NSTextAlignmentCenter;
//            [menu_User_Acc[alertIndex] addSubview:lblChangeSchedule[alertIndex]];
            
            btn_Save_AccName[alertIndex] = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btn_Save_AccName[alertIndex].frame=CGRectMake(242, 0, 47, 22);
                btn_Save_AccName[alertIndex].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:11.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btn_Save_AccName[alertIndex].frame=CGRectMake(321, 0, 47, 44);
                btn_Save_AccName[alertIndex].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:13.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                btn_Save_AccName[alertIndex].frame=CGRectMake(283, 0, 47, 34);
                btn_Save_AccName[alertIndex].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:12.0];
            }
            [btn_Save_AccName[alertIndex] setTitle:@"SAVE"  forState:UIControlStateNormal];
            [btn_Save_AccName[alertIndex] setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
            [btn_Save_AccName[alertIndex] addTarget:self action:@selector(save_AccName_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            [btn_Save_AccName[alertIndex] setTag:alertIndex];
            [btn_Save_AccName[alertIndex] setHidden:YES];
            [menu_User_Acc[alertIndex] addSubview:btn_Save_AccName[alertIndex]];
                        
            btn_close_UserAcc[alertIndex] = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btn_close_UserAcc[alertIndex].frame=CGRectMake(286, -2, 26, 26);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btn_close_UserAcc[alertIndex].frame=CGRectMake(376, 2, 41, 41);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                btn_close_UserAcc[alertIndex].frame=CGRectMake(337, 0, 34, 34);
            }
//            [btn_close_UserAcc[alertIndex] setImage:[UIImage imageNamed:@"WhiteCloseImagei6plus"] forState:UIControlStateNormal];
            [btn_close_UserAcc[alertIndex] setImage:[UIImage imageNamed:@"PopupClose"] forState:UIControlStateNormal];
            [btn_close_UserAcc[alertIndex] addTarget:self action:@selector(close_UserAcc_Acion:) forControlEvents:UIControlEventTouchUpInside];
            [btn_close_UserAcc[alertIndex] setTag:alertIndex];
            [btn_close_UserAcc[alertIndex] setHidden:YES];
            [menu_User_Acc[alertIndex] addSubview:btn_close_UserAcc[alertIndex]];

            viewEdit_UserAcc_Billing[alertIndex] = [[UIView alloc] init];
            viewEdit_UserAcc_Billing[alertIndex].frame=CGRectMake(700, 0, 48, 60);
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                viewEdit_UserAcc_Billing[alertIndex].frame=CGRectMake(278, 0, 30, 22);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                viewEdit_UserAcc_Billing[alertIndex].frame=CGRectMake(351, 0, 50, 44);
            }else{
                viewEdit_UserAcc_Billing[alertIndex].frame=CGRectMake(326, 0, 40, 34);
            }
            viewEdit_UserAcc_Billing[alertIndex].backgroundColor =lblRGBA(124, 124, 123, 1);
            viewEdit_UserAcc_Billing[alertIndex].tag=alertIndex;
            viewEdit_UserAcc_Billing[alertIndex].userInteractionEnabled=NO;
            viewEdit_UserAcc_Billing[alertIndex].hidden=YES;
            [menu_User_Acc[alertIndex] addSubview:viewEdit_UserAcc_Billing[alertIndex]];
            
            
            btnEdit_UserAcc[alertIndex]=[UIButton buttonWithType:UIButtonTypeCustom];
            [btnEdit_UserAcc[alertIndex] setImage:[UIImage imageNamed:@"yellowEditImagei6plus"] forState:UIControlStateNormal];
            [btnEdit_UserAcc[alertIndex] addTarget:self action:@selector(edit_UserAcc_Action:) forControlEvents:UIControlEventTouchUpInside];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btnEdit_UserAcc[alertIndex].frame = CGRectMake(-3,-9,36, 40);//130
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btnEdit_UserAcc[alertIndex].frame = CGRectMake(-2,-13,55, 70);//130
            }else{
                btnEdit_UserAcc[alertIndex].frame = CGRectMake(0,-6,40, 45);//130
            }
            btnEdit_UserAcc[alertIndex].tag=alertIndex;
            [viewEdit_UserAcc_Billing[alertIndex] addSubview:btnEdit_UserAcc[alertIndex]];
            
            y_acc=menu_User_Acc[alertIndex].frame.size.height+menu_User_Acc[alertIndex].frame.origin.y+5;
        }
        self.scroll_UserMgt_UserAcc.frame=CGRectMake(self.scroll_UserMgt_UserAcc.frame.origin.x, self.scroll_UserMgt_UserAcc.frame.origin.y, self.scroll_UserMgt_UserAcc.frame.size.width, y_acc);
        self.user_Acc_View_Mgt.frame=CGRectMake(self.user_Acc_View_Mgt.frame.origin.x, self.user_Acc_View_Mgt.frame.origin.y, self.user_Acc_View_Mgt.frame.size.width, self.scroll_UserMgt_UserAcc.frame.origin.y+self.scroll_UserMgt_UserAcc.frame.size.height);
        self.bodyViewScroll_UserManage.contentSize=CGSizeMake(self.bodyViewScroll_UserManage.frame.size.width, self.user_Acc_View_Mgt.frame.origin.y+self.user_Acc_View_Mgt.frame.size.height);
        user_Acc_View_Mgt.hidden=NO;
        [self stop_PinWheel_UserSettings];
    }
    
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
        [self stop_PinWheel_UserSettings];
    }
}

-(void)userAcc_AddWidget_Network:(int)tag{
    dictUserAcc_Content=[arrUserManagement objectAtIndex:tag];
    NSLog(@"dict==%@",dictUserAcc_Content);
    @try {
        frame_Org_Size_UserAcc_Content=view_User_Acc_Contentview[tag].frame;
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_User_Acc_Contentview[tag]=[[UIView alloc] initWithFrame:CGRectMake(0, 22, self.view.frame.size.width, 229)];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_User_Acc_Contentview[tag]=[[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 280)];
        }else{
            view_User_Acc_Contentview[tag]=[[UIView alloc] initWithFrame:CGRectMake(0, 34, self.view.frame.size.width, 260)];
        }

        view_User_Acc_Contentview[tag].backgroundColor=lblRGBA(65, 64, 66, 1);
        view_User_Acc_Contentview[tag].hidden=YES;
        [menu_User_Acc[tag] addSubview:view_User_Acc_Contentview[tag]];

        view_Acc_AddNwtwork=[[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_Acc_AddNwtwork.frame=CGRectMake(0, 0, self.view.frame.size.width, 220);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_Acc_AddNwtwork.frame=CGRectMake(0, 0, self.view.frame.size.width, 280);
        }else{
            view_Acc_AddNwtwork.frame=CGRectMake(0, 0, self.view.frame.size.width, 250);
        }
        
        view_Acc_AddNwtwork.backgroundColor=lblRGBA(65, 64, 66, 1);
        [view_User_Acc_Contentview[tag] addSubview:view_Acc_AddNwtwork];
        
        UILabel *lblAddNW = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblAddNW.frame =CGRectMake(21, 2, 125, 21);
            lblAddNW.font = [UIFont fontWithName:@"NexaBold" size:10];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblAddNW.frame =CGRectMake(21, 0, 152, 30);
            lblAddNW.font = [UIFont fontWithName:@"NexaBold" size:12];
        }else{
            lblAddNW.frame =CGRectMake(21, 10, 130, 21);
            lblAddNW.font = [UIFont fontWithName:@"NexaBold" size:11];
        }
        lblAddNW.text = @"SELECT PROPERTIES";
        lblAddNW.textColor = lblRGBA(255, 255, 255, 1);
        [view_Acc_AddNwtwork addSubview:lblAddNW];
        
        UIScrollView *scroll_User_Acc_AddNW=[[UIScrollView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            scroll_User_Acc_AddNW.frame=CGRectMake(0, 25, 320, 112);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            scroll_User_Acc_AddNW.frame=CGRectMake(0, 30, 414, 141);
        }else{
            scroll_User_Acc_AddNW.frame=CGRectMake(0, 37, 375, 126);
        }
        scroll_User_Acc_AddNW.delegate=self;
        scroll_User_Acc_AddNW.userInteractionEnabled=YES;
        scroll_User_Acc_AddNW.showsHorizontalScrollIndicator=YES;
        [view_Acc_AddNwtwork addSubview:scroll_User_Acc_AddNW];
        
        
        float x_nw=10,y_nw=0,w_nw=0,h_nw=0;
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            w_nw=88,h_nw=91;
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            w_nw=110,h_nw=120;
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            w_nw=100,h_nw=105;
        }
        for(int index=0;index<[arr_NetworkList count];index++){
            
            lbl_UserAcc_AccessType[index] = [[UILabel alloc] initWithFrame:CGRectMake(x_nw, y_nw, w_nw, 21)];
            lbl_UserAcc_AccessType[index].textColor = [UIColor whiteColor];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lbl_UserAcc_AccessType[index].font = [UIFont fontWithName:@"NexaBold" size:8.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lbl_UserAcc_AccessType[index].font = [UIFont fontWithName:@"NexaBold" size:11.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lbl_UserAcc_AccessType[index].font = [UIFont fontWithName:@"NexaBold" size:10.0];
            }
            lbl_UserAcc_AccessType[index].textAlignment = NSTextAlignmentCenter;
            [scroll_User_Acc_AddNW addSubview:lbl_UserAcc_AccessType[index]];

            UIView *network_View=[[UIView alloc] initWithFrame:CGRectMake(x_nw, lbl_UserAcc_AccessType[index].frame.origin.y+lbl_UserAcc_AccessType[index].frame.size.height+2, w_nw, h_nw)];
            network_View.backgroundColor=[UIColor clearColor];
            [scroll_User_Acc_AddNW addSubview:network_View];
            
            imgV_NW_User_Acc_List[index]=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 205, 145)];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgV_NW_User_Acc_List[index].frame = CGRectMake(0, 0, 88, 61);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgV_NW_User_Acc_List[index].frame = CGRectMake(0, 0, 110, 80);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgV_NW_User_Acc_List[index].frame = CGRectMake(0, 0, 100, 70);
            }
            if([[[arr_NetworkList objectAtIndex:index] objectForKey:@"thumbnailImage"] isEqualToString:@""]){
                dispatch_async(kBgQueue, ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imgV_NW_User_Acc_List[index].image = [UIImage imageNamed:@"noNetworkImage"];
                    });
                });
            }else{
                dispatch_async(kBgQueue, ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imgV_NW_User_Acc_List[index].image = [UIImage imageWithData:[Base64 decode:[[arr_NetworkList objectAtIndex:index] objectForKey:@"thumbnailImage"]]];
                    });
                });
            }
            
            [network_View addSubview:imgV_NW_User_Acc_List[index]];
            
            lbl_UserAcc_AccessType[index].text =@"";

            btn_Chk_Network_UserAcc[index]=[UIButton buttonWithType:UIButtonTypeCustom];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btn_Chk_Network_UserAcc[index].frame=CGRectMake(64, 3, 22, 22);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btn_Chk_Network_UserAcc[index].frame=CGRectMake(71, 0, 40, 40);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                btn_Chk_Network_UserAcc[index].frame=CGRectMake(66, 0, 35, 35);
            }
            [btn_Chk_Network_UserAcc[index] setImage:[UIImage imageNamed:@"checkBox_UserManagei6plus"] forState:UIControlStateNormal];

            NSLog(@"index id ==%@",[[[arr_NetworkList objectAtIndex:index] valueForKey:@"id"] stringValue]);
            // NSLog(@"selected id's =%@",arrUserSelectedNetworksIDS);
            for(int tagIndex=0;tagIndex<[arrUserSelectedIDS count];tagIndex++)
            {
                NSLog(@" slected index networkid ==%@",[[arrUserSelectedIDS objectAtIndex:tagIndex] valueForKey:kNetworkID]);
                if([[[arrUserSelectedIDS objectAtIndex:tagIndex] valueForKey:kNetworkID] isEqualToString:[[[arr_NetworkList objectAtIndex:index] valueForKey:@"id"] stringValue]])
                {
                    [btn_Chk_Network_UserAcc[index] setImage:[UIImage imageNamed:@"bgYellowTickImagei6plus"] forState:UIControlStateNormal];
                    if ([[[arrUserSelectedIDS objectAtIndex:tagIndex] valueForKey:kaccesstypeID] isEqualToString:@"1"]) {
                        lbl_UserAcc_AccessType[index].text = @"FULL ACCESS";
                    }else if ([[[arrUserSelectedIDS objectAtIndex:tagIndex] valueForKey:kaccesstypeID] isEqualToString:@"2"]){
                        lbl_UserAcc_AccessType[index].text = @"VIEW ONLY";
                    }else if([[[arrUserSelectedIDS objectAtIndex:tagIndex] valueForKey:kaccesstypeID] isEqualToString:@"3"]){
                        lbl_UserAcc_AccessType[index].text = @"CHANGE SCHEDULE";
                    }
//                    else if([[[arrUserSelectedIDS objectAtIndex:tagIndex] valueForKey:kaccesstypeID] isEqualToString:@"5"]){
//                        lbl_UserAcc_AccessType[index].text = @"NONE";
//                    }

                    if (![[[arrUserSelectedIDS objectAtIndex:tagIndex] valueForKey:kAccountPermissionID] isEqualToString:@"2"]) {
                        network_View.alpha=0.4;
                        lbl_UserAcc_AccessType[index].alpha=0.4;
                        // btn_UserAcc_AddNW[index].userInteractionEnabled=NO;
                    }
                    NSMutableDictionary *dictNewVal=[[NSMutableDictionary alloc] init];
                    [dictNewVal setObject:[[arrUserSelectedIDS objectAtIndex:tagIndex] valueForKey:kNetworkID] forKey:kNetworkID];
                    [dictNewVal setObject:[[arrUserSelectedIDS objectAtIndex:tagIndex] valueForKey:kaccesstypeID] forKey:kaccesstypeID];
                    [arr_NetworkUserID addObject:dictNewVal];
                    tagIndex=tagIndex+(int)arrUserSelectedIDS.count;
                }/*
                  

                  */
            }
            NSLog(@"after assing%@",arr_NetworkUserID);
            btn_Chk_Network_UserAcc[index].tag=index;
            [network_View addSubview:btn_Chk_Network_UserAcc[index]];
            
            UIView *network_View_Footer=[[UIView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                network_View_Footer.frame = CGRectMake(0, 61, 88, 30);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                network_View_Footer.frame = CGRectMake(0, 80, 110, 40);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                network_View_Footer.frame = CGRectMake(0, 70, 100, 30);
            }
            network_View_Footer.backgroundColor=lblRGBA(77, 77, 79, 1);
            [network_View addSubview:network_View_Footer];
            
//            UILabel *lbl_Nw_Direction = [[UILabel alloc] init];
//            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                lbl_Nw_Direction.frame = CGRectMake(0, 5, 88, 15);
//                lbl_Nw_Direction.font = [UIFont fontWithName:@"NexaBold" size:11.0];
//            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                lbl_Nw_Direction.frame = CGRectMake(0, 6, 110, 19);
//                lbl_Nw_Direction.font = [UIFont fontWithName:@"NexaBold" size:13.0];
//            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
//                lbl_Nw_Direction.frame = CGRectMake(0, 2, 100, 22);
//                lbl_Nw_Direction.font = [UIFont fontWithName:@"NexaBold" size:12.0];
//            }
//            lbl_Nw_Direction.text = @"9234 NORTH";
//            lbl_Nw_Direction.textColor = lblRGBA(255, 255, 255, 1);
//            lbl_Nw_Direction.textAlignment=NSTextAlignmentCenter;
//            [network_View_Footer addSubview:lbl_Nw_Direction];
            
//            UILabel *lbl_Nw_Name_List= [[UILabel alloc] init];
//            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                lbl_Nw_Name_List.frame = CGRectMake(0, 15, 88, 15);
//                lbl_Nw_Name_List.font = [UIFont fontWithName:@"NexaBold" size:8.0];
//            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                lbl_Nw_Name_List.frame = CGRectMake(0, 19, 110, 19);
//                lbl_Nw_Name_List.font = [UIFont fontWithName:@"NexaBold" size:10.0];
//            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
//                lbl_Nw_Name_List.frame = CGRectMake(0, 13, 100, 22);
//                lbl_Nw_Name_List.font = [UIFont fontWithName:@"NexaBold" size:9.0];
//            }
//            lbl_Nw_Name_List.text = [[arr_NetworkList objectAtIndex:index] objectForKey:@"name"];
//            lbl_Nw_Name_List.textColor = lblRGBA(40, 165, 222, 1);
//            lbl_Nw_Name_List.textAlignment=NSTextAlignmentCenter;
//            [network_View_Footer addSubview:lbl_Nw_Name_List];
            
            UILabel *lbl_Nw_Name_List= [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lbl_Nw_Name_List.frame = CGRectMake(0, 0, 88, 30);
                lbl_Nw_Name_List.font = [UIFont fontWithName:@"NexaBold" size:11.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lbl_Nw_Name_List.frame = CGRectMake(0, 0, 110, 40);
                lbl_Nw_Name_List.font = [UIFont fontWithName:@"NexaBold" size:13.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lbl_Nw_Name_List.frame = CGRectMake(0, 0, 100, 30);
                lbl_Nw_Name_List.font = [UIFont fontWithName:@"NexaBold" size:12.0];
            }
            lbl_Nw_Name_List.text = [[arr_NetworkList objectAtIndex:index] objectForKey:@"name"];
            lbl_Nw_Name_List.textColor = lblRGBA(255, 255, 255, 1);
            lbl_Nw_Name_List.textAlignment=NSTextAlignmentCenter;
            lbl_Nw_Name_List.numberOfLines=2;
            [network_View_Footer addSubview:lbl_Nw_Name_List];

            btn_UserAcc_AddNW[index]=[UIButton buttonWithType:UIButtonTypeCustom];
            btn_UserAcc_AddNW[index].frame=CGRectMake(0, 0, 205, 215);
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btn_UserAcc_AddNW[index].frame=CGRectMake(0, 0, 88, 61);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btn_UserAcc_AddNW[index].frame=CGRectMake(0, 0, 110, 80);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                btn_UserAcc_AddNW[index].frame=CGRectMake(0, 0, 100, 70);
            }
            btn_UserAcc_AddNW[index].tag=index;
            [btn_UserAcc_AddNW[index] addTarget:self action:@selector(change_Add_NW_Status:) forControlEvents:UIControlEventTouchUpInside];
            [network_View addSubview:btn_UserAcc_AddNW[index]];
            
            x_nw=network_View.frame.origin.x+network_View.frame.size.width+3;
        }
        
        scroll_User_Acc_AddNW.contentSize=CGSizeMake(x_nw, scroll_User_Acc_AddNW.frame.size.height);
        
        //Delete User
        UIView *view_Delete_NW=[[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_Delete_NW.frame = CGRectMake(21,scroll_User_Acc_AddNW.frame.origin.y+scroll_User_Acc_AddNW.frame.size.height+10,134, 64);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_Delete_NW.frame = CGRectMake(27,scroll_User_Acc_AddNW.frame.origin.y+scroll_User_Acc_AddNW.frame.size.height+10,174, 83);
        }else{
            view_Delete_NW.frame = CGRectMake(24,scroll_User_Acc_AddNW.frame.origin.y+scroll_User_Acc_AddNW.frame.size.height+10,157, 75);
        }
        view_Delete_NW.backgroundColor=lblRGBA(211,7, 25, 1);
        [view_Acc_AddNwtwork addSubview:view_Delete_NW];
        
        UIImageView *closeImgDel=[[UIImageView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            closeImgDel.frame = CGRectMake(52,8,24, 24);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            closeImgDel.frame = CGRectMake(66,8,40, 40);
        }else{
            closeImgDel.frame = CGRectMake(63,8,30, 30);
        }
        closeImgDel.image=[UIImage imageNamed:@"cancelImagei6plus"];
        [view_Delete_NW addSubview:closeImgDel];
        
        
        UILabel *lbl_Delete_NW=[[UILabel alloc] initWithFrame:CGRectMake(0, 105, 311, 21)];
        lbl_Delete_NW.text = @"DELETE USER";
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lbl_Delete_NW.frame = CGRectMake(0,40,134, 15);
            lbl_Delete_NW.font = [UIFont fontWithName:@"NexaBold" size:12];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lbl_Delete_NW.frame = CGRectMake(0,60,174, 15);
            lbl_Delete_NW.font = [UIFont fontWithName:@"NexaBold" size:14];
        }else{
            lbl_Delete_NW.frame = CGRectMake(0,49,157, 15);
            lbl_Delete_NW.font = [UIFont fontWithName:@"NexaBold" size:13];
        }
        lbl_Delete_NW.textColor = lblRGBA(255, 255, 255, 1);
        lbl_Delete_NW.textAlignment=NSTextAlignmentCenter;
        [view_Delete_NW addSubview:lbl_Delete_NW];
        
        UIButton *btn_Delete_NW=[UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Delete_NW.frame = CGRectMake(0,0,134, 64);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Delete_NW.frame = CGRectMake(0,0,174, 83);
        }else{
            btn_Delete_NW.frame = CGRectMake(0,0,157, 75);
        }
        btn_Delete_NW.tag=tag;
        [btn_Delete_NW addTarget:self action:@selector(userMGT_DeleteUser_Action:) forControlEvents:UIControlEventTouchUpInside];
        [view_Delete_NW addSubview:btn_Delete_NW];
        
        //Save Changes View
        UIView *save_Change_NW_UserAcc=[[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            save_Change_NW_UserAcc.frame = CGRectMake(164,scroll_User_Acc_AddNW.frame.origin.y+scroll_User_Acc_AddNW.frame.size.height+10,134, 64);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            save_Change_NW_UserAcc.frame = CGRectMake(212,scroll_User_Acc_AddNW.frame.origin.y+scroll_User_Acc_AddNW.frame.size.height+10,174, 83);
        }else{
            save_Change_NW_UserAcc.frame = CGRectMake(194,scroll_User_Acc_AddNW.frame.origin.y+scroll_User_Acc_AddNW.frame.size.height+10,157, 75);
        }
        save_Change_NW_UserAcc.backgroundColor=lblRGBA(255,206, 52, 1);
        [view_Acc_AddNwtwork addSubview:save_Change_NW_UserAcc];
        
        
        UIImageView *tickImg=[[UIImageView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            tickImg.frame = CGRectMake(52,8,24, 24);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            tickImg.frame = CGRectMake(66,8,40, 40);
        }else{
            tickImg.frame = CGRectMake(63,8,30, 30);
        }
        tickImg.image=[UIImage imageNamed:@"proceedImagei6plus"];
        [save_Change_NW_UserAcc addSubview:tickImg];
        
        
        UILabel *lbl_Change_NW=[[UILabel alloc] init];
        lbl_Change_NW.text = @"SAVE CHANGES";
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lbl_Change_NW.frame = CGRectMake(0,40,134, 15);
            lbl_Change_NW.font = [UIFont fontWithName:@"NexaBold" size:12];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lbl_Change_NW.frame = CGRectMake(0,60,174, 15);
            lbl_Change_NW.font = [UIFont fontWithName:@"NexaBold" size:14];
        }else{
            lbl_Change_NW.frame = CGRectMake(0,49,157, 15);
            lbl_Change_NW.font = [UIFont fontWithName:@"NexaBold" size:13];
        }
        lbl_Change_NW.textColor = lblRGBA(255, 255, 255, 1);
        lbl_Change_NW.textAlignment=NSTextAlignmentCenter;
        [save_Change_NW_UserAcc addSubview:lbl_Change_NW];
        
        UIButton *btn_Change_NW=[UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Change_NW.frame = CGRectMake(0,0,134, 64);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Change_NW.frame = CGRectMake(0,0,174, 83);//554
        }else{
            btn_Change_NW.frame = CGRectMake(0,0,157, 75);//554
        }
        btn_Change_NW.tag=tag;
        [btn_Change_NW addTarget:self action:@selector(userMGT_SaveNW_Action:) forControlEvents:UIControlEventTouchUpInside];
        [save_Change_NW_UserAcc addSubview:btn_Change_NW];
    }
    @catch (NSException *exception) {
        NSLog(@"exception for user acc addnetwork==%@",exception.description);
    }
}

-(void)hide_Schedule_Header_UserAcc:(int)tagVal{
//    [lblChangeSchedule[tagVal] setHidden:YES];
    viewEdit_UserAcc_Billing[tagVal].hidden=NO;
    viewEdit_UserAcc_Billing[tagVal].backgroundColor=[UIColor clearColor];
    viewEdit_UserAcc_Billing[tagVal].userInteractionEnabled=YES;
}
-(void)show_Schedule_Header_UserAc:(int)tagVal{
//    [lblChangeSchedule[tagVal] setHidden:NO];
    [btn_Save_AccName[tagVal] setHidden:YES];
    viewEdit_UserAcc_Billing[tagVal].hidden=YES;
    viewEdit_UserAcc_Billing[tagVal].backgroundColor=lblRGBA(124, 124, 123, 1);
    viewEdit_UserAcc_Billing[tagVal].userInteractionEnabled=NO;
    txt_AccName[tagVal].hidden=YES;
    [txt_AccName[tagVal] resignFirstResponder];
    txt_AccLName[tagVal].hidden=YES;
    [txt_AccLName[tagVal] resignFirstResponder];
    lblAcc_Name[tagVal].hidden=NO;
    lblAcc_LName[tagVal].hidden=NO;
    [btn_close_UserAcc[tagVal] setHidden:YES];
    strStatus_UserMGT=@"NO";
}

-(void)edit_UserAcc_Action:(UIButton *)sender
{
//    if([[[arrUserManagement objectAtIndex:sender.tag] valueForKey:kNetworkOwner] isEqualToString:@"NO"])
//    {
//        [Common showAlert:kAlertTitleWarning withMessage:@"This user is not a direct invitee. You cannot change the user details"];
//        return;
//    }
    NSLog(@"edt tag value is ==%ld",(long)sender.tag);
    [txt_AccName[sender.tag] setHidden:NO];
    [txt_AccName[sender.tag] becomeFirstResponder];
    [txt_AccLName[sender.tag] setHidden:NO];
    [lblAcc_Name[sender.tag] setHidden:YES];
    [lblAcc_LName[sender.tag] setHidden:YES];
    txt_AccName[sender.tag].text = [[arrUserManagement objectAtIndex:sender.tag] valueForKey:kAccountName];
    txt_AccLName[sender.tag].text = [[arrUserManagement objectAtIndex:sender.tag] valueForKey:kAccountLastName];
    [btn_Save_AccName[sender.tag] setHidden:NO];
    [btn_close_UserAcc[sender.tag] setHidden:NO];
    [viewEdit_UserAcc_Billing[sender.tag] setHidden:YES];
    strStatus_UserMGT=@"YES";
}

-(void)close_UserAcc_Acion:(UIButton *)sender
{
    [txt_AccName[sender.tag] setHidden:YES];
    [txt_AccName[sender.tag] resignFirstResponder];
    [txt_AccLName[sender.tag] setHidden:YES];
    [txt_AccLName[sender.tag] resignFirstResponder];
    [lblAcc_Name[sender.tag] setHidden:NO];
    [lblAcc_LName[sender.tag] setHidden:NO];
    [btn_Save_AccName[sender.tag] setHidden:YES];
    [self hide_Schedule_Header_UserAcc:(int)sender.tag];
    [btn_close_UserAcc[sender.tag] setHidden:YES];
}

-(void)save_AccName_Tapped:(UIButton *)sender
{
//    lblAcc_Name[sender.tag].text = txt_AccName[sender.tag].text;
//    [txt_AccName[sender.tag] setHidden:YES];
//    [txt_AccName[sender.tag] resignFirstResponder];
//    [lblAcc_Name[sender.tag] setHidden:NO];
//    [btn_Save_AccName[sender.tag] setHidden:YES];
//    [viewEdit_UserAcc_Billing[sender.tag] setHidden:NO];
//    [btn_close_UserAcc[sender.tag] setHidden:YES];
    if ([txt_AccName[tag_PosAcc] resignFirstResponder]) {
        [txt_AccName[tag_PosAcc] resignFirstResponder];
    }else if ([txt_AccLName[tag_PosAcc] resignFirstResponder]){
        [txt_AccLName[tag_PosAcc] resignFirstResponder];
    }
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    txt_AccName[tag_PosAcc].text=[Common Trimming_Right_End_WhiteSpaces:txt_AccName[tag_PosAcc].text];
    txt_AccLName[tag_PosAcc].text=[Common Trimming_Right_End_WhiteSpaces:txt_AccLName[tag_PosAcc].text];
    if(txt_AccName[tag_PosAcc].text.length==0 && txt_AccLName[tag_PosAcc].text.length==0){
        [Common showAlert:@"Warning" withMessage:@"Please enter the name fields"];
        return;
    }else if (txt_AccName[tag_PosAcc].text.length==0){
        [Common showAlert:@"Warning" withMessage:@"Please enter the first name"];
        return;
    }else if (txt_AccLName[tag_PosAcc].text.length==0){
        [Common showAlert:@"Warning" withMessage:@"Please enter the last name"];
        return;
    }
    
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(updateUserAccName) withObject:self];
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
}

-(void)parseBodyUserAccMgt
{
    @try {
        if (cellExpandStatusAcc==YES) {
            self.view.userInteractionEnabled=NO;
//            [self userAcc_AddWidget:tag_PosAcc];
            [self userAcc_AddWidget_Network:tag_PosAcc];
            [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    menu_User_Acc[viewCurrentAcc.tag].frame = CGRectMake(0, menu_User_Acc[viewCurrentAcc.tag].frame.origin.y, self.view.frame.size.width, 240);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    menu_User_Acc[viewCurrentAcc.tag].frame = CGRectMake(0, menu_User_Acc[viewCurrentAcc.tag].frame.origin.y, self.view.frame.size.width, 320);
                }else{
                    menu_User_Acc[viewCurrentAcc.tag].frame = CGRectMake(0, menu_User_Acc[viewCurrentAcc.tag].frame.origin.y, self.view.frame.size.width, 290);
                }

                yOffSet_Content=menu_User_Acc[viewCurrentAcc.tag].frame.origin.y+menu_User_Acc[viewCurrentAcc.tag].frame.size.height+5;
                for (int index=0;index<[arrUserManagement count];index++){
                    if (index>[viewCurrentAcc tag]) {
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                            menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 22);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                            menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 44);
                        }else{
                            menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 34);
                        }
                        yOffSet_Content=menu_User_Acc[index].frame.origin.y+menu_User_Acc[index].frame.size.height+5;
                    }
                }
                viewTagValueAcc=viewCurrentAcc.tag;
                [self scroll_UserMgt_setup:yOffSet_Content];
                [self hide_Schedule_Header_UserAcc:(int)viewTagValueAcc];
            } completion:^(BOOL finished) {
                view_User_Acc_Contentview[tag_PosAcc].hidden=NO;
                cellExpandStatusAcc=NO;
                self.view.userInteractionEnabled=YES;
            }];
        }else{
            self.view.userInteractionEnabled=NO;
            [self show_Schedule_Header_UserAc:(int)viewTagValueAcc];
//            [self userAcc_AddWidget:tag_PosAcc];
            [self userAcc_AddWidget_Network:tag_PosAcc];
            [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    menu_User_Acc[viewTagValueAcc].frame=CGRectMake(0, menu_User_Acc[viewTagValueAcc].frame.origin.y, self.view.frame.size.width, 22);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    menu_User_Acc[viewTagValueAcc].frame=CGRectMake(0, menu_User_Acc[viewTagValueAcc].frame.origin.y, self.view.frame.size.width, 44);
                }else{
                    menu_User_Acc[viewTagValueAcc].frame=CGRectMake(0, menu_User_Acc[viewTagValueAcc].frame.origin.y, self.view.frame.size.width, 34);
                }
                yOffSet_Content=menu_User_Acc[viewTagValueAcc].frame.origin.y+menu_User_Acc[viewTagValueAcc].frame.size.height+5;
                [view_User_Acc_Contentview[viewTagValueAcc] setHidden:YES];
                [view_User_Acc_Contentview[viewTagValueAcc] removeFromSuperview];
                for (int index=0;index<[arrUserManagement count];index++){
                    if (index>viewTagValueAcc) {
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                            menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 22);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                            menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 44);
                        }else{
                            menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 34);
                        }
                        yOffSet_Content=menu_User_Acc[index].frame.origin.y+menu_User_Acc[index].frame.size.height+5;
                    }
                }
                
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    menu_User_Acc[viewCurrentAcc.tag].frame = CGRectMake(0, menu_User_Acc[viewCurrentAcc.tag].frame.origin.y, self.view.frame.size.width, 240);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    menu_User_Acc[viewCurrentAcc.tag].frame = CGRectMake(0, menu_User_Acc[viewCurrentAcc.tag].frame.origin.y, self.view.frame.size.width, 320);
                }else{
                    menu_User_Acc[viewCurrentAcc.tag].frame = CGRectMake(0, menu_User_Acc[viewCurrentAcc.tag].frame.origin.y, self.view.frame.size.width, 290);
                }
                yOffSet_Content=menu_User_Acc[viewCurrentAcc.tag].frame.origin.y+menu_User_Acc[viewCurrentAcc.tag].frame.size.height+5;
                // [self testAddWidget:view.tag];
                for (int index=0;index<[arrUserManagement count];index++){
                    if (index>[viewCurrentAcc tag]) {
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                            menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 22);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                            menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 44);
                        }else{
                            menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 34);
                        }
                        yOffSet_Content=menu_User_Acc[index].frame.origin.y+menu_User_Acc[index].frame.size.height+5;
                    }
                }
                viewTagValueAcc=viewCurrentAcc.tag;
                // scrollViewSchedule.contentSize = CGSizeMake(self.scrollViewSchedule.frame.size.width, yOffSet_Content+20);
                [self hide_Schedule_Header_UserAcc:(int)viewTagValueAcc];
                [self scroll_UserMgt_setup:yOffSet_Content];
                
            } completion:^(BOOL finished) {
                view_User_Acc_Contentview[tag_PosAcc].hidden=NO;
                self.view.userInteractionEnabled=YES;
                // [self schedule_AddWidget:tag_Pos];
                cellExpandStatusAcc=NO;
            }];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"expandable exception==%@",exception.description);
    }
    [self stop_PinWheel_UserSettings];
}

- (void)expandUserAcc_View_onClick:(UITapGestureRecognizer*)sender {
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    if([arr_NetworkList count]==0)
    {
        [Common showAlert:kAlertTitleWarning withMessage:@"No property available for sharing"];
        return;
    }

    if ([current_textfield_Billing resignFirstResponder]) {
        [current_textfield_Billing resignFirstResponder];
    }
    viewCurrentAcc = sender.view;
    tag_PosAcc=(int)viewCurrentAcc.tag;
    NSLog(@"tag==%ld",(long)viewCurrentAcc.tag);
    strMemberID=[[arrUserManagement objectAtIndex:tag_PosAcc] valueForKey:kAccountID];
    if([strStatus_UserMGT isEqualToString:@"YES"]){
        [txt_AccName[viewTagValueAcc] resignFirstResponder];
        [txt_AccName[viewTagValueAcc] setHidden:YES];
        [txt_AccLName[viewTagValueAcc] resignFirstResponder];
        [txt_AccLName[viewTagValueAcc] setHidden:YES];
        [btn_Save_AccName[viewTagValueAcc] setHidden:YES];
        [self show_Schedule_Header_UserAc:(int)viewTagValueAcc];
    }
    @try {
        if (cellExpandStatusAcc==YES) {
            [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(getUserSelectedNW) withObject:self waitUntilDone:YES];
        }else{
            if (viewTagValueAcc==viewCurrentAcc.tag) {
                self.view.userInteractionEnabled=NO;
                [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                        menu_User_Acc[viewCurrentAcc.tag].frame = CGRectMake(0, menu_User_Acc[viewCurrentAcc.tag].frame.origin.y, self.view.frame.size.width, 22);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                        menu_User_Acc[viewCurrentAcc.tag].frame = CGRectMake(0, menu_User_Acc[viewCurrentAcc.tag].frame.origin.y, self.view.frame.size.width, 44);
                    }else{
                        menu_User_Acc[viewCurrentAcc.tag].frame = CGRectMake(0, menu_User_Acc[viewCurrentAcc.tag].frame.origin.y, self.view.frame.size.width, 34);
                    }
                    yOffSet_Content=menu_User_Acc[viewCurrentAcc.tag].frame.origin.y+menu_User_Acc[viewCurrentAcc.tag].frame.size.height+5;
                    for (int index=0;index<[arrUserManagement count];index++){
                        if (index>[viewCurrentAcc tag]) {
                            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                                menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 22);
                            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                                menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 44);
                            }else{
                                menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 34);
                            }
                            yOffSet_Content=menu_User_Acc[index].frame.origin.y+menu_User_Acc[index].frame.size.height+5;
                        }
                    }
                    //scrollViewSchedule.contentSize = CGSizeMake(self.scrollViewSchedule.frame.size.width, yOffSet_Content);
                    [self scroll_UserMgt_setup:yOffSet_Content];
                    [view_User_Acc_Contentview[viewCurrentAcc.tag] setHidden:YES];
                    [view_User_Acc_Contentview[viewCurrentAcc.tag] removeFromSuperview];
                    [self show_Schedule_Header_UserAc:(int)viewTagValueAcc];
                } completion:^(BOOL finished) {
                    self.view.userInteractionEnabled=YES;
                    cellExpandStatusAcc=YES;
                }];
                
            }else{
                [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
                [self performSelectorOnMainThread:@selector(getUserSelectedNW) withObject:self waitUntilDone:YES];

              }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"expandable exception==%@",exception.description);
    }
}

-(void)scroll_UserMgt_setup:(float)yAxis{
    NSLog(@"yaxis==%f",yAxis);
    self.scroll_UserMgt_UserAcc.frame=CGRectMake(self.scroll_UserMgt_UserAcc.frame.origin.x, self.scroll_UserMgt_UserAcc.frame.origin.y, self.scroll_UserMgt_UserAcc.frame.size.width, yAxis);
    self.user_Acc_View_Mgt.frame=CGRectMake(self.user_Acc_View_Mgt.frame.origin.x, self.user_Acc_View_Mgt.frame.origin.y, self.user_Acc_View_Mgt.frame.size.width, self.scroll_UserMgt_UserAcc.frame.origin.y+self.scroll_UserMgt_UserAcc.frame.size.height);
    self.bodyViewScroll_UserManage.contentSize=CGSizeMake(self.bodyViewScroll_UserManage.frame.size.width, self.user_Acc_View_Mgt.frame.origin.y+self.user_Acc_View_Mgt.frame.size.height);
}

-(void)collapseUserAccountView
{
    self.view.userInteractionEnabled=NO;
    [view_User_Acc_Contentview[tag_PosAcc] removeFromSuperview];
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            menu_User_Acc[tag_PosAcc].frame = CGRectMake(0, menu_User_Acc[tag_PosAcc].frame.origin.y, self.view.frame.size.width, 22);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            menu_User_Acc[tag_PosAcc].frame = CGRectMake(0, menu_User_Acc[tag_PosAcc].frame.origin.y, self.view.frame.size.width, 44);
        }else{
            menu_User_Acc[tag_PosAcc].frame = CGRectMake(0, menu_User_Acc[tag_PosAcc].frame.origin.y, self.view.frame.size.width, 34);
        }

        yOffSet_Content=menu_User_Acc[tag_PosAcc].frame.origin.y+menu_User_Acc[tag_PosAcc].frame.size.height+5;
        
        yOffSet_Content=menu_User_Acc[tag_PosAcc].frame.origin.y+menu_User_Acc[tag_PosAcc].frame.size.height+5;
        for (int index=0;index<[arrUserManagement count];index++){
            if (index>tag_PosAcc) {
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 22);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 44);
                }else{
                    menu_User_Acc[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 34);
                }
                yOffSet_Content=menu_User_Acc[index].frame.origin.y+menu_User_Acc[index].frame.size.height+5;
            }
        }
        [self scroll_UserMgt_setup:yOffSet_Content];
    } completion:^(BOOL  finished) {
        [self show_Schedule_Header_UserAc:(int)tag_PosAcc];
        cellExpandStatusAcc=YES;
        self.view.userInteractionEnabled=YES;
    }];
}

-(void)popUserAcc_DeleteOldConfiguration
{
    self.settingHeaderView.alpha=1.0;
    self.settingTabView.alpha=1.0;
    self.settingConatinerView.alpha=1.0;
}

-(void)userMGT_DeleteUser_Action:(UIButton *)sender
{
//    if([[[arrUserManagement objectAtIndex:sender.tag] valueForKey:kNetworkOwner] isEqualToString:@"NO"])
//    {
//        [Common showAlert:kAlertTitleWarning withMessage:@"This user is not a direct invitee. You cannot delete this user"];
//        return;
//    }
//    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    alertView_userManagement.hidden=NO;
    [settingTabView setAlpha:0.6];
    [settingHeaderView setAlpha:0.6];
    [settingConatinerView setAlpha:0.6];
}

-(void)userMGT_SaveNW_Action:(UIButton *)sender{
//    if([[[arrUserManagement objectAtIndex:sender.tag] valueForKey:kNetworkOwner] isEqualToString:@"NO"])
//    {
//        [Common showAlert:kAlertTitleWarning withMessage:@"This user is not a direct invitee. You cannot change the user details"];
//        return;
//    }
    [self textfield_WidgetDismissOrNot_Settings];
    if (txt_AccName[tag_PosAcc].text.length==0 && txt_AccLName[tag_PosAcc].text.length==0) {
        [Common showAlert:@"Warning" withMessage:@"Please enter the name fields"];
        return;
    }else if (txt_AccName[tag_PosAcc].text.length==0){
        [Common showAlert:@"Warning" withMessage:@"Please enter the first name"];
        return;
    }else if (txt_AccLName[tag_PosAcc].text.length==0){
        [Common showAlert:@"Warning" withMessage:@"Please enter the last name"];
        return;
    }else if ([arr_NetworkUserID count]==0){
        [Common showAlert:@"Warning" withMessage:@"Please select atleast one property"];
        return;
    }
    if([arr_NetworkUserID count]>0)
    {
        if(prev_Count==0)
        {
            int noneCount=0;
            for(int index=0;index<[arr_NetworkUserID count];index++)
            {
                if([[[arr_NetworkUserID objectAtIndex:index] valueForKey:kaccesstypeID] isEqualToString:@"4"])
                {
                    noneCount=noneCount+1;
                }
            }
            if(noneCount==[arr_NetworkUserID count])
            {
                [Common showAlert:@"Warning" withMessage:@"Please select atleast one property"];
                
                return;
            }
        }
    }
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(updateUserAccountDetails) withObject:self];
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
}


-(void)change_Add_NW_Status_SubNetwork:(UIButton *)sender{
    [self textfield_WidgetDismissOrNot_Settings];
    NSLog(@"network checkbox tick %ld",(long)sender.tag);
    accessTypeTag = (int)sender.tag;
    strSelectedNw_Status=@"AddUserAcc";
    self.view_PermissionAlert.hidden=NO;
    [self popup_Settings_Alpha_Disabled];
}

-(void)change_Add_NW_Status:(UIButton *)sender{
    
    NSLog(@"tag is ==%@",[dictUserAcc_Content valueForKey:kNetworkOwner]);
//    if([[dictUserAcc_Content valueForKey:kNetworkOwner] isEqualToString:@"NO"])
//    {
//        [Common showAlert:kAlertTitleWarning withMessage:@"This user is not a direct invitee. You cannot change the user details"];
//        return;
//    }
    [self textfield_WidgetDismissOrNot_Settings];
    NSLog(@"network checkbox tick %ld",(long)sender.tag);
    self.view_PermissionAlert.hidden=NO;
    [self popup_Settings_Alpha_Disabled];
    userAcc_AccessTag = (int)sender.tag;
    strSelectedNw_Status=@"userAccDetail";
}

-(void)userAccNetworkList
{
    NSString *strNWID = [[[arr_NetworkList objectAtIndex:userAcc_AccessTag] objectForKey:@"id"] stringValue];
    
    NSMutableDictionary *dict_UserAcc_SltNw;
    dict_UserAcc_SltNw = [[NSMutableDictionary alloc] init];
    if ([arr_NetworkUserID count]==0) {
        [dict_UserAcc_SltNw setObject:strUserAccessType forKey:kaccesstypeID];
        [dict_UserAcc_SltNw setObject:strNWID forKey:kNetworkID];
        [arr_NetworkUserID addObject:dict_UserAcc_SltNw];
    }else{
        for (int i=0; i<[arr_NetworkUserID count]; i++) {
            NSLog(@"%@",[[arr_NetworkUserID objectAtIndex:i] valueForKey:kNetworkID]);
            NSLog(@"%@",strNWID);
            
            if ([[[arr_NetworkUserID objectAtIndex:i] valueForKey:kNetworkID] isEqualToString:strNWID]) {
                [arr_NetworkUserID removeObjectAtIndex:i];
            }
        }
        [dict_UserAcc_SltNw setObject:strUserAccessType forKey:kaccesstypeID];
        [dict_UserAcc_SltNw setObject:strNWID forKey:kNetworkID];
        [arr_NetworkUserID addObject:dict_UserAcc_SltNw];
    }
    NSLog(@"arrrr %@",arr_NetworkUserID);
}


-(void)addSelectNetworkList
{
    [btn_Chk_Network_AddUser[accessTypeTag] setImage:[UIImage imageNamed:@"bgYellowTickImagei6plus"] forState:UIControlStateNormal];
    NSString *strNwID = [[[arr_NetworkList objectAtIndex:accessTypeTag] objectForKey:@"id"] stringValue];
    NSMutableDictionary *dictSltNw;
    dictSltNw = [[NSMutableDictionary alloc] init];
    if ([arr_Networkid count]==0) {
        [dictSltNw setObject:strAccessType forKey:kaccesstypeID];
        [dictSltNw setObject:strNwID forKey:kNetworkID];
        [arr_Networkid addObject:dictSltNw];
    }else{
        for (int i=0; i<[arr_Networkid count]; i++) {
            NSLog(@"%@",[[arr_Networkid objectAtIndex:i] valueForKey:kNetworkID]);
            NSLog(@"%@",strNwID);

            if ([[[arr_Networkid objectAtIndex:i] valueForKey:kNetworkID] isEqualToString:strNwID]) {
                [arr_Networkid removeObjectAtIndex:i];
            }
        }
        [dictSltNw setObject:strAccessType forKey:kaccesstypeID];
        [dictSltNw setObject:strNwID forKey:kNetworkID];
        [arr_Networkid addObject:dictSltNw];
    }
    NSLog(@"arrrr %@",arr_Networkid);
}

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Animate the view when the next and previous button clicked for user management screen
 Method Name : PreviousNextButtons_UserMgmt(User Defined Methods)
 ************************************************************************************* */
-(void)PreviousNextButtons_UserMgmt
{
    NSArray *fields = @[txtfld_Fname_userManagement,txtfld_Lname_userManagement,txtfld_email_userManagement];
    [self setKeyboardControls_Billing:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls_Billing setDelegate:self];
}

-(void)PreviousNextButtons_UserMgmt_UserAcc
{
    NSArray *fields = @[txt_AccName[tag_PosAcc]];
    [self setKeyboardControls_Billing:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls_Billing setDelegate:self];
}

#pragma mark - History SetUp
-(void)historySetup
{
    pageindex=0;
    countPerPage=9;
    str_Selected_Tap=@"page1";
    str_Previous_Tap=@"page1";
    cellExpandStatus=YES;
}

-(void)loadHistoryDatas:(NSArray *)arrHistoryContent
{
    NSLog(@"array==%@",arrHistoryContent);
    NSLog(@"array count==%lu",(unsigned long)arrHistoryContent.count);
    scroll_History.userInteractionEnabled=YES;
    scroll_History.delegate=self;
    scroll_History.scrollsToTop=NO;
    cellExpandStatus=YES;
    arrHistoryListPerPage = [[NSMutableArray alloc] init];
    [arrHistoryListPerPage addObjectsFromArray:arrHistoryContent];
    float x_OffsetAlerts=0,h_OffsetAlerts=0,yOffsetAlerts=0.0;
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        h_OffsetAlerts=34;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        h_OffsetAlerts=43;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        h_OffsetAlerts=36;
    }
    @try {
        for(int alertIndex=0;alertIndex<[arrHistoryContent count];alertIndex++){
            NSLog(@"array value is ==%@",arrHistoryContent);
            NSLog(@"array value is indi ==%@",[arrHistoryContent objectAtIndex:alertIndex]);
            menuViewHistory[alertIndex]=[[UIView alloc] init];
            menuViewHistory[alertIndex].frame=CGRectMake(x_OffsetAlerts, yOffsetAlerts, self.settingHistoryView.frame.size.width,h_OffsetAlerts);
            menuViewHistory[alertIndex].backgroundColor=[UIColor clearColor];
            menuViewHistory[alertIndex].tag=alertIndex;
            [scroll_History addSubview:menuViewHistory[alertIndex]];
            
            menuTapViewHistory[alertIndex] = [[UIView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                menuTapViewHistory[alertIndex].frame = CGRectMake(0, 0, menuViewHistory[alertIndex].frame.size.width, 34);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                menuTapViewHistory[alertIndex].frame = CGRectMake(0, 0, menuViewHistory[alertIndex].frame.size.width, 43);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                menuTapViewHistory[alertIndex].frame = CGRectMake(0, 0, menuViewHistory[alertIndex].frame.size.width, 36);
            }
            menuTapViewHistory[alertIndex].backgroundColor=[UIColor clearColor];
            menuTapViewHistory[alertIndex].tag=alertIndex;
            [menuViewHistory[alertIndex] addSubview:menuTapViewHistory[alertIndex]];

            UITapGestureRecognizer *tapGestureView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandHistory_View_onClick:)];
            [menuTapViewHistory[alertIndex] addGestureRecognizer:tapGestureView];
            [menuTapViewHistory[alertIndex] setExclusiveTouch:YES];
            
            lblMsgAlert[alertIndex] = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblMsgAlert[alertIndex].frame=CGRectMake(10, 6, 146, 21);
                [lblMsgAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:10]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblMsgAlert[alertIndex].frame=CGRectMake(10, 11, 176, 21);
                [lblMsgAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblMsgAlert[alertIndex].frame=CGRectMake(10, 8, 162, 21);
                [lblMsgAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }
            [lblMsgAlert[alertIndex] setTextColor:lblRGBA(255,255,255, 1)];
            lblMsgAlert[alertIndex].text =[NSString stringWithFormat:@"%@",[[[arrHistoryContent objectAtIndex:alertIndex]objectForKey:@"eventType"] objectForKey:@"code"]];
            [menuViewHistory[alertIndex] addSubview:lblMsgAlert[alertIndex]];
            
            NSTimeInterval date =[[NSString stringWithFormat:@"%@",[[arrHistoryContent objectAtIndex:alertIndex] objectForKey:@"eventTimeStamp"]] doubleValue];
            NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:date/1000];
            NSLog(@"date==%@",epochNSDate);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:[Common GetCurrentDateFormat]];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:strTimeZoneIDFor_User]];
            NSString *timestamp = [dateFormatter stringFromDate:epochNSDate];
            NSLog(@"%@",timestamp);
            
            lblDateAlert[alertIndex] = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblDateAlert[alertIndex].frame=CGRectMake(157, 6, 69, 21);
                [lblDateAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:10]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblDateAlert[alertIndex].frame=CGRectMake(212, 11, 86, 21);
                [lblDateAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblDateAlert[alertIndex].frame=CGRectMake(195, 8, 74, 21);
                [lblDateAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }
            [lblDateAlert[alertIndex] setTextColor:lblRGBA(255, 255, 255, 1)];
            lblDateAlert[alertIndex].text =[NSString stringWithFormat:@"%@",timestamp];
            lblDateAlert[alertIndex].textAlignment = NSTextAlignmentCenter;
            [menuViewHistory[alertIndex] addSubview:lblDateAlert[alertIndex]];
            
            
//            viewButtonAlert[alertIndex]=[UIButton buttonWithType:UIButtonTypeSystem];
//            [viewButtonAlert[alertIndex] setTitle:@"VIEW" forState:UIControlStateNormal];
//            [viewButtonAlert[alertIndex] setTitleColor:lblRGBA(135, 196, 65, 1) forState:UIControlStateNormal];
//            // [viewButtonAlert[alertIndex] addTarget:self action:@selector(myAction:) forControlEvents:UIControlEventTouchUpInside];
//            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                viewButtonAlert[alertIndex].frame = CGRectMake(264, 2, 46, 30);
//                viewButtonAlert[alertIndex].titleLabel.font=[UIFont fontWithName:@"NexaBold" size:10];
//            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                viewButtonAlert[alertIndex].frame = CGRectMake(349, 7, 46, 30);
//                viewButtonAlert[alertIndex].titleLabel.font=[UIFont fontWithName:@"NexaBold" size:12];
//            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
//                viewButtonAlert[alertIndex].frame = CGRectMake(319, 4, 46, 30);
//                viewButtonAlert[alertIndex].titleLabel.font=[UIFont fontWithName:@"NexaBold" size:11];
//            }
//            [menuViewHistory[alertIndex] addSubview:viewButtonAlert[alertIndex]];
            
            lbl_viewBillingHistory[alertIndex]=[[UILabel alloc] init];
            lbl_viewBillingHistory[alertIndex].text = @"VIEW";
            lbl_viewBillingHistory[alertIndex].textColor = lblRGBA(135, 196, 65, 1);
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lbl_viewBillingHistory[alertIndex].frame = CGRectMake(264, 2, 46, 30);
                [lbl_viewBillingHistory[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:10]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lbl_viewBillingHistory[alertIndex].frame = CGRectMake(349, 7, 46, 30);
                [lbl_viewBillingHistory[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lbl_viewBillingHistory[alertIndex].frame = CGRectMake(319, 4, 46, 30);
                [lbl_viewBillingHistory[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }
            [menuViewHistory[alertIndex] addSubview:lbl_viewBillingHistory[alertIndex]];

            UIView *viewDivier=[[UIView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                viewDivier.frame=CGRectMake(0, 33,menuViewHistory[alertIndex].frame.size.width, 1);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                viewDivier.frame=CGRectMake(0, 42,menuViewHistory[alertIndex].frame.size.width, 1);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                viewDivier.frame=CGRectMake(0, 35,menuViewHistory[alertIndex].frame.size.width, 1);
            }
            viewDivier.backgroundColor=lblRGBA(76, 76, 76, 1);
            [menuViewHistory[alertIndex] addSubview:viewDivier];
            
            //
            yOffsetAlerts=menuViewHistory[alertIndex].frame.size.height+menuViewHistory[alertIndex].frame.origin.y;
        }
        scroll_History.contentSize=CGSizeMake(scroll_History.frame.size.width, yOffsetAlerts);
        if(historyStatus==YES){
            [self rendering_Pagination_History_Buttons];
            [self setupFooter_UserSettings];
            historyStatus=NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    [self stop_PinWheel_UserSettings];
}

-(void)rendering_Pagination_History_Buttons
{
    float xAxis=0.0;
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        xAxis=74;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        xAxis=106;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        xAxis=98;
    }

    for(int index=1;index<=TotalPage;index++){
        btnHistory_Page[index]=[UIButton buttonWithType:UIButtonTypeCustom];
        btnHistory_Page[index].frame=CGRectMake(xAxis,5.0,30.0,30.0);
        [btnHistory_Page[index] setBackgroundColor:[UIColor clearColor]];
        btnHistory_Page[index].tag=index;
        [btnHistory_Page[index] setTitle:[NSString stringWithFormat:@"%d",index] forState:UIControlStateNormal];
        [btnHistory_Page[index].titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
        if(index==1)
        {
            [btnHistory_Page[index] setBackgroundColor:lblRGBA(135, 196, 65, 1)];
            [btnHistory_Page[index] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                  currentIndex=index;
            PreviousIndex=index;
        }else{
            [btnHistory_Page[index] setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            [btnHistory_Page[index] setBackgroundImage:[UIImage imageNamed:@"grayBoxImage"] forState:UIControlStateNormal];
        }
        [btnHistory_Page[index] addTarget:self action:@selector(historyPaginationTapped:) forControlEvents:UIControlEventTouchUpInside];
        [viewFooter_UserHistory addSubview:btnHistory_Page[index]];
        if(index%5==0){
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                xAxis=74;
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                xAxis=106;
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                xAxis=98;
            }
        }else{
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                xAxis=btnHistory_Page[index].frame.origin.x+btnHistory_Page[index].frame.size.width+5;
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                xAxis=btnHistory_Page[index].frame.origin.x+btnHistory_Page[index].frame.size.width+10;
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                xAxis=btnHistory_Page[index].frame.origin.x+btnHistory_Page[index].frame.size.width+8;
            }
        }
        if(index>5){
            btnHistory_Page[index].hidden=YES;
        }
    }
}

-(void)setupFooter_UserSettings
{
    if(TotalPage>1){
        self.viewFooter_UserHistory.hidden=NO;
        btnPagePrevious.userInteractionEnabled=NO;
        btnPageNext.userInteractionEnabled=YES;
    }else{
        self.viewFooter_UserHistory.hidden=YES;
    }
}

-(void)historyPaginationTapped:(UIButton*)button
{
    currentIndex=(int)button.tag;
    if(currentIndex==PreviousIndex)
    {
        return;
    }
    if(currentIndex==1)
    {
        [btnPagePrevious setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        [btnPagePrevious setBackgroundColor:[UIColor clearColor]];
        [btnPagePrevious setBackgroundImage:[UIImage imageNamed:@"bigGrayBoxImage"] forState:UIControlStateNormal];
        btnPagePrevious.userInteractionEnabled=NO;
    }else{
        [btnPagePrevious setBackgroundColor:lblRGBA(135, 196, 65, 1)];
        [btnPagePrevious setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnPagePrevious setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.scroll_History.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        btnPagePrevious.userInteractionEnabled=YES;
    }
    if(currentIndex==TotalPage)
    {
        [btnPageNext setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        [btnPageNext setBackgroundColor:[UIColor clearColor]];
        [btnPageNext setBackgroundImage:[UIImage imageNamed:@"bigGrayBoxImage"] forState:UIControlStateNormal];
        btnPageNext.userInteractionEnabled=NO;
    }else{
        [btnPageNext setBackgroundColor:lblRGBA(135, 196, 65, 1)];
        [btnPageNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnPageNext setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        btnPageNext.userInteractionEnabled=YES;
    }
    [btnHistory_Page[PreviousIndex] setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
    [btnHistory_Page[PreviousIndex] setBackgroundColor:[UIColor clearColor]];
    [btnHistory_Page[PreviousIndex] setBackgroundImage:[UIImage imageNamed:@"grayBoxImage"] forState:UIControlStateNormal];
    
    [btnHistory_Page[currentIndex] setBackgroundColor:lblRGBA(135, 196, 65, 1)];
    [btnHistory_Page[currentIndex] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnHistory_Page[currentIndex] setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.scroll_History.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    pageindex=(int)button.tag-1;
    NSUInteger start = countPerPage * pageindex;
    NSRange range = NSMakeRange(start, MIN([arrUserHistory count] - start, countPerPage));
    arrUserHistorySplit = [arrUserHistory subarrayWithRange:range];
    PreviousIndex=currentIndex;
    [self loadHistoryDatas:arrUserHistorySplit];
}

-(void) history_AddWidget:(int)tag
{
    @try {
        view_History_ContentView[tag]=[[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_History_ContentView[tag].frame = CGRectMake(0, 34, self.view.frame.size.width, 105);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_History_ContentView[tag].frame = CGRectMake(0, 43, self.view.frame.size.width, 132);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            view_History_ContentView[tag].frame = CGRectMake(0, 36, self.view.frame.size.width, 120);
        }
        view_History_ContentView[tag].backgroundColor=lblRGBA(99, 100, 102, 1);
        [menuViewHistory[tag] addSubview:view_History_ContentView[tag]];
        
        UIView *view_History_divider=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        view_History_divider.backgroundColor=lblRGBA(76, 76, 76, 1);
        [view_History_ContentView[tag] addSubview:view_History_divider];
        
        UIView *view_History_divider2=[[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_History_divider2.frame = CGRectMake(0, 34, self.view.frame.size.width, 1);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_History_divider2.frame = CGRectMake(0, 43, self.view.frame.size.width, 1);

        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            view_History_divider2.frame = CGRectMake(0, 36, self.view.frame.size.width, 1);
        }
        view_History_divider2.backgroundColor=lblRGBA(76, 76, 76, 1);
        [view_History_ContentView[tag] addSubview:view_History_divider2];
        
        UIView *view_History_divider3=[[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_History_divider3.frame = CGRectMake(0, 69, self.view.frame.size.width, 1);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_History_divider3.frame = CGRectMake(0, 87, self.view.frame.size.width, 1);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            view_History_divider3.frame = CGRectMake(0, 73, self.view.frame.size.width, 1);
        }
        view_History_divider3.backgroundColor=lblRGBA(76, 76, 76, 1);
        [view_History_ContentView[tag] addSubview:view_History_divider3];
        
        NSTimeInterval date =[[NSString stringWithFormat:@"%@",[[arrUserHistorySplit objectAtIndex:tag] objectForKey:@"eventTimeStamp"]] doubleValue];
        NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:date/1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:strTimeZoneIDFor_User]];
        [dateFormatter setDateFormat:[Common GetCurrentDateFormat]];
        NSString *timestamp = [dateFormatter stringFromDate:epochNSDate];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *time = [dateFormatter stringFromDate:epochNSDate];
        NSLog(@"Your local date is: %@", timestamp);

        UILabel *lblTime = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblTime.frame = CGRectMake(10, 6, 29, 21);
            lblTime.font = [UIFont fontWithName:@"NexaBold" size:10.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblTime.frame = CGRectMake(10, 13, 32, 21);
            lblTime.font = [UIFont fontWithName:@"NexaBold" size:12.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lblTime.frame = CGRectMake(10, 11, 29, 21);
            lblTime.font = [UIFont fontWithName:@"NexaBold" size:11.0];
        }
        lblTime.text = @"TIME";
        lblTime.textColor = lblRGBA(255, 255, 255, 1);
        [view_History_ContentView[tag] addSubview:lblTime];
        
        UILabel *lblTimeValue = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblTimeValue.frame = CGRectMake(45, 6, 42, 21);
            lblTimeValue.font = [UIFont fontWithName:@"NexaBold" size:10.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblTimeValue.frame = CGRectMake(45, 13, 46, 21);
            lblTimeValue.font = [UIFont fontWithName:@"NexaBold" size:12.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lblTimeValue.frame = CGRectMake(45, 11, 42, 21);
            lblTimeValue.font = [UIFont fontWithName:@"NexaBold" size:11.0];
        }
        lblTimeValue.text = [NSString stringWithFormat:@"%@",time];;
        lblTimeValue.textColor = lblRGBA(184, 184, 184, 1);
        [view_History_ContentView[tag] addSubview:lblTimeValue];
        
        UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(239, 28, 58, 21)];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblDate.frame = CGRectMake(88, 6, 29, 21);
            lblDate.font = [UIFont fontWithName:@"NexaBold" size:10.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblDate.frame = CGRectMake(112, 13, 38, 21);
            lblDate.font = [UIFont fontWithName:@"NexaBold" size:12.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lblDate.frame = CGRectMake(99, 11, 32, 21);
            lblDate.font = [UIFont fontWithName:@"NexaBold" size:11.0];
        }
        lblDate.text = @"DATE";
        lblDate.textColor = lblRGBA(255, 255, 255, 1);
        [view_History_ContentView[tag] addSubview:lblDate];
        
        UILabel *lblDateValue = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblDateValue.frame = CGRectMake(123, 6, 68, 21);
            lblDateValue.font = [UIFont fontWithName:@"NexaBold" size:10.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblDateValue.frame = CGRectMake(158, 13, 77, 21);
            lblDateValue.font = [UIFont fontWithName:@"NexaBold" size:12.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lblDateValue.frame = CGRectMake(134, 11, 68, 21);
            lblDateValue.font = [UIFont fontWithName:@"NexaBold" size:11.0];
        }
        lblDateValue.text = [NSString stringWithFormat:@"%@",timestamp];
        lblDateValue.textColor = lblRGBA(184, 184, 184, 1);
        [view_History_ContentView[tag] addSubview:lblDateValue];
        
        UILabel *lblUser = [[UILabel alloc] initWithFrame:CGRectMake(472, 28, 58, 21)];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblUser.frame = CGRectMake(186, 6, 32, 21);
            lblUser.font = [UIFont fontWithName:@"NexaBold" size:10.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblUser.frame = CGRectMake(248, 13, 38, 21);
            lblUser.font = [UIFont fontWithName:@"NexaBold" size:12.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lblUser.frame = CGRectMake(206, 11, 35, 21);
            lblUser.font = [UIFont fontWithName:@"NexaBold" size:11.0];
        }
        lblUser.text = @"USER";
        lblUser.textColor = lblRGBA(255, 255, 255, 1);
        [view_History_ContentView[tag] addSubview:lblUser];
        
        UILabel *lblUserValue = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblUserValue.frame = CGRectMake(221, 6, 91, 21);
            lblUserValue.font = [UIFont fontWithName:@"NexaBold" size:10.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblUserValue.frame = CGRectMake(291, 13, 118, 21);
            lblUserValue.font = [UIFont fontWithName:@"NexaBold" size:12.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lblUserValue.frame = CGRectMake(249, 11, 118, 21);
            lblUserValue.font = [UIFont fontWithName:@"NexaBold" size:11.0];
        }
        lblUserValue.text = [NSString stringWithFormat:@"%@ %@",[[[arrUserHistorySplit objectAtIndex:tag] objectForKey:@"account"] objectForKey:@"firstName"], [[[arrUserHistorySplit objectAtIndex:tag] objectForKey:@"account"] objectForKey:@"lastName"]];
        lblUserValue.textColor = lblRGBA(184, 184, 184, 1);
        [view_History_ContentView[tag] addSubview:lblUserValue];
        
        UILabel *lblSubject = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblSubject.frame = CGRectMake(10, 42, 53, 21);
            lblSubject.font = [UIFont fontWithName:@"NexaBold" size:10.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblSubject.frame = CGRectMake(10, 55, 65, 21);
            lblSubject.font = [UIFont fontWithName:@"NexaBold" size:12.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lblSubject.frame = CGRectMake(10, 48, 65, 21);
            lblSubject.font = [UIFont fontWithName:@"NexaBold" size:11.0];
        }
        lblSubject.text = @"SUBJECT:";
        lblSubject.textColor = lblRGBA(255, 255, 255, 1);
        [view_History_ContentView[tag] addSubview:lblSubject];
        
        UILabel *lblSubjectValue = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblSubjectValue.frame = CGRectMake(73, 42, 247, 21);
            lblSubjectValue.font = [UIFont fontWithName:@"NexaBold" size:10.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblSubjectValue.frame = CGRectMake(85, 55, 329, 21);
            lblSubjectValue.font = [UIFont fontWithName:@"NexaBold" size:12.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lblSubjectValue.frame = CGRectMake(75, 48, 245, 21);
            lblSubjectValue.font = [UIFont fontWithName:@"NexaBold" size:11.0];
        }
        lblSubjectValue.text = [NSString stringWithFormat:@"%@",[[[arrUserHistorySplit objectAtIndex:tag]objectForKey:@"eventType"] objectForKey:@"code"]];
        
        lblSubjectValue.textColor = lblRGBA(184, 184, 184, 1);
        [view_History_ContentView[tag] addSubview:lblSubjectValue];

        UILabel *lblDetails = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblDetails.frame = CGRectMake(10, 75, 48, 21);
            lblDetails.font = [UIFont fontWithName:@"NexaBold" size:10.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblDetails.frame = CGRectMake(10, 99, 59, 21);
            lblDetails.font = [UIFont fontWithName:@"NexaBold" size:12.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lblDetails.frame = CGRectMake(10, 89, 59, 21);
            lblDetails.font = [UIFont fontWithName:@"NexaBold" size:11.0];
        }
        lblDetails.text = @"DETAILS:";
        lblDetails.textColor = lblRGBA(255, 255, 255, 1);
        [view_History_ContentView[tag] addSubview:lblDetails];
        
        UILabel *lblDetailsVal = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblDetailsVal.frame = CGRectMake(73, 75, 247, 21);
            lblDetailsVal.font = [UIFont fontWithName:@"NexaBold" size:10.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblDetailsVal.frame = CGRectMake(85, 99, 322, 21);
            lblDetailsVal.font = [UIFont fontWithName:@"NexaBold" size:12.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lblDetailsVal.frame = CGRectMake(75, 89, 281, 21);
            lblDetailsVal.font = [UIFont fontWithName:@"NexaBold" size:11.0];
        }
        lblDetailsVal.text = [NSString stringWithFormat:@"%@",[[arrUserHistorySplit objectAtIndex:tag] objectForKey:@"eventDesc"]];
        lblDetailsVal.textColor = lblRGBA(184, 184, 184, 1);
        [view_History_ContentView[tag] addSubview:lblDetailsVal];

    }
    @catch (NSException *exception) {
        NSLog(@"Exception draw Contentview ==%@",exception.description);
    }
}

- (void)expandHistory_View_onClick:(UITapGestureRecognizer*)sender {
    UIView *viewCurrent = sender.view;
    int tag_Pos=(int)viewCurrent.tag;
    NSLog(@"tag==%ld",(long)viewCurrent.tag);
    @try {
        if (cellExpandStatus==YES) {
            self.view.userInteractionEnabled=NO;
            [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    menuViewHistory[viewCurrent.tag].frame = CGRectMake(0, menuViewHistory[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 140);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    menuViewHistory[viewCurrent.tag].frame = CGRectMake(0, menuViewHistory[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 177);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                    menuViewHistory[viewCurrent.tag].frame = CGRectMake(0, menuViewHistory[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 158);
                }
                menuViewHistory[viewCurrent.tag].backgroundColor=lblRGBA(99, 100, 102, 1);
                yOffSet_Content=menuViewHistory[viewCurrent.tag].frame.origin.y+menuViewHistory[viewCurrent.tag].frame.size.height;
                for (int index=0;index<[arrHistoryListPerPage count];index++){
                    if (index>[viewCurrent tag]) {
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                            menuViewHistory[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 34);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                            menuViewHistory[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 43);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                            menuViewHistory[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 36);
                        }
                        yOffSet_Content=menuViewHistory[index].frame.origin.y+menuViewHistory[index].frame.size.height;
                    }
                }
                viewTagValue=viewCurrent.tag;
                [self scroll_History_Setup_:yOffSet_Content];
            } completion:^(BOOL finished) {
                [self history_AddWidget:tag_Pos];
                lbl_viewBillingHistory[viewTagValue].text = @"CLOSE";
                cellExpandStatus=NO;
                self.view.userInteractionEnabled=YES;
            }];
        }else{
            if (viewTagValue==viewCurrent.tag) {
                self.view.userInteractionEnabled=NO;
                [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                        menuViewHistory[viewCurrent.tag].frame = CGRectMake(0, menuViewHistory[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 34);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                        menuViewHistory[viewCurrent.tag].frame = CGRectMake(0, menuViewHistory[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 43);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                        menuViewHistory[viewCurrent.tag].frame = CGRectMake(0, menuViewHistory[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 36);
                    }
                    menuViewHistory[viewCurrent.tag].backgroundColor=[UIColor clearColor];
                    yOffSet_Content=menuViewHistory[viewCurrent.tag].frame.origin.y+menuViewHistory[viewCurrent.tag].frame.size.height;
                    for (int index=0;index<[arrHistoryListPerPage count];index++){
                        if (index>[viewCurrent tag]) {
                            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                                menuViewHistory[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 34);
                            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                                menuViewHistory[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 43);
                            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                                menuViewHistory[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 36);
                            }
                            yOffSet_Content=menuViewHistory[index].frame.origin.y+menuViewHistory[index].frame.size.height;
                        }
                    }
                    [self scroll_History_Setup_:yOffSet_Content];
                    lbl_viewBillingHistory[viewTagValue].text = @"VIEW";
                    [view_History_ContentView[viewCurrent.tag] setHidden:YES];
                    [view_History_ContentView[viewCurrent.tag] removeFromSuperview];
                } completion:^(BOOL finished) {
                    self.view.userInteractionEnabled=YES;
                    cellExpandStatus=YES;
                }];
            }else{
                self.view.userInteractionEnabled=NO;
                [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                        menuViewHistory[viewTagValue].frame=CGRectMake(0, menuViewHistory[viewTagValue].frame.origin.y, self.view.frame.size.width, 34);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                        menuViewHistory[viewTagValue].frame=CGRectMake(0, menuViewHistory[viewTagValue].frame.origin.y, self.view.frame.size.width, 43);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                        menuViewHistory[viewTagValue].frame=CGRectMake(0, menuViewHistory[viewTagValue].frame.origin.y, self.view.frame.size.width, 36);
                    }
                    menuViewHistory[viewTagValue].backgroundColor=[UIColor clearColor];
                    yOffSet_Content=menuViewHistory[viewTagValue].frame.origin.y+menuViewHistory[viewTagValue].frame.size.height;
                    lbl_viewBillingHistory[viewTagValue].text = @"VIEW";
                    [view_History_ContentView[viewTagValue] setHidden:YES];
                    [view_History_ContentView[viewTagValue] removeFromSuperview];
                    for (int index=0;index<[arrHistoryListPerPage count];index++){
                        if (index>viewTagValue) {
                            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                                menuViewHistory[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 34);
                            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                                menuViewHistory[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 43);
                            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                                menuViewHistory[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 36);
                            }
                            yOffSet_Content=menuViewHistory[index].frame.origin.y+menuViewHistory[index].frame.size.height;
                        }
                    }
                    
                    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                        menuViewHistory[viewCurrent.tag].frame = CGRectMake(0, menuViewHistory[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 140);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                        menuViewHistory[viewCurrent.tag].frame = CGRectMake(0, menuViewHistory[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 177);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                        menuViewHistory[viewCurrent.tag].frame = CGRectMake(0, menuViewHistory[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 158);
                    }
                    menuViewHistory[viewCurrent.tag].backgroundColor=lblRGBA(99, 100, 102, 1);
                    yOffSet_Content=menuViewHistory[viewCurrent.tag].frame.origin.y+menuViewHistory[viewCurrent.tag].frame.size.height;
                    for (int index=0;index<[arrHistoryListPerPage count];index++){
                        if (index>[viewCurrent tag]) {
                            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                                menuViewHistory[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 34);
                            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                                menuViewHistory[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 43);
                            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                                menuViewHistory[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 36);
                            }
                            yOffSet_Content=menuViewHistory[index].frame.origin.y+menuViewHistory[index].frame.size.height;
                        }
                    }
                    viewTagValue=viewCurrent.tag;
                    [self scroll_History_Setup_:yOffSet_Content];
                } completion:^(BOOL finished) {
                    [self history_AddWidget:tag_Pos];
                    lbl_viewBillingHistory[viewTagValue].text = @"CLOSE";
                    self.view.userInteractionEnabled=YES;
                    cellExpandStatus=NO;
                }];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"expandable exception==%@",exception.description);
    }
}

-(void)scroll_History_Setup_:(float)yAxis{
    scroll_History.contentSize = CGSizeMake(scroll_History.frame.size.width, yAxis);
}

#pragma mark - Billing SetUp

-(void)textfield_WidgetConfiguration_Billing
{
    txtfld_CardName_UpdateCard.delegate=self;
    txtfld_CardNo_UpdateCard.delegate=self;
    txtfld_Month_UpdateCard.delegate=self;
    txtfld_Year_UpdateCard.delegate=self;
    txtfld_zipCode_UpdateCard.delegate=self;
    txtfld_digits_UpdateCard.delegate=self;
    
    txtfld_CardNo_UpdateCard.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_CardName_UpdateCard.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_zipCode_UpdateCard.clearButtonMode = UITextFieldViewModeWhileEditing;

    [txtfld_CardName_UpdateCard setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_CardNo_UpdateCard setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_Month_UpdateCard setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_Year_UpdateCard setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_zipCode_UpdateCard setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_digits_UpdateCard setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"_placeholderLabel.textColor"];
}


/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Remove the tap gesture action
 Method Name : tapGusterSetup(User Defined Methods)
 ************************************************************************************* */
-(void)tapGusterSetup_Settings{
    [settingConatinerView removeGestureRecognizer:tapBodyViewBilling];
    [self.settingHeaderView removeGestureRecognizer:tapheaderViewBilling];
    [self.settingTabView removeGestureRecognizer:tapTabViewBilling];
}

-(void)billingSetup
{
    arrUserBilling_Controller = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dict_Controller_Content=[[NSMutableDictionary alloc] init];
    [dict_Controller_Content setObject:@"CONTROLLER 1" forKey:kControllerName];
    [dict_Controller_Content setObject:@"5 STATIONS" forKey:kControllerStation];
    [arrUserBilling_Controller addObject:dict_Controller_Content];
    
    dict_Controller_Content=[[NSMutableDictionary alloc] init];
    [dict_Controller_Content setObject:@"CONTROLLER 2" forKey:kControllerName];
    [dict_Controller_Content setObject:@"10 STATIONS" forKey:kControllerStation];
    [arrUserBilling_Controller addObject:dict_Controller_Content];
    
    
    dict_Controller_Content=[[NSMutableDictionary alloc] init];
    [dict_Controller_Content setObject:@"CONTROLLER 3" forKey:kControllerName];
    [dict_Controller_Content setObject:@"7 STATIONS" forKey:kControllerStation];
    [arrUserBilling_Controller addObject:dict_Controller_Content];
    
    dict_Controller_Content=[[NSMutableDictionary alloc] init];
    [dict_Controller_Content setObject:@"CONTROLLER 4" forKey:kControllerName];
    [dict_Controller_Content setObject:@"6 STATIONS" forKey:kControllerStation];
    [arrUserBilling_Controller addObject:dict_Controller_Content];
    
    dict_Controller_Content=[[NSMutableDictionary alloc] init];
    [dict_Controller_Content setObject:@"CONTROLLER 5" forKey:kControllerName];
    [dict_Controller_Content setObject:@"2 STATIONS" forKey:kControllerStation];
    [arrUserBilling_Controller addObject:dict_Controller_Content];
    
    [self billing_History_Setup];
    
    [self loadControllerDatas];
}

//-(void)billing_History_Setup{
//    arrBilling_History = [[NSMutableArray alloc] init];
//    
//    NSMutableDictionary *dict_Billing_History=[[NSMutableDictionary alloc] init];
//    [dict_Billing_History setObject:@"05/10/2015 BILLING" forKey:kBillingDate];
//    [dict_Billing_History setObject:@"$100.00" forKey:kBillingRate];
//    [arrBilling_History addObject:dict_Billing_History];
//    
//    dict_Billing_History=[[NSMutableDictionary alloc] init];
//    [dict_Billing_History setObject:@"12/12/2015 BILLING" forKey:kBillingDate];
//    [dict_Billing_History setObject:@"$100.00" forKey:kBillingRate];
//    [arrBilling_History addObject:dict_Billing_History];
//    
//    
//    dict_Billing_History=[[NSMutableDictionary alloc] init];
//    [dict_Billing_History setObject:@"07/15/2015 BILLING" forKey:kBillingDate];
//    [dict_Billing_History setObject:@"$100.00" forKey:kBillingRate];
//    [arrBilling_History addObject:dict_Billing_History];
//    
//    pageindex=0;
//    str_Selected_Tap=@"page1";
//    str_Previous_Tap=@"page1";
//    
//    [btnPage1_billing setBackgroundColor:lblRGBA(255, 206, 52, 1)];
//    [btnPage1_billing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnPage1_billing setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    
//    [btnPage2_billing setBackgroundImage:[UIImage imageNamed:@"grayBoxImage"] forState:UIControlStateNormal];
//    [btnPage2_billing setBackgroundColor:[UIColor clearColor]];
//    [btnPage2_billing setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
//    
//    [btnPageNext_billing setBackgroundColor:lblRGBA(255, 206, 52, 1)];
//    [btnPageNext_billing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnPageNext_billing setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//}

-(void)billing_History_Setup
{
    pageindexBilling=0;
    countPerPageBilling=2;
    scroll_Billing_Main_Container.showsVerticalScrollIndicator=YES;
    scroll_Billing_Main_Container.scrollEnabled=YES;
    scroll_Billing_Main_Container.userInteractionEnabled=YES;
    scroll_Billing_Main_Container.delegate=self;
    scroll_Billing_Main_Container.scrollsToTop=NO;
}

-(void)loadControllerDatas{
    // scroll_Billing_Controller.showsVerticalScrollIndicator=YES;
    //scroll_Billing_Controller.scrollEnabled=YES;
    scroll_Billing_Controller.userInteractionEnabled=YES;
    scroll_Billing_Controller.delegate=self;
    float x_OffsetAlerts=0,h_OffsetAlerts=0,yOffsetAlerts=0.0;
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        h_OffsetAlerts=26;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        h_OffsetAlerts=44;
    }else{
        h_OffsetAlerts=30;
    }

    @try {
        for(int alertIndex=0;alertIndex<[arrUserBilling_Controller count];alertIndex++){
            NSLog(@"array value is ==%@",arrUserBilling_Controller);
            NSLog(@"array value is indi ==%@",[arrUserBilling_Controller objectAtIndex:alertIndex]);
            viewController[alertIndex]=[[UIView alloc] init];
            viewController[alertIndex].frame=CGRectMake(x_OffsetAlerts, yOffsetAlerts, self.settingBillingView.frame.size.width,h_OffsetAlerts);
            if(alertIndex%2==0){
                viewController[alertIndex].backgroundColor=lblRGBA(99, 99, 102, 1);
            }else{
                viewController[alertIndex].backgroundColor=lblRGBA(65, 64, 66, 1);
            }
            viewController[alertIndex].tag=alertIndex;
            [scroll_Billing_Controller addSubview:viewController[alertIndex]];
            
            
            UILabel *lblController_Name = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblController_Name.frame=CGRectMake(21, 0, 142, 26);
                [lblController_Name setFont:[UIFont fontWithName:@"NexaBold" size:10]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblController_Name.frame=CGRectMake(21, 0, 187, 44);
                [lblController_Name setFont:[UIFont fontWithName:@"NexaBold" size:13]];
            }else{
                lblController_Name.frame=CGRectMake(21, 0, 146, 30);
                [lblController_Name setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }
            [lblController_Name setTextColor:lblRGBA(255,255,255, 1)];
            lblController_Name.text =[NSString stringWithFormat:@"%@",[[arrUserBilling_Controller objectAtIndex:alertIndex] valueForKey:@"name"]];
            [viewController[alertIndex] addSubview:lblController_Name];
            
            UILabel *lblStation_Name = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblStation_Name.frame=CGRectMake(197, 0, 91, 26);
                [lblStation_Name setFont:[UIFont fontWithName:@"NexaBold" size:10]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblStation_Name.frame=CGRectMake(222, 0, 143, 44);
                [lblStation_Name setFont:[UIFont fontWithName:@"NexaBold" size:13]];
            }else{
                lblStation_Name.frame=CGRectMake(215, 0, 125, 30);
                [lblStation_Name setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }
            [lblStation_Name setTextColor:lblRGBA(255,206,52, 1)];
            lblStation_Name.textAlignment = NSTextAlignmentRight;
            lblStation_Name.text =[NSString stringWithFormat:@"%@ STATIONS",[[arrUserBilling_Controller objectAtIndex:alertIndex] valueForKey:@"stations"]];
            [viewController[alertIndex] addSubview:lblStation_Name];
            
            
            UIButton *btnClose_Contianer=[UIButton buttonWithType:UIButtonTypeCustom];
            [btnClose_Contianer setImage:[UIImage imageNamed:@"PopupClose"] forState:UIControlStateNormal];
            [btnClose_Contianer setTag:alertIndex];
            [btnClose_Contianer addTarget:self action:@selector(close_Controller_Action:) forControlEvents:UIControlEventTouchUpInside];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btnClose_Contianer.frame = CGRectMake(294,0,25, 25);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btnClose_Contianer.frame = CGRectMake(367,0,44, 44);
            }else{
                btnClose_Contianer.frame = CGRectMake(344,0,30, 30);
            }
            [viewController[alertIndex] addSubview:btnClose_Contianer];
            
            //settings_close
            
            //
            
            yOffsetAlerts=viewController[alertIndex].frame.size.height+viewController[alertIndex].frame.origin.y;
        }
        scroll_Billing_Controller.frame=CGRectMake(scroll_Billing_Controller.frame.origin.x, scroll_Billing_Controller.frame.origin.y, scroll_Billing_Controller.frame.size.width, yOffsetAlerts);
        
        @try {
            yOffsetAlerts=self.scroll_Billing_Controller.frame.origin.y+self.scroll_Billing_Controller.frame.size.height+10;
            self.viewController_Plan.frame=CGRectMake(self.viewController_Plan.frame.origin.x, yOffsetAlerts, self.viewController_Plan.frame.size.width, self.viewController_Plan.frame.size.height);
            self.viewBilling_History.frame=CGRectMake(self.viewBilling_History.frame.origin.x, self.viewController_Plan.frame.origin.y+self.viewController_Plan.frame.size.height, self.viewBilling_History.frame.size.width, self.viewBilling_History.frame.size.height);
            yOffsetAlerts=self.viewBilling_History.frame.origin.y+self.viewBilling_History.frame.size.height+10;
            self.scroll_Billing_Main_Container.contentSize=CGSizeMake(self.scroll_Billing_Main_Container.frame.size.width,yOffsetAlerts);
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
}

-(void)loadBilling_HistoryDatas:(NSArray *)arrBillingContent{
    @try {
        NSLog(@"array==%@",arrBillingContent);
        NSLog(@"array count==%lu",(unsigned long)arrBillingContent.count);
        scroll_Billing_History.userInteractionEnabled=YES;
        scroll_Billing_History.delegate=self;
        float y_billing=0.0;
        for(int alertIndex=0;alertIndex<[arrBillingContent count];alertIndex++){
            NSLog(@"array value is ==%@",arrBillingContent);
            NSLog(@"array value is indi ==%@",[arrBillingContent objectAtIndex:alertIndex]);
            UIView *menuview_Billing_History=[[UIView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                menuview_Billing_History.frame=CGRectMake(0, y_billing, self.settingBillingView.frame.size.width,26);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                menuview_Billing_History.frame=CGRectMake(0, y_billing, self.settingBillingView.frame.size.width,44);
            }else{
                menuview_Billing_History.frame=CGRectMake(0, y_billing, self.settingBillingView.frame.size.width,30);
            }
            menuview_Billing_History.backgroundColor=[UIColor clearColor];
            [scroll_Billing_History addSubview:menuview_Billing_History];
            
            NSTimeInterval date =[[NSString stringWithFormat:@"%@",[[arrBillingContent objectAtIndex:alertIndex] objectForKey:@"billingDate"]] doubleValue];
            NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:date/1000];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"MM/dd/YY"];
            [dateFormatter setDateFormat:[Common GetCurrentDateFormat]];
           // [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:strTimeZoneIDFor_User]];
            NSString *timestamp = [dateFormatter stringFromDate:epochNSDate];

            UILabel *lblBillng_Date = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblBillng_Date.frame=CGRectMake(21, 0, 142, 26);
                [lblBillng_Date setFont:[UIFont fontWithName:@"NexaBold" size:10]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblBillng_Date.frame=CGRectMake(21, 0, 196, 44);
                [lblBillng_Date setFont:[UIFont fontWithName:@"NexaBold" size:13]];
            }else{
                lblBillng_Date.frame=CGRectMake(21, 0, 150, 30);
                [lblBillng_Date setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }
            [lblBillng_Date setTextColor:lblRGBA(255,255,255, 1)];
            lblBillng_Date.text =[NSString stringWithFormat:@"%@",timestamp];
            [menuview_Billing_History addSubview:lblBillng_Date];
            
            UILabel *lblBilling_Rate = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblBilling_Rate.frame=CGRectMake(233, 0, 65, 26);
                [lblBilling_Rate setFont:[UIFont fontWithName:@"NexaBold" size:10]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblBilling_Rate.frame=CGRectMake(295, 0, 92, 44);
                [lblBilling_Rate setFont:[UIFont fontWithName:@"NexaBold" size:13]];
            }else{
                lblBilling_Rate.frame=CGRectMake(266, 0, 82, 30);
                [lblBilling_Rate setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }
            [lblBilling_Rate setTextColor:lblRGBA(255,206,52, 1)];
            lblBilling_Rate.text =[NSString stringWithFormat:@"$%.2f",fabs([[[arrBillingContent objectAtIndex:alertIndex] objectForKey:@"amount"] floatValue])];
            lblBilling_Rate.textAlignment=NSTextAlignmentRight;
            [menuview_Billing_History addSubview:lblBilling_Rate];
            
            UIView *divier_Billing=[[UIView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                divier_Billing.frame=CGRectMake(0, 25, self.settingBillingView.frame.size.width, 1);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                divier_Billing.frame=CGRectMake(0, 43, self.settingBillingView.frame.size.width, 1);
            }else{
                divier_Billing.frame=CGRectMake(0, 29, self.settingBillingView.frame.size.width, 1);
            }
            divier_Billing.backgroundColor=lblRGBA(77, 77, 79, 1);
            [menuview_Billing_History addSubview:divier_Billing];
            
            y_billing=menuview_Billing_History.frame.size.height+menuview_Billing_History.frame.origin.y;
        }
        scroll_Billing_History.contentSize=CGSizeMake(scroll_Billing_History.frame.size.width, y_billing);
        if(billingHistoryStatus==YES){
            [self rendering_Pagination_Billing_History_Buttons];
            [self setupFooter_UserBillingHistory];
            billingHistoryStatus=NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
}

-(void)close_Controller_Action:(UIButton *)sender{
    controllerTag = (int)sender.tag;
    NSLog(@"tag==%d",controllerTag);
    [alertView_Billing setHidden:NO];
    [self popup_Settings_Alpha_Disabled];
    strController_NetworkID = [[[arrUserBilling_Controller objectAtIndex:sender.tag] objectForKey:@"networkId"] stringValue];
    strController_ContollerID = [[[arrUserBilling_Controller objectAtIndex:sender.tag] objectForKey:@"id"] stringValue];
    NSLog(@"network id==%@",strController_NetworkID);
}


-(void)popup_Settings_Alpha_Enabled{
    [settingConatinerView setAlpha:1.0];
    [settingTabView setAlpha:1.0];
    [settingHeaderView setAlpha:1.0];
}
-(void)popup_Settings_Alpha_Disabled{
    [settingConatinerView setAlpha:0.6];
    [settingTabView setAlpha:0.6];
    [settingHeaderView setAlpha:0.6];
}

-(void)rendering_Pagination_Billing_History_Buttons
{
    float xAxis=0.0;
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        xAxis=74;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        xAxis=106;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        xAxis=98;
    }
    for(int index=1;index<=TotalPageBilling;index++){
        btnBillingHistory_Page[index]=[UIButton buttonWithType:UIButtonTypeCustom];
        btnBillingHistory_Page[index].frame=CGRectMake(xAxis,5.0,30.0,30.0);
        [btnBillingHistory_Page[index] setBackgroundColor:[UIColor clearColor]];
        [btnBillingHistory_Page[index].titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
        btnBillingHistory_Page[index].tag=index;
        [btnBillingHistory_Page[index] setTitle:[NSString stringWithFormat:@"%d",index] forState:UIControlStateNormal];
        if(index==1)
        {
            [btnBillingHistory_Page[index] setBackgroundColor:lblRGBA(255, 206, 52, 1)];
            [btnBillingHistory_Page[index] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            currentIndexBilling=index;
            PreviousIndexBilling=index;
        }else{
            [btnBillingHistory_Page[index] setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            [btnBillingHistory_Page[index] setBackgroundImage:[UIImage imageNamed:@"grayBoxImage"] forState:UIControlStateNormal];
        }
        [btnBillingHistory_Page[index] addTarget:self action:@selector(billing_HistoryPaginationTapped:) forControlEvents:UIControlEventTouchUpInside];
        [viewFooter_BillingHistory addSubview:btnBillingHistory_Page[index]];
        if(index%5==0){
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                xAxis=74;
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                xAxis=106;
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                xAxis=98;
            }
        }else{
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                xAxis=btnBillingHistory_Page[index].frame.origin.x+btnBillingHistory_Page[index].frame.size.width+5;
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                xAxis=btnBillingHistory_Page[index].frame.origin.x+btnBillingHistory_Page[index].frame.size.width+10;
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                xAxis=btnBillingHistory_Page[index].frame.origin.x+btnBillingHistory_Page[index].frame.size.width+8;
            }
        }
        if(index>5){
            btnBillingHistory_Page[index].hidden=YES;
        }
    }
}

-(void)billing_HistoryPaginationTapped:(UIButton*)button
{
    currentIndexBilling=(int)button.tag;
    if(currentIndexBilling==PreviousIndexBilling)
    {
        return;
    }
    if(currentIndexBilling==1)
    {
        [btnPagePrev_Billing setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        [btnPagePrev_Billing setBackgroundColor:[UIColor clearColor]];
        [btnPagePrev_Billing setBackgroundImage:[UIImage imageNamed:@"bigGrayBoxImage"] forState:UIControlStateNormal];
        btnPagePrev_Billing.userInteractionEnabled=NO;
    }else{
        [btnPagePrev_Billing setBackgroundColor:lblRGBA(255, 206, 52, 1)];
        [btnPagePrev_Billing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnPagePrev_Billing setBackgroundImage:nil forState:UIControlStateNormal];
        [self.scroll_Billing_History.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        btnPagePrev_Billing.userInteractionEnabled=YES;
    }
    if(currentIndexBilling==TotalPageBilling)
    {
        [btnPageNext_billing setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        [btnPageNext_billing setBackgroundColor:[UIColor clearColor]];
        [btnPageNext_billing setBackgroundImage:[UIImage imageNamed:@"bigGrayBoxImage"] forState:UIControlStateNormal];
        btnPageNext_billing.userInteractionEnabled=NO;
    }else{
        [btnPageNext_billing setBackgroundColor:lblRGBA(255, 206, 52, 1)];
        [btnPageNext_billing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnPageNext_billing setBackgroundImage:nil forState:UIControlStateNormal];
        btnPageNext_billing.userInteractionEnabled=YES;
    }
    [btnBillingHistory_Page[PreviousIndexBilling] setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
    [btnBillingHistory_Page[PreviousIndexBilling] setBackgroundColor:[UIColor clearColor]];
    [btnBillingHistory_Page[PreviousIndexBilling] setBackgroundImage:[UIImage imageNamed:@"grayBoxImage"] forState:UIControlStateNormal];
    
    [btnBillingHistory_Page[currentIndexBilling] setBackgroundColor:lblRGBA(255, 206, 52, 1)];
    [btnBillingHistory_Page[currentIndexBilling] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnBillingHistory_Page[currentIndexBilling] setBackgroundImage:nil forState:UIControlStateNormal];
    [self.scroll_Billing_History.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    pageindexBilling=button.tag-1;
    NSUInteger start = countPerPageBilling * pageindexBilling;
    NSRange range = NSMakeRange(start, MIN([arrBilling_History count] - start, countPerPageBilling));
    arrBillingHistorySplit = [arrBilling_History subarrayWithRange:range];
    PreviousIndexBilling=currentIndexBilling;
    [self loadBilling_HistoryDatas:arrBillingHistorySplit];
}

-(void)setupFooter_UserBillingHistory
{
    if(TotalPageBilling>1){
        self.viewFooter_BillingHistory.hidden=NO;
        btnPagePrev_Billing.userInteractionEnabled=NO;
        btnPageNext_billing.userInteractionEnabled=YES;
    }else{
        self.viewFooter_BillingHistory.hidden=YES;
    }
}

-(void)set_PlanOption_Gesture_Settings
{
    tapScrollCellular = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapScroll_Setting_Actions:)];
    [scrollView_PlanCard addGestureRecognizer:tapScrollCellular];
    
    tapPlanOptionCellular = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapPlan_Setting_Actions:)];
    [viewPlan addGestureRecognizer:tapPlanOptionCellular];
}

-(void)ViewTapScroll_Setting_Actions:(UITapGestureRecognizer *)recognizer
{
    [self hidePlanOptionView];
}

-(void)ViewTapPlan_Setting_Actions:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"view touch");
}
-(void)removeGesture_PlanOption_Settings
{
    [scrollView_PlanCard removeGestureRecognizer:tapScrollCellular];
    [viewPlan removeGestureRecognizer:tapPlanOptionCellular];
}
-(void)planCardScrollSetupSettings
{
    scrollView_PlanCard .showsHorizontalScrollIndicator=NO;
    scrollView_PlanCard.showsVerticalScrollIndicator=NO;
    scrollView_PlanCard.scrollEnabled=YES;
    scrollView_PlanCard.userInteractionEnabled=YES;
    scrollView_PlanCard.delegate=self;
}
-(void)planCardOptionScrollSetupSettings{
    scrollView_Planoptions .showsHorizontalScrollIndicator=NO;
    scrollView_Planoptions.showsVerticalScrollIndicator=NO;
    scrollView_Planoptions.scrollEnabled=YES;
    scrollView_Planoptions.userInteractionEnabled=YES;
    scrollView_Planoptions.delegate=self;
}
-(void)saveCardDetails
{
    if([strPaymentType isEqualToString:@"VISA"]){
        imgView_CC_Logo.image=[UIImage imageNamed:@"visaUpdateCardImagei6plus"];
    }
    else if([strPaymentType isEqualToString:@"MASTRO"]){
        imgView_CC_Logo.image=[UIImage imageNamed:@"masterCardImagei6plus"];
    }
    else if([strPaymentType isEqualToString:@"DISCOVER"]){
        imgView_CC_Logo.image=[UIImage imageNamed:@"discoverImagei6plus"];
    }
    else if([strPaymentType isEqualToString:@"AMERICAN"]){
        imgView_CC_Logo.image=[UIImage imageNamed:@"americanExImagei6plus"];
    }
    lbl_CC_Name.text=txtfld_CardName_UpdateCard.text;
    lbl_CC_Number.text=[Common secureCreditCardNumber:txtfld_CardNo_UpdateCard.text];
    lbl_CC_ExpiryDate.text=[NSString stringWithFormat:@"EXPIRY %@/%@",txtfld_Month_UpdateCard.text,txtfld_Year_UpdateCard.text];
    strCredit_Card_Added_Status=@"YES";
    str_SVD_PaymentType=strPaymentType;
    str_SVD_CardName=txtfld_CardName_UpdateCard.text;
    str_SVD_CardNumber=txtfld_CardNo_UpdateCard.text;
    str_SVD_Month=txtfld_Month_UpdateCard.text;
    str_SVD_Year=txtfld_Year_UpdateCard.text;
    str_SVD_CSC_Digits=txtfld_digits_UpdateCard.text;
    str_SVD_ZipCode=txtfld_zipCode_UpdateCard.text;
    NSLog(@"pay=%@",str_SVD_PaymentType);
    NSLog(@"pay=%@",str_SVD_CardName);
    NSLog(@"pay=%@",str_SVD_CardNumber);
    NSLog(@"pay=%@",str_SVD_Month);
    NSLog(@"pay=%@",str_SVD_Year);
    NSLog(@"pay=%@",str_SVD_CSC_Digits);
    NSLog(@"pay=%@",str_SVD_ZipCode);
    orgCardFlag=YES;
    [self hidePlanOptionView];
    [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
}

-(void)setPlan_Payment_OptionGusters{
    tapGusters_Container = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBody_Guster_Actions:)];
    [self.settingConatinerView addGestureRecognizer:tapGusters_Container];
    tapGuster_Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap_Guster_Actions:)];
    [self.settingTabView addGestureRecognizer:tapGuster_Tap];
    tapGuster_Header = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewHeader_Guster_Actions:)];
    [self.settingHeaderView addGestureRecognizer:tapGuster_Header];
}
-(void)viewBody_Guster_Actions:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"claling");
    [self hidePlanOptionView];
}
-(void)viewSlider_Guster_Actions:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"claling");
    [self hidePlanOptionView];
}

-(void)viewHeader_Guster_Actions:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"claling");
    [self hidePlanOptionView];
}
-(void)swipeGestureBilling
{
    swipeDown_planoption = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe_planOption:)];
    [swipeDown_planoption setDirection:UISwipeGestureRecognizerDirectionDown];
    
    swipeDown_planoption_View = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe_planOption_View:)];
    
    [swipeDown_planoption_View setDirection:UISwipeGestureRecognizerDirectionDown];
    
    if([strAlert_Type isEqualToString:@"Plan"]){
        //  [btn_SwipeDown_Plan addGestureRecognizer:swipeDown_planoption];
        //[view_SwipeDown_Plan addGestureRecognizer:swipeDown_planoption_View];
    }else{
        [btn_SwipeDown_Payment addGestureRecognizer:swipeDown_planoption];
        [view_SwipeDown_Payment addGestureRecognizer:swipeDown_planoption_View];
    }
    
}
- (void)handleSwipe_planOption:(UISwipeGestureRecognizer *)swipe {
    [self hidePlanOptionView];
    if([strAlert_Type isEqualToString:@"Plan"]){
        // [self.btn_SwipeDown_Plan removeGestureRecognizer:swipeDown_planoption];
    }else{
        [self.btn_SwipeDown_Payment removeGestureRecognizer:swipeDown_planoption];
    }
    
}
- (void)handleSwipe_planOption_View:(UISwipeGestureRecognizer *)swipe {
    [self hidePlanOptionView];
    if([strAlert_Type isEqualToString:@"Plan"]){
        // [self.view_SwipeDown_Plan removeGestureRecognizer:swipeDown_planoption];
    }else{
        [self.view_SwipeDown_Payment removeGestureRecognizer:swipeDown_planoption];
    }
    
}
-(void)viewTap_Guster_Actions:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"claling");
    [self hidePlanOptionView];
}
-(void)hidePlanOptionView{
    
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.5];
    //  self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    if([strAlert_Type isEqualToString:@"Plan"]){
        self.scrollView_PlanCard.frame  = CGRectMake(self.scrollView_PlanCard.frame.origin.x, 1500,self.scrollView_PlanCard.frame.size.width,self.scrollView_PlanCard.frame.size.height);
        self.scrollView_PlanCard.contentOffset=CGPointMake(0,0);
        self.scrollView_Planoptions.contentOffset=CGPointMake(0,0);
        [self removeGesture_PlanOption_Settings];
    }else{
        self.scrollUpdateCard.contentOffset = CGPointZero;
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        viewPayment_Alert.frame  = CGRectMake(viewPayment_Alert.frame.origin.x, 1500,viewPayment_Alert.frame.size.width,viewPayment_Alert.frame.size.height);
        if([strCredit_Card_Added_Status isEqualToString:@"YES"]){
            NSLog(@"pay=%@",str_SVD_PaymentType);
            NSLog(@"pay=%@",str_SVD_CardName);
            NSLog(@"pay=%@",str_SVD_CardNumber);
            NSLog(@"pay=%@",str_SVD_Month);
            NSLog(@"pay=%@",str_SVD_Year);
            NSLog(@"pay=%@",str_SVD_CSC_Digits);
            NSLog(@"pay=%@",str_SVD_ZipCode);
            strPaymentType=str_SVD_PaymentType;
            txtfld_CardName_UpdateCard.text=str_SVD_CardName;
            txtfld_CardNo_UpdateCard.text=str_SVD_CardNumber;
            txtfld_Month_UpdateCard.text=str_SVD_Month;
            txtfld_Year_UpdateCard.text=str_SVD_Year;
            txtfld_digits_UpdateCard.text=str_SVD_CSC_Digits;
            txtfld_zipCode_UpdateCard.text=str_SVD_ZipCode;
            txtfld_digits_UpdateCard.userInteractionEnabled=YES;
            txtfld_digits_UpdateCard.alpha=1.0;
            
            if(orgCardFlag==YES){
                cardNumber_Billing_Flag=YES;
                if([strPaymentType isEqualToString:@"VISA"]){
                    imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_On"];
                    imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_Off"];
                    imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_Off"];
                    imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_Off"];
                    txtfld_digits_UpdateCard.placeholder = @"CVV2 (3 DIGITS)";
                }
                else if([strPaymentType isEqualToString:@"MASTRO"]){
                    imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_On"];
                    imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_Off"];
                    imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_Off"];
                    imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_Off"];
                    txtfld_digits_UpdateCard.placeholder = @"CVC2 (3 DIGITS)";
                }
                else if([strPaymentType isEqualToString:@"DISCOVER"]){
                    imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_On"];
                    imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_Off"];
                    imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_Off"];
                    imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_Off"];
                    txtfld_digits_UpdateCard.placeholder = @"CID (3 DIGITS)";
                }
                else if([strPaymentType isEqualToString:@"AMERICAN"]){
                    imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_On"];
                    imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_Off"];
                    imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_Off"];
                    imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_Off"];
                    txtfld_digits_UpdateCard.placeholder = @"CID (4 DIGITS)";
                }
            }else{
                cardNumber_Billing_Flag=NO;
                imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_Off"];
                imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_Off"];
                imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_Off"];
                imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_Off"];
            }
            month_Billing_Flag=YES;
            year_Billing_Flag=YES;
            cscDigits_Billing_Flag=YES;
            zipcode_Billing_Flag=YES;
        }
        
    }
    [UIView commitAnimations];
    [self setUserInteraction_Settings_Enalbed];
}

-(void)delete_DataPlan_Action:(UIButton *)sender
{
    [alertView_Billing setHidden:NO];
    [settingConatinerView setAlpha:0.6];
    [settingTabView setAlpha:0.6];
}

#pragma mark - Textfield Delegates
/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the textfield is selected.
 Method Name : textFieldShouldBeginEditing(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"%f",textField.frame.origin.y);
    if ([selected_Settings_Tab isEqualToString:@"UserManagement"]) {
        current_textfield_Usermanage = textField;
        if (current_textfield_Usermanage==txtfld_email_userManagement || current_textfield_Usermanage==txtfld_Fname_userManagement || current_textfield_Usermanage==txtfld_Lname_userManagement) {
            [self PreviousNextButtons_UserMgmt];
//            if ([[Common deviceType] isEqualToString:@"iPhone5"]){
//                self.view.frame=CGRectMake(0, -70, self.view.frame.size.width, self.view.frame.size.height);
//            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                self.view.frame=CGRectMake(0, -30, self.view.frame.size.width, self.view.frame.size.height);
//            }else{
//                self.view.frame=CGRectMake(0, -40, self.view.frame.size.width, self.view.frame.size.height);
//            }
        }else{
            [self PreviousNextButtons_UserMgmt_UserAcc];
            [bodyViewScroll_UserManage setContentOffset:CGPointMake(0, user_Acc_View_Mgt.frame.origin.y+scroll_UserMgt_UserAcc.frame.origin.y+menu_User_Acc[tag_PosAcc].frame.origin.y+txt_AccName[tag_PosAcc].frame.origin.y) animated:NO];
        }
    }else if([strAlert_Type isEqualToString:@"Payment"]){
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            self.view.frame=CGRectMake(0, -40, self.view.frame.size.width, self.view.frame.size.height);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            self.view.frame=CGRectMake(0, -10, self.view.frame.size.width, self.view.frame.size.height);
        }else{
            self.view.frame=CGRectMake(0, -15, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
    return YES;
}

/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the textfield is selected.
 Method Name : textFieldDidBeginEditing(Pre Defined Method)
 ************************************************************************************* */

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    current_textfield_Billing=textField;
    [self.keyboardControls_Billing setActiveField:textField];
    if([selected_Settings_Tab isEqualToString:@"Billing"])
    {
        [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            if(current_textfield_Billing==txtfld_CardNo_UpdateCard||current_textfield_Billing==txtfld_CardName_UpdateCard){
                self.scrollUpdateCard.contentOffset = CGPointZero;
            }else if(current_textfield_Billing==txtfld_zipCode_UpdateCard){
                self.scrollUpdateCard.contentOffset = CGPointMake(0, current_textfield_Billing.frame.origin.y+100);
            }else{
                self.scrollUpdateCard.contentOffset = CGPointMake(0, current_textfield_Billing.frame.origin.y+100);
            }
        } completion:^(BOOL finished) {
        }];
    }else if ([selected_Settings_Tab isEqualToString:@"UserManagement"]){
        if(current_textfield_Billing == txtfld_Fname_userManagement||current_textfield_Billing == txtfld_Lname_userManagement)
        {
            if([strNameStatus isEqualToString:@"YES"])
            {
                strNameStatus=@"NO";
                //firstName_Flag=NO;
                //[self resizeWidgets];
                self.lblName_UM.hidden=YES;
                self.imgView_Name_UM.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
            if([strLastNameStatus isEqualToString:@"YES"])
            {
                strLastNameStatus=@"NO";
                // lastName_Flag=NO;
                // [self resizeWidgets];
                self.lblLastName_UM.hidden=YES;
                self.imgView_Name_UM.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
        }
        else if(current_textfield_Billing == txtfld_email_userManagement)
        {
            if([strEmailStatus isEqualToString:@"YES"]){
                strEmailStatus=@"NO";
                self.lblEmail_UM.hidden=YES;
                //  [self resizeWidgets];
                self.imgView_Email_UM.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
        }
    }
    else{
        if(current_textfield_Billing==txtfld_name_settings){
            if ([txtfld_email_settings resignFirstResponder]) {
                [txtfld_email_settings resignFirstResponder];
            }else if ([txtfld_Lname_settings resignFirstResponder]) {
                [txtfld_Lname_settings resignFirstResponder];
            }
        }
        else if(current_textfield_Billing==txtfld_Lname_settings){
            if ([txtfld_email_settings resignFirstResponder]) {
                [txtfld_email_settings resignFirstResponder];
            }else if ([txtfld_name_settings resignFirstResponder]) {
                [txtfld_name_settings resignFirstResponder];
            }
        }
        else if(current_textfield_Billing==txtfld_email_settings){
            if ([txtfld_Lname_settings resignFirstResponder]) {
                [txtfld_Lname_settings resignFirstResponder];
            }else if ([txtfld_name_settings resignFirstResponder]) {
                [txtfld_name_settings resignFirstResponder];
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int fieldLength=20;
    if ((range.location == 0 && [string isEqualToString:@" "]))
    {
        return NO;
    }
    NSLog(@"string === %@",string);
    NSString * proposedNewString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"whole string === %@",proposedNewString);
    if(current_textfield_Billing == txtfld_CardNo_UpdateCard){
        NSUInteger newLength = [txtfld_CardNo_UpdateCard.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSNumbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if([strPaymentType isEqualToString:@"VISA"]){
            fieldLength=visaCardLimit;
        }
        else if([strPaymentType isEqualToString:@"MASTRO"]){
            fieldLength=masterCardLimit;
        }
        else if([strPaymentType isEqualToString:@"DISCOVER"]){
            fieldLength=discoverCardLimit;
        }
        else if([strPaymentType isEqualToString:@"AMERICAN"]){
            fieldLength=americanCardLimit;
        }
        return (([string isEqualToString:filtered])&&(newLength <= fieldLength));
    }
    else if(current_textfield_Billing==txtfld_digits_UpdateCard){
        NSUInteger newLength = [txtfld_digits_UpdateCard.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSNumbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if([strPaymentType isEqualToString:@"VISA"]||[strPaymentType isEqualToString:@"MASTRO"]||[strPaymentType isEqualToString:@"DISCOVER"]){
            fieldLength=3;
        }
        else if([strPaymentType isEqualToString:@"AMERICAN"]){
            fieldLength=4;
        }
        return (([string isEqualToString:filtered])&&(newLength <= fieldLength));
    }
    else if(current_textfield_Billing==txtfld_Month_UpdateCard){
        NSUInteger newLength = [txtfld_Month_UpdateCard.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSNumbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldMonthLimit));
    }
    else if(current_textfield_Billing==txtfld_Year_UpdateCard){
        NSUInteger newLength = [txtfld_Year_UpdateCard.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSNumbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldYearLimit));
    }
    else if(current_textfield_Billing==txtfld_zipCode_UpdateCard){
        NSUInteger newLength = [txtfld_zipCode_UpdateCard.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSZIPCODEBILLING] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= zipcodeBillingLimit));
    }
    else if(current_textfield_Billing==txtfld_CardName_UpdateCard){
        NSUInteger newLength = [txtfld_CardName_UpdateCard.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSNAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldNameLimit));
    }
    else if(textField==txtfld_name_settings){
        if (range.location == 0 && [string isEqualToString:@"'"]) {
            return NO;
        }
        NSUInteger newLength = [txtfld_name_settings.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSNAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldNameLimit));
    }
    else if(textField==txtfld_Lname_settings){
        if (range.location == 0 && [string isEqualToString:@"'"]) {
            return NO;
        }
        NSUInteger newLength = [txtfld_Lname_settings.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSNAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldNameLimit));
    }else if(textField==txtfld_Fname_userManagement){
        if (range.location == 0 && [string isEqualToString:@"'"]) {
            return NO;
        }
        NSUInteger newLength = [txtfld_Fname_userManagement.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSNAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        //return (([string isEqualToString:filtered])&&(newLength <= UnitfieldNameLimit));
        if(([string isEqualToString:filtered])&&(newLength <= UnitfieldNameLimit))
        {
            int nameCount=(int)[proposedNewString length];
            if(nameCount==0){
                // firstName_Flag=NO;
                // [self checkRegisterationValidation];
                self.imgView_Name_UM.backgroundColor=lblRGBA(255, 206, 52, 1);
                return YES;
            }else{
                if(self.txtfld_Lname_userManagement.text.length>0){
                    self.imgView_Name_UM.backgroundColor=lblRGBA(136, 197, 65, 1);
                }
                // firstName_Flag=YES;
                // [self checkRegisterationValidation];
                return YES;
            }
            
        }else{
            return NO;
        }
    }
    else if(textField==txtfld_Lname_userManagement){
        if (range.location == 0 && [string isEqualToString:@"'"]) {
            return NO;
        }
        NSUInteger newLength = [txtfld_Lname_userManagement.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSNAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        // return (([string isEqualToString:filtered])&&(newLength <= UnitfieldNameLimit));
        if(([string isEqualToString:filtered])&&(newLength <= UnitfieldNameLimit))
        {
            
            int nameCount=(int)[proposedNewString length];
            if(nameCount==0){
                // lastName_Flag=NO;
                //[self checkRegisterationValidation];
                self.imgView_Name_UM.backgroundColor=lblRGBA(255, 206, 52, 1);
                return YES;
            }else{
                if(self.txtfld_Fname_userManagement.text.length>0){
                    self.imgView_Name_UM.backgroundColor=lblRGBA(136, 197, 65, 1);
                }
                //  lastName_Flag=YES;
                // [self checkRegisterationValidation];
                
                return YES;
            }
        }else{
            return NO;
        }
    }
    else if(textField == txtfld_email_userManagement){
        if([[self emailValidationSettings:proposedNewString] isEqualToString:@"NO"]){
            mail_Flag=NO;
            //[self tempHideRegInteraction];
            int mailCount=(int)[proposedNewString length];
            if(mailCount==0){
                strEmailStatus=@"NO";
                self.lblEmail_UM.hidden=YES;
                self.imgView_Email_UM.backgroundColor=lblRGBA(255, 206, 52, 1);
                return YES;
            }
            self.imgView_Email_UM.backgroundColor=lblRGBA(255, 206, 52, 1);
            NSLog(@"Please Enter Valid Email Address");
            strEmailStatus=@"NO";
        }else{
            mail_Flag=YES;
            // [self checkRegisterationValidation];
            self.imgView_Email_UM.backgroundColor=lblRGBA(136, 197, 65, 1);
        }
    }else if(textField==txt_AccName[tag_PosAcc]){
        if (range.location == 0 && [string isEqualToString:@"'"]) {
            return NO;
        }
        NSUInteger newLength = [txt_AccName[tag_PosAcc].text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSNAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        // return (([string isEqualToString:filtered])&&(newLength <= UnitfieldNameLimit));
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldNameLimit));
    }else if (textField==txt_AccLName[tag_PosAcc]){
        if (range.location == 0 && [string isEqualToString:@"'"]) {
            return NO;
        }
        NSUInteger newLength = [txt_AccLName[tag_PosAcc].text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSNAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        // return (([string isEqualToString:filtered])&&(newLength <= UnitfieldNameLimit));
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldNameLimit));
    }
    return YES;
}

/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the return button on the keyboard is clicked
 Method Name : textFieldShouldReturn(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([selected_Settings_Tab isEqualToString:@"UserManagement"]) {
        [self.bodyViewScroll_UserManage setContentOffset:CGPointZero animated:YES];
    }
//    else{
        self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }
    return YES;
}

//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    if ([selected_Settings_Tab isEqualToString:@"ManageUsers"]) {
//        [tableView_UserManagement setContentOffset:CGPointZero animated:YES];
//    }
//    return YES;
//}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(current_textfield_Billing == txtfld_email_userManagement)
    {
        if(txtfld_email_userManagement.text.length==0 ||mail_Flag==NO){
            mail_Flag=NO;
            strEmailStatus=@"YES";
            //  [self resizeWidgets];
            self.lblEmail_UM.hidden=NO;
            self.imgView_Email_UM.backgroundColor=lblRGBA(211, 7, 25, 1);
        }
    }
    else if(current_textfield_Billing == txtfld_Fname_userManagement){
        if(txtfld_Fname_userManagement.text.length==0)
        {
            strNameStatus=@"YES";
            // firstName_Flag=NO;
            // [self resizeWidgets];
            self.lblName_UM.hidden=NO;
            self.imgView_Name_UM.backgroundColor=lblRGBA(211, 7, 25, 1);
        }
        if(txtfld_Lname_userManagement.text.length==0)
        {
            strLastNameStatus=@"YES";
            // lastName_Flag=NO;
            // [self resizeWidgets];
            self.lblLastName_UM.hidden=NO;
            self.imgView_Name_UM.backgroundColor=lblRGBA(211, 7, 25, 1);
        }
    }
    else if(current_textfield_Billing == txtfld_Lname_userManagement){
        if(txtfld_Lname_userManagement.text.length==0)
        {
            strLastNameStatus=@"YES";
            // lastName_Flag=NO;
            // [self resizeWidgets];
            self.lblLastName_UM.hidden=NO;
            self.imgView_Name_UM.backgroundColor=lblRGBA(211, 7, 25, 1);
        }
        if(txtfld_Fname_userManagement.text.length==0)
        {
            strNameStatus=@"YES";
            //[self resizeWidgets];
            self.lblName_UM.hidden=NO;
            self.imgView_Name_UM.backgroundColor=lblRGBA(211, 7, 25, 1);
        }
    }else if(current_textfield_Billing==txtfld_Month_UpdateCard){
        if(txtfld_Month_UpdateCard.text.length==1)
        {
            txtfld_Month_UpdateCard.text=[NSString stringWithFormat:@"0%@",txtfld_Month_UpdateCard.text];
        }
    }
     return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    current_textfield_Billing=textField;
    if(current_textfield_Billing==txtfld_CardNo_UpdateCard){
        txtfld_CardNo_UpdateCard.text=@"";
        txtfld_digits_UpdateCard.placeholder=@"";
        strPaymentType=@"";
        imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_Off"];
        imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_Off"];
        imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_Off"];
        imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_Off"];
    }
    else if(current_textfield_Billing == txtfld_Fname_userManagement)
    {
        textField.text=@"";
        strNameStatus=@"NO";
        self.lblName_UM.hidden=YES;
        self.imgView_Name_UM.backgroundColor=lblRGBA(255, 206, 52, 1);
    }
    else if(current_textfield_Billing == txtfld_Lname_userManagement)
    {
        textField.text=@"";
        strLastNameStatus=@"NO";
        self.lblLastName_UM.hidden=YES;
        self.imgView_Name_UM.backgroundColor=lblRGBA(255, 206, 52, 1);
    }
    else if(current_textfield_Billing == txtfld_email_userManagement)
    {
        mail_Flag=NO;
        textField.text=@"";
        strEmailStatus=@"NO";
        self.lblEmail_UM.hidden=YES;
        //[self resizeWidgets];
        self.imgView_Email_UM.backgroundColor=lblRGBA(255, 206, 52, 1);
    }
    else{
        textField.text=@"";
    }
    
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : Hide the keyboard from the superview
 Method Name : keyboardControlsDonePressed(Pre Defined Methods)
 ************************************************************************************* */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:YES];
    if ([selected_Settings_Tab isEqualToString:@"UserManagement"]) {
        [self.bodyViewScroll_UserManage setContentOffset:CGPointZero animated:YES];
    }else if ([strAlert_Type isEqualToString:@"Payment"]){
        [self.scrollUpdateCard setContentOffset:CGPointZero animated:YES];
    }
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//}

-(void)PreviousNextButtons_Billing
{
    NSArray *fields = @[txtfld_CardName_UpdateCard,txtfld_CardNo_UpdateCard,txtfld_Month_UpdateCard,txtfld_Year_UpdateCard,txtfld_digits_UpdateCard,txtfld_zipCode_UpdateCard];
    
    [self setKeyboardControls_Billing:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls_Billing setDelegate:self];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scroll did");
    if([strAlert_Type isEqualToString:@"Plan"]){
        if (scrollView_PlanCard.contentOffset.y >= scrollView_PlanCard.contentSize.height - scrollView_PlanCard.frame.size.height) {
            [scrollView_PlanCard setContentOffset:CGPointMake(scrollView_PlanCard.contentOffset.x, scrollView_PlanCard.contentSize.height - scrollView_PlanCard.frame.size.height)];
        }
        if (scrollView_PlanCard.contentOffset.y <=-50)
        {
            [self hidePlanOptionView];
        }
    }
}

#pragma mark - IBAction
-(IBAction)changevalidationStringSettings:(id)sender
{
    NSString *cc_num_string = ((UITextField*)sender).text;
    NSLog(@"%@",cc_num_string);
    UITextField *textField = ((UITextField*)sender);
    textField.rightViewMode = UITextFieldViewModeAlways;
//    if ([cc_num_string length] > 1 && [cc_num_string characterAtIndex:0] == '4')
    if ([cc_num_string length] > 0 && [cc_num_string characterAtIndex:0] == '4')
    {
        // textField.rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"paymentVisa"]];
        strPaymentType=@"VISA";
        imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_On"];
        imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_Off"];
        imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_Off"];
        imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_Off"];
        txtfld_digits_UpdateCard.userInteractionEnabled=YES;
        txtfld_digits_UpdateCard.alpha=1.0;
        txtfld_digits_UpdateCard.placeholder = @"CVV2 (3 DIGITS)";
    }
    else if ([cc_num_string length] > 1 && [cc_num_string characterAtIndex:0] == '5' && ([cc_num_string characterAtIndex:1] == '1' || [cc_num_string characterAtIndex:1] == '5' || [cc_num_string characterAtIndex:1] == '2' || [cc_num_string characterAtIndex:1] == '3' || [cc_num_string characterAtIndex:1] == '4'))
    {
        //  textField.rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PaymentMasrterOn"]];
        strPaymentType=@"MASTRO";
        imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_Off"];
        imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_On"];
        imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_Off"];
        imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_Off"];
        txtfld_digits_UpdateCard.userInteractionEnabled=YES;
        txtfld_digits_UpdateCard.alpha=1.0;
        txtfld_digits_UpdateCard.placeholder = @"CVC2 (3 DIGITS)";
    }
    else if ([cc_num_string length] > 1 && [cc_num_string characterAtIndex:0] == '6' && ([cc_num_string characterAtIndex:1] == '5' || ([cc_num_string length] > 2 &&[cc_num_string length] > 1 && [cc_num_string characterAtIndex:1] == '4' && [cc_num_string characterAtIndex:2] == '4')||([cc_num_string length] > 2 &&[cc_num_string length] > 1 && [cc_num_string characterAtIndex:1] == '2' && [cc_num_string characterAtIndex:2] == '2') || ([cc_num_string length] > 2 &&[cc_num_string length] > 1 && [cc_num_string characterAtIndex:1] == '4' && [cc_num_string characterAtIndex:2] == '5')||([cc_num_string length] > 2 &&[cc_num_string length] > 1 && [cc_num_string characterAtIndex:1] == '4' && [cc_num_string characterAtIndex:2] == '6')||([cc_num_string length] > 2 &&[cc_num_string length] > 1 && [cc_num_string characterAtIndex:1] == '4' && [cc_num_string characterAtIndex:2] == '7')||([cc_num_string length] > 2 &&[cc_num_string length] > 1 && [cc_num_string characterAtIndex:1] == '4' && [cc_num_string characterAtIndex:2] == '8')||([cc_num_string length] > 2 &&[cc_num_string length] > 1 && [cc_num_string characterAtIndex:1] == '4' && [cc_num_string characterAtIndex:2] == '9') || ([cc_num_string length] > 3 && [cc_num_string characterAtIndex:1] == '0' && [cc_num_string characterAtIndex:2] == '1' && [cc_num_string characterAtIndex:3] == '1' )))
    {
        //  textField.rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PaymentDiscoverOn"]];
        strPaymentType=@"DISCOVER";
        imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_Off"];
        imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_Off"];
        imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_Off"];
        imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_On"];
        txtfld_digits_UpdateCard.userInteractionEnabled=YES;
        txtfld_digits_UpdateCard.alpha=1.0;
        txtfld_digits_UpdateCard.placeholder = @"CID (3 DIGITS)";
    }
    else if ([cc_num_string length] > 1 && [cc_num_string characterAtIndex:0] == '3' && ([cc_num_string characterAtIndex:1] == '4' || [cc_num_string characterAtIndex:1] == '7'))
    {
        //  textField.rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PaymentAmericanOn"]];
        strPaymentType=@"AMERICAN";
        imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_Off"];
        imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_Off"];
        imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_On"];
        imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_Off"];
        txtfld_digits_UpdateCard.userInteractionEnabled=YES;
        txtfld_digits_UpdateCard.alpha=1.0;
        txtfld_digits_UpdateCard.placeholder = @"CID (4 DIGITS)";
    }
    else
    {
        textField.rightView = nil;
        imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_Off"];
        imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_Off"];
        imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_Off"];
        imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_Off"];
        txtfld_digits_UpdateCard.text = @"";
        txtfld_digits_UpdateCard.userInteractionEnabled=NO;
        txtfld_digits_UpdateCard.alpha=0.4;
        txtfld_digits_UpdateCard.placeholder = @"";
        strPaymentType=@"";
    }
}

/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates to the time zone screen
 Method Name : TimeZone_Action
 ************************************************************************************* */
-(IBAction)TimeZone_Action:(id)sender
{
//    TimeZoneViewController *TZVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeZoneViewController"];
//    TZVC.callbackValue=^(NSMutableDictionary *dict){
//        NSLog(@"Dicitionary Call Back Response==%@",dict);
//        lbl_TimeZone.text = [dict objectForKey:KTimeZone];
//        NSLog(@"%@",lbl_TimeZone.text);
//    };
//    TZVC.callbackVoid=^{
//        NSLog(@"Void");
//    };
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:TZVC];
//    [TZVC.navigationController setNavigationBarHidden:YES animated:YES];
//    
//    // Presuming a view controller is asking for the modal transition in the first place.
//    [self presentViewController:navController animated:YES completion:nil];
//    [Common viewSlide_FromBottom_ToTop:self.navigationController.view];
//    [self.navigationController pushViewController:TZVC animated:NO];
    
    strEditMode=@"timezone";
    [self checkSettings_Widgets_DismissedOrNot];
    TimeZoneViewController *TZVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeZoneViewController"];
    TZVC.strUserDetail = @"timezone";
    TZVC.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response==%@",dict);
        if([Common reachabilityChanged]==YES){
            strTimeZone = [dict objectForKey:KTimeZone];
            
            // lbl_TimeZone.text = [dict objectForKey:KTimeZone];
            NSLog(@"%@",lbl_TimeZone.text);
            if([[self chkWidgetValidation] isEqualToString:@"YES"]){
                if([strTimeZone isEqualToString:@"Atlantic Time Zone"])
                {
                    strOrgTimeZone=@"America/Puerto_Rico";
                }else if([strTimeZone isEqualToString:@"Eastern Time Zone"])
                {
                    strOrgTimeZone=@"America/New_Yorks";   //crt
                }
                else if([strTimeZone isEqualToString:@"Central Time Zone"])
                {
                    strOrgTimeZone=@"America/Chicago";
                }
                else if([strTimeZone isEqualToString:@"Mountain Time Zone"])
                {
                    strOrgTimeZone=@"America/Denver";
                }
                else if([strTimeZone isEqualToString:@"Mountain Time Zone - Arizona"])
                {
                    strOrgTimeZone=@"America/Phoenix";
                }
                else if([strTimeZone isEqualToString:@"Pacific Time Zone"])
                {
                    strOrgTimeZone=@"America/Los_Angeles";
                }
                else if([strTimeZone isEqualToString:@"Alaska Time Zone"])
                {
                    strOrgTimeZone=@"America/Juneau";
                }
                else if([strTimeZone isEqualToString:@"Hawaii–Aleutian Time Zone"])
                {
                    strOrgTimeZone=@"America/Araguaina";
                }
                else if ([strTimeZone isEqualToString:@"India Standard Time"])
                {
                    strOrgTimeZone=@"Asia/Kolkata";
                }

                if ([strTimeZone isEqualToString:self.lbl_TimeZone.text]) {
                    return;
                }
                [self performSelector:@selector(start_PinWheel_UserSettings) withObject:self afterDelay:0.1];
                [self performSelectorInBackground:@selector(update_UserSettingsNOID) withObject:self];
            }else{
                strTimeZone = self.lbl_TimeZone.text;
            }
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
    };
    TZVC.callbackVoid=^{
        NSLog(@"Void");
    };
    [Common viewSlide_FromBottom_ToTop:self.navigationController.view];
    [self.navigationController pushViewController:TZVC animated:NO];

//    [self presentViewController:TZVC animated:YES completion:nil];
}

-(IBAction)selectLanguage_Action:(id)sender
{
    strEditMode=@"";
    [self checkSettings_Widgets_DismissedOrNot];
    TimeZoneViewController *TZVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeZoneViewController"];
    TZVC.strUserDetail = @"language";
    TZVC.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response==%@",dict);
        if([Common reachabilityChanged]==YES){
            strLanguage = [dict objectForKey:kLanguage];
            if([[self chkWidgetValidation] isEqualToString:@"YES"]){
                if ([strLanguage isEqualToString:self.lbl_Language.text]) {
                    return;
                }
                [self performSelector:@selector(start_PinWheel_UserSettings) withObject:self afterDelay:0.1];
                [self performSelectorInBackground:@selector(update_UserSettingsNOID) withObject:self];
            }else{
                strLanguage = self.lbl_Language.text;
            }
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
    };
    TZVC.callbackVoid=^{
        NSLog(@"Void");
    };    
    [self presentViewController:TZVC animated:YES completion:nil];
}

/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description :
 Method Name : back_NetworkHome_Action_In_Settings
 ************************************************************************************* */
-(IBAction)back_NetworkHome_Action_In_Settings:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"settings logo ==%@",appDelegate.strNoidLogo);
    
    if([appDelegate.strNoidLogo isEqualToString:@"MultipleNW"]){
        appDelegate.strNoidLogo=@"";
        defaults_Settings = [NSUserDefaults standardUserDefaults];
        [defaults_Settings setObject:@"YES" forKey:@"MPNETWORKLOADSTATUS"];
        [defaults_Settings synchronize];
        for (UIViewController *controller in [self.navigationController viewControllers])
        {
            if ([controller isKindOfClass:[MultipleNetworkViewController class]])
            {
                [Common viewFadeIn:self.navigationController.view];
                [self.navigationController popToViewController:controller animated:NO];
                break;
            }
        }
    }
    else if([appDelegate.strNoidLogo isEqualToString:@"NetworkHome"]){
        appDelegate.strNoidLogo=@"";
        if([appDelegate.strDevice_Added_Status isEqualToString:@"OLDPOPUPLOAD"]||[appDelegate.strDeviceUpdated_Status isEqualToString:@"YES"])
        {
            appDelegate.strDeviceUpdated_Status=@"";
            appDelegate.strDevice_Added_Status=@"REMOVEPOPUPLOAD";
        }
        for (UIViewController *controller in [self.navigationController viewControllers])
        {
            if ([controller isKindOfClass:[SWRevealViewController class]])
            {
                appDelegate.strNoid_BackStatus = @"noid";
                [Common viewFadeIn:self.navigationController.view];
                [self.navigationController popToViewController:controller animated:NO];
                break;
            }
        }
    }else if([appDelegate.strNoidLogo isEqualToString:@"Add/Edit"]){
        appDelegate.strNoidLogo=@"";
        defaults_Settings=[NSUserDefaults standardUserDefaults];
        [defaults_Settings setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
        [defaults_Settings synchronize];
        MultipleNetworkViewController *MNVC = [[MultipleNetworkViewController alloc] initWithNibName:@"MultipleNetworkViewController" bundle:nil];
        MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
        NSArray *newStack = @[MNVC];
        [Common viewFadeIn:self.navigationController.view];
        [self.navigationController setViewControllers:newStack animated:NO];
    }
    else{
        appDelegate.strNoidLogo=@"";
        defaults_Settings=[NSUserDefaults standardUserDefaults];
        [defaults_Settings setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
        [defaults_Settings synchronize];
        MultipleNetworkViewController *MNVC = [[MultipleNetworkViewController alloc] initWithNibName:@"MultipleNetworkViewController" bundle:nil];
        MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
        NSArray *newStack = @[MNVC];
        [Common viewFadeIn:self.navigationController.view];
        [self.navigationController setViewControllers:newStack animated:NO];
        
    }
}

/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event the user name and the email address can be edited.
 Method Name : edit_settings_Action
 ************************************************************************************* */
-(IBAction)edit_settings_Action:(id)sender
{
    UIButton *btnTag=(UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
            [self PreviousNextButtons_NameField_UserSettings];
            [self resetDeviceName];
            txtfld_name_settings.text=lbl_name_settings.text;
            txtfld_Lname_settings.text=lbl_Lname_settings.text;
            break;
        case 1:
            [self PreviousNextButtons_Email_UserSettings];
            [self resetCategoryName];
            txtfld_email_settings.text=lbl_email_settings.text;
            break;
    }
}

-(void)resetDeviceName{
    if ([txtfld_email_settings resignFirstResponder]) {
        [txtfld_email_settings resignFirstResponder];
    }
    [btn_edit1_settings setHidden:YES];
    [btn_save1_settings setHidden:NO];
    [txtfld_name_settings setHidden:NO];
    [txtfld_Lname_settings setHidden:NO];
    [lbl_name_settings setHidden:YES];
    [lbl_Lname_settings setHidden:YES];
    [btn_close1_settings setHidden:NO];
    [txtfld_name_settings becomeFirstResponder];
    
    //
//    [btn_edit2_settings setHidden:NO];
//    [btn_save2_settings setHidden:YES];
//    [txtfld_email_settings setHidden:YES];
//    [lbl_email_settings setHidden:NO];
//    [btn_close2_settings setHidden:YES];
//    [txtfld_email_settings resignFirstResponder];
    
}
-(void)resetCategoryName{
    
//    [btn_edit1_settings setHidden:NO];
//    [btn_save1_settings setHidden:YES];
//    [txtfld_name_settings setHidden:YES];
//    [txtfld_Lname_settings setHidden:YES];
//    [lbl_name_settings setHidden:NO];
//    [lbl_Lname_settings setHidden:NO];
//    [btn_close1_settings setHidden:YES];
    
    if ([txtfld_name_settings resignFirstResponder]) {
        [txtfld_name_settings resignFirstResponder];
    }else  if ([txtfld_Lname_settings resignFirstResponder]) {
        [txtfld_Lname_settings resignFirstResponder];
    }
    
    [btn_edit2_settings setHidden:YES];
    [btn_save2_settings setHidden:NO];
    [txtfld_email_settings setHidden:NO];
    [lbl_email_settings setHidden:YES];
    [btn_close2_settings setHidden:NO];
    [txtfld_email_settings becomeFirstResponder];
    
}
/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event the user name and the email address are saved.
 Method Name : save_settings_Action
 ************************************************************************************* */
-(IBAction)save_settings_Action:(id)sender
{
    UIButton *btnTag=(UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
            strEditMode=@"name";
            txtfld_name_settings.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_name_settings.text];
            txtfld_Lname_settings.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_Lname_settings.text];
//            lbl_name_settings.text = txtfld_name_settings.text;
//            lbl_Lname_settings.text=txtfld_Lname_settings.text;
            if ([txtfld_name_settings resignFirstResponder]) {
                [txtfld_name_settings resignFirstResponder];
            }else if ([txtfld_Lname_settings resignFirstResponder]) {
                [txtfld_Lname_settings resignFirstResponder];
            }
            
            if([[self chkWidgetValidation] isEqualToString:@"YES"]){
                if ([lbl_name_settings.text isEqualToString:txtfld_name_settings.text] && [lbl_Lname_settings.text isEqualToString:txtfld_Lname_settings.text]) {
                    [self reset_UserName_Container];
                    return;
                }
                lbl_name_settings.text = txtfld_name_settings.text;
                lbl_Lname_settings.text=txtfld_Lname_settings.text;
                [self updateSettings];
            }
            break;
        case 1:
            strEditMode=@"email";
            txtfld_email_settings.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_email_settings.text];
            strEmailVal_status=@"NO";
            if ([txtfld_email_settings resignFirstResponder]) {
                [txtfld_email_settings resignFirstResponder];
            }
            
            if(txtfld_email_settings.text.length==0){
                [Common showAlert:kAlertTitleWarning withMessage:@"Please enter the email"];
                return;
            }
            if([[self emailValidationSettings:txtfld_email_settings.text] isEqualToString:@"NO"]){
                NSLog(@"Please Enter Valid Email Address");
//                lbl_email_settings.text = txtfld_email_settings.text;
                [Common showAlert:kAlertTitleWarning withMessage:@"Please enter valid email address"];
                return;
            }
//            [self reset_EMail_Container];
            if([[self chkWidgetValidation] isEqualToString:@"YES"]){
                if ([lbl_email_settings.text isEqualToString:txtfld_email_settings.text]) {
                    [self reset_EMail_Container];
                    return;
                }
                lbl_email_settings.text = txtfld_email_settings.text;
                [self updateSettings];
            }
            //[txtfld_email_settings resignFirstResponder];
            break;
    }
}

-(void)reset_UserName_Container{
    [btn_edit1_settings setHidden:NO];
    [btn_save1_settings setHidden:YES];
    [txtfld_name_settings setHidden:YES];
    [txtfld_Lname_settings setHidden:YES];
    [lbl_name_settings setHidden:NO];
    [lbl_Lname_settings setHidden:NO];
    [btn_close1_settings setHidden:YES];
    txtfld_name_settings.text=lbl_name_settings.text;
    txtfld_Lname_settings.text=lbl_Lname_settings.text;
}
-(void)reset_EMail_Container{
    [btn_edit2_settings setHidden:NO];
    [btn_save2_settings setHidden:YES];
    [txtfld_email_settings setHidden:YES];
    [lbl_email_settings setHidden:NO];
    [btn_close2_settings setHidden:YES];
    txtfld_email_settings.text=lbl_email_settings.text;
}

/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event toggles the tempertaure.
 Method Name : tempToggle_Action
 ************************************************************************************* */
-(IBAction)tempToggle_Action:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    strEditMode=@"";
    [self checkSettings_Widgets_DismissedOrNot];
    if([[self chkWidgetValidation] isEqualToString:@"YES"]){
        UIButton *btnTag=(UIButton *)sender;
        switch (btnTag.tag) {
            case 0:
                strSelected_Temp_type=@"f";
                if([strSelected_Temp_type isEqualToString:@"f"]&&![strPrevious_Temp_type isEqualToString:@"f"])
                {
                    strPrevious_Temp_type=strSelected_Temp_type;
                    temperatureType=@"f";
                    [self updateSettings];
//                    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
//                    {
//                        appDelegate.strWeatherChanged=@"";
//                    }else{
                        appDelegate.strWeatherChanged=@"YES";
//                    }
                }
                
                break;
            case 1:
                strSelected_Temp_type=@"c";
                if([strSelected_Temp_type isEqualToString:@"c"]&&![strPrevious_Temp_type isEqualToString:@"c"])
                {
                    strPrevious_Temp_type=strSelected_Temp_type;
                    temperatureType=@"c";
                    [self updateSettings];
//                    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
//                    {
//                        appDelegate.strWeatherChanged=@"";
//                    }else{
                        appDelegate.strWeatherChanged=@"YES";
//                    }
                }
                break;
        }
    }
}

-(void)changeFahrenheit
{
    temperatureType=@"f";
    strPrevious_Temp_type=@"f";
    [btn_temp1_settings setBackgroundColor:lblRGBA(255, 206, 52, 1)];
    [btn_temp2_settings setBackgroundColor:lblRGBA(99, 99, 102, 1)];
    
}
-(void)changeCentigrade
{
    temperatureType=@"c";
    strPrevious_Temp_type=@"c";
    [btn_temp1_settings setBackgroundColor:lblRGBA(99, 99, 102, 1)];
    [btn_temp2_settings setBackgroundColor:lblRGBA(255, 206, 52, 1)];
    
}

/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Navigates back to the previous screen.
 Method Name : back_settings_Action
 ************************************************************************************* */
-(IBAction)back_settings_Action:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Hides the textfield
 Method Name : close_setting_Action
 ************************************************************************************* */
-(IBAction)close_setting_Action:(id)sender
{
    UIButton *btnTag=(UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
            [btn_edit1_settings setHidden:NO];
            [btn_save1_settings setHidden:YES];
            [txtfld_name_settings setHidden:YES];
            [txtfld_Lname_settings setHidden:YES];
            [lbl_name_settings setHidden:NO];
            [lbl_Lname_settings setHidden:NO];
            [btn_close1_settings setHidden:YES];
            [txtfld_name_settings resignFirstResponder];
            [txtfld_Lname_settings resignFirstResponder];
            txtfld_name_settings.text = lbl_name_settings.text;
            txtfld_Lname_settings.text= lbl_Lname_settings.text;
            self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            break;
        case 1:
            strEmailVal_status=@"YES";
            [btn_edit2_settings setHidden:NO];
            [btn_save2_settings setHidden:YES];
            [txtfld_email_settings setHidden:YES];
            [lbl_email_settings setHidden:NO];
            [btn_close2_settings setHidden:YES];
            [txtfld_email_settings resignFirstResponder];
            txtfld_email_settings.text=lbl_email_settings.text;
            self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            break;
    }
}

-(void)textfield_WidgetDismissOrNot_Settings
{
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    if ([previous_Settings_tab isEqualToString:@"UserSettings"]) {
        if([txtfld_email_settings resignFirstResponder]){
            [txtfld_email_settings resignFirstResponder];
        }else if([txtfld_name_settings resignFirstResponder]){
            [txtfld_name_settings resignFirstResponder];
        }else if([txtfld_Lname_settings resignFirstResponder]){
            [txtfld_Lname_settings resignFirstResponder];
        }
    }else if ([previous_Settings_tab isEqualToString:@"UserManagement"]){
        if([txtfld_Fname_userManagement resignFirstResponder]){
            [txtfld_Fname_userManagement resignFirstResponder];
        }else if([txtfld_Lname_userManagement resignFirstResponder]){
            [txtfld_Lname_userManagement resignFirstResponder];
        }else if([txtfld_email_userManagement resignFirstResponder]){
            [txtfld_email_userManagement resignFirstResponder];
        }else if ([txt_AccName[tag_PosAcc] resignFirstResponder]){
            [txt_AccName[tag_PosAcc] resignFirstResponder];
        }else if ([txt_AccLName[tag_PosAcc] resignFirstResponder]){
            [txt_AccLName[tag_PosAcc] resignFirstResponder];
        }
    }
}

-(IBAction)changeTab_From_Settings_Action:(id)sender
{
    UIButton *btnTag=(UIButton *)sender;
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self textfield_WidgetDismissOrNot_Settings];
    switch (btnTag.tag) {
        case 0:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                selected_Settings_Tab=@"UserSettings";
                if([selected_Settings_Tab isEqualToString:@"UserSettings"] && ![previous_Settings_tab isEqualToString:@"UserSettings"]){
                    previous_Settings_tab=selected_Settings_Tab;
                    lbl_UserSettings.textColor = lblRGBA(255, 206, 52, 1);
                    lbl_UserManagement.textColor = lblRGBA(99, 99, 102, 1);
                    lbl_UserHistory.textColor = lblRGBA(99, 99, 102, 1);
                    lbl_UserBilling.textColor = lblRGBA(99, 99, 102, 1);
//                    if([[Common deviceType] isEqualToString:@"iPhone5"]){
//                        imgUserSettings.image = [UIImage imageNamed:@"profileDetailsImage"];
//                        imgUserManagement.image = [UIImage imageNamed:@"manageUserImageGrey"];
//                        imgUserHistroy.image = [UIImage imageNamed:@"historyimageGray"];
//                        imgUserBilling.image = [UIImage imageNamed:@"billingImage"];
//                    }else if([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                        imgUserSettings.image = [UIImage imageNamed:@"profileDetailsImagei6plus"];
//                        imgUserManagement.image = [UIImage imageNamed:@"manageUserImageGreyi6plus"];
//                        imgUserHistroy.image = [UIImage imageNamed:@"historyimageGrayi6plus"];
//                        imgUserBilling.image = [UIImage imageNamed:@"billingImagei6plus"];
//                    }else{
//                        imgUserSettings.image = [UIImage imageNamed:@"profileDetailsImagei6"];
//                        imgUserManagement.image = [UIImage imageNamed:@"manageUserImageGreyi6"];
//                        imgUserHistroy.image = [UIImage imageNamed:@"historyimageGrayi6"];
//                        imgUserBilling.image = [UIImage imageNamed:@"billingImagei6"];
//                    }
                    imgUserSettings.image = [UIImage imageNamed:@"profileDetailsImagei6plus"];
                    imgUserManagement.image = [UIImage imageNamed:@"manageUserImageGreyi6plus"];
                    imgUserHistroy.image = [UIImage imageNamed:@"historyimageGrayi6plus"];
                    imgUserBilling.image = [UIImage imageNamed:@"billingImagei6plus"];

                    // [Common viewFadeIn:self.navigationController.view];
                    [Common viewFadeInSettings:self.navigationController.view];
//                    [self initialSetup_UserSettings];
                    settingHistoryView.hidden=YES;
                    settingHomeView.hidden=NO;
                    [settingBillingView setHidden:YES];
                    [settingManageUserView setHidden:YES];
                }else{
                    NSLog(@"User settings already selected");
                }
            });
        }
            break;
        case 1:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                selected_Settings_Tab=@"UserHistory";
                if([selected_Settings_Tab isEqualToString:@"UserHistory"] && ![previous_Settings_tab isEqualToString:@"UserHistory"]){
                    if([strHistoryUpdateStatus isEqualToString:@"YES"])
                    {
                        [self.scroll_History setContentOffset:CGPointZero animated:YES];
                        [self.scroll_History.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                        strHistoryUpdateStatus=@"";
                        historyStatus=YES;
                        strHistoryLoadedStatus=@"";
                        self.viewFooter_UserHistory.hidden=YES;
                        for (int index=0;index<[arrUserHistory count];index++){
                            [btnHistory_Page[index] removeFromSuperview];
                        }
                    }
                    previous_Settings_tab=selected_Settings_Tab;
                    lbl_UserSettings.textColor = lblRGBA(99, 99, 102, 1);
                    lbl_UserManagement.textColor = lblRGBA(99, 99, 102, 1);
                    lbl_UserHistory.textColor = lblRGBA(255, 206, 52, 1);
                    lbl_UserBilling.textColor = lblRGBA(99, 99, 102, 1);
//                    if([[Common deviceType] isEqualToString:@"iPhone5"]){
//                        imgUserSettings.image = [UIImage imageNamed:@"profileDetailImageGrey"];
//                        imgUserManagement.image = [UIImage imageNamed:@"manageUserImageGrey"];
//                        imgUserHistroy.image = [UIImage imageNamed:@"historyImageYellow"];
//                        imgUserBilling.image = [UIImage imageNamed:@"billingImage"];
//                    }else if([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                        imgUserSettings.image = [UIImage imageNamed:@"profileDetailImageGreyi6plus"];
//                        imgUserManagement.image = [UIImage imageNamed:@"manageUserImageGreyi6plus"];
//                        imgUserHistroy.image = [UIImage imageNamed:@"historyImageYellowi6plus"];
//                        imgUserBilling.image = [UIImage imageNamed:@"billingImagei6plus"];
//                    }else{
//                        imgUserSettings.image = [UIImage imageNamed:@"profileDetailImageGreyi6"];
//                        imgUserManagement.image = [UIImage imageNamed:@"manageUserImageGreyi6"];
//                        imgUserHistroy.image = [UIImage imageNamed:@"historyImageYellowi6"];
//                        imgUserBilling.image = [UIImage imageNamed:@"billingImagei6"];
//                    }

                    imgUserSettings.image = [UIImage imageNamed:@"profileDetailImageGreyi6plus"];
                    imgUserManagement.image = [UIImage imageNamed:@"manageUserImageGreyi6plus"];
                    imgUserHistroy.image = [UIImage imageNamed:@"historyImageYellowi6plus"];
                    imgUserBilling.image = [UIImage imageNamed:@"billingImagei6plus"];
                    [txtfld_email_settings resignFirstResponder];
                    [txtfld_name_settings resignFirstResponder];
                    [Common viewFadeInSettings:self.navigationController.view];
//                    [self tableViewSetup];
                    settingHomeView.hidden=YES;
                    settingHistoryView.hidden=NO;
                    [settingManageUserView setHidden:YES];
                    [settingBillingView setHidden:YES];
                    if([strHistoryLoadedStatus isEqualToString:@""])
                    {
                        if([Common reachabilityChanged]==YES){
                            [self historySetup];
                            [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
                            [self performSelectorInBackground:@selector(getUsersRunning_History) withObject:self];
                        }else{
                            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                        }
                    }
                }
            });
        }
            break;
        case 2:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                selected_Settings_Tab=@"UserManagement";
                if([selected_Settings_Tab isEqualToString:@"UserManagement"] && ![previous_Settings_tab isEqualToString:@"UserManagement"]){
                    previous_Settings_tab=selected_Settings_Tab;
                    lbl_UserSettings.textColor = lblRGBA(99, 99, 102, 1);
                    lbl_UserManagement.textColor = lblRGBA(255, 206, 52, 1);
                    lbl_UserHistory.textColor = lblRGBA(99, 99, 102, 1);
                    lbl_UserBilling.textColor = lblRGBA(99, 99, 102, 1);
//                    if([[Common deviceType] isEqualToString:@"iPhone5"]){
//                        imgUserSettings.image = [UIImage imageNamed:@"profileDetailImageGrey"];
//                        imgUserManagement.image = [UIImage imageNamed:@"userManageImage"];
//                        imgUserHistroy.image = [UIImage imageNamed:@"historyimageGray"];
//                        imgUserBilling.image = [UIImage imageNamed:@"billingImage"];
//                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                         imgUserSettings.image = [UIImage imageNamed:@"profileDetailImageGreyi6plus"];
//                        imgUserManagement.image = [UIImage imageNamed:@"userManageImagei6plus"];
//                        imgUserHistroy.image = [UIImage imageNamed:@"historyimageGrayi6plus"];
//                        imgUserBilling.image = [UIImage imageNamed:@"billingImagei6plus"];
//                    }else{
//                        imgUserSettings.image = [UIImage imageNamed:@"profileDetailImageGreyi6"];
//                        imgUserManagement.image = [UIImage imageNamed:@"userManageImagei6"];
//                        imgUserHistroy.image = [UIImage imageNamed:@"historyimageGrayi6"];
//                        imgUserBilling.image = [UIImage imageNamed:@"billingImagei6"];
//                    }
                    imgUserSettings.image = [UIImage imageNamed:@"profileDetailImageGreyi6plus"];
                    imgUserManagement.image = [UIImage imageNamed:@"userManageImagei6plus"];
                    imgUserHistroy.image = [UIImage imageNamed:@"historyimageGrayi6plus"];
                    imgUserBilling.image = [UIImage imageNamed:@"billingImagei6plus"];

                    [self scrollView_Configuration_UserManagement];
                    [Common viewFadeInSettings:self.navigationController.view];
                    settingHomeView.hidden=YES;
                    settingHistoryView.hidden=YES;
                    [settingManageUserView setHidden:NO];
                    [settingBillingView setHidden:YES];
                    if ([strSelectNWStatus isEqualToString:@"YES"]) {
                        selectNetworkView.hidden=YES;
                    }else{
                        selectNetworkView.hidden=NO;
                    }
                    if ([strNetworkLoadedStatus isEqualToString:@""]) {
                        if([Common reachabilityChanged]==YES){
                            [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
                            [self performSelectorInBackground:@selector(getAllNetworksID_NOID) withObject:self];
                        }else{
                            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                        }
                    }
                }
            });
        }
            break;
        case 3:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                selected_Settings_Tab=@"Billing";
                if([selected_Settings_Tab isEqualToString:@"Billing"] && ![previous_Settings_tab isEqualToString:@"Billing"]){
                    [self textfield_WidgetConfiguration_Billing];
                    if([strBillingUpdateStatus isEqualToString:@"YES"])
                    {
                        [self.scroll_Billing_Main_Container setContentOffset:CGPointZero animated:YES];
                        [self.scroll_Billing_Controller.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                        [self.scroll_Billing_History.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                        strBillingUpdateStatus=@"";
                        billingHistoryStatus=YES;
                        strBillingLoadedStatus=@"";
                        self.viewFooter_BillingHistory.hidden=YES;
                        for (int index=0;index<[arrBillingHistorySplit count];index++){
                            [btnBillingHistory_Page[index] removeFromSuperview];
                        }
                    }

                    previous_Settings_tab=selected_Settings_Tab;
                    lbl_UserSettings.textColor = lblRGBA(99, 99, 102, 1);
                    lbl_UserManagement.textColor = lblRGBA(99, 99, 102, 1);
                    lbl_UserHistory.textColor = lblRGBA(99, 99, 102, 1);
                    lbl_UserBilling.textColor = lblRGBA(255, 206, 52, 1);
//                    if([[Common deviceType] isEqualToString:@"iPhone5"]){
//                        imgUserSettings.image = [UIImage imageNamed:@"profileDetailImageGrey"];
//                        imgUserManagement.image = [UIImage imageNamed:@"manageUserImageGrey"];
//                        imgUserHistroy.image = [UIImage imageNamed:@"historyimageGray"];
//                        imgUserBilling.image = [UIImage imageNamed:@"billingYellowImage"];
//                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                        imgUserSettings.image = [UIImage imageNamed:@"profileDetailImageGreyi6plus"];
//                        imgUserManagement.image = [UIImage imageNamed:@"manageUserImageGreyi6plus"];
//                        imgUserHistroy.image = [UIImage imageNamed:@"historyimageGrayi6plus"];
//                        imgUserBilling.image = [UIImage imageNamed:@"billingYellowImagei6"];
//                    }else{
//                        imgUserSettings.image = [UIImage imageNamed:@"profileDetailImageGreyi6"];
//                        imgUserManagement.image = [UIImage imageNamed:@"manageUserImageGreyi6"];
//                        imgUserHistroy.image = [UIImage imageNamed:@"historyimageGrayi6"];
//                        imgUserBilling.image = [UIImage imageNamed:@"billingYellowImagei6"];
//                    }
                    imgUserSettings.image = [UIImage imageNamed:@"profileDetailImageGreyi6plus"];
                    imgUserManagement.image = [UIImage imageNamed:@"manageUserImageGreyi6plus"];
                    imgUserHistroy.image = [UIImage imageNamed:@"historyimageGrayi6plus"];
                    imgUserBilling.image = [UIImage imageNamed:@"billingYellowImagei6plus"];

                    [Common viewFadeInSettings:self.navigationController.view];
                    settingHomeView.hidden=YES;
                    settingHistoryView.hidden=YES;
                    [settingManageUserView setHidden:YES];
                    [settingBillingView setHidden:YES];
                    if([strBillingLoadedStatus isEqualToString:@""])
                    {
                        if([Common reachabilityChanged]==YES){
                            [self billing_History_Setup];
                            [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
                            [self performSelectorInBackground:@selector(getBilling_Section) withObject:self];
                        }else{
                            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                        }
                    }else{
                        settingBillingView.hidden=NO;
                    }
                }
            });
        }
            break;
    }
}

-(IBAction)paginationNext_Action:(id)sender
{
    NSLog(@"Total Page ==%d",TotalPage);
    UIButton *btnTag=(UIButton *)sender;
    switch (btnTag.tag) {
        case 0:  //Next
        {
            NSLog(@"current index =%d",currentIndex);
            if(currentIndex==TotalPage)
            {
                return;
            }
            if(currentIndex%5==0)
            {
                for(int index=currentIndex;index>currentIndex-5;index--)
                {
                    btnHistory_Page[index].hidden=YES;
                }
                for(int index=currentIndex+1;index<=currentIndex+5;index++)
                {
                    btnHistory_Page[index].hidden=NO;
                    if(index==TotalPage)
                    {
                        index=TotalPage+1;
                    }
                }
            }
            [btnHistory_Page[currentIndex] setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            [btnHistory_Page[currentIndex] setBackgroundColor:[UIColor clearColor]];
            [btnHistory_Page[currentIndex] setBackgroundImage:[UIImage imageNamed:@"grayBoxImage"] forState:UIControlStateNormal];
            
            currentIndex=currentIndex+1;
            [btnHistory_Page[currentIndex] setBackgroundColor:lblRGBA(135, 196, 65, 1)];
            [btnHistory_Page[currentIndex] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnHistory_Page[currentIndex] setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.scroll_History.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            pageindex=currentIndex-1;
            NSLog(@"page index==%ld",(long)pageindex);
            NSUInteger start = countPerPage * pageindex;
            NSRange range = NSMakeRange(start, MIN([arrUserHistory count] - start, countPerPage));
            arrUserHistorySplit = [arrUserHistory subarrayWithRange:range];
            PreviousIndex=currentIndex;
            [self loadHistoryDatas:arrUserHistorySplit];
            if(currentIndex==TotalPage)
            {
                [btnPageNext setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
                [btnPageNext setBackgroundColor:[UIColor clearColor]];
                [btnPageNext setBackgroundImage:[UIImage imageNamed:@"bigGrayBoxImage"] forState:UIControlStateNormal];
                btnPageNext.userInteractionEnabled=NO;
            }else{
                [btnPageNext setBackgroundColor:lblRGBA(135, 196, 65, 1)];
                [btnPageNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnPageNext setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                btnPageNext.userInteractionEnabled=YES;
            }
            if(currentIndex==1)
            {
                [btnPagePrevious setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
                [btnPagePrevious setBackgroundColor:[UIColor clearColor]];
                [btnPagePrevious setBackgroundImage:[UIImage imageNamed:@"bigGrayBoxImage"] forState:UIControlStateNormal];
                btnPagePrevious.userInteractionEnabled=NO;
            }else{
                [btnPagePrevious setBackgroundColor:lblRGBA(135, 196, 65, 1)];
                [btnPagePrevious setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnPagePrevious setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                btnPagePrevious.userInteractionEnabled=YES;
            }
        }
            break;
        case 1: //Prev
        {
            NSLog(@"current index previous =%d",currentIndex);
            currentIndex=currentIndex-1;
            if(currentIndex<1)
            {
                btnPagePrevious.userInteractionEnabled=NO;
                return;
            }
            if(currentIndex%5==0)
            {
                for(int index=currentIndex+1;index<=currentIndex+5;index++)
                {
                    btnHistory_Page[index].hidden=YES;
                    if(index==TotalPage)
                    {
                        index=TotalPage+1;
                    }
                }
                for(int index=currentIndex-4;index<=currentIndex;index++)
                {
                    btnHistory_Page[index].hidden=NO;
                }
            }
            
            [btnHistory_Page[PreviousIndex] setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            [btnHistory_Page[PreviousIndex] setBackgroundColor:[UIColor clearColor]];
            [btnHistory_Page[PreviousIndex] setBackgroundImage:[UIImage imageNamed:@"grayBoxImage"] forState:UIControlStateNormal];
            
            //currentIndex=currentIndex+1;
            [btnHistory_Page[currentIndex] setBackgroundColor:lblRGBA(135, 196, 65, 1)];
            [btnHistory_Page[currentIndex] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnHistory_Page[currentIndex] setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.scroll_History.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            pageindex=currentIndex-1;
            NSLog(@"page index==%ld",(long)pageindex);
            NSUInteger start = countPerPage * pageindex;
            NSRange range = NSMakeRange(start, MIN([arrUserHistory count] - start, countPerPage));
            arrUserHistorySplit = [arrUserHistory subarrayWithRange:range];
            PreviousIndex=currentIndex;
            [self loadHistoryDatas:arrUserHistorySplit];
            if(currentIndex==1)
            {
                [btnPagePrevious setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
                [btnPagePrevious setBackgroundColor:[UIColor clearColor]];
                [btnPagePrevious setBackgroundImage:[UIImage imageNamed:@"bigGrayBoxImage"] forState:UIControlStateNormal];
                btnPagePrevious.userInteractionEnabled=NO;
            }else{
                [btnPagePrevious setBackgroundColor:lblRGBA(135, 196, 65, 1)];
                [btnPagePrevious setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnPagePrevious setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                btnPagePrevious.userInteractionEnabled=YES;
            }
            if(currentIndex==TotalPage)
            {
                [btnPageNext setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
                [btnPageNext setBackgroundColor:[UIColor clearColor]];
                [btnPageNext setBackgroundImage:[UIImage imageNamed:@"bigGrayBoxImage"] forState:UIControlStateNormal];
                btnPageNext.userInteractionEnabled=NO;
            }else{
                [btnPageNext setBackgroundColor:lblRGBA(135, 196, 65, 1)];
                [btnPageNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnPageNext setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                btnPageNext.userInteractionEnabled=YES;
            }
        }
            break;
    }
}

/* **********************************************************************************
 Date : 27/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click network permission can be changed.
 Method Name : selectNetwork_UserManage_Action
 ************************************************************************************* */
-(IBAction)selectNetwork_UserManage_Action:(id)sender
{
    [self textfield_WidgetDismissOrNot_Settings];
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            if ([arr_NetworkList count]==0) {
                [Common showAlert:@"Warning" withMessage:@"No Property"];
                return;
            }
            [self dismissKeyboard];
            [self start_PinWheel_UserSettings];
            [self userManagementSetup];
            [self selectNetwork_Enable_Disable];
        }
            break;
        case 1:
        {
            for (int i=0; i<[arr_NetworkList count]; i++) {
                lbl_AccessType[i].text=@"";
            }
            [arr_Networkid removeAllObjects];
            [self selectNetwork_Enable_Disable];
        }
    }
}

-(IBAction)save_UserManagementDetails:(id)sender{
    txtfld_email_userManagement.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_email_userManagement.text];
    txtfld_Fname_userManagement.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_Fname_userManagement.text];
    txtfld_Lname_userManagement.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_Lname_userManagement.text];

    if (txtfld_Fname_userManagement.text.length==0 && txtfld_Lname_userManagement.text.length==0){
        [Common showAlert:@"Warning" withMessage:@"Please enter the name fields"];
        return;
    }else if (txtfld_Fname_userManagement.text.length==0){
        [Common showAlert:@"Warning" withMessage:@"Please enter the first name"];
        return;
    }else if (txtfld_Lname_userManagement.text.length==0){
        [Common showAlert:@"Warning" withMessage:@"Please enter the last name"];
        return;
    }else if (txtfld_email_userManagement.text.length==0) {
        [Common showAlert:@"Warning" withMessage:@"Please enter email address"];
        return;
    }else if ([arr_Networkid count]==0){
        [Common showAlert:@"Warning" withMessage:@"Please select atleast one property"];
        return;
    }
    if([[self emailValidationSettings:txtfld_email_userManagement.text] isEqualToString:@"NO"]){
        NSLog(@"Please Enter Valid Email Address");
        [Common showAlert:kAlertTitleWarning withMessage:@"Please enter valid email address"];
        return;
    }
    
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(add_UserManagement) withObject:self];
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
    
}

-(IBAction)editBillingDetail_PLanOptions_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            strAlert_Type=@"Payment";
            self.scrollUpdateCard.delegate=self;
            self.scrollUpdateCard.scrollEnabled=YES;
            self.scrollUpdateCard.showsVerticalScrollIndicator=YES;
            self.scrollUpdateCard.userInteractionEnabled=YES;
            self.scrollUpdateCard.contentOffset = CGPointZero;
            [self userInteraction_Settings_Disabled];
            [self PreviousNextButtons_Billing];
            [UIView beginAnimations:@"move" context:nil];
            [UIView setAnimationDuration:0.5];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                viewPayment_Alert.frame  = CGRectMake(viewPayment_Alert.frame.origin.x, 215,viewPayment_Alert.frame.size.width,viewPayment_Alert.frame.size.height);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                viewPayment_Alert.frame  = CGRectMake(viewPayment_Alert.frame.origin.x, 272,viewPayment_Alert.frame.size.width,viewPayment_Alert.frame.size.height);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                viewPayment_Alert.frame  = CGRectMake(viewPayment_Alert.frame.origin.x, 248,viewPayment_Alert.frame.size.width,viewPayment_Alert.frame.size.height);
            }
            [self setPlan_Payment_OptionGusters];
            [self swipeGestureBilling];
            [UIView commitAnimations];
        }
            break;
        case 1:
            [self hidePlanOptionView];
            break;
        case 2:
        {
            [self set_PlanOption_Gesture_Settings];
            if([strPlanStatus isEqualToString:@"YES"]){
                [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
                strAlert_Type=@"Plan";
                strEditCardStatus=@"";
                scrollView_PlanCard.frame  = CGRectMake(scrollView_PlanCard.frame.origin.x, 20,scrollView_PlanCard.frame.size.width,scrollView_PlanCard.frame.size.height);
                [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
            }else{
                if([Common reachabilityChanged]==YES){
                    strAlert_Type=@"Plan";
                    strEditCardStatus=@"";
                    [self planCardScrollSetupSettings];
                    [self planCardOptionScrollSetupSettings];
                    scrollView_PlanCard.frame  = CGRectMake(scrollView_PlanCard.frame.origin.x, 20,scrollView_PlanCard.frame.size.width,scrollView_PlanCard.frame.size.height);
                    [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
                    [self performSelectorInBackground:@selector(getBillingPlansSettings) withObject:self];
                }else{
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                }
            }
        }
            break;
        case 3: //Save Card Details
            {
                [current_textfield_Billing resignFirstResponder];
                self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                self.scrollUpdateCard.contentOffset = CGPointZero;

                if(txtfld_CardName_UpdateCard.text.length==0&&txtfld_CardNo_UpdateCard.text.length==0&&txtfld_Month_UpdateCard.text.length==0&&txtfld_Year_UpdateCard.text.length==0&&txtfld_digits_UpdateCard.text.length==0&&txtfld_zipCode_UpdateCard.text.length==0){
                    [Common showAlert:@"Warning" withMessage:@"Please enter all the card details"];
                    return;
                }else if(txtfld_CardName_UpdateCard.text.length==0){
                    [Common showAlert:@"Warning" withMessage:@"Please enter the card holder name"];
                    return;
                }
                else if(txtfld_CardNo_UpdateCard.text.length==0){
                    [Common showAlert:@"Warning" withMessage:@"Please enter the credit card number"];
                    return;
                }
                else if(txtfld_Month_UpdateCard.text.length==0){
                    [Common showAlert:@"Warning" withMessage:@"Please enter the expiry date month"];
                    return;
                }
                else if(txtfld_Year_UpdateCard.text.length==0){
                    [Common showAlert:@"Warning" withMessage:@"Please enter the expiry year"];
                    return;
                }
                else if(txtfld_digits_UpdateCard.text.length==0){
                    if ([strPaymentType isEqualToString:@"AMERICAN"]) {
                        [Common showAlert:@"Warning" withMessage:@"Please enter the Unique Card Code"];
                        return;
                    }
                    else if ([strPaymentType isEqualToString:@"VISA"]) {
                        [Common showAlert:@"Warning" withMessage:@"Please enter the Card Verification Value 2"];
                        return;
                    }
                    else if ([strPaymentType isEqualToString:@"DISCOVER"]) {
                        [Common showAlert:@"Warning" withMessage:@"Please enter the Card Identification Number"];
                        return;
                    }
                    else if ([strPaymentType isEqualToString:@"MASTRO"]) {
                        [Common showAlert:@"Warning" withMessage:@"Please enter the Card Validation Code"];
                        return;
                    }
                    else if(txtfld_zipCode_UpdateCard.text.length==0){
                        [Common showAlert:@"Warning" withMessage:@"Please enter the zipcode"];
                        return;
                    }
                }
                else if(txtfld_zipCode_UpdateCard.text.length==0){
                    [Common showAlert:@"Warning" withMessage:@"Please enter the zipcode"];
                    return;
                }
                
                if([self checkCardVaidationSettings]==NO)
                {
                    return;
                }
                
                if([self checkCardMonthValidationSettings]==NO)
                {
                    
                    return;
                }
                if([self checkCardYearValidationSettings]==NO){
                    
                    return;
                }
                if(month_Billing_Flag==YES && year_Billing_Flag==YES){
                    int user_Exp_Yr=[self.txtfld_Year_UpdateCard.text intValue];
                    if(user_Exp_Yr==[Common getCurrentYear])
                    {
                        int user_Exp_Month=[self.txtfld_Month_UpdateCard.text intValue];
                        if(user_Exp_Month>=[Common getCurrentMonth])
                        {
                            
                        }else{
                            [Common showAlert:@"Invalid Expiry Date Month" withMessage:@"Card Month is already expired"];
                            return;
                        }
                    }
                }
                if([self checkCardDigitsValidationSettings]==NO)
                {
                    
                    return;
                }
                if([self checkCardZipCodeValidationSettings]==NO){
                    
                    return;
                }
                if([Common reachabilityChanged]==YES){
                    [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
                    [self performSelectorInBackground:@selector(updateCreditCardDetailsSettings) withObject:self];
                }else{
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                }
            }
            break;
        case 4: //Cancel payment card
            {
                [current_textfield_Billing resignFirstResponder];
                self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                cardNumber_Billing_Flag=orgCardFlag;
                [self hidePlanOptionView];
            }
            break;
    }
}

-(BOOL)checkCardDigitsValidationSettings
{
    BOOL isValidDigits=[Common checCardCSCRegx:self.txtfld_digits_UpdateCard.text];
    if(isValidDigits){
        if ([strPaymentType isEqualToString:@"AMERICAN"] && txtfld_digits_UpdateCard.text.length!=4) {
            [Common showAlert:@"Invalid Card CID Digits" withMessage:@"Please Enter Valid Unique Card Code"];
            cscDigits_Billing_Flag=NO;
            return cscDigits_Billing_Flag;
        }
        cscDigits_Billing_Flag=YES;
    }else{
        if ([strPaymentType isEqualToString:@"AMERICAN"]){
            [Common showAlert:@"Invalid Card CID Digits" withMessage:@"Please Enter Valid Unique Card Code"];
            cscDigits_Billing_Flag=NO;
            return cscDigits_Billing_Flag;
        }
        else if ([strPaymentType isEqualToString:@"VISA"]) {
            [Common showAlert:@"Invalid Card CVV2 Digits" withMessage:@"Please Enter Valid Card Verification Value 2"];
            cscDigits_Billing_Flag=NO;
            return cscDigits_Billing_Flag;
        }
        else if ([strPaymentType isEqualToString:@"DISCOVER"]) {
            [Common showAlert:@"Invalid Card CID Digits" withMessage:@"Please Enter Valid Card Identification Number"];
            cscDigits_Billing_Flag=NO;
            return cscDigits_Billing_Flag;
        }
        else if ([strPaymentType isEqualToString:@"MASTRO"]) {
            [Common showAlert:@"Invalid Card CVC2 Digits" withMessage:@"Please Enter Valid Card Validation Code"];
            cscDigits_Billing_Flag=NO;
            return cscDigits_Billing_Flag;
        }
        cscDigits_Billing_Flag=NO;
    }
    return cscDigits_Billing_Flag;
}
-(BOOL)checkCardZipCodeValidationSettings
{
    BOOL isValidDigits=[Common checkZIPCODEregx:self.txtfld_zipCode_UpdateCard.text];
    if(isValidDigits){
        //[Common showAlert:@"woowwwwwwwwwww" withMessage:@"wowwwwwwwwww"];
        zipcode_Billing_Flag=YES;
    }else{
        [Common showAlert:@"Invalid ZipCode" withMessage:@"Please Enter Valid Zipcode"];
        zipcode_Billing_Flag=NO;
    }
    return zipcode_Billing_Flag;
}
-(BOOL)checkCardMonthValidationSettings
{
    BOOL isValidDigits=[Common checCardMonthRegx:self.txtfld_Month_UpdateCard.text];
    if(isValidDigits){
        month_Billing_Flag=YES;
    }else{
        [Common showAlert:@"Invalid Expiry Date Month" withMessage:@"Please Enter Valid Month"];
        month_Billing_Flag=NO;
    }
    return month_Billing_Flag;
}
-(BOOL)checkCardYearValidationSettings
{
    BOOL isValidDigits=[Common checCardYearRegx:self.txtfld_Year_UpdateCard.text];
    if(isValidDigits){
        int user_Exp_Yr=[self.txtfld_Year_UpdateCard.text intValue];
        if(user_Exp_Yr>=[Common getCurrentYear])
        {
            year_Billing_Flag=YES;
        }else{
            [Common showAlert:@"Invalid Expiry Date Year" withMessage:@"Please Enter Valid 4 Digit Year"];
            year_Billing_Flag=NO;
        }
        
    }else{
        [Common showAlert:@"Invalid Expiry Date Year" withMessage:@"Please Enter Valid 4 Digit Year"];
        year_Billing_Flag=NO;
    }
    return year_Billing_Flag;
}
-(BOOL)checkCardVaidationSettings
{
    BOOL isValid = [self.txtfld_CardNo_UpdateCard.text isValidCreditCardNumber];
    NSLog(@"%@",[NSString stringWithFormat:@"The number you entered is %@!", isValid ? @"valid" : @"isn't valid"]);
//    if(isValid)
//    {
        if([strPaymentType isEqualToString:@"VISA"]){
            BOOL isValidDigits=[Common checkVISACardRegx:self.txtfld_CardNo_UpdateCard.text];
            if(isValidDigits){
                if (isValid) {
                    cardNumber_Billing_Flag=YES;
                }else{
                    [Common showAlert:@"Invalid VISA Card Number" withMessage:@"Please Enter Valid VISA Card Number"];
                    cardNumber_Billing_Flag=NO;
                }
//                cardNumber_Billing_Flag=YES;
            }else{
                [Common showAlert:@"Invalid VISA Card Number" withMessage:@"Please Enter Valid VISA Card Number"];
                cardNumber_Billing_Flag=NO;
            }
        }
        else if([strPaymentType isEqualToString:@"AMERICAN"]){
            BOOL isValidDigits=[Common checkAMERICANCardRegx:self.txtfld_CardNo_UpdateCard.text];
            if(isValidDigits){
                if (isValid) {
                    cardNumber_Billing_Flag=YES;
                }else{
                    [Common showAlert:@"Invalid AMERICAN EXPRESS Card Number" withMessage:@"Please Enter Valid AMERICAN EXPRESS Card Number"];
                    cardNumber_Billing_Flag=NO;
                }
//                cardNumber_Billing_Flag=YES;
            }else{
                [Common showAlert:@"Invalid AMERICAN EXPRESS Card Number" withMessage:@"Please Enter Valid AMERICAN EXPRESS Card Number"];
                cardNumber_Billing_Flag=NO;
            }
        }
        else if([strPaymentType isEqualToString:@"DISCOVER"]){
            BOOL isValidDigits=[Common checkDISCOVERCardRegx:self.txtfld_CardNo_UpdateCard.text];
            if(isValidDigits){
                if (isValid) {
                    cardNumber_Billing_Flag=YES;
                }else{
                    [Common showAlert:@"Invalid DISCOVER Card Number" withMessage:@"Please Enter Valid DISCOVER Card Number"];
                    cardNumber_Billing_Flag=NO;
                }
            }else{
                [Common showAlert:@"Invalid DISCOVER Card Number" withMessage:@"Please Enter Valid DISCOVER Card Number"];
                cardNumber_Billing_Flag=NO;
            }
        }
        else if([strPaymentType isEqualToString:@"MASTRO"]){
            BOOL isValidDigits=[Common checkMASTROCardRegx:self.txtfld_CardNo_UpdateCard.text];
            if(isValidDigits){
                if (isValid) {
                    cardNumber_Billing_Flag=YES;
                }else{
                    [Common showAlert:@"Invalid MASTER Card Number" withMessage:@"Please Enter Valid MASTER Card Number"];
                    cardNumber_Billing_Flag=NO;
                }
            }else{
                [Common showAlert:@"Invalid MASTER Card Number" withMessage:@"Please Enter Valid MASTER Card Number"];
                cardNumber_Billing_Flag=NO;
            }
        }
        else{
            cardNumber_Billing_Flag=NO;
            [Common showAlert:@"Invalid Card Number" withMessage:@"Please Enter Valid Card Number"];
        }
//    }else{
//        cardNumber_Billing_Flag=NO;
//        [Common showAlert:@"Invalid Card Number" withMessage:@"Please Enter Valid Card Number"];
//    }
    return cardNumber_Billing_Flag;
}

-(IBAction)close_AlertView_Billing_UserManage_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            [alertView_Billing setHidden:YES];
            [self popUserAcc_DeleteOldConfiguration];
        }
            break;
        case 1:
        {
            [alertView_userManagement setHidden:YES];
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(deleteUserAccount) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 2:
        {
            [alertView_userManagement setHidden:YES];
            [self popUserAcc_DeleteOldConfiguration];
        }
            break;
        case 3:
        {
            [alertView_Billing setHidden:YES];
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(deleteControllerNetwork_NOID) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
            [self popUserAcc_DeleteOldConfiguration];
        }
            break;
    }
}

-(IBAction)openClose_Info_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    if([current_textfield_Billing resignFirstResponder]){
        [current_textfield_Billing resignFirstResponder];
    }
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.scrollUpdateCard setContentOffset:CGPointZero animated:YES];
    switch (btnTag.tag) {
        case 0:
            [alertView_info setHidden:NO];
//            [settingHeaderView setAlpha:0.6];
//            [settingConatinerView setAlpha:0.6];
//            [settingTabView setAlpha:0.6];
//            [scrollUpdateCard setAlpha:0.6];
            [self popUpNewConfiguration_Settings];
            break;
        case 1:
            [alertView_info setHidden:YES];
//            [settingHeaderView setAlpha:1.0];
//            [settingConatinerView setAlpha:1.0];
//            [settingTabView setAlpha:1.0];
//            [scrollUpdateCard setAlpha:1.0];
            [self popUpOldConfiguration_Settings];
            break;
        case 2:
        {
            self.viewAlert_CVVDigit.hidden=NO;
            [self popUpNewConfiguration_Settings];
        }
            break;
        case 3:
        {
            self.viewAlert_CVVDigit.hidden=YES;
            [self popUpOldConfiguration_Settings];
        }
            break;
    }
}

-(void)popUpNewConfiguration_Settings
{
    [settingHeaderView setAlpha:0.6];
    [settingConatinerView setAlpha:0.6];
    [settingTabView setAlpha:0.6];
    [scrollUpdateCard setAlpha:0.6];
}

-(void)popUpOldConfiguration_Settings
{
    [settingHeaderView setAlpha:1.0];
    [settingConatinerView setAlpha:1.0];
    [settingTabView setAlpha:1.0];
    [scrollUpdateCard setAlpha:1.0];
}
-(IBAction)paginationNext_Action_Billing:(id)sender{
    NSLog(@"Total Page ==%d",TotalPageBilling);
    UIButton *btnTag=(UIButton *)sender;
    switch (btnTag.tag) {
        case 0:  //Next
        {
            NSLog(@"current index =%d",currentIndexBilling);
            if(currentIndexBilling==TotalPageBilling)
            {
                return;
            }
            if(currentIndexBilling%5==0)
            {
                for(int index=currentIndexBilling;index>currentIndexBilling-5;index--)
                {
                    btnBillingHistory_Page[index].hidden=YES;
                }
                for(int index=currentIndexBilling+1;index<=currentIndexBilling+5;index++)
                {
                    btnBillingHistory_Page[index].hidden=NO;
                    if(index==TotalPageBilling)
                    {
                        index=TotalPageBilling+1;
                    }
                }
            }
            [btnBillingHistory_Page[currentIndexBilling] setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            [btnBillingHistory_Page[currentIndexBilling] setBackgroundColor:[UIColor clearColor]];
            [btnBillingHistory_Page[currentIndexBilling] setBackgroundImage:[UIImage imageNamed:@"grayBoxImage"] forState:UIControlStateNormal];
            
            currentIndexBilling=currentIndexBilling+1;
            [btnBillingHistory_Page[currentIndexBilling] setBackgroundColor:lblRGBA(255, 206, 52, 1)];
            [btnBillingHistory_Page[currentIndexBilling] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnBillingHistory_Page[currentIndexBilling] setBackgroundImage:nil forState:UIControlStateNormal];
            [self.scroll_Billing_History.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            pageindexBilling=currentIndexBilling-1;
            NSLog(@"page index==%ld",(long)pageindexBilling);
            NSUInteger start = countPerPageBilling * pageindexBilling;
            NSRange range = NSMakeRange(start, MIN([arrBilling_History count] - start, countPerPageBilling));
            arrBillingHistorySplit = [arrBilling_History subarrayWithRange:range];
            //            NSRange range = NSMakeRange(start, MIN([arrUserBilling_Controller count] - start, countPerPageBilling));
            //            arrBillingHistorySplit = [arrUserBilling_Controller subarrayWithRange:range];
            
            PreviousIndexBilling=currentIndexBilling;
            [self loadBilling_HistoryDatas:arrBillingHistorySplit];
            if(currentIndexBilling==TotalPageBilling)
            {
                [btnPageNext_billing setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
                [btnPageNext_billing setBackgroundColor:[UIColor clearColor]];
                [btnPageNext_billing setBackgroundImage:[UIImage imageNamed:@"bigGrayBoxImage"] forState:UIControlStateNormal];
                btnPageNext_billing.userInteractionEnabled=NO;
            }else{
                [btnPageNext_billing setBackgroundColor:lblRGBA(255, 206, 52, 1)];
                [btnPageNext_billing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnPageNext_billing setBackgroundImage:nil forState:UIControlStateNormal];
                btnPageNext_billing.userInteractionEnabled=YES;
            }
            if(currentIndexBilling==1)
            {
                [btnPagePrev_Billing setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
                [btnPagePrev_Billing setBackgroundColor:[UIColor clearColor]];
                [btnPagePrev_Billing setBackgroundImage:[UIImage imageNamed:@"bigGrayBoxImage"] forState:UIControlStateNormal];
                btnPagePrev_Billing.userInteractionEnabled=NO;
            }else{
                [btnPagePrev_Billing setBackgroundColor:lblRGBA(255, 206, 52, 1)];
                [btnPagePrev_Billing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnPagePrev_Billing setBackgroundImage:nil forState:UIControlStateNormal];
                btnPagePrev_Billing.userInteractionEnabled=YES;
            }
        }
            
            break;
        case 1: //Prev
        {
            NSLog(@"current index previous =%d",currentIndexBilling);
            currentIndexBilling=currentIndexBilling-1;
            if(currentIndexBilling<1)
            {
                btnPagePrev_Billing.userInteractionEnabled=NO;
                return;
            }
            if(currentIndexBilling%5==0)
            {
                for(int index=currentIndexBilling+1;index<=currentIndexBilling+5;index++)
                {
                    btnBillingHistory_Page[index].hidden=YES;
                    if(index==TotalPageBilling)
                    {
                        index=TotalPageBilling+1;
                    }
                }
                for(int index=currentIndexBilling-4;index<=currentIndexBilling;index++)
                {
                    btnBillingHistory_Page[index].hidden=NO;
                }
            }
            
            [btnBillingHistory_Page[PreviousIndexBilling] setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            [btnBillingHistory_Page[PreviousIndexBilling] setBackgroundColor:[UIColor clearColor]];
            [btnBillingHistory_Page[PreviousIndexBilling] setBackgroundImage:[UIImage imageNamed:@"grayBoxImage"] forState:UIControlStateNormal];
            
            //currentIndex=currentIndex+1;
            [btnBillingHistory_Page[currentIndexBilling] setBackgroundColor:lblRGBA(255, 206, 52, 1)];
            [btnBillingHistory_Page[currentIndexBilling] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnBillingHistory_Page[currentIndexBilling] setBackgroundImage:nil forState:UIControlStateNormal];
            [self.scroll_Billing_History.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            pageindexBilling=currentIndexBilling-1;
            NSLog(@"page index==%ld",(long)pageindexBilling);
            NSUInteger start = countPerPageBilling * pageindexBilling;
            NSRange range = NSMakeRange(start, MIN([arrBilling_History count] - start, countPerPageBilling));
            arrBillingHistorySplit = [arrBilling_History subarrayWithRange:range];
            //            NSRange range = NSMakeRange(start, MIN([arrUserBilling_Controller count] - start, countPerPageBilling));
            //            arrBillingHistorySplit = [arrUserBilling_Controller subarrayWithRange:range];
            
            PreviousIndexBilling=currentIndexBilling;
            [self loadBilling_HistoryDatas:arrBillingHistorySplit];
            if(currentIndexBilling==1)
            {
                [btnPagePrev_Billing setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
                [btnPagePrev_Billing setBackgroundColor:[UIColor clearColor]];
                [btnPagePrev_Billing setBackgroundImage:[UIImage imageNamed:@"bigGrayBoxImage"] forState:UIControlStateNormal];
                btnPagePrev_Billing.userInteractionEnabled=NO;
            }else{
                [btnPagePrev_Billing setBackgroundColor:lblRGBA(255, 206, 52, 1)];
                [btnPagePrev_Billing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnPagePrev_Billing setBackgroundImage:nil forState:UIControlStateNormal];
                btnPagePrev_Billing.userInteractionEnabled=YES;
            }
            if(currentIndexBilling==TotalPageBilling)
            {
                [btnPageNext_billing setTitleColor:lblRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
                [btnPageNext_billing setBackgroundColor:[UIColor clearColor]];
                [btnPageNext_billing setBackgroundImage:[UIImage imageNamed:@"bigGrayBoxImage"] forState:UIControlStateNormal];
                btnPageNext_billing.userInteractionEnabled=NO;
            }else{
                [btnPageNext_billing setBackgroundColor:lblRGBA(255, 206, 52, 1)];
                [btnPageNext_billing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnPageNext_billing setBackgroundImage:nil forState:UIControlStateNormal];
                btnPageNext_billing.userInteractionEnabled=YES;
            }
        }
            break;
    }
}

-(void)selectNetwork_Enable_Disable
{
    if ([strSelectNWStatus isEqualToString:@"YES"]) {
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            user_Acc_View_Mgt.frame = CGRectMake(user_Acc_View_Mgt.frame.origin.x, selectNetworkView.frame.origin.y+selectNetworkView.frame.size.height, user_Acc_View_Mgt.frame.size.width, user_Acc_View_Mgt.frame.size.height);
        }completion:^(BOOL finished) {
            strSelectNWStatus=@"NO";
            [selectNetworkView setHidden:NO];
            if ([strUserAccountList_LoadedStatus isEqualToString:@""]) {
                self.bodyViewScroll_UserManage.contentSize=CGSizeMake(self.bodyViewScroll_UserManage.frame.size.width, self.selectNetworkView.frame.origin.y+selectNetworkView.frame.size.height+20);
            }else{
                self.bodyViewScroll_UserManage.contentSize=CGSizeMake(self.bodyViewScroll_UserManage.frame.size.width, self.user_Acc_View_Mgt.frame.origin.y+user_Acc_View_Mgt.frame.size.height+20);
            }
        }];
    }else{
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [selectNetworkView setHidden:YES];
            user_Acc_View_Mgt.frame = CGRectMake(user_Acc_View_Mgt.frame.origin.x, addUser_View_Mgt.frame.origin.y+addUser_View_Mgt.frame.size.height, user_Acc_View_Mgt.frame.size.width, user_Acc_View_Mgt.frame.size.height);
        }completion:^(BOOL finished) {
            strSelectNWStatus=@"YES";
            if ([strUserAccountList_LoadedStatus isEqualToString:@""]) {
                self.bodyViewScroll_UserManage.contentSize=CGSizeMake(self.bodyViewScroll_UserManage.frame.size.width, self.addUser_View_Mgt.frame.origin.y+addUser_View_Mgt.frame.size.height+20);
            }else{
                self.bodyViewScroll_UserManage.contentSize=CGSizeMake(self.bodyViewScroll_UserManage.frame.size.width, self.user_Acc_View_Mgt.frame.origin.y+user_Acc_View_Mgt.frame.size.height+20);
            }
        }];
    }
}

-(void)reset_UserManagement_Details
{
    txtfld_Fname_userManagement.text=@"";
    txtfld_Lname_userManagement.text=@"";
    txtfld_email_userManagement.text=@"";
    strAccessType=@"";
    strNameStatus=@"NO";
    strLastNameStatus=@"NO";
    strEmailStatus=@"NO";
    mail_Flag=NO;
    self.lblName_UM.hidden=YES;
    self.lblLastName_UM.hidden=YES;
    self.lblEmail_UM.hidden=YES;
    self.imgView_Name_UM.backgroundColor=lblRGBA(255, 206, 52, 1);
    self.imgView_Email_UM.backgroundColor=lblRGBA(255, 206, 52, 1);
    
    [viewOnlybtn_userManage setImage:[UIImage imageNamed:@"checkBox_UserManagei6plus"] forState:UIControlStateNormal];
    [changeSchedule_userManage setImage:[UIImage imageNamed:@"checkBox_UserManagei6plus"] forState:UIControlStateNormal];
    [fullAccess_userManage setImage:[UIImage imageNamed:@"checkBox_UserManagei6plus"] forState:UIControlStateNormal];

    for (int i=0; i<[arr_NetworkList count]; i++) {
        [btn_Chk_Network_AddUser[i] setImage:[UIImage imageNamed:@"checkBox_UserManagei6plus"] forState:UIControlStateNormal];
        lbl_AccessType[i].text=@"";
    }
    
    [arr_Networkid removeAllObjects];
    [self selectNetwork_Enable_Disable];
}

-(IBAction)signOut_Action:(id)sender
{
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(signOutService) withObject:self];
        
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
}

-(IBAction)userPermissionType_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //View Only
        {
            if ([strSelectedNw_Status isEqualToString:@"userAccDetail"]) {
                lbl_UserAcc_AccessType[userAcc_AccessTag].text = [NSString stringWithFormat:@"%@",[sender currentTitle]];
                strUserAccessType = @"2";
                [btn_Chk_Network_UserAcc[userAcc_AccessTag] setImage:[UIImage imageNamed:@"bgYellowTickImagei6plus"] forState:UIControlStateNormal];
                [self userAccNetworkList];
            }else{
                lbl_AccessType[accessTypeTag].text = [NSString stringWithFormat:@"%@",[sender currentTitle]];
                strAccessType = @"2";
                [self addSelectNetworkList];
            }
        }
            break;
        case 1: //Change Schedule
        {
            if ([strSelectedNw_Status isEqualToString:@"userAccDetail"]) {
                lbl_UserAcc_AccessType[userAcc_AccessTag].text = [NSString stringWithFormat:@"%@",[sender currentTitle]];
                strUserAccessType = @"3";
                [btn_Chk_Network_UserAcc[userAcc_AccessTag] setImage:[UIImage imageNamed:@"bgYellowTickImagei6plus"] forState:UIControlStateNormal];
                [self userAccNetworkList];
            }else{
                lbl_AccessType[accessTypeTag].text = [NSString stringWithFormat:@"%@",[sender currentTitle]];
                strAccessType = @"3";
                [self addSelectNetworkList];
            }
        }
            break;
        case 2: //Full access
        {
            if ([strSelectedNw_Status isEqualToString:@"userAccDetail"]) {
                lbl_UserAcc_AccessType[userAcc_AccessTag].text = [NSString stringWithFormat:@"%@",[sender currentTitle]];
                strUserAccessType = @"1";
                [btn_Chk_Network_UserAcc[userAcc_AccessTag] setImage:[UIImage imageNamed:@"bgYellowTickImagei6plus"] forState:UIControlStateNormal];
                [self userAccNetworkList];
            }else{
                lbl_AccessType[accessTypeTag].text = [NSString stringWithFormat:@"%@",[sender currentTitle]];
                strAccessType = @"1";
                [self addSelectNetworkList];
            }
        }
            break;
        case 3: //Delete / None
        {
            if ([strSelectedNw_Status isEqualToString:@"userAccDetail"]) {
                if (![[btn_Chk_Network_UserAcc[userAcc_AccessTag] imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkBox_UserManagei6plus"]]) {
                    lbl_UserAcc_AccessType[userAcc_AccessTag].text = @"";
                    strUserAccessType = @"4";
                    [btn_Chk_Network_UserAcc[userAcc_AccessTag] setImage:[UIImage imageNamed:@"checkBox_UserManagei6plus"] forState:UIControlStateNormal];
                    [self userAccNetworkList];
                }
            }else{
                if (![[btn_Chk_Network_AddUser[accessTypeTag] imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkBox_UserManagei6plus"]]) {
                    lbl_AccessType[accessTypeTag].text = @"";
                    strAccessType = @"4";
                    [btn_Chk_Network_AddUser[accessTypeTag] setImage:[UIImage imageNamed:@"checkBox_UserManagei6plus"] forState:UIControlStateNormal];
                    NSString *strNwID = [[[arr_NetworkList objectAtIndex:accessTypeTag] objectForKey:@"id"] stringValue];
                    for (int i=0; i<[arr_Networkid count]; i++) {
                        if ([[[arr_Networkid objectAtIndex:i] valueForKey:kNetworkID] isEqualToString:strNwID]) {
                            [arr_Networkid removeObjectAtIndex:i];
                        }
                    }
                    NSLog(@"arrrr %@",arr_Networkid);
                }
            }
        }
            break;
        case 4: //close
        {
            NSLog(@"close button clicked");
        }
        case 5: //none
        {
//            if ([strSelectedNw_Status isEqualToString:@"userAccDetail"]) {
//                lbl_UserAcc_AccessType[userAcc_AccessTag].text = [NSString stringWithFormat:@"%@",[sender currentTitle]];
//                strUserAccessType = @"5";
//                [btn_Chk_Network_UserAcc[userAcc_AccessTag] setImage:[UIImage imageNamed:@"bgYellowTickImagei6plus"] forState:UIControlStateNormal];
//                [self userAccNetworkList];
//            }else{
//                lbl_AccessType[accessTypeTag].text = [NSString stringWithFormat:@"%@",[sender currentTitle]];
//                strAccessType = @"5";
//                [self addSelectNetworkList];
//            }
        }
            break;
    }
    self.view_PermissionAlert.hidden=YES;
    [self popup_Settings_Alpha_Enabled];
}

-(IBAction)planUpgrade_Confirmation_Billing_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Plan Downgrade Okay
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(quoteForDowngradeControllerSettings) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 1: //Plan Downgrade Cancel
        {
            self.viewAlert_PlanUpgrade_Billing.hidden=YES;
            [self popup_Settings_Alpha_Enabled];
        }
            break;
        case 2: //Charge my card Downgrade
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(quoteForDowngradeControllerConfirmationSettings) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
            
        }
            break;
        case 3: //Confirmation cancel Downgrade
        {
            self.viewAlert_PlanUpgrade_Confirm_Billing.hidden=YES;
            [self popup_Settings_Alpha_Enabled];
        }
            break;
    }
}

#pragma mark - Orientation
/* **********************************************************************************
 Date : 25/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Set the Orientation of the view
 Method Name : shouldAutorotate(Pre Defined Method)
 ************************************************************************************* */
- (BOOL) shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate.strLaunchOrientation isEqualToString:@"YES"]) {
        return  UIInterfaceOrientationMaskPortrait;
    }else{
        return  UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
    }

    //return here which orientation you are going to support
}
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        NSLog(@"Landscape left");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        [Common viewFadeIn:self.navigationController.view];
        [self.navigationController pushViewController:TLVC animated:NO];
        
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        NSLog(@"Landscape right");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        [Common viewFadeIn:self.navigationController.view];
        [self.navigationController pushViewController:TLVC animated:NO];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        
    }
} 

#pragma mark - WebService Implementation
-(void)getAllNetworksID_NOID{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults_Settings objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks",[defaults_Settings objectForKey:@"ACCOUNTID"]];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Controller Availability==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(load_Network_Contents) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Controller Availability ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorNetworkSetup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
    
}
-(void)responseErrorNetworkSetup{
    [Common showAlert:@"Warning" withMessage:strResponseError];
}
-(void)load_Network_Contents{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            arr_NetworkList = [[NSMutableArray alloc] init];
            NSMutableArray *arrTempUM=[responseDict objectForKey:@"data"];
            NSLog(@"%@",arrTempUM);
            NSLog(@"arr_Network_Data count==%lu",(unsigned long)arrTempUM.count);
            for(int i=0;i<arrTempUM.count;i++)
            {
                NSLog(@"invitee %@",[[arrTempUM objectAtIndex:i]objectForKey:@"inviteeNetStatus"]);
                NSLog(@"access %@",[[arrTempUM objectAtIndex:i] objectForKey:@"accessTypeId"]);
                if([[[arrTempUM objectAtIndex:i] objectForKey:@"accessTypeId"] intValue]==0 && [[[[arrTempUM objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"controllerTypeId"] intValue]==1)
                {
                    //arr_NetworkList[i] = [arrTempUM objectAtIndex:i];
                    [arr_NetworkList addObject:[arrTempUM objectAtIndex:i]];
                }
                else if([[[arrTempUM objectAtIndex:i] objectForKey:@"accessTypeId"] intValue]==0 && [[[[arrTempUM objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"controllerTypeId"] intValue]==2 &&[[[[arrTempUM objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentCompleted"] boolValue] &&[[[[arrTempUM objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentRenewed"] boolValue])
                {
                    [arr_NetworkList addObject:[arrTempUM objectAtIndex:i]];
                }
                else if([[[arrTempUM objectAtIndex:i] objectForKey:@"accessTypeId"] intValue]==1 && [[[arrTempUM objectAtIndex:i]objectForKey:@"inviteeNetStatus"] intValue]==2 && [[[[arrTempUM objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"controllerTypeId"] intValue]==1)
                {
                    [arr_NetworkList addObject:[arrTempUM objectAtIndex:i]];
                }
                else if([[[arrTempUM objectAtIndex:i] objectForKey:@"accessTypeId"] intValue]==1 && [[[arrTempUM objectAtIndex:i]objectForKey:@"inviteeNetStatus"] intValue]==2 && [[[[arrTempUM objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"controllerTypeId"] intValue]==2 && [[[[arrTempUM objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentCompleted"] boolValue] &&[[[[arrTempUM objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentRenewed"] boolValue])
                {
                    [arr_NetworkList addObject:[arrTempUM objectAtIndex:i]];
                }
                NSLog(@"arr_Network_Data count==%lu",(unsigned long)arr_NetworkList.count);
            }
            strNetworkLoadedStatus=@"YES";
            [self performSelectorInBackground:@selector(user_ManagementList) withObject:self];
        }else{
//            [self stop_PinWheel_UserSettings];
            [self performSelectorInBackground:@selector(user_ManagementList) withObject:self];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)getUserProfile_Basic_Details
{
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    NSLog(@"Time Zone ==%@",[defaults_Settings objectForKey:@"TIMEZONE"]);
    NSLog(@"Language ==%@",[defaults_Settings objectForKey:@"LANGUAGE"]);
    NSLog(@"Account id ==%@",[defaults_Settings objectForKey:@"ACCOUNTID"]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"%@%@",Get_User_Settings_Basic_Details,[defaults_Settings objectForKey:@"ACCOUNTID"]];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for User Basic Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseUserSettings_BasicDetails) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for User Basic Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)responseUserSettings_BasicDetails
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            NSLog(@"DICT controller Data ==%@",dicitData);
            NSLog(@"DIC controller Data  count==%lu",(unsigned long)dicitData.count);
            if([dicitData count]>0)
            {
                defaults_Settings=[NSUserDefaults standardUserDefaults];
                strEmailVal_status = @"YES";
                self.lbl_name_settings.text=[dicitData objectForKey:@"firstName"];
                self.lbl_Lname_settings.text=[dicitData objectForKey:@"lastName"];
                self.lbl_email_settings.text=[dicitData objectForKey:@"emailId"];
                txtfld_name_settings.text=lbl_name_settings.text;
                txtfld_Lname_settings.text=lbl_Lname_settings.text;
                txtfld_email_settings.text=lbl_email_settings.text;
                strEmailAddress = lbl_email_settings.text;
                self.lbl_Language.text=[dicitData objectForKey:@"language"];
                self.lbl_TimeZone.text=[dicitData objectForKey:@"timeZone"];
                strLatitude=[dicitData objectForKey:@"latitude"];
                strLongitude=[dicitData objectForKey:@"longitude"];
                strOrgTimeZone=[dicitData objectForKey:@"timeZoneId"];
                NSLog(@"org time zone id == %@",strOrgTimeZone);
                
//                if ([dicitData objectForKey:@"language"] == [NSNull null]) {
//                    NSLog(@"null");
//                    self.lbl_Language.text=[defaults_Settings objectForKey:@"LANGUAGE"];
//                }else{
//                    self.lbl_Language.text=[dicitData objectForKey:@"language"];
//                }
//                if ([dicitData objectForKey:@"timeZone"] == [NSNull null]) {
//                    NSLog(@"null");
//                    self.lbl_TimeZone.text=[defaults_Settings objectForKey:@"TIMEZONE"];
//                }else{
//                    self.lbl_TimeZone.text=[dicitData objectForKey:@"timeZone"];
//                }
                strTimeZone=self.lbl_TimeZone.text;
                strLanguage = self.lbl_Language.text;
                if([[dicitData objectForKey:@"temperatureType"] isEqualToString:@"c"]){
                    [self changeCentigrade];
                }else{
                    [self changeFahrenheit];
                }
                
                strInAppStatus = [[dicitData objectForKey:@"inAppStatus"] stringValue];
                
                self.settingHomeView.hidden=NO;
                [self stop_PinWheel_UserSettings];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
                [self stop_PinWheel_UserSettings];
            }
        }else{
            [self stop_PinWheel_UserSettings];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)responseErrorUserSettings
{
    [Common showAlert:kAlertTitleWarning withMessage:strResponseError];
}

-(void)update_UserSettingsNOID
{
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    
    NSLog(@"User Account id ==%@",[defaults_Settings objectForKey:@"ACCOUNTID"]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictController_User_Details=[[NSMutableDictionary alloc] init];
    [dictController_User_Details setObject:[NSString stringWithFormat:@"%@",[defaults_Settings objectForKey:@"ACCOUNTID"]] forKey:kAccountID];
    [dictController_User_Details setObject:lbl_name_settings.text forKey:kFirstName];
    [dictController_User_Details setObject:lbl_Lname_settings.text forKey:kLastName];
    [dictController_User_Details setObject:lbl_email_settings.text forKey:kEmailID];
    [dictController_User_Details setObject:temperatureType forKey:kTemperatureType];
    [dictController_User_Details setObject:strInAppStatus forKey:kInAppStatus];
    [dictController_User_Details setObject:strTimeZone forKey:KTimeZone];
    [dictController_User_Details setObject:strLanguage forKey:kLanguage];
    [dictController_User_Details setObject:strLatitude forKey:kLat];
    [dictController_User_Details setObject:strLongitude forKey:kLong];
    [dictController_User_Details setObject:strOrgTimeZone forKey:kOrgTimeZone];
    
    parameters=[SCM userSettingsUpdate:dictController_User_Details];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update cellular Controller Device Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(response_UpdateUserSettings_Response) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Controller cellular Device Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:Update_UserSettings];
}
-(void)response_UpdateUserSettings_Response
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            strHistoryUpdateStatus=@"YES";
            NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            NSLog(@"DICT controller Data ==%@",dicitData);
            NSLog(@"DIC controller Data  count==%lu",(unsigned long)dicitData.count);
            if([strEditMode isEqualToString:@"name"]){
                [self reset_UserName_Container];
            }
            else if([strEditMode isEqualToString:@"email"]){
                strEmailAddress = lbl_email_settings.text;
                [self reset_EMail_Container];
                defaults_Settings = [NSUserDefaults standardUserDefaults];
                [defaults_Settings setObject:lbl_email_settings.text forKey:@"MAILID"];
                [defaults_Settings synchronize];
            }
            else if ([strEditMode isEqualToString:@"timezone"]){
                self.lbl_TimeZone.text=[dicitData objectForKey:@"timeZone"];
                strTimeZone=self.lbl_TimeZone.text;
                strBillingUpdateStatus=@"YES";
                appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.strTimeZoneChanged_Status=@"YES";
                appDelegate.strWeatherChanged=@"YES";
            }
            self.lbl_Language.text=[dicitData objectForKey:@"language"];
            strLanguage=self.lbl_Language.text;

            if([[dicitData objectForKey:@"temperatureType"] isEqualToString:@"c"]){
                [self changeCentigrade];
            }else{
                [self changeFahrenheit];
            }
            [self stop_PinWheel_UserSettings];
            // [Common showAlert:kAlertTitleSuccess withMessage:responseMessage];
        }else{
            [self stop_PinWheel_UserSettings];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            if([strEditMode isEqualToString:@"email"]){
                lbl_email_settings.text = strEmailAddress;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)getBilling_Section
{
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    NSLog(@"Account id ==%@",[defaults_Settings objectForKey:@"ACCOUNTID"]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/billing/history",[defaults_Settings objectForKey:@"ACCOUNTID"]];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Billing Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseBillingDetails) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Billing Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
-(void)responseBillingDetails
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            NSLog(@"DICT billing details ==%@",dicitData);
            if([dicitData count]>0)
            {
                strTimeZoneIDFor_User=[[[responseDict valueForKey:@"data"] objectForKey:@"account"] objectForKey:@"timeZoneId"];
                strBillingLoadedStatus=@"YES";
                [self parseBilling_Section:dicitData];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
                [self stop_PinWheel_UserSettings];
            }
        }else{
            [self stop_PinWheel_UserSettings];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)parseBilling_Section:(NSDictionary *)dictBilling
{
    @try {
        
        
        self.viewController_PlanOptions.hidden=YES;
        arrUserBilling_Controller = [[NSMutableArray alloc] init];
        arrUserBilling_Controller=[dictBilling objectForKey:@"controller"];
        arrBilling_History=[dictBilling objectForKey:@"billingHistory"];
        if([dictBilling objectForKey:@"cardDetails"] == [NSNull null])
        {
            NSLog(@"card details empty");
            self.view_Settings_CardDetailView.hidden=YES;
            if([arrUserBilling_Controller count]>0)
            {
                self.view_Settings_CardControllerView.hidden=NO;
                self.scroll_Billing_Controller.hidden=NO;
                self.view_Settings_CardControllerView.frame=CGRectMake(self.view_Settings_CardControllerView.frame.origin.x, 0, self.view_Settings_CardControllerView.frame.size.width, self.view_Settings_CardControllerView.frame.size.height);
                self.scroll_Billing_Controller.frame=CGRectMake(self.scroll_Billing_Controller.frame.origin.x, self.view_Settings_CardControllerView.frame.origin.y+self.view_Settings_CardControllerView.frame.size.height, self.scroll_Billing_Controller.frame.size.width, self.scroll_Billing_Controller.frame.size.height);
                [self loadControllerDatas];
                if([dictBilling objectForKey:@"currentBillingPlan"]== [NSNull null])
                {
                    self.viewController_Plan.hidden=YES;
                    self.viewController_PlanOptions.hidden=NO;
                    self.viewController_PlanOptions.frame=CGRectMake(self.viewController_PlanOptions.frame.origin.x, self.scroll_Billing_Controller.frame.origin.y+self.scroll_Billing_Controller.frame.size.height+10, self.viewController_PlanOptions.frame.size.width, self.viewController_PlanOptions.frame.size.height);
                    self.viewBilling_History.frame=CGRectMake(self.viewBilling_History.frame.origin.x, self.viewController_PlanOptions.frame.origin.y+self.viewController_PlanOptions.frame.size.height, self.viewBilling_History.frame.size.width, self.viewBilling_History.frame.size.height);
                }else{
                    self.viewBilling_RenewalDate.hidden=YES;
                    self.viewBilling_History.frame=CGRectMake(self.viewBilling_History.frame.origin.x, self.viewController_Plan.frame.origin.y+self.viewController_Plan.frame.size.height, self.viewBilling_History.frame.size.width, self.viewBilling_History.frame.size.height);
                }
            }else{
                self.view_Settings_CardControllerView.hidden=YES;
                self.scroll_Billing_Controller.hidden=YES;
                if([dictBilling objectForKey:@"currentBillingPlan"]== [NSNull null])
                {
                    self.viewController_Plan.hidden=YES;
                    self.viewController_PlanOptions.hidden=NO;
                    self.viewPlanWifi.hidden=NO;
                    self.viewController_PlanOptions.frame=CGRectMake(self.viewController_PlanOptions.frame.origin.x,self.viewPlanWifi.frame.origin.y+self.viewPlanWifi.frame.size.height+20, self.viewController_PlanOptions.frame.size.width, self.viewController_PlanOptions.frame.size.height);
                    self.viewBilling_History.frame=CGRectMake(self.viewBilling_History.frame.origin.x, self.viewController_PlanOptions.frame.origin.y+self.viewController_PlanOptions.frame.size.height+20, self.viewBilling_History.frame.size.width, self.viewBilling_History.frame.size.height);
                }else{
                    self.viewController_Plan.frame=CGRectMake(self.viewController_Plan.frame.origin.x,0,self.viewController_Plan.frame.size.width, self.viewController_Plan.frame.size.height);
                    self.viewBilling_History.frame=CGRectMake(self.viewBilling_History.frame.origin.x, self.viewController_Plan.frame.origin.y+self.viewController_Plan.frame.size.height, self.viewBilling_History.frame.size.width, self.viewBilling_History.frame.size.height);
                }
            }
        }else{
            [self putCardDetailsSettings:[dictBilling objectForKey:@"cardDetails"]];
            self.view_Settings_CardDetailView.hidden=NO;
            if([arrUserBilling_Controller count]>0)
            {
                self.view_Settings_CardControllerView.hidden=NO;
                self.scroll_Billing_Controller.hidden=NO;
                [self loadControllerDatas];
                if([dictBilling objectForKey:@"currentBillingPlan"]== [NSNull null])
                {
                    self.viewController_Plan.hidden=YES;
                    self.viewController_PlanOptions.hidden=NO;
                    self.viewController_PlanOptions.frame=CGRectMake(self.viewController_PlanOptions.frame.origin.x, self.scroll_Billing_Controller.frame.origin.y+self.scroll_Billing_Controller.frame.size.height, self.viewController_PlanOptions.frame.size.width, self.viewController_PlanOptions.frame.size.height);
                    self.viewBilling_History.frame=CGRectMake(self.viewBilling_History.frame.origin.x, self.viewController_PlanOptions.frame.origin.y+self.viewController_PlanOptions.frame.size.height, self.viewBilling_History.frame.size.width, self.viewBilling_History.frame.size.height);
                }else{
                    self.viewBilling_History.frame=CGRectMake(self.viewBilling_History.frame.origin.x, self.viewController_Plan.frame.origin.y+self.viewController_Plan.frame.size.height, self.viewBilling_History.frame.size.width, self.viewBilling_History.frame.size.height);
                }
            }else{
                self.view_Settings_CardControllerView.hidden=YES;
                self.scroll_Billing_Controller.hidden=YES;
                if([dictBilling objectForKey:@"currentBillingPlan"]== [NSNull null])
                {
                    self.viewController_Plan.hidden=YES;
                    self.viewController_PlanOptions.hidden=NO;
                    self.viewController_PlanOptions.frame=CGRectMake(self.viewController_PlanOptions.frame.origin.x,self.view_Settings_CardDetailView.frame.origin.y+self.view_Settings_CardDetailView.frame.size.height+20, self.viewController_PlanOptions.frame.size.width, self.viewController_PlanOptions.frame.size.height);
                    self.viewBilling_History.frame=CGRectMake(self.viewBilling_History.frame.origin.x, self.viewController_PlanOptions.frame.origin.y+self.viewController_PlanOptions.frame.size.height+20, self.viewBilling_History.frame.size.width, self.viewBilling_History.frame.size.height);
                }else{
                    self.viewController_Plan.frame=CGRectMake(self.viewController_Plan.frame.origin.x,self.view_Settings_CardControllerView.frame.origin.y+self.view_Settings_CardControllerView.frame.size.height,self.viewController_Plan.frame.size.width, self.viewController_Plan.frame.size.height);
                    self.viewBilling_History.frame=CGRectMake(self.viewBilling_History.frame.origin.x, self.viewController_Plan.frame.origin.y+self.viewController_Plan.frame.size.height, self.viewBilling_History.frame.size.width, self.viewBilling_History.frame.size.height);
                }
            }
        }
        if([dictBilling objectForKey:@"currentBillingPlan"]== [NSNull null])
        {
            
        }else{
            NSDictionary *currentPlan=[dictBilling objectForKey:@"currentBillingPlan"];
            NSLog(@"currenplan==%@",currentPlan);
            currentPlan=[currentPlan objectForKey:@"billingPlan"];
            NSLog(@"currenplan==%@",currentPlan);
            NSDictionary *dictPlan_Details=[currentPlan valueForKey:@"plan"];
            NSLog(@"plan==%@",dictPlan_Details);
            NSLog(@"plan name==%@",[dictPlan_Details objectForKey:@"name"]);
            NSLog(@"plan hub==%@",[[currentPlan objectForKey:@"hub"] stringValue]);
            NSLog(@"plan hub==%@",[currentPlan objectForKey:@"price"]);
            lbl_Plan_Name_MainView.text =[dictPlan_Details objectForKey:@"name"];
            lbl_Plan_Name_Detail_View.text=[dictPlan_Details objectForKey:@"name"];
            lbl_Plan_Controller_Name_MainView.text=[[currentPlan objectForKey:@"hub"] stringValue];
            lbl_Plan_Controller_Cost_Detail_View.text = [NSString stringWithFormat:@"$%.2f",[[currentPlan objectForKey:@"price"] floatValue]];
            NSTimeInterval date =[[NSString stringWithFormat:@"%@",[currentPlan objectForKey:@"expiryDate"]] doubleValue];
            NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:date/1000];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:[Common GetCurrentDateFormat]];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:strTimeZoneIDFor_User]];
            NSString *timestamp = [dateFormatter stringFromDate:epochNSDate];
            NSLog(@"Your local date is: %@", timestamp);
            lbl_Plan_RenewalDate_Detail_View.text = timestamp;

            if([dictBilling objectForKey:@"cardDetails"] == [NSNull null]){
                lbl_Plan_RenewalDate_MainView.text=[NSString stringWithFormat:@"%@: $%.2f",[dictPlan_Details valueForKey:@"name"],[[currentPlan objectForKey:@"price"] floatValue]];
            }else{
                lbl_Plan_RenewalDate_MainView.text=[NSString stringWithFormat:@"%@: $%.2f/ RENEWAL DATE: %@",[dictPlan_Details valueForKey:@"name"],[[currentPlan objectForKey:@"price"] floatValue],timestamp];
            }
            lbl_Plan_Controller_Count_MainView.text=[NSString stringWithFormat:@"%@ - %@ NOIDS",[[dictPlan_Details valueForKey:@"minLimit"] stringValue],[[dictPlan_Details valueForKey:@"maxLimit"] stringValue]];
        }
        if(arrBilling_History.count>0)
        {
            NSLog(@"Total running billing history =%lu",(unsigned long)arrBilling_History.count);
            int totalBillingHistory_Count=(int)arrBilling_History.count;
            TotalPageBilling=totalBillingHistory_Count/countPerPageBilling;
            if(totalBillingHistory_Count%countPerPageBilling>0)
            {
                TotalPageBilling=TotalPageBilling+1;
            }
            NSLog(@"Total Page =%d",TotalPageBilling);
            NSUInteger start = countPerPageBilling * pageindexBilling;
            NSLog(@"page index==%ld",(long)pageindexBilling);
            NSRange range = NSMakeRange(start, MIN([arrBilling_History count] - start, countPerPageBilling));
            arrBillingHistorySplit = [arrBilling_History subarrayWithRange:range];
            [self loadBilling_HistoryDatas:arrBillingHistorySplit];
        }else{
            self.viewBilling_History.hidden=YES;
        }
        
        
        NSLog(@"scroll height=%f",self.scroll_Billing_Main_Container.frame.size.height);
        self.scroll_Billing_Main_Container.contentSize=CGSizeMake(self.scroll_Billing_Main_Container.frame.size.width, self.viewBilling_History.frame.origin.y+self.viewBilling_History.frame.size.height);
        NSLog(@"scroll  after=%f",self.scroll_Billing_Main_Container.frame.size.height);
        self.settingBillingView.hidden=NO;
        [self stop_PinWheel_UserSettings];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)putCardDetailsSettings:(NSDictionary *)dictCardDetails
{
    NSLog(@"card det=%@",dictCardDetails);
    if([[[[dictCardDetails objectForKey:@"cardType"] objectForKey:@"id"] stringValue] isEqualToString:@"1"]){
        
        strPaymentType=@"VISA";
        imgView_CC_Logo.image=[UIImage imageNamed:@"visaUpdateCardImagei6plus"];
        lbl_CC_Number.text=[NSString stringWithFormat:@"************%@",[dictCardDetails objectForKey:@"cardNumber"]];
        imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_On"];
        txtfld_digits_UpdateCard.placeholder = @"CVV2 (3 DIGITS)";
    }
    else  if([[[[dictCardDetails objectForKey:@"cardType"] objectForKey:@"id"]stringValue] isEqualToString:@"2"]){
        
        strPaymentType=@"MASTRO";
        imgView_CC_Logo.image=[UIImage imageNamed:@"masterCardImagei6plus"];
        lbl_CC_Number.text=[NSString stringWithFormat:@"************%@",[dictCardDetails objectForKey:@"cardNumber"]];
        imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_On"];
        txtfld_digits_UpdateCard.placeholder = @"CVC2 (3 DIGITS)";
    }
    else  if([[[[dictCardDetails objectForKey:@"cardType"] objectForKey:@"id"]stringValue] isEqualToString:@"4"]){
        strPaymentType=@"DISCOVER";
        imgView_CC_Logo.image=[UIImage imageNamed:@"discoverImagei6plus"];
        lbl_CC_Number.text=[NSString stringWithFormat:@"************%@",[dictCardDetails objectForKey:@"cardNumber"]];
        imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_On"];
        txtfld_digits_UpdateCard.placeholder = @"CID (3 DIGITS)";
    }
    else  if([[[[dictCardDetails objectForKey:@"cardType"] objectForKey:@"id"]stringValue] isEqualToString:@"3"]){
        strPaymentType=@"AMERICAN";
        imgView_CC_Logo.image=[UIImage imageNamed:@"americanExImagei6plus"];
        lbl_CC_Number.text=[NSString stringWithFormat:@"***********%@",[dictCardDetails objectForKey:@"cardNumber"]];
        imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_On"];
        txtfld_digits_UpdateCard.placeholder = @"CID (4 DIGITS)";
    }
    lbl_CC_Name.text=[dictCardDetails objectForKey:@"cardName"];
    // lbl_CC_Number.text=[NSString stringWithFormat:@"************%@",[dictCardDetails objectForKey:@"cardNumber"]];
    NSString *strMonth=[[dictCardDetails objectForKey:@"expireMonth"] stringValue];
    if([strMonth length]==1)
    {
        strMonth=[NSString stringWithFormat:@"%@%@",@"0",strMonth];
        NSLog(@"month ==%@",strMonth);
    }
    lbl_CC_ExpiryDate.text=[NSString stringWithFormat:@"EXPIRY %@/%@",strMonth,[[dictCardDetails objectForKey:@"expireYear"] stringValue]];
    txtfld_CardNo_UpdateCard.text=lbl_CC_Number.text;
    txtfld_CardName_UpdateCard.text=[dictCardDetails objectForKey:@"cardName"];
    //txtfld_CardNo_UpdateCard.text=@"";[dictCardDetails objectForKey:@"cardNumber"];
    txtfld_digits_UpdateCard.text=@"";//[[dictCardDetails objectForKey:@"cscCode"] stringValue];
    txtfld_Month_UpdateCard.text=strMonth;//[[dictCardDetails objectForKey:@"expireMonth"] stringValue];
    txtfld_Year_UpdateCard.text=[[dictCardDetails objectForKey:@"expireYear"] stringValue];
    txtfld_zipCode_UpdateCard.text=[dictCardDetails objectForKey:@"zipCode"];
    // txtfld_digits_UpdateCard.userInteractionEnabled = YES;
    //txtfld_digits_UpdateCard.alpha = 1;
    zipcode_Billing_Flag=YES;
    cscDigits_Billing_Flag=YES;
    month_Billing_Flag=YES;
    year_Billing_Flag=YES;
    //cardNumber_Billing_Flag=NO;
    cardNumber_Billing_Flag=YES;  //need to change
    orgCardFlag=YES;   //need to change
    strCredit_Card_Added_Status=@"YES";
    strCreditCardID=[[dictCardDetails objectForKey:@"id"] stringValue];
    str_SVD_PaymentType=strPaymentType;
    str_SVD_CardName=txtfld_CardName_UpdateCard.text;
    str_SVD_CardNumber=txtfld_CardNo_UpdateCard.text;
    str_SVD_Month=txtfld_Month_UpdateCard.text;
    str_SVD_Year=txtfld_Year_UpdateCard.text;
    str_SVD_CSC_Digits=txtfld_digits_UpdateCard.text;
    str_SVD_ZipCode=txtfld_zipCode_UpdateCard.text;
    NSLog(@"pay=%@",str_SVD_PaymentType);
    NSLog(@"pay=%@",str_SVD_CardName);
    NSLog(@"pay=%@",str_SVD_CardNumber);
    NSLog(@"pay=%@",str_SVD_Month);
    NSLog(@"pay=%@",str_SVD_Year);
    NSLog(@"pay=%@",str_SVD_CSC_Digits);
    NSLog(@"pay=%@",str_SVD_ZipCode);
}

-(void)getUsersRunning_History
{
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/history",[defaults_Settings objectForKey:@"ACCOUNTID"]];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for User Basic Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseHistory_Details) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for User Basic Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
-(void)responseHistory_Details
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
//            strHistoryUpdateStatus=@"YES";
            strHistoryLoadedStatus=@"YES";
            arrUserHistory=[[responseDict valueForKey:@"data"] valueForKey:@"historyList"];
            NSLog(@"%lu",(unsigned long)[arrUserHistory count]);
            strTimeZoneIDFor_User=[[responseDict valueForKey:@"data"] objectForKey:@"timeZoneId"];
            NSLog(@"Total running history =%lu",(unsigned long)arrUserHistory.count);
            int totalHistory_Count=(int)arrUserHistory.count;
            TotalPage=totalHistory_Count/countPerPage;
            if(totalHistory_Count%countPerPage>0)
            {
                TotalPage=TotalPage+1;
            }
            NSLog(@"Total Page =%d",TotalPage);
            NSUInteger start = countPerPage * pageindex;
            NSLog(@"page index==%ld",(long)pageindex);
            NSRange range = NSMakeRange(start, MIN([arrUserHistory count] - start, countPerPage));
            arrUserHistorySplit = [arrUserHistory subarrayWithRange:range];
            [self loadHistoryDatas:arrUserHistorySplit];
        }else{
            [self stop_PinWheel_UserSettings];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)getBillingPlansSettings
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/billing_plans"];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Billing Plans ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseBillingPlansSettings) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Billing Plans ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)responseBillingPlansSettings
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSMutableArray *arrBillingPlans=[[NSMutableArray alloc] init];
            arrBillingPlans=[responseDict objectForKey:@"data"];
            NSLog(@"array count ==%lu",(unsigned long)arrBillingPlans.count);
            if([arrBillingPlans count]>0)
            {
                arrStoreCount=0;
                [self parseBillingPlansSettings:arrBillingPlans];
            }else{
                [self stop_PinWheel_UserSettings];
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
        }else{
            [self stop_PinWheel_UserSettings];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)parseBillingPlansSettings:(NSMutableArray *)arrBillingPlans
{
    
    //going to split
    arrPlan=[[NSMutableArray alloc] init];
    arrPlanRange=[[NSMutableArray alloc] init];
    for(int orgIndex=0;orgIndex<[arrBillingPlans count];orgIndex++){
        NSLog(@"current array ==%@",[arrBillingPlans objectAtIndex:orgIndex]);
        NSMutableDictionary *dictBillingPlan=[[NSMutableDictionary alloc] init];
        dictBillingPlan=[[arrBillingPlans objectAtIndex:orgIndex] objectForKey:@"plan"];
        NSString *strCode=[dictBillingPlan objectForKey:@"code"];
        if(![arrPlan containsObject:strCode])
        {
            [arrPlan addObject:strCode];
        }
        NSString *strRange;
        if ([[dictBillingPlan objectForKey:@"minLimit"] intValue]>=100) {
            strRange = @"101+";
        }else{
            strRange=[NSString stringWithFormat:@"%@ - %@",[dictBillingPlan objectForKey:@"minLimit"],[dictBillingPlan objectForKey:@"maxLimit"]];
        }
        if(![arrPlanRange containsObject:strRange])
        {
            [arrPlanRange addObject:strRange];
        }
        
        if(orgIndex==0)
        {
            arrBilling_New[arrStoreCount]=[[NSMutableArray alloc] init];
            [arrBilling_New[arrStoreCount] addObject:[arrBillingPlans objectAtIndex:orgIndex]];
            arrStoreCount=arrStoreCount+1;
        }else{
            // for(int newindex=0;newindex[)
            NSLog(@"current hub ==%@",[[arrBillingPlans objectAtIndex:orgIndex] objectForKey:@"hub"]);
            int indexCount=arrStoreCount;
            for(int preIndex=0;preIndex<indexCount;preIndex++){
                NSLog(@"whole hub ==%@",[[arrBilling_New[preIndex] objectAtIndex:0] objectForKey:@"hub"]);
                NSString *current_Hub_Name=[[[arrBillingPlans objectAtIndex:orgIndex] objectForKey:@"hub"] stringValue];
                NSString *Prevs_Hub_Name=[[[arrBilling_New[preIndex] objectAtIndex:0] objectForKey:@"hub"] stringValue];
                if([current_Hub_Name isEqualToString:Prevs_Hub_Name]){
                    [arrBilling_New[preIndex] addObject:[arrBillingPlans objectAtIndex:orgIndex]];
                    NSLog(@"array value is ==%@",arrBilling_New[preIndex]);
                    preIndex=indexCount;
                    
                }else{
                    NSLog(@"diff hub");
                    if(preIndex==indexCount-1){
                        arrBilling_New[arrStoreCount]=[[NSMutableArray alloc] init];
                        [arrBilling_New[arrStoreCount] addObject:[arrBillingPlans objectAtIndex:orgIndex]];
                        arrStoreCount=arrStoreCount+1;
                    }
                }
            }
        }
        NSLog(@"stored array count ==%d",arrStoreCount);
    }
    NSLog(@"stored total array count ==%d",arrStoreCount);
    NSLog(@"arrplans=%@",arrPlan);
    NSLog(@"******************");
    // Going to Parse
    
    @try {
        float x_OffsetLblDoller=0;
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            x_OffsetLblDoller=45;
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            x_OffsetLblDoller=65;
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            x_OffsetLblDoller=60;
        }
        for(int planHeaderIndex=0;planHeaderIndex<[arrPlanRange count];planHeaderIndex++){
            NSLog(@"array value header ==%@",[arrPlanRange objectAtIndex:planHeaderIndex]);
            NSLog(@"xoof==%f",x_OffsetLblDoller);
//            lblPlanHeader[planHeaderIndex] = [[UILabel alloc] init];
//            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                lblPlanHeader[planHeaderIndex].frame=CGRectMake(x_OffsetLblDoller,0,80,25);
//                [lblPlanHeader[planHeaderIndex] setFont:[UIFont fontWithName:@"NexaBold" size:10]];
//            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                lblPlanHeader[planHeaderIndex].frame=CGRectMake(x_OffsetLblDoller,0,120,44);
//                [lblPlanHeader[planHeaderIndex] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
//            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
//                lblPlanHeader[planHeaderIndex].frame=CGRectMake(x_OffsetLblDoller,0,100,30);
//                [lblPlanHeader[planHeaderIndex] setFont:[UIFont fontWithName:@"NexaBold" size:11]];
//            }
//            [lblPlanHeader[planHeaderIndex] setTextColor:lblRGBA(255, 255, 255, 1)];
//            lblPlanHeader[planHeaderIndex].textAlignment = NSTextAlignmentCenter;
//            lblPlanHeader[planHeaderIndex].text =[NSString stringWithFormat:@"%@",[arrPlan objectAtIndex:planHeaderIndex]];
//            [self.scrollView_Planoptions addSubview:lblPlanHeader[planHeaderIndex]];
            
            lblPlanHeaderRange[planHeaderIndex] = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                if ([arrPlanRange objectAtIndex:planHeaderIndex]==[arrPlanRange lastObject]) {
                    lblPlanHeaderRange[planHeaderIndex].frame=CGRectMake(x_OffsetLblDoller,0,80,25);
                }else{
                    lblPlanHeaderRange[planHeaderIndex].frame=CGRectMake(x_OffsetLblDoller,0,38,25);
                }

                [lblPlanHeaderRange[planHeaderIndex] setFont:[UIFont fontWithName:@"NexaBold" size:10]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                if ([arrPlanRange objectAtIndex:planHeaderIndex]==[arrPlanRange lastObject]) {
                    lblPlanHeaderRange[planHeaderIndex].frame=CGRectMake(x_OffsetLblDoller,0,100,44);
                }else{
                    lblPlanHeaderRange[planHeaderIndex].frame=CGRectMake(x_OffsetLblDoller,0,50,44);
                }
                [lblPlanHeaderRange[planHeaderIndex] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                if ([arrPlanRange objectAtIndex:planHeaderIndex]==[arrPlanRange lastObject]) {
                    lblPlanHeaderRange[planHeaderIndex].frame=CGRectMake(x_OffsetLblDoller,0,85,30);
                }else{
                    lblPlanHeaderRange[planHeaderIndex].frame=CGRectMake(x_OffsetLblDoller,0,45,30);
                }
                [lblPlanHeaderRange[planHeaderIndex] setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }
            [lblPlanHeaderRange[planHeaderIndex] setTextColor:lblRGBA(255, 255, 255, 1)];
            lblPlanHeaderRange[planHeaderIndex].textAlignment = NSTextAlignmentCenter;
            lblPlanHeaderRange[planHeaderIndex].text =[NSString stringWithFormat:@"%@",[arrPlanRange objectAtIndex:planHeaderIndex]];
            [self.scrollView_Planoptions addSubview:lblPlanHeaderRange[planHeaderIndex]];
            
            x_OffsetLblDoller=lblPlanHeaderRange[planHeaderIndex].frame.origin.x+lblPlanHeaderRange[planHeaderIndex].frame.size.width+5;
        }
        NSLog(@"xoof==%f",x_OffsetLblDoller);
        //Plan option Card Scroll Setup
        self.scrollView_Planoptions.contentSize=CGSizeMake(x_OffsetLblDoller,self.scrollView_Planoptions.frame.size.height);
        float x_OffsetPlan=0,h_OffsetPlan=0,yOffsetPlan=lblPlanHeaderRange[0].frame.size.height+lblPlanHeaderRange[0].frame.origin.y,wOffsetPlan=viewPlan.frame.size.width;
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            h_OffsetPlan = 25;
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            h_OffsetPlan = 44;
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            h_OffsetPlan = 30;
        }
        for(int hubIndex=0;hubIndex<arrStoreCount;hubIndex++){
            UIView *planMenuView=[[UIView alloc] init];
            planMenuView.frame=CGRectMake(x_OffsetPlan, yOffsetPlan,wOffsetPlan,h_OffsetPlan);
            if (hubIndex%2==0)
            {
                planMenuView.backgroundColor=lblRGBA(255, 205, 52, 1);
            }else{
                planMenuView.backgroundColor=[UIColor clearColor];
            }
            [self.scrollView_Planoptions addSubview:planMenuView];
            
            
            UILabel *lblHub = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblHub.frame=CGRectMake(8, 0, 45, 25);
                [lblHub setFont:[UIFont fontWithName:@"NexaBold" size:10]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblHub.frame=CGRectMake(15, 0, 65, 44);
                [lblHub setFont:[UIFont fontWithName:@"NexaBold" size:12]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblHub.frame=CGRectMake(8, 0, 60, 30);
                [lblHub setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }
            [lblHub setTextColor:lblRGBA(255,255,255, 1)];
            if(hubIndex==0){
                lblHub.text =[NSString stringWithFormat:@"%@ hub",[[arrBilling_New[hubIndex] objectAtIndex:0] objectForKey:@"hub"]];
            }else{
                lblHub.text =[NSString stringWithFormat:@"%@ hubs",[[arrBilling_New[hubIndex] objectAtIndex:0] objectForKey:@"hub"]];
            }
            
            [planMenuView addSubview:lblHub];
            
            for(int priceIndex=0;priceIndex<[arrPlanRange count];priceIndex++){
                NSLog(@"stored %d th conente %@=",priceIndex,arrBilling_New[hubIndex]);
                NSLog(@"stored %d th count %lu=",priceIndex,(unsigned long)arrBilling_New[hubIndex].count);
//                UILabel *lblPrice = [[UILabel alloc]init];
//                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                    lblPrice.frame=CGRectMake(lblPlanHeaderRange[priceIndex].frame.origin.x,0,lblPlanHeaderRange[priceIndex].frame.size.width,25);
//                    [lblPrice setFont:[UIFont fontWithName:@"NexaBold" size:10]];
//                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                    lblPrice.frame=CGRectMake(lblPlanHeaderRange[priceIndex].frame.origin.x,0,lblPlanHeaderRange[priceIndex].frame.size.width,44);
//                    [lblPrice setFont:[UIFont fontWithName:@"NexaBold" size:12]];
//                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
//                    lblPrice.frame=CGRectMake(lblPlanHeaderRange[priceIndex].frame.origin.x,0,lblPlanHeaderRange[priceIndex].frame.size.width,30);
//                    [lblPrice setFont:[UIFont fontWithName:@"NexaBold" size:11]];
//                }
//                [lblPrice setTextColor:lblRGBA(255, 255, 255, 1)];
//                lblPrice.textAlignment=NSTextAlignmentCenter;
//                [planMenuView addSubview:lblPrice];
                
                UIButton *lblPrice = [UIButton buttonWithType:UIButtonTypeCustom];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    lblPrice.frame=CGRectMake(lblPlanHeaderRange[priceIndex].frame.origin.x,0,lblPlanHeaderRange[priceIndex].frame.size.width,25);
                    lblPrice.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:10];
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    lblPrice.frame=CGRectMake(lblPlanHeaderRange[priceIndex].frame.origin.x,0,lblPlanHeaderRange[priceIndex].frame.size.width,44);
                    lblPrice.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:12];
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                    lblPrice.frame=CGRectMake(lblPlanHeaderRange[priceIndex].frame.origin.x,0,lblPlanHeaderRange[priceIndex].frame.size.width,30);
                    lblPrice.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:11];
                }
                [lblPrice setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
                [lblPrice addTarget:self action:@selector(open_emailView_OnTap:) forControlEvents:UIControlEventTouchUpInside];
                [planMenuView addSubview:lblPrice];

                NSString *codePresent;
                for(int i=0;i<[arrBilling_New[hubIndex] count];i++){
                    NSLog(@"array store sub ==%@",[arrBilling_New[hubIndex] objectAtIndex:i]);
                    NSDictionary *dictPlan=[[arrBilling_New[hubIndex] objectAtIndex:i] objectForKey:@"plan"];
                    NSLog(@"plan  ind ==%@",dictPlan);
                    if([[arrPlan objectAtIndex:priceIndex] isEqualToString:[dictPlan valueForKey:@"code"]])
                    {
                        //Present
                        codePresent=@"YES";
                        if ([[arrBilling_New[hubIndex] objectAtIndex:i] objectForKey:@"price"] == [NSNull null]) {
                            NSLog(@"null");
//                            lblPrice.text =@"Email for Pricing";
                            [lblPrice setTitle:[NSString stringWithFormat:@"Email for Pricing"] forState:UIControlStateNormal];
                        }else{
                            float price=[[[arrBilling_New[hubIndex] objectAtIndex:i] objectForKey:@"price"] floatValue];
//                            lblPrice.text =[NSString stringWithFormat:@"%.2f",price];
                            [lblPrice setTitle:[NSString stringWithFormat:@"%.2f",price] forState:UIControlStateNormal];

                        }
                        i=(int)arrBilling_New[hubIndex].count;
                    }else{
                        //not present
                        codePresent=@"NO";
                        if(i==arrBilling_New[hubIndex].count-1)
                        {
//                            lblPrice.text =@"-";
                            [lblPrice setTitle:[NSString stringWithFormat:@"-"] forState:UIControlStateNormal];
                        }
                    }
                }
            }
            
            yOffsetPlan=planMenuView.frame.origin.y+planMenuView.frame.size.height;
        }
        
        self.scrollView_Planoptions.frame=CGRectMake(self.scrollView_Planoptions.frame.origin.x, self.scrollView_Planoptions.frame.origin.y, self.scrollView_Planoptions.frame.size.width, yOffsetPlan);
        
        self.viewPlan.frame=CGRectMake(self.viewPlan.frame.origin.x, self.viewPlan.frame.origin.y, self.viewPlan.frame.size.width, self.scrollView_Planoptions.frame.size.height+self.scrollView_Planoptions.frame.origin.y);
        
        self.scrollView_PlanCard.contentSize=CGSizeMake(scrollView_PlanCard.frame.size.width, self.viewPlan.frame.origin.y+self.viewPlan.frame.size.height);
        
        [self stop_PinWheel_UserSettings];
        
        
        //Corner For Alerts Card
        UIBezierPath *maskPathPlan_Alerts = [UIBezierPath bezierPathWithRoundedRect:viewPlan.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(16.0, 16.0)];
        CAShapeLayer *maskLayerPlan_Alerts = [[CAShapeLayer alloc] init];
        maskLayerPlan_Alerts.frame = self.view.bounds;
        maskLayerPlan_Alerts.path  = maskPathPlan_Alerts.CGPath;
        viewPlan.layer.mask = maskLayerPlan_Alerts;
        
        strPlanStatus=@"YES";
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
}


-(void)updateCreditCardDetailsSettings
{
    NSString *strCardType=@"";
    if([strPaymentType isEqualToString:@"VISA"]){
        strCardType=@"1";
    }else if([strPaymentType isEqualToString:@"MASTRO"]){
        strCardType=@"2";
    }else if([strPaymentType isEqualToString:@"DISCOVER"]){
        strCardType=@"4";
    }else if([strPaymentType isEqualToString:@"AMERICAN"]){
        strCardType=@"3";
    }
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults_Settings objectForKey:@"ACCOUNTID"]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodName=[NSString stringWithFormat:@"/accounts/%@/billing",[defaults_Settings objectForKey:@"ACCOUNTID"]];
    NSMutableDictionary *dictCardDetails=[[NSMutableDictionary alloc] init];
    [dictCardDetails setObject:strCardType forKey:kCardType];
    [dictCardDetails setObject:txtfld_CardName_UpdateCard.text forKey:kCardName];
    [dictCardDetails setObject:txtfld_CardNo_UpdateCard.text forKey:kCardNumber];
    [dictCardDetails setObject:txtfld_Month_UpdateCard.text forKey:kCardExpiryMonth];
    [dictCardDetails setObject:txtfld_Year_UpdateCard.text forKey:kCardExpiryYear];
    [dictCardDetails setObject:txtfld_digits_UpdateCard.text forKey:kCardCSCCode];
    [dictCardDetails setObject:txtfld_zipCode_UpdateCard.text forKey:kCardZipCode];
    //[dictCardDetails setObject:strCreditCardID forKey:kCreditCardID];
    
    
    parameters=[SCM updateCreditCardDetails:dictCardDetails];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update credit card Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(response_UpdateCreditCard_Details_Settings) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update credit card Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodName];
}
-(void)response_UpdateCreditCard_Details_Settings
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self saveCardDetails];
        }else{
            [self stop_PinWheel_UserSettings];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
    
}
-(void)add_UserManagement{
    
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    NSLog(@"selected networks are =%@",arr_Networkid);
    NSLog(@"User management==%@",[defaults_Settings objectForKey:@"ACCOUNTID"]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictController_User_Management=[[NSMutableDictionary alloc] init];
    
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/invitees",[defaults_Settings objectForKey:@"ACCOUNTID"]];
    [dictController_User_Management setObject:[NSString stringWithFormat:@"%@",[defaults_Settings objectForKey:@"ACCOUNTID"]] forKey:kAccountID];
    [dictController_User_Management setObject:txtfld_Fname_userManagement.text forKey:kFirstName];
    [dictController_User_Management setObject:txtfld_Lname_userManagement.text forKey:kLastName];
    [dictController_User_Management setObject:txtfld_email_userManagement.text forKey:kEmailID];
    NSMutableArray *arrNets=[[NSMutableArray alloc] init];
    for(int index=0;index<[arr_Networkid count];index++)
    {
        NSMutableDictionary *dictNets= [[NSMutableDictionary alloc] init];
        [dictNets setObject:[[arr_Networkid objectAtIndex:index] valueForKey:kNetworkID] forKey:@"id"];
        [dictNets setObject:[[arr_Networkid objectAtIndex:index] valueForKey:kaccesstypeID] forKey:@"accessTypeId"];
        [arrNets addObject:dictNets];
    }
    [dictController_User_Management setObject:arrNets forKey:knetworkid];
    
    parameters=[SCM addUserMangementSettings:dictController_User_Management];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for add usermanagement==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(response_UserManagement) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for add usermanagement==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodNameWith_Value];
    
}
-(void)response_UserManagement
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            NSLog(@"DICT controller Data ==%@",dicitData);
            NSLog(@"DIC controller Data  count==%lu",(unsigned long)dicitData.count);
            if([Common reachabilityChanged]==YES){
                [self reset_UserManagement_Details];
                [self stop_PinWheel_UserSettings];
                [self performSelectorOnMainThread:@selector(start_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(user_ManagementList) withObject:self];
            }else{
                [self stop_PinWheel_UserSettings];
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }else{
            [self stop_PinWheel_UserSettings];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
-(void)user_ManagementList
{
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    
    NSLog(@"Account id ==%@",[defaults_Settings objectForKey:@"ACCOUNTID"]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/invitees",[defaults_Settings objectForKey:@"ACCOUNTID"]];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for UserMangement Detail List==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(response_UserMangementList) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for UserMangement Detail List==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
-(void)response_UserMangementList
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            arrUserManagement = [[NSMutableArray alloc] init];
            arrUserAccList=[responseDict objectForKey:@"data"];
            NSLog(@"arr_Network_Data count==%lu",(unsigned long)arrUserManagement.count);
            if ([arrUserAccList count]>0) {
                strUserAccountList_LoadedStatus=@"YES";
                for(int index=0;index<[arrUserAccList count];index++){
                    NSMutableDictionary *dict_User_Content=[[NSMutableDictionary alloc] init];
                    [dict_User_Content setObject:[[arrUserAccList objectAtIndex:index] valueForKey:@"firstName"] forKey:kAccountName];
                    [dict_User_Content setObject:[[arrUserAccList objectAtIndex:index] valueForKey:@"lastName"] forKey:kAccountLastName];
                    [dict_User_Content setObject:[[arrUserAccList objectAtIndex:index] valueForKey:@"email"] forKey:kEmailID];
                    [dict_User_Content setObject:[[arrUserAccList objectAtIndex:index] valueForKey:@"id"] forKey:kAccountID];
                    if([[[arrUserAccList objectAtIndex:index] objectForKey:@"isDirectInvitee"] boolValue])
                    {
                        [dict_User_Content setObject:@"YES" forKey:kNetworkOwner];
                    }else{
                        [dict_User_Content setObject:@"NO" forKey:kNetworkOwner];
                    }
                    [arrUserManagement addObject:dict_User_Content];
                }
                if (cellExpandStatusAcc==NO) {
                    [self collapseUserAccountView];
                }
                [self loadUserAccountDatas];
            }else{
                strUserAccountList_LoadedStatus=@"";
                [self stop_PinWheel_UserSettings];
            }
        }else{
            user_Acc_View_Mgt.hidden=YES;
            [self stop_PinWheel_UserSettings];
        }
    }
    @catch (NSException *exception) {
        user_Acc_View_Mgt.hidden=YES;
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)getUserSelectedNW
{
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    
    NSLog(@"Account id ==%@",[defaults_Settings objectForKey:@"ACCOUNTID"]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/invitees?inviteeId=%@",[defaults_Settings objectForKey:@"ACCOUNTID"],strMemberID];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Particular User acc Detail ==%@",dict);
        responseDict=dict;
         prev_Count=0;
        [self performSelectorOnMainThread:@selector(responseSelectedUserNetwork) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Particular User acc Detail ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
-(void)responseSelectedUserNetwork
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSMutableArray *arrRes = [[NSMutableArray alloc] init];
            arrRes=[responseDict valueForKey:@"data"];
            NSLog(@"network ==%@",arrRes);
            if([arrRes count]>0){
                arrRes=[[arrRes objectAtIndex:0] objectForKey:@"network"];
                arrUserSelectedIDS=[[NSMutableArray alloc] init];
                arr_NetworkUserID=[[NSMutableArray alloc] init];
                for(int index=0;index<[arrRes count];index++){
                    NSLog(@"id ==%@",[[arrRes objectAtIndex:index] objectForKey:@"id"]);
                    NSMutableDictionary *dictNets= [[NSMutableDictionary alloc] init];
                    [dictNets setObject:[[[arrRes objectAtIndex:index] objectForKey:@"id"] stringValue] forKey:kNetworkID];
                    [dictNets setObject:[[[[arrRes objectAtIndex:index] objectForKey:@"accessType"] objectForKey:@"id"] stringValue] forKey:kaccesstypeID];
                    [dictNets setObject:[[[[arrRes objectAtIndex:index] objectForKey:@"inviteeNetworkStatus"] objectForKey:@"id"] stringValue] forKey:kAccountPermissionID];
                    [arrUserSelectedIDS addObject:dictNets];
                }
                NSLog(@"%@",arrUserSelectedIDS);
                 prev_Count=[arrRes count];
                [self performSelectorOnMainThread:@selector(parseBodyUserAccMgt) withObject:self waitUntilDone:YES];
            }else{
                [self stop_PinWheel_UserSettings];
            }
        }else{
            [self stop_PinWheel_UserSettings];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)updateUserAccountDetails
{
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    NSLog(@"User management==%@",[defaults_Settings objectForKey:@"ACCOUNTID"]);
    NSLog(@"member id==%@",strMemberID);
    
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictController_UserAccDetails=[[NSMutableDictionary alloc] init];
    
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/invitees",[defaults_Settings objectForKey:@"ACCOUNTID"]];
    [dictController_UserAccDetails setObject:strMemberID forKey:kAccountID];
    [dictController_UserAccDetails setObject:[dictUserAcc_Content valueForKey:kAccountName] forKey:kFirstName];
    [dictController_UserAccDetails setObject:[dictUserAcc_Content valueForKey:kAccountLastName] forKey:kLastName];
    [dictController_UserAccDetails setObject:[dictUserAcc_Content valueForKey:kEmailID] forKey:kEmailID];
    NSMutableArray *arrNets=[[NSMutableArray alloc] init];
    for(int index=0;index<[arr_NetworkUserID count];index++)
    {
        NSMutableDictionary *dictNets= [[NSMutableDictionary alloc] init];
        [dictNets setObject:[[arr_NetworkUserID objectAtIndex:index] valueForKey:kNetworkID] forKey:@"id"];
        [dictNets setObject:[[arr_NetworkUserID objectAtIndex:index] valueForKey:kaccesstypeID] forKey:@"accessTypeId"];
        [arrNets addObject:dictNets];
    }
    [dictController_UserAccDetails setObject:arrNets forKey:knetworkid];
    
    parameters=[SCM updateUserAccountDetails:dictController_UserAccDetails];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update usermanagement==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(response_UpdateUserAccount) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update usermanagement==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}
-(void)response_UpdateUserAccount
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSMutableArray *arrUpdateUserAcc = [[NSMutableArray alloc] init];
            NSMutableDictionary *dict_User_Content=[[NSMutableDictionary alloc] init];
            [dict_User_Content setObject:[dictUserAcc_Content valueForKey:kAccountName] forKey:kAccountName];
            [dict_User_Content setObject:[dictUserAcc_Content valueForKey:kAccountLastName] forKey:kAccountLastName];
            [dict_User_Content setObject:[dictUserAcc_Content valueForKey:kEmailID] forKey:kEmailID];
            [dict_User_Content setObject:strMemberID forKey:kAccountID];
            [dict_User_Content setObject:[dictUserAcc_Content valueForKey:kNetworkOwner] forKey:kNetworkOwner];
            [arrUpdateUserAcc addObject:dict_User_Content];
            
            if([arrUpdateUserAcc count]>0)
            {
                [arrUserManagement replaceObjectAtIndex:tag_PosAcc withObject:[arrUpdateUserAcc objectAtIndex:0]];
                NSLog(@"arr after replace ==%@",arrUserManagement);
                [self collapseUserAccountView];
                
                [self stop_PinWheel_UserSettings];
//                [Common showAlert:kAlertTitleSuccess withMessage:responseMessage];
            }else{
                [self stop_PinWheel_UserSettings];
            }
        }else{
            [self stop_PinWheel_UserSettings];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)deleteUserAccount
{
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/invitees?inviteeId=%@",[defaults_Settings objectForKey:@"ACCOUNTID"],strMemberID];
    NSLog(@"method name==%@",strMethodNameWith_Value);
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for delete Schedule==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseDelete_UserAccount) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for delete Schedule==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorDELETE:strMethodNameWith_Value];
}

-(void)responseDelete_UserAccount
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self popUserAcc_DeleteOldConfiguration];
            NSLog(@"view tag value==%ld",(long)viewTagValue);
            for (int index=0;index<[arrUserManagement count];index++){
                [menu_User_Acc[index] removeFromSuperview];
            }
            [arrUserManagement removeObjectAtIndex:tag_PosAcc];
            NSLog(@"%@",arrUserManagement);
            cellExpandStatusAcc=YES;
            if ([arrUserManagement count]==0) {
                self.user_Acc_View_Mgt.hidden=YES;
                self.bodyViewScroll_UserManage.contentOffset=CGPointZero;
            }else{
                [self loadUserAccountDatas];
            }
            [self stop_PinWheel_UserSettings];
//            [Common showAlert:kAlertTitleSuccess withMessage:responseMessage];
        }else{
            [self stop_PinWheel_UserSettings];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)deleteControllerNetwork_NOID
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dicit_NetworkDatas valueForKey:@"id"]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults_Settings objectForKey:@"ACCOUNTID"]);
    NSLog(@"Network Id==%@",strController_NetworkID);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks?networkId=%@",[defaults_Settings objectForKey:@"ACCOUNTID"],strController_NetworkID];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Network Delete==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(parse_Delete_ControllerNetwork_Details) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Network Delete ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorDELETE:strMethodNameWith_Value];
}

-(void)parse_Delete_ControllerNetwork_Details
{
    @try {
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            defaults_Settings=[NSUserDefaults standardUserDefaults];
//            if([[[arrUserBilling_Controller objectAtIndex:controllerTag] objectForKey:@"isOwnController"] intValue]==1)
//            {
                NSLog(@"network count is ==%@",[defaults_Settings objectForKey:@"NETWORKCOUNT"]);
                int nwCount=[[defaults_Settings objectForKey:@"NETWORKCOUNT"] intValue];
                nwCount=nwCount-1;
                [defaults_Settings setObject:[NSString stringWithFormat:@"%d",nwCount] forKey:@"NETWORKCOUNT"];
                [defaults_Settings synchronize];
//            }
            [self stop_PinWheel_UserSettings];
            if([appDelegate.strSettingAction isEqualToString:@"multipleNw"])
            {
                [defaults_Settings setObject:@"YES" forKey:@"MPNETWORKLOADSTATUS"];
                appDelegate.strNetworkAddedStatus=@"YES";
                appDelegate.strEdit_Controller_DeviceStatus=@"";
                [defaults_Settings synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else 
            {
                [defaults_Settings setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
                appDelegate.strNetworkAddedStatus=@"YES";
                appDelegate.strEdit_Controller_DeviceStatus=@"";
                [defaults_Settings synchronize];
                MultipleNetworkViewController *MNVC = [[MultipleNetworkViewController alloc] initWithNibName:@"MultipleNetworkViewController" bundle:nil];
                MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                NSArray *newStack = @[MNVC];
                [self.navigationController setViewControllers:newStack animated:YES];
            }
            appDelegate.strOwnerNetwork_Status=@"";
        }else{
            [self stop_PinWheel_UserSettings];
            if([responseMessage isEqualToString:@"ACCT_CONTROLLER_MIN_LIMIT_REACHED"])
            {
                [self.viewAlert_PlanUpgrade_Billing setHidden:NO];
                [self popup_Settings_Alpha_Disabled];
                return;
            }
            else if([responseMessage isEqualToString:@"ACCT_CONTROLLER_PLAN_EXIT"]) //Plan exit
            {
                planExitStatus=@"YES";
                //need to put iboutlet for chargemy card button
                strprorationTime=@"0";
                self.lbl_PlanUpgrade_Charge_Billing.text=[NSString stringWithFormat:@"YOUR SUBSCRIPTION WILL BE CLOSED. DO YOU WANT TO PROCEED?"];
                [self.viewAlert_PlanUpgrade_Confirm_Billing setHidden:NO];
                [self popup_Settings_Alpha_Disabled];
                return;
            }
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)updateUserAccName
{
    NSDictionary *parameters;
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/invitees/profile",[defaults_Settings objectForKey:@"ACCOUNTID"]];
    NSLog(@"method name==%@",strMethodNameWith_Value);
    
    NSMutableDictionary *dictUserAcc_Detail=[[NSMutableDictionary alloc] init];
    [dictUserAcc_Detail setObject:strMemberID forKey:kAccountID];
    [dictUserAcc_Detail setObject:txt_AccName[tag_PosAcc].text forKey:kAccountName];
    [dictUserAcc_Detail setObject:txt_AccLName[tag_PosAcc].text forKey:kAccountLastName];
    
    NSLog(@"dict values going to update user acc name ==%@",dictUserAcc_Detail);
    parameters=[SCM updateUserAccName:dictUserAcc_Detail];
    NSLog(@"%@",parameters);
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update User acc Name==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseUserAccNameUpdate) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update User acc Name==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}

-(void)responseUserAccNameUpdate
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSLog(@"dict ==%@",[arrUserAccList objectAtIndex:tag_PosAcc]);
            lblAcc_Name[tag_PosAcc].text = txt_AccName[tag_PosAcc].text;
            lblAcc_LName[tag_PosAcc].text = txt_AccLName[tag_PosAcc].text;
            [txt_AccName[tag_PosAcc] setHidden:YES];
            [txt_AccName[tag_PosAcc] resignFirstResponder];
            [txt_AccLName[tag_PosAcc] setHidden:YES];
            [txt_AccLName[tag_PosAcc] resignFirstResponder];
            [lblAcc_Name[tag_PosAcc] setHidden:NO];
            [lblAcc_LName[tag_PosAcc] setHidden:NO];
            [btn_Save_AccName[tag_PosAcc] setHidden:YES];
            [btn_close_UserAcc[tag_PosAcc] setHidden:YES];
            [viewEdit_UserAcc_Billing[tag_PosAcc] setHidden:NO];
            [[arrUserManagement objectAtIndex:tag_PosAcc] setObject:txt_AccName[tag_PosAcc].text forKey:kAccountName];
            [[arrUserManagement objectAtIndex:tag_PosAcc] setObject:txt_AccLName[tag_PosAcc].text forKey:kAccountLastName];
            NSLog(@"dict ==%@",[arrUserManagement objectAtIndex:tag_PosAcc]);
            
            [self stop_PinWheel_UserSettings];
//            [Common showAlert:kAlertTitleSuccess withMessage:responseMessage];
        }else{
            [self stop_PinWheel_UserSettings];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
    [self stop_PinWheel_UserSettings];
}

-(void)signOutService
{
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"User Account id ==%@",[defaults_Settings objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/logout",[defaults_Settings objectForKey:@"ACCOUNTID"]];
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *deviceToken=@"";
    if(appDelegate.devicetoken_nsdatta==nil){
        deviceToken=@"CDF1c7bf338c5e9bab2ad2fca45ada646d600061c28cf79c90a";
    }else{
        deviceToken=[NSString stringWithFormat:@"%@",appDelegate.devicetoken_nsdatta];
        deviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    NSMutableDictionary *dictDetails=[[NSMutableDictionary alloc] init];
    [dictDetails setObject:deviceToken forKey:kDeviceToken];
    [dictDetails setObject:@"1" forKey:kTokenType];
    parameters=[SCM signOut:dictDetails];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for signout==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseSignOut) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for sign out==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorNetworkSetup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}

-(void)responseSignOut
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self stop_PinWheel_UserSettings];
            defaults_Settings=[NSUserDefaults standardUserDefaults];
            [defaults_Settings setObject:@"" forKey:@"APPREMEMBERMESTATUS"];
            [defaults_Settings setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
            [defaults_Settings setObject:@"" forKey:@"ACTIVENETWORKID"];
            [defaults_Settings synchronize];
            appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strNoidLogo=@"";
            appDelegate.strOwnerNetwork_Status=@"";
            [appDelegate.dict_NetworkControllerDatas removeAllObjects];
            appDelegate.strInviteeID=@"";
            appDelegate.dict_NetworkControllerDatas=nil;
            appDelegate.strNetworkPermission=@"";
            [Common resetNetworkFlags];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            ViewController *VC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
            VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            NSArray *newStack = @[VC];
            [Common viewFadeIn:self.navigationController.view];
            [self.navigationController setViewControllers:newStack animated:NO];
            //[Common showAlert:kAlertTitleSuccess withMessage:responseMessage];
        }else{
            [self stop_PinWheel_UserSettings];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
    
    [self stop_PinWheel_UserSettings];
}

-(void)quoteForDowngradeControllerSettings
{
    NSLog(@"controller id ==%@",strController_ContollerID);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults_Settings objectForKey:@"ACCOUNTID"]);
    
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/billing/planQuote?quoteTypeId=2&deviceTypeId=1&controllerId=%@",[defaults_Settings objectForKey:@"ACCOUNTID"],strController_ContollerID];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Quote details ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseForQuotePlanDowngradeSettings) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Quote details ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
/*
-(void)responseForQuotePlanDowngradeSettings
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSArray *arrPlanQuote;
            arrPlanQuote = [[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"lineItems"];
            NSLog(@"%@",arrPlanQuote);
            if([arrPlanQuote count]>=2)
            {
                NSLog(@"Amount == %@",[[arrPlanQuote objectAtIndex:0] objectForKey:@"amount"]);
                NSLog(@"Amount == %@",[[arrPlanQuote objectAtIndex:1] objectForKey:@"amount"]);
                float remAmt=[[[arrPlanQuote objectAtIndex:0] objectForKey:@"amount"] floatValue]+[[[arrPlanQuote objectAtIndex:1] objectForKey:@"amount"] floatValue];
                NSLog(@"remAmount =%f",remAmt);
                float Amount = remAmt/100;
                NSLog(@"remAmount =%f",Amount);
//                self.lbl_PlanUpgrade_Charge_Billing.text=[NSString stringWithFormat:@"PLEASE NOTE THAT YOUR AMOUNT $%.2f WILL BE REFUNDED AND YOUR PLAN WILL BE %@.",Amount,[[[responseDict valueForKey:@"data"] objectForKey:@"billingPlan"] objectForKey:@"billingPlanName"]];
                self.lbl_PlanUpgrade_Charge_Billing.text=[NSString stringWithFormat:@"PLEASE NOTE THAT YOUR AMOUNT $%.2f WILL BE REFUNDED AND YOUR PLAN WILL BE DOWNGRADED.",Amount];
                [self.viewAlert_PlanUpgrade_Billing setHidden:YES];
                [self.viewAlert_PlanUpgrade_Confirm_Billing setHidden:NO];
            }else{
                [self.viewAlert_PlanUpgrade_Billing setHidden:YES];
                [self.viewAlert_PlanUpgrade_Confirm_Billing setHidden:NO];
            }
            NSLog(@"Time == %@",[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"prorationDateTime"]);
            strprorationTime=[[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"prorationDateTime"] stringValue];
            [self stop_PinWheel_UserSettings];
            [self popup_Settings_Alpha_Disabled];
        }else{
            [self stop_PinWheel_UserSettings];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
 */

-(void)responseForQuotePlanDowngradeSettings
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            strTimeZoneIDFor_User=[[responseDict valueForKey:@"data"] objectForKey:@"timeZoneId"];
            if([[[responseDict valueForKey:@"data"] objectForKey:@"billingQuoteType"] isEqualToString:@"planExit"])
            {
                
                self.lbl_PlanUpgrade_Charge_Billing.text=[NSString stringWithFormat:@"PLEASE NOTE THAT YOUR SUBSCRIPTION WILL CLOSED"];
                
                NSLog(@"plan exit date == %@",[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"planExitDate"]);
                strprorationTime=[[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"planExitDate"] stringValue];
                [self stop_PinWheel_UserSettings];
                [self.viewAlert_PlanUpgrade_Billing setHidden:YES];
                [self.viewAlert_PlanUpgrade_Confirm_Billing setHidden:NO];
                [self popup_Settings_Alpha_Disabled];
            }else{
                NSArray *arrPlanQuote;
                arrPlanQuote = [[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"lineItems"];
                NSLog(@"%@",arrPlanQuote);
                if([arrPlanQuote count]>=2)
                {
                    NSLog(@"Amount == %@",[[arrPlanQuote objectAtIndex:0] objectForKey:@"amount"]);
                    NSLog(@"Amount == %@",[[arrPlanQuote objectAtIndex:1] objectForKey:@"amount"]);
                    float remAmt=[[[arrPlanQuote objectAtIndex:0] objectForKey:@"amount"] floatValue]+[[[arrPlanQuote objectAtIndex:1] objectForKey:@"amount"] floatValue];
                    NSLog(@"remAmount =%f",remAmt);
                    float Amount = fabs(remAmt/100);
                    NSLog(@"remAmount =%f",Amount);
                    self.lbl_PlanUpgrade_Charge_Billing.text=[NSString stringWithFormat:@"PLEASE NOTE THAT YOUR AMOUNT $%.2f WILL BE REFUNDED AND YOUR PLAN WILL BE DOWNGRADED.",Amount];
                    // self.lbl_PlanUpgrade_Charge_Billing.text=[NSString stringWithFormat:@"PLEASE NOTE THAT YOUR AMOUNT $%.2f WILL BE REFUNDED AND YOUR PLAN WILL BE %@.",Amount,[[[responseDict valueForKey:@"data"] objectForKey:@"billingPlan"] objectForKey:@"billingPlanName"]];
                    [self stop_PinWheel_UserSettings];
                    [self.viewAlert_PlanUpgrade_Billing setHidden:YES];
                    [self.viewAlert_PlanUpgrade_Confirm_Billing setHidden:NO];
                }else{
                    [self stop_PinWheel_UserSettings];
                    [self.viewAlert_PlanUpgrade_Billing setHidden:YES];
                    [self.viewAlert_PlanUpgrade_Confirm_Billing setHidden:NO];
                }
                NSLog(@"Time == %@",[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"prorationDateTime"]);
                strprorationTime=[[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"prorationDateTime"] stringValue];
                
                [self popup_Settings_Alpha_Disabled];
            }
            
        }else{
            [self stop_PinWheel_UserSettings];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
-(void)quoteForDowngradeControllerConfirmationSettings
{
    defaults_Settings=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults_Settings objectForKey:@"ACCOUNTID"]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodName=[NSString stringWithFormat:@"/accounts/%@/billing/planChange",[defaults_Settings objectForKey:@"ACCOUNTID"]];
    
    NSMutableDictionary *dict_Plan=[[NSMutableDictionary alloc] init];
    [dict_Plan setObject:@"2" forKey:kquoteTypeId];
    [dict_Plan setObject:@"1" forKey:kdeviceTypeId];
    [dict_Plan setObject:strController_ContollerID forKey:kControllerID];
    [dict_Plan setObject:strprorationTime forKey:kprorationDateTime];
    
    parameters=[SCM downgrade_Plan:dict_Plan];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for downgrade plan ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseDowngradePlanController) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for downgrade plan ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_UserSettings) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorUserSettings) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodName];
}
-(void)responseDowngradePlanController
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            strTimeZoneIDFor_User=[[responseDict valueForKey:@"data"] objectForKey:@"timeZoneId"];
            [self.viewAlert_PlanUpgrade_Confirm_Billing setHidden:YES];
            [self popup_Settings_Alpha_Enabled];
            [self stop_PinWheel_UserSettings];
            defaults_Settings=[NSUserDefaults standardUserDefaults];
            if([[[arrUserBilling_Controller objectAtIndex:controllerTag] objectForKey:@"isOwnController"] intValue]==1)
            {
                NSLog(@"network count is ==%@",[defaults_Settings objectForKey:@"NETWORKCOUNT"]);
                int nwCount=[[defaults_Settings objectForKey:@"NETWORKCOUNT"] intValue];
                nwCount=nwCount-1;
                [defaults_Settings setObject:[NSString stringWithFormat:@"%d",nwCount] forKey:@"NETWORKCOUNT"];
                [defaults_Settings synchronize];
            }
            appDelegate.strOwnerNetwork_Status=@"";
            if([planExitStatus isEqualToString:@"YES"])
            {
                UIAlertView *alertDelete_Controller = [[UIAlertView alloc] initWithTitle:@"" message:@"YOUR SUBSCRIPTION IS CLOSED"
                                                                                delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertDelete_Controller setTag:5];
                [alertDelete_Controller show];
                
                return;
            }
            if([appDelegate.strSettingAction isEqualToString:@"multipleNw"])
            {
                [defaults_Settings setObject:@"YES" forKey:@"MPNETWORKLOADSTATUS"];
                appDelegate.strNetworkAddedStatus=@"YES";
                appDelegate.strEdit_Controller_DeviceStatus=@"";
                [defaults_Settings synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [defaults_Settings setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
                appDelegate.strNetworkAddedStatus=@"YES";
                appDelegate.strEdit_Controller_DeviceStatus=@"";
                [defaults_Settings synchronize];
                MultipleNetworkViewController *MNVC = [[MultipleNetworkViewController alloc] initWithNibName:@"MultipleNetworkViewController" bundle:nil];
                MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                NSArray *newStack = @[MNVC];
                [self.navigationController setViewControllers:newStack animated:YES];
            }
            
            
        }else{
            [self stop_PinWheel_UserSettings];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_UserSettings];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==5)
    {
        if([appDelegate.strSettingAction isEqualToString:@"multipleNw"])
        {
            [defaults_Settings setObject:@"YES" forKey:@"MPNETWORKLOADSTATUS"];
            appDelegate.strNetworkAddedStatus=@"YES";
            appDelegate.strEdit_Controller_DeviceStatus=@"";
            [defaults_Settings synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [defaults_Settings setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
            appDelegate.strNetworkAddedStatus=@"YES";
            appDelegate.strEdit_Controller_DeviceStatus=@"";
            [defaults_Settings synchronize];
            MultipleNetworkViewController *MNVC = [[MultipleNetworkViewController alloc] initWithNibName:@"MultipleNetworkViewController" bundle:nil];
            MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
            NSArray *newStack = @[MNVC];
            [self.navigationController setViewControllers:newStack animated:YES];
        }
        
    }
    
}
#pragma mark - pin wheel
-(void)start_PinWheel_UserSettings{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"YES";
}
-(void)stop_PinWheel_UserSettings{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
}

#pragma mark - Mail
-(void)open_emailView_OnTap:(UIButton*)sender
{
    NSLog(@"%@",sender.currentTitle);
    if ([sender.currentTitle isEqualToString:@"Email for Pricing"]) {
        MFMailComposeViewController *composer=[[MFMailComposeViewController alloc]init];
        [composer setMailComposeDelegate:self];
        if ([MFMailComposeViewController canSendMail]) {
            [composer setToRecipients:[NSArray arrayWithObjects:@"info@noidtech.com", nil]];
            [composer setSubject:@""];
            [composer setMessageBody:@"" isHTML:NO];
//            [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:composer animated:YES completion:nil];
        }
        else {
            [Common showAlert:@"NOID" withMessage:@"This device cannot send email"];
        }
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
            [Common showAlert:@"NOID" withMessage:@"Mail Deleted!"];
            break;
        }
        case MFMailComposeResultSaved:
        {
            [Common showAlert:@"NOID" withMessage:@"Mail Saved!"];
            break;
        }
        case MFMailComposeResultSent:
        {
            [Common showAlert:@"NOID" withMessage:@"Mail Sent successsfully!"];
            break;
            
        }
        case MFMailComposeResultFailed:
        {
            [Common showAlert:@"NOID" withMessage:@"Mail Sent Failed!"];
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
