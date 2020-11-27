//
//  CellularViewController.m
//  NOID
//
//  Created by iExemplar on 9/10/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "CellularViewController.h"
#import "MultipleNetworkViewController.h"
#import "NetworkHomeViewController.h"
#import "Common.h"
#import "SettingsViewController.h"
#import "TimeLineViewController.h"
#import "CreditCardValidation.h"
#import "Luhn.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "Base64.h"
#import "ServiceConnectorModel.h"
#import "DeviceSetUpViewController.h"
#import "SprinklerDeviceSetupViewController.h"
#import "ControllerSetUpViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kButtonIndex 1000

@interface CellularViewController ()
{
    UITapGestureRecognizer *tapGusters_Container,*tapGuster_Header;
    UISwipeGestureRecognizer *swipeDown_planoption,*swipeDown_planoption_View;
    NSMutableArray *arrBilling_New[kButtonIndex];
    UILabel *lblPlanHeader[kButtonIndex];
    UILabel *lblPlanHeaderRange[kButtonIndex];
}
@end

@implementation CellularViewController
@synthesize viewCellular_QR,viewCellular_QR_HeaderContent,scrollViewCellular,lblEdit_QR,strControllerStatus,viewBilling,viewBilling_BodyContent,viewBilling_HeaderContent,lblEdit_Billing,viewBilling_AddCardView,view_PaymentCard,keyboardControls_Cellular;
@synthesize btn_SwipeDown_Payment,scrollPayment,imgView_Payment_American,imgView_Payment_Discover,imgView_Payment_Mastro,imgView_Payment_Visa;
@synthesize txtfld_CardNo_UpdateCard,txtfld_digits_UpdateCard,txtfld_Month_UpdateCard,txtfld_Year_UpdateCard,txtfld_zipCode_UpdateCard,view_SwipeDown_Payment,btn_Cellular_Logo,btn_Settings_Cellular,viewCellular_Body,viewCellular_Header,current_textfield_Billing,txtfld_CardName_UpdateCard;
@synthesize viewBilling_ChargeCardView,viewChargeCardSmall,btn_TC,view_Billing_Cancel,view_Billing_Proceed,progressConnection,progressValue;
@synthesize viewConnection,viewConnection_BodyContent,viewConnection_HeaderContent,lblEdit_Connection,viewConnection_Progress_Succ_View,viewConnection_ProgressView;
@synthesize viewController,viewController_BodyContent,viewController_HeaderContent;
@synthesize viewController_ImageEdit,viewController_ImageGallery,viewController_CancelView,viewController_ProceedView,txtfld_DeviceName,lblEdit_Controller;
@synthesize imgView_Controller,view_Info_Popup,view_SwipeDown_Plan,viewPlan,btn_SwipeDown_Plan,lblController_Header;
@synthesize view_Info_TC,str_MultipleNetwork_Mode,lblController_Welcome,lblConnection_Index,lblContorller_Index,strPreviousView,lbl_deviceImgName_CellularController;
@synthesize lbl_Plan_Name_MainView,lbl_Plan_Controller_Name_MainView,lbl_Plan_Controller_Count_MainView,lbl_Plan_RenewalDate_MainView,lbl_Plan_Name_Detail_View,lbl_Plan_Controller_Cost_Detail_View,lbl_Plan_RenewalDate_Detail_View;
@synthesize lbl_CC_ExpiryDate,lbl_CC_Name,lbl_CC_Number,imgView_CC_Logo,dictController_BasicPlan,strController_TraceID;
@synthesize lbl_Billing_Index,scrollView_PlanCard,scrollView_Planoptions,view_deviceSetUp_Alert;
@synthesize strController_ConnectedSTS,strController_PaymentCardSTS,strController_PaymentCompletedSTS,viewConnection_SetupView,deleteNetworkView_Cellular,popUpDeleteView_Cellular,addCardView,TCemail_View,txtfld_emailTC,txtView_TermsAndCond,viewBilling_RenewalDate,btnInfo_billing,viewBilling_DefaultPlan,viewBilling_StarterPlan;
@synthesize btn_PencilCard,btn_PencilCardName,strCellularAccessType,viewAlert_PlanUpgrade,viewAlert_PlanUpgrade_Confirmation,lbl_PlanUpgrade_Charge,lbl_PlanUpgrade_Qute,btn_PlanCharge,imgViewCharge,strTimeZoneIDFor_User,viewCellular_QR_BodyContent,txtfld_DeviceId_SetUp;

#pragma mark - ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self flag_Setup_Cellular];
    [self cellular_Setup_UIConfiguration];
//    [self loadBasicPlan_Options];
    [self textfield_WidgetConfiguration_Cellular];
    [self scrollView_Configuration_Cellular];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    NSMutableArray *viewStackArr=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSLog(@"Stack count %lu",(unsigned long)[viewStackArr count]);
    NSLog(@"stack List == %@",viewStackArr);
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        NSLog(@"landscape");
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
    else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
        NSLog(@"portrait");
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - mark Textfield Delegates
/* **********************************************************************************
 Date : 14/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the textfield is selected.
 Method Name : textFieldShouldBeginEditing(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([strAlert_Type isEqualToString:@"Payment"]){
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
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the textfield is selected.
 Method Name : textFieldDidBeginEditing(Pre Defined Method)
 ************************************************************************************* */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    current_textfield_Billing = textField;
    [self.keyboardControls_Cellular setActiveField:textField];
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if(current_textfield_Billing==txtfld_CardNo_UpdateCard||current_textfield_Billing==txtfld_CardName_UpdateCard){
            self.scrollPayment.contentOffset = CGPointZero;
        }else if(current_textfield_Billing==txtfld_zipCode_UpdateCard){
            self.scrollPayment.contentOffset = CGPointMake(0, current_textfield_Billing.frame.origin.y+100);
        }else{
            self.scrollPayment.contentOffset = CGPointMake(0, current_textfield_Billing.frame.origin.y+100);
        }
        
    } completion:^(BOOL finished) {
    }];
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
    [self.scrollPayment setContentOffset:CGPointZero animated:YES];
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(BOOL)checkCardDigitsValidationCellular
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
-(BOOL)checkCardZipCodeValidationCellular
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
-(BOOL)checkCardMonthValidationCellular
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
-(BOOL)checkCardYearValidationCellular
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
-(BOOL)checkCardVaidationCellular
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

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the textfield is resgined.
 Method Name : textFieldDidEndEditing(Pre Defined Method)
 ************************************************************************************* */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
   /* if(current_textfield_Billing==txtfld_CardNo_UpdateCard){
        BOOL isValid = [self.txtfld_CardNo_UpdateCard.text isValidCreditCardNumber];
        NSLog(@"%@",[NSString stringWithFormat:@"The number you entered is %@!", isValid ? @"valid" : @"isn't valid"]);
        if(isValid)
        {
            if([strPaymentType isEqualToString:@"VISA"]){
                BOOL isValidDigits=[Common checkVISACardRegx:self.txtfld_CardNo_UpdateCard.text];
                if(isValidDigits){
                    cardNumber_Billing_Flag=YES;
                }else{
                    [Common showAlert:@"Invalid VISA Card Number" withMessage:@"Please Enter Valid VISA Card Number"];
                    cardNumber_Billing_Flag=NO;
                }
            }
            else if([strPaymentType isEqualToString:@"AMERICAN"]){
                BOOL isValidDigits=[Common checkAMERICANCardRegx:self.txtfld_CardNo_UpdateCard.text];
                if(isValidDigits){
                    cardNumber_Billing_Flag=YES;
                }else{
                    [Common showAlert:@"Invalid AMERICAN EXPRESS Card Number" withMessage:@"Please Enter Valid AMERICAN EXPRESS Card Number"];
                    cardNumber_Billing_Flag=NO;
                }
            }
            else if([strPaymentType isEqualToString:@"DISCOVER"]){
                BOOL isValidDigits=[Common checkDISCOVERCardRegx:self.txtfld_CardNo_UpdateCard.text];
                if(isValidDigits){
                    cardNumber_Billing_Flag=YES;
                }else{
                    [Common showAlert:@"Invalid DISCOVER Card Number" withMessage:@"Please Enter Valid DISCOVER Card Number"];
                    cardNumber_Billing_Flag=NO;
                }
            }
            else if([strPaymentType isEqualToString:@"MASTRO"]){
                BOOL isValidDigits=[Common checkMASTROCardRegx:self.txtfld_CardNo_UpdateCard.text];
                if(isValidDigits){
                    cardNumber_Billing_Flag=YES;
                }else{
                    [Common showAlert:@"Invalid MASTER Card Number" withMessage:@"Please Enter Valid MASTER Card Number"];
                    cardNumber_Billing_Flag=NO;
                }
            }
            else{
                cardNumber_Billing_Flag=NO;
                [Common showAlert:@"Invalid Card Number" withMessage:@"Please Enter Valid Card Number"];
            }
        }else{
            [Common showAlert:@"Invalid Card Number" withMessage:@"Please Enter Valid Card Number"];
            cardNumber_Billing_Flag=NO;
        }
    }
    else if(current_textfield_Billing==txtfld_digits_UpdateCard){
        BOOL isValidDigits=[Common checCardCSCRegx:self.txtfld_digits_UpdateCard.text];
        if(isValidDigits){
            cscDigits_Billing_Flag=YES;
        }else{
            [Common showAlert:@"Invalid Card CSC Digits" withMessage:@"Please Enter Valid CSC Digits"];
            cscDigits_Billing_Flag=NO;
        }
    }
    else if(current_textfield_Billing==txtfld_Month_UpdateCard){
        BOOL isValidDigits=[Common checCardMonthRegx:self.txtfld_Month_UpdateCard.text];
        if(isValidDigits){
            month_Billing_Flag=YES;
        }else{
            [Common showAlert:@"Invalid Expiry Date Month" withMessage:@"Please Enter Valid Month"];
            month_Billing_Flag=NO;
        }
    }
    else if(current_textfield_Billing==txtfld_Year_UpdateCard){
        NSLog(@"%@",txtfld_Year_UpdateCard.text);
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
    }
    else if(current_textfield_Billing==txtfld_zipCode_UpdateCard){
        BOOL isValidDigits=[Common checkZIPCODEregx:self.txtfld_zipCode_UpdateCard.text];
        if(isValidDigits){
//            [Common showAlert:@"woowwwwwwwwwww" withMessage:@"wowwwwwwwwww"];
            zipcode_Billing_Flag=YES;
        }else{
            [Common showAlert:@"Invalid ZipCode" withMessage:@"Please Enter Valid Zipcode"];
            zipcode_Billing_Flag=NO;
        }
    }
    else if(current_textfield_Billing==txtfld_CardName_UpdateCard){
        if(self.txtfld_CardName_UpdateCard.text.length>0){
            cardNumber_Billing_Flag=YES;
        }else{
            cardNumber_Billing_Flag=NO;
        }
    }
    
    else if(current_textfield_Billing==txtfld_CardName_UpdateCard){
        if(txtfld_CardName_UpdateCard.text.length==0){
            [Common showAlert:@"Warning" withMessage:@"Please enter the card holder name"];
        }
    } */
    
    if(current_textfield_Billing==txtfld_Month_UpdateCard){
        if(txtfld_Month_UpdateCard.text.length==1)
        {
            txtfld_Month_UpdateCard.text=[NSString stringWithFormat:@"0%@",txtfld_Month_UpdateCard.text];
        }
    }
}

//^((0[1-9])|(1[0-2]))\/(\d{4})$
// /^[0-9]{3,4}$/
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the character typed in textfield.
 Method Name : shouldChangeCharactersInRange(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"Characters Entered");
    int fieldLength=20;
    if ((range.location == 0 && [string isEqualToString:@" "]) || (range.location == 0 && [string isEqualToString:@"'"]))
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
        if([strPaymentType isEqualToString:@"VISA"] || [strPaymentType isEqualToString:@"MASTRO"] || [strPaymentType isEqualToString:@"DISCOVER"]){
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
    else if(current_textfield_Billing==txtfld_DeviceName){
        NSUInteger newLength = [txtfld_DeviceName.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_DEVICENAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldDigitsPWd));
    }
    
    return YES;
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the return button on the keyboard is clicked
 Method Name : textFieldShouldReturn(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.scrollPayment setContentOffset:CGPointZero animated:YES];
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
        txtfld_digits_UpdateCard.text=@"";
        txtfld_digits_UpdateCard.userInteractionEnabled=NO;
        txtfld_digits_UpdateCard.alpha=0.4;
    }else if(current_textfield_Billing==txtfld_DeviceName){
        txtfld_DeviceName.text=@"";
    }
    else{
        textField.text=@"";
    }
    return NO;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}
#pragma mark - User Defined Actions
-(void)flag_Setup_Cellular
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
    planExitStatus=@"";
    planRenewString=@"NO";
    self.view_deviceSetUp_Alert.hidden=YES;
    imageStatus=NO;
    // strController_Status=@"NO";
    self.viewBilling.userInteractionEnabled=NO;
    self.viewConnection.userInteractionEnabled=NO;
    strNetwork_Added_Status=@"";
    strEncoded_ControllerImage=@"";
    strPlanStatus=@"";
    strCreditCardID=@"";
    popUpDeleteView_Cellular.hidden=YES;
    deleteNetworkView_Cellular.hidden=YES;
    viewAlert_PlanUpgrade.hidden=YES;
    viewAlert_PlanUpgrade_Confirmation.hidden=YES;
    strprorationTime=@"";
    strControllerDelete=@"";
    strChargeMyCard=@"";
    txtfld_digits_UpdateCard.placeholder=@"";
}
-(void)PreviousNextButtons_Cellular
{
    NSArray *fields = @[txtfld_CardName_UpdateCard,txtfld_CardNo_UpdateCard,txtfld_Month_UpdateCard,txtfld_Year_UpdateCard,txtfld_digits_UpdateCard,txtfld_zipCode_UpdateCard];
    
    [self setKeyboardControls_Cellular:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls_Cellular setDelegate:self];
    
}

/*
 if (![[defaultsCellular objectForKey:@"NETWORKCOUNT"] isEqual:0]){
 */
/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : uiconfiguration setup with flag
 Method Name : controllet_Setup_UIConfiguration(User Defined Method)
 ************************************************************************************* */
-(void)cellular_Setup_UIConfiguration{
    NSLog(@"controller payment card Status ==%@",self.strController_PaymentCardSTS);
    NSLog(@"controller payment card Compelted Status ==%@",self.strController_PaymentCompletedSTS);
    NSLog(@"controller connected Status ==%@",self.strController_ConnectedSTS);
    defaultsCellular=[NSUserDefaults standardUserDefaults];
    self.view_Info_Popup.hidden=YES;
    self.view_Info_TC.hidden=YES;
    
    if([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]){
        self.lblController_Header.text=@"EDIT CELLULAR NOID HUB";
        self.lblController_Welcome.hidden=YES;
        
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            self.lblController_Header.frame=CGRectMake(self.lblController_Header.frame.origin.x, self.lblController_Header.frame.origin.y-47, self.lblController_Header.frame.size.width, self.lblController_Header.frame.size.height);
            self.viewCellular_Body.frame=CGRectMake(self.viewCellular_Body.frame.origin.x, self.viewCellular_Body.frame.origin.y-38, self.viewCellular_Body.frame.size.width,self.viewCellular_Body.frame.size.height+38);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            self.lblController_Header.frame=CGRectMake(self.lblController_Header.frame.origin.x, self.lblController_Header.frame.origin.y-63, self.lblController_Header.frame.size.width, self.lblController_Header.frame.size.height);
            self.viewCellular_Body.frame=CGRectMake(self.viewCellular_Body.frame.origin.x, self.viewCellular_Body.frame.origin.y-51, self.viewCellular_Body.frame.size.width,self.viewCellular_Body.frame.size.height+51);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            self.lblController_Header.frame=CGRectMake(self.lblController_Header.frame.origin.x, self.lblController_Header.frame.origin.y-60, self.lblController_Header.frame.size.width, self.lblController_Header.frame.size.height);
            self.viewCellular_Body.frame=CGRectMake(self.viewCellular_Body.frame.origin.x, self.viewCellular_Body.frame.origin.y-53, self.viewCellular_Body.frame.size.width,self.viewCellular_Body.frame.size.height+53);
        }
        
        //QRView Setup
        self.viewCellular_QR.hidden=YES;
        
        //controller setup
        
        if([self.strController_PaymentCardSTS isEqualToString:@"NO"]&&[self.strController_PaymentCompletedSTS isEqualToString:@"NO"])
        {
            self.lblContorller_Index.text=@"1";
            self.lbl_Billing_Index.text=@"2";
            self.lblConnection_Index.text=@"3";
            
            self.viewBilling.frame=CGRectMake(self.viewController.frame.origin.x,self.viewController.frame.origin.y+self.viewController.frame.size.height+14,self.viewController.frame.size.width, self.viewController.frame.size.height);
            self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x,self.viewBilling.frame.origin.y+self.viewBilling.frame.size.height+14,self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
            
            [self initial_Billing_Config];
            
        }
        //controller setup already billing enabled
        else
        {
            cellular_billing_ExpandedStatus=YES;
            self.viewBilling.hidden=YES;
            self.lblContorller_Index.text=@"1";
            self.lblConnection_Index.text=@"2";
            self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x,self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+14,self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
            lblEdit_Connection.hidden=NO;
        }
        
        self.deleteNetworkView_Cellular.frame = CGRectMake(self.deleteNetworkView_Cellular.frame.origin.x, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+20, self.deleteNetworkView_Cellular.frame.size.width, self.deleteNetworkView_Cellular.frame.size.height);
        
        deleteNetworkView_Cellular.hidden=NO;
        
        
        //Controller Setup
//        lblEdit_Controller.hidden=YES;
        cellular_ControllerStatus=YES;
        self.viewController_BodyContent.hidden=YES;
        self.viewController_ImageEdit.hidden=YES;
        
        [imgView_Controller.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [imgView_Controller.layer setBorderWidth:1.0];
        [self expand_Controller_Edit_View];
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        str_Added_ControllerID=[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID];
        NSLog(@"str_Added_ControllerID=%@",str_Added_ControllerID);

    }else{
        if (![[defaultsCellular objectForKey:@"NETWORKCOUNT"] isEqualToString:@"0"]){
            NSLog(@"from MP Nw");
            NSLog(@"Network Mode =%@",self.str_MultipleNetwork_Mode);
            self.lblController_Header.text=@"SET-UP CELLULAR NOID HUB";
        }
        
        //Controller Setup
        lblEdit_Controller.hidden=YES;
        cellular_ControllerStatus=YES;
        self.viewController_BodyContent.hidden=YES;
        self.viewController_ImageEdit.hidden=YES;
        
        [imgView_Controller.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [imgView_Controller.layer setBorderWidth:1.0];

        [self expand_Controller_View];
        lblEdit_Billing.hidden=YES;
        [self initial_Billing_Config];
        
    }
    if ([[Common deviceType] isEqualToString:@"iPhone5"]){
        transform = CGAffineTransformMakeScale(1.0f,12.0f);
    }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
        transform = CGAffineTransformMakeScale(1.0f,14.2f);
    }else{
        transform = CGAffineTransformMakeScale(1.0f,16.3f);
    }
    progressConnection.transform = transform;
    
    //Connection Setup
    cellular_Connection_ExpandedStatus=YES;
    self.viewConnection_BodyContent.hidden=YES;
    self.viewConnection_Progress_Succ_View.hidden=YES;
    self.viewConnection_SetupView.hidden=YES;
    self.TCemail_View.hidden=YES;
    self.viewCellular_QR_BodyContent.hidden=YES;
    cellular_QR_ExpandStatus=YES;
}

-(void)initial_Billing_Config
{
    //Billing Setup
    
    cellular_billing_ExpandedStatus=YES;
    self.viewBilling_BodyContent.hidden=YES;
    self.viewBilling_ChargeCardView.hidden=YES;
    self.view_Billing_Proceed.hidden=YES;
    self.view_Billing_Cancel.hidden=YES;
    lblEdit_Connection.hidden=YES;

    //PlanAlertSetup
    strPayment_Selected_Tap=@"VISA";
    strPayment_PreviousTap=@"VISA";
    UIBezierPath *maskPathPlan = [UIBezierPath bezierPathWithRoundedRect:view_PaymentCard.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(16.0, 16.0)];
    CAShapeLayer *maskLayerPlan = [[CAShapeLayer alloc] init];
    maskLayerPlan.frame = self.view.bounds;
    maskLayerPlan.path  = maskPathPlan.CGPath;
    view_PaymentCard.layer.mask = maskLayerPlan;
}

-(void)check_Cellular_WidgetDismissORNot{
    if([txtfld_DeviceName resignFirstResponder]){
        [txtfld_DeviceName resignFirstResponder];
    }else if ([txtfld_DeviceId_SetUp resignFirstResponder]){
        [txtfld_DeviceId_SetUp resignFirstResponder];
    }
}
-(void)scrollView_Configuration_Cellular
{
    scrollViewCellular.showsHorizontalScrollIndicator=NO;
    scrollViewCellular.scrollEnabled=YES;
    scrollViewCellular.userInteractionEnabled=YES;
    scrollViewCellular.delegate=self;
    scrollViewCellular.scrollsToTop=NO;
}
-(void)userInteraction_CellularBilling_Disabled{
    [btn_Settings_Cellular setUserInteractionEnabled:NO];
    [btn_Cellular_Logo setUserInteractionEnabled:NO];
    [scrollViewCellular setUserInteractionEnabled:NO];
}
-(void)setPlan_Payment_OptionGusters_Cellular{
    tapGusters_Container = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBodyCellular_Guster_Actions:)];
    [self.viewCellular_Body addGestureRecognizer:tapGusters_Container];
    tapGuster_Header = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewHeaderCellular_Guster_Actions:)];
    [self.viewCellular_Header addGestureRecognizer:tapGuster_Header];
}
-(void)viewBodyCellular_Guster_Actions:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"claling");
    [self hidePlanPaymentOptionView_Cellular];
}
-(void)viewHeaderCellular_Guster_Actions:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"claling");
    [self hidePlanPaymentOptionView_Cellular];
}
-(void)hidePlanPaymentOptionView_Cellular{
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.5];
    if([strAlert_Type isEqualToString:@"Plan"]){
        self.scrollView_PlanCard.frame  = CGRectMake(self.scrollView_PlanCard.frame.origin.x, 1500,self.scrollView_PlanCard.frame.size.width,self.scrollView_PlanCard.frame.size.height);
        scrollView_PlanCard.contentOffset = CGPointMake(0, 0);
        scrollView_Planoptions.contentOffset = CGPointMake(0, 0);
        [self removeGesture_PlanOption_Cellular];
    }else{
        self.scrollPayment.contentOffset = CGPointZero;
        self.view_PaymentCard.frame  = CGRectMake(self.view_PaymentCard.frame.origin.x, 1500,self.view_PaymentCard.frame.size.width,self.view_PaymentCard.frame.size.height);
        self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        if([strCredit_Card_Added_Status isEqualToString:@"YES"]){
            strPaymentType=str_SVD_PaymentType;
            txtfld_CardName_UpdateCard.text=str_SVD_CardName;
            txtfld_CardNo_UpdateCard.text=str_SVD_CardNumber;
            txtfld_Month_UpdateCard.text=str_SVD_Month;
            txtfld_Year_UpdateCard.text=str_SVD_Year;
            txtfld_digits_UpdateCard.text=str_SVD_CSC_Digits;
            txtfld_zipCode_UpdateCard.text=str_SVD_ZipCode;
            
            if([strPaymentType isEqualToString:@"VISA"]){
                imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_On"];
                imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_Off"];
                imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_Off"];
                imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_Off"];
            }
            else if([strPaymentType isEqualToString:@"MASTRO"]){
                imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_On"];
                imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_Off"];
                imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_Off"];
                imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_Off"];
            }
            else if([strPaymentType isEqualToString:@"DISCOVER"]){
                imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_On"];
                imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_Off"];
                imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_Off"];
                imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_Off"];
            }
            else if([strPaymentType isEqualToString:@"AMERICAN"]){
                imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_On"];
                imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_Off"];
                imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_Off"];
                imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_Off"];
            }
            cardNumber_Billing_Flag=YES;
            month_Billing_Flag=YES;
            year_Billing_Flag=YES;
            cscDigits_Billing_Flag=YES;
            zipcode_Billing_Flag=YES;
        }else{
            [self resetPaymentWidgets];
        }
    }
    [UIView commitAnimations];
    [self setUserInteraction_Settings_Enalbed_Cellular];
}
-(void)setUserInteraction_Settings_Enalbed_Cellular{
    if([strAlert_Type isEqualToString:@"Payment"]){
        if([current_textfield_Billing resignFirstResponder]){
            [current_textfield_Billing resignFirstResponder];
        }
    }
    [self.scrollPayment setContentOffset:CGPointZero animated:YES];
    [self.viewBilling_BodyContent removeGestureRecognizer:tapGusters_Container];
    [self.viewBilling_HeaderContent removeGestureRecognizer:tapGuster_Header];
    [btn_Cellular_Logo setUserInteractionEnabled:YES];
    [btn_Settings_Cellular setUserInteractionEnabled:YES];
    [scrollViewCellular setUserInteractionEnabled:YES];
    strAlert_Type=@"";
}
-(void)swipeGestureBilling_Cellular
{
    swipeDown_planoption = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe_planOption_Cellular:)];
    [swipeDown_planoption setDirection:UISwipeGestureRecognizerDirectionDown];
    
    swipeDown_planoption_View = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe_planOption_View_Cellular:)];
    [swipeDown_planoption_View setDirection:UISwipeGestureRecognizerDirectionDown];
    
    if([strAlert_Type isEqualToString:@"Plan"]){
        [btn_SwipeDown_Plan addGestureRecognizer:swipeDown_planoption];
        [view_SwipeDown_Plan addGestureRecognizer:swipeDown_planoption_View];
    }else{
        [btn_SwipeDown_Payment addGestureRecognizer:swipeDown_planoption];
        [view_SwipeDown_Payment addGestureRecognizer:swipeDown_planoption_View];
    }
    
}
- (void)handleSwipe_planOption_Cellular:(UISwipeGestureRecognizer *)swipe {
    [self hidePlanPaymentOptionView_Cellular];
    if([strAlert_Type isEqualToString:@"Plan"]){
        [self.btn_SwipeDown_Plan removeGestureRecognizer:swipeDown_planoption];
    }else{
        [self.btn_SwipeDown_Payment removeGestureRecognizer:swipeDown_planoption];
    }
    
}
- (void)handleSwipe_planOption_View_Cellular:(UISwipeGestureRecognizer *)swipe {
    [self hidePlanPaymentOptionView_Cellular];
    if([strAlert_Type isEqualToString:@"Plan"]){
        [self.view_SwipeDown_Plan removeGestureRecognizer:swipeDown_planoption];
    }else{
        [self.view_SwipeDown_Payment removeGestureRecognizer:swipeDown_planoption];
    }
    
}
-(void)textfield_WidgetConfiguration_Cellular
{
    strPaymentType=@"";
    txtfld_DeviceName.delegate=self;
    txtfld_emailTC.delegate=self;
    txtfld_DeviceName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [txtfld_DeviceName setValue:lblRGBA(0, 0, 0, 1) forKeyPath:@"_placeholderLabel.textColor"];
    
    txtfld_DeviceId_SetUp.delegate=self;
    txtfld_DeviceId_SetUp.clearButtonMode = UITextFieldViewModeWhileEditing;
    [txtfld_DeviceId_SetUp setValue:lblRGBA(0, 0, 0, 1) forKeyPath:@"_placeholderLabel.textColor"];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txtfld_DeviceId_SetUp.leftView = paddingView;
    txtfld_DeviceId_SetUp.leftViewMode = UITextFieldViewModeAlways;

    txtfld_CardNo_UpdateCard.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_CardName_UpdateCard.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtfld_zipCode_UpdateCard.clearButtonMode = UITextFieldViewModeWhileEditing;

    [txtfld_CardName_UpdateCard setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_CardNo_UpdateCard setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_Month_UpdateCard setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_Year_UpdateCard setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_zipCode_UpdateCard setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_digits_UpdateCard setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [txtfld_emailTC setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
}
-(void)popup_Cellular_Alpha_Disabled{
    self.viewCellular_Header.alpha=0.6;
    self.viewCellular_Body.alpha=0.6;
    self.scrollPayment.alpha=0.6;
}
-(void)popup_Cellular_Alpha_Enabled{
    self.viewCellular_Header.alpha=1.0;
    self.viewCellular_Body.alpha=1.0;
    self.scrollPayment.alpha=1.0;
}

-(void)loadBasicPlan_Options
{
    NSLog(@"timezoneid=%@",strTimeZoneIDFor_User);
    planRenewString=@"YES";
    NSLog(@"basic plan dict ==%@",self.dictController_BasicPlan);
    if(![strChargeMyCard isEqualToString:@"YES"]) //upgrade
    {
        Amount = fabs([[self.dictController_BasicPlan valueForKey:@"price"] floatValue]);
    }
    NSDictionary *dictPlan_Details=[self.dictController_BasicPlan valueForKey:@"plan"];
    lbl_Plan_Name_MainView.text=[dictPlan_Details valueForKey:@"name"];
    lbl_Plan_Name_Detail_View.text=[dictPlan_Details valueForKey:@"name"];
    lbl_Plan_Controller_Count_MainView.text=[NSString stringWithFormat:@"%@ - %@ NOIDS",[[dictPlan_Details valueForKey:@"minLimit"] stringValue],[[dictPlan_Details valueForKey:@"maxLimit"] stringValue]];
    lbl_Plan_Controller_Name_MainView.text=[[self.dictController_BasicPlan valueForKey:@"hub"] stringValue];
    NSTimeInterval date =[[NSString stringWithFormat:@"%@",[self.dictController_BasicPlan valueForKey:@"expiryDate"]] doubleValue];
    NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:date/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE d MMM YYYY"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:strTimeZoneIDFor_User]];
    NSString *timestamp = [dateFormatter stringFromDate:epochNSDate];
    NSLog(@"timestamp==%@",timestamp);
    [dateFormatter setDateFormat:[Common GetCurrentDateFormat]];
    timestamp = [dateFormatter stringFromDate:epochNSDate];
    NSLog(@"timestamp==%@",timestamp);
    lbl_Plan_Controller_Cost_Detail_View.text=[NSString stringWithFormat:@"$%.2f",Amount];
    lbl_Plan_RenewalDate_Detail_View.text = timestamp;
    if([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]){
        if([self.strController_PaymentCardSTS isEqualToString:@"NO"]&&[self.strController_PaymentCompletedSTS isEqualToString:@"NO"])
        {
            lbl_Plan_RenewalDate_MainView.text=[NSString stringWithFormat:@"%@: $%.2f",[dictPlan_Details valueForKey:@"name"],Amount];
            self.viewBilling_RenewalDate.hidden=YES;
            self.btnInfo_billing.frame=CGRectMake(self.btnInfo_billing.frame.origin.x, self.btnInfo_billing.frame.origin.y+5, self.btnInfo_billing.frame.size.width, self.btnInfo_billing.frame.size.height);
            self.viewBilling_DefaultPlan.frame=CGRectMake(self.viewBilling_DefaultPlan.frame.origin.x, self.btnInfo_billing.frame.origin.y+self.btnInfo_billing.frame.size.height+10, self.viewBilling_DefaultPlan.frame.size.width, self.viewBilling_DefaultPlan.frame.size.height);
            self.viewBilling_StarterPlan.frame=CGRectMake(self.viewBilling_StarterPlan.frame.origin.x, self.viewBilling_DefaultPlan.frame.origin.y+self.viewBilling_DefaultPlan.frame.size.height+15, self.viewBilling_StarterPlan.frame.size.width, self.viewBilling_StarterPlan.frame.size.height);
        }else{
            lbl_Plan_RenewalDate_MainView.text=[NSString stringWithFormat:@"%@: $%.2f/ RENEWAL DATE: %@",[dictPlan_Details valueForKey:@"name"],Amount,timestamp];
        }
    }
    else{
        if(hasPaymentCard)
        {
            lbl_Plan_RenewalDate_MainView.text=[NSString stringWithFormat:@"%@: $%.2f/ RENEWAL DATE: %@",[dictPlan_Details valueForKey:@"name"],Amount,timestamp];
            
        }else{
            lbl_Plan_RenewalDate_MainView.text=[NSString stringWithFormat:@"%@: $%.2f",[dictPlan_Details valueForKey:@"name"],Amount];
            self.viewBilling_RenewalDate.hidden=YES;
            self.btnInfo_billing.frame=CGRectMake(self.btnInfo_billing.frame.origin.x, self.btnInfo_billing.frame.origin.y+5, self.btnInfo_billing.frame.size.width, self.btnInfo_billing.frame.size.height);
            self.viewBilling_DefaultPlan.frame=CGRectMake(self.viewBilling_DefaultPlan.frame.origin.x, self.btnInfo_billing.frame.origin.y+self.btnInfo_billing.frame.size.height+10, self.viewBilling_DefaultPlan.frame.size.width, self.viewBilling_DefaultPlan.frame.size.height);
            self.viewBilling_StarterPlan.frame=CGRectMake(self.viewBilling_StarterPlan.frame.origin.x, self.viewBilling_DefaultPlan.frame.origin.y+self.viewBilling_DefaultPlan.frame.size.height+15, self.viewBilling_StarterPlan.frame.size.width, self.viewBilling_StarterPlan.frame.size.height);
        }
    }
}

-(void)resetProgressBar{
    progressValue = 0;
    progressConnection.progress = 0;
}
-(void)startProgressBar{
    progressValue = 0.0f;
    [self increaseProgressValue];
}
-(void)increaseProgressValue
{
    if ([strExpandFlagStatus isEqualToString:@"YES"]) {
        if(progressConnection.progress<1){
            progressValue = progressValue+0.1;
            progressConnection.progress = progressValue;
            [self performSelector:@selector(increaseProgressValue) withObject:self afterDelay:0.4];
        }else{
            [self completeProgressBar];
        }
    }
}
-(void)completeProgressBar{
    [self expand_Connection_Succ_View];
}
-(void)check_Cellular_TapAlreadyOpenedOrNot{
    if([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]){
        if(cellular_Connection_ExpandedStatus==NO){
            [self collapse_Connection_View];
        }else if(cellular_ControllerStatus==NO){
            [self collapse_Controller_View];
        }else if(cellular_billing_ExpandedStatus==NO){
            [self collapse_Billing_View];
        }
    }else{
        if(cellular_billing_ExpandedStatus==NO){
            [self collapse_Billing_View];
        }else if(cellular_Connection_ExpandedStatus==NO){
            [self collapse_Connection_View];
        }else if(cellular_ControllerStatus==NO){
            [self collapse_Controller_View];
        }else if (cellular_QR_ExpandStatus==NO){
            [self collapse_QR_View_Cellular];
        }
    }
}

-(void)expand_QR_View_Cellular
{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewCellular_QR.frame=CGRectMake(self.viewCellular_QR.frame.origin.x, self.viewCellular_QR.frame.origin.y, self.viewCellular_QR.frame.size.width, self.viewCellular_QR_BodyContent.frame.origin.y+self.viewCellular_QR_BodyContent.frame.size.height);
        self.viewController.frame=CGRectMake(self.viewController.frame.origin.x, self.viewCellular_QR.frame.origin.y+self.viewCellular_QR.frame.size.height+5, self.viewController.frame.size.width, self.viewController.frame.size.height);
        self.viewBilling.frame=CGRectMake(self.viewBilling.frame.origin.x, self.viewController.frame.origin.y+self.viewController.frame.size.height+5, self.viewBilling.frame.size.width, self.viewBilling.frame.size.height);
        self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewBilling.frame.origin.y+self.viewBilling.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
        lblEdit_QR.hidden=YES;
    } completion:^(BOOL finished) {
        self.viewCellular_QR_BodyContent.hidden=NO;
        cellular_QR_ExpandStatus=NO;
        self.view.userInteractionEnabled=YES;
        [self scrollCellularReSet_And_Changes];
    }];
}

-(void)collapse_QR_View_Cellular
{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewCellular_QR_BodyContent.hidden=YES;
        self.viewCellular_QR.frame=CGRectMake(self.viewCellular_QR.frame.origin.x, self.viewCellular_QR.frame.origin.y, self.viewCellular_QR.frame.size.width, self.viewCellular_QR_HeaderContent.frame.size.height);
        self.viewController.frame=CGRectMake(self.viewController.frame.origin.x, self.viewCellular_QR.frame.origin.y+self.viewCellular_QR.frame.size.height+5, self.viewController.frame.size.width, self.viewController.frame.size.height);
        self.viewBilling.frame=CGRectMake(self.viewBilling.frame.origin.x, self.viewController.frame.origin.y+self.viewController.frame.size.height+5, self.viewBilling.frame.size.width, self.viewBilling.frame.size.height);
        self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewBilling.frame.origin.y+self.viewBilling.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
    } completion:^(BOOL finished) {
        lblEdit_QR.hidden=NO;
        cellular_QR_ExpandStatus=YES;
        self.view.userInteractionEnabled=YES;
        [self scrollCellularReSet_And_Changes];
    }];
}

-(void)expand_Billing_View{
    self.view.userInteractionEnabled=NO;
    if(![planRenewString isEqualToString:@"YES"])
    {
        [self loadBasicPlan_Options];
    }
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewBilling.frame=CGRectMake(self.viewBilling.frame.origin.x, self.viewBilling.frame.origin.y, self.viewBilling.frame.size.width, self.viewBilling_BodyContent.frame.origin.y+self.viewBilling_BodyContent.frame.size.height);
        self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewBilling.frame.origin.y+self.viewBilling.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Cellular.frame = CGRectMake(self.deleteNetworkView_Cellular.frame.origin.x, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+20, self.deleteNetworkView_Cellular.frame.size.width, self.deleteNetworkView_Cellular.frame.size.height);
        }
        lblEdit_Billing.hidden=YES;
    } completion:^(BOOL finished) {
        self.viewBilling_BodyContent.hidden=NO;
        cellular_billing_ExpandedStatus=NO;
        self.view.userInteractionEnabled=YES;
        [self scrollCellularReSet_And_Changes];
    }];
    if(hasPaymentCard)
    {
        addCardView.userInteractionEnabled = NO;
        viewConnection.userInteractionEnabled = YES;
        addCardView.alpha = 0.6;
    }
}
-(void)expand_Controller_View{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewController.frame=CGRectMake(self.viewController.frame.origin.x, self.viewController.frame.origin.y, self.viewController.frame.size.width, self.viewController_BodyContent.frame.origin.y+self.viewController_BodyContent.frame.size.height+5);
        if([self.strController_PaymentCardSTS isEqualToString:@"NO"] && [self.strController_PaymentCompletedSTS isEqualToString:@"NO"])
        {
            self.viewBilling.frame=CGRectMake(self.viewBilling.frame.origin.x, self.viewController.frame.origin.y+self.viewController.frame.size.height+5, self.viewBilling.frame.size.width,self.viewBilling.frame.size.height);
            self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewBilling.frame.origin.y+self.viewBilling.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
        }else{
            self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewController.frame.origin.y+self.viewController.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
        }
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Cellular.frame = CGRectMake(self.deleteNetworkView_Cellular.frame.origin.x, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+20, self.deleteNetworkView_Cellular.frame.size.width, self.deleteNetworkView_Cellular.frame.size.height);
        }
        lblEdit_Controller.hidden=YES;
    } completion:^(BOOL finished) {
        self.viewController_BodyContent.hidden=NO;
        cellular_ControllerStatus=NO;
        [self scrollCellularReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
    }];
}

-(void)expand_Controller_Edit_View
{
    @try {
        strNetwork_Added_Status=@"YES";
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSLog(@"Network Data == %@",appDelegate.dict_NetworkControllerDatas);
        //  networkData_Dict=appDelegate.dicit_NetworkDatas;
        txtfld_DeviceName.text=[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkName];
        NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
        
        if([appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage] == [NSNull null]){
            [self expand_Controller_View];
            strEncoded_ControllerImage=@"";
        }
        else if([[appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage] isEqualToString:@""]){
            [self expand_Controller_View];
            strEncoded_ControllerImage=@"";
        }
        else{
            [self editImageGallerySetupCellular];
            dispatch_async(kBgQueue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgView_Controller.image = [UIImage imageWithData:[Base64 decode:[appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage]]];
                    strEncoded_ControllerImage = [appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage];
                });
            });
        }
        if([self.strController_PaymentCardSTS isEqualToString:@"NO"]&&[self.strController_PaymentCompletedSTS isEqualToString:@"NO"])
        {
            self.viewBilling.userInteractionEnabled=YES;
        }else
        {
            self.viewConnection.userInteractionEnabled=YES;
        }
        //self.viewBilling.userInteractionEnabled=YES;
        [self stop_PinWheel_Cellular];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)expand_Connection_View{
    self.view.userInteractionEnabled=NO;
    strExpandFlagStatus=@"YES";
    [self resetProgressBar];
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x,self.viewConnection.frame.origin.y, self.viewConnection.frame.size.width, self.viewConnection_BodyContent.frame.origin.y+self.viewConnection_BodyContent.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Cellular.frame = CGRectMake(self.deleteNetworkView_Cellular.frame.origin.x, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+20, self.deleteNetworkView_Cellular.frame.size.width, self.deleteNetworkView_Cellular.frame.size.height);
        }
        lblEdit_Connection.hidden=YES;
        [self startProgressBar];
    } completion:^(BOOL finished) {
        self.viewConnection_BodyContent.hidden=NO;
        cellular_Connection_ExpandedStatus=NO;
        self.view.userInteractionEnabled=YES;
        [self scrollCellularReSet_And_Changes];
    }];
}
-(void)expand_Billing_ChargeCardView{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewBilling_BodyContent.frame=CGRectMake(self.viewBilling_BodyContent.frame.origin.x, self.viewBilling_BodyContent.frame.origin.y, self.viewBilling_BodyContent.frame.size.width, self.viewBilling_ChargeCardView.frame.origin.y+self.viewBilling_ChargeCardView.frame.size.height);
        self.viewBilling.frame=CGRectMake(self.viewBilling.frame.origin.x, self.viewBilling.frame.origin.y, self.viewBilling.frame.size.width, self.viewBilling_BodyContent.frame.origin.y+self.viewBilling_BodyContent.frame.size.height);
        self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewBilling.frame.origin.y+self.viewBilling.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Cellular.frame = CGRectMake(self.deleteNetworkView_Cellular.frame.origin.x, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+20, self.deleteNetworkView_Cellular.frame.size.width, self.deleteNetworkView_Cellular.frame.size.height);
        }
    } completion:^(BOOL finished) {
//        [self setBillingCardsWidgets];
        self.viewBilling_ChargeCardView.hidden=NO;
        self.view.userInteractionEnabled=YES;
        [self scrollCellularReSet_And_Changes];
    }];
}

-(void)expand_Connection_Succ_View{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewConnection_BodyContent.frame=CGRectMake(self.viewConnection_BodyContent.frame.origin.x, self.viewConnection_BodyContent.frame.origin.y, self.viewConnection_BodyContent.frame.size.width, self.viewConnection_Progress_Succ_View.frame.origin.y+self.viewConnection_Progress_Succ_View.frame.size.height);
        self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewConnection.frame.origin.y, self.viewConnection.frame.size.width, self.viewConnection_BodyContent.frame.origin.y+self.viewConnection_BodyContent.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Cellular.frame = CGRectMake(self.deleteNetworkView_Cellular.frame.origin.x, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+20, self.deleteNetworkView_Cellular.frame.size.width, self.deleteNetworkView_Cellular.frame.size.height);
        }
//        self.viewController.frame=CGRectMake(self.viewController.frame.origin.x,self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+5,self.viewController.frame.size.width, self.viewController.frame.size.height);
    } completion:^(BOOL finished) {
        [self setConnectionWidgets];
        self.view.userInteractionEnabled=YES;
        [self scrollCellularReSet_And_Changes];
    }];
}
-(void)collapse_Billing_ChargeCardView{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewBilling_ChargeCardView.hidden=YES;
        self.viewBilling_BodyContent.frame=CGRectMake(self.viewBilling_BodyContent.frame.origin.x,self.viewBilling_BodyContent.frame.origin.y,self.viewBilling_BodyContent.frame.size.width,self.viewBilling_AddCardView.frame.origin.y+self.viewBilling_AddCardView.frame.size.height);
        self.viewBilling.frame=CGRectMake(self.viewBilling.frame.origin.x, self.viewBilling.frame.origin.y, self.viewBilling.frame.size.width, self.viewBilling_BodyContent.frame.origin.y+self.viewBilling_BodyContent.frame.size.height);
        self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewBilling.frame.origin.y+self.viewBilling.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Cellular.frame = CGRectMake(self.deleteNetworkView_Cellular.frame.origin.x, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+20, self.deleteNetworkView_Cellular.frame.size.width, self.deleteNetworkView_Cellular.frame.size.height);
        }
    } completion:^(BOOL finished) {
        [self resetPaymentWidgets];
        [self setBillingCardsWidgets];
        self.view.userInteractionEnabled=YES;
        [self scrollCellularReSet_And_Changes];
    }];
}

-(void)resetPaymentWidgets
{
    strCredit_Card_Added_Status=@"";
    txtfld_CardName_UpdateCard.text=@"";
    txtfld_CardNo_UpdateCard.text=@"";
    txtfld_digits_UpdateCard.text=@"";
    txtfld_digits_UpdateCard.placeholder=@"";
    txtfld_Year_UpdateCard.text=@"";
    txtfld_Month_UpdateCard.text=@"";
    txtfld_zipCode_UpdateCard.text=@"";
    txtfld_CardNo_UpdateCard.rightView = nil;
    strPaymentType=@"";
    imgView_Payment_Visa.image=[UIImage imageNamed:@"pay_visa_Off"];
    imgView_Payment_Mastro.image=[UIImage imageNamed:@"pay_mastro_Off"];
    imgView_Payment_American.image=[UIImage imageNamed:@"pay_american_Off"];
    imgView_Payment_Discover.image=[UIImage imageNamed:@"pay_discover_Off"];
    cardNumber_Billing_Flag=NO;
    month_Billing_Flag=NO;
    year_Billing_Flag=NO;
    cscDigits_Billing_Flag=NO;
    zipcode_Billing_Flag=NO;
//    txtfld_digits_UpdateCard.placeholder = @"CSC(3-4DIGITS)";
}

-(void)scrollCellularReSet_And_Changes{
    if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
        self.scrollViewCellular.contentSize=CGSizeMake(self.scrollViewCellular.frame.size.width, self.deleteNetworkView_Cellular.frame.origin.y+self.deleteNetworkView_Cellular.frame.size.height+10);
    }else{
        if(cellular_Connection_ExpandedStatus==YES){
            self.scrollViewCellular.contentSize=CGSizeMake(self.scrollViewCellular.frame.size.width, self.viewConnection.frame.origin.y+self.viewConnection_HeaderContent.frame.size.height+10);
        }else{
            self.scrollViewCellular.contentSize=CGSizeMake(self.scrollViewCellular.frame.size.width, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+10);
        }
    }
}

-(void)setBillingCardsWidgets{
    self.viewChargeCardSmall.hidden=NO;
    self.btn_TC.hidden=NO;
    self.view_Billing_Proceed.hidden=YES;
    self.view_Billing_Cancel.hidden=YES;
}
-(void)resetControllerGallary{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewController_ImageEdit.hidden=YES;
        self.viewController_ImageGallery.hidden=NO;
        self.imgView_Controller.image=nil;
        self.viewController_ProceedView.frame=CGRectMake(self.viewController_ProceedView.frame.origin.x, self.viewController_ImageGallery.frame.origin.y+self.viewController_ImageGallery.frame.size.height+5,self.viewController_ProceedView.frame.size.width, self.viewController_ProceedView.frame.size.height);
        self.viewController_CancelView.frame=CGRectMake(self.viewController_CancelView.frame.origin.x, self.viewController_ImageGallery.frame.origin.y+self.viewController_ImageGallery.frame.size.height+5,self.viewController_CancelView.frame.size.width, self.viewController_CancelView.frame.size.height);
        self.viewController_BodyContent.frame=CGRectMake(self.viewController_BodyContent.frame.origin.x,self.viewController_BodyContent.frame.origin.y,self.viewController_BodyContent.frame.size.width,self.viewController_ProceedView.frame.origin.y+self.viewController_ProceedView.frame.size.height+10);
        self.viewController.frame=CGRectMake(self.viewController.frame.origin.x, self.viewController.frame.origin.y, self.viewController.frame.size.width, self.viewController_BodyContent.frame.origin.y+self.viewController_BodyContent.frame.size.height);
        
        if([self.strController_PaymentCardSTS isEqualToString:@"NO"]&&[self.strController_PaymentCompletedSTS isEqualToString:@"NO"])
        {
            self.viewBilling.frame=CGRectMake(self.viewBilling.frame.origin.x, self.viewController.frame.origin.y+self.viewController.frame.size.height+5, self.viewBilling.frame.size.width,self.viewBilling.frame.size.height);
            self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewBilling.frame.origin.y+self.viewBilling.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
        }else{
            self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewController.frame.origin.y+self.viewController.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
        }
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Cellular.frame = CGRectMake(self.deleteNetworkView_Cellular.frame.origin.x, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+20, self.deleteNetworkView_Cellular.frame.size.width, self.deleteNetworkView_Cellular.frame.size.height);
        }
    } completion:^(BOOL finished) {
        [self scrollCellularReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
    }];
}
-(void)setConnectionWidgets{
    self.viewConnection_ProgressView.hidden=YES;
    self.viewConnection_Progress_Succ_View.hidden=NO;
}
-(void)resetsetConnectionWidgets{
    self.viewConnection_ProgressView.hidden=NO;
    self.viewConnection_Progress_Succ_View.hidden=YES;
}
-(void)resetsetControlerWidgets{
    if(imageStatus==YES){
        self.viewController_ImageGallery.hidden=YES;
        self.viewController_ImageEdit.hidden=NO;
    }else{
        self.viewController_ImageGallery.hidden=NO;
        self.viewController_ImageEdit.hidden=YES;
    }
    
    //self.txtfld_DeviceName.text=@"";
}
-(void)collapse_Billing_View{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if([strCredit_Card_Added_Status isEqualToString:@"YES"]){
            self.viewBilling_BodyContent.frame=CGRectMake(self.viewBilling_BodyContent.frame.origin.x, self.viewBilling_BodyContent.frame.origin.y, self.viewBilling_BodyContent.frame.size.width, self.viewBilling_ChargeCardView.frame.origin.y+self.viewBilling_ChargeCardView.frame.size.height);
            self.viewBilling.frame=CGRectMake(self.viewBilling.frame.origin.x, self.viewBilling.frame.origin.y, self.viewBilling.frame.size.width, self.viewBilling_BodyContent.frame.origin.y+self.viewBilling_BodyContent.frame.size.height);
            //self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewBilling.frame.origin.y+self.viewBilling.frame.size.height+14, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
        }else{
            //[self setBillingCardsWidgets];
            self.viewBilling_ChargeCardView.hidden=YES;
            self.viewBilling_BodyContent.frame=CGRectMake(self.viewBilling_BodyContent.frame.origin.x,self.viewBilling_BodyContent.frame.origin.y,self.viewBilling_BodyContent.frame.size.width,self.viewBilling_AddCardView.frame.origin.y+self.viewBilling_AddCardView.frame.size.height);
            self.viewBilling.frame=CGRectMake(self.viewBilling.frame.origin.x, self.viewBilling.frame.origin.y, self.viewBilling.frame.size.width, self.viewBilling_BodyContent.frame.origin.y+self.viewBilling_BodyContent.frame.size.height);
        }
        self.viewBilling.frame=CGRectMake(self.viewBilling.frame.origin.x, self.viewBilling.frame.origin.y, self.viewBilling.frame.size.width, self.viewBilling_HeaderContent.frame.size.height);
        self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewBilling.frame.origin.y+self.viewBilling.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
        self.viewBilling_BodyContent.hidden=YES;
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Cellular.frame = CGRectMake(self.deleteNetworkView_Cellular.frame.origin.x, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+20, self.deleteNetworkView_Cellular.frame.size.width, self.deleteNetworkView_Cellular.frame.size.height);
        }
    } completion:^(BOOL finished) {
        cellular_billing_ExpandedStatus=YES;
        lblEdit_Billing.hidden=NO;
        self.view.userInteractionEnabled=YES;
        [self scrollCellularReSet_And_Changes];
    }];
}
-(void)collapse_Controller_View{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if(imageStatus==YES){
            self.viewController_ProceedView.frame=CGRectMake(self.viewController_ProceedView.frame.origin.x, self.viewController_ImageEdit.frame.origin.y+self.viewController_ImageEdit.frame.size.height+5,self.viewController_ProceedView.frame.size.width, self.viewController_ProceedView.frame.size.height);
            self.viewController_CancelView.frame=CGRectMake(self.viewController_CancelView.frame.origin.x, self.viewController_ImageEdit.frame.origin.y+self.viewController_ImageEdit.frame.size.height+5,self.viewController_CancelView.frame.size.width, self.viewController_CancelView.frame.size.height);
        }else{
            self.viewController_ProceedView.frame=CGRectMake(self.viewController_ProceedView.frame.origin.x, self.viewController_ImageGallery.frame.origin.y+self.viewController_ImageGallery.frame.size.height+5,self.viewController_ProceedView.frame.size.width, self.viewController_ProceedView.frame.size.height);
            self.viewController_CancelView.frame=CGRectMake(self.viewController_CancelView.frame.origin.x, self.viewController_ImageGallery.frame.origin.y+self.viewController_ImageGallery.frame.size.height+5,self.viewController_CancelView.frame.size.width, self.viewController_CancelView.frame.size.height);
        }
        
        self.viewController_BodyContent.frame=CGRectMake(self.viewController_BodyContent.frame.origin.x, self.viewController_BodyContent.frame.origin.y, self.viewController_BodyContent.frame.size.width,self.viewController_ProceedView.frame.origin.y+self.viewController_ProceedView.frame.size.height);
        self.viewController.frame=CGRectMake(self.viewController.frame.origin.x, self.viewController.frame.origin.y, self.viewController.frame.size.width, self.viewController_BodyContent.frame.origin.y+self.viewController_BodyContent.frame.size.height);
        self.viewController_BodyContent.hidden=YES;
        self.viewController.frame=CGRectMake(self.viewController.frame.origin.x,self.viewController.frame.origin.y, self.viewController.frame.size.width, self.viewController_HeaderContent.frame.size.height);
        if([self.strController_PaymentCardSTS isEqualToString:@"NO"]&&[self.strController_PaymentCompletedSTS isEqualToString:@"NO"])
        {
            self.viewBilling.frame=CGRectMake(self.viewBilling.frame.origin.x, self.viewController.frame.origin.y+self.viewController.frame.size.height+5, self.viewBilling.frame.size.width, self.viewBilling.frame.size.height);
            self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewBilling.frame.origin.y+self.viewBilling.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
        }else{
            self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewController.frame.origin.y+self.viewController.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
        }
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Cellular.frame = CGRectMake(self.deleteNetworkView_Cellular.frame.origin.x, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+20, self.deleteNetworkView_Cellular.frame.size.width, self.deleteNetworkView_Cellular.frame.size.height);
        }
    } completion:^(BOOL finished) {
        cellular_ControllerStatus=YES;
        lblEdit_Controller.hidden=NO;
        [self resetsetControlerWidgets];
        self.view.userInteractionEnabled=YES;
        [self scrollCellularReSet_And_Changes];
        
    }];
}
-(void)collapse_Connection_View{
    self.view.userInteractionEnabled=NO;
    if(self.viewConnection_SetupView.hidden==NO)
    {
        self.viewConnection_SetupView.hidden=YES;
    }
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewConnection_BodyContent.hidden=YES;
        self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x,self.viewConnection.frame.origin.y, self.viewConnection.frame.size.width, self.viewConnection_HeaderContent.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Cellular.frame = CGRectMake(self.deleteNetworkView_Cellular.frame.origin.x, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+20, self.deleteNetworkView_Cellular.frame.size.width, self.deleteNetworkView_Cellular.frame.size.height);
        }
    } completion:^(BOOL finished) {
        [self resetProgressBar];
        cellular_Connection_ExpandedStatus=YES;
        lblEdit_Connection.hidden=NO;
        [self resetsetConnectionWidgets];
        self.view.userInteractionEnabled=YES;
        [self scrollCellularReSet_And_Changes];
    }];
}

-(void)chnage_SetupConnection_View
{
    self.view.userInteractionEnabled=NO;
    self.viewConnection_Progress_Succ_View.hidden=YES;
    self.viewConnection_SetupView.hidden=NO;
    // [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    self.viewConnection_BodyContent.frame=CGRectMake(self.viewConnection_BodyContent.frame.origin.x, self.viewConnection_BodyContent.frame.origin.y, self.viewConnection_BodyContent.frame.size.width, self.viewConnection_SetupView.frame.origin.y+self.viewConnection_SetupView.frame.size.height);
    self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewConnection.frame.origin.y, self.viewConnection.frame.size.width, self.viewConnection_BodyContent.frame.origin.y+self.viewConnection_BodyContent.frame.size.height);
    if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
        self.deleteNetworkView_Cellular.frame = CGRectMake(self.deleteNetworkView_Cellular.frame.origin.x, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+20, self.deleteNetworkView_Cellular.frame.size.width, self.deleteNetworkView_Cellular.frame.size.height);
    }
    // self.viewController.frame=CGRectMake(self.viewController.frame.origin.x,self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+14,self.viewController.frame.size.width, self.viewController.frame.size.height);
    // } completion:^(BOOL finished) {
    // [self setConnectionWidgets];
    self.view.userInteractionEnabled=YES;
    [self scrollCellularReSet_And_Changes];
    // }];
}

-(void)planCardScrollSetup
{
    scrollView_PlanCard .showsHorizontalScrollIndicator=NO;
    scrollView_PlanCard.showsVerticalScrollIndicator=NO;
    scrollView_PlanCard.scrollEnabled=YES;
    scrollView_PlanCard.userInteractionEnabled=YES;
    scrollView_PlanCard.delegate=self;
    scrollView_PlanCard.scrollsToTop=NO;
}
-(void)planCardOptionScrollSetup{
    scrollView_Planoptions .showsHorizontalScrollIndicator=NO;
    scrollView_Planoptions.showsVerticalScrollIndicator=NO;
    scrollView_Planoptions.scrollEnabled=YES;
    scrollView_Planoptions.userInteractionEnabled=YES;
    scrollView_Planoptions.delegate=self;
    scrollView_Planoptions.scrollsToTop=NO;
}

-(void)set_PlanOption_Gesture_Cellular
{
    tapScrollCellular = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapScroll_Cellular_Actions:)];
    [scrollView_PlanCard addGestureRecognizer:tapScrollCellular];
    
    tapPlanOptionCellular = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapPlan_Cellular_Actions:)];
    [viewPlan addGestureRecognizer:tapPlanOptionCellular];
}

-(void)ViewTapScroll_Cellular_Actions:(UITapGestureRecognizer *)recognizer
{
    [self hidePlanPaymentOptionView_Cellular];
}

-(void)ViewTapPlan_Cellular_Actions:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"view touch");
}

-(void)removeGesture_PlanOption_Cellular
{
    [scrollView_PlanCard removeGestureRecognizer:tapScrollCellular];
    [viewPlan removeGestureRecognizer:tapPlanOptionCellular];
}

-(void)hide_DeviceSetup_Cellular
{
    view_deviceSetUp_Alert.hidden=YES;
    [viewCellular_Header setAlpha:1.0];
    [viewCellular_Body setAlpha:1.0];
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
    return strEmailVal_status;
}

#pragma mark - Orientation
/* **********************************************************************************
 Date : 16/07/2015
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
}
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        NSLog(@"Landscape left");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        TLVC.strNoidLogo_Status=@"";
        [self.navigationController pushViewController:TLVC animated:NO];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        NSLog(@"Landscape right");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        TLVC.strNoidLogo_Status=@"";
        [self.navigationController pushViewController:TLVC animated:NO];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        
    }
}
/*
 if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
 UIImage *img =  [info objectForKey:UIImagePickerControllerEditedImage];
 UIImageWriteToSavedPhotosAlbum(img, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
 // img = [Common imageWithImage:img scaledToSize:CGSizeMake(52, 52)]; //257 52
 CGSize imgScalling = [Common imageScalling:img withScalingDetails:257 and:52];
 img = [Common imageWithImage:img scaledToSize:imgScalling];
 image_MobeCard.image=img;
 strAlertStatus=@"image";
 changed_Status_MobeCard=YES;
 image_Status_MC = YES;
 [btn_browse_MobeCard setTitle:@"Change" forState:UIControlStateNormal];
 [self removeButtonSetupEnableMC];
 
 */

#pragma mark - Image Picker Delegtes
/* **********************************************************************************
 Date : 19/08/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Image Saved To Album
 Description : after capture Image/Video its saved to album
 Method Name : hasBeenSavedInPhotoAlbumWithError (Media Picker Delegate Method)
 ************************************************************************************* */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImage *img =  [info objectForKey:UIImagePickerControllerEditedImage];
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
            
            //anitha code
//            UIImage *newImage=img;
//            NSData *imageData1 = UIImageJPEGRepresentation(newImage, 1);
//            NSLog(@"Size of image = %lu KB",(imageData1.length/1024));
//            CGSize size=CGSizeMake(newImage.size.width/8,newImage.size.height/8);
//            newImage=[self resizeImageCellular:newImage newSize:size];
//            NSData *imageData = UIImageJPEGRepresentation(newImage, 0.05);
//            NSLog(@"Size of image = %lu KB",(imageData.length/1024));
//            imgView_Controller.image=newImage;
            
            CGSize imgScalling;
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgScalling = [Common imageScalling:img withScalingDetails:96 and:60];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgScalling = [Common imageScalling:img withScalingDetails:133 and:73];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgScalling = [Common imageScalling:img withScalingDetails:113 and:68];
            }
            img = [Common imageWithImage:img scaledToSize:imgScalling];
            NSData *imageData = UIImageJPEGRepresentation(img, 0.05);
            NSLog(@"Size of big image = %lu KB",(imageData.length/1024));
            imgView_Controller.image=[[UIImage alloc]initWithData:imageData];
        }else{
            UIImage *image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
            [imgView_Controller.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [imgView_Controller.layer setBorderWidth:1.0];
            
            CGSize imgScalling;
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgScalling = [Common imageScalling:image withScalingDetails:96 and:60];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgScalling = [Common imageScalling:image withScalingDetails:133 and:73];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgScalling = [Common imageScalling:image withScalingDetails:113 and:68];
            }
            image = [Common imageWithImage:image scaledToSize:imgScalling];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.05);
            NSLog(@"Size of big image = %lu KB",(imageData.length/1024));
            imgView_Controller.image=[[UIImage alloc]initWithData:imageData];
        }
        NSData* data = UIImageJPEGRepresentation(imgView_Controller.image, 0.3f);
        strEncoded_ControllerImage = [Base64 encode:data];
        
        [picker dismissViewControllerAnimated:YES completion:NULL];
        imageStatus=YES;
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [viewController_ImageGallery setHidden:YES];
            [viewController_ImageEdit setHidden:NO];
            self.viewController_ProceedView.frame=CGRectMake(self.viewController_ProceedView.frame.origin.x, self.viewController_ImageEdit.frame.origin.y+self.viewController_ImageEdit.frame.size.height+5,self.viewController_ProceedView.frame.size.width, self.viewController_ProceedView.frame.size.height);
            self.viewController_CancelView.frame=CGRectMake(self.viewController_CancelView.frame.origin.x, self.viewController_ImageEdit.frame.origin.y+self.viewController_ImageEdit.frame.size.height+5,self.viewController_CancelView.frame.size.width, self.viewController_CancelView.frame.size.height);
            self.viewController_BodyContent.frame=CGRectMake(self.viewController_BodyContent.frame.origin.x,self.viewController_BodyContent.frame.origin.y,self.viewController_BodyContent.frame.size.width,self.viewController_ProceedView.frame.origin.y+self.viewController_ProceedView.frame.size.height+10);
            self.viewController.frame=CGRectMake(self.viewController.frame.origin.x, self.viewController.frame.origin.y, self.viewController.frame.size.width, self.viewController_BodyContent.frame.origin.y+self.viewController_BodyContent.frame.size.height);
            if([self.strController_PaymentCardSTS isEqualToString:@"NO"]&&[self.strController_PaymentCompletedSTS isEqualToString:@"NO"])
            {
                self.viewBilling.frame=CGRectMake(self.viewBilling.frame.origin.x, self.viewController.frame.origin.y+self.viewController.frame.size.height+5, self.viewBilling.frame.size.width,self.viewBilling.frame.size.height);
                self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewBilling.frame.origin.y+self.viewBilling.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
            }else{
                self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewController.frame.origin.y+self.viewController.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
            }
            if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
                self.deleteNetworkView_Cellular.frame = CGRectMake(self.deleteNetworkView_Cellular.frame.origin.x, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+20, self.deleteNetworkView_Cellular.frame.size.width, self.deleteNetworkView_Cellular.frame.size.height);
            }
        } completion:^(BOOL finished) {
            [self scrollCellularReSet_And_Changes];
            self.view.userInteractionEnabled=YES;
        }];
    }
}

-(void)editImageGallerySetupCellular
{
    imageStatus=YES;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [viewController_ImageGallery setHidden:YES];
        [viewController_ImageEdit setHidden:NO];
        self.viewController_ProceedView.frame=CGRectMake(self.viewController_ProceedView.frame.origin.x, self.viewController_ImageEdit.frame.origin.y+self.viewController_ImageEdit.frame.size.height+5,self.viewController_ProceedView.frame.size.width, self.viewController_ProceedView.frame.size.height);
        self.viewController_CancelView.frame=CGRectMake(self.viewController_CancelView.frame.origin.x, self.viewController_ImageEdit.frame.origin.y+self.viewController_ImageEdit.frame.size.height+5,self.viewController_CancelView.frame.size.width, self.viewController_CancelView.frame.size.height);
        self.viewController_BodyContent.frame=CGRectMake(self.viewController_BodyContent.frame.origin.x,self.viewController_BodyContent.frame.origin.y,self.viewController_BodyContent.frame.size.width,self.viewController_ProceedView.frame.origin.y+self.viewController_ProceedView.frame.size.height+10);
        self.viewController.frame=CGRectMake(self.viewController.frame.origin.x, self.viewController.frame.origin.y, self.viewController.frame.size.width, self.viewController_BodyContent.frame.origin.y+self.viewController_BodyContent.frame.size.height);
        if([self.strController_PaymentCardSTS isEqualToString:@"NO"] && [self.strController_PaymentCompletedSTS isEqualToString:@"NO"])
        {
            self.viewBilling.frame=CGRectMake(self.viewBilling.frame.origin.x, self.viewController.frame.origin.y+self.viewController.frame.size.height+5, self.viewBilling.frame.size.width,self.viewBilling.frame.size.height);
            self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewBilling.frame.origin.y+self.viewBilling.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
        }else{
            self.viewConnection.frame=CGRectMake(self.viewConnection.frame.origin.x, self.viewController.frame.origin.y+self.viewController.frame.size.height+5, self.viewConnection.frame.size.width, self.viewConnection.frame.size.height);
        }
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Cellular.frame = CGRectMake(self.deleteNetworkView_Cellular.frame.origin.x, self.viewConnection.frame.origin.y+self.viewConnection.frame.size.height+20, self.deleteNetworkView_Cellular.frame.size.width, self.deleteNetworkView_Cellular.frame.size.height);
        }
    } completion:^(BOOL finished) {
        self.viewController_BodyContent.hidden=NO;
        cellular_ControllerStatus=NO;
        [self scrollCellularReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
    }];
}
- (UIImage *)resizeImageCellular:(UIImage*)image newSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

/* **********************************************************************************
 Date : 19/08/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Image Saved To Album
 Description : after capture Image/Video its saved to album
 Method Name : hasBeenSavedInPhotoAlbumWithError (Media Picker Delegate Method)
 ************************************************************************************* */
- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
//    if (error) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Photo Saving Failed"
//                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Saved" message:@"Saved To Photo Album"
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        lbl_deviceImgName_CellularController.text = @"asset.JPG";
//        [alert show];
//    }

//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    // Request to save the image to camera roll
//    [library writeImageToSavedPhotosAlbum:[imgView_Controller.image CGImage] orientation:(ALAssetOrientation)[imgView_Controller.image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
//        if (error) {
//            NSLog(@"error");
//        } else {
//            NSLog(@"url %@", [assetURL lastPathComponent]);
//        }
//        lbl_deviceImgName_CellularController.text = [assetURL lastPathComponent];
//    }];
}
#pragma mark - IB Action
-(IBAction)networkHome_CellularController_Action:(id)sender
{
    [self check_Cellular_WidgetDismissORNot];
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Noid Logo
        {
            defaultsCellular=[NSUserDefaults standardUserDefaults];
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            if([appDelegate.strController_Setup_Mode isEqualToString:@"AppLaunch"]||[appDelegate.strController_Setup_Mode isEqualToString:@"NetworkHomeDrawer"]){
                [defaultsCellular setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
                [defaultsCellular synchronize];
                //Need to Push Multiple Network
                MultipleNetworkViewController *MNVC = [[MultipleNetworkViewController alloc] initWithNibName:@"MultipleNetworkViewController" bundle:nil];
                MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                NSArray *newStack = @[MNVC];
                [Common viewFadeIn:self.navigationController.view];
                [self.navigationController setViewControllers:newStack animated:NO];
                // [self.navigationController pushViewController:MNVC animated:YES];
            }
            else if([appDelegate.strController_Setup_Mode isEqualToString:@"MultipleNetwork"]){
                [defaultsCellular setObject:@"YES" forKey:@"MPNETWORKLOADSTATUS"];
                [defaultsCellular synchronize];
                //Need to Pop Multiple Network
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
        }
            break;
        case 1: //Edit add Network   //Remove
        {
            if([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]){
                appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                if([appDelegate.strInitialView isEqualToString:@"SignIn"]){
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
            }else{
                SWRevealViewController *NHVC = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
                // appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.strInitialView=@"ControllerFirstTime";
                NHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                [self.navigationController pushViewController:NHVC animated:YES];
            }
        }
            break;
        case 2: //stngs
        {
            appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strSettingAction = @"networkHome";
            SettingsViewController *SVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
            //  SVC.strPreviousView=@"Cellular";
            // SVC.str_Cellular_FirstStatus=self.strControllerStatus;
            [Common viewFadeInSettings:self.navigationController.view];
            [self.navigationController pushViewController:SVC animated:NO];
        }
    }
}

-(IBAction)cellular_QR_ButtonAction:(id)sender
{
    //self.view.userInteractionEnabled=NO;
    [self check_Cellular_WidgetDismissORNot];
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Prceed QR Button
        {
            if ([txtfld_DeviceId_SetUp resignFirstResponder]) {
                [txtfld_DeviceId_SetUp resignFirstResponder];
            }
            txtfld_DeviceId_SetUp.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceId_SetUp.text];
            if(txtfld_DeviceId_SetUp.text.length==0){
                [Common showAlert:@"Warning" withMessage:@"Please enter hub id"];
                return;
            }
//            ControllerSetUpViewController *CSVC = [[ControllerSetUpViewController alloc] initWithNibName:@"ControllerSetUpViewController" bundle:nil];
//            CSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strHubId=txtfld_DeviceId_SetUp.text;
            appDelegate.strControllerSetUp_Header=lblController_Header.text;
            [Common viewFadeIn:self.navigationController.view];
            [self.navigationController popViewControllerAnimated:NO];
        }
            break;
        case 1: //Cancel OR Button
        {
            [self collapse_QR_View_Cellular];
        }
            break;
        case 2:
        {
//            ControllerSetUpViewController *CSVC = [[ControllerSetUpViewController alloc] initWithNibName:@"ControllerSetUpViewController" bundle:nil];
//            CSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strHubId=@"QRSCAN";
            appDelegate.strControllerSetUp_Header=lblController_Header.text;
            [Common viewFadeIn:self.navigationController.view];
            [self.navigationController popViewControllerAnimated:NO];
        }
            break;
    }
}

-(IBAction)controllerSetup_Button_Action:(id)sender
{
    if([txtfld_DeviceName resignFirstResponder]){
        [txtfld_DeviceName resignFirstResponder];
    }
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Camera for Controller Setup
        {
            //self.view.userInteractionEnabled=NO;
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:@"Device has no camera"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles: nil];
                [myAlertView show];
                return;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:^{}];
        }
            break;
        case 1: //Gallery for Contoller Setup
        {
            //self.view.userInteractionEnabled=NO;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;[self presentViewController:picker animated:YES completion:^{}];
            
        }
            break;
        case 2:  //Edit action gallary
        {
            self.view.userInteractionEnabled=NO;
            [self resetControllerGallary];
            imageStatus=NO;
            strEncoded_ControllerImage=@"";
            
        }
            break;
        case 3: // Proceed Button
        {
            // [txtfld_DeviceName resignFirstResponder];
            txtfld_DeviceName.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceName.text];
            if(txtfld_DeviceName.text.length==0){
                [Common showAlert:@"Warning" withMessage:@"Please enter hub name"];
                return;
            }
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Cellular) withObject:self waitUntilDone:YES];
                if(![strNetwork_Added_Status isEqualToString:@"YES"]){
                    [self performSelectorInBackground:@selector(create_Modify_Cellular_Controller_Noid_Service) withObject:self];
                }else{
                    [self performSelectorInBackground:@selector(update_Modify_Cellular_Controller_Noid_Service) withObject:self];
                }
                
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 4: //Cancel Connection Button
        {
            [self collapse_Controller_View];
        }
            break;
            
    }
}
//strPayment_Selected_Tap,strPayment_PreviousTap
-(IBAction)cellular_CardType_Selection_Action:(id)sender
{
    if([current_textfield_Billing resignFirstResponder]){
        [current_textfield_Billing resignFirstResponder];
    }
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.scrollPayment setContentOffset:CGPointZero animated:YES];
    UIButton *btnPayment_Tag=(UIButton *)sender;
    switch (btnPayment_Tag.tag) {
        case 4:
        {
            self.view_Info_Popup.hidden=NO;
            [self popup_Cellular_Alpha_Disabled];
        }
            break;
            
        case 5:
        {
            self.view_Info_Popup.hidden=YES;
            [self popup_Cellular_Alpha_Enabled];
        }
            break;
    }
}
-(IBAction)cellular_Billing_ButtonAction:(id)sender{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:   //Billing Add Card
        {
            strEditCardStatus=@"";
            strAlert_Type=@"Payment";
            txtfld_zipCode_UpdateCard.delegate=self;
            txtfld_CardName_UpdateCard.delegate=self;
            txtfld_CardNo_UpdateCard.delegate=self;
            txtfld_digits_UpdateCard.delegate=self;
            txtfld_Month_UpdateCard.delegate=self;
            txtfld_Year_UpdateCard.delegate=self;
            if(![strCredit_Card_Added_Status isEqualToString:@"YES"]){
                txtfld_digits_UpdateCard.userInteractionEnabled = NO;
                txtfld_digits_UpdateCard.alpha = 0.4;
            }
            self.scrollPayment.delegate=self;
            self.scrollPayment.scrollEnabled=YES;
            self.scrollPayment.showsVerticalScrollIndicator=YES;
            self.scrollPayment.userInteractionEnabled=YES;
            self.scrollPayment.contentOffset = CGPointZero;
            self.scrollPayment.scrollsToTop=NO;
            [self userInteraction_CellularBilling_Disabled];
            [self PreviousNextButtons_Cellular];
            [UIView beginAnimations:@"move" context:nil];
            [UIView setAnimationDuration:0.5];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                view_PaymentCard.frame  = CGRectMake(view_PaymentCard.frame.origin.x, 215,view_PaymentCard.frame.size.width,view_PaymentCard.frame.size.height);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                view_PaymentCard.frame  = CGRectMake(view_PaymentCard.frame.origin.x, 272,view_PaymentCard.frame.size.width,view_PaymentCard.frame.size.height);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                view_PaymentCard.frame  = CGRectMake(view_PaymentCard.frame.origin.x, 248,view_PaymentCard.frame.size.width,view_PaymentCard.frame.size.height);
            }
             [self setPlan_Payment_OptionGusters_Cellular];
             [self swipeGestureBilling_Cellular];
             [UIView commitAnimations];
        }
            break;
        case 1: //Payment Popup Sliderbtn and Cancel Button
        {
             [self hidePlanPaymentOptionView_Cellular];
        }
            break;
            
        case 2:  //Payment Popup Save Button
        {
            [current_textfield_Billing resignFirstResponder];
            self.scrollPayment.contentOffset = CGPointZero;
            self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
            
            if([self checkCardVaidationCellular]==NO)
            {
                return;
            }
            
            if([self checkCardMonthValidationCellular]==NO)
            {
                //[Common showAlert:@"Invalid Expiry Date Month" withMessage:@"Please Enter Valid Month"];
                return;
            }
            if([self checkCardYearValidationCellular]==NO){
                //[Common showAlert:@"Invalid Expiry Date Year" withMessage:@"Please Enter Valid 4 Digit Year"];
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
            if([self checkCardDigitsValidationCellular]==NO)
            {
                // [Common showAlert:@"Invalid Card CSC Digits" withMessage:@"Please Enter Valid CSC Digits"];
                return;
            }
            if([self checkCardZipCodeValidationCellular]==NO){
                // [Common showAlert:@"Invalid ZipCode" withMessage:@"Please Enter Valid Zipcode"];
                return;
            }
            
            [self performSelectorOnMainThread:@selector(start_PinWheel_Cellular) withObject:self waitUntilDone:YES];
            [self putCardDetails];
            // [self hidePlanPaymentOptionView_Cellular];
        }
            break;
        case 3: //Billing ChargeMyCard Button
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Cellular) withObject:self waitUntilDone:YES];
                if([strCredit_Card_Updated_Status isEqualToString:@"YES"])
                {
                    [self performSelectorInBackground:@selector(updateCreditCardDetails) withObject:self];
                }else{
                    [self performSelectorInBackground:@selector(addCreditCardDetails) withObject:self];
                }
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }

        }
            break;
        case 4: //Billing ChargeMyCard Cancel Button
        {
            [self collapse_Billing_ChargeCardView];
            
        }
            break;
        case 5://Billing Terms and Conditions Close Button
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Cellular) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(tc_Noid_UserService_Cellular) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 6://Billing Proceed Button
        {
            [self collapse_Billing_View];
            strExpandFlagStatus=@"YES";
            [self resetProgressBar];
            [self expand_Connection_View];
            self.viewConnection.userInteractionEnabled=YES;
            [self startProgressBar];
            [self hidePlanPaymentOptionView_Cellular];
        }
            break;
        case 7://Billing Cancel Button
        {
            [self collapse_Billing_View];
            // [self scrollCellularReSet_And_Changes];
            
        }
            break;
            
        case 8:{   //i icon
            [self set_PlanOption_Gesture_Cellular];
            if([strPlanStatus isEqualToString:@"YES"]){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Cellular) withObject:self waitUntilDone:YES];
                strAlert_Type=@"Plan";
                strEditCardStatus=@"";
                scrollView_PlanCard.frame  = CGRectMake(scrollView_PlanCard.frame.origin.x, 20,scrollView_PlanCard.frame.size.width,scrollView_PlanCard.frame.size.height);
                [self performSelectorOnMainThread:@selector(stop_PinWheel_Cellular) withObject:self waitUntilDone:YES];
            }else{
                if([Common reachabilityChanged]==YES){
                    strAlert_Type=@"Plan";
                    strEditCardStatus=@"";
                    [self planCardScrollSetup];
                    [self planCardOptionScrollSetup];
                    scrollView_PlanCard.frame  = CGRectMake(scrollView_PlanCard.frame.origin.x, 20,scrollView_PlanCard.frame.size.width,scrollView_PlanCard.frame.size.height);
                    [self performSelectorOnMainThread:@selector(start_PinWheel_Cellular) withObject:self waitUntilDone:YES];
                    [self performSelectorInBackground:@selector(getBillingPlans) withObject:self];
                }else{
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                }
            }
        }
            break;
        case 9: //TC Pop Up close
        {
            self.view_Info_TC.hidden=YES;
            self.viewCellular_Header.userInteractionEnabled=YES;
            self.viewCellular_Body.userInteractionEnabled=YES;
            [self popup_Cellular_Alpha_Enabled];
            [txtView_TermsAndCond scrollRangeToVisible:NSMakeRange(0, 0)];
        }
            break;
        case 10:{  //Edicard and Pencil
            [self start_PinWheel_Cellular];
            strEditCardStatus=@"YES";
            strAlert_Type=@"Payment";
            [self userInteraction_CellularBilling_Disabled];
            [self PreviousNextButtons_Cellular];
            [UIView beginAnimations:@"move" context:nil];
            [UIView setAnimationDuration:0.5];
//            self.view_PaymentCard.frame  = CGRectMake(self.view_PaymentCard.frame.origin.x, 345,self.view_PaymentCard.frame.size.width,self.view_PaymentCard.frame.size.height);
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                view_PaymentCard.frame  = CGRectMake(view_PaymentCard.frame.origin.x, 215,view_PaymentCard.frame.size.width,view_PaymentCard.frame.size.height);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                view_PaymentCard.frame  = CGRectMake(view_PaymentCard.frame.origin.x, 272,view_PaymentCard.frame.size.width,view_PaymentCard.frame.size.height);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                view_PaymentCard.frame  = CGRectMake(view_PaymentCard.frame.origin.x, 248,view_PaymentCard.frame.size.width,view_PaymentCard.frame.size.height);
            }
            [self setPlan_Payment_OptionGusters_Cellular];
            [self swipeGestureBilling_Cellular];
            [UIView commitAnimations];
            [self stop_PinWheel_Cellular];
            // [self loadCardDetails];
        }
            break;
        case 11: //Email TC
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Cellular) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(sendGridEmail_Noid_UserService_Cellular) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
    }
}

-(void)putCardDetails
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
    
    if(![strEditCardStatus isEqualToString:@"YES"]){
        [self expand_Billing_ChargeCardView];
    }else if([strCredit_Card_Updated_Status isEqualToString:@"YES"])
    {
        self.viewChargeCardSmall.hidden=NO;
        self.btn_TC.hidden=NO;
        self.view_Billing_Proceed.hidden=YES;
        self.view_Billing_Cancel.hidden=YES;
    }
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
    [self hidePlanPaymentOptionView_Cellular];
    [self performSelectorOnMainThread:@selector(stop_PinWheel_Cellular) withObject:self waitUntilDone:YES];
}

/*
-(NSString *) secureCreditCardNumber:(NSString *)strCardNumber
{
    NSString *newString=@"";
    NSString *myString = [NSString stringWithFormat:@"%4@",strCardNumber]; // if less than 4 then pad string
    NSLog(@"Old String is%@",myString);
    
    NSInteger obscureLength = myString.length;
    NSLog(@"string length %ld",(long)obscureLength);
    if (obscureLength ==16)
    {
        NSRange range = NSMakeRange(0,12);
        newString = [myString stringByReplacingCharactersInRange:range
                                                      withString:@"************"];
        //  lbldisplay.text=newString;
        NSLog(@"result for 16 %@",newString);
        
    }else if (obscureLength ==15){
        
        NSRange range = NSMakeRange(0,11);
        newString = [myString stringByReplacingCharactersInRange:range
                                                      withString:@"***********"];
        // lbldisplay.text=newString;
        NSLog(@"result for 15 %@",newString);
    }
    else if (obscureLength ==13){
        
        NSRange range = NSMakeRange(0,9);
        newString = [myString stringByReplacingCharactersInRange:range
                                                      withString:@"*********"];
        //lbldisplay.text=newString;
        NSLog(@"result for 13 %@",newString);
    }
    return newString;
}*/

-(IBAction)cellular_Connection_ButtonAction:(id)sender
{
    if([txtfld_DeviceName resignFirstResponder])
    {
        [txtfld_DeviceName resignFirstResponder];
    }
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Prceed Connection Button
        {
            //[self checkCollapseConnection];
            [self chnage_SetupConnection_View];
            //[self scrollCellularReSet_And_Changes];
            //[self expand_Controller_View];
        }
            break;
        case 1: //Cancel Connection Button
        {
            //[self checkCollapseConnection];
            [self collapse_Connection_View];
            // [self scrollCellularReSet_And_Changes];
            
        }
            break;
        case 2: //Set Up Device
        {
            //self.view.userInteractionEnabled=YES;
            view_deviceSetUp_Alert.hidden=NO;
            [viewCellular_Header setAlpha:0.6];
            [viewCellular_Body setAlpha:0.6];
        }
            break;
        case 3: //Skipe Device and Save
        {
            [Common resetNetworkFlags];
            SWRevealViewController *SWR = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
            SWR = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            NSArray *newStack = @[SWR];
            [self.navigationController setViewControllers:newStack animated:YES];
            self.view.userInteractionEnabled=YES;
        }
            break;
        case 4: //Sprinkler
        {
            //SprinklerDeviceSetupViewController
            SprinklerDeviceSetupViewController *SDSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SprinklerDeviceSetupViewController"];
            SDSVC.strDeviceType = @"sprinklers";
            [self hide_DeviceSetup_Cellular];
            [self.navigationController pushViewController:SDSVC animated:YES];
        }
            break;
        case 5:  //Lights
        {
            DeviceSetUpViewController *LDSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceSetUpViewController"];
            LDSVC.strDeviceType = @"lights";
            [self hide_DeviceSetup_Cellular];
            [self.navigationController pushViewController:LDSVC animated:YES];
        }
            break;
        case 6:  //Others
        {
            DeviceSetUpViewController *LDSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceSetUpViewController"];
            LDSVC.strDeviceType = @"others";
            [self hide_DeviceSetup_Cellular];
            [self.navigationController pushViewController:LDSVC animated:YES];
            
        }
            break;
        case 7: // Close alert
        {
            [self hide_DeviceSetup_Cellular];
        }
            break;
            
    }
}

-(IBAction)cellular_TapMenu_Action:(id)sender
{
    self.view.userInteractionEnabled=NO;
    [self check_Cellular_WidgetDismissORNot];
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:   //Scan Or Enter Device Id Tap Button
        {
            if(cellular_QR_ExpandStatus==YES){
                [self check_Cellular_TapAlreadyOpenedOrNot];
                [self expand_QR_View_Cellular];
            }else{
                [self collapse_QR_View_Cellular];
            }
            
        }
            break;
        case 1:
        {
            strExpandFlagStatus=@"";
            if(cellular_billing_ExpandedStatus==YES){
                [self check_Cellular_TapAlreadyOpenedOrNot];
                [self expand_Billing_View];
            }else{
                [self collapse_Billing_View];
            }
            //[self scrollCellularReSet_And_Changes];
        }
            break;
        case 2:
        {
            if(cellular_Connection_ExpandedStatus==YES){
                strExpandFlagStatus=@"YES";
                [self check_Cellular_TapAlreadyOpenedOrNot];
//                [self resetProgressBar];
                [self expand_Connection_View];
//                [self startProgressBar];
            }else{
                strExpandFlagStatus=@"";
                [self resetProgressBar];
                [self collapse_Connection_View];
            }
            //[self scrollCellularReSet_And_Changes];
        }
            break;
        case 3:  //Controller Details Tap
        {
            strExpandFlagStatus=@"";
            if(cellular_ControllerStatus==YES){
                [self check_Cellular_TapAlreadyOpenedOrNot];
                [self expand_Controller_View];
            }else{
                [self collapse_Controller_View];
            }
            //[self scrollCellularReSet_And_Changes];
        }
            break;
    }
}

-(IBAction)deleteNetwork_Cellular_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            popUpDeleteView_Cellular.hidden=YES;
            [viewCellular_Body setAlpha:1.0];
            [viewCellular_Header setAlpha:1.0];
        }
            break;
        case 1:
        {
            popUpDeleteView_Cellular.hidden=YES;
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Cellular) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(deleteCellularNetwork_NOID) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
            [viewCellular_Body setAlpha:1.0];
            [viewCellular_Header setAlpha:1.0];
        }
            break;
        case 2:
        {
            popUpDeleteView_Cellular.hidden=NO;
            [viewCellular_Body setAlpha:0.6];
            [viewCellular_Header setAlpha:0.6];
        }
            break;
    }
}

-(IBAction)planUpgrade_Confirmation_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Plan Upgarde Okay
        {
            if(![strControllerDelete isEqualToString:@"YES"])  //Not downgrade going to upgrade
            {
                if([Common reachabilityChanged]==YES){
                    [self performSelectorOnMainThread:@selector(start_PinWheel_Cellular) withObject:self waitUntilDone:YES];
                    [self performSelectorInBackground:@selector(quoteForAdditionalController) withObject:self];
                    
                }else{
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                }
                return;
            }
            //Downgrade
            
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Cellular) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(quoteForAdditionalController) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
            
        }
            break;
        case 1: //Plan Upgrade Cancel
        {
            viewAlert_PlanUpgrade.hidden=YES;
            [self popup_Cellular_Alpha_Enabled];
        }
            break;
        case 2: // Charge My card
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Cellular) withObject:self waitUntilDone:YES];
                if(![strControllerDelete isEqualToString:@"YES"]) //Upgrade Confirmation
                {
                    [self performSelectorInBackground:@selector(quoteForAdditionalControllerConfirmation) withObject:self];
                }else{  //Downgrade Confirmation
                    [self performSelectorInBackground:@selector(quoteForDowngradeControllerConfirmation) withObject:self];
                }
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 3: //Confirmation Alert Cancel
        {
            self.viewAlert_PlanUpgrade_Confirmation.hidden=YES;
            [self popup_Cellular_Alpha_Enabled];
        }
            break;
    }
}

#pragma mark - Payment Credit Card Validation
- (IBAction)changevalidationString:(id)sender {
    
    NSString *cc_num_string = ((UITextField*)sender).text;
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
#pragma mark - PinWheel Methods
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : This method is called to start the Progress HUD
 Method Name : start_PinWheel_Registeration(User Defined Method)
 ************************************************************************************* */
-(void)start_PinWheel_Cellular{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"YES";
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : This method is called to stop the Progress HUD
 Method Name : stop_PinWheel_Registeration(User Defined Method)
 ************************************************************************************* */
-(void)stop_PinWheel_Cellular{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
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
            [self hidePlanPaymentOptionView_Cellular];
        }
    }
}

#pragma mark - WebService Part
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Title: Registeration Webservice
 Description : Add Cellular Controller device detials to server
 Method Name : create_Modify_Cellular_Controller_Noid_Service(User Defined Method)
 ************************************************************************************* */
-(void)create_Modify_Cellular_Controller_Noid_Service
{
    defaultsCellular=[NSUserDefaults standardUserDefaults];
    txtfld_DeviceName.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceName.text];
    NSLog(@"User Account id ==%@",[defaultsCellular objectForKey:@"ACCOUNTID"]);
    NSLog(@"plan id ==%@",[[self.dictController_BasicPlan valueForKey:@"id"] stringValue]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks",[defaultsCellular objectForKey:@"ACCOUNTID"]];
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictController_Device_Details=[[NSMutableDictionary alloc] init];
    [dictController_Device_Details setObject:txtfld_DeviceName.text forKey:kDeviceName];
//    [dictController_Device_Details setObject:strEncoded_ControllerImage forKey:kDeviceImage];
    [dictController_Device_Details setObject:@"" forKey:kDeviceImage];
    [dictController_Device_Details setObject:strEncoded_ControllerImage forKey:KThumbnailImage];
    [dictController_Device_Details setObject:self.strController_TraceID forKey:kControllerID];
    [dictController_Device_Details setObject:[[self.dictController_BasicPlan valueForKey:@"id"] stringValue] forKey:kBillingPlanID];
    //[dictController_Device_Details setObject:[NSString stringWithFormat:@"%@",[defaultsCellular objectForKey:@"ACCOUNTID"]] forKey:kAccountID];
    
    parameters=[SCM controller_Add_Device_Details:dictController_Device_Details];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Create/Edit New Controller Device Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseCellularController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Create/Edit New Controller Device Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Cellular) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedCellularController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodNameWith_Value];
}

-(void)responseCellularController_DeviceDetails
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            strNetwork_Added_Status=@"YES";
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strNetworkAddedStatus=@"YES";
            networkData_Dict=[responseDict objectForKey:@"data"];
            if([networkData_Dict count]>0){
                appDelegate.dict_NetworkControllerDatas = [[NSMutableDictionary alloc] init];
                //new code
                NSDictionary *dictNetworkStatus=[networkData_Dict valueForKey:@"networkStatus"];
                NSArray *arrController=[dictNetworkStatus valueForKey:@"controller"];
                hasPaymentCard = [[dictNetworkStatus objectForKey:@"hasPaymentCard"] boolValue];
                if(arrController.count>0)
                {
                    [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"alert"] forKey:kAlertCount];
                    [appDelegate.dict_NetworkControllerDatas setObject:[[networkData_Dict valueForKey:@"id"] stringValue] forKey:kNetworkID];
                    [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"message"] forKey:kMessageCount];
                    [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"latitude"] forKey:kLat];
                    [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"longitude"] forKey:kLong];
                    [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"name"] forKey:kNetworkName];
                    [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"thumbnailImage"] forKey:kNetWrokImage];
                    NSLog(@"network details==%@",appDelegate.dict_NetworkControllerDatas);
                    
                    NSDictionary *dictController=[arrController objectAtIndex:0];
                    NSDictionary *dictControllerTrace = [[dictController valueForKey:@"controllerTrace"] valueForKey:@"controllerConnectivityType"];
                    
                    NSLog(@"controller id ==%@",[dictController valueForKey:@"id"]);
                    NSLog(@"controllerConnectivityType is ==%@",dictControllerTrace);
                    NSLog(@"controller type%@",[dictControllerTrace valueForKey:@"typeCode"]);
                    NSLog(@"controller Trace ID ==%@",[[dictController valueForKey:@"controllerTrace"] valueForKey:@"id"]);
                    
                    [appDelegate.dict_NetworkControllerDatas setObject:[dictControllerTrace valueForKey:@"typeCode"] forKey:kControllerType];
                    [appDelegate.dict_NetworkControllerDatas setObject:[[dictController valueForKey:@"id"] stringValue] forKey:kControllerID];
                    str_Added_ControllerID=[[dictController objectForKey:@"id"] stringValue];
                    NSLog(@"network details==%@",appDelegate.dict_NetworkControllerDatas);
                    
                    defaultsCellular=[NSUserDefaults standardUserDefaults];
                    NSLog(@"network count is ==%@",[defaultsCellular objectForKey:@"NETWORKCOUNT"]);
                    int nwCount=[[defaultsCellular objectForKey:@"NETWORKCOUNT"] intValue];
                    nwCount=nwCount+1;
                    
                    [defaultsCellular setObject:[NSString stringWithFormat:@"%d",nwCount] forKey:@"NETWORKCOUNT"];
                    [defaultsCellular synchronize];
                    NSLog(@"network count is ==%@",[defaultsCellular objectForKey:@"NETWORKCOUNT"]);
                    if(nwCount==1){
                        [defaultsCellular setObject:appDelegate.dict_NetworkControllerDatas forKey:@"NETWORKSINGLEDATAS"];
                        [defaultsCellular setObject:[networkData_Dict valueForKey:@"id"] forKey:@"NETWORKID"];
                        [defaultsCellular synchronize];
                        
                        NSMutableDictionary *dictPaymentDict=[[NSMutableDictionary alloc] init];
                        [dictPaymentDict setObject:@"NO" forKey:kControllerConnectedStatus];
                        [dictPaymentDict setObject:@"NO" forKey:kControllerPaymentCard];
                        [dictPaymentDict setObject:@"NO" forKey:kControllerPaymentCompleted];
                        [defaultsCellular setObject:dictPaymentDict forKey:@"NETWORKPAYMENTDATAS"];
                        [defaultsCellular setObject:self.dictController_BasicPlan forKey:@"CONTROLLERPLANDATA"];
                        [defaultsCellular setObject:self.strController_TraceID forKey:@"CONTROLLERTRACEIDDATA"];
                        [defaultsCellular synchronize];
                    }
                    
                    self.viewBilling.userInteractionEnabled=YES;
                    [self stop_PinWheel_Cellular];
//                    [Common showAlert:kAlertSuccess withMessage:responseMessage];
                    [self collapse_Controller_View];
                    [self expand_Billing_View];
                    
                }else{
                    [self stop_PinWheel_Cellular];
                    [Common showAlert:kAlertTitleWarning withMessage:@"Parser Error"];
                }
                
                // [self add_Cellular_Controller_Noid_Service];
            }
            else{
                //  self.viewSetUp.userInteractionEnabled=YES;
                [self stop_PinWheel_Cellular];
                [Common showAlert:kAlertTitleWarning withMessage:@"Parser Error"];
            }
        }else{
            [self stop_PinWheel_Cellular];
            if([responseMessage isEqualToString:@"ACCT_CONTROLLER_MAX_LIMIT_REACHED"])
            {
                [self.viewAlert_PlanUpgrade setHidden:NO];
                [self popup_Cellular_Alpha_Disabled];
                return;
            }
            else if([responseMessage isEqualToString:@"ACCT_CONTROLLER_PLAN_START"])
            {
                strprorationTime=@"0";
                self.lbl_PlanUpgrade_Charge.text=@"";
                
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    self.imgViewCharge.frame=CGRectMake(133, self.imgViewCharge.frame.origin.y, self.imgViewCharge.frame.size.width, self.imgViewCharge.frame.size.height);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    self.imgViewCharge.frame=CGRectMake(156, self.imgViewCharge.frame.origin.y, self.imgViewCharge.frame.size.width, self.imgViewCharge.frame.size.height);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                    self.imgViewCharge.frame=CGRectMake(149, self.imgViewCharge.frame.origin.y, self.imgViewCharge.frame.size.width, self.imgViewCharge.frame.size.height);
                }

                [self.viewAlert_PlanUpgrade_Confirmation setHidden:NO];
                [self popup_Cellular_Alpha_Disabled];
               // planExitStatus=@"YES";
               // [self performSelectorOnMainThread:@selector(start_PinWheel_Cellular) withObject:self waitUntilDone:YES];
                //[self performSelectorInBackground:@selector(quoteForAdditionalControllerConfirmation) withObject:self];
                return;
            }
            else if([responseMessage isEqualToString:@"NAME_ALREADY_USED"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"This Hub Name Already Exists"];
                return;
            }else if ([responseMessage isEqualToString:@"APP_CONTROLLER_MAX_LIMIT_REACHED"]){
                [Common showAlert:kAlertTitleWarning withMessage:@"Sorry! You Have Already Reached Your Maximum Limit."];
                return;
            }
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)responseFailedCellularController_DeviceDetails
{
    [Common showAlert:@"Warning" withMessage:strResponseError];
}
/*
 NSLog(@"Nwtwork id ==%@",[[networkData_Dict valueForKey:@"id"] stringValue]);
 NSLog(@"controller id ==%@",strController_ID);
 defaults_Wifi=[NSUserDefaults standardUserDefaults];
 NSLog(@"User Account id ==%@",[defaults_Wifi objectForKey:@"ACCOUNTID"]);
 NSDictionary *parameters;
 ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
 NSMutableDictionary *dictController=[[NSMutableDictionary alloc] init];
 [dictController setObject:self.strController_ID forKey:kControllerID];
 [dictController setObject:[[networkData_Dict valueForKey:@"id"] stringValue] forKey:kNetworkID];
 NSString *strMethodName=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers",[defaults_Wifi objectForKey:@"ACCOUNTID"],[[networkData_Dict valueForKey:@"id"] stringValue]];
 
 */

//controller added service
/*-(void)add_Cellular_Controller_Noid_Service
{
    NSLog(@"Nwtwork id ==%@",[[networkData_Dict valueForKey:@"id"] stringValue]);
    NSLog(@"plan id ==%@",[[self.dictController_BasicPlan valueForKey:@"id"] stringValue]);
    NSLog(@"controller id ==%@",strController_ID);
    NSDictionary *parameters;
    defaultsCellular=[NSUserDefaults standardUserDefaults];
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictController=[[NSMutableDictionary alloc] init];
    NSLog(@"User Account id ==%@",[defaultsCellular objectForKey:@"ACCOUNTID"]);
    [dictController setObject:[[self.dictController_BasicPlan valueForKey:@"id"] stringValue] forKey:kBillingPlanID];  //plan id is nt for wifi
    [dictController setObject:self.strController_ID forKey:kControllerID];
    [dictController setObject:[[networkData_Dict valueForKey:@"id"] stringValue] forKey:kNetworkID];
    NSString *strMethodName=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers",[defaultsCellular objectForKey:@"ACCOUNTID"],[[networkData_Dict valueForKey:@"id"] stringValue]];
    parameters=[SCM controller_Add:dictController];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Add New Controller ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(response_AddCellular_Controller) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Add New Controller ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Cellular) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedCellularController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodName];
    
}

-(void)response_AddCellular_Controller
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *dictController=[responseDict objectForKey:@"data"];
            str_Added_ControllerID=[[dictController objectForKey:@"id"] stringValue];
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strController_IDApp=str_Added_ControllerID;
            self.viewBilling.userInteractionEnabled=YES;
            [self stop_PinWheel_Cellular];
            [Common showAlert:kAlertSuccess withMessage:responseMessage];
            [self collapse_Controller_View];
            [self expand_Billing_View];
        }else{
            [self stop_PinWheel_Cellular];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
 */
-(void)update_Modify_Cellular_Controller_Noid_Service
{
    defaultsCellular=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    txtfld_DeviceName.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceName.text];
    NSLog(@"User Account id ==%@",[defaultsCellular objectForKey:@"ACCOUNTID"]);
    NSLog(@"Nwtwork id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks?controllerTraceId=%@",[defaultsCellular objectForKey:@"ACCOUNTID"],self.strController_TraceID];
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictController_Device_Details=[[NSMutableDictionary alloc] init];
    [dictController_Device_Details setObject:txtfld_DeviceName.text forKey:kDeviceName];
//    [dictController_Device_Details setObject:strEncoded_ControllerImage forKey:kDeviceImage];
    [dictController_Device_Details setObject:@"" forKey:kDeviceImage];
    [dictController_Device_Details setObject:strEncoded_ControllerImage forKey:KThumbnailImage];
    [dictController_Device_Details setObject:[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID] forKey:kNetworkID];
    
    parameters=[SCM controller_Update_Device_Details:dictController_Device_Details];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update cellular Controller Device Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseCellularController_Update_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Controller cellular Device Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Cellular) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedCellularController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}
-(void)responseCellularController_Update_DeviceDetails
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            strNetwork_Added_Status=@"YES";
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strNetworkAddedStatus=@"YES";
            if([str_MultipleNetwork_Mode isEqualToString:@"edit"]){
                appDelegate.strEdit_Controller_DeviceStatus=@"YES";
            }else{
                appDelegate.strEdit_Controller_DeviceStatus=@"";
            }
            networkData_Dict=[responseDict objectForKey:@"data"];
            NSString *strConType=[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerType];
            appDelegate.dict_NetworkControllerDatas = [[NSMutableDictionary alloc] init];
            [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"alert"] forKey:kAlertCount];
            [appDelegate.dict_NetworkControllerDatas setObject:[[networkData_Dict valueForKey:@"id"] stringValue] forKey:kNetworkID];
            [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"message"] forKey:kMessageCount];
            [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"latitude"] forKey:kLat];
            [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"longitude"] forKey:kLong];
            [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"name"] forKey:kNetworkName];
            [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"thumbnailImage"] forKey:kNetWrokImage];
            [appDelegate.dict_NetworkControllerDatas setObject:str_Added_ControllerID forKey:kControllerID];
            NSLog(@"network details==%@",appDelegate.dict_NetworkControllerDatas);
            NSDictionary *dictNetworkStatus=[networkData_Dict valueForKey:@"networkStatus"];
            NSArray *arrController=[dictNetworkStatus valueForKey:@"controller"];
            if(arrController.count>0)
            {
                NSDictionary *dictController=[arrController objectAtIndex:0];
                NSArray *arrControllerTrace = [[dictController valueForKey:@"controllerTrace"] valueForKey:@"controllerConnectivityType"];
                NSLog(@"controllerConnectivityType is ==%@",arrControllerTrace);
                [appDelegate.dict_NetworkControllerDatas setObject:[arrControllerTrace valueForKey:@"typeCode"] forKey:kControllerType];
                
            }else{
                [appDelegate.dict_NetworkControllerDatas setObject:strConType forKey:kControllerType];
            }
            NSLog(@"network details==%@",appDelegate.dict_NetworkControllerDatas);
            defaultsCellular=[NSUserDefaults standardUserDefaults];
            NSLog(@"network count is ==%@",[defaultsCellular objectForKey:@"NETWORKCOUNT"]);
            int nwCount=[[defaultsCellular objectForKey:@"NETWORKCOUNT"] intValue];
            if(nwCount==1){
                [defaultsCellular setObject:appDelegate.dict_NetworkControllerDatas forKey:@"NETWORKSINGLEDATAS"];
                [defaultsCellular synchronize];
            }
            
            
            [self stop_PinWheel_Cellular];
//            [Common showAlert:kAlertSuccess withMessage:responseMessage];
            self.viewBilling.userInteractionEnabled=YES;
            [self collapse_Controller_View];
            if([self.strController_PaymentCardSTS isEqualToString:@"NO"]&&[self.strController_PaymentCompletedSTS isEqualToString:@"NO"]){
                [self expand_Billing_View];
            }else{
                [self expand_Connection_View];
            }
        }else{
            // self.viewSetUp.userInteractionEnabled=YES;
            [self stop_PinWheel_Cellular];
            if([responseMessage isEqualToString:@"NAME_ALREADY_USED"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"This Hub Name Already Exists"];
                return;
                
            }
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        // self.viewSetUp.userInteractionEnabled=YES;
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}


-(void)getBillingPlans
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/billing_plans"];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Billing Plans ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseBillingPlans) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Billing Plans ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Cellular) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedCellularController_DeviceDetails) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
-(void)responseBillingPlans
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
                [self parseBillingPlans:arrBillingPlans];
            }else{
                [self stop_PinWheel_Cellular];
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
        }else{
            [self stop_PinWheel_Cellular];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)parseBillingPlans:(NSMutableArray *)arrBillingPlans
{
    //going to split
    arrPlan=[[NSMutableArray alloc] init];
    arrPlanRange = [[NSMutableArray alloc] init];
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

            //self.scrollView_Planoptions.contentSize=CGSizeMake(x_OffsetLblDoller,self.scrollView_Planoptions.frame.size.height);
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
                [lblPrice addTarget:self action:@selector(open_emailView_Cellular_OnTap:) forControlEvents:UIControlEventTouchUpInside];
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
        NSLog(@"yoffset==%f",yOffsetPlan);
        self.scrollView_Planoptions.frame=CGRectMake(self.scrollView_Planoptions.frame.origin.x, self.scrollView_Planoptions.frame.origin.y, self.scrollView_Planoptions.frame.size.width, yOffsetPlan);
        
        self.viewPlan.frame=CGRectMake(self.viewPlan.frame.origin.x, self.viewPlan.frame.origin.y, self.viewPlan.frame.size.width, scrollView_Planoptions.frame.size.height+scrollView_Planoptions.frame.origin.y);
        
        self.scrollView_PlanCard.contentSize=CGSizeMake(self.scrollView_PlanCard.frame.size.width, viewPlan.frame.origin.y+viewPlan.frame.size.height);
        
        [self stop_PinWheel_Cellular];
        
        
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

-(void)updateCreditCardDetails
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
    defaultsCellular=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsCellular objectForKey:@"ACCOUNTID"]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodName=[NSString stringWithFormat:@"/accounts/%@/billing",[defaultsCellular objectForKey:@"ACCOUNTID"]];
    NSMutableDictionary *dictCardDetails=[[NSMutableDictionary alloc] init];
    [dictCardDetails setObject:strCardType forKey:kCardType];
    [dictCardDetails setObject:txtfld_CardName_UpdateCard.text forKey:kCardName];
    [dictCardDetails setObject:txtfld_CardNo_UpdateCard.text forKey:kCardNumber];
    [dictCardDetails setObject:txtfld_Month_UpdateCard.text forKey:kCardExpiryMonth];
    [dictCardDetails setObject:txtfld_Year_UpdateCard.text forKey:kCardExpiryYear];
    [dictCardDetails setObject:txtfld_digits_UpdateCard.text forKey:kCardCSCCode];
    [dictCardDetails setObject:txtfld_zipCode_UpdateCard.text forKey:kCardZipCode];
    // [dictCardDetails setObject:strCreditCardID forKey:kCreditCardID];
    
    //    if([str_MultipleNetwork_Mode isEqualToString:@"edit"]){
    //        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    //        str_Added_ControllerID=appDelegate.strController_IDApp;
    //    }
    //    [dictCardDetails setObject:str_Added_ControllerID forKey:kControllerID];
    
    parameters=[SCM updateCreditCardDetails:dictCardDetails];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update credit card Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(response_UpdateCreditCard_Details) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update credit card Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Cellular) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedCellularController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodName];
}
-(void)addCreditCardDetails
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
    defaultsCellular=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsCellular objectForKey:@"ACCOUNTID"]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodName=[NSString stringWithFormat:@"/accounts/%@/billing?controllerId=%@",[defaultsCellular objectForKey:@"ACCOUNTID"],str_Added_ControllerID];
    NSMutableDictionary *dictCardDetails=[[NSMutableDictionary alloc] init];
    [dictCardDetails setObject:strCardType forKey:kCardType];
    [dictCardDetails setObject:txtfld_CardName_UpdateCard.text forKey:kCardName];
    [dictCardDetails setObject:txtfld_CardNo_UpdateCard.text forKey:kCardNumber];
    [dictCardDetails setObject:txtfld_Month_UpdateCard.text forKey:kCardExpiryMonth];
    [dictCardDetails setObject:txtfld_Year_UpdateCard.text forKey:kCardExpiryYear];
    [dictCardDetails setObject:txtfld_digits_UpdateCard.text forKey:kCardCSCCode];
    [dictCardDetails setObject:txtfld_zipCode_UpdateCard.text forKey:kCardZipCode];
    
    //    if([str_MultipleNetwork_Mode isEqualToString:@"edit"]){
    //        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    //        str_Added_ControllerID=appDelegate.strController_IDApp;
    //    }
    //    [dictCardDetails setObject:str_Added_ControllerID forKey:kControllerID];
    
    parameters=[SCM addCreditCardDetails:dictCardDetails];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for add credit card Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(response_AddCreditCard_Details) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for add credit card Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Cellular) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedCellularController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodName];
}

/*-(void)response_AddCreditCard_Details
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            NSLog(@"DICT credit card ID ==%@",[[dicitData objectForKey:@"id"] stringValue]);
            // strCreditCardID=[dicitData objectForKey:@"id"];
            strCredit_Card_Updated_Status=@"YES";
            self.viewChargeCardSmall.hidden=YES;
            self.btn_TC.hidden=YES;
            self.view_Billing_Proceed.hidden=NO;
            self.view_Billing_Cancel.hidden=NO;
            
            
            //new code
            self.btn_PencilCardName.hidden=YES;
            self.btn_PencilCard.hidden=YES;
            //
            //Check netowrk count
            
            defaultsCellular=[NSUserDefaults standardUserDefaults];
            NSLog(@"network count is ==%@",[defaultsCellular objectForKey:@"NETWORKCOUNT"]);
            int nwCount=[[defaultsCellular objectForKey:@"NETWORKCOUNT"] intValue];
            if(nwCount==1){
                NSMutableDictionary *dictPaymentDict=[[NSMutableDictionary alloc] init];
                [dictPaymentDict setObject:@"YES" forKey:kControllerConnectedStatus];
                [dictPaymentDict setObject:@"YES" forKey:kControllerPaymentCard];
                [dictPaymentDict setObject:@"YES" forKey:kControllerPaymentCompleted];
                [defaultsCellular setObject:dictPaymentDict forKey:@"NETWORKPAYMENTDATAS"];
                [defaultsCellular synchronize];
            }
            
            
            [self stop_PinWheel_Cellular];
        }else{
            [self stop_PinWheel_Cellular];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
} */

-(void)response_AddCreditCard_Details
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            NSLog(@"DICT credit card ID ==%@",[[dicitData objectForKey:@"id"] stringValue]);
            
            //new code
            self.btn_PencilCardName.hidden=YES;
            self.btn_PencilCard.hidden=YES;
            //
            
            // strCreditCardID=[dicitData objectForKey:@"id"];
            strCredit_Card_Updated_Status=@"YES";
            self.viewChargeCardSmall.hidden=YES;
            self.btn_TC.hidden=YES;
            self.view_Billing_Proceed.hidden=NO;
            self.view_Billing_Cancel.hidden=NO;
            
            //Check netowrk count
            
            defaultsCellular=[NSUserDefaults standardUserDefaults];
            NSLog(@"network count is ==%@",[defaultsCellular objectForKey:@"NETWORKCOUNT"]);
            int nwCount=[[defaultsCellular objectForKey:@"NETWORKCOUNT"] intValue];
            if(nwCount==1){
                NSMutableDictionary *dictPaymentDict=[[NSMutableDictionary alloc] init];
                [dictPaymentDict setObject:@"YES" forKey:kControllerConnectedStatus];
                [dictPaymentDict setObject:@"YES" forKey:kControllerPaymentCard];
                [dictPaymentDict setObject:@"YES" forKey:kControllerPaymentCompleted];
                [defaultsCellular setObject:dictPaymentDict forKey:@"NETWORKPAYMENTDATAS"];
                [defaultsCellular synchronize];
            }
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strNetworkAddedStatus=@"YES";
            if([str_MultipleNetwork_Mode isEqualToString:@"edit"]){
                appDelegate.strPaymentActive=@"YES";
            }
            [self stop_PinWheel_Cellular];
        }else{
            [self stop_PinWheel_Cellular];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)response_UpdateCreditCard_Details
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            self.viewChargeCardSmall.hidden=YES;
            self.btn_TC.hidden=YES;
            self.view_Billing_Proceed.hidden=NO;
            self.view_Billing_Cancel.hidden=NO;
            [self stop_PinWheel_Cellular];
        }else{
            [self stop_PinWheel_Cellular];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)deleteCellularNetwork_NOID
{
    
    ///accounts/1001/networks/1007/controllers/1002/devices?deviceId=1001
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[[appDelegate.dict_NetworkControllerDatas valueForKey:@"id"] stringValue]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsCellular=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsCellular objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks?networkId=%@",[defaultsCellular objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Network Delete==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(parse_Delete_CellularNetwork_Details) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Network Delete ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Cellular) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedCellularController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorDELETE:strMethodNameWith_Value];
}

-(void)parse_Delete_CellularNetwork_Details
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strNetworkAddedStatus=@"YES";
            appDelegate.strEdit_Controller_DeviceStatus=@"";
            appDelegate.strOwnerNetwork_Status=@"";
            defaultsCellular=[NSUserDefaults standardUserDefaults];
            [defaultsCellular setObject:@"YES" forKey:@"MPNETWORKLOADSTATUS"];
//            if([strCellularAccessType isEqualToString:@"0"]){
                NSLog(@"network count is ==%@",[defaultsCellular objectForKey:@"NETWORKCOUNT"]);
                int nwCount=[[defaultsCellular objectForKey:@"NETWORKCOUNT"] intValue];
                nwCount=nwCount-1;
                [defaultsCellular setObject:[NSString stringWithFormat:@"%d",nwCount] forKey:@"NETWORKCOUNT"];
                [defaultsCellular synchronize];
//            }
            [self stop_PinWheel_Cellular];
            if([appDelegate.strController_Setup_Mode isEqualToString: @"MultipleNetwork"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([appDelegate.strController_Setup_Mode isEqualToString: @"NetworkHomeDrawer"])
            {
                MultipleNetworkViewController *MNVC = [[MultipleNetworkViewController alloc] initWithNibName:@"MultipleNetworkViewController" bundle:nil];
                MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                NSArray *newStack = @[MNVC];
                [self.navigationController setViewControllers:newStack animated:YES];
            }
        }else{
            [self stop_PinWheel_Cellular];
            if([responseMessage isEqualToString:@"ACCT_CONTROLLER_MIN_LIMIT_REACHED"])
            {
                strControllerDelete=@"YES";
                [btn_PlanCharge setTitle:@"PROCEED" forState:UIControlStateNormal];
                self.lbl_PlanUpgrade_Qute.text=@"WHEN DELETING THIS HUB, YOUR PLAN WILL BE AUTOMATICALLY DOWNGRADED TO THE PREVIOUS TIER.";
                [self.viewAlert_PlanUpgrade setHidden:NO];
                [self popup_Cellular_Alpha_Disabled];
                return;
            }
            else if([responseMessage isEqualToString:@"ACCT_CONTROLLER_PLAN_EXIT"]) //Plan Exit
            {
                strControllerDelete=@"YES";
                planExitStatus=@"YES";
                [btn_PlanCharge setTitle:@"PROCEED" forState:UIControlStateNormal];
                self.lbl_PlanUpgrade_Charge.text=@"YOUR SUBSCRIPTION WILL BE CLOSED. DO YOU WANT TO PROCEED?";
                strprorationTime=@"0";
                [self.viewAlert_PlanUpgrade_Confirmation setHidden:NO];
                [self popup_Cellular_Alpha_Disabled];
                return;
            }

            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)tc_Noid_UserService_Cellular
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=@"/terms_conditions";
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Get T and C details ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseTCDetails_Cellular) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Get T and C details ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Cellular) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedCellularController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
-(void)responseTCDetails_Cellular
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            txtView_TermsAndCond.text=[dicitData valueForKey:@"message"];
            txtView_TermsAndCond.scrollsToTop=NO;
            [self stop_PinWheel_Cellular];
            [self.view_Info_TC setHidden:NO];
            [self popup_Cellular_Alpha_Disabled];
        }else{
            [self stop_PinWheel_Cellular];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)sendGridEmail_Noid_UserService_Cellular
{
    NSLog(@"email id ==%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"MAILID"]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictTC=[[NSMutableDictionary alloc] init];
    [dictTC setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"MAILID"] forKey:kEmailID];
    [dictTC setObject:@"terms_conditions" forKey:kEmailType];
    
    parameters=[SCM sendGridMailTC:dictTC];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for TC Send Grid==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseSendGridTC_Cellular) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for TC Send Grid==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Cellular) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedCellularController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:TC_Method_Name];
}

-(void)responseSendGridTC_Cellular
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self stop_PinWheel_Cellular];
        }else{
            [self stop_PinWheel_Cellular];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
-(void)quoteForAdditionalController
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsCellular=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsCellular objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=@"";
    if(![strControllerDelete isEqualToString:@"YES"]) //Upgrade quote
    {
        strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/billing/planQuote?quoteTypeId=1&deviceTypeId=1",[defaultsCellular objectForKey:@"ACCOUNTID"]];
    }
    else{  //Downgrade quote
        strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/billing/planQuote?quoteTypeId=2&deviceTypeId=1&controllerId=%@",[defaultsCellular objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];
    }
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Quote details ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseForQuotePlanUpgrade) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Quote details ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Cellular) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedCellularController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
/*
-(void)responseForQuotePlanUpgrade
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
                Amount = remAmt/100;
                NSLog(@"remAmount =%f",Amount);
                
                if(![strControllerDelete isEqualToString:@"YES"]) //upgrade
                {
                    self.lbl_PlanUpgrade_Charge.text=[NSString stringWithFormat:@"YOU WILL BE AUTOMATICALLY CHARGED $%.2f FOR THE %@.",Amount,[[[responseDict valueForKey:@"data"] objectForKey:@"billingPlan"] objectForKey:@"billingPlanName"]];
                }else{
                    self.lbl_PlanUpgrade_Charge.text=[NSString stringWithFormat:@"PLEASE NOTE THAT YOUR AMOUNT $%.2f WILL BE REFUNDED AND YOUR PLAN WILL BE DOWNGRADED.",Amount];
                    [btn_PlanCharge setTitle:@"PROCEED" forState:UIControlStateNormal];
                }
                
                [self.viewAlert_PlanUpgrade setHidden:YES];
                [self.viewAlert_PlanUpgrade_Confirmation setHidden:NO];
            }else{
                [self.viewAlert_PlanUpgrade setHidden:YES];
                [self.viewAlert_PlanUpgrade_Confirmation setHidden:NO];
            }
            NSLog(@"billing plan name==%@",[[[responseDict valueForKey:@"data"] objectForKey:@"billingPlan"] objectForKey:@"billingPlanName"]);
            NSLog(@"Time == %@",[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"prorationDateTime"]);
            strprorationTime=[[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"prorationDateTime"] stringValue];
            [self stop_PinWheel_Cellular];
            [self popup_Cellular_Alpha_Disabled];
        }else{
            [self stop_PinWheel_Cellular];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
 */

-(void)responseForQuotePlanUpgrade
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
                
                self.lbl_PlanUpgrade_Charge.text=[NSString stringWithFormat:@"PLEASE NOTE THAT YOUR SUBSCRIPTION WILL CLOSED"];
                
                NSLog(@"plan exit date == %@",[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"planExitDate"]);
                strprorationTime=[[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"planExitDate"] stringValue];
                [self stop_PinWheel_Cellular];
                [self.viewAlert_PlanUpgrade setHidden:YES];
                [self.viewAlert_PlanUpgrade_Confirmation setHidden:NO];
                [self popup_Cellular_Alpha_Disabled];
            }
            else if([[[responseDict valueForKey:@"data"] objectForKey:@"billingQuoteType"] isEqualToString:@"planStart"])
            {
                self.lbl_PlanUpgrade_Charge.text=[NSString stringWithFormat:@"PLEASE NOTE THAT YOUR SUBSCRIPTION WILL START"];
                
                //NSLog(@"plan exit date == %@",[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"planExitDate"]);
                strprorationTime=@"0";
                [self stop_PinWheel_Cellular];
                [self.viewAlert_PlanUpgrade setHidden:YES];
                [self.viewAlert_PlanUpgrade_Confirmation setHidden:NO];
                [self popup_Cellular_Alpha_Disabled];
            }
            else{  //plan change
                NSArray *arrPlanQuote;
                arrPlanQuote = [[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"lineItems"];
                NSLog(@"%@",arrPlanQuote);
                if([arrPlanQuote count]>=2)
                {
                    NSLog(@"Amount == %@",[[arrPlanQuote objectAtIndex:0] objectForKey:@"amount"]);
                    NSLog(@"Amount == %@",[[arrPlanQuote objectAtIndex:1] objectForKey:@"amount"]);
                    float remAmt=[[[arrPlanQuote objectAtIndex:0] objectForKey:@"amount"] floatValue]+[[[arrPlanQuote objectAtIndex:1] objectForKey:@"amount"] floatValue];
                    NSLog(@"remAmount =%f",remAmt);
                    Amount = fabs(remAmt/100);
                    NSLog(@"remAmount =%f",Amount);
                    
                    if(![strControllerDelete isEqualToString:@"YES"]) //upgrade
                    {
                        self.lbl_PlanUpgrade_Charge.text=[NSString stringWithFormat:@"YOU WILL BE AUTOMATICALLY CHARGED $%.2f FOR THE PLAN %@.",Amount,[[[responseDict valueForKey:@"data"] objectForKey:@"billingPlan"] objectForKey:@"billingPlanName"]];
                    }else{
                        //Please note that your amount $99.99 will be refunded and your plan will be downgraded
                        //[[[responseDict valueForKey:@"data"] objectForKey:@"billingPlan"] objectForKey:@"billingPlanName"]
                        self.lbl_PlanUpgrade_Charge.text=[NSString stringWithFormat:@"PLEASE NOTE THAT YOUR AMOUNT $%.2f WILL BE REFUNDED AND YOUR PLAN WILL BE DOWNGRADED.",Amount];
                    }
                    [self stop_PinWheel_Cellular];
                    [self.viewAlert_PlanUpgrade setHidden:YES];
                    [self.viewAlert_PlanUpgrade_Confirmation setHidden:NO];
                }else{
                    [self stop_PinWheel_Cellular];
                    [self.viewAlert_PlanUpgrade setHidden:YES];
                    [self.viewAlert_PlanUpgrade_Confirmation setHidden:NO];
                }
                NSLog(@"billing plan name==%@",[[[responseDict valueForKey:@"data"] objectForKey:@"billingPlan"] objectForKey:@"billingPlanName"]);
                NSLog(@"Time == %@",[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"prorationDateTime"]);
                strprorationTime=[[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"prorationDateTime"] stringValue];
                
                [self popup_Cellular_Alpha_Disabled];
            }
            
        }else{
            [self stop_PinWheel_Cellular];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
-(void)quoteForDowngradeControllerConfirmation
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    defaultsCellular=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsCellular objectForKey:@"ACCOUNTID"]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodName=[NSString stringWithFormat:@"/accounts/%@/billing/planChange",[defaultsCellular objectForKey:@"ACCOUNTID"]];
    
    NSMutableDictionary *dict_Plan=[[NSMutableDictionary alloc] init];
    [dict_Plan setObject:@"2" forKey:kquoteTypeId];
    [dict_Plan setObject:@"1" forKey:kdeviceTypeId];
    [dict_Plan setObject:[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID] forKey:kControllerID];
    [dict_Plan setObject:strprorationTime forKey:kprorationDateTime];
    
    parameters=[SCM downgrade_Plan:dict_Plan];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for upgrade plan ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseDownGradePlanController) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for upgrade plan ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Cellular) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedCellularController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodName];
}
-(void)quoteForAdditionalControllerConfirmation
{
    defaultsCellular=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsCellular objectForKey:@"ACCOUNTID"]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodName=[NSString stringWithFormat:@"/accounts/%@/billing/planChange",[defaultsCellular objectForKey:@"ACCOUNTID"]];
    
    NSMutableDictionary *dict_Plan=[[NSMutableDictionary alloc] init];
    [dict_Plan setObject:@"1" forKey:kquoteTypeId];
    [dict_Plan setObject:@"1" forKey:kdeviceTypeId];
    [dict_Plan setObject:strprorationTime forKey:kprorationDateTime];
    
    parameters=[SCM upgrade_Plan:dict_Plan];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for upgrade plan ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseUpgradePlanController) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for upgrade plan ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Cellular) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedCellularController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodName];
}

-(void)responseUpgradePlanController
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            strChargeMyCard=@"YES";
            dictController_BasicPlan = [[responseDict valueForKey:@"data"] objectForKey:@"billingPlan"];
            if([[[responseDict valueForKey:@"data"] objectForKey:@"billingQuoteType"] isEqualToString:@"planStart"])
            {
                float remAmt=[[[[responseDict valueForKey:@"data"] objectForKey:@"billingNewPlan"] objectForKey:@"planAmount"] floatValue];
                Amount = fabs(remAmt/100);
            }else{
                float remAmt=[[[responseDict valueForKey:@"data"] objectForKey:@"total"] floatValue];
                Amount = fabs(remAmt/100);
            }
            NSLog(@"remAmount =%f",Amount);
            [self stop_PinWheel_Cellular];
            [self.viewAlert_PlanUpgrade_Confirmation setHidden:YES];
            [self popup_Cellular_Alpha_Enabled];

            [self performSelectorOnMainThread:@selector(start_PinWheel_Cellular) withObject:self waitUntilDone:YES];
            if(![strNetwork_Added_Status isEqualToString:@"YES"]){
                [self performSelectorInBackground:@selector(create_Modify_Cellular_Controller_Noid_Service) withObject:self];
            }else{
                [self performSelectorInBackground:@selector(update_Modify_Cellular_Controller_Noid_Service) withObject:self];
            }
        }else{
            [self stop_PinWheel_Cellular];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
    
}
-(void)responseDownGradePlanController
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            strTimeZoneIDFor_User=[[responseDict valueForKey:@"data"] objectForKey:@"timeZoneId"];
            [self.viewAlert_PlanUpgrade_Confirmation setHidden:YES];
            [self popup_Cellular_Alpha_Enabled];
            [self stop_PinWheel_Cellular];
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strNetworkAddedStatus=@"YES";
            appDelegate.strEdit_Controller_DeviceStatus=@"";
            appDelegate.strOwnerNetwork_Status=@"";
            defaultsCellular=[NSUserDefaults standardUserDefaults];
            [defaultsCellular setObject:@"YES" forKey:@"MPNETWORKLOADSTATUS"];
            if([strCellularAccessType isEqualToString:@"0"]){
                NSLog(@"network count is ==%@",[defaultsCellular objectForKey:@"NETWORKCOUNT"]);
                int nwCount=[[defaultsCellular objectForKey:@"NETWORKCOUNT"] intValue];
                nwCount=nwCount-1;
                [defaultsCellular setObject:[NSString stringWithFormat:@"%d",nwCount] forKey:@"NETWORKCOUNT"];
                [defaultsCellular synchronize];
            }
            if([planExitStatus isEqualToString:@"YES"])
            {
                UIAlertView *alertDelete_Controller = [[UIAlertView alloc] initWithTitle:@"" message:@"YOUR SUBSCRIPTION IS CLOSED"
                                                                                delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertDelete_Controller setTag:5];
                [alertDelete_Controller show];
                
                return;
            }
            if([appDelegate.strController_Setup_Mode isEqualToString: @"MultipleNetwork"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([appDelegate.strController_Setup_Mode isEqualToString: @"NetworkHomeDrawer"])
            {
                MultipleNetworkViewController *MNVC = [[MultipleNetworkViewController alloc] initWithNibName:@"MultipleNetworkViewController" bundle:nil];
                MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                NSArray *newStack = @[MNVC];
                [self.navigationController setViewControllers:newStack animated:YES];
            }
        }else{
            [self stop_PinWheel_Cellular];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Cellular];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

#pragma mark - Mail
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==5)
    {
        if([appDelegate.strController_Setup_Mode isEqualToString: @"MultipleNetwork"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if ([appDelegate.strController_Setup_Mode isEqualToString: @"NetworkHomeDrawer"])
        {
            MultipleNetworkViewController *MNVC = [[MultipleNetworkViewController alloc] initWithNibName:@"MultipleNetworkViewController" bundle:nil];
            MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
            NSArray *newStack = @[MNVC];
            [self.navigationController setViewControllers:newStack animated:YES];
        }
        
    }
    
}
-(void)open_emailView_Cellular_OnTap:(UIButton*)sender
{
    NSLog(@"%@",sender.currentTitle);
    if ([sender.currentTitle isEqualToString:@"Email for Pricing"]) {
        NSLog(@"mail");
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
            // case m
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
