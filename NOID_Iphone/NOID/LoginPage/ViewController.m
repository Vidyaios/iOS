//
//  ViewController.m
//  NOID
//
//  Created by iExemplar on 22/06/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "ViewController.h"
#import "Common.h"
#import "MultipleNetworkViewController.h"
#import "WifiViewController.h"
#import "ControllerSetUpViewController.h"
#import "TimeLineViewController.h"
#import "MBProgressHUD.h"
#import "ServiceConnectorModel.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "CellularViewController.h"

@import SystemConfiguration.CaptiveNetwork;
@interface ViewController ()

@end

@implementation ViewController
@synthesize scrollView,txtfld_email_reg,txtfld_email_signIn,txtfld_firstName_reg,txtfld_forgotPswd,txtfld_lastName_reg,txtfld_pswd_reg,txtfld_pswd_signIn,txtfld_Verifypswd_reg,current_textField,btn_check;
@synthesize RegisterView,SignInView,IntroView;
@synthesize frgtPswdBodyView,signInBodyView,imageViewbk;
@synthesize lblEmail_Reg,btn_Create_Reg,email_View_Reg,pwd_View_Reg,confirm_Pwd_View_Reg,name_View_Reg,imgView_ConfrimPwd_Reg,imgView_Email_Reg,imgView_Name_Reg,imgView_Pwd_Reg;
@synthesize viewPwd_Bubble_Popup,lblCount_PWd,lblPWd_Reg,lblName_Reg,lblLastName_Reg;
@synthesize imgView_Email_SignIn,imgView_Pwd_SignIn,btn_SignIn,email_View_SignIn,pwd_View_SignIn,lblEmail_SignIn,lblPwd_SignIn,btn_forgetPwd_SignIn,btn_rememberMe_SignIn;
@synthesize didFindLocation,txtView_TermsAndCond,imgView_ResetPwd,btn_ResetPwd,txtfld_emailTC,TCemail_View;

#pragma mark - View LifeCycle
/* **********************************************************************************
 Date : 22/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Initial setup for the view
 Method Name : viewDidLoad(View Delegate Methods)
 ************************************************************************************* */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tapGestureSetUp_Intro];
    [self scrollView_Configuration];
    [self widget_Configuraiton_Login];
    [self textfield_Widget_Configuration];
//    [self timeZoneWithLanguage];
    [self locationFetch];

    // Do any additional setup after loading the view, typically from a nib.
}

/* **********************************************************************************
 Date : 1/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Method called when the view finish loading.
 Method Name : viewDidUnload(View Delegate Methods)
 ************************************************************************************* */
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setTxtfld_firstName_reg:nil];
    [self setTxtfld_lastName_reg:nil];
    [self setTxtfld_email_reg:nil];
    [self setTxtfld_pswd_reg:nil];
    [self setTxtfld_Verifypswd_reg:nil];
    [self setTxtfld_pswd_signIn:nil];
    [self setTxtfld_email_signIn:nil];
    [self setTxtfld_forgotPswd:nil];
    [self setKeyboardControls:nil];
}

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: View Will Appear
 Description : Set the view after loading
 Method Name : viewWillAppear(View Delegate Methods)
 ************************************************************************************* */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
     [self BgVideoSetup];
}

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: View Will DisAppear
 Description : It mainely used for before going next ViewController
 Method Name : viewDidDisappear(View Delegate Methods)
 ************************************************************************************* */
-(void)viewDidDisappear:(BOOL)animated{

}

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    [moviePlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
/* **********************************************************************************
 Date : 22/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates to the registration screen.
 Method Name : register_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)register_Action:(id)sender
{
    [self PreviousNextButtons_register];
        if(RegisterView.hidden ==YES)
        {
            IntroView.hidden = YES;
            SignInView.hidden=YES;
            RegisterView.hidden = NO;
        }
        else
        {
            RegisterView.hidden = YES;
            SignInView.hidden=YES;
            IntroView.hidden = NO;
        }
    animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
     [animation setDuration:0.2];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[IntroView layer] addAnimation:animation forKey:@"IntroviewPushFromRight"];
    [[RegisterView layer] addAnimation:animation forKey:@"RegisviewPushFromRight"];
    strViewStatus = @"register";
}

/* **********************************************************************************
 Date : 22/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates to the Sign in screen.
 Method Name : signIn_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)signIn_Action:(id)sender
{
    strViewStatus=@"ForgotPassword";
    [self PreviousNextButtons_SignIn];
        if(SignInView.hidden ==YES)
        {
            IntroView.hidden = YES;
            RegisterView.hidden=YES;
            SignInView.hidden = NO;
            signInBodyView.hidden=NO;
            frgtPswdBodyView.hidden=YES;
        }
        else
        {
            SignInView.hidden = YES;
            RegisterView.hidden=YES;
            IntroView.hidden = NO;
            signInBodyView.hidden=YES;
            frgtPswdBodyView.hidden=YES;
        }
    animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:0.2];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[IntroView layer] addAnimation:animation forKey:@"IntroviewPushFromRight"];
    [[SignInView layer] addAnimation:animation forKey:@"viewPushFromRight"];
}

/* **********************************************************************************
 Date : 01/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates back to the the intro screen
 Method Name : register_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)backRegister_Action:(id)sender
{
    if([current_textField resignFirstResponder]){
        [current_textField resignFirstResponder];
    }
//    [self reSet_Reg_Widgets];
//    [self resizeWidgets];
        if(IntroView.hidden ==YES)
        {
            IntroView.hidden = NO;
            SignInView.hidden=YES;
            RegisterView.hidden = YES;
        }
        else
        {
            RegisterView.hidden = NO;
            SignInView.hidden=YES;
            IntroView.hidden = YES;
        }
    animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
   [animation setDuration:0.2];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[IntroView layer] addAnimation:animation forKey:@"IntroviewPushFromRight"];
    [[RegisterView layer] addAnimation:animation forKey:@"RegisviewPushFromLeft"];
}

/* **********************************************************************************
 Date : 01/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates back to the intro screen
 Method Name : backSignIn_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)backSignIn_Action:(id)sender
{
    if([current_textField resignFirstResponder]){
        [current_textField resignFirstResponder];
    }
//    [self reSet_Signin_Widgets];
//    [self resizeWidgets_SignIn];
    if (strHomeStatus==YES) {
        if(signInBodyView.hidden ==YES)
        {
            IntroView.hidden = YES;
            SignInView.hidden=NO;
            signInBodyView.hidden=NO;
            RegisterView.hidden = YES;
            frgtPswdBodyView.hidden=YES;
            strHomeStatus=NO;
        }
        else
        {
            RegisterView.hidden = YES;
            SignInView.hidden=NO;
            signInBodyView.hidden=YES;
            IntroView.hidden = YES;
            frgtPswdBodyView.hidden=NO;
        }
        animation = [CATransition animation];
        [animation setDelegate:self];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [[IntroView layer] addAnimation:animation forKey:@"IntroviewPushFromRight"];
        [[signInBodyView layer] addAnimation:animation forKey:@"SignviewPushFromLeft"];
        
    }else{
        if(IntroView.hidden ==YES)
        {
            IntroView.hidden = NO;
            SignInView.hidden=YES;
            RegisterView.hidden = YES;
        }
        else
        {
            RegisterView.hidden = NO;
            SignInView.hidden=YES;
            IntroView.hidden = YES;
        }
        animation = [CATransition animation];
        [animation setDelegate:self];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
         [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [[IntroView layer] addAnimation:animation forKey:@"IntroviewPushFromRight"];
        [[SignInView layer] addAnimation:animation forKey:@"SignviewPushFromLeft"];

    }
}

/* **********************************************************************************
 Date : 01/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates to the forgot password view
 Method Name : ForgotPswd_Action(View Delegate Methods)
 ***************************** ******************************************************** */
-(IBAction)ForgotPswd_Action:(id)sender
{
//    [self PreviousNextButtons_ForgetPswd];
    scrollView.contentOffset=CGPointZero;
    if([current_textField resignFirstResponder]){
        [current_textField resignFirstResponder];
        [scrollView setContentOffset:CGPointZero animated:YES];
    }
        if(frgtPswdBodyView.hidden ==YES)
        {
            IntroView.hidden = YES;
            SignInView.hidden=NO;
            RegisterView.hidden = YES;
            signInBodyView.hidden=YES;
            frgtPswdBodyView.hidden=NO;
        }
        else
        {
            RegisterView.hidden = YES;
            SignInView.hidden=NO;
            IntroView.hidden = YES;
            signInBodyView.hidden=NO;
            frgtPswdBodyView.hidden=YES;
        }

    animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
   // [animation setDuration:0.8];
    [animation setDuration:0.2];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[signInBodyView layer] addAnimation:animation forKey:@"SignviewPushFromRight"];
    [[frgtPswdBodyView layer] addAnimation:animation forKey:@"ForgetviewPushFromRight"];
    strHomeStatus = YES;
}

/* **********************************************************************************
 Date : 01/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates back to the signIn view
 Method Name : back_ForgotPswd_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)back_ForgotPswd_Action:(id)sender
{
        if(SignInView.hidden ==YES)
        {
            IntroView.hidden = YES;
            SignInView.hidden=NO;
            RegisterView.hidden = YES;
        }
        else
        {
            RegisterView.hidden = YES;
            SignInView.hidden=YES;
            IntroView.hidden = YES;
        }
}

/* **********************************************************************************
 Date : 01/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates back to the intro screen
 Method Name : home_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)home_Action:(id)sender
{
    if([current_textField resignFirstResponder]){
        [current_textField resignFirstResponder];
    }
//    if ([strViewStatus isEqualToString:@"register"]) {
//        [self reSet_Reg_Widgets];
//        [self resizeWidgets];
//    }else{
//        [self reSet_Signin_Widgets];
//        [self resizeWidgets_SignIn];
//        
//    }
    if (strHomeStatus==YES) {
        if(IntroView.hidden ==YES)
        {
            IntroView.hidden = NO;
            SignInView.hidden=YES;
            RegisterView.hidden = YES;
        }
        strHomeStatus=NO;
    }else{
        if(IntroView.hidden ==YES)
        {
            IntroView.hidden = NO;
            SignInView.hidden=YES;
            RegisterView.hidden = YES;
        }
    }
    animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    if ([strViewStatus isEqualToString:@"register"]) {
        [animation setSubtype:kCATransitionFromLeft];
    }else{
        [animation setSubtype:kCATransitionFromLeft];
    }
   // [animation setDuration:0.8];
    [animation setDuration:0.2];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[IntroView layer] addAnimation:animation forKey:@"IntroviewPushFromRight"];
    [[RegisterView layer] addAnimation:animation forKey:@"RegisterviewPushFromLeft"];
    [[SignInView layer] addAnimation:animation forKey:@"RegisterviewPushFromLeft"];
}

-(IBAction)Forgot_home_Action:(id)sender
{
    if(IntroView.hidden ==YES)
    {
        IntroView.hidden = NO;
        SignInView.hidden=YES;
        RegisterView.hidden = YES;
    }
}
/* **********************************************************************************
 Date : 24/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates to the multiple network screen
 Method Name : Login_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)Login_Action:(id)sender
{
    if([current_textField resignFirstResponder]){
        [current_textField resignFirstResponder];
    }
    scrollView.contentOffset = CGPointZero;
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_Registeration) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(login_Noid_UserService) withObject:self];
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
    
//     SWRevealViewController *SWRVC = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
//     SWRVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//     [Common viewFadeInSettings:self.navigationController.view];
//     [self.navigationController pushViewController:SWRVC animated:NO];

//
//    ControllerSetUpViewController *CSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
//    CSVC.str_Cellular_FirstStatus=@"ControllerFirstTime";
//    [self.navigationController pushViewController:CSVC animated:YES];


//    MultipleNetworkViewController *MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
//    [Common viewSlide_FromLeft_ToRight:self.navigationController.view];
//    [self.navigationController pushViewController:MNVC animated:NO];
}

/* **********************************************************************************
 Date : 24/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description :
 Method Name : remember_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)remember_Action:(id)sender
{
//    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//        if([[btn_check backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox_image"]]){
//            [btn_check setBackgroundImage:[UIImage imageNamed:@"tick_image"] forState:UIControlStateNormal];
//            rememberAction=YES;
//        }else{
//            [btn_check setBackgroundImage:[UIImage imageNamed:@"checkbox_image"] forState:UIControlStateNormal];
//            rememberAction=NO;
//        }
//    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//        if([[btn_check backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox_imagei6plus"]]){
//            [btn_check setBackgroundImage:[UIImage imageNamed:@"tick_imagei6plus"] forState:UIControlStateNormal];
//            rememberAction=YES;
//        }else{
//            [btn_check setBackgroundImage:[UIImage imageNamed:@"checkbox_imagei6plus"] forState:UIControlStateNormal];
//            rememberAction=NO;
//        }
//    }else{
//        if([[btn_check backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkBox_UserManagei6plus"]]){
//            [btn_check setBackgroundImage:[UIImage imageNamed:@"tick_imagei6plus"] forState:UIControlStateNormal];
//            rememberAction=YES;
//        }else{
//            [btn_check setBackgroundImage:[UIImage imageNamed:@"checkBox_UserManagei6plus"] forState:UIControlStateNormal];
//            rememberAction=NO;
//        }
//    }
    if([[btn_check backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox_imagei6plus"]]){
        [btn_check setBackgroundImage:[UIImage imageNamed:@"tick_imagei6plus"] forState:UIControlStateNormal];
        rememberAction=YES;
    }else{
        [btn_check setBackgroundImage:[UIImage imageNamed:@"checkbox_imagei6plus"] forState:UIControlStateNormal];
        rememberAction=NO;
    }
}

/* **********************************************************************************
 Date : 01/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event pop up is displayed for the terms and conditions
 Method Name : TC_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)TC_Action:(id)sender
{
    [current_textField resignFirstResponder];
    scrollView.contentOffset = CGPointZero;
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_Registeration) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(tc_Noid_UserService) withObject:self];
        
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
}

///terms_conditions

/* **********************************************************************************
 Date : 01/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : 
 Method Name : close_TC_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)close_TC_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
            [self.TCView setHidden:YES];
            [scrollView setAlpha:1.0];
            [txtView_TermsAndCond scrollRangeToVisible:NSMakeRange(0, 0)];
            break;
        case 1: //Email
        {
//            [self showTCMailAlert];
            self.TCemail_View.hidden=NO;
            self.TCView.userInteractionEnabled=NO;
            self.RegisterView.userInteractionEnabled=NO;
            [self.txtfld_emailTC becomeFirstResponder];
            txtfld_emailTC.text=@"";
        }
            break;
        case 2: //cancel
        {
            self.TCemail_View.hidden=YES;
            self.TCView.userInteractionEnabled=YES;
            self.RegisterView.userInteractionEnabled=YES;
            [self.txtfld_emailTC resignFirstResponder];
            txtfld_emailTC.text=@"";
        }
            break;
        case 3: //Send
        {
            NSLog(@"1 send");
            txtfld_emailTC.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_emailTC.text];
            
            if(txtfld_emailTC.text.length==0){
                [Common showAlert:kAlertTitleWarning withMessage:@"Please enter the email"];
                //[self showTCMailAlert];
                return;
            }
            if([[self emailValidation:txtfld_emailTC.text] isEqualToString:@"NO"]){
                NSLog(@"Please Enter Valid Email Address");
                [Common showAlert:kAlertTitleWarning withMessage:@"Please enter valid email address"];
                // [self showTCMailAlert];
                return;
            }
            if([Common reachabilityChanged]==YES){
                self.TCemail_View.hidden=YES;
                [self.txtfld_emailTC resignFirstResponder];
                [self performSelectorOnMainThread:@selector(start_PinWheel_Registeration) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(sendGridEmail_Noid_UserService) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
            self.TCView.userInteractionEnabled=YES;
            self.RegisterView.userInteractionEnabled=YES;
        }
            break;
    }
}

-(IBAction)newUserCreate_Action:(id)sender
{
    [self timeZoneWithLanguage];
   [self.scrollView setContentOffset:CGPointZero animated:YES];
   [current_textField resignFirstResponder];
   if([Common reachabilityChanged]==YES){
       [self performSelectorOnMainThread:@selector(start_PinWheel_Registeration) withObject:self waitUntilDone:YES];
       [self performSelectorInBackground:@selector(register_New_Noid_UserService) withObject:self];
   }else{
       [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
   }
}

-(IBAction)closeBubble_Action:(id)sender
{
    self.viewPwd_Bubble_Popup.hidden=YES;
    strBubbleStatus=@"NO";
}

-(IBAction)resetPWD_Action:(id)sender
{
    if([txtfld_forgotPswd resignFirstResponder]){
        [txtfld_forgotPswd resignFirstResponder];
    }
    [self resetPasswordAction];
}

#pragma mark - Textfield Delegates

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the return button on the keyboard is clicked
 Method Name : textFieldShouldReturn(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [scrollView setContentOffset:CGPointZero animated:YES];
    if (current_textField==txtfld_forgotPswd) {
        [self resetPasswordAction];
    }
    return YES;
}

/* **********************************************************************************
 Date : 01/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the textfield is selected
 Method Name : textFieldDidBeginEditing(Pre Defined Method)
 ************************************************************************************* */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Focus on TextField");
    current_textField = textField;
    [self.keyboardControls setActiveField:textField];
    
    if (current_textField==txtfld_forgotPswd || current_textField==txtfld_emailTC) {
        NSLog(@"textfield");
    }else{
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y+100);
        } completion:^(BOOL finished) {
        }];
    }

    if(current_textField == txtfld_email_reg)
    {
        if([strEmailStatus isEqualToString:@"YES"]){
            strEmailStatus=@"NO";
            self.lblEmail_Reg.hidden=YES;
            [self resizeWidgets];
            self.imgView_Email_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
        }
    }else if(current_textField == txtfld_pswd_reg){
        if(txtfld_pswd_reg.text.length==0){
            self.imgView_Pwd_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
            self.lblCount_PWd.text=@"8 characters required";
        }
        else if(txtfld_pswd_reg.text.length<8)
        {
            int bubleCount=(int)txtfld_pswd_reg.text.length;
            strPwdEditMode=@"YES";
            [self showPwd_BubbleCount:bubleCount];
        }else{
            strPwdEditMode=@"YES";
            return;
        }
        strBubbleStatus=@"YES";
        self.viewPwd_Bubble_Popup.frame=CGRectMake(self.viewPwd_Bubble_Popup.frame.origin.x, self.pwd_View_Reg.frame.origin.y-viewPwd_Bubble_Popup.frame.size.height, self.viewPwd_Bubble_Popup.frame.size.width, self.viewPwd_Bubble_Popup.frame.size.height);
        self.viewPwd_Bubble_Popup.hidden=NO;
    }else if(current_textField == txtfld_Verifypswd_reg){
//        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y+textField.frame.size.height);
//        } completion:^(BOOL finished) {
//        }];
        if([strPasswordStatus isEqualToString:@"YES"]){
            self.lblPWd_Reg.hidden=YES;
            strPasswordStatus=@"NO";
            [self resizeWidgets];
        }
        if(txtfld_pswd_reg.text.length==0 || txtfld_pswd_reg.text.length<8){
            self.txtfld_Verifypswd_reg.userInteractionEnabled=NO;
            self.confirm_Pwd_View_Reg.alpha=0.4;
        }else{
            self.txtfld_Verifypswd_reg.userInteractionEnabled=YES;
            self.confirm_Pwd_View_Reg.alpha=1.0;
        }
    }
    else if(current_textField==txtfld_firstName_reg || current_textField == txtfld_lastName_reg){
        if([strNameStatus isEqualToString:@"YES"])
        {
            strNameStatus=@"NO";
            firstName_Flag=NO;
            [self resizeWidgets];
            self.lblName_Reg.hidden=YES;
            self.imgView_Name_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
        }
        if([strLastNameStatus isEqualToString:@"YES"])
        {
            strLastNameStatus=@"NO";
            lastName_Flag=NO;
            [self resizeWidgets];
            self.lblLastName_Reg.hidden=YES;
            self.imgView_Name_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
        }
//        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y+100);
//        } completion:^(BOOL finished) {
//        }];
    }
    else if(current_textField == txtfld_pswd_signIn){
        NSLog(@"length==%lu",txtfld_pswd_signIn.text.length);
        if(txtfld_pswd_signIn.text.length==0){
            self.imgView_Pwd_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
//            self.lblPwd_SignIn.hidden=NO;
//            strPasswordStatus_Signin=@"YES";
            if([strBubbleStatus_SignIn isEqualToString:@"NO"]){
                [self resizeWidgets_SignIn];
                [self showSinginPwd_Error_Msg];
            }
        }
        else if(txtfld_pswd_signIn.text.length<8)
        {
            if([strBubbleStatus_SignIn isEqualToString:@"NO"]){
                [self resizeWidgets_SignIn];
                [self showSinginPwd_Error_Msg];
            }
            strPwdEditMode_SignIn=@"YES";
        }
        else{
            strPwdEditMode_SignIn=@"YES";
        }
    }else if(current_textField == txtfld_email_signIn)
    {
        if([strEmailStatus_Signin isEqualToString:@"YES"]){
            strEmailStatus_Signin=@"NO";
            self.lblEmail_SignIn.hidden=YES;
            [self resizeWidgets_SignIn];
            self.imgView_Email_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
        }
    }else if (current_textField==txtfld_forgotPswd){
        if([strResetEmailStatus isEqualToString:@"YES"]){
            strResetEmailStatus=@"NO";
            self.imgView_ResetPwd.backgroundColor=lblRGBA(40, 165, 222, 1);
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"Focus End on TextField");
    
    current_textField=textField;
    if(current_textField==txtfld_email_reg){
        NSLog(@"mail status==%@",strEmailStatus);
        if(txtfld_email_reg.text.length==0 ||mail_Flag==NO){
            mail_Flag=NO;
            strEmailStatus=@"YES";
            [self resizeWidgets];
            self.lblEmail_Reg.hidden=NO;
            self.imgView_Email_Reg.backgroundColor=lblRGBA(211, 7, 25, 1);
        }
    }
    else if(current_textField==txtfld_forgotPswd){
        NSLog(@"mail status==%@",strResetEmailStatus);
        if(txtfld_forgotPswd.text.length==0 ||mail_FlagReset==NO){
            mail_FlagReset=NO;
            strResetEmailStatus=@"YES";
            self.imgView_ResetPwd.backgroundColor=lblRGBA(211, 7, 25, 1);
        }
    }
    else if(current_textField==txtfld_pswd_reg){
        if(txtfld_pswd_reg.text.length>=8){
            NSLog(@"Pwd met req");
            if(self.lblPWd_Reg.hidden==YES){
                self.imgView_Pwd_Reg.backgroundColor=lblRGBA(136, 197, 65, 1);
            }
            pwd_Flag=YES;
        }else{
            NSLog(@"Pwd not met req");
            self.imgView_Pwd_Reg.backgroundColor=lblRGBA(211, 7, 25, 1);
            pwd_Flag=NO;
        }
        self.viewPwd_Bubble_Popup.hidden=YES;
        strBubbleStatus=@"NO";
    }
    else if(current_textField==txtfld_Verifypswd_reg){
        if(txtfld_Verifypswd_reg.text.length>=8){
            NSLog(@"pwd met req");
            if([txtfld_pswd_reg.text isEqualToString:txtfld_Verifypswd_reg.text]){
                NSLog(@"both green");
                self.imgView_Pwd_Reg.backgroundColor=lblRGBA(136, 197, 65, 1);
                self.imgView_ConfrimPwd_Reg.backgroundColor=lblRGBA(136, 197, 65, 1);
            }else{
                NSLog(@"both red");
                self.imgView_Pwd_Reg.backgroundColor=lblRGBA(211, 7, 25, 1);
                self.imgView_ConfrimPwd_Reg.backgroundColor=lblRGBA(211, 7, 25, 1);
                strPasswordStatus=@"YES";
                [self resizeWidgets];
                self.lblPWd_Reg.hidden=NO;
            }
        }else{
            NSLog(@"Pwd not met req");
            self.imgView_Pwd_Reg.backgroundColor=lblRGBA(211, 7, 25, 1);
            self.imgView_ConfrimPwd_Reg.backgroundColor=lblRGBA(211, 7, 25, 1);
            strPasswordStatus=@"YES";
            [self resizeWidgets];
            self.lblPWd_Reg.hidden=NO;
        }
        strVerifypwdStatus = @"YES";
    }
    else if(current_textField==txtfld_firstName_reg){
        if(txtfld_firstName_reg.text.length==0)
        {
            strNameStatus=@"YES";
            firstName_Flag=NO;
            [self resizeWidgets];
            self.lblName_Reg.hidden=NO;
            self.imgView_Name_Reg.backgroundColor=lblRGBA(211, 7, 25, 1);
        }
        if(txtfld_lastName_reg.text.length==0)
        {
            strLastNameStatus=@"YES";
            lastName_Flag=NO;
            [self resizeWidgets];
            self.lblLastName_Reg.hidden=NO;
            self.imgView_Name_Reg.backgroundColor=lblRGBA(211, 7, 25, 1);
        }
    }
    else if(current_textField==txtfld_lastName_reg){
        if(txtfld_lastName_reg.text.length==0)
        {
            strLastNameStatus=@"YES";
            lastName_Flag=NO;
            [self resizeWidgets];
            self.lblLastName_Reg.hidden=NO;
            self.imgView_Name_Reg.backgroundColor=lblRGBA(211, 7, 25, 1);
        }
        if(txtfld_firstName_reg.text.length==0)
        {
            strNameStatus=@"YES";
            [self resizeWidgets];
            self.lblName_Reg.hidden=NO;
            self.imgView_Name_Reg.backgroundColor=lblRGBA(211, 7, 25, 1);
        }
        
    }else if(current_textField==txtfld_email_signIn){
        if(txtfld_email_signIn.text.length==0||mail_Flag_Signin==NO){
            mail_Flag_Signin=NO;
            strEmailStatus_Signin=@"YES";
            [self resizeWidgets_SignIn];
            self.lblEmail_SignIn.hidden=NO;
            self.imgView_Email_SignIn.backgroundColor=lblRGBA(211, 7, 25, 1);
        }
    }else if(current_textField==txtfld_pswd_signIn){
        if(txtfld_pswd_signIn.text.length>=8){
            NSLog(@"Pwd met req");
            //            if(self.lblPwd_SignIn.hidden==YES){
            //                self.imgView_Pwd_SignIn.backgroundColor=lblRGBA(136, 197, 65, 1);
            //            }
            pwd_Flag_Signin=YES;
        }else{
            NSLog(@"Pwd not met req");
            self.imgView_Pwd_SignIn.backgroundColor=lblRGBA(211, 7, 25, 1);
            pwd_Flag_Signin=NO;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"Characters Entered");
    if (range.location == 0 && [string isEqualToString:@" "])
    {
        return NO;
    }
    NSLog(@"string === %@",string);
    NSString * proposedNewString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"whole string === %@",proposedNewString);
    if(current_textField==txtfld_email_reg){
        if([[self emailValidation:proposedNewString] isEqualToString:@"NO"]){
            mail_Flag=NO;
            [self tempHideRegInteraction];
            int mailCount=(int)[proposedNewString length];
            if(mailCount==0){
                strEmailStatus=@"NO";
                self.lblEmail_Reg.hidden=YES;
                [self resizeWidgets];
                self.imgView_Email_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
                return YES;
            }
            self.imgView_Email_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
            NSLog(@"Please Enter Valid Email Address");
            strEmailStatus=@"NO";
        }else{
            mail_Flag=YES;
            [self checkRegisterationValidation];
            self.imgView_Email_Reg.backgroundColor=lblRGBA(136, 197, 65, 1);
        }
    }
    else if(current_textField==txtfld_pswd_reg){
        txtfld_Verifypswd_reg.text=@"";
        NSUInteger newLength = [txtfld_pswd_reg.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSPWD] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        int bubleCount=(int)[proposedNewString length];
        if(([string isEqualToString:filtered])&&(newLength <= UnitfieldDigitsPWd))
        {
            pwd_Flag=NO;
            confirmPwd_Flag=NO;
            [self checkRegisterationValidation];
            if(bubleCount<8){
                if(![strBubbleStatus isEqualToString:@"YES"]){
                    self.imgView_Pwd_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
                    [self showBubblePWd_Popup];
                }
                if([strPwdEditMode isEqualToString:@"YES"]){
                    bubleCount=0;
                    strPwdEditMode=@"NO";
                    strPasswordStatus=@"NO"; //
                    self.imgView_Pwd_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
                    self.imgView_ConfrimPwd_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
                    self.confirm_Pwd_View_Reg.alpha=0.4;
                    self.txtfld_Verifypswd_reg.userInteractionEnabled=NO;
                    self.lblPWd_Reg.hidden=YES; //
                    [self resizeWidgets];
                }
                [self showPwd_BubbleCount:bubleCount];
                self.confirm_Pwd_View_Reg.alpha=0.4;
                self.txtfld_Verifypswd_reg.userInteractionEnabled=NO;
                
            }
            else{
                if([strPwdEditMode isEqualToString:@"YES"]){
                    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
                    int isBackSpace = strcmp(_char, "\b");
                    if (isBackSpace != -8)
                    {
                        bubleCount=1;
                    }else{
                        bubleCount=0;
                    }
                    
                    strPwdEditMode=@"NO";
                    strPasswordStatus=@"NO"; //
                    self.imgView_Pwd_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
                    self.imgView_ConfrimPwd_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
                    self.confirm_Pwd_View_Reg.alpha=0.4;
                    self.txtfld_Verifypswd_reg.userInteractionEnabled=NO;
                    self.lblPWd_Reg.hidden=YES; //
                    [self resizeWidgets];
                    self.viewPwd_Bubble_Popup.hidden=NO;
                    [self showPwd_BubbleCount:bubleCount];
                    strBubbleStatus=@"YES";
                }else{
                    self.viewPwd_Bubble_Popup.hidden=YES;
                    strBubbleStatus=@"NO";
                    self.txtfld_Verifypswd_reg.userInteractionEnabled=YES;
                    self.imgView_Pwd_Reg.backgroundColor=lblRGBA(136, 197, 65, 1);
                    self.confirm_Pwd_View_Reg.alpha=1.0;
                }
                
            }
            return YES;
        }else{
            return NO;
        }
    }
    else if(current_textField==txtfld_Verifypswd_reg){
        //confirmPwd_Flag=NO;
        NSUInteger newLength = [txtfld_Verifypswd_reg.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSPWD] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if ([strVerifypwdStatus isEqualToString:@"YES"]) {
            proposedNewString = @"";
            strVerifypwdStatus=@"NO";
        }
        int verfy_Pwd_Count=(int)[proposedNewString length];
        if(([string isEqualToString:filtered])&&(newLength <= UnitfieldDigitsPWd))
        {
            if(txtfld_pswd_reg.text.length<=verfy_Pwd_Count){
                if([txtfld_pswd_reg.text isEqualToString:proposedNewString])
                {
                    NSLog(@"pwd match");
                    confirmPwd_Flag=YES;
                    self.imgView_Pwd_Reg.backgroundColor=lblRGBA(136, 197, 65, 1);
                    self.imgView_ConfrimPwd_Reg.backgroundColor=lblRGBA(136, 197, 65, 1);
                    [self checkRegisterationValidation];
                    
                }else{
                    NSLog(@"pwd not match");
                    confirmPwd_Flag=NO;
                    self.imgView_ConfrimPwd_Reg.backgroundColor=lblRGBA(211, 7, 25, 1);
                    [self checkRegisterationValidation];
                }
            }else{
                confirmPwd_Flag=NO;
                if (txtfld_pswd_reg.text.length>=8) {
                    self.imgView_Pwd_Reg.backgroundColor=lblRGBA(136, 197, 65, 1);
                }
                self.imgView_ConfrimPwd_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
                [self checkRegisterationValidation];
            }
            return YES;
        }else{
            return NO;
        }
    }
    else if(current_textField==txtfld_firstName_reg){
        NSUInteger newLength = [txtfld_firstName_reg.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSNAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        if(([string isEqualToString:filtered])&&(newLength <= UnitfieldNameLimit))
        {
            int nameCount=(int)[proposedNewString length];
            if(nameCount==0){
                firstName_Flag=NO;
                [self checkRegisterationValidation];
                self.imgView_Name_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
                return YES;
            }else{
                if(self.txtfld_lastName_reg.text.length>0){
                    self.imgView_Name_Reg.backgroundColor=lblRGBA(136, 197, 65, 1);
                }
                firstName_Flag=YES;
                [self checkRegisterationValidation];
                return YES;
            }
            
        }else{
            return NO;
        }
    }
    else if(current_textField==txtfld_lastName_reg){
        NSUInteger newLength = [txtfld_lastName_reg.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSNAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if(([string isEqualToString:filtered])&&(newLength <= UnitfieldNameLimit))
        {
            
            int nameCount=(int)[proposedNewString length];
            if(nameCount==0){
                lastName_Flag=NO;
                [self checkRegisterationValidation];
                self.imgView_Name_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
                return YES;
            }else{
                if(self.txtfld_firstName_reg.text.length>0){
                    self.imgView_Name_Reg.backgroundColor=lblRGBA(136, 197, 65, 1);
                }
                lastName_Flag=YES;
                [self checkRegisterationValidation];
                
                return YES;
            }
        }else{
            return NO;
        }
    }
    else if(current_textField==txtfld_email_signIn){
        if([[self emailValidation:proposedNewString] isEqualToString:@"NO"]){
            mail_Flag_Signin=NO;
            [self tempHideSigninInteraction];
            int mailCount=(int)[proposedNewString length];
            if(mailCount==0){
                strEmailStatus_Signin=@"NO";
                self.lblEmail_SignIn.hidden=YES;
                [self resizeWidgets_SignIn];
                self.imgView_Email_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
                return YES;
            }
            strEmailStatus_Signin=@"NO";
            self.imgView_Email_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
            NSLog(@"Please Enter Valid Email Address");
            //            if(![strEmailStatus_Signin isEqualToString:@"YES"]){
            //                strEmailStatus_Signin=@"YES";
            //                [self resizeWidgets_SignIn];
            //                self.lblEmail_SignIn.hidden=NO;
            //                self.imgView_Email_SignIn.backgroundColor=lblRGBA(211, 7, 25, 1);
            //            }
        }else{
            mail_Flag_Signin=YES;
            [self checkSignInValidation];
            self.imgView_Email_SignIn.backgroundColor=lblRGBA(136, 197, 65, 1);
            //            if([strEmailStatus_Signin isEqualToString:@"YES"]){
            //                strEmailStatus_Signin=@"NO";
            //                self.lblEmail_SignIn.hidden=YES;
            //                [self resizeWidgets_SignIn];
            //                self.imgView_Email_SignIn.backgroundColor=lblRGBA(136, 197, 65, 1);
            //            }
        }
    }
    else if(current_textField==txtfld_pswd_signIn){
        NSUInteger newLength = [txtfld_pswd_signIn.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERSPWD] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        int verfy_Pwd_Count=(int)[proposedNewString length];
        if(([string isEqualToString:filtered])&&(newLength <= UnitfieldDigitsPWd))
        {
            if(verfy_Pwd_Count>=8){
                if([strPwdEditMode_SignIn isEqualToString:@"YES"]){
//                    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
//                    int isBackSpace = strcmp(_char, "\b");
//                    if (isBackSpace != -8)
//                    {
//                        NSLog(@"test");
//                    }else{
//                        NSLog(@"test111111");
//                    }
                    pwd_Flag_Signin=NO;
                    strPwdEditMode_SignIn=@"NO";
                    self.imgView_Pwd_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
                    if([strBubbleStatus_SignIn isEqualToString:@"NO"])
                    {
                        //self.lblPwd_SignIn.hidden=NO;
                        //strPasswordStatus_Signin=@"YES";
                        strBubbleStatus_SignIn=@"YES";
                        [self resizeWidgets_SignIn];
                    }
                    [self checkSignInValidation];
                }else{
                    pwd_Flag_Signin=YES;
                    strPwdEditMode_SignIn=@"NO";
                    self.imgView_Pwd_SignIn.backgroundColor=lblRGBA(136, 197, 65, 1);
                    if([strBubbleStatus_SignIn isEqualToString:@"YES"])
                    {
                        //self.lblPwd_SignIn.hidden=YES;
                        // strPasswordStatus_Signin=@"NO";
                        strBubbleStatus_SignIn=@"NO";
                        [self resizeWidgets_SignIn];
                    }
                    [self checkSignInValidation];
                }
                
            }else{
                pwd_Flag_Signin=NO;
                strPwdEditMode_SignIn=@"NO";
                self.imgView_Pwd_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
                if([strBubbleStatus_SignIn isEqualToString:@"NO"])
                {
                    //self.lblPwd_SignIn.hidden=NO;
                    // strPasswordStatus_Signin=@"YES";
                    strBubbleStatus_SignIn=@"YES";
                    [self resizeWidgets_SignIn];
                }
                [self checkSignInValidation];
            }
            return YES;
        }else{
            return NO;
        }
    }
    else if(current_textField==txtfld_forgotPswd){
        if([[self emailValidation:proposedNewString] isEqualToString:@"NO"]){
            mail_FlagReset=NO;
            [self tempHideResetPwdInteraction];
            int mailCount=(int)[proposedNewString length];
            if(mailCount==0){
                strResetEmailStatus=@"NO";
                self.imgView_ResetPwd.backgroundColor=lblRGBA(40, 165, 222, 1);
                return YES;
            }
            self.imgView_ResetPwd.backgroundColor=lblRGBA(40, 165, 222, 1);
            NSLog(@"Please Enter Valid Email Address");
            strResetEmailStatus=@"NO";
        }else{
            mail_FlagReset=YES;
            [self checkResetPwdValidation];
            self.imgView_ResetPwd.backgroundColor=lblRGBA(136, 197, 65, 1);
        }
    }
    return YES;
}

//blue-(40,165,222);Green-(136,197,65);Red-(211,7,25)
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    current_textField=textField;
    if(current_textField==txtfld_email_reg){
        mail_Flag=NO;
        textField.text=@"";
        strEmailStatus=@"NO";
        self.lblEmail_Reg.hidden=YES;
        [self resizeWidgets];
        self.imgView_Email_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
        [self checkRegisterationValidation];
    }else if(current_textField==txtfld_pswd_reg){
        pwd_Flag=NO;
        confirmPwd_Flag=NO;
        textField.text=@"";
        txtfld_Verifypswd_reg.text=@"";
        strBubbleStatus=@"YES";
        strPasswordStatus=@"NO";
        strPwdEditMode=@"NO";
        self.lblPWd_Reg.hidden=YES;
        self.viewPwd_Bubble_Popup.hidden=NO;
        [self showPwd_BubbleCount:0];
        self.txtfld_Verifypswd_reg.userInteractionEnabled=NO;
        self.confirm_Pwd_View_Reg.alpha=0.4;
        self.imgView_Pwd_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
        self.imgView_ConfrimPwd_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
        [self resizeWidgets];
        [self checkRegisterationValidation];
        // [textField resignFirstResponder];
    }
    else if(current_textField==txtfld_Verifypswd_reg){
        textField.text=@"";
        if(txtfld_pswd_reg.text.length>=8)
        {
            self.imgView_Pwd_Reg.backgroundColor=lblRGBA(136, 197, 65, 1);
        }
        self.imgView_ConfrimPwd_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
        //strPasswordStatus=@"NO";
        if([strPasswordStatus isEqualToString:@"YES"]){
            self.lblPWd_Reg.hidden=YES;
            strPasswordStatus=@"NO";
            [self resizeWidgets];
        }
        confirmPwd_Flag=NO;
        [self checkRegisterationValidation];
        // [textField resignFirstResponder];
    }else if(current_textField==txtfld_firstName_reg){
        firstName_Flag=NO;
        textField.text=@"";
        strNameStatus=@"NO";
        self.lblName_Reg.hidden=YES;
        [self resizeWidgets];
        self.imgView_Name_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
        //        if(self.lblLastName_Reg.hidden==YES){
        //            self.imgView_Name_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
        //        }else{
        //            self.imgView_Name_Reg.backgroundColor=lblRGBA(211, 7, 25, 1);
        //        }
        [self checkRegisterationValidation];
    }
    else if(current_textField==txtfld_lastName_reg){
        lastName_Flag=NO;
        textField.text=@"";
        strLastNameStatus=@"NO";
        self.lblLastName_Reg.hidden=YES;
        [self resizeWidgets];
        self.imgView_Name_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
        //        if(self.lblName_Reg.hidden==YES){
        //            self.imgView_Name_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
        //        }else{
        //          self.imgView_Name_Reg.backgroundColor=lblRGBA(211, 7, 25, 1);
        //        }
        [self checkRegisterationValidation];
    }
    else if(current_textField==txtfld_email_signIn){
        mail_Flag_Signin=NO;
        textField.text=@"";
        strEmailStatus_Signin=@"NO";
        self.lblEmail_SignIn.hidden=YES;
        [self resizeWidgets_SignIn];
        self.imgView_Email_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
        [self checkSignInValidation];
    }
    else if(current_textField==txtfld_pswd_signIn){
        //        pwd_Flag_Signin=NO;
        //        txtfld_pswd_signIn.text=@"";
        //        strBubbleStatus_SignIn=@"YES";
        //        strPasswordStatus_Signin=@"YES";
        //        strPwdEditMode_SignIn=@"NO";
        //        self.lblPwd_SignIn.hidden=YES;
        //        self.imgView_Pwd_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
        //        [self resizeWidgets_SignIn];
        //        [self checkSignInValidation];
        //        [self showSinginPwd_Error_Msg];
        [self signIn_AttemptFailed];
    }
    else if(current_textField==txtfld_forgotPswd){
        mail_FlagReset=NO;
        textField.text=@"";
        strResetEmailStatus=@"NO";
        self.imgView_ResetPwd.backgroundColor=lblRGBA(40, 165, 222, 1);
        [self checkResetPwdValidation];
    }
    return NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - User Defined Methods
-(void)timeZoneWithLanguage
{
    //    NSString *langID = [[NSLocale preferredLanguages] objectAtIndex:0];
    //    strLanguage = [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:langID];
    NSString *localID = [[[NSLocale currentLocale] localeIdentifier] substringToIndex:2];
    NSLog(@"My deviceOS language is: %@", localID);
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    strLanguage = [locale displayNameForKey:NSLocaleIdentifier value:localID];
    NSLog(@"My deviceOS language is: %@", strLanguage);
    
    //Device Wifi Status
    NSLog(@"Device Wifi ==%@",[Common fetchSSIDInfo]);
    
    //Wifi Conntection is Present or not
    NSLog(@"Chk wifi is connected or not ==%@",[Common wifiConnectionStatus]);
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    strOrgTimeZone =[NSString stringWithFormat:@"%@",[currentTimeZone name]];
    NSLog(@"timezone==%@",strOrgTimeZone);
    NSLocale *localeZone = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    strTimeZone = [currentTimeZone localizedName:NSTimeZoneNameStyleStandard locale:localeZone];
    NSLog(@"timezone==%@",strTimeZone);
    
    //Temperature Type
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSLog(@"%@",countryCode);

    if ([countryCode isEqualToString:@"BS"]||[countryCode isEqualToString:@"BZ"]||[countryCode isEqualToString:@"KY"]||[countryCode isEqualToString:@"PW"]||[countryCode isEqualToString:@"US"]) {
        strTempType = @"f";
    }else{
        strTempType=@"c";
    }
    
    if([countryCode isEqualToString:@"Mountain Standard Time"])
    {
        strTimeZone=[NSString stringWithFormat:@"Mountain Time Zone - Arizona"];
    }
    
    if ([countryCode isEqualToString:@"AF"] || [countryCode isEqualToString:@"CN"]
        || [countryCode isEqualToString:@"HU"] || [countryCode isEqualToString:@"JP"]
        || [countryCode isEqualToString:@"KP"] || [countryCode isEqualToString:@"KR"]
        || [countryCode isEqualToString:@"LV"] || [countryCode isEqualToString:@"MM"]
        || [countryCode isEqualToString:@"MN"] || [countryCode isEqualToString:@"MO"]
        || [countryCode isEqualToString:@"NO"] || [countryCode isEqualToString:@"NP"]
        || [countryCode isEqualToString:@"TW"] || [countryCode isEqualToString:@"ZW"] || [countryCode isEqualToString:@"LT"]) {
        DateFormat=@"yyyy/MM/dd";
        
    } else if ([countryCode isEqualToString:@"AO"] || [countryCode isEqualToString:@"AQ"]
               || [countryCode isEqualToString:@"AS"] || [countryCode isEqualToString:@"BI"]
               || [countryCode isEqualToString:@"BJ"] || [countryCode isEqualToString:@"BM"]
               || [countryCode isEqualToString:@"BV"] || [countryCode isEqualToString:@"BW"]
               || [countryCode isEqualToString:@"CA"] || [countryCode isEqualToString:@"CD"]
               || [countryCode isEqualToString:@"CF"] || [countryCode isEqualToString:@"CG"]
               || [countryCode isEqualToString:@"CI"] || [countryCode isEqualToString:@"CK"]
               || [countryCode isEqualToString:@"CM"] || [countryCode isEqualToString:@"CU"]
               || [countryCode isEqualToString:@"DJ"] || [countryCode isEqualToString:@"EH"]
               || [countryCode isEqualToString:@"ER"] || [countryCode isEqualToString:@"FJ"]
               || [countryCode isEqualToString:@"FK"] || [countryCode isEqualToString:@"GA"]
               || [countryCode isEqualToString:@"FM"] || [countryCode isEqualToString:@"GH"]
               || [countryCode isEqualToString:@"GM"] || [countryCode isEqualToString:@"GQ"]
               || [countryCode isEqualToString:@"GN"] || [countryCode isEqualToString:@"GS"]
               || [countryCode isEqualToString:@"GU"] || [countryCode isEqualToString:@"GW"]
               || [countryCode isEqualToString:@"HM"] || [countryCode isEqualToString:@"HT"]
               || [countryCode isEqualToString:@"KE"] || [countryCode isEqualToString:@"KI"]
               || [countryCode isEqualToString:@"KM"] || [countryCode isEqualToString:@"KY"]
               || [countryCode isEqualToString:@"LR"] || [countryCode isEqualToString:@"LS"]
               || [countryCode isEqualToString:@"MD"] || [countryCode isEqualToString:@"MG"]
               || [countryCode isEqualToString:@"MH"] || [countryCode isEqualToString:@"MK"]
               || [countryCode isEqualToString:@"ML"] || [countryCode isEqualToString:@"MP"]
               || [countryCode isEqualToString:@"MR"] || [countryCode isEqualToString:@"MW"]
               || [countryCode isEqualToString:@"MZ"] || [countryCode isEqualToString:@"NA"]
               || [countryCode isEqualToString:@"NC"] || [countryCode isEqualToString:@"NE"]
               || [countryCode isEqualToString:@"NF"] || [countryCode isEqualToString:@"NG"]
               || [countryCode isEqualToString:@"NR"] || [countryCode isEqualToString:@"NU"]
               || [countryCode isEqualToString:@"PG"] || [countryCode isEqualToString:@"PH"]
               || [countryCode isEqualToString:@"PM"] || [countryCode isEqualToString:@"PN"]
               || [countryCode isEqualToString:@"PR"] || [countryCode isEqualToString:@"RW"]
               || [countryCode isEqualToString:@"SB"] || [countryCode isEqualToString:@"SC"]
               || [countryCode isEqualToString:@"SH"] || [countryCode isEqualToString:@"SN"]
               || [countryCode isEqualToString:@"SO"] || [countryCode isEqualToString:@"SS"]
               || [countryCode isEqualToString:@"ST"] || [countryCode isEqualToString:@"SZ"]
               || [countryCode isEqualToString:@"TC"] || [countryCode isEqualToString:@"TD"]
               || [countryCode isEqualToString:@"TF"] || [countryCode isEqualToString:@"TG"]
               || [countryCode isEqualToString:@"TK"] || [countryCode isEqualToString:@"TL"]
               || [countryCode isEqualToString:@"TO"] || [countryCode isEqualToString:@"TZ"]
               || [countryCode isEqualToString:@"UG"] || [countryCode isEqualToString:@"UM"]
               || [countryCode isEqualToString:@"US"] || [countryCode isEqualToString:@"VG"]
               || [countryCode isEqualToString:@"VI"] || [countryCode isEqualToString:@"VU"]
               || [countryCode isEqualToString:@"WF"] || [countryCode isEqualToString:@"WS"]
               || [countryCode isEqualToString:@"YT"] || [countryCode isEqualToString:@"ZM"] || [countryCode  isEqualToString:@"BS"]) {
        DateFormat=@"MM/dd/yyyy";
        
    } else if ([countryCode isEqualToString:@"AD"] || [countryCode isEqualToString:@"AE"]
               || [countryCode isEqualToString:@"AG"] || [countryCode isEqualToString:@"AI"]
               || [countryCode isEqualToString:@"AL"] || [countryCode isEqualToString:@"AM"]
               || [countryCode isEqualToString:@"AR"] || [countryCode isEqualToString:@"AT"]
               || [countryCode isEqualToString:@"AU"] || [countryCode isEqualToString:@"AW"]
               || [countryCode isEqualToString:@"AX"] || [countryCode isEqualToString:@"AZ"]
               || [countryCode isEqualToString:@"BA"] || [countryCode isEqualToString:@"BB"]
               || [countryCode isEqualToString:@"BD"] || [countryCode isEqualToString:@"BE"]
               || [countryCode isEqualToString:@"BF"] || [countryCode isEqualToString:@"BG"]
               || [countryCode isEqualToString:@"BH"] || [countryCode isEqualToString:@"BL"]
               || [countryCode isEqualToString:@"BN"] || [countryCode isEqualToString:@"BO"]
               || [countryCode isEqualToString:@"BQ"] || [countryCode isEqualToString:@"BR"]
               || [countryCode isEqualToString:@"BT"] || [countryCode isEqualToString:@"BY"]
               || [countryCode isEqualToString:@"BZ"] || [countryCode isEqualToString:@"CC"]
               || [countryCode isEqualToString:@"CH"] || [countryCode isEqualToString:@"CL"]
               || [countryCode isEqualToString:@"CO"] || [countryCode isEqualToString:@"CR"]
               || [countryCode isEqualToString:@"CV"] || [countryCode isEqualToString:@"CW"]
               || [countryCode isEqualToString:@"CX"] || [countryCode isEqualToString:@"CY"]
               || [countryCode isEqualToString:@"CZ"] || [countryCode isEqualToString:@"DE"]
               || [countryCode isEqualToString:@"DK"] || [countryCode isEqualToString:@"DM"]
               || [countryCode isEqualToString:@"DO"] || [countryCode isEqualToString:@"DZ"]
               || [countryCode isEqualToString:@"EC"] || [countryCode isEqualToString:@"EG"]
               || [countryCode isEqualToString:@"EE"] || [countryCode isEqualToString:@"ES"]
               || [countryCode isEqualToString:@"ET"] || [countryCode isEqualToString:@"FI"]
               || [countryCode isEqualToString:@"FO"] || [countryCode isEqualToString:@"FR"]
               || [countryCode isEqualToString:@"GD"] || [countryCode isEqualToString:@"GB"]
               || [countryCode isEqualToString:@"GE"] || [countryCode isEqualToString:@"GF"]
               || [countryCode isEqualToString:@"GG"] || [countryCode isEqualToString:@"GI"]
               || [countryCode isEqualToString:@"GL"] || [countryCode isEqualToString:@"GP"]
               || [countryCode isEqualToString:@"GR"] || [countryCode isEqualToString:@"GT"]
               || [countryCode isEqualToString:@"GY"] || [countryCode isEqualToString:@"HK"]
               || [countryCode isEqualToString:@"HN"] || [countryCode isEqualToString:@"HR"]
               || [countryCode isEqualToString:@"ID"] || [countryCode isEqualToString:@"IE"]
               || [countryCode isEqualToString:@"IL"] || [countryCode isEqualToString:@"IM"]
               || [countryCode isEqualToString:@"IN"] || [countryCode isEqualToString:@"IQ"]
               || [countryCode isEqualToString:@"IO"] || [countryCode isEqualToString:@"IR"]
               || [countryCode isEqualToString:@"IS"] || [countryCode isEqualToString:@"IT"]
               || [countryCode isEqualToString:@"JE"] || [countryCode isEqualToString:@"JM"]
               || [countryCode isEqualToString:@"JO"] || [countryCode isEqualToString:@"KG"]
               || [countryCode isEqualToString:@"KH"] || [countryCode isEqualToString:@"KN"]
               || [countryCode isEqualToString:@"KW"] || [countryCode isEqualToString:@"KZ"]
               || [countryCode isEqualToString:@"LA"] || [countryCode isEqualToString:@"LB"]
               || [countryCode isEqualToString:@"LC"] || [countryCode isEqualToString:@"LI"]
               || [countryCode isEqualToString:@"LK"] || [countryCode isEqualToString:@"LU"]
               || [countryCode isEqualToString:@"LY"] || [countryCode isEqualToString:@"MA"]
               || [countryCode isEqualToString:@"MC"] || [countryCode isEqualToString:@"ME"]
               || [countryCode isEqualToString:@"MF"] || [countryCode isEqualToString:@"MQ"]
               || [countryCode isEqualToString:@"MS"] || [countryCode isEqualToString:@"MT"]
               || [countryCode isEqualToString:@"MU"] || [countryCode isEqualToString:@"MV"]
               || [countryCode isEqualToString:@"MX"] || [countryCode isEqualToString:@"MY"]
               || [countryCode isEqualToString:@"NI"] || [countryCode isEqualToString:@"NL"]
               || [countryCode isEqualToString:@"NZ"] || [countryCode isEqualToString:@"OM"]
               || [countryCode isEqualToString:@"PA"] || [countryCode isEqualToString:@"PE"]
               || [countryCode isEqualToString:@"PF"] || [countryCode isEqualToString:@"PK"]
               || [countryCode isEqualToString:@"PL"] || [countryCode isEqualToString:@"LI"]
               || [countryCode isEqualToString:@"PS"] || [countryCode isEqualToString:@"PT"]
               || [countryCode isEqualToString:@"PW"] || [countryCode isEqualToString:@"PY"]
               || [countryCode isEqualToString:@"QA"] || [countryCode isEqualToString:@"RE"]
               || [countryCode isEqualToString:@"RO"] || [countryCode isEqualToString:@"RS"]
               || [countryCode isEqualToString:@"RU"] || [countryCode isEqualToString:@"SA"]
               || [countryCode isEqualToString:@"SD"] || [countryCode isEqualToString:@"SE"]
               || [countryCode isEqualToString:@"SG"] || [countryCode isEqualToString:@"SI"]
               || [countryCode isEqualToString:@"SJ"] || [countryCode isEqualToString:@"SK"]
               || [countryCode isEqualToString:@"SL"] || [countryCode isEqualToString:@"SM"]
               || [countryCode isEqualToString:@"SR"] || [countryCode isEqualToString:@"SV"]
               || [countryCode isEqualToString:@"SX"] || [countryCode isEqualToString:@"SY"]
               || [countryCode isEqualToString:@"TH"] || [countryCode isEqualToString:@"TJ"]
               || [countryCode isEqualToString:@"TM"] || [countryCode isEqualToString:@"TN"]
               || [countryCode isEqualToString:@"TR"] || [countryCode isEqualToString:@"TT"]
               || [countryCode isEqualToString:@"TV"] || [countryCode isEqualToString:@"UA"]
               || [countryCode isEqualToString:@"UY"] || [countryCode isEqualToString:@"UZ"]
               || [countryCode isEqualToString:@"VA"] || [countryCode isEqualToString:@"VC"]
               || [countryCode isEqualToString:@"VE"] || [countryCode isEqualToString:@"VN"]
               || [countryCode isEqualToString:@"YE"] || [countryCode isEqualToString:@"ZA"]) {
        DateFormat=@"dd/MM/yyyy";
    }
}

/* **********************************************************************************
 Date : 01/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Initial Setup for scroll view
 Method Name : scrollView_Configuration(Pre Defined Method)
 ************************************************************************************* */
-(void)scrollView_Configuration
{
    scrollView .showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.scrollEnabled=YES;
    scrollView.userInteractionEnabled=YES;
    scrollView.delegate=self;
    scrollView.scrollsToTop=NO;
}

/* **********************************************************************************
 Date : 01/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Set textfiled delegate and textfield placeholder color
 Method Name : textfield_Widget_Configuration(Pre Defined Method)
 ************************************************************************************* */
-(void)textfield_Widget_Configuration
{
    txtfld_email_reg.delegate = self;
    txtfld_firstName_reg.delegate = self;
    txtfld_lastName_reg.delegate = self;
    txtfld_pswd_reg.delegate = self;
    txtfld_Verifypswd_reg.delegate=self;
    txtfld_email_signIn.delegate=self;
    txtfld_pswd_signIn.delegate=self;
    txtfld_forgotPswd.delegate=self;
    
    txtfld_email_reg.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_pswd_reg.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_Verifypswd_reg.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_firstName_reg.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_lastName_reg.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_email_signIn.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_pswd_signIn.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_forgotPswd.clearButtonMode = UITextFieldViewModeWhileEditing;
    [txtfld_firstName_reg setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_email_reg setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_lastName_reg setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_pswd_reg setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_Verifypswd_reg setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_email_signIn setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_pswd_signIn setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_forgotPswd setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.TCView setHidden:YES];
    RegisterView.hidden=YES;
    SignInView.hidden=YES;
    signInBodyView.hidden=YES;
    frgtPswdBodyView.hidden=YES;
    
    txtfld_emailTC.delegate=self;
    [txtfld_emailTC setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
}

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Animate the view when the next and previous button clicked for registeration screen
 Method Name : PreviousNextButtons_reg(User Defined Methods)
 ************************************************************************************* */
-(void)PreviousNextButtons_register
{
    NSArray *fields = @[txtfld_email_reg,txtfld_pswd_reg,txtfld_Verifypswd_reg,txtfld_firstName_reg,txtfld_lastName_reg];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Animate the view when the next and previous button clicked for signIn screen
 Method Name : PreviousNextButtons_SignIn(User Defined Methods)
 ************************************************************************************* */
-(void)PreviousNextButtons_SignIn
{
    NSArray *fields = @[txtfld_email_signIn,txtfld_pswd_signIn];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Animate the view when the next and previous button clicked for forget password screen
 Method Name : PreviousNextButtons_ForgetPswd(User Defined Methods)
 ************************************************************************************* */
-(void)PreviousNextButtons_ForgetPswd
{
    NSArray *fields = @[txtfld_forgotPswd];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Hide the keyboard from the superview
 Method Name : keyboardControlsDonePressed(Pre Defined Methods)
 ************************************************************************************* */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [scrollView setContentOffset:CGPointZero animated:YES];
    [self.view endEditing:YES];
}

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Background Video player setup
 Method Name : BgVideoSetup(User Defined Methods)
 ************************************************************************************* */
-(void)BgVideoSetup
{
    imageViewbk = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageViewbk.image = [UIImage imageNamed:@"LaunchImagePos1"];
    [self.view  addSubview:imageViewbk];
    [self performSelector:@selector(removeFifthBk) withObject:imageViewbk afterDelay:0.4];
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"grassvideo" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    moviePlayer.view.frame = self.view.frame;
    moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    [self.view addSubview:moviePlayer.view];
    [self.view sendSubviewToBack:moviePlayer.view];
    [moviePlayer play];
}

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Start the movie Player
 Method Name : replayMovie(User Defined Methods)
 ************************************************************************************* */
-(void)replayMovie:(NSNotification *)notification
{
        [moviePlayer play];
}

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Remove the first splash image
 Method Name : removeFirstbK(User Defined Methods)
 ************************************************************************************* */
-(void)removeFirstbK
{    
    imageViewbk.image = [UIImage imageNamed:@"LaunchImagePos2"];
    [self performSelector:@selector(removeSecondbBk) withObject:imageViewbk afterDelay:0.4];
    
}

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Remove the second splash image
 Method Name : removeSecondbBk(User Defined Methods)
 ************************************************************************************* */
-(void)removeSecondbBk
{
    
    imageViewbk.image = [UIImage imageNamed:@"LaunchImagePos3"];
    [self.view  addSubview:imageViewbk];
    [self performSelector:@selector(removeThirdBk) withObject:imageViewbk afterDelay:0.4];
}

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Remove the third splash image
 Method Name : removeThirdBk(User Defined Methods)
 ************************************************************************************* */
-(void)removeThirdBk
{
    imageViewbk.image = [UIImage imageNamed:@"LaunchImagePos4"];
    [self.view  addSubview:imageViewbk];
    [self performSelector:@selector(removeFourthBk) withObject:imageViewbk afterDelay:0.8];
}

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Remove the fourth splash image
 Method Name : removeFourthBk(User Defined Methods)
 ************************************************************************************* */
-(void)removeFourthBk
{
    imageViewbk.image = [UIImage imageNamed:@"LaunchImagePos5"];
    [self.view  addSubview:imageViewbk];
    [self performSelector:@selector(removeFifthBk) withObject:imageViewbk afterDelay:0.8];
}

/* **********************************************************************************
 Date : 23/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Remove the fivth splash image
 Method Name : removeFifthBk(User Defined Methods)
 ************************************************************************************* */
-(void)removeFifthBk
{
    imageViewbk.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(replayMovie:)
                                                 name: MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
}


-(void)widget_Configuraiton_Login
{
    strResetAlert=@"";
    self.lblEmail_Reg.hidden=YES;
    self.lblPWd_Reg.hidden=YES;
    self.lblName_Reg.hidden=YES;
    self.lblLastName_Reg.hidden=YES;
    strEmailStatus=@"NO";
    strNameStatus=@"NO";
    strLastNameStatus=@"NO";
    strPasswordStatus=@"NO";
    strBubbleStatus=@"NO";
    self.viewPwd_Bubble_Popup.hidden=YES;
    self.txtfld_Verifypswd_reg.userInteractionEnabled=NO;
    self.confirm_Pwd_View_Reg.alpha=0.4;
    self.imgView_Email_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.imgView_Pwd_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.imgView_ConfrimPwd_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.imgView_Name_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.btn_Create_Reg.userInteractionEnabled=NO;
    self.btn_Create_Reg.alpha=0.4;
    mail_Flag=NO;
    pwd_Flag=NO;
    confirmPwd_Flag=NO;
    firstName_Flag=NO;
    lastName_Flag=NO;
    
    //SignIn
    strEmailStatus_Signin=@"NO";
    strPasswordStatus_Signin=@"NO";
    strBubbleStatus_SignIn=@"NO";
    mail_Flag_Signin=NO;
    pwd_Flag_Signin=NO;
    rememberAction=NO;
    self.lblPwd_SignIn.hidden=YES;
    self.lblEmail_SignIn.hidden=YES;
    self.imgView_Email_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.imgView_Pwd_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.btn_SignIn.userInteractionEnabled=NO;
    self.btn_SignIn.alpha=0.4;
    strVerifypwdStatus=@"NO";
    
    //ForgotPwd
    strResetEmailStatus=@"NO";
    mail_FlagReset=NO;
    self.btn_ResetPwd.userInteractionEnabled=NO;
    self.btn_ResetPwd.alpha=0.4;
    self.txtfld_forgotPswd.enablesReturnKeyAutomatically=YES;
    
    self.TCemail_View.hidden=YES;
    UIBezierPath *maskPathPlan = [UIBezierPath bezierPathWithRoundedRect:TCemail_View.bounds byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(16.0, 16.0)];
    CAShapeLayer *maskLayerPlan = [[CAShapeLayer alloc] init];
    maskLayerPlan.frame = self.view.bounds;
    maskLayerPlan.path  = maskPathPlan.CGPath;
    TCemail_View.layer.mask = maskLayerPlan;
    strOrgTimeZone=@"";
}
-(void)reSet_Reg_Widgets
{
    self.lblEmail_Reg.hidden=YES;
    self.lblPWd_Reg.hidden=YES;
    self.lblName_Reg.hidden=YES;
    self.lblLastName_Reg.hidden=YES;
    strEmailStatus=@"NO";
    strNameStatus=@"NO";
    strPasswordStatus=@"NO";
    strBubbleStatus=@"NO";
    strPwdEditMode=@"NO";
    strLastNameStatus=@"NO";
    self.viewPwd_Bubble_Popup.hidden=YES;
    self.txtfld_Verifypswd_reg.userInteractionEnabled=NO;
    self.confirm_Pwd_View_Reg.alpha=0.4;
    self.imgView_Email_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.imgView_Pwd_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.imgView_ConfrimPwd_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.imgView_Name_Reg.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.txtfld_email_reg.text=@"";
    self.txtfld_pswd_reg.text=@"";
    self.txtfld_firstName_reg.text=@"";
    self.txtfld_lastName_reg.text=@"";
    self.txtfld_Verifypswd_reg.text=@"";
    self.btn_Create_Reg.userInteractionEnabled=NO;
    self.btn_Create_Reg.alpha=0.4;
    mail_Flag=NO;
    pwd_Flag=NO;
    confirmPwd_Flag=NO;
    firstName_Flag=NO;
    lastName_Flag=NO;
    strVerifypwdStatus=@"NO";
}

-(void)reSet_Signin_Widgets
{
    self.lblEmail_SignIn.hidden=YES;
    self.lblPwd_SignIn.hidden=YES;
    strEmailStatus_Signin=@"NO";
    strPasswordStatus_Signin=@"NO";
    strBubbleStatus_SignIn=@"NO";
    strPwdEditMode_SignIn=@"NO";
    self.imgView_Email_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.imgView_Pwd_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.txtfld_email_signIn.text=@"";
    self.txtfld_pswd_signIn.text=@"";
    self.btn_SignIn.userInteractionEnabled=NO;
    self.btn_SignIn.alpha=0.4;
    mail_Flag_Signin=NO;
    pwd_Flag_Signin=NO;
    rememberAction=NO;
    [btn_check setBackgroundImage:[UIImage imageNamed:@"checkbox_imagei6plus"] forState:UIControlStateNormal];
}

-(NSString *)emailValidation :(NSString *)strMailString
{
    NSLog(@"email string ==%@",strMailString);
    NSString *strEmailVal_status;
//    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
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
    if(self.RegisterView.hidden==NO){
        txtfld_email_reg.userInteractionEnabled=YES;
    }else{
        txtfld_email_signIn.userInteractionEnabled=YES;
    }
    return strEmailVal_status;
}

-(void)resizeWidgets_SignIn
{
    NSLog(@"only one");
    // self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.email_View_SignIn.frame=CGRectMake(self.email_View_SignIn.frame.origin.x, self.email_View_SignIn.frame.origin.y, self.email_View_SignIn.frame.size.width,self.email_View_SignIn.frame.size.height);
        if([strEmailStatus_Signin isEqualToString:@"YES"]){
            self.lblEmail_SignIn.frame=CGRectMake(self.lblEmail_SignIn.frame.origin.x, self.email_View_SignIn.frame.origin.y+self.email_View_SignIn.frame.size.height+2, self.lblEmail_SignIn.frame.size.width, self.lblEmail_SignIn.frame.size.height);
            self.pwd_View_SignIn.frame=CGRectMake(self.pwd_View_SignIn.frame.origin.x, self.lblEmail_SignIn.frame.origin.y+self.lblEmail_SignIn.frame.size.height+2, self.pwd_View_SignIn.frame.size.width, self.pwd_View_SignIn.frame.size.height);
        }else{
            self.pwd_View_SignIn.frame=CGRectMake(self.pwd_View_Reg.frame.origin.x, self.email_View_SignIn.frame.origin.y+self.email_View_SignIn.frame.size.height+10, self.pwd_View_SignIn.frame.size.width, self.pwd_View_SignIn.frame.size.height);
        }
//        if([strPasswordStatus_Signin isEqualToString:@"YES"]){
//            self.lblPwd_SignIn.frame=CGRectMake(self.lblPwd_SignIn.frame.origin.x, self.pwd_View_SignIn.frame.origin.y+self.pwd_View_SignIn.frame.size.height+2, self.lblPwd_SignIn.frame.size.width, self.lblPwd_SignIn.frame.size.height);
//            self.btn_SignIn.frame=CGRectMake(self.btn_SignIn.frame.origin.x, self.lblPwd_SignIn.frame.origin.y+self.lblPwd_SignIn.frame.size.height+2, self.btn_SignIn.frame.size.width, self.btn_SignIn.frame.size.height);
//        }else{
            self.btn_SignIn.frame=CGRectMake(self.btn_SignIn.frame.origin.x, self.pwd_View_SignIn.frame.origin.y+self.pwd_View_SignIn.frame.size.height+10, self.btn_SignIn.frame.size.width, self.btn_SignIn.frame.size.height);
//        }
        btn_rememberMe_SignIn.frame = CGRectMake(btn_rememberMe_SignIn.frame.origin.x, btn_SignIn.frame.origin.y+btn_SignIn.frame.size.height+10, btn_rememberMe_SignIn.frame.size.width, btn_rememberMe_SignIn.frame.size.height);
        btn_forgetPwd_SignIn.frame = CGRectMake(btn_forgetPwd_SignIn.frame.origin.x, btn_SignIn.frame.origin.y+btn_SignIn.frame.size.height+10, btn_forgetPwd_SignIn.frame.size.width, btn_forgetPwd_SignIn.frame.size.height);
        btn_check.frame = CGRectMake(btn_check.frame.origin.x, btn_SignIn.frame.origin.y+btn_SignIn.frame.size.height+5, btn_check.frame.size.width, btn_check.frame.size.height);

    } completion:^(BOOL finished) {
        //self.view.userInteractionEnabled=YES;
    }];
}

-(void)showSinginPwd_Error_Msg
{
//    self.lblPwd_SignIn.hidden=NO;
    strBubbleStatus_SignIn=@"YES";
}

-(void)tempHideSigninInteraction
{
    self.btn_SignIn.alpha=0.4;
    self.btn_SignIn.userInteractionEnabled=NO;
}

-(void)checkSignInValidation
{
    if(mail_Flag_Signin==YES&&pwd_Flag_Signin==YES){
        self.btn_SignIn.alpha=1.0;
        self.btn_SignIn.userInteractionEnabled=YES;
    }else
    {
        [self tempHideSigninInteraction];
    }
}

-(void)checkResetPwdValidation
{
    if(mail_FlagReset==YES){
        self.btn_ResetPwd.alpha=1.0;
        self.btn_ResetPwd.userInteractionEnabled=YES;
        self.txtfld_forgotPswd.enablesReturnKeyAutomatically=NO;
    }else
    {
        [self tempHideResetPwdInteraction];
    }
}


-(void)showPwd_BubbleCount:(int)strCount;
{
    int reqCount=8-strCount;
    if(reqCount==1){
        self.lblCount_PWd.text=[NSString stringWithFormat:@"%d character required",reqCount];
    }else{
        self.lblCount_PWd.text=[NSString stringWithFormat:@"%d characters required",reqCount];
    }
    
}
-(void)showBubblePWd_Popup
{
    self.viewPwd_Bubble_Popup.hidden=NO;
    strBubbleStatus=@"YES";
}
-(void)resizeWidgets
{
    NSLog(@"only one");
    // self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.email_View_Reg.frame=CGRectMake(self.email_View_Reg.frame.origin.x, self.email_View_Reg.frame.origin.y, self.email_View_Reg.frame.size.width,self.email_View_Reg.frame.size.height);
        if([strEmailStatus isEqualToString:@"YES"]){
            self.lblEmail_Reg.frame=CGRectMake(self.lblEmail_Reg.frame.origin.x, self.email_View_Reg.frame.origin.y+self.email_View_Reg.frame.size.height+2, self.lblEmail_Reg.frame.size.width, self.lblEmail_Reg.frame.size.height);
            self.pwd_View_Reg.frame=CGRectMake(self.pwd_View_Reg.frame.origin.x, self.lblEmail_Reg.frame.origin.y+self.lblEmail_Reg.frame.size.height+2, self.pwd_View_Reg.frame.size.width, self.pwd_View_Reg.frame.size.height);
        }else{
            self.pwd_View_Reg.frame=CGRectMake(self.pwd_View_Reg.frame.origin.x, self.email_View_Reg.frame.origin.y+self.email_View_Reg.frame.size.height+10, self.pwd_View_Reg.frame.size.width, self.pwd_View_Reg.frame.size.height);
        }
        self.confirm_Pwd_View_Reg.frame=CGRectMake(self.confirm_Pwd_View_Reg.frame.origin.x, self.pwd_View_Reg.frame.origin.y+self.pwd_View_Reg.frame.size.height+10, self.confirm_Pwd_View_Reg.frame.size.width, self.confirm_Pwd_View_Reg.frame.size.height);
        if([strPasswordStatus isEqualToString:@"YES"]){
            self.lblPWd_Reg.frame=CGRectMake(self.lblPWd_Reg.frame.origin.x, self.confirm_Pwd_View_Reg.frame.origin.y+self.confirm_Pwd_View_Reg.frame.size.height+2, self.lblPWd_Reg.frame.size.width, self.lblPWd_Reg.frame.size.height);
            self.name_View_Reg.frame=CGRectMake(self.name_View_Reg.frame.origin.x, self.lblPWd_Reg.frame.origin.y+self.lblPWd_Reg.frame.size.height+2, self.name_View_Reg.frame.size.width, self.name_View_Reg.frame.size.height);
        }else{
            self.name_View_Reg.frame=CGRectMake(self.name_View_Reg.frame.origin.x, self.confirm_Pwd_View_Reg.frame.origin.y+self.confirm_Pwd_View_Reg.frame.size.height+10, self.name_View_Reg.frame.size.width, self.name_View_Reg.frame.size.height);
        }
        if([strNameStatus isEqualToString:@"YES"]){
            if(![strLastNameStatus isEqualToString:@"YES"]){
                self.lblName_Reg.frame=CGRectMake(self.lblName_Reg.frame.origin.x, self.name_View_Reg.frame.origin.y+self.name_View_Reg.frame.size.height+2, self.lblName_Reg.frame.size.width, self.lblName_Reg.frame.size.height);
            }else{
                self.lblName_Reg.frame=CGRectMake(self.lblName_Reg.frame.origin.x, self.name_View_Reg.frame.origin.y+self.name_View_Reg.frame.size.height+2, self.lblName_Reg.frame.size.width, self.lblName_Reg.frame.size.height);
                self.lblLastName_Reg.frame=CGRectMake(self.lblLastName_Reg.frame.origin.x, self.name_View_Reg.frame.origin.y+self.name_View_Reg.frame.size.height+2, self.lblLastName_Reg.frame.size.width, self.lblLastName_Reg.frame.size.height);
            }
            
            self.btn_Create_Reg.frame=CGRectMake(self.btn_Create_Reg.frame.origin.x, self.lblName_Reg.frame.origin.y+self.lblName_Reg.frame.size.height+2, self.btn_Create_Reg.frame.size.width, self.btn_Create_Reg.frame.size.height);
        }else{
            if([strLastNameStatus isEqualToString:@"YES"]){
                self.lblLastName_Reg.frame=CGRectMake(self.lblLastName_Reg.frame.origin.x, self.name_View_Reg.frame.origin.y+self.name_View_Reg.frame.size.height+2, self.lblLastName_Reg.frame.size.width, self.lblLastName_Reg.frame.size.height);
                self.btn_Create_Reg.frame=CGRectMake(self.btn_Create_Reg.frame.origin.x, self.lblLastName_Reg.frame.origin.y+self.lblLastName_Reg.frame.size.height+2, self.btn_Create_Reg.frame.size.width, self.btn_Create_Reg.frame.size.height);
            }else{
                self.btn_Create_Reg.frame=CGRectMake(self.btn_Create_Reg.frame.origin.x, self.name_View_Reg.frame.origin.y+self.name_View_Reg.frame.size.height+10, self.btn_Create_Reg.frame.size.width, self.btn_Create_Reg.frame.size.height);
            }
        }
        
        
        
    } completion:^(BOOL finished) {
        //self.view.userInteractionEnabled=YES;
    }];
}
-(void)tempHideRegInteraction
{
    self.btn_Create_Reg.alpha=0.4;
    self.btn_Create_Reg.userInteractionEnabled=NO;
}
-(void)tempHideResetPwdInteraction
{
    self.btn_ResetPwd.alpha=0.4;
    self.btn_ResetPwd.userInteractionEnabled=NO;
    self.txtfld_forgotPswd.enablesReturnKeyAutomatically=YES;
}

-(void)checkRegisterationValidation
{
    //if(mail_Flag==YES&&firstName_Flag==YES&&lastName_Flag==YES&&pwd_Flag==YES){
    if(mail_Flag==YES&&pwd_Flag==YES&&confirmPwd_Flag==YES&&firstName_Flag==YES&&lastName_Flag==YES){
        self.btn_Create_Reg.alpha=1.0;
        self.btn_Create_Reg.userInteractionEnabled=YES;
    }else
    {
        self.btn_Create_Reg.alpha=0.4;
        self.btn_Create_Reg.userInteractionEnabled=NO;
    }
}

-(void)tapGestureSetUp_Intro
{
    UITapGestureRecognizer *tapGestureView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(introView_Tap:)];
    tapGestureView.numberOfTapsRequired=3;
    tapGestureView.numberOfTouchesRequired=2;
    [IntroView addGestureRecognizer:tapGestureView];
}

-(void)introView_Tap:(UITapGestureRecognizer*)sender
{
    NSLog(@"view touch");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Prod", @"QA",@"Dev", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

-(void)email_Not_Register
{
//    self.lblEmail_SignIn.hidden=YES;
//    self.lblPwd_SignIn.hidden=YES;
//    strEmailStatus_Signin=@"NO";
    strPasswordStatus_Signin=@"NO";
    strBubbleStatus_SignIn=@"NO";
    strPwdEditMode_SignIn=@"NO";
//    self.imgView_Email_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.imgView_Pwd_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.txtfld_pswd_signIn.text=@"";
//    self.txtfld_email_signIn.text=@"";
    self.btn_SignIn.userInteractionEnabled=NO;
    self.btn_SignIn.alpha=0.4;
//    mail_Flag_Signin=YES;
    pwd_Flag_Signin=YES;
//    [txtfld_email_signIn becomeFirstResponder];
//    [self resizeWidgets_SignIn];
    //  rememberAction=NO;
    //  [btn_check setBackgroundImage:[UIImage imageNamed:@"checkbox_image"] forState:UIControlStateNormal];
}

-(void)signIn_AttemptFailed
{
    pwd_Flag_Signin=NO;
    txtfld_pswd_signIn.text=@"";
    strBubbleStatus_SignIn=@"YES";
    strPasswordStatus_Signin=@"YES";
    strPwdEditMode_SignIn=@"NO";
//    self.lblPwd_SignIn.hidden=YES;
    self.imgView_Pwd_SignIn.backgroundColor=lblRGBA(40, 165, 222, 1);
    [self resizeWidgets_SignIn];
    [self checkSignInValidation];
    [self showSinginPwd_Error_Msg];
}


-(void)resetPasswordAction
{
    if(mail_FlagReset==NO)
    {
//        [Common showAlert:kAlertTitleWarning withMessage:@"Please enter valid email"];
        return;
    }
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_Registeration) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(reset_Password_Webservice) withObject:self];
        
        
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
}

-(void)reSet_ResetPassword_Widgets
{
    strResetEmailStatus=@"NO";
    self.imgView_ResetPwd.backgroundColor=lblRGBA(40, 165, 222, 1);
    self.txtfld_forgotPswd.text=@"";
    self.btn_ResetPwd.userInteractionEnabled=NO;
    self.btn_ResetPwd.alpha=0.4;
    mail_FlagReset=NO;
    self.txtfld_forgotPswd.enablesReturnKeyAutomatically=YES;
    strResetAlert=@"";
}

-(void)showTCMailAlert
{
    strResetAlert=@"TC";
    UIAlertView *alert_TC=[[UIAlertView alloc]initWithTitle:@"NOID T&C" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    alert_TC.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert_TC textFieldAtIndex:0] setPlaceholder:@"EMAIL ADDRESS"];
    txtfld_emailTC = [alert_TC textFieldAtIndex:0];
    txtfld_emailTC.keyboardType = UIKeyboardTypeAlphabet;
    txtfld_emailTC.delegate=self;
    txtfld_emailTC.tag=100;
    [alert_TC show];
}

#pragma mark - CLLocation Manager Delegates and User Defined Methods
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : CLLocation manager setup
 Method Name : locationFetchBC(User Defined Methods)
 ************************************************************************************* */
-(void)locationFetch
{
    self.didFindLocation = NO;
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : CLLocation manager show error message
 Method Name : didFailWithError(User Defined Methods)
 ************************************************************************************* */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    //[self stop_PinWheel_Registeration];
    // [Common showAlert:kAlertTitleWarning withMessage:@"Failed to Get Your Location"];
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : CLLocation manager update user location
 Method Name : didUpdateToLocation(User Defined Methods)
 ************************************************************************************* */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (!self.didFindLocation) {
        self.didFindLocation = YES;
        NSLog(@"didUpdateToLocation: %@", newLocation);
        currentLocation = newLocation;
        
        if (currentLocation != nil) {
            NSLog(@"curent lat==%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
            strLat=[NSString stringWithFormat:@"%.2f", currentLocation.coordinate.latitude];
            NSLog(@"curent long==%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
            strlongs=[NSString stringWithFormat:@"%.2f", currentLocation.coordinate.longitude];
        }
        // Stop Location Manager
        [locationManager stopUpdatingLocation];
    }
}

#pragma mark - Action Sheet Delegates
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex==%ld",(long)buttonIndex);
    defaults=[NSUserDefaults standardUserDefaults];
    switch(buttonIndex)
    {
        case 0: //
        {
            
            [defaults setObject:[NSString stringWithFormat:@"%@",getNoidAppUrlProd] forKey:@"NOIDURL"];
            [defaults synchronize];
        }
            break;
        case 1: //
        {
            
            [defaults setObject:[NSString stringWithFormat:@"%@",getNoidAppUrlQA] forKey:@"NOIDURL"];
            [defaults synchronize];
        }
            break;
        case 2: //
        {
            [defaults setObject:[NSString stringWithFormat:@"%@",getNoidAppUrl] forKey:@"NOIDURL"];
            [defaults synchronize];
        }
            break;
    }
}

#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(![strResetAlert isEqualToString:@""])
    {
        NSLog(@"button index ==%ld",(long)buttonIndex);
        if([strResetAlert isEqualToString:@"TC"])
        {
            if ([txtfld_emailTC resignFirstResponder]) {
                [txtfld_emailTC resignFirstResponder];
            }
            strResetAlert=@"";
            if (buttonIndex == 0)
            {
                NSLog(@"0 Cancel");
            }else
            {
                NSLog(@"1 send");
                txtfld_emailTC.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_emailTC.text];
                
                if(txtfld_emailTC.text.length==0){
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please enter the email"];
                    //[self showTCMailAlert];
                    return;
                }
                if([[self emailValidation:txtfld_emailTC.text] isEqualToString:@"NO"]){
                    NSLog(@"Please Enter Valid Email Address");
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please enter valid email address"];
                    // [self showTCMailAlert];
                    return;
                }
                if([Common reachabilityChanged]==YES){
                    [self performSelectorOnMainThread:@selector(start_PinWheel_Registeration) withObject:self waitUntilDone:YES];
                    [self performSelectorInBackground:@selector(sendGridEmail_Noid_UserService) withObject:self];
                    
                }else{
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                }
            }
            
        }else if([strResetAlert isEqualToString:@"Reset"])
        {
            if (buttonIndex == 0)
            {
                NSLog(@"move to sign in");
                IntroView.hidden = YES;
                SignInView.hidden=NO;
                signInBodyView.hidden=NO;
                RegisterView.hidden = YES;
                frgtPswdBodyView.hidden=YES;
                strHomeStatus=NO;
                animation = [CATransition animation];
                [animation setDelegate:self];
                [animation setType:kCATransitionPush];
                [animation setSubtype:kCATransitionFromLeft];
                [animation setDuration:0.2];
                [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
                [[IntroView layer] addAnimation:animation forKey:@"IntroviewPushFromRight"];
                [[signInBodyView layer] addAnimation:animation forKey:@"SignviewPushFromLeft"];
                [self reSet_ResetPassword_Widgets];
                
            }
        }
        
    }
}


#pragma mark - PinWheel Methods
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : This method is called to start the Progress HUD
 Method Name : start_PinWheel_Registeration(User Defined Method)
 ************************************************************************************* */
-(void)start_PinWheel_Registeration{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please Wait";
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : This method is called to stop the Progress HUD
 Method Name : stop_PinWheel_Registeration(User Defined Method)
 ************************************************************************************* */
-(void)stop_PinWheel_Registeration{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
/*
 
 NSString *hashPWD=[Common md5:txtfld_pswd_reg.text];
 ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
 NSMutableDictionary *dictRegDetails=[[NSMutableDictionary alloc] init];
 [dictRegDetails setObject:txtfld_firstName_reg.text forKey:kFirstName];
 [dictRegDetails setObject:txtfld_lastName_reg.text forKey:kLastName];
 [dictRegDetails setObject:txtfld_email_reg.text forKey:kEmailID];
 if(appDelegate.devicetoken_nsdatta==nil){
 deviceToken=@"ASD1c7bf338c5e9bab2ad2fca45ada646d600061c28cf79c90a";
 }else{
 deviceToken=[NSString stringWithFormat:@"%@",appDelegate.devicetoken_nsdatta];
 deviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
 deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
 }
 */
#pragma mark - WebService
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Title: Registeration Webservice
 Description : Registers the user in the server
 Method Name : register_New_Noid_UserService(User Defined Method)
 ************************************************************************************* */
-(void)register_New_Noid_UserService
{
    NSDictionary *parameters;
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    hashPWD=[Common md5:txtfld_pswd_reg.text];
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictRegDetails=[[NSMutableDictionary alloc] init];
    [dictRegDetails setObject:txtfld_firstName_reg.text forKey:kFirstName];
    [dictRegDetails setObject:txtfld_lastName_reg.text forKey:kLastName];
    [dictRegDetails setObject:txtfld_email_reg.text forKey:kEmailID];
    if(appDelegate.devicetoken_nsdatta==nil){
        deviceToken=@"CDF1c7bf338c5e9bab2ad2fca45ada646d600061c28cf79c90a";
    }else{
        deviceToken=[NSString stringWithFormat:@"%@",appDelegate.devicetoken_nsdatta];
        deviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    [dictRegDetails setObject:deviceToken forKey:kDeviceToken];
    [dictRegDetails setObject:hashPWD forKey:kPassword];
    [dictRegDetails setObject:@"1" forKey:kTokenType];
    [dictRegDetails setObject:strLat forKey:kLat];
    [dictRegDetails setObject:strlongs forKey:kLong];
    [dictRegDetails setObject:@"1" forKey:kInAppStatus];
    [dictRegDetails setObject:strTimeZone forKey:KTimeZone];
    [dictRegDetails setObject:strLanguage forKey:kLanguage];
    [dictRegDetails setObject:strTempType forKey:kTemperatureType];
    [dictRegDetails setObject:DateFormat forKey:kYearFormat];
    [dictRegDetails setObject:strOrgTimeZone forKey:kOrgTimeZone];
    
    defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:DateFormat forKey:@"DATEFORMAT"];
    [defaults synchronize];
    parameters=[SCM registerationList:dictRegDetails];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Create New NOID User==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseRegisteration) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Create New NOID User==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Registeration) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedResisteration) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:Registration_Method_Name];
}
-(void)responseFailedResisteration
{
    [Common showAlert:@"NOID" withMessage:strResponseError];
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Title: Registeration Webservice Response
 Description : Validates and checks the response from the server for the registeration process
 Method Name : responseRegisteration(User Defined Method)
 ************************************************************************************* */
-(void)responseRegisteration
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            defaults=[NSUserDefaults standardUserDefaults];
            NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            if([dicitData count]>0){
                NSLog(@"DICT User Data ==%@",dicitData);
                NSLog(@"DIC User Data ==%lu",(unsigned long)dicitData.count);
                NSLog(@"account id ==%@",[dicitData valueForKey:@"accountId"]);
                NSLog(@"emailId id ==%@",[dicitData valueForKey:@"emailId"]);
                NSLog(@"firstName ==%@",[dicitData valueForKey:@"firstName"]);
                NSLog(@"netwrok count ==%@",[dicitData valueForKey:@"networkCount"]);
                [defaults setObject:[[dicitData valueForKey:@"accountId"] stringValue] forKey:@"ACCOUNTID"];
                [defaults setObject:[dicitData valueForKey:@"emailId"] forKey:@"MAILID"];
                [defaults setObject:@"0" forKey:@"NETWORKCOUNT"];
                [defaults setObject:@"YES" forKey:@"APPREMEMBERMESTATUS"];
                [defaults setObject:hashPWD forKey:@"PASSWORD"];
                [defaults synchronize];
                [self stop_PinWheel_Registeration];
                //                [Common showAlert:kAlertTitleSuccess withMessage:responseMessage];
                appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.strInitialView=@"RegisterUser";
                appDelegate.strController_Setup_Mode=@"AppLaunch";
                ControllerSetUpViewController *CSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
                CSVC.str_Cellular_FirstStatus=@"ControllerFirstTime";
                [Common viewFadeInSettings:self.navigationController.view];
                [self.navigationController pushViewController:CSVC animated:NO];
            }else{
                [self stop_PinWheel_Registeration];
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
            
        }else{
            [self stop_PinWheel_Registeration];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Registeration];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}


/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Title: Registeration Webservice
 Description : Signin the user in the server
 Method Name : login_Noid_UserService(User Defined Method)
 ************************************************************************************* */
-(void)login_Noid_UserService
{
    NSDictionary *parameters;
    hashPWD=[Common md5:txtfld_pswd_signIn.text];
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dictSignInDetails=[[NSMutableDictionary alloc] init];
    [dictSignInDetails setObject:txtfld_email_signIn.text forKey:kEmailID];
    [dictSignInDetails setObject:hashPWD forKey:kPassword];
    if(appDelegate.devicetoken_nsdatta==nil){
        deviceToken=@"CDF1c7bf338c5e9bab2ad2fca45ada646d600061c28cf79c90a";
    }else{
        deviceToken=[NSString stringWithFormat:@"%@",appDelegate.devicetoken_nsdatta];
        deviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    [dictSignInDetails setObject:deviceToken forKey:kDeviceToken];
    [dictSignInDetails setObject:@"1" forKey:kTokenType];
    defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:dictSignInDetails forKey:@"LOGIN"];
    [defaults synchronize];
    parameters=[SCM signinList:dictSignInDetails];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for SignIn NOID User==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseSignIn) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Create New NOID User==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Registeration) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorSignin) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:SignIn_Method_Name];
}

-(void)responseErrorSignin
{
    [Common showAlert:@"Warning" withMessage:strResponseError];
}
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Title: Registeration Webservice Response
 Description : Validates and checks the response from the server for the registeration process
 Method Name : responseRegisteration(User Defined Method)
 ************************************************************************************* */
-(void)responseSignIn
{
    NSLog(@"%@",responseDict);
    @try {
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        defaults=[NSUserDefaults standardUserDefaults];
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            if([dicitData count]>0){
                NSLog(@"DICT User Data ==%@",dicitData);
                NSLog(@"DIC User Data ==%lu",(unsigned long)dicitData.count);
                NSLog(@"account id ==%@",[dicitData valueForKey:@"accountId"]);
                NSLog(@"emailId id ==%@",[dicitData valueForKey:@"emailId"]);
                NSLog(@"firstName ==%@",[dicitData valueForKey:@"firstName"]);
                [defaults setObject:[[dicitData valueForKey:@"accountId"] stringValue] forKey:@"ACCOUNTID"];
                [defaults setObject:[dicitData valueForKey:@"emailId"] forKey:@"MAILID"];
                [defaults setObject:[dicitData valueForKey:@"dateFormat"] forKey:@"DATEFORMAT"];
                [defaults setObject:hashPWD forKey:@"PASSWORD"];
                [defaults synchronize];
                
           //     NSLog(@"netwrok count ==%@",[dicitData valueForKey:@"networkId"]);
//                NSArray *networkCount=[dicitData valueForKey:@"networkId"];
                NSArray *networkList = [dicitData valueForKey:@"networkList"];
                NSLog(@"%@",networkList);
                NSUInteger count=[networkList count];
                NSLog(@"netwrok count ==%lu",(unsigned long)count);
                [defaults setObject:[NSString stringWithFormat:@"%lu",(unsigned long)count] forKey:@"NETWORKCOUNT"];
                [defaults synchronize];
                
                    [defaults setObject:@"YES" forKey:@"APPREMEMBERMESTATUS"];
                    [defaults synchronize];
                
                    NSLog(@"netwrok count ==%lu",(unsigned long)count);
                [self stop_PinWheel_Registeration];
                
                if(count==0)  //if its Zero Go TO Controller Setup Screen
                {
                    appDelegate.strInitialView=@"RegisterUser";
                    appDelegate.strController_Setup_Mode=@"AppLaunch";
//                    appDelegate.strNoidLogo=@"";
                    ControllerSetUpViewController *CSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
                    CSVC.str_Cellular_FirstStatus=@"ControllerFirstTime";
                    [Common viewFadeInSettings:self.navigationController.view];
                    [self.navigationController pushViewController:CSVC animated:NO];
                }
                else if(count==1) //if its 1 means go to Network Home
                {
                    appDelegate.strInitialView=@"SignIn";
                    appDelegate.strController_Setup_Mode=@"AppLaunch";
                    strNetworkId = [[[networkList objectAtIndex:0] valueForKey:@"networkId"] stringValue];
                    NSLog(@"%@",strNetworkId);
                    NSString *strNetworkStatus = [[[networkList objectAtIndex:0] valueForKey:@"networkStatus"] stringValue];
                    NSLog(@"%@",strNetworkStatus);
                    
                    if ([strNetworkStatus isEqualToString:@"0"] || [strNetworkStatus isEqualToString:@"2"]) {
                        appDelegate.strNetworkPermission=[[[networkList objectAtIndex:0] valueForKey:@"accessTypeId"] stringValue];
                        if(![strNetworkStatus isEqualToString:@"0"])
                        {
                            appDelegate.strOwnerNetwork_Status=@"NO";
                        }else{
                            appDelegate.strOwnerNetwork_Status=@"YES";
                        }
                        if([Common reachabilityChanged]==YES){
                            [self performSelectorOnMainThread:@selector(start_PinWheel_Registeration) withObject:self waitUntilDone:YES];
                            [self performSelectorInBackground:@selector(networkDetails_Service) withObject:self];
                        }else{
                            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                        }
                    }else{
                        appDelegate.strInitialView=@"SignIn";
                        MultipleNetworkViewController *MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                        [Common viewFadeInSettings:self.navigationController.view];
                        [self.navigationController pushViewController:MNVC animated:NO];
                    }
                }
                else //if its more than 1 means go to Multiple network
                {
                    appDelegate.strInitialView=@"SignIn";
                    MultipleNetworkViewController *MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                    [Common viewFadeInSettings:self.navigationController.view];
                    [self.navigationController pushViewController:MNVC animated:NO];
                }
            }else{
                [self stop_PinWheel_Registeration];
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
            
        }else{
            if([responseMessage isEqualToString:@"Invalid Credentials."])
            {
                [self stop_PinWheel_Registeration];
                [Common showAlert:kAlertEmailWarningTitle withMessage:kAlertEmailWarningMessages];
            }
            else if([responseMessage isEqualToString:@"This Email-Id is not registered."]){
                [self stop_PinWheel_Registeration];
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
                [self email_Not_Register];
                return;
            }
            else{
                [self stop_PinWheel_Registeration];
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
            [self signIn_AttemptFailed];
            //[self.txtfld_pswd_signIn becomeFirstResponder];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Registeration];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
        [self signIn_AttemptFailed];
        // [self.txtfld_pswd_signIn becomeFirstResponder];
    }
}

-(void)networkDetails_Service
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"account id==%@",[defaults objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks?networkId=%@",[defaults objectForKey:@"ACCOUNTID"],strNetworkId];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Get network details ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseNetworkDetails) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for network details ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Registeration) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorSignin) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)responseNetworkDetails
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSMutableArray *arrNetwork_Data=[[NSMutableArray alloc] init];
           // arrNetwork_Data=[responseDict objectForKey:@"data"];
            arrNetwork_Data=[[responseDict objectForKey:@"data"] objectForKey:@"networkDetails"];
            strTimeZoneIDFor_User=[[responseDict valueForKey:@"data"] objectForKey:@"timeZoneId"];
            NSLog(@"array count ==%lu",(unsigned long)arrNetwork_Data.count);
            if([arrNetwork_Data count]>0)
            {
                [self naviagte_NetworkHome_MultipleNetwork:[arrNetwork_Data objectAtIndex:0]];
            }else{
                [self stop_PinWheel_Registeration];
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
        }else{
            [self stop_PinWheel_Registeration];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Registeration];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)naviagte_NetworkHome_MultipleNetwork:(NSDictionary *)dictNetworkDetails
{
    NSLog(@"%@",dictNetworkDetails);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.dict_NetworkControllerDatas = [[NSMutableDictionary alloc] init];
    [appDelegate.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"alert"] forKey:kAlertCount];
    [appDelegate.dict_NetworkControllerDatas setObject:[[dictNetworkDetails valueForKey:@"id"] stringValue] forKey:kNetworkID];
    [appDelegate.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"message"] forKey:kMessageCount];
    [appDelegate.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"latitude"] forKey:kLat];
    [appDelegate.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"longitude"] forKey:kLong];
    [appDelegate.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"name"] forKey:kNetworkName];
    [appDelegate.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"thumbnailImage"] forKey:kNetWrokImage];
    NSLog(@"network details==%@",appDelegate.dict_NetworkControllerDatas);
    [defaults setObject:[dictNetworkDetails valueForKey:@"id"] forKey:@"NETWORKID"];
    [defaults synchronize];
    NSDictionary *dictNetworkStatus=[dictNetworkDetails valueForKey:@"networkStatus"];
    NSArray *arrController=[dictNetworkStatus valueForKey:@"controller"];
    if(arrController.count>0)
    {
        
        NSDictionary *dictController=[arrController objectAtIndex:0];
        NSLog(@"controller id ==%@",[dictController valueForKey:@"id"]);
        NSDictionary *dictControllerTrace = [[dictController valueForKey:@"controllerTrace"] valueForKey:@"controllerConnectivityType"];
        NSLog(@"controllerConnectivityType is ==%@",dictControllerTrace);
        [appDelegate.dict_NetworkControllerDatas setObject:[dictControllerTrace valueForKey:@"typeCode"] forKey:kControllerType];
        //  [appDelegate.dict_NetworkControllerDatas setObject:[[dictControllerTrace valueForKey:@"id"] stringValue] forKey:kControllerID];
        [appDelegate.dict_NetworkControllerDatas setObject:[[dictController valueForKey:@"id"] stringValue] forKey:kControllerID];
        NSLog(@"controller type%@",[dictControllerTrace valueForKey:@"typeCode"]);
        NSLog(@"network details==%@",appDelegate.dict_NetworkControllerDatas);
        NSLog(@"controller Trace ID ==%@",[[dictController valueForKey:@"controllerTrace"] valueForKey:@"id"]);
        [defaults setObject:appDelegate.dict_NetworkControllerDatas forKey:@"NETWORKSINGLEDATAS"];
        [defaults synchronize];
        if ([[dictControllerTrace valueForKey:@"typeCode"] isEqualToString:@"WIFI"]) {
            [self stop_PinWheel_Registeration];
            SWRevealViewController *SWR = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
            SWR = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            NSArray *newStack = @[SWR];
            [self.navigationController setViewControllers:newStack animated:YES];
        }else{
            if([[dictNetworkStatus valueForKey:@"hasPaymentCompleted"] boolValue]&&[[dictNetworkStatus valueForKey:@"hasPaymentRenewed"] boolValue])
            {
                [self stop_PinWheel_Registeration];
                SWRevealViewController *SWR = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
                SWR = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                NSArray *newStack = @[SWR];
                [self.navigationController setViewControllers:newStack animated:YES];
            }
            else if([[dictNetworkStatus valueForKey:@"hasPaymentCompleted"] boolValue]&& ![[dictNetworkStatus valueForKey:@"hasPaymentRenewed"] boolValue])
            {
                [self stop_PinWheel_Registeration];
                appDelegate.strInitialView=@"SignIn";
                MultipleNetworkViewController *MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                [Common viewFadeInSettings:self.navigationController.view];
                [self.navigationController pushViewController:MNVC animated:NO];
            }
            else{
                NSLog(@"billing plan ==%@",[[dictController valueForKey:@"controllerTrace"] valueForKey:@"defaultBillingPlan"]);
                appDelegate.strController_Setup_Mode = @"NetworkHomeDrawer";
                CellularViewController *CVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CellularViewController"];
                CVC.str_MultipleNetwork_Mode=@"edit";
                NSMutableDictionary *dictPaymentDict=[[NSMutableDictionary alloc] init];
                if([[dictNetworkStatus valueForKey:@"hasControllerConnected"] boolValue])
                {
                    CVC.strController_ConnectedSTS=@"YES";
                    [dictPaymentDict setObject:@"YES" forKey:kControllerConnectedStatus];
                }
                else{
                    CVC.strController_ConnectedSTS=@"NO";
                    [dictPaymentDict setObject:@"NO" forKey:kControllerConnectedStatus];
                }
                if([[dictNetworkStatus valueForKey:@"hasPaymentCard"] boolValue])
                {
                    CVC.strController_PaymentCardSTS=@"YES";
                    [dictPaymentDict setObject:@"YES" forKey:kControllerPaymentCard];
                }
                else{
                    CVC.strController_PaymentCardSTS=@"NO";
                    [dictPaymentDict setObject:@"NO" forKey:kControllerPaymentCard];
                }
                if([[dictNetworkStatus valueForKey:@"hasPaymentCompleted"] boolValue])
                {
                    CVC.strController_PaymentCompletedSTS=@"YES";
                    [dictPaymentDict setObject:@"YES" forKey:kControllerPaymentCompleted];
                }
                else{
                    CVC.strController_PaymentCompletedSTS=@"NO";
                    [dictPaymentDict setObject:@"NO" forKey:kControllerPaymentCompleted];
                }
                [defaults setObject:dictPaymentDict forKey:@"NETWORKPAYMENTDATAS"];
                CVC.dictController_BasicPlan=[[dictController valueForKey:@"controllerTrace"] valueForKey:@"defaultBillingPlan"];
                CVC.strController_TraceID=[[[dictController valueForKey:@"controllerTrace"] valueForKey:@"id"] stringValue];
                CVC.strTimeZoneIDFor_User=strTimeZoneIDFor_User;
                [defaults setObject:[[dictController valueForKey:@"controllerTrace"] valueForKey:@"defaultBillingPlan"] forKey:@"CONTROLLERPLANDATA"];
                [defaults setObject:[[[dictController valueForKey:@"controllerTrace"] valueForKey:@"id"] stringValue] forKey:@"CONTROLLERTRACEIDDATA"];
                [defaults synchronize];
                [self stop_PinWheel_Registeration];
                [self.navigationController pushViewController:CVC animated:YES];
            }
        }
    }
    else{
        [self stop_PinWheel_Registeration];
        [Common showAlert:kAlertTitleWarning withMessage:@"Parser Error"];
    }
}

-(void)tc_Noid_UserService
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"account id==%@",[defaults objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=@"/terms_conditions";
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Get T and C details ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseTCDetails) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Get T and C details ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Registeration) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorSignin) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
-(void)responseTCDetails
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            txtView_TermsAndCond.text=[dicitData valueForKey:@"message"];
            [self stop_PinWheel_Registeration];
            [self.TCView setHidden:NO];
            [scrollView setAlpha:0.6];
            txtView_TermsAndCond.scrollsToTop = NO;
        }else{
            [self stop_PinWheel_Registeration];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Registeration];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)reset_Password_Webservice
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictResetPswd=[[NSMutableDictionary alloc] init];
    [dictResetPswd setObject:txtfld_forgotPswd.text forKey:kEmailID];
    
    parameters=[SCM resetPassword:dictResetPswd];
    NSLog(@"%@",parameters);
    NSString *strMethodNameWith_Value=@"/forgot_password";
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for reset password ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseResetPassword) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for reset password==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Registeration) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedResisteration) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodNameWith_Value];
}

-(void)responseResetPassword
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self stop_PinWheel_Registeration];
            strResetAlert=@"Reset";
            UIAlertView *alertForCall = [[UIAlertView alloc]initWithTitle:kAlertResetSuccessTitle message:kAlertResetSuccessMessage delegate:self cancelButtonTitle:@"Got it!" otherButtonTitles:nil, nil];
            [alertForCall show];
            
        }else{
            if([responseMessage isEqualToString:@"Incorrect Email Address"])
            {
                [self stop_PinWheel_Registeration];
                [Common showAlert:kAlertResetFailureTitle withMessage:kAlertResetFailureMessage];
            }
            else{
                [self stop_PinWheel_Registeration];
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Registeration];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)sendGridEmail_Noid_UserService
{
    NSLog(@"txt==%@",txtfld_emailTC.text);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictTC=[[NSMutableDictionary alloc] init];
    [dictTC setObject:txtfld_emailTC.text forKey:kEmailID];
    [dictTC setObject:@"terms_conditions" forKey:kEmailType];
    
    parameters=[SCM sendGridMailTC:dictTC];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for TC Send Grid==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseSendGridTC) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for TC Send Grid==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Registeration) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorSignin) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:TC_Method_Name];
}
-(void)responseSendGridTC
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self stop_PinWheel_Registeration];
    //        [Common showAlert:kAlertTitleSuccess withMessage:responseMessage];
        }else{
            [self stop_PinWheel_Registeration];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Registeration];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

#pragma mark - Orientation
/* **********************************************************************************
 Date : 23/06/2015
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
    return  UIInterfaceOrientationMaskPortrait;
//        return  UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown;
    //return here which orientation you are going to support
}

//-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//
//    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
//        NSLog(@"Landscape left");
//        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
//        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
//        [self.navigationController pushViewController:TLVC animated:NO];
//    }
//    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//
//        NSLog(@"Landscape right");
//        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
//        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
//        [self.navigationController pushViewController:TLVC animated:NO];
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
//
//    }
//}

@end

