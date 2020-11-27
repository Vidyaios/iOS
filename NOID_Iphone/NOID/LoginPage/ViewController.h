//
//  ViewController.h
//  NOID
//
//  Created by iExemplar on 22/06/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BSKeyboardControls.h"
#import <CoreLocation/CoreLocation.h>

@class AppDelegate;

@interface ViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,BSKeyboardControlsDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CATransition *animation;
    CLLocation *currentLocation;
    CLGeocoder *geocoder;

    MPMoviePlayerController *moviePlayer;
    
    NSString *strEmailStatus,*strPasswordStatus,*strNameStatus,*strBubbleStatus,*strLastNameStatus,*strPwdEditMode,*strPasswordStatus_Signin,*strBubbleStatus_SignIn,*strPwdEditMode_SignIn,*strEmailStatus_Signin,*strViewStatus,*strResponseError,*strLat,*strlongs,*strLanguage,*strTimeZone,*strVerifypwdStatus,*strVerifyPwd,*strResetEmailStatus,*strNetworkId;
    
    BOOL strHomeStatus,rememberAction,mail_Flag_Signin,pwd_Flag_Signin,mail_Flag,pwd_Flag,confirmPwd_Flag,firstName_Flag,lastName_Flag,mail_FlagReset;
    
    AppDelegate *appDelegate;
    
    NSUserDefaults *defaults;
    
    NSDictionary *responseDict,*networkData_Dict;
    NSString *deviceToken,*strnetworkId,*strResetAlert,*strTempType,*DateFormat,*hashPWD,*strOrgTimeZone;
    NSString *strTimeZoneIDFor_User;
}
@property BOOL didFindLocation;
@property (strong, nonatomic) UIImageView *imageViewbk;
@property (strong, nonatomic) IBOutlet UIView *IntroView;
@property (strong, nonatomic) IBOutlet UIView *RegisterView;
@property (strong, nonatomic) IBOutlet UIView *SignInView;
@property (strong, nonatomic) IBOutlet UIView *signInBodyView;
@property (strong, nonatomic) IBOutlet UIView *frgtPswdBodyView;

@property (strong, nonatomic) IBOutlet UIView *TCView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@property (strong, nonatomic) IBOutlet UITextField *txtfld_email_reg;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_pswd_reg;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_Verifypswd_reg;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_firstName_reg;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_lastName_reg;
@property (strong, nonatomic) UITextField *current_textField;

@property (strong, nonatomic) IBOutlet UITextField *txtfld_email_signIn;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_pswd_signIn;

@property (strong, nonatomic) IBOutlet UITextField *txtfld_forgotPswd;
@property (strong, nonatomic) IBOutlet UIButton *btn_check;

//Reg Error Messgaes
@property (strong, nonatomic) IBOutlet UILabel *lblCount_PWd;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail_Reg;
@property (strong, nonatomic) IBOutlet UILabel *lblName_Reg;
@property (strong, nonatomic) IBOutlet UILabel *lblLastName_Reg;
@property (strong, nonatomic) IBOutlet UILabel *lblPWd_Reg;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail_SignIn;
@property (strong, nonatomic) IBOutlet UILabel *lblPwd_SignIn;

@property (strong, nonatomic) IBOutlet UIView *viewPwd_Bubble_Popup;
@property (strong, nonatomic) IBOutlet UIView *email_View_Reg;
@property (strong, nonatomic) IBOutlet UIView *pwd_View_Reg;
@property (strong, nonatomic) IBOutlet UIView *confirm_Pwd_View_Reg;
@property (strong, nonatomic) IBOutlet UIView *name_View_Reg;
@property (strong, nonatomic) IBOutlet UIView *email_View_SignIn;
@property (strong, nonatomic) IBOutlet UIView *pwd_View_SignIn;
@property (strong, nonatomic) IBOutlet UIView *TCemail_View;

@property (strong, nonatomic) IBOutlet UIImageView *imgView_Email_Reg;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Pwd_Reg;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_ConfrimPwd_Reg;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Name_Reg;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Email_SignIn;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Pwd_SignIn;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_ResetPwd;

@property (strong, nonatomic) IBOutlet UIButton *btn_SignIn;
@property (strong, nonatomic) IBOutlet UIButton *btn_Create_Reg;
@property (strong, nonatomic) IBOutlet UIButton *btn_rememberMe_SignIn;
@property (strong, nonatomic) IBOutlet UIButton *btn_forgetPwd_SignIn;
@property (strong, nonatomic) IBOutlet UIButton *btn_ResetPwd;

@property (strong, nonatomic) IBOutlet UITextView *txtView_TermsAndCond;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_emailTC;

-(IBAction)register_Action:(id)sender;
-(IBAction)signIn_Action:(id)sender;
-(IBAction)backRegister_Action:(id)sender;
-(IBAction)backSignIn_Action:(id)sender;
-(IBAction)ForgotPswd_Action:(id)sender;
-(IBAction)back_ForgotPswd_Action:(id)sender;
-(IBAction)home_Action:(id)sender;
-(IBAction)Login_Action:(id)sender;
-(IBAction)remember_Action:(id)sender;
-(IBAction)TC_Action:(id)sender;
-(IBAction)close_TC_Action:(id)sender;
-(IBAction)Forgot_home_Action:(id)sender;
-(IBAction)newUserCreate_Action:(id)sender;

@end

