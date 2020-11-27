//
//  SettingsViewController.h
//  NOID
//
//  Created by iExemplar on 7/8/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BSKeyboardControls.h"
#import <MessageUI/MessageUI.h>

@protocol ProcessDataDelegateSettings <NSObject>
@required
-(void)processSuccessful_Back_To_NetworkHome:(BOOL)success;
@end

@interface SettingsViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,BSKeyboardControlsDelegate,MFMailComposeViewControllerDelegate>
{
    id <ProcessDataDelegateSettings> delegate;
    BOOL tempStatus,historyStatus,billingHistoryStatus;
    int pageindex,arrCount;
    NSString *str_Selected_Tap,*str_Previous_Tap,*selected_Settings_Tab,*previous_Settings_tab,*strPayment_Selected_Tap,*strPayment_PreviousTap,*strNameStatus,*strEmailStatus;
    NSIndexPath *selectedRowIndex;
    NSInteger selectedIndex;
    NSInteger indexPathValue;
    BOOL *selectedStatus,selectNetworkStatus,updateCard_planOption_Status,changeNetworkStatus,cellExpandStatus;
    UITapGestureRecognizer *tapBodyViewBilling,*tapTabViewBilling,*tapheaderViewBilling;
    NSDictionary *responseDict;
    NSUserDefaults *defaults_Settings;
    NSString *strResponseError,*temperatureType,*strInAppStatus,*strEmailVal_status,*strEmailAddress;
    float yOffSet_Content;
    NSInteger viewTagValue,pageCount,pageindexBilling,viewTagValueAcc;
    
    AppDelegate *appDelegate;
    NSString *strEditMode,*strTimeZone,*strLanguage;
    NSArray *arrUserHistorySplit,*arrBillingHistorySplit;
    int countPerPage,TotalPage,currentIndex,PreviousIndex;
    NSString *strHistoryUpdateStatus,*strHistoryLoadedStatus,*strLatitude,*strLongitude,*strBillingLoadedStatus,*strLastNameStatus,*strBillingUpdateStatus;
   
    BOOL name_Billing_Flag,cardNumber_Billing_Flag,month_Billing_Flag,year_Billing_Flag,cscDigits_Billing_Flag,zipcode_Billing_Flag,imageStatus,orgCardFlag;
    UITapGestureRecognizer *tapScrollCellular,*tapPlanOptionCellular;
    int arrStoreCount,indexPlans,countPerPageBilling,TotalPageBilling,currentIndexBilling,PreviousIndexBilling;
    NSMutableArray *arrPlan,*arrPlanRange,*arr_NetworkList,*arr_Networkid,*arrUserManagement,*arr_NetworkUserID;
    NSString *strPaymentType,*strAlert_Type;
    NSString *str_SVD_PaymentType,*str_SVD_CardNumber,*str_SVD_CardName,*str_SVD_Month,*str_SVD_Year,*str_SVD_CSC_Digits,*str_SVD_ZipCode,*strCredit_Card_Added_Status;
    NSString *strCreditCardID,*strPlanStatus,*strEditCardStatus,*strNetworkID;
    NSString *strTotalNetworkID,*strSelectNWStatus,*strUserAccountList_LoadedStatus,*strNetworkLoadedStatus,*strSelected_Temp_type,*strPrevious_Temp_type,*strController_ContollerID;
    CGRect frame_Org_Size_UserAcc,frame_Org_Size_UserAcc_Content;
    
    UIView *viewCurrentAcc;
    int tag_PosAcc;
    BOOL cellExpandStatusAcc;
    NSString *strStatus_UserMGT,*strMemberID,*strUserAccessType,*strController_NetworkID,*strSelectedNw_Status,*strprorationTime;
    NSMutableArray *arrUserSelectedIDS,*arrUserAccList;
    NSDictionary *dictUserAcc_Content;
    BOOL mail_Flag;
    NSMutableArray *arrHistoryListPerPage;
    int controllerTag,accessTypeTag,userAcc_AccessTag;
    NSString *planExitStatus,*strOrgTimeZone,*strTimeZoneIDFor_User;
    int prev_Count;
}
@property (strong, nonatomic) NSString *strchangeNetwork;
@property (strong, nonatomic) NSString *strAccessType;
@property (strong,nonatomic) IBOutlet UIScrollView *scroll_UserMgt_UserAcc;
@property (strong, nonatomic) IBOutlet UIView *user_Acc_View_Mgt;
@property (retain) id delegate;
@property (strong, nonatomic) IBOutlet UIButton *btn_Setting_Logo;
@property (strong, nonatomic) IBOutlet UIButton *btn_backArrow_setting;
@property (strong, nonatomic) IBOutlet UIButton *btn_profileName_setting;
@property (strong, nonatomic) IBOutlet UIButton *btn_UserSettings;
@property (strong, nonatomic) IBOutlet UIButton *btn_BillingSetting;
@property (strong, nonatomic) IBOutlet UIButton *btn_UserManage;
@property (strong, nonatomic) IBOutlet UIButton *btn_HistorySetting;

@property (strong,nonatomic) IBOutlet UIScrollView *scroll_Billing_Controller;
@property (strong,nonatomic) IBOutlet UIScrollView *scroll_Billing_History;
@property (strong, nonatomic) IBOutlet UIButton *btn_SwipeDown_Payment;

@property (strong, nonatomic) IBOutlet UIView *viewController_Plan;
@property (strong, nonatomic) IBOutlet UIView *viewController_PlanOptions;

@property (strong, nonatomic) IBOutlet UIButton *btn_edit1_settings;
@property (strong, nonatomic) IBOutlet UIButton *btn_edit2_settings;
@property (strong, nonatomic) IBOutlet UIButton *btn_save1_settings;
@property (strong, nonatomic) IBOutlet UIButton *btn_save2_settings;
@property (strong, nonatomic) IBOutlet UIButton *btn_close1_settings;
@property (strong, nonatomic) IBOutlet UIButton *btn_close2_settings;
@property (strong, nonatomic) IBOutlet UIButton *btn_temp1_settings;
@property (strong, nonatomic) IBOutlet UIButton *btn_temp2_settings;
@property (strong, nonatomic) IBOutlet UILabel *lbl_name_settings;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Lname_settings;
@property (strong, nonatomic) IBOutlet UILabel *lbl_email_settings;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TimeZone;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_name_settings;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_Lname_settings;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_email_settings;
@property (strong, nonatomic) NSString *str_gear_Type;

@property (strong, nonatomic) IBOutlet UIView *settingHeaderView;
@property (strong, nonatomic) IBOutlet UIView *settingConatinerView;
@property (strong, nonatomic) IBOutlet UIView *settingHomeView;
@property (strong, nonatomic) IBOutlet UIView *settingHistoryView;
@property (strong, nonatomic) IBOutlet UIView *settingManageUserView;
@property (strong, nonatomic) IBOutlet UIView *settingBillingView;
@property (strong, nonatomic) IBOutlet UIView *settingTabView;

@property (strong, nonatomic) IBOutlet UIView *changeNetworkView;
@property (strong, nonatomic) IBOutlet UIView *selectNetworkView;
@property (strong, nonatomic) IBOutlet UIView *saveNewUserView;
@property (strong, nonatomic) IBOutlet UIView *userAccountView;
@property (strong, nonatomic) IBOutlet UIView *updateCardView;
@property (strong, nonatomic) IBOutlet UIView *planOptionsView;
@property (strong, nonatomic) IBOutlet UIView *alertView_userManagement;
@property (strong, nonatomic) IBOutlet UIView *alertView_Billing;
@property (strong, nonatomic) IBOutlet UIView *alertView_info;

@property (strong, nonatomic) NSMutableArray *arrUserHistory;
@property (strong, nonatomic) IBOutlet UIButton *btnPagePrevious;
@property (strong, nonatomic) IBOutlet UIButton *btnPageNext;
@property (strong, nonatomic) IBOutlet UIView *viewFooter_UserHistory;

@property (strong, nonatomic) IBOutlet UITableView *tableViewHistory;

@property (strong, nonatomic) IBOutlet UIButton *btnPage1_billing;
@property (strong, nonatomic) IBOutlet UIButton *btnPage2_billing;
@property (strong, nonatomic) IBOutlet UIButton *btnPageNext_billing;
@property (strong, nonatomic) IBOutlet UIButton *btnPagePrev_Billing;

@property (strong, nonatomic) IBOutlet UIImageView *imgUserSettings;
@property (strong, nonatomic) IBOutlet UIImageView *imgUserManagement;
@property (strong, nonatomic) IBOutlet UIImageView *imgUserHistroy;
@property (strong, nonatomic) IBOutlet UIImageView *imgUserBilling;

@property (strong, nonatomic) IBOutlet UILabel *lbl_UserSettings;
@property (strong, nonatomic) IBOutlet UILabel *lbl_UserManagement;
@property (strong, nonatomic) IBOutlet UILabel *lbl_UserHistory;
@property (strong, nonatomic) IBOutlet UILabel *lbl_UserBilling;

@property (strong, nonatomic) IBOutlet UITextField *txtfld_Fname_userManagement;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_Lname_userManagement;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_email_userManagement;
@property (strong, nonatomic) UITextField *current_textfield_Usermanage;

@property (strong, nonatomic) IBOutlet UIButton *viewOnlybtn_userManage;
@property (strong, nonatomic) IBOutlet UIButton *changeSchedule_userManage;
@property (strong, nonatomic) IBOutlet UIButton *fullAccess_userManage;
@property (strong, nonatomic) IBOutlet UITableView *tableView_UserManagement;
@property (strong, nonatomic) NSMutableArray *arrUserAccounts;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_UserManage;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_Billing;
@property (strong, nonatomic) IBOutlet UITableView *tableView_Controller;
@property (strong, nonatomic) IBOutlet UITableView *tableView_BillingHistory;
@property (strong, nonatomic) NSMutableArray *arrCellularController;
@property (strong, nonatomic) NSMutableArray *arrNoStation;
@property (strong, nonatomic) NSMutableArray *arrBillingAmount;
@property (strong, nonatomic) NSMutableArray *arrBillingHistory;
@property (strong, nonatomic) NSMutableArray *arrPlanOption;

@property (strong, nonatomic) IBOutlet UITextField *txtfld_CardName_UpdateCard;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_CardNo_UpdateCard;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_Month_UpdateCard;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_Year_UpdateCard;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_zipCode_UpdateCard;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_digits_UpdateCard;
@property (strong, nonatomic) UITextField *current_textfield_Billing;

@property (strong, nonatomic) IBOutlet UITableView *tableView_PlanOptions;

@property (strong, nonatomic) IBOutlet UIImageView *imgCheck_Network1_UserManage;
@property (strong, nonatomic) IBOutlet UIImageView *imgCheck_Network2_UserManage;
@property (strong, nonatomic) IBOutlet UIImageView *imgCheck_Network3_UserManage;
@property (strong, nonatomic) IBOutlet UIImageView *imgCheck_Network4_UserManage;
@property (strong, nonatomic) IBOutlet UIImageView *imgCheck_Network5_UserManage;
@property (strong, nonatomic) IBOutlet UIImageView *imgCheck_Network6_UserManage;
@property (strong, nonatomic) IBOutlet UIScrollView *bodyViewScroll_UserManage;
@property (strong, nonatomic) IBOutlet UIButton *btnSave_SelectNetwork_UserManage;
@property (strong, nonatomic) NSString *strPreviousView;
@property (strong, nonatomic) NSString *str_Cellular_FirstStatus;

@property (strong, nonatomic) IBOutlet UIButton *btn_timeZone_Settings;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Language;
@property (strong, nonatomic) NSMutableArray *arrUserNW_Acc;
@property (strong, nonatomic) IBOutlet UIButton *btn_InAppStatus;
@property (strong,nonatomic) IBOutlet UIScrollView *scroll_History;
@property (strong,nonatomic) IBOutlet UIScrollView *scroll_AddNw_AddUser;
@property (strong, nonatomic) IBOutlet UIView *addUser_View_Mgt;

@property (strong,nonatomic) IBOutlet UIView *view_Settings_CardDetailView;
@property (strong,nonatomic) IBOutlet UIView *view_Settings_CardControllerView;
@property (strong, nonatomic) IBOutlet UIView *viewBilling_History;
@property (strong,nonatomic) IBOutlet UIScrollView *scroll_Billing_Main_Container;
@property (strong, nonatomic) NSMutableArray *arrUserBilling_Controller;
@property (strong, nonatomic) NSMutableArray *arrBilling_History;

//Add Card Widgets
@property (strong, nonatomic) IBOutlet UILabel *lbl_Plan_Name_MainView;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Plan_Controller_Name_MainView;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Plan_Controller_Count_MainView;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Plan_RenewalDate_MainView;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Plan_Name_Detail_View;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Plan_Controller_Cost_Detail_View;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Plan_RenewalDate_Detail_View;

//Credit Card Detail Widgets
@property (strong, nonatomic) IBOutlet UILabel *lbl_CC_Name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_CC_Number;
@property (strong, nonatomic) IBOutlet UILabel *lbl_CC_ExpiryDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_CC_Logo;


@property (strong, nonatomic) IBOutlet UIView *viewPlan;
@property (strong, nonatomic) IBOutlet UIView *viewPlanWifi;

//ScrollView plan option
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_PlanCard;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_Planoptions;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollUpdateCard;

@property (strong, nonatomic) IBOutlet UIImageView *imgView_Payment_Visa;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Payment_Mastro;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Payment_American;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Payment_Discover;
@property (strong, nonatomic) IBOutlet UIView *viewFooter_BillingHistory;
@property (strong, nonatomic) IBOutlet UIView *view_SwipeDown_Payment;
@property (strong, nonatomic) IBOutlet UIView *viewPayment_Alert;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls_Billing;

//User Mgt ImageView
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Name_UM;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Email_UM;
@property (strong, nonatomic) IBOutlet UILabel *lblName_UM;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail_UM;
@property (strong, nonatomic) IBOutlet UILabel *lblLastName_UM;

@property (strong, nonatomic) IBOutlet UIView *view_PermissionAlert;
@property (strong, nonatomic) IBOutlet UIView *viewBilling_RenewalDate;

@property (strong, nonatomic) IBOutlet UIView *viewAlert_CVVDigit;
@property (strong, nonatomic) IBOutlet UIView *viewAlert_PlanUpgrade_Billing;
@property (strong, nonatomic) IBOutlet UIView *viewAlert_PlanUpgrade_Confirm_Billing;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PlanUpgrade_Charge_Billing;

-(IBAction)back_NetworkHome_Action_In_Settings:(id)sender;
-(IBAction)edit_settings_Action:(id)sender;
-(IBAction)save_settings_Action:(id)sender;
-(IBAction)tempToggle_Action:(id)sender;
-(IBAction)back_settings_Action:(id)sender;
-(IBAction)TimeZone_Action:(id)sender;
-(IBAction)close_setting_Action:(id)sender;
-(IBAction)paginationNext_Action:(id)sender;
-(IBAction)changeTab_From_Settings_Action:(id)sender;
-(IBAction)networkPermission_Action:(id)sender;
-(IBAction)selectNetwork_UserManage_Action:(id)sender;
-(IBAction)close_AlertView_Billing_UserManage_Action:(id)sender;
-(IBAction)openClose_Info_Action:(id)sender;
-(IBAction)inAppMessagingStatus_Action:(id)sender;
-(IBAction)selectLanguage_Action:(id)sender;
-(IBAction)paginationNext_Action_Billing:(id)sender;
-(IBAction)signOut_Action:(id)sender;
-(IBAction)userPermissionType_Action:(id)sender;
-(IBAction)planUpgrade_Confirmation_Billing_Action:(id)sender;
@end
