//
//  SprinklerDeviceSetupViewController.m
//  NOID
//
//  Created by Karthik on 8/18/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "SprinklerDeviceSetupViewController.h"
#import "SettingsViewController.h"
#import "AddSprinklerScheldule.h"
#import "NetworkHomeViewController.h"
#import "SWRevealViewController.h"
#import "TimeLineViewController.h"
#import "Base64.h"
#import "Utils.h"
#import "ServiceConnectorModel.h"
#import "AFNetworking.h"

int zoneC;
#define kButtonIndex 1000

@interface SprinklerDeviceSetupViewController ()
{
    UIView *zoneView[kButtonIndex];
    UIView *zoneHeaderView[kButtonIndex];
    UIView *zoneBodyView;
    UILabel *lblZoneIndex[kButtonIndex];
    UILabel *lblZoneName[kButtonIndex];
    UILabel *lblZoneStatus[kButtonIndex];
    UIButton *btnZoneHeader[kButtonIndex];
}

@end

@implementation SprinklerDeviceSetupViewController

@synthesize delegate,scrollViewSprinkler,viewSprinkler_QR,viewSprinkler_QR_HeaderContent,viewSprinkler_QR_BodyContent,txtfld_DeviceId_SetUp,lblEdit_QR,footerView_Zone_Sprinkler,headerView,sliderView,bodyView,strDeviceType,commonView;
@synthesize commonCancelView,commonEditImageView,commonImageView,commonProceedView,imgViewZone,txtfld_DeviceName_SetUp,captureSession_SprinklerSetUp,videoPreviewLayer_SprinklerSetUp,audioPlayer_SprinklerSetUp,viewSprinklerSetUp_QRScanCode,bodyView_QRScan_SprinklerSetUp,viewAlert_PlanUpgrade_Confirm_Zone,viewAlert_PlanUpgrade_Zone,lbl_PlanUpgrade_Charge_Zone,btn_Charge_Zone;

#pragma mark - View LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self flagSetupSprinklers];
    [self sprinkler_Device_Setup_UIConfiguration];
    [self scrollView_Configuration_SprinklerSetup];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    NSMutableArray *viewStackArr=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSLog(@"Stack count %lu",(unsigned long)[viewStackArr count]);
    NSLog(@"stack List == %@",viewStackArr);
    [super viewWillAppear:animated];
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        NSLog(@"landscape");
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
    else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
        NSLog(@"portrait");
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }

     NSLog(@"devie id ==%@",strSprinkler_DeviceID);
}

-(void)flagSetupSprinklers
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation = @"";
    strZoneProceedStatus=@"";
    strActionType=@"";
    strVacationStatus=@"";
    strDeviceAdd_UpdateStatus=@"";
    self.commonView.hidden=YES;
    self.commonEditImageView.hidden=YES;
    strZoneUIStatus=@"NO";
    imageStatus=NO;
    strEncoded_ControllerImage=@"";
    self.footerView_Zone_Sprinkler.hidden=YES;
    
    txtfld_DeviceId_SetUp.delegate=self;
    txtfld_DeviceId_SetUp.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txtfld_DeviceId_SetUp.leftView = paddingView;
    txtfld_DeviceId_SetUp.leftViewMode = UITextFieldViewModeAlways;
    
    txtfld_DeviceName_SetUp.delegate=self;
    txtfld_DeviceName_SetUp.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *paddingViewNew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    [txtfld_DeviceName_SetUp setValue:lblRGBA(0, 0, 0, 1) forKeyPath:@"_placeholderLabel.textColor"];
    txtfld_DeviceName_SetUp.leftView = paddingViewNew;
    txtfld_DeviceName_SetUp.leftViewMode = UITextFieldViewModeAlways;
    
    strZone_Added_Status=@"";
    strSprinkler_DeviceID=@"";
    strAutoOpen_Status=@"";
    strServiceUpdate_Status=@"";

    bodyView_QRScan_SprinklerSetUp.hidden=YES;
    captureSession_SprinklerSetUp = nil;
    _isReading_SprinklerSetUp = NO;
    strZone_AddedStatus = @"";
    strVacationStatus=@"";
    
    viewAlert_PlanUpgrade_Zone.hidden=YES;
    viewAlert_PlanUpgrade_Confirm_Zone.hidden=YES;
  }
/*
 if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
 }
 else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
 }
 else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
 }
 */
-(void)parseSprinklerUI
{
    @try {
        int yAxis=self.viewSprinkler_QR.frame.origin.y+self.viewSprinkler_QR.frame.size.height+5;
        for(int index=0;index<zoneC;index++)
        {
            //zone Main View
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                zoneView[index]=[[UIView alloc] initWithFrame:CGRectMake(0,yAxis,self.view.frame.size.width,26)];
            }
            else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                zoneView[index]=[[UIView alloc] initWithFrame:CGRectMake(0,yAxis,self.view.frame.size.width,30)];
            }
            else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                zoneView[index]=[[UIView alloc] initWithFrame:CGRectMake(0,yAxis,self.view.frame.size.width,33)];
            }
            
            zoneView[index].backgroundColor=[UIColor clearColor];
            [self.scrollViewSprinkler addSubview:zoneView[index]];
            
            
            //Zone Header View
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                zoneHeaderView[index]=[[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,26)];
            }
            else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                zoneHeaderView[index]=[[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,30)];
            }
            else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                zoneHeaderView[index]=[[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,33)];
            }
            
            zoneHeaderView[index].backgroundColor=lblRGBA(128, 130, 133, 1);
            [zoneView[index] addSubview:zoneHeaderView[index]];
            
            //ZoneHeader Index
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblZoneIndex[index]=[[UILabel alloc] initWithFrame:CGRectMake(0,0,21,26)];
                lblZoneIndex[index].font=[UIFont fontWithName:@"NexaBold" size:12.0];
            }
            else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblZoneIndex[index]=[[UILabel alloc] initWithFrame:CGRectMake(0,0,25,30)];
                lblZoneIndex[index].font=[UIFont fontWithName:@"NexaBold" size:16.0];
            }
            else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblZoneIndex[index]=[[UILabel alloc] initWithFrame:CGRectMake(0,0,28,33)];
                lblZoneIndex[index].font=[UIFont fontWithName:@"NexaBold" size:17.0];
            }
            
            lblZoneIndex[index].text=[NSString stringWithFormat:@"%d",index+2];
            lblZoneIndex[index].textAlignment=NSTextAlignmentCenter;
            lblZoneIndex[index].backgroundColor=lblRGBA(135,197, 65, 1);
            lblZoneIndex[index].textColor=[UIColor whiteColor];
            [zoneHeaderView[index] addSubview:lblZoneIndex[index]];
            
            NSNumber *numberValue = [NSNumber numberWithInt:index+1]; //needs to be NSNumber!
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
            NSString *wordNumber = [[numberFormatter stringFromNumber:numberValue] uppercaseString];
            NSLog(@"Answer: %@", wordNumber);

            //ZoneHeader Name
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblZoneName[index]=[[UILabel alloc] initWithFrame:CGRectMake(34,0,149,26)];
                lblZoneName[index].font=[UIFont fontWithName:@"NexaBold" size:10.0];
            }
            else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblZoneName[index]=[[UILabel alloc] initWithFrame:CGRectMake(35,0,175,30)];
                lblZoneName[index].font=[UIFont fontWithName:@"NexaBold" size:11.0];
            }
            else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblZoneName[index]=[[UILabel alloc] initWithFrame:CGRectMake(39,0,236,33)];
                lblZoneName[index].font=[UIFont fontWithName:@"NexaBold" size:11.0];
            }
            
            if ([[[arrZoneDetails objectAtIndex:index] valueForKey:kZoneStatus] isEqualToString:@"IN_USE"]) {
                lblZoneName[index].text=[NSString stringWithFormat:@"ZONE %@ - %@",wordNumber,[[arrZoneDetails objectAtIndex:index] valueForKey:kDeviceName]];
            }else{
                lblZoneName[index].text=[NSString stringWithFormat:@"ZONE %@",wordNumber];
            }
            lblZoneName[index].textAlignment=NSTextAlignmentLeft;
            lblZoneName[index].backgroundColor=[UIColor clearColor];
            lblZoneName[index].textColor=[UIColor whiteColor];
            lblZoneName[index].numberOfLines=2;
            [zoneHeaderView[index] addSubview:lblZoneName[index]];
            
            //ZoneStatus
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblZoneStatus[index]=[[UILabel alloc] initWithFrame:CGRectMake(170,0,150,26)];
                lblZoneStatus[index].font=[UIFont fontWithName:@"NexaBold" size:10.0];
            }
            else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblZoneStatus[index]=[[UILabel alloc] initWithFrame:CGRectMake(200,0,175,30)];
                lblZoneStatus[index].font=[UIFont fontWithName:@"NexaBold" size:11.0];
            }
            else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblZoneStatus[index]=[[UILabel alloc] initWithFrame:CGRectMake(264,0,150,33)];
                lblZoneStatus[index].font=[UIFont fontWithName:@"NexaBold" size:11.0];
            }
            lblZoneStatus[index].textAlignment=NSTextAlignmentCenter;
            lblZoneStatus[index].backgroundColor=lblRGBA(98,99,102,1);
            lblZoneStatus[index].textColor=[UIColor whiteColor];
            [zoneHeaderView[index] addSubview:lblZoneStatus[index]];
            
            if ([[[arrZoneDetails objectAtIndex:index] valueForKey:kZoneConfigStatus] isEqualToString:@"1"]) {
                lblZoneStatus[index].text=@"ALREADY SET-UP";
            }
            else{
                lblZoneStatus[index].text=@"CONFIGURE NOW";
            }
            
            btnZoneHeader[index]=[UIButton buttonWithType:UIButtonTypeCustom];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btnZoneHeader[index].frame=CGRectMake(0, 0, self.view.frame.size.width, 26);
            }
            else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                btnZoneHeader[index].frame=CGRectMake(0, 0, self.view.frame.size.width, 30);
            }
            else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btnZoneHeader[index].frame=CGRectMake(0, 0, self.view.frame.size.width, 33);
            }
            
            [btnZoneHeader[index] addTarget:self action:@selector(zoneAction:) forControlEvents:UIControlEventTouchUpInside];
            [btnZoneHeader[index] setTag:index];
            [zoneHeaderView[index] addSubview:btnZoneHeader[index]];
            
            //        textVal=textVal+1;
            // yAxis=zoneView[index].frame.origin.y+zoneView[index].frame.size.height+5;
            if (([[[arrZoneDetails objectAtIndex:index] valueForKey:kZoneStatus] isEqualToString:@"NEW"]||[[[arrZoneDetails objectAtIndex:index] valueForKey:kZoneStatus] isEqualToString:@"UNCONFIGURED"])&& [strAutoOpen_Status isEqualToString:@""]) {
                zoneView[index].frame=CGRectMake(zoneView[index].frame.origin.x, zoneView[index].frame.origin.y,zoneView[index].frame.size.width, zoneView[index].frame.size.height+self.commonView.frame.size.height);
                zoneExpandStatus=NO;
                commonView.hidden=NO;
                commonImageView.hidden=NO;
                lblZoneStatus[index].hidden=YES;
                [self addZoneSubWidget:index];
                strAutoOpen_Status=@"YES";
            }
            //        if (index==0) {
            //            NSLog(@"height ==%f",self.commonView.frame.size.height);
            //            zoneView[index].frame=CGRectMake(zoneView[index].frame.origin.x, zoneView[index].frame.origin.y,zoneView[index].frame.size.width, zoneView[index].frame.size.height+self.commonView.frame.size.height);
            //            zoneExpandStatus=NO;
            //            commonView.hidden=NO;
            //            commonImageView.hidden=NO;
            //            lblZoneStatus[index].hidden=YES;
            //            [self addZoneSubWidget:index];
            //        }
            yAxis=zoneView[index].frame.origin.y+zoneView[index].frame.size.height+5;
        }
        strZoneUIStatus=@"YES";
        self.footerView_Zone_Sprinkler.frame=CGRectMake(self.footerView_Zone_Sprinkler.frame.origin.x, yAxis+20, self.footerView_Zone_Sprinkler.frame.size.width, self.footerView_Zone_Sprinkler.frame.size.height);
        [self scrollSprinklerSetup_ReSet_And_Changes];
        self.footerView_Zone_Sprinkler.hidden=NO;
    }
    @catch (NSException *exception) {
        NSLog(@"ecep==%@",exception.description);
        [Common showAlert:@"warning" withMessage:exception.description];
    }
    
    [self stop_PinWheel_Sprinkler_AddDevice];
}
-(void)open_ZoneAuto:(int)tagpos
{
    [self check_Sprinkler_TapAlreadyOpenedOrNot];
    [self check_SprinklerSetup_WidgetDismissORNot];
    NSLog(@"sender tag ==%d",tagpos);
    self.view.userInteractionEnabled=NO;
    //int indexVal=sender.tag+1;
    @try {
        if (zoneExpandStatus==YES) {
            NSLog(@"height ==%f",self.commonView.frame.size.height);
            [self addZoneSubWidget:tagpos];
            [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                NSLog(@"%f",zoneView[tagpos].frame.size.height);
                if (imageStatus==NO) {
                    zoneView[tagpos].frame=CGRectMake(zoneView[tagpos].frame.origin.x, zoneView[tagpos].frame.origin.y,zoneView[tagpos].frame.size.width, zoneView[tagpos].frame.size.height+self.commonView.frame.size.height);
                    int yAxis=zoneView[tagpos].frame.origin.y+zoneView[tagpos].frame.size.height+5;
                    for(int index=tagpos+1;index<zoneC;index++)
                    {
                        zoneView[index].frame=CGRectMake(zoneView[index].frame.origin.x, yAxis, zoneView[index].frame.size.width, zoneView[index].frame.size.height);
                        yAxis=zoneView[index].frame.origin.y+zoneView[index].frame.size.height+5;
                    }
                    self.footerView_Zone_Sprinkler.frame=CGRectMake(self.footerView_Zone_Sprinkler.frame.origin.x, yAxis+20, self.footerView_Zone_Sprinkler.frame.size.width, self.footerView_Zone_Sprinkler.frame.size.height);
                    [self scrollSprinklerSetup_ReSet_And_Changes];
                }
            } completion:^(BOOL finished) {
                lblZoneStatus[tagpos].hidden=YES;
                zoneExpandStatus=NO;
                // lblEdit_QR.hidden=NO;
                commonView.hidden=NO;
                self.view.userInteractionEnabled=YES;
            }];
        }
        else{
            if(tagpos==tag_Pos)
            {
                [self collapse_ZoneView];
            }else
            {
                self.commonView.hidden=YES;
                self.commonEditImageView.hidden=YES;
               // [self dumbTempDataZone];
                [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    //Remove first prev view
                    if(imageStatus==YES)
                    {
                        self.commonProceedView.frame=CGRectMake(self.commonProceedView.frame.origin.x, self.commonImageView.frame.origin.y+self.commonImageView.frame.size.height+5, self.commonProceedView.frame.size.width, self.commonProceedView.frame.size.height);
                        self.commonCancelView.frame=CGRectMake(self.commonCancelView.frame.origin.x, self.commonImageView.frame.origin.y+self.commonImageView.frame.size.height+5, self.commonCancelView.frame.size.width, self.commonCancelView.frame.size.height);
                        self.commonView.frame=CGRectMake(self.commonView.frame.origin.x, self.commonView.frame.origin.y, self.commonView.frame.size.width,self.commonCancelView.frame.origin.y+self.commonCancelView.frame.size.height+5);
                        self.commonImageView.hidden=NO;
                        imageStatus=NO;
                        strEncoded_ControllerImage=@"";
                        imgViewZone.image=nil;
                    }
                    zoneView[tag_Pos].frame=CGRectMake(zoneView[tag_Pos].frame.origin.x, zoneView[tag_Pos].frame.origin.y,zoneView[tag_Pos].frame.size.width, zoneHeaderView[tag_Pos].frame.size.height);
                    int yAxis=zoneView[tag_Pos].frame.origin.y+zoneView[tag_Pos].frame.size.height+5;
                    lblZoneStatus[tag_Pos].hidden=NO;
                    for(int index=tag_Pos+1;index<zoneC;index++)
                    {
                        zoneView[index].frame=CGRectMake(zoneView[index].frame.origin.x, yAxis, zoneView[index].frame.size.width, zoneView[index].frame.size.height);
                        yAxis=zoneView[index].frame.origin.y+zoneView[index].frame.size.height+5;
                    }
                    
                    //expand new view
                    
                    [self addZoneSubWidget:tagpos];
                    if (imageStatus==NO) {
                        zoneView[tagpos].frame=CGRectMake(zoneView[tagpos].frame.origin.x, zoneView[tagpos].frame.origin.y,zoneView[tagpos].frame.size.width, zoneView[tagpos].frame.size.height+self.commonView.frame.size.height);
                        yAxis=zoneView[tagpos].frame.origin.y+zoneView[tagpos].frame.size.height+5;
                        for(int index=tagpos+1;index<zoneC;index++)
                        {
                            zoneView[index].frame=CGRectMake(zoneView[index].frame.origin.x, yAxis, zoneView[index].frame.size.width, zoneView[index].frame.size.height);
                            yAxis=zoneView[index].frame.origin.y+zoneView[index].frame.size.height+5;
                        }
                        
                        self.footerView_Zone_Sprinkler.frame=CGRectMake(self.footerView_Zone_Sprinkler.frame.origin.x, yAxis+20, self.footerView_Zone_Sprinkler.frame.size.width, self.footerView_Zone_Sprinkler.frame.size.height);
                        [self scrollSprinklerSetup_ReSet_And_Changes];
                    }
                } completion:^(BOOL finished) {
                    lblZoneStatus[tagpos].hidden=YES;
                    self.view.userInteractionEnabled=YES;
                    zoneExpandStatus=NO;
                    commonView.hidden=NO;
                }];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"expandable exception==%@",exception.description);
    }
}
-(void)zoneAction:(UIButton *)sender
{
    NSLog(@"sender tag ==%ld",(long)sender.tag);
    [self open_ZoneAuto:(int)sender.tag];
}

-(void)addZoneSubWidget:(int)tag
{
    @try {
        tag_Pos=tag;
        txtfld_DeviceName_SetUp.text = [[arrZoneDetails objectAtIndex:tag_Pos] valueForKey:kDeviceName];
        strEncoded_ControllerImage = [[arrZoneDetails objectAtIndex:tag_Pos] valueForKey:kDeviceImage];
        if (![strEncoded_ControllerImage isEqualToString:@""]) {
            imageStatus=YES;
            imgViewZone.image = [UIImage imageWithData:[Base64 decode:[[arrZoneDetails objectAtIndex:tag_Pos] valueForKey:kDeviceImage]]];
            [self changeCommonView];
        }else{
            imageStatus=NO;
            commonImageView.hidden=NO;
        }
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            self.commonView.frame=CGRectMake(self.commonView.frame.origin.x, 26, self.commonView.frame.size.width, self.commonView.frame.size.height);
        }
        else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            self.commonView.frame=CGRectMake(self.commonView.frame.origin.x, 30, self.commonView.frame.size.width, self.commonView.frame.size.height);
        }
        else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            self.commonView.frame=CGRectMake(self.commonView.frame.origin.x, 33, self.commonView.frame.size.width, self.commonView.frame.size.height);
        }
        [zoneView[tag] addSubview:commonView];
    }@catch (NSException *exception) {
        NSLog(@"exception for user acc addnetwork==%@",exception.description);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  User Defined Action
-(void)sprinkler_Device_Setup_UIConfiguration
{
    txtfld_DeviceId_SetUp.delegate=self;
    //QRView SetUp
    lblEdit_QR.hidden=YES;
    sprinkler_QR_ExpandedStatus=NO;
    zoneExpandStatus=YES;
}

-(void)check_SprinklerSetup_WidgetDismissORNot{
    if([txtfld_DeviceId_SetUp resignFirstResponder]){
        [txtfld_DeviceId_SetUp resignFirstResponder];
    }else if([txtfld_DeviceName_SetUp resignFirstResponder]){
        [txtfld_DeviceName_SetUp resignFirstResponder];
    }
}
-(void)scrollView_Configuration_SprinklerSetup
{
    scrollViewSprinkler.showsHorizontalScrollIndicator=NO;
    scrollViewSprinkler.scrollEnabled=YES;
    scrollViewSprinkler.userInteractionEnabled=YES;
    scrollViewSprinkler.delegate=self;
    [self scrollSprinklerSetup_ReSet_And_Changes];
}

-(void)scrollSprinklerSetup_ReSet_And_Changes
{
    self.scrollViewSprinkler.contentSize=CGSizeMake(self.scrollViewSprinkler.frame.size.width, self.footerView_Zone_Sprinkler.frame.origin.y+self.footerView_Zone_Sprinkler.frame.size.height+20);
}
-(void)check_Sprinkler_TapAlreadyOpenedOrNot{
    if (sprinkler_QR_ExpandedStatus==NO) {
        [self collapse_Sprinkler_QR_View];
    }
}


-(void)dumbTempDataZone
{
    if (![[[arrZoneDetails objectAtIndex:tag_Pos] valueForKey:kZoneStatus] isEqualToString:@"IN_USE"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:txtfld_DeviceName_SetUp.text  forKey:kDeviceName];
        [dict setObject:strEncoded_ControllerImage forKey:kDeviceImage];
        [dict setObject:[[arrZoneDetails objectAtIndex:tag_Pos] valueForKey:kZoneID] forKey:kZoneID];
        [dict setObject:[[arrZoneDetails objectAtIndex:tag_Pos] valueForKey:kZoneLevel] forKey:kZoneLevel];
        [dict setObject:[[arrZoneDetails objectAtIndex:tag_Pos] valueForKey:kZoneStatus] forKey:kZoneStatus];
        [dict setObject:[[arrZoneDetails objectAtIndex:tag_Pos] valueForKey:kZoneConfigStatus] forKey:kZoneConfigStatus];
        [arrZoneDetails replaceObjectAtIndex:tag_Pos withObject:dict];
    }
}

-(void)collapse_ZoneView
{
    self.commonView.hidden=YES;
    self.commonEditImageView.hidden=YES;
    NSLog(@"%d",tag_Pos);
    //[self dumbTempDataZone];
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if(imageStatus==YES)
        {
            self.commonProceedView.frame=CGRectMake(self.commonProceedView.frame.origin.x, self.commonImageView.frame.origin.y+self.commonImageView.frame.size.height+5, self.commonProceedView.frame.size.width, self.commonProceedView.frame.size.height);
            self.commonCancelView.frame=CGRectMake(self.commonCancelView.frame.origin.x, self.commonImageView.frame.origin.y+self.commonImageView.frame.size.height+5, self.commonCancelView.frame.size.width, self.commonCancelView.frame.size.height);
            self.commonView.frame=CGRectMake(self.commonView.frame.origin.x, self.commonView.frame.origin.y, self.commonView.frame.size.width,self.commonCancelView.frame.origin.y+self.commonCancelView.frame.size.height+5);
            self.commonImageView.hidden=NO;
        }
        zoneView[tag_Pos].frame=CGRectMake(zoneView[tag_Pos].frame.origin.x, zoneView[tag_Pos].frame.origin.y,zoneView[tag_Pos].frame.size.width, zoneHeaderView[tag_Pos].frame.size.height);
        int yAxis=zoneView[tag_Pos].frame.origin.y+zoneView[tag_Pos].frame.size.height+5;
        for(int index=tag_Pos+1;index<zoneC;index++)
        {
            zoneView[index].frame=CGRectMake(zoneView[index].frame.origin.x, yAxis, zoneView[index].frame.size.width, zoneView[index].frame.size.height);
            yAxis=zoneView[index].frame.origin.y+zoneView[index].frame.size.height+5;
        }
        self.footerView_Zone_Sprinkler.frame=CGRectMake(self.footerView_Zone_Sprinkler.frame.origin.x, yAxis+20, self.footerView_Zone_Sprinkler.frame.size.width, self.footerView_Zone_Sprinkler.frame.size.height);
        [self scrollSprinklerSetup_ReSet_And_Changes];
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled=YES;
        lblZoneStatus[tag_Pos].hidden=NO;
        zoneExpandStatus=YES;
        strEncoded_ControllerImage=@"";
        self.txtfld_DeviceName_SetUp.text=@"";
        imgViewZone.image=nil;
        imageStatus=NO;
        if([strServiceUpdate_Status isEqualToString:@"YES"])
        {
            if(tag_Pos+1==zoneC)
            {
                strServiceUpdate_Status=@"";
                return;
            }
            [self open_ZoneAuto:tag_Pos+1];
            strServiceUpdate_Status=@"";
        }
    }];
}
-(void)collapse_Sprinkler_QR_View
{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewSprinkler_QR_BodyContent.hidden=YES;
        self.viewSprinkler_QR.frame=CGRectMake(self.viewSprinkler_QR.frame.origin.x, self.viewSprinkler_QR.frame.origin.y, self.viewSprinkler_QR.frame.size.width, self.viewSprinkler_QR_HeaderContent.frame.size.height);
        [self changeZonePositions];
    } completion:^(BOOL finished) {
        sprinkler_QR_ExpandedStatus=YES;
        lblEdit_QR.hidden=NO;
        self.view.userInteractionEnabled=YES;
    }];
}
-(void)changeZonePositions
{
    int yAxis=self.viewSprinkler_QR.frame.origin.y+self.viewSprinkler_QR.frame.size.height+5;
    for(int index=0;index<zoneC;index++)
    {
        zoneView[index].frame=CGRectMake(zoneView[index].frame.origin.x, yAxis, zoneView[index].frame.size.width, zoneView[index].frame.size.height);
        yAxis=zoneView[index].frame.origin.y+zoneView[index].frame.size.height+5;
    }
    self.footerView_Zone_Sprinkler.frame=CGRectMake(self.footerView_Zone_Sprinkler.frame.origin.x, yAxis+5, self.footerView_Zone_Sprinkler.frame.size.width, self.footerView_Zone_Sprinkler.frame.size.height);
    [self scrollSprinklerSetup_ReSet_And_Changes];
}

-(void)expand_SprinklerQR_View{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewSprinkler_QR.frame=CGRectMake(self.viewSprinkler_QR.frame.origin.x, self.viewSprinkler_QR.frame.origin.y, self.viewSprinkler_QR.frame.size.width, self.viewSprinkler_QR_BodyContent.frame.origin.y+self.viewSprinkler_QR_BodyContent.frame.size.height);
        [self changeZonePositions];
        lblEdit_QR.hidden=YES;
    } completion:^(BOOL finished) {
        self.viewSprinkler_QR_BodyContent.hidden=NO;
        sprinkler_QR_ExpandedStatus=NO;
        self.view.userInteractionEnabled=YES;
    }];
}
-(void)processCompleteSprinklerSetUp{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strDevice_Added_Status isEqualToString:@"OLDPOPUPLOAD"])
    {
        appDelegate.strDevice_Added_Status=@"REMOVEPOPUPLOAD";
    }
    [[self delegate] processSuccessful_Back_To_NetworkHome_Via_SprinklerDeviceSetUp:YES];
    [Common viewFadeIn:self.navigationController.view];
    [self.navigationController popViewControllerAnimated:NO];

}

-(void)loadZoneView
{
//    if(![strZoneUIStatus isEqualToString:@"NO"])
//    {
//        for(int index=0;index<zoneC;index++)
//        {
//            [zoneView[index] removeFromSuperview];
//        }
//        self.footerView_Zone_Sprinkler.frame=CGRectMake(self.footerView_Zone_Sprinkler.frame.origin.x, self.viewSprinkler_QR.frame.origin.y+self.viewSprinkler_QR.frame.size.height+40, self.footerView_Zone_Sprinkler.frame.size.width, self.footerView_Zone_Sprinkler.frame.size.height);
//        [self scrollSprinklerSetup_ReSet_And_Changes];
//        [self.footerView_Zone_Sprinkler setHidden:YES];
//    }
    strZoneProceedStatus=@"YES";
    [self collapse_Sprinkler_QR_View];
    [self scrollSprinklerSetup_ReSet_And_Changes];
    [self parseSprinklerUI];
}

- (BOOL)startReading {
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    captureSession_SprinklerSetUp = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [captureSession_SprinklerSetUp addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureSession_SprinklerSetUp addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    videoPreviewLayer_SprinklerSetUp = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession_SprinklerSetUp];
    [videoPreviewLayer_SprinklerSetUp setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [videoPreviewLayer_SprinklerSetUp setFrame:viewSprinklerSetUp_QRScanCode.layer.bounds];
    [viewSprinklerSetUp_QRScanCode.layer addSublayer:videoPreviewLayer_SprinklerSetUp];
    bodyView_QRScan_SprinklerSetUp.hidden=NO;
    // Start video capture.
    [captureSession_SprinklerSetUp startRunning];
    return YES;
}

-(void)stopReading{
    [captureSession_SprinklerSetUp stopRunning];
    captureSession_SprinklerSetUp = nil;
    [videoPreviewLayer_SprinklerSetUp removeFromSuperlayer];
    txtfld_DeviceId_SetUp.text = strScanCode_SprinklerSetUp;
    bodyView_QRScan_SprinklerSetUp.hidden=YES;
}

-(void)popUp_ZoneSetUp_Alpha_Disabled
{
    [bodyView setAlpha:0.6];
    [headerView setAlpha:0.6];
}

-(void)popUp_ZoneSetUp_Alpha_Enabled
{
    [bodyView setAlpha:1.0];
    [headerView setAlpha:1.0];
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSLog(@"%@",[metadataObj stringValue]);
            strScanCode_SprinklerSetUp = [NSString stringWithFormat:@"%@",[metadataObj stringValue]];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            _isReading_SprinklerSetUp = NO;
            if (audioPlayer_SprinklerSetUp) {
                [audioPlayer_SprinklerSetUp play];
            }
        }
    }
}

#pragma mark - IBAction
-(IBAction)sprinkler_TapMenu_Action:(id)sender{
    self.view.userInteractionEnabled=NO;
    [self check_SprinklerSetup_WidgetDismissORNot];
    if (sprinkler_QR_ExpandedStatus==YES) {
        if(zoneExpandStatus==NO)
        {
            [self collapse_ZoneView];
        }
        [self check_Sprinkler_TapAlreadyOpenedOrNot];
        [self expand_SprinklerQR_View];
    }else{
        if(zoneExpandStatus==NO)
        {
            [self collapse_ZoneView];
        }
        [self collapse_Sprinkler_QR_View];
    }
    [self scrollSprinklerSetup_ReSet_And_Changes];
}

-(IBAction)sprinkler_QR_ButtonAction:(id)sender
{
    
    [self check_SprinklerSetup_WidgetDismissORNot];
    UIButton *btnTag = (UIButton *)sender;
    [sender setExclusiveTouch:YES];
    switch (btnTag.tag) {
        case 0: //Prceed QR Button
        {
            strZone_AddedStatus=@"";
            txtfld_DeviceId_SetUp.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceId_SetUp.text];
            if(txtfld_DeviceId_SetUp.text.length==0){
                [Common showAlert:@"Warning" withMessage:@"Please enter device id"];
                return;
            }
            if(![strZoneUIStatus isEqualToString:@"NO"])
            {
                for(int index=0;index<zoneC;index++)
                {
                    [zoneView[index] removeFromSuperview];
                }
                self.footerView_Zone_Sprinkler.frame=CGRectMake(self.footerView_Zone_Sprinkler.frame.origin.x, self.viewSprinkler_QR.frame.origin.y+self.viewSprinkler_QR.frame.size.height+40, self.footerView_Zone_Sprinkler.frame.size.width, self.footerView_Zone_Sprinkler.frame.size.height);
                [self scrollSprinklerSetup_ReSet_And_Changes];
                [self.footerView_Zone_Sprinkler setHidden:YES];
            }
            if([Common reachabilityChanged]==YES){
                strAutoOpen_Status=@"";
                [self performSelectorOnMainThread:@selector(start_PinWheel_Sprinkler_AddDevice) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(checkSprinkler_Device_Availabilty) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 1: //Cancel OR Button
        {
            [self collapse_Sprinkler_QR_View];
            [self scrollSprinklerSetup_ReSet_And_Changes];
            
        }
            break;
        case 2:
        {
            if (!_isReading_SprinklerSetUp) {
                if ([self startReading]) {
                    NSLog(@"scanning");
                }
            }
            else{
                [self stopReading];
                NSLog(@"stopped");
            }
            
            _isReading_SprinklerSetUp = !_isReading_SprinklerSetUp;
        }
            break;
    }
}

-(IBAction)sprinkler_Zone_Action:(id)sender
{
    [self check_SprinklerSetup_WidgetDismissORNot];
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            //camera
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
        case 1: //Gallery
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;[self presentViewController:picker animated:YES completion:^{}];
        }
            break;
        case 2: //Edit
        {
            self.view.userInteractionEnabled=NO;
            [self resetCommonView];
            imageStatus=NO;
            strEncoded_ControllerImage=@"";
        }
            break;
        case 3: //proceed
        {
            txtfld_DeviceName_SetUp.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceName_SetUp.text];
            if(txtfld_DeviceName_SetUp.text.length==0){
                [Common showAlert:@"Warning" withMessage:@"Please enter zone name"];
                return;
            }
            
            NSString *strNameAlready_Exists=@"";
            for(int index=0;index<[arrZoneDetails count];index++)
            {
                if ([[[arrZoneDetails objectAtIndex:index] valueForKey:kDeviceName] isEqualToString:txtfld_DeviceName_SetUp.text]&&tag_Pos!=index) {
                    strNameAlready_Exists=@"YES";
                    break;
                }
            }
            if([strNameAlready_Exists isEqualToString:@"YES"])
            {
                [Common showAlert:@"Warning" withMessage:@"This Zone Name Already Exists"];
                return;
            }
            //
            NSMutableDictionary *dict_ZoneDetails = [[NSMutableDictionary alloc] init];
            [dict_ZoneDetails setObject:txtfld_DeviceName_SetUp.text  forKey:kDeviceName];
            [dict_ZoneDetails setObject:strEncoded_ControllerImage forKey:kDeviceImage];
            [dict_ZoneDetails setObject:[[arrZoneDetails objectAtIndex:tag_Pos] valueForKey:kZoneID] forKey:kZoneID];
            [dict_ZoneDetails setObject:[[arrZoneDetails objectAtIndex:tag_Pos] valueForKey:kZoneLevel] forKey:kZoneLevel];
            [dict_ZoneDetails setObject:@"IN_USE" forKey:kZoneStatus];
            [dict_ZoneDetails setObject:@"1" forKey:kZoneConfigStatus];
            [arrZoneDetails replaceObjectAtIndex:tag_Pos withObject:dict_ZoneDetails];
            NSLog(@"%@",arrZoneDetails);
            lblZoneStatus[tag_Pos].text=@"ALREADY SET-UP";
            
            NSNumber *numberValue = [NSNumber numberWithInt:tag_Pos+1];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
            NSString *wordNumber = [[numberFormatter stringFromNumber:numberValue] uppercaseString];
            NSLog(@"Answer: %@", wordNumber);
            lblZoneName[tag_Pos].text=[NSString stringWithFormat:@"ZONE %@ - %@",wordNumber,[[arrZoneDetails objectAtIndex:tag_Pos] valueForKey:kDeviceName]];
            
            strServiceUpdate_Status=@"YES";
            strZone_AddedStatus=@"YES";
            strDeviceAdd_UpdateStatus=@"YES";
            [self collapse_ZoneView];
        }
            break;
        case 4: //cancel
        {
            [self collapse_ZoneView];
        }
    }
}
-(void)resetCommonView
{
    self.imgViewZone.image=nil;
    strEncoded_ControllerImage=@"";
    imageStatus=NO;
    self.commonEditImageView.hidden=YES;
    self.commonImageView.hidden=NO;
    
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.commonProceedView.frame=CGRectMake(self.commonProceedView.frame.origin.x, self.commonImageView.frame.origin.y+self.commonImageView.frame.size.height+5, self.commonProceedView.frame.size.width, self.commonProceedView.frame.size.height);
        self.commonCancelView.frame=CGRectMake(self.commonCancelView.frame.origin.x, self.commonImageView.frame.origin.y+self.commonImageView.frame.size.height+5, self.commonCancelView.frame.size.width, self.commonCancelView.frame.size.height);
        self.commonView.frame=CGRectMake(self.commonView.frame.origin.x, self.commonView.frame.origin.y, self.commonView.frame.size.width,self.commonCancelView.frame.origin.y+self.commonCancelView.frame.size.height+5);
        zoneView[tag_Pos].frame=CGRectMake(zoneView[tag_Pos].frame.origin.x, zoneView[tag_Pos].frame.origin.y, zoneView[tag_Pos].frame.size.width, self.commonView.frame.size.height+zoneHeaderView[tag_Pos].frame.size.height);
        int yAxis=zoneView[tag_Pos].frame.origin.y+zoneView[tag_Pos].frame.size.height+5;
        for(int index=tag_Pos+1;index<zoneC;index++)
        {
            zoneView[index].frame=CGRectMake(zoneView[index].frame.origin.x, yAxis, zoneView[index].frame.size.width, zoneView[index].frame.size.height);
            yAxis=zoneView[index].frame.origin.y+zoneView[index].frame.size.height+5;
        }
        self.footerView_Zone_Sprinkler.frame=CGRectMake(self.footerView_Zone_Sprinkler.frame.origin.x, yAxis+10, self.footerView_Zone_Sprinkler.frame.size.width, self.footerView_Zone_Sprinkler.frame.size.height);
        [self scrollSprinklerSetup_ReSet_And_Changes];
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled=YES;
    }];
}

-(void)changeCommonView
{
    self.commonImageView.hidden=YES;
    self.commonEditImageView.hidden=NO;
    
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.commonProceedView.frame=CGRectMake(self.commonProceedView.frame.origin.x, self.commonEditImageView.frame.origin.y+self.commonEditImageView.frame.size.height+5, self.commonProceedView.frame.size.width, self.commonProceedView.frame.size.height);
        self.commonCancelView.frame=CGRectMake(self.commonCancelView.frame.origin.x, self.commonEditImageView.frame.origin.y+self.commonEditImageView.frame.size.height+5, self.commonCancelView.frame.size.width, self.commonCancelView.frame.size.height);
        self.commonView.frame=CGRectMake(self.commonView.frame.origin.x, self.commonView.frame.origin.y, self.commonView.frame.size.width,self.commonCancelView.frame.origin.y+self.commonCancelView.frame.size.height+5);
        zoneView[tag_Pos].frame=CGRectMake(zoneView[tag_Pos].frame.origin.x, zoneView[tag_Pos].frame.origin.y, zoneView[tag_Pos].frame.size.width, self.commonView.frame.size.height+zoneHeaderView[tag_Pos].frame.size.height);
        int yAxis=zoneView[tag_Pos].frame.origin.y+zoneView[tag_Pos].frame.size.height+5;
        for(int index=tag_Pos+1;index<zoneC;index++)
        {
            zoneView[index].frame=CGRectMake(zoneView[index].frame.origin.x, yAxis, zoneView[index].frame.size.width, zoneView[index].frame.size.height);
            yAxis=zoneView[index].frame.origin.y+zoneView[index].frame.size.height+5;
        }
        self.footerView_Zone_Sprinkler.frame=CGRectMake(self.footerView_Zone_Sprinkler.frame.origin.x, yAxis+10, self.footerView_Zone_Sprinkler.frame.size.width, self.footerView_Zone_Sprinkler.frame.size.height);
        [self scrollSprinklerSetup_ReSet_And_Changes];
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled=YES;
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==5)
    {
        if(buttonIndex==0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}
-(IBAction)settings_HomeNoid_SprinklerSetUp_Action:(id)sender
{
    [self check_SprinklerSetup_WidgetDismissORNot];
    UIButton *btnTag = (UIButton *)sender;
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    switch (btnTag.tag) {
        case 0:  //Back
        {
//            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//            NSLog(@"Str Device Added Mode ==%@",appDelegate.strDevice_Added_Mode);
//            if([appDelegate.strDevice_Added_Mode isEqualToString:@"NetworkHome"])
//            { //network home
//                if([strDeviceAdd_UpdateStatus isEqualToString:@"YES"])
//                {
//                    appDelegate.strDevice_Added_Status=@"OLDPOPUPLOAD";
//                    appDelegate.strAddedDevice_Type=self.strDeviceType;
//                }
//                [self.navigationController popViewControllerAnimated:YES];
//                //[self processComplete_LightOther_DeviceSetUp];
//            }else{
//                [self.navigationController popViewControllerAnimated:YES];
//            }
            if([strZoneProceedStatus isEqualToString:@"YES"])
            {
                UIAlertView *alertDelete_Controller = [[UIAlertView alloc] initWithTitle:kAlertTitleWarning message:@"You are configuring a device currently. You will lose the changes if you navigate"
                                                                                delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL", nil];
                [alertDelete_Controller setTag:5];
                [alertDelete_Controller show];
                return;
            }
            
            [self.navigationController popViewControllerAnimated:YES];

        }
            break;
        case 1:  //NoidLogo
        {
            if ([appDelegate.strNoidLogo isEqualToString:@"NetworkHome"]) {
                [self processCompleteSprinklerSetUp];
            }else{
                [Common resetNetworkFlags];
                SWRevealViewController *NHVC = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
                NHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                NSArray *newStack = @[NHVC];
                [Common viewFadeIn:self.navigationController.view];
                [self.navigationController setViewControllers:newStack animated:NO];
            }
            //[self processCompleteSprinklerSetUp];
        }
            break;
        case 2:
        {
            
            SettingsViewController *SVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
            [Common viewFadeInSettings:self.navigationController.view];
            [self.navigationController pushViewController:SVC animated:NO];
            
        }
            break;
        case 3: //Sprik sch
        {
            
            strActionType=@"SCHEDULE";
            if ([strZone_AddedStatus isEqualToString:@""]) {
                [Common showAlert:@"Warning" withMessage:@"At least 1 zone should be configured"];
                return;
            }
            NSLog(@"all zone ==%@",arrZoneDetails);
            
            if([Common reachabilityChanged]==YES){
                //strAutoOpen_Status=@"";
                [self performSelectorOnMainThread:@selector(start_PinWheel_Sprinkler_AddDevice) withObject:self waitUntilDone:YES];
                if([strZoneCode isEqualToString:@"NEW"])
                {
                    [self performSelectorInBackground:@selector(addSprinklerZones) withObject:self];
                }else{
                    [self performSelectorInBackground:@selector(updateSprinklerZones) withObject:self];
                }
                
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
//            if([strVacationStatus isEqualToString:@"VACATION"])
//            {
//                [Common showAlert:@"Warning" withMessage:@"Please turn off vacation mode and add more schedules"];
//                return;
//            }
//
//            if ([strZone_AddedStatus isEqualToString:@""]) {
//                [Common showAlert:@"Warning" withMessage:@"At least 1 zone should be configured"];
//                return;
//            }
//            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//            if([appDelegate.strDevice_Added_Mode isEqualToString:@"MultipleNetwork"])
//            {
//                appDelegate.strDevice_Added_Status=@"NEWPOPUPLOAD";
//                appDelegate.strAddedDevice_Type=self.strDeviceType;
//            }else if([appDelegate.strDevice_Added_Mode isEqualToString:@"NetworkHome"])
//            { //network home
//                appDelegate.strDevice_Added_Status=@"OLDPOPUPLOAD";
//                appDelegate.strAddedDevice_Type=self.strDeviceType;
//            }else{
//                //Reg Or Signin
//                appDelegate.strDevice_Added_Status=@"NEWPOPUPLOAD";
//                appDelegate.strAddedDevice_Type=self.strDeviceType;
//            }
//            NSLog(@"%@",appDelegate.strDevice_Added_Status);
//            AddSprinklerScheldule *ASS = [[AddSprinklerScheldule alloc] initWithNibName:@"AddSprinklerScheldule" bundle:nil];
//            ASS = [self.storyboard instantiateViewControllerWithIdentifier:@"AddSprinklerScheldule"];
//            [Common viewFadeInSettings:self.navigationController.view];
//            [self.navigationController pushViewController:ASS animated:NO];
        }
            break;
        case 4:  //Network home
        {
            strActionType=@"HOME";
            if ([strZone_AddedStatus isEqualToString:@""]) {
                [Common showAlert:@"Warning" withMessage:@"At least 1 zone should be configured"];
                return;
            }
            
            if([Common reachabilityChanged]==YES){
                //strAutoOpen_Status=@"";
                [self performSelectorOnMainThread:@selector(start_PinWheel_Sprinkler_AddDevice) withObject:self waitUntilDone:YES];
                if([strZoneCode isEqualToString:@"NEW"])
                {
                    [self performSelectorInBackground:@selector(addSprinklerZones) withObject:self];
                }else{
                    [self performSelectorInBackground:@selector(updateSprinklerZones) withObject:self];
                }
                
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
//            if ([strZone_AddedStatus isEqualToString:@""]) {
//                [Common showAlert:@"Warning" withMessage:@"At least 1 zone should be configured"];
//                return;
//            }
//            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//            NSLog(@"Str Device Added Mode ==%@",appDelegate.strDevice_Added_Mode);
//            if([appDelegate.strDevice_Added_Mode isEqualToString:@"NetworkHome"])
//            { //network home
//                if([strDeviceAdd_UpdateStatus isEqualToString:@"YES"])
//                {
//                    appDelegate.strDevice_Added_Status=@"OLDPOPUPLOAD";
//                    appDelegate.strAddedDevice_Type=self.strDeviceType;
//                }
//                [self.navigationController popViewControllerAnimated:YES];
//            }else{
//                //Reg Or Signin Or AnyOther Page
//                appDelegate.strDevice_Added_Status=@"NEWPOPUPLOAD";
//                appDelegate.strAddedDevice_Type=self.strDeviceType;
//                SWRevealViewController *NHVC = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
//                NHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//                NSArray *newStack = @[NHVC];
//                [Common viewFadeIn:self.navigationController.view];
//                [self.navigationController setViewControllers:newStack animated:NO];
//            }
        }
            break;
    }
}

-(IBAction)planUpgrade_Confirm_Zone_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Plan Upgrade Okay
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Sprinkler_AddDevice) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(quoteForAdditionalZone) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 1: //Plan Upgrade Cancel
        {
            viewAlert_PlanUpgrade_Zone.hidden=YES;
            [self popUp_ZoneSetUp_Alpha_Enabled];
        }
            break;
        case 2: //Charge my card
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Sprinkler_AddDevice) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(quoteForUpgradeZoneConfirmation) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 3: //confirm cancel
        {
            viewAlert_PlanUpgrade_Confirm_Zone.hidden=YES;
            [self popUp_ZoneSetUp_Alpha_Enabled];
        }
            break;
    }
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
            // imgView_Info.image=img;
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
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
            //imgView_Info.image=img;
            imgViewZone.image=[[UIImage alloc]initWithData:imageData];
        }else{
            UIImage *image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
            [imgViewZone.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [imgViewZone.layer setBorderWidth:1.0];
            
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
            //imgView_Info.image=img;
            imgViewZone.image=[[UIImage alloc]initWithData:imageData];
        }
        NSData* data = UIImageJPEGRepresentation(imgViewZone.image, 0.3f);
        strEncoded_ControllerImage = [Base64 encode:data];
        NSLog(@"image encoded lenght ==%lu",(unsigned long)strEncoded_ControllerImage.length);
        [picker dismissViewControllerAnimated:YES completion:NULL];
        imageStatus=YES;
        [self changeCommonView];
    }
}

/* **********************************************************************************
 Date : 19/08/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Image Saved To Album
 Description : after capture Image/Video its saved to album
 Method Name : hasBeenSavedInPhotoAlbumWithError (Media Picker Delegate Method)
 ************************************************************************************* */
- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    
}
#pragma mark - Textfield Delegates
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the textfield is selected.
 Method Name : textFieldShouldBeginEditing(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"Characters Entered");
    
    NSString * proposedNewString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"whole string === %@",proposedNewString);
    if ((range.location == 0 && [string isEqualToString:@" "]) || (range.location == 0 && [string isEqualToString:@"'"]))
    {
        return NO;
    }
    if (textField==txtfld_DeviceId_SetUp){
        NSUInteger newLength = [txtfld_DeviceId_SetUp.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_DEVICEID] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <=UnitfieldIDLimit));
    }
    else if(textField==txtfld_DeviceName_SetUp){
        NSUInteger newLength = [txtfld_DeviceName_SetUp.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_DEVICENAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldDigitsPWd));
    }
    return YES;
}
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
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text=@"";
    return NO;
}

#pragma mark - WebService Part
-(void)checkSprinkler_Device_Availabilty
{
    defaults_AddSprinkler=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"User Account id ==%@",[defaults_AddSprinkler objectForKey:@"ACCOUNTID"]);
    NSLog(@"Nwtwork id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);

    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/deviceTrace?traceCode=%@",[defaults_AddSprinkler objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],txtfld_DeviceId_SetUp.text];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Sprinkler Availability==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseSprinkler_Availability) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Sprinkler Availability ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Sprinkler_AddDevice) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorSprinkler_Device_Setup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

//-(void)responseSprinkler_Availability
//{
//    NSLog(@"%@",responseDict);
//    @try {
//        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
//        NSString *responseMessage = [responseDict valueForKey:@"message"];
//        NSLog(@"response Code ==%@",responseCode);
//        NSLog(@"response Message ==%@",responseMessage);
//        if([responseCode isEqualToString:@"200"]){
//            zoneC = [[[[responseDict valueForKey:@"data"] valueForKey:@"deviceTraceDetails"] valueForKey:@"zones"] intValue];
//            strVacationStatus=[[[responseDict valueForKey:@"data"] valueForKey:@"deviceMode"] valueForKey:@"deviceModeCode"];
//            NSLog(@"strvacStatus==%@",strVacationStatus);
//            strSprinklerDevice_TraceID = [[[[responseDict valueForKey:@"data"] valueForKey:@"deviceTraceDetails"] valueForKey:@"id"] stringValue];
//            NSLog(@"%d",zoneC);
//            strZoneCode = [[[[responseDict valueForKey:@"data"] valueForKey:@"deviceTraceDetails"] valueForKey:@"deviceTraceStatus"] valueForKey:@"code"];
//            NSLog(@"%@",strZoneCode);
//            [self parseZoneDetails];
//           // [self stop_PinWheel_Sprinkler_AddDevice];  //neeed to cahnge place
//        }else{
//            [self stop_PinWheel_Sprinkler_AddDevice];
//            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
//        }
//    }
//    @catch (NSException *exception) {
//        NSLog(@"Exception ==%@",[exception description]);
//        [self stop_PinWheel_Sprinkler_AddDevice];
//        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
//    }
//}

-(void)responseSprinkler_Availability
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            zoneC = [[[[responseDict valueForKey:@"data"] valueForKey:@"deviceTraceDetails"] valueForKey:@"zones"] intValue];
            strVacationStatus=[[[responseDict valueForKey:@"data"] valueForKey:@"deviceMode"] valueForKey:@"deviceModeCode"];
            NSLog(@"strvacStatus==%@",strVacationStatus);
            strSprinklerDevice_TraceID = [[[[responseDict valueForKey:@"data"] valueForKey:@"deviceTraceDetails"] valueForKey:@"id"] stringValue];
            NSLog(@"%d",zoneC);
            
            strZoneCode = [[[[responseDict valueForKey:@"data"] valueForKey:@"deviceTraceDetails"] valueForKey:@"deviceTraceStatus"] valueForKey:@"code"];
            NSLog(@"%@",strZoneCode);
            [self parseZoneDetails];
            //neeed to cahnge place
        }else{
            [self stop_PinWheel_Sprinkler_AddDevice];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Sprinkler_AddDevice];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}


//-(void)parseZoneDetails
//{
//    @try {
//        arrZoneDetails = [[NSMutableArray alloc] init];
//        if ([strZoneCode isEqualToString:@"NEW"]) {
//            strSprinkler_DeviceID=@"";
//            NSMutableDictionary *dict_ZoneDetails;
//            for (int index=0; index<zoneC; index++) {
//                dict_ZoneDetails = [[NSMutableDictionary alloc] init];
//                [dict_ZoneDetails setObject:@""  forKey:kDeviceName];
//                [dict_ZoneDetails setObject:@"" forKey:kDeviceImage];
//                [dict_ZoneDetails setObject:@"" forKey:kZoneID];
//                [dict_ZoneDetails setObject:[NSString stringWithFormat:@"%d",index+1] forKey:kZoneLevel];
//                [dict_ZoneDetails setObject:@"NEW" forKey:kZoneStatus];
//                [dict_ZoneDetails setObject:@"0" forKey:kZoneConfigStatus];
//                [arrZoneDetails addObject:dict_ZoneDetails];
//            }
//            NSLog(@"%@",arrZoneDetails);
//            [self loadZoneView];
//        }else{
//            NSMutableArray *arr_Zonelist = [[NSMutableArray alloc] init];
//            arr_Zonelist = [[responseDict valueForKey:@"data"] valueForKey:@"zoneDetails"];
//            strSprinkler_DeviceID= [[[arr_Zonelist objectAtIndex:0] valueForKey:@"deviceId"] stringValue];
//            NSLog(@"%@",strSprinkler_DeviceID);
//            NSMutableArray *arrList = [[NSMutableArray alloc] init];
//            arrList = [[arr_Zonelist objectAtIndex:0] valueForKey:@"zoneList"];
//            if(zoneC==arrList.count)
//            {
//                BOOL unConfigFlag=NO;
//                for (int index=0; index<zoneC; index++) {
//                    if([[[[arrList objectAtIndex:index] valueForKey:@"status"] stringValue] isEqualToString:@"2"])
//                    {
//                        unConfigFlag=YES;
//                        index=zoneC+index;
//                    }
//                }
//                if(unConfigFlag==NO)
//                {
//                    [self stop_PinWheel_Sprinkler_AddDevice];
//                    [Common showAlert:@"warning" withMessage:@"All zones in this device are configured"];
//                    return;
//                }
//                
//            }
//            
//            NSString *strIndex=@"",*strZoneStatus;
//            for (int i=0; i<zoneC; i++) {
//                strIndex  = [NSString stringWithFormat:@"%d",i+1];
//                strZoneStatus=@"";
//                for(int zlIndex=0;zlIndex<[arrList count];zlIndex++)
//                {
//                    if([strIndex isEqualToString:[[[arrList objectAtIndex:zlIndex] valueForKey:@"zoneLevel"] stringValue]])
//                    {
//                        if ([[[[arrList objectAtIndex:zlIndex] valueForKey:@"status"] stringValue] isEqualToString:@"2"]) {
//                            NSMutableDictionary *dict_ZoneDetails = [[NSMutableDictionary alloc] init];
//                            [dict_ZoneDetails setObject:@""  forKey:kDeviceName];
//                            [dict_ZoneDetails setObject:@"" forKey:kDeviceImage];
//                            [dict_ZoneDetails setObject:[[[arrList objectAtIndex:zlIndex] valueForKey:@"id"] stringValue] forKey:kZoneID];
//                            [dict_ZoneDetails setObject:[[[arrList objectAtIndex:zlIndex] valueForKey:@"zoneLevel"] stringValue] forKey:kZoneLevel];
//                            [dict_ZoneDetails setObject:@"UNCONFIGURED" forKey:kZoneStatus];
//                            [dict_ZoneDetails setObject:[[[arrList objectAtIndex:zlIndex] valueForKey:@"status"] stringValue] forKey:kZoneConfigStatus];
//                            [arrZoneDetails addObject:dict_ZoneDetails];
//                            zlIndex=zlIndex+(int)arrList.count;
//                            strZoneStatus=@"YES";
//                        }else{
//                            NSMutableDictionary *dict_ZoneDetails = [[NSMutableDictionary alloc] init];
//                            [dict_ZoneDetails setObject:[[arrList objectAtIndex:zlIndex] valueForKey:@"name"]  forKey:kDeviceName];
//                            [dict_ZoneDetails setObject:[[arrList objectAtIndex:zlIndex] valueForKey:@"image"] forKey:kDeviceImage];
//                            [dict_ZoneDetails setObject:[[[arrList objectAtIndex:zlIndex] valueForKey:@"id"] stringValue] forKey:kZoneID];
//                            [dict_ZoneDetails setObject:[[[arrList objectAtIndex:zlIndex] valueForKey:@"zoneLevel"] stringValue] forKey:kZoneLevel];
//                            [dict_ZoneDetails setObject:strZoneCode forKey:kZoneStatus];
//                            [dict_ZoneDetails setObject:[[[arrList objectAtIndex:zlIndex] valueForKey:@"status"] stringValue] forKey:kZoneConfigStatus];
//                            [arrZoneDetails addObject:dict_ZoneDetails];
//                            zlIndex=zlIndex+(int)arrList.count;
//                            strZoneStatus=@"YES";
//                            strZone_AddedStatus = @"YES";
//                        }
//                    }
//                }
//                if(![strZoneStatus isEqualToString:@"YES"])
//                {
//                    NSMutableDictionary *dict_ZoneDetails = [[NSMutableDictionary alloc] init];
//                    [dict_ZoneDetails setObject:@""  forKey:kDeviceName];
//                    [dict_ZoneDetails setObject:@"" forKey:kDeviceImage];
//                    [dict_ZoneDetails setObject:@"" forKey:kZoneID];
//                    [dict_ZoneDetails setObject:[NSString stringWithFormat:@"%d",i+1] forKey:kZoneLevel];
//                    [dict_ZoneDetails setObject:@"NEW" forKey:kZoneStatus];
//                    [dict_ZoneDetails setObject:@"0" forKey:kZoneConfigStatus];
//                    [arrZoneDetails addObject:dict_ZoneDetails];
//                }
//            }
//            [self loadZoneView];
//        }
//        NSLog(@"%@",arrZoneDetails);
//    }
//    @catch (NSException *exception) {
//        NSLog(@"ecep==%@",exception.description);
//        [self stop_PinWheel_Sprinkler_AddDevice];
//        [Common showAlert:@"warning" withMessage:exception.description];
//    }
//
//
//   
//}

-(void)parseZoneDetails
{
    @try {
        arrZoneDetails = [[NSMutableArray alloc] init];
        if ([strZoneCode isEqualToString:@"NEW"]) {
            strSprinkler_DeviceID=@"";
            NSMutableDictionary *dict_ZoneDetails;
            for (int index=0; index<zoneC; index++) {
                dict_ZoneDetails = [[NSMutableDictionary alloc] init];
                [dict_ZoneDetails setObject:@""  forKey:kDeviceName];
                [dict_ZoneDetails setObject:@"" forKey:kDeviceImage];
                [dict_ZoneDetails setObject:@"0" forKey:kZoneID];
                [dict_ZoneDetails setObject:[NSString stringWithFormat:@"%d",index+1] forKey:kZoneLevel];
                [dict_ZoneDetails setObject:@"NEW" forKey:kZoneStatus];
                [dict_ZoneDetails setObject:@"0" forKey:kZoneConfigStatus];
                [arrZoneDetails addObject:dict_ZoneDetails];
            }
            NSLog(@"%@",arrZoneDetails);
            [self loadZoneView];
        }else{
            NSMutableArray *arr_Zonelist = [[NSMutableArray alloc] init];
            arr_Zonelist = [[responseDict valueForKey:@"data"] valueForKey:@"zoneDetails"];
            strSprinkler_DeviceID= [[[arr_Zonelist objectAtIndex:0] valueForKey:@"deviceId"] stringValue];
            NSLog(@"%@",strSprinkler_DeviceID);
            NSMutableArray *arrList = [[NSMutableArray alloc] init];
            arrList = [[arr_Zonelist objectAtIndex:0] valueForKey:@"zoneList"];
            if(zoneC==arrList.count)
            {
                BOOL unConfigFlag=NO;
                for (int index=0; index<zoneC; index++) {
                    if([[[[arrList objectAtIndex:index] valueForKey:@"status"] stringValue] isEqualToString:@"2"])
                    {
                        unConfigFlag=YES;
                        index=zoneC+index;
                    }
                }
                if(unConfigFlag==NO)
                {
                    [self stop_PinWheel_Sprinkler_AddDevice];
                    [Common showAlert:@"warning" withMessage:@"All zones in this device are configured"];
                    return;
                }
                
            }
            NSString *strIndex=@"",*strZoneStatus;
            for (int i=0; i<zoneC; i++) {
                strIndex  = [NSString stringWithFormat:@"%d",i+1];
                strZoneStatus=@"";
                for(int zlIndex=0;zlIndex<[arrList count];zlIndex++)
                {
                    NSLog(@"strIndex==%@",strIndex);
                    NSLog(@"zonelevel==%@",[[[arrList objectAtIndex:zlIndex] valueForKey:@"zoneLevel"] stringValue]);
                    NSLog(@"zone status ==%@",[[[arrList objectAtIndex:zlIndex] valueForKey:@"status"] stringValue]);
                    if([strIndex isEqualToString:[[[arrList objectAtIndex:zlIndex] valueForKey:@"zoneLevel"] stringValue]])
                    {
                        if ([[[[arrList objectAtIndex:zlIndex] valueForKey:@"status"] stringValue] isEqualToString:@"2"]) {
                            NSMutableDictionary *dict_ZoneDetails = [[NSMutableDictionary alloc] init];
                            
                            [dict_ZoneDetails setObject:@""  forKey:kDeviceName];
                            [dict_ZoneDetails setObject:@"" forKey:kDeviceImage];
                            [dict_ZoneDetails setObject:[[[arrList objectAtIndex:zlIndex] valueForKey:@"id"] stringValue] forKey:kZoneID];
                            [dict_ZoneDetails setObject:[[[arrList objectAtIndex:zlIndex] valueForKey:@"zoneLevel"] stringValue] forKey:kZoneLevel];
                            [dict_ZoneDetails setObject:@"UNCONFIGURED" forKey:kZoneStatus];
                            //[dict_ZoneDetails setObject:[[[arrList objectAtIndex:zlIndex] valueForKey:@"status"] stringValue] forKey:kZoneConfigStatus];
                            [dict_ZoneDetails setObject:@"1" forKey:kZoneConfigStatus];
                            [arrZoneDetails addObject:dict_ZoneDetails];
                            zlIndex=zlIndex+(int)arrList.count;
                            strZoneStatus=@"YES";
                        }else{
                            NSMutableDictionary *dict_ZoneDetails = [[NSMutableDictionary alloc] init];
                            [dict_ZoneDetails setObject:[[arrList objectAtIndex:zlIndex] valueForKey:@"name"]  forKey:kDeviceName];
                            [dict_ZoneDetails setObject:[[arrList objectAtIndex:zlIndex] valueForKey:@"thumbnailImage"] forKey:kDeviceImage];
                            [dict_ZoneDetails setObject:[[[arrList objectAtIndex:zlIndex] valueForKey:@"id"] stringValue] forKey:kZoneID];
                            [dict_ZoneDetails setObject:[[[arrList objectAtIndex:zlIndex] valueForKey:@"zoneLevel"] stringValue] forKey:kZoneLevel];
                            [dict_ZoneDetails setObject:strZoneCode forKey:kZoneStatus];
                            [dict_ZoneDetails setObject:[[[arrList objectAtIndex:zlIndex] valueForKey:@"status"] stringValue] forKey:kZoneConfigStatus];
                            [arrZoneDetails addObject:dict_ZoneDetails];
                            zlIndex=zlIndex+(int)arrList.count;
                            strZoneStatus=@"YES"; //need to change place instead of else need to place if
                            strZone_AddedStatus=@"YES";
                        }
                    }
                }
                if(![strZoneStatus isEqualToString:@"YES"])
                {
                    NSMutableDictionary *dict_ZoneDetails = [[NSMutableDictionary alloc] init];
                    [dict_ZoneDetails setObject:@""  forKey:kDeviceName];
                    [dict_ZoneDetails setObject:@"" forKey:kDeviceImage];
                    [dict_ZoneDetails setObject:@"0" forKey:kZoneID];
                    [dict_ZoneDetails setObject:[NSString stringWithFormat:@"%d",i+1] forKey:kZoneLevel];
                    [dict_ZoneDetails setObject:@"NEW" forKey:kZoneStatus];
                    [dict_ZoneDetails setObject:@"0" forKey:kZoneConfigStatus];
                    [arrZoneDetails addObject:dict_ZoneDetails];
                }
            }
            [self loadZoneView];
        }
        NSLog(@"%@",arrZoneDetails);
    }
    @catch (NSException *exception) {
        NSLog(@"ecep==%@",exception.description);
        [self stop_PinWheel_Sprinkler_AddDevice];
        [Common showAlert:@"warning" withMessage:exception.description];
    }
}


-(void)responseErrorSprinkler_Device_Setup
{
    [Common showAlert:@"Warning" withMessage:strResponseError];
}

-(void)addSprinklerZones
{
    NSString *selected_Zones=@"";
    for (int index=0; index<[arrZoneDetails count]; index++) {
        if ([[[arrZoneDetails objectAtIndex:index] valueForKey:kZoneConfigStatus] isEqualToString:@"1"]) {
            NSString *strZone=[NSString stringWithFormat:@"{\"zoneStatus\":{\"id\":\"%@\"},\"name\":\"%@\",\"image\":\"%@\",\"thumbnailImage\":\"%@\",\"zoneLevel\":\"%@\",\"status\":\"%@\"}",@"2",[[arrZoneDetails objectAtIndex:index] valueForKey:kDeviceName],@"",[[arrZoneDetails objectAtIndex:index] valueForKey:kDeviceImage],[[arrZoneDetails objectAtIndex:index] valueForKey:kZoneLevel],@"1"];
            if([selected_Zones isEqualToString:@""])
            {
                selected_Zones=[NSString stringWithFormat:@"%@",strZone];
            }else{
                selected_Zones=[NSString stringWithFormat:@"%@,%@",selected_Zones,strZone];
            }
            
        }
    }
    NSLog(@"%@",selected_Zones);
    selected_Zones=[NSString stringWithFormat:@"[%@]",selected_Zones];
    NSLog(@"%@",selected_Zones);
    
    NSError *jsonError;
    NSData *objectData = [selected_Zones dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonZones = [NSJSONSerialization JSONObjectWithData:objectData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&jsonError];
    NSLog(@"jsonn==%@",jsonZones);
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"device trace id ==%@",strSprinklerDevice_TraceID);
    defaults_AddSprinkler=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults_AddSprinkler objectForKey:@"ACCOUNTID"]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/zoneList",[defaults_AddSprinkler objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];
    
    NSDictionary *parameters;
    NSMutableDictionary *dictController_Device_Details=[[NSMutableDictionary alloc] init];
    [dictController_Device_Details setObject:@"2" forKey:kdeviceTypeId];
    [dictController_Device_Details setObject:strSprinklerDevice_TraceID forKey:kDeviceTraceID];
    [dictController_Device_Details setObject:jsonZones forKey:kZoneLevel];
    
    parameters=[SCM add_Sprinkler_Device_Details:dictController_Device_Details];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for add zone device==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseAdded_update_Device_Sprinkler) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for add zone device ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Sprinkler_AddDevice) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorSprinkler_Device_Setup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodNameWith_Value];
    
}
-(void)updateSprinklerZones
{
    NSString *selected_Zones=@"";
    for (int index=0; index<[arrZoneDetails count]; index++) {
        if ([[[arrZoneDetails objectAtIndex:index] valueForKey:kZoneConfigStatus] isEqualToString:@"1"]) {
            NSString *strZone=[NSString stringWithFormat:@"{\"zoneStatus\":{\"id\":\"%@\"},\"name\":\"%@\",\"image\":\"%@\",\"thumbnailImage\":\"%@\",\"zoneLevel\":\"%@\",\"status\":\"%@\",\"id\":\"%@\"}",@"2",[[arrZoneDetails objectAtIndex:index] valueForKey:kDeviceName],@"",[[arrZoneDetails objectAtIndex:index] valueForKey:kDeviceImage],[[arrZoneDetails objectAtIndex:index] valueForKey:kZoneLevel],@"1",[[arrZoneDetails objectAtIndex:index] valueForKey:kZoneID]];
            if([selected_Zones isEqualToString:@""])
            {
                selected_Zones=[NSString stringWithFormat:@"%@",strZone];
            }else{
                selected_Zones=[NSString stringWithFormat:@"%@,%@",selected_Zones,strZone];
            }
            
        }
    }
    NSLog(@"%@",selected_Zones);
    selected_Zones=[NSString stringWithFormat:@"[%@]",selected_Zones];
    NSLog(@"%@",selected_Zones);
    
    NSError *jsonError;
    NSData *objectData = [selected_Zones dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonZones = [NSJSONSerialization JSONObjectWithData:objectData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&jsonError];
    NSLog(@"jsonn==%@",jsonZones);
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"device trace id ==%@",strSprinklerDevice_TraceID);
    defaults_AddSprinkler=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults_AddSprinkler objectForKey:@"ACCOUNTID"]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/%@/zoneList",[defaults_AddSprinkler objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],strSprinkler_DeviceID];
    
    NSDictionary *parameters;
    NSMutableDictionary *dictController_Device_Details=[[NSMutableDictionary alloc] init];
    [dictController_Device_Details setObject:@"2" forKey:kdeviceTypeId];
    [dictController_Device_Details setObject:strSprinklerDevice_TraceID forKey:kDeviceTraceID];
    [dictController_Device_Details setObject:jsonZones forKey:kZoneLevel];
    
    parameters=[SCM add_Sprinkler_Device_Details:dictController_Device_Details];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update zone device==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseAdded_update_Device_Sprinkler) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update zone device ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Sprinkler_AddDevice) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorSprinkler_Device_Setup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}

-(void)responseAdded_update_Device_Sprinkler
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            strDeviceAdd_UpdateStatus=@"YES";
            
            NSMutableArray *arr_Zonelist = [[NSMutableArray alloc] init];
            arr_Zonelist = [[responseDict valueForKey:@"data"] valueForKey:@"zoneList"];
            NSLog(@"%@",arr_Zonelist);
            strVacationStatus=[[[responseDict valueForKey:@"data"] valueForKey:@"deviceMode"] valueForKey:@"deviceModeCode"];
            NSLog(@"strvacStatus==%@",strVacationStatus);
            if ([strSprinkler_DeviceID isEqualToString:@""] && [strZoneCode isEqualToString:@"NEW"]) {
                strSprinkler_DeviceID= [[[responseDict valueForKey:@"data"] valueForKey:@"deviceId"] stringValue];
                NSLog(@"%@",strSprinkler_DeviceID);
                strZoneCode=@"IN_USE";
            }
            [self reparseZonesList:arr_Zonelist];
            
        }else{
            [self stop_PinWheel_Sprinkler_AddDevice];
//            if([responseMessage isEqualToString:@"NAME_ALREADY_USED"])
//            {
//                [Common showAlert:kAlertTitleWarning withMessage:@"This Zone Name Already Exists"];
//                return;
//            }
//            else
                if ([responseMessage isEqualToString:@"ACCT_DEVICE_MAX_LIMIT_REACHED"])
            {
                [self.viewAlert_PlanUpgrade_Zone setHidden:NO];
                [self popUp_ZoneSetUp_Alpha_Disabled];
                return;
            }
            else if ([responseMessage isEqualToString:@"APP_DEVICE_MAX_LIMIT_REACHED"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"Sorry! You Have Already Reached Your Maximum Limit."];
                return;
            }
            else{
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
            
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Sprinkler_AddDevice];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
-(void)reparseZonesList:arr_Zonelist
{
    @try {
        arrZoneDetails=[[NSMutableArray alloc] init];
        NSString *strIndex=@"",*strZoneStatus;
        for (int i=0; i<zoneC; i++) {
            strIndex  = [NSString stringWithFormat:@"%d",i+1];
            strZoneStatus=@"";
            for(int zlIndex=0;zlIndex<[arr_Zonelist count];zlIndex++)
            {
                NSLog(@"strIndex==%@",strIndex);
                NSLog(@"zonelevel==%@",[[[arr_Zonelist objectAtIndex:zlIndex] valueForKey:@"zoneLevel"] stringValue]);
                NSLog(@"zone status ==%@",[[[arr_Zonelist objectAtIndex:zlIndex] valueForKey:@"status"] stringValue]);
                if([strIndex isEqualToString:[[[arr_Zonelist objectAtIndex:zlIndex] valueForKey:@"zoneLevel"] stringValue]])
                {
                    NSMutableDictionary *dict_ZoneDetails = [[NSMutableDictionary alloc] init];
                    [dict_ZoneDetails setObject:[[arr_Zonelist objectAtIndex:zlIndex] valueForKey:@"name"]  forKey:kDeviceName];
                    [dict_ZoneDetails setObject:[[arr_Zonelist objectAtIndex:zlIndex] valueForKey:@"thumbnailImage"] forKey:kDeviceImage];
                    [dict_ZoneDetails setObject:[[[arr_Zonelist objectAtIndex:zlIndex] valueForKey:@"id"] stringValue] forKey:kZoneID];
                    [dict_ZoneDetails setObject:[[[arr_Zonelist objectAtIndex:zlIndex] valueForKey:@"zoneLevel"] stringValue] forKey:kZoneLevel];
                    [dict_ZoneDetails setObject:strZoneCode forKey:kZoneStatus];
                    [dict_ZoneDetails setObject:[[[arr_Zonelist objectAtIndex:zlIndex] valueForKey:@"status"] stringValue] forKey:kZoneConfigStatus];
                    [arrZoneDetails addObject:dict_ZoneDetails];
                    zlIndex=zlIndex+(int)[arr_Zonelist count];
                    strZoneStatus=@"YES"; //need to change place instead of else need to place if
                }
            }
            if(![strZoneStatus isEqualToString:@"YES"])
            {
                NSMutableDictionary *dict_ZoneDetails = [[NSMutableDictionary alloc] init];
                [dict_ZoneDetails setObject:@""  forKey:kDeviceName];
                [dict_ZoneDetails setObject:@"" forKey:kDeviceImage];
                [dict_ZoneDetails setObject:@"" forKey:kZoneID];
                [dict_ZoneDetails setObject:[NSString stringWithFormat:@"%d",i+1] forKey:kZoneLevel];
                [dict_ZoneDetails setObject:@"NEW" forKey:kZoneStatus];
                [dict_ZoneDetails setObject:@"0" forKey:kZoneConfigStatus];
                [arrZoneDetails addObject:dict_ZoneDetails];
            }
        }
        NSLog(@"arr=%@",arrZoneDetails);
        [self collapse_ZoneView];
        [self stop_PinWheel_Sprinkler_AddDevice];
    }
    @catch (NSException *exception) {
        NSLog(@"excp==%@",exception.description);
        [self stop_PinWheel_Sprinkler_AddDevice];
        [self collapse_ZoneView];
        [Common showAlert:kAlertTitleWarning withMessage:exception.description];
    }
    
    
    if([strActionType isEqualToString:@"SCHEDULE"])
    {
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        if([appDelegate.strDevice_Added_Mode isEqualToString:@"MultipleNetwork"])
        {
            appDelegate.strDevice_Added_Status=@"NEWPOPUPLOAD";
            appDelegate.strAddedDevice_Type=self.strDeviceType;
        }else if([appDelegate.strDevice_Added_Mode isEqualToString:@"NetworkHome"])
        { //network home
            appDelegate.strDevice_Added_Status=@"OLDPOPUPLOAD";
            appDelegate.strAddedDevice_Type=self.strDeviceType;
        }else{
            //Reg Or Signin
            appDelegate.strDevice_Added_Status=@"NEWPOPUPLOAD";
            appDelegate.strAddedDevice_Type=self.strDeviceType;
        }
        if([strVacationStatus isEqualToString:@"VACATION"])
        {
            [Common showAlert:@"Warning" withMessage:@"Please turn off vacation mode and add more schedules"];
            return;
        }
        
        AddSprinklerScheldule *ASSVC = [[AddSprinklerScheldule alloc]  initWithNibName:@"AddSprinklerScheldule" bundle:nil];
        ASSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddSprinklerScheldule"];
        [Common viewFadeInSettings:self.navigationController.view];
        [self.navigationController pushViewController:ASSVC animated:NO];
    }else{
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSLog(@"Str Device Added Mode ==%@",appDelegate.strDevice_Added_Mode);
        if([appDelegate.strDevice_Added_Mode isEqualToString:@"NetworkHome"])
        { //network home
            if([strDeviceAdd_UpdateStatus isEqualToString:@"YES"])
            {
                appDelegate.strDevice_Added_Status=@"OLDPOPUPLOAD";
                appDelegate.strAddedDevice_Type=self.strDeviceType;
            }
            [self.navigationController popViewControllerAnimated:YES];
            //[self processComplete_LightOther_DeviceSetUp];
        }else{
            //Reg Or Signin Or AnyOther Page
            appDelegate.strDevice_Added_Status=@"NEWPOPUPLOAD";
            appDelegate.strAddedDevice_Type=self.strDeviceType;
            SWRevealViewController *NHVC = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
            NHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            NSArray *newStack = @[NHVC];
            [Common viewFadeIn:self.navigationController.view];
            [self.navigationController setViewControllers:newStack animated:NO];
            
        }
    }
    
}


-(void)quoteForAdditionalZone
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults_AddSprinkler=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults_AddSprinkler objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/billing/planQuote?quoteTypeId=1&deviceTypeId=2&controllerId=%@",[defaults_AddSprinkler objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for zone Quote details ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseForQuotePlanUpgrade_Zone) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for zone Quote details ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Sprinkler_AddDevice) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorSprinkler_Device_Setup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)responseForQuotePlanUpgrade_Zone
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
                Amount_Zone = remAmt/100;
                NSLog(@"remAmount =%f",Amount_Zone);
                self.lbl_PlanUpgrade_Charge_Zone.text=[NSString stringWithFormat:@"YOU WILL BE AUTOMATICALLY CHARGED $%.2f FOR THE PLAN %@.",Amount_Zone,[[[responseDict valueForKey:@"data"] objectForKey:@"billingPlan"] objectForKey:@"billingPlanName"]];
                
                [self.viewAlert_PlanUpgrade_Zone setHidden:YES];
                [self.viewAlert_PlanUpgrade_Confirm_Zone setHidden:NO];
            }else{
                [self.viewAlert_PlanUpgrade_Zone setHidden:YES];
                [self.viewAlert_PlanUpgrade_Confirm_Zone setHidden:NO];
            }
            
            NSLog(@"%@",[[responseDict valueForKey:@"data"] objectForKey:@"billingUserFirstName"]);
            appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if ([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"]) {
                [btn_Charge_Zone setTitle:[NSString stringWithFormat:@"CHARGE %@'s CARD",[[responseDict valueForKey:@"data"] objectForKey:@"billingUserFirstName"]] forState:UIControlStateNormal];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    btn_Charge_Zone.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:11];
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    btn_Charge_Zone.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:14];
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                    btn_Charge_Zone.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:13];
                }
            }

            NSLog(@"billing plan name==%@",[[[responseDict valueForKey:@"data"] objectForKey:@"billingPlan"] objectForKey:@"billingPlanName"]);
            NSLog(@"Time == %@",[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"prorationDateTime"]);
            strprorationTime=[[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"prorationDateTime"] stringValue];
            [self stop_PinWheel_Sprinkler_AddDevice];
            [self popUp_ZoneSetUp_Alpha_Disabled];
        }else{
            [self stop_PinWheel_Sprinkler_AddDevice];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Sprinkler_AddDevice];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)quoteForUpgradeZoneConfirmation
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    defaults_AddSprinkler=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults_AddSprinkler objectForKey:@"ACCOUNTID"]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodName=[NSString stringWithFormat:@"/accounts/%@/billing/planChange",[defaults_AddSprinkler objectForKey:@"ACCOUNTID"]];
    
    NSMutableDictionary *dict_Plan=[[NSMutableDictionary alloc] init];
    [dict_Plan setObject:@"1" forKey:kquoteTypeId];
    [dict_Plan setObject:@"2" forKey:kdeviceTypeId];
    [dict_Plan setObject:[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID] forKey:kControllerID];
    [dict_Plan setObject:strprorationTime forKey:kprorationDateTime];
    
    parameters=[SCM upgrade_Device_Plan:dict_Plan];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for zone upgrade plan ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseUpGradePlanZone) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for zone upgrade plan ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorSprinkler_Device_Setup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodName];
}

-(void)responseUpGradePlanZone
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            float remAmt=[[[responseDict valueForKey:@"data"] objectForKey:@"total"] floatValue];
            Amount_Zone = remAmt/100;
            NSLog(@"remAmount =%f",Amount_Zone);
            [self.viewAlert_PlanUpgrade_Confirm_Zone setHidden:YES];
            [self popUp_ZoneSetUp_Alpha_Enabled];
            [self stop_PinWheel_Sprinkler_AddDevice];
            [self performSelectorOnMainThread:@selector(start_PinWheel_Sprinkler_AddDevice) withObject:self waitUntilDone:YES];
            if ([strZoneCode isEqualToString:@"NEW"]) {
                [self performSelectorInBackground:@selector(addSprinklerZones) withObject:self];
            }else{
                [self performSelectorInBackground:@selector(updateSprinklerZones) withObject:self];
            }
        }else{
            [self stop_PinWheel_Sprinkler_AddDevice];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Sprinkler_AddDevice];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

#pragma mark - Pin Wheel Delegate
-(void)start_PinWheel_Sprinkler_AddDevice{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation = @"YES";
}
-(void)stop_PinWheel_Sprinkler_AddDevice{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation = @"";
}

@end
