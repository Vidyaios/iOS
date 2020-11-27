//
//  CellularViewController.h
//  NOID
//
//  Created by iExemplar on 24/08/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>

@interface CellularViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate,BSKeyboardControlsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>
{
    NSString *strAlert_Type,*strPayment_Selected_Tap,*strPayment_PreviousTap,*strExpandFlagStatus,*strEditCardStatus;
    CGRect frame_Org_QRView;
    BOOL cellular_billing_ExpandedStatus,cellular_Connection_ExpandedStatus,cellular_ControllerStatus,billing_ChargeCardView_ExpandStatus,cellular_QR_ExpandStatus;
    AppDelegate *appDelegate;
    NSString *strPaymentType,*strEncoded_ControllerImage,*strResponseError,*strNetwork_Added_Status;
    NSUserDefaults *defaultsCellular;
    BOOL name_Billing_Flag,cardNumber_Billing_Flag,month_Billing_Flag,year_Billing_Flag,cscDigits_Billing_Flag,zipcode_Billing_Flag,imageStatus,hasPaymentCard;
    NSDictionary *responseDict,*networkData_Dict;
    int arrStoreCount,indexPlans;
    NSMutableArray *arrPlan,*arrPlanRange;
    NSString *strPlanStatus,*strCredit_Card_Added_Status,*strCredit_Card_Updated_Status;
    UITapGestureRecognizer *tapScrollCellular,*tapPlanOptionCellular;
    BOOL credtiCardStatus;
    NSString *strCreditCardID;
    NSString *str_SVD_PaymentType,*str_SVD_CardNumber,*str_SVD_CardName,*str_SVD_Month,*str_SVD_Year,*str_SVD_CSC_Digits,*str_SVD_ZipCode,*str_Added_ControllerID;
    CGAffineTransform transform;
    NSString *planRenewString,*strprorationTime,*strControllerDelete,*currentPlanTimeStamp,*strChargeMyCard;
    float Amount;
    NSString *planExitStatus;
}
@property (nonatomic, strong) NSString *strTimeZoneIDFor_User;
@property (nonatomic, strong) NSString *strCellularAccessType;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_PlanCard;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_Planoptions;

@property (nonatomic, strong) IBOutlet UILabel *lblController_Header;
@property (nonatomic, strong) IBOutlet UILabel *lblController_Welcome;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls_Cellular;
@property (strong, nonatomic) NSString *strControllerStatus;
@property (strong, nonatomic) IBOutlet UIView *viewCellular_Header;
@property (strong, nonatomic) IBOutlet UIView *viewCellular_Body;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewCellular;
//QRView
@property (strong, nonatomic) IBOutlet UIView *viewCellular_QR;
@property (strong, nonatomic) IBOutlet UIView *viewCellular_QR_HeaderContent;
@property (strong, nonatomic) IBOutlet UIView *viewCellular_QR_BodyContent;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_DeviceId_SetUp;
@property (strong, nonatomic) IBOutlet UILabel *lblEdit_QR;

//BillingView
@property (strong, nonatomic) IBOutlet UILabel *lbl_Billing_Index;
@property (strong, nonatomic) IBOutlet UIView *viewBilling;
@property (strong, nonatomic) IBOutlet UIView *view_PaymentCard;
@property (strong, nonatomic) IBOutlet UIView *viewBilling_HeaderContent;
@property (strong, nonatomic) IBOutlet UIView *viewBilling_BodyContent;
@property (strong, nonatomic) IBOutlet UIView *viewBilling_AddCardView;
@property (strong, nonatomic) IBOutlet UIView *viewBilling_ChargeCardView;
@property (strong, nonatomic) IBOutlet UIView *addCardView;
@property (strong, nonatomic) IBOutlet UILabel *lblEdit_Billing;

@property (strong, nonatomic) IBOutlet UIImageView *imgView_Payment_Visa;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Payment_Mastro;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Payment_American;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Payment_Discover;
@property (strong, nonatomic) IBOutlet UIButton *btn_SwipeDown_Payment;


@property (strong, nonatomic) IBOutlet UITextField *txtfld_CardName_UpdateCard;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_CardNo_UpdateCard;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_Month_UpdateCard;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_Year_UpdateCard;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_zipCode_UpdateCard;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_digits_UpdateCard;
@property (strong, nonatomic) UITextField *current_textfield_Billing;

@property (strong, nonatomic) IBOutlet UIView *view_SwipeDown_Payment;
@property (strong, nonatomic) IBOutlet UIView *viewChargeCardSmall;
@property (strong, nonatomic) IBOutlet UIButton *btn_TC;
@property (strong, nonatomic) IBOutlet UIButton *btn_Cellular_Logo;
@property (strong, nonatomic) IBOutlet UIButton *btn_Settings_Cellular;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollPayment;
@property (strong, nonatomic) IBOutlet UIView *view_Billing_Proceed;
@property (strong, nonatomic) IBOutlet UIView *view_Billing_Cancel;

//PlanView
@property (strong, nonatomic) IBOutlet UIView *viewPlan;
@property (strong, nonatomic) IBOutlet UIButton *btn_SwipeDown_Plan;
@property (strong, nonatomic) IBOutlet UIView *view_SwipeDown_Plan;

//Conntection View
@property (strong, nonatomic) IBOutlet UIView *viewConnection;
@property (strong, nonatomic) IBOutlet UIView *viewConnection_HeaderContent;
@property (strong, nonatomic) IBOutlet UIView *viewConnection_BodyContent;
@property (strong, nonatomic) IBOutlet UIView *viewConnection_ProgressView;
@property (strong, nonatomic) IBOutlet UIView *viewConnection_Progress_Succ_View;
@property (strong, nonatomic) IBOutlet UIView *viewConnection_SetupView;
@property (strong, nonatomic) IBOutlet UILabel *lblEdit_Connection;
@property (strong, nonatomic) IBOutlet UILabel *lblConnection_Index;
@property (strong, nonatomic) IBOutlet UIProgressView *progressConnection;
@property (nonatomic) float progressValue;

//Controller View
@property (strong, nonatomic) IBOutlet UILabel *lbl_deviceImgName_CellularController;
@property (strong, nonatomic) IBOutlet UIView *viewController;
@property (strong, nonatomic) IBOutlet UIView *viewController_ImageGallery;
@property (strong, nonatomic) IBOutlet UIView *viewController_ImageEdit;
@property (strong, nonatomic) IBOutlet UIView *viewController_HeaderContent;
@property (strong, nonatomic) IBOutlet UIView *viewController_BodyContent;
@property (strong, nonatomic) IBOutlet UIView *viewController_ProceedView;
@property (strong, nonatomic) IBOutlet UIView *viewController_CancelView;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_DeviceName;
@property (strong, nonatomic) IBOutlet UILabel *lblEdit_Controller;
@property (strong, nonatomic) IBOutlet UILabel *lblContorller_Index;
@property (strong, nonatomic) IBOutlet UIButton *btn_Complete_Setup_Controller;
@property (strong, nonatomic) IBOutlet UIButton *btn_Cancel_Setup_Controller;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Controller;
@property (strong, nonatomic) NSString *str_MultipleNetwork_Mode;
@property (strong, nonatomic) IBOutlet UIView *view_Info_Popup;
@property (strong, nonatomic) IBOutlet UIView *view_Info_TC;
@property (strong, nonatomic) NSString *strPreviousView;

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
@property (strong, nonatomic) NSDictionary *dictController_BasicPlan;

//new
@property (strong, nonatomic) NSString *strController_TraceID;
@property (strong, nonatomic) NSString *strController_ConnectedSTS;
@property (strong, nonatomic) NSString *strController_PaymentCardSTS;
@property (strong, nonatomic) NSString *strController_PaymentCompletedSTS;


@property (strong, nonatomic) IBOutlet UIView *view_deviceSetUp_Alert;
@property (strong, nonatomic) IBOutlet UIView *deleteNetworkView_Cellular;
@property (strong, nonatomic) IBOutlet UIView *popUpDeleteView_Cellular;

@property (strong, nonatomic) IBOutlet UITextView *txtView_TermsAndCond;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_emailTC;
@property (strong, nonatomic) IBOutlet UIView *TCemail_View;

@property (strong, nonatomic) IBOutlet UIView *viewBilling_StarterPlan;
@property (strong, nonatomic) IBOutlet UIView *viewBilling_RenewalDate;
@property (strong, nonatomic) IBOutlet UIView *viewBilling_DefaultPlan;
@property (strong, nonatomic) IBOutlet UIButton *btnInfo_billing;

@property (strong, nonatomic) IBOutlet UIButton *btn_PencilCard;
@property (strong, nonatomic) IBOutlet UIButton *btn_PencilCardName;

@property (strong, nonatomic) IBOutlet UIView *viewAlert_PlanUpgrade;
@property (strong, nonatomic) IBOutlet UIView *viewAlert_PlanUpgrade_Confirmation;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PlanUpgrade_Charge;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PlanUpgrade_Qute;
@property (strong, nonatomic) IBOutlet UIButton *btn_PlanCharge;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewCharge;

-(IBAction)networkHome_CellularController_Action:(id)sender;
//-(IBAction)cellular_QR_ButtonAction:(id)sender;
-(IBAction)cellular_Billing_ButtonAction:(id)sender;
-(IBAction)cellular_Connection_ButtonAction:(id)sender;
-(IBAction)cellular_TapMenu_Action:(id)sender;
-(IBAction)cellular_CardType_Selection_Action:(id)sender;
-(IBAction)controllerSetup_Button_Action:(id)sender;
-(IBAction)changevalidationString:(id)sender;
-(IBAction)deleteNetwork_Cellular_Action:(id)sender;
-(IBAction)planUpgrade_Confirmation_Action:(id)sender;
@end
