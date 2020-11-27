//
//  LightScheduleViewController.m
//  NOID
//
//  Created by iExemplar on 23/09/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "LightScheduleViewController.h"
#import "Utils.h"
#import "Common.h"
#import "SettingsViewController.h"
#import "NetworkHomeViewController.h"
#import "TimeLineViewController.h"
#import "MBProgressHUD.h"
#import "ServiceConnectorModel.h"

@interface LightScheduleViewController ()

@end

@implementation LightScheduleViewController
@synthesize scrollView_Schedule,btn_header_Schedule,txtfld_ScheduleName,strDeviceType_Schedule,view_SaveSchedule;
@synthesize lbl_Dawn_Schedule,lbl_Dusk_Schedule,btn_DawnPlus_Schedule,btn_Dec_Schedule,btn_DuskPlus_Schedule,btn_Feb_Schedule,btn_Fri_Schedule,btn_Jan_Schedule,btn_Mar_Schedule,btn_Mon_Schedule,btn_Nov_Schedule,btn_Oct_Schedule,btn_Sun_Schedule,btn_Wed_Schedule;
@synthesize switch_dawn_Schedule,switch_dawnSetting_Schedule,switch_dusk_Schedule,switch_duskSetting_Schedule,switch_evenDays_Schedule,switch_oddDays_Schedule,switch_RunOnOddEven_Schedule,switch_timeFromTo_Schedule,strStatus_Schedule,view_OddEven_Schedule,btn_backArrow_Schedule,view_SkipSchedule,lbl_header_Schedule,strPreviousView,strControllerStatus,lbl_Dawn_Schedule_Hours,lbl_Dusk_Schedule_Hours,btn_DawnMinus_Schedule,btn_DuskMinus_Schedule,btn_July_Schedule,btn_June_Schedule,btn_May_Schedule,btn_Sat_Schedule,btn_Sep_Schedule,btn_Thur_Schedule,btn_Tues_Schedule,strDeviceID,btn_Apr_Schedule,btn_Aug_Schedule;
@synthesize btn_EndTime,btn_StartTime,timePicker,pickerView,btnCancel_picker,btnOk_picker;


#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self start_PinWheel_ScheduleAdd];
    [self flagSetupSchedule];
    [self initialSetUp_LightSchedule];
    [self scrollView_Configuration_Schedule];
    [self stop_PinWheel_ScheduleAdd];
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


#pragma mark - User Defined Methods
-(void)flagSetupSchedule
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
    strAllowDuplicate=@"false"; 
    intDawnPlusHrs=0;
    intDawnMinusHrs=0;
    intDuskPlusHrs=0;
    intDuskMinusHrs=0;
    
    btn_DuskMinus_Schedule.userInteractionEnabled=NO;
    btn_DuskPlus_Schedule.userInteractionEnabled=NO;
    btn_DawnMinus_Schedule.userInteractionEnabled=NO;
    btn_DawnPlus_Schedule.userInteractionEnabled=NO;
    btn_StartTime.userInteractionEnabled=NO;
    btn_EndTime.userInteractionEnabled=NO;
    
    //new changes feb29th
    daySun=YES,dayMon=YES,dayTus=YES,dayWed=YES,dayThurs=YES,dayFri=YES,daySat=YES,daySun=YES;
    incDawnStatus=NO,incDuskStatus=NO,decDawnStatus=NO,decDuskStatus=NO;
    monJan=YES,monFeb=YES,monMar=YES,monApr=YES,monMay=YES,monJun=YES,monJly=YES,monAug=YES,monSep=YES,monOct=YES,monNov=YES,monDec=YES;
    
    str_ScheduleCat_ID=@"0";
    str_Schedule_Day_Type=@"ManualDays";  //new changes feb29th
    oddDays=NO,evenDays=NO;
    str_Schedule_Month=@"Month"; //new changes feb29th
    startTime=@"00:00:00";
    endTime=@"00:00:00";
    strJan=@"true";
    strFeb=@"true";
    strMar=@"true";
    strApr=@"true";
    strMay=@"true";
    strJun=@"true";
    strJly=@"true";
    strAug=@"true";
    strSep=@"true";
    strOct=@"true";
    strNov=@"true";
    strDec=@"true";
    strSun=@"true";
    strMon=@"true";
    strTue=@"true";
    strWed=@"true";
    strThr=@"true";
    strFri=@"true";
    strSat=@"true";
    strOddDay=@"false";
    strEvenDay=@"false";
    timerType=@"";
}

-(void)initialSetUp_LightSchedule
{
    if ([strDeviceType_Schedule isEqualToString:@"others"]) {
        [btn_header_Schedule setTitleColor:lblRGBA(49, 165, 222, 1) forState:UIControlStateNormal];
        [btn_backArrow_Schedule setImage:[UIImage imageNamed:@"blueBackBtni6plus"] forState:UIControlStateNormal];
        view_SaveSchedule.backgroundColor = lblRGBA(49, 165, 222, 1);
        lbl_Dawn_Schedule.textColor = lblRGBA(49, 165, 222, 1);
        lbl_Dusk_Schedule.textColor = lblRGBA(49, 165, 222, 1);
        lbl_header_Schedule.text = @"OTHER SCHEDULE SET-UP";
        
        //changes feb 29th
        btn_Mon_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Tues_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Wed_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Thur_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Fri_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Sat_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Sun_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Jan_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Feb_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Mar_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Apr_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_May_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_June_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_July_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Aug_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Sep_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Oct_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Nov_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Dec_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
    }
    
    if ([strStatus_Schedule isEqualToString:@"lightSchedule"]) {
        view_SkipSchedule.hidden=YES;
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_SaveSchedule.frame = CGRectMake(93, view_SaveSchedule.frame.origin.y, view_SaveSchedule.frame.size.width, view_SaveSchedule.frame.size.height);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_SaveSchedule.frame = CGRectMake(120, view_SaveSchedule.frame.origin.y, view_SaveSchedule.frame.size.width, view_SaveSchedule.frame.size.height);
        }else{
            view_SaveSchedule.frame = CGRectMake(109, view_SaveSchedule.frame.origin.y, view_SaveSchedule.frame.size.width, view_SaveSchedule.frame.size.height);
        }
    }
    txtfld_ScheduleName.delegate=self;
    [txtfld_ScheduleName setValue:lblRGBA(0, 0, 0, 1) forKeyPath:@"_placeholderLabel.textColor"];
    txtfld_ScheduleName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self toggleSwitchSetUp_Schedule];
    
//    [timePicker setValue:[UIColor blackColor] forKeyPath:@"textColor"];
//    timePicker.backgroundColor = [UIColor whiteColor];
//    if ([strDeviceType_Schedule isEqualToString:@"others"]) {
        [timePicker setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"textColor"];
        timePicker.backgroundColor = lblRGBA(65, 64, 66, 1);
        btnOk_picker.layer.cornerRadius=5.0;
        btnCancel_picker.layer.cornerRadius=5.0;

//        [btnOk_picker setTitleColor:lblRGBA(40, 165, 222, 1) forState:UIControlStateNormal];
//        [btnCancel_picker setTitleColor:lblRGBA(40, 165, 222, 1) forState:UIControlStateNormal];
//    }else{
//        [timePicker setValue:lblRGBA(255, 205, 52, 1) forKeyPath:@"textColor"];
//        timePicker.backgroundColor = lblRGBA(65, 64, 66, 1);
//        [btnOk_picker setTitleColor:lblRGBA(255, 205, 52, 1) forState:UIControlStateNormal];
//        [btnCancel_picker setTitleColor:lblRGBA(255, 205, 52, 1) forState:UIControlStateNormal];
//    }

//    [self reset_Old_State_ODD_EVEN];
}

-(void)scrollView_Configuration_Schedule
{
    scrollView_Schedule.showsHorizontalScrollIndicator=NO;
    scrollView_Schedule.scrollEnabled=YES;
    scrollView_Schedule.userInteractionEnabled=YES;
    scrollView_Schedule.delegate=self;
    scrollView_Schedule.scrollsToTop=NO;
    scrollView_Schedule.contentSize = CGSizeMake(scrollView_Schedule.contentSize.width, view_SaveSchedule.frame.origin.y+view_SaveSchedule.frame.size.height+100);
}

-(void)toggleSwitchSetUp_Schedule
{
    [switch_dawn_Schedule setOn:NO animated:NO];
    [switch_dawn_Schedule setSelected:NO];
    [switch_dawn_Schedule setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_dawn_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_dawn_Schedule.tintColor=lblRGBA(98, 99, 102, 1);
    switch_dawn_Schedule.layer.masksToBounds=YES;
    switch_dawn_Schedule.layer.cornerRadius=16.0;
    
    [switch_dawnSetting_Schedule setOn:NO animated:NO];
    [switch_dawnSetting_Schedule setSelected:NO];
    [switch_dawnSetting_Schedule setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_dawnSetting_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_dawnSetting_Schedule.tintColor=lblRGBA(98, 99, 102, 1);
    switch_dawnSetting_Schedule.layer.masksToBounds=YES;
    switch_dawnSetting_Schedule.layer.cornerRadius=16.0;
    
    [switch_dusk_Schedule setOn:NO animated:NO];
    [switch_dusk_Schedule setSelected:NO];
    [switch_dusk_Schedule setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_dusk_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_dusk_Schedule.tintColor=lblRGBA(98, 99, 102, 1);
    switch_dusk_Schedule.layer.masksToBounds=YES;
    switch_dusk_Schedule.layer.cornerRadius=16.0;
    
    [switch_duskSetting_Schedule setOn:NO animated:NO];
    [switch_duskSetting_Schedule setSelected:NO];
    [switch_duskSetting_Schedule setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_duskSetting_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_duskSetting_Schedule.tintColor=lblRGBA(98, 99, 102, 1);
    switch_duskSetting_Schedule.layer.masksToBounds=YES;
    switch_duskSetting_Schedule.layer.cornerRadius=16.0;
    
    [switch_evenDays_Schedule setOn:NO animated:NO];
    [switch_evenDays_Schedule setSelected:NO];
    [switch_evenDays_Schedule setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_evenDays_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_evenDays_Schedule.tintColor=lblRGBA(98, 99, 102, 1);
    switch_evenDays_Schedule.layer.masksToBounds=YES;
    switch_evenDays_Schedule.layer.cornerRadius=16.0;
    
    [switch_oddDays_Schedule setOn:NO animated:NO];
    [switch_oddDays_Schedule setSelected:NO];
    [switch_oddDays_Schedule setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_oddDays_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_oddDays_Schedule.tintColor=lblRGBA(98, 99, 102, 1);
    switch_oddDays_Schedule.layer.masksToBounds=YES;
    switch_oddDays_Schedule.layer.cornerRadius=16.0;
    
    [switch_RunOnOddEven_Schedule setOn:NO animated:NO];
    [switch_RunOnOddEven_Schedule setSelected:NO];
    [switch_RunOnOddEven_Schedule setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_RunOnOddEven_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_RunOnOddEven_Schedule.tintColor=lblRGBA(98, 99, 102, 1);
    switch_RunOnOddEven_Schedule.layer.masksToBounds=YES;
    switch_RunOnOddEven_Schedule.layer.cornerRadius=16.0;
    
    [switch_timeFromTo_Schedule setOn:NO animated:NO];
    [switch_timeFromTo_Schedule setSelected:NO];
    [switch_timeFromTo_Schedule setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_timeFromTo_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_timeFromTo_Schedule.tintColor=lblRGBA(98, 99, 102, 1);
    switch_timeFromTo_Schedule.layer.masksToBounds=YES;
    switch_timeFromTo_Schedule.layer.cornerRadius=16.0;
    
    //if (![switch_RunOnOddEven_Schedule isOn]) {
    view_OddEven_Schedule.userInteractionEnabled=NO;
    [view_OddEven_Schedule setAlpha:0.4];
    //}switchTime switch_RunOn_Header  switch_ODD_Days  switch_Even_Days
}


-(void)resetODD_EVEN_Days_State
{
    btn_Mon_Schedule.userInteractionEnabled=YES;
    btn_Tues_Schedule.userInteractionEnabled=YES;
    btn_Wed_Schedule.userInteractionEnabled=YES;
    btn_Thur_Schedule.userInteractionEnabled=YES;
    btn_Fri_Schedule.userInteractionEnabled=YES;
    btn_Sat_Schedule.userInteractionEnabled=YES;
    btn_Sun_Schedule.userInteractionEnabled=YES;
    
    if ([strDeviceType_Schedule isEqualToString:@"others"])
    {
        btn_Mon_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Tues_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Wed_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Thur_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Fri_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Sat_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Sun_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
    }else{
        btn_Mon_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Tues_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Wed_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Thur_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Fri_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Sat_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Sun_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
    }
    
    dayMon=YES,dayTus=YES,dayWed=YES,dayThurs=YES,dayFri=YES,daySat=YES,daySun=YES;
    
    strSun=@"true";
    strMon=@"true";
    strTue=@"true";
    strWed=@"true";
    strThr=@"true";
    strFri=@"true";
    strSat=@"true";
    str_Schedule_Day_Type=@"ManualDays";
    
}
-(void)changeODD_EVEN_Days_State
{
    
    btn_Mon_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Tues_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Wed_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Thur_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Fri_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Sat_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Sun_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    dayMon=NO,dayTus=NO,dayWed=NO,dayThurs=NO,dayFri=NO,daySat=NO,daySun=NO;
    
    btn_Mon_Schedule.userInteractionEnabled=NO;
    btn_Tues_Schedule.userInteractionEnabled=NO;
    btn_Wed_Schedule.userInteractionEnabled=NO;
    btn_Thur_Schedule.userInteractionEnabled=NO;
    btn_Fri_Schedule.userInteractionEnabled=NO;
    btn_Sat_Schedule.userInteractionEnabled=NO;
    btn_Sun_Schedule.userInteractionEnabled=NO;
    
    strSun=@"false";
    strMon=@"false";
    strTue=@"false";
    strWed=@"false";
    strThr=@"false";
    strFri=@"false";
    strSat=@"false";
}

-(void)set_New_State_ODD_EVEN
{
    btn_Mon_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Wed_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Fri_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Sun_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Jan_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Feb_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Mar_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Oct_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Nov_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Dec_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
}

-(void)changeDays_Months_Settings_For_Odd
{
    if([switch_oddDays_Schedule isOn]){
        if([switch_evenDays_Schedule isOn]){
            return;
        }else{
            [self set_New_State_ODD_EVEN];
        }
    }else{
        if([switch_evenDays_Schedule isOn]){
            return;
        }else{
            //  [self reset_Old_State_ODD_EVEN];
        }
    }
}

-(void)changeDays_Months_Settings_For_Even
{
    if([switch_evenDays_Schedule isOn]){
        if([switch_oddDays_Schedule isOn]){
            return;
        }else{
            [self set_New_State_ODD_EVEN];
        }
    }else{
        if([switch_oddDays_Schedule isOn]){
            return;
        }else{
            // [self reset_Old_State_ODD_EVEN];
        }
    }
}

-(void)dawn_dusk_switch_Disable
{
    switch_duskSetting_Schedule.enabled=NO;
    [switch_duskSetting_Schedule setOn:NO animated:YES];
    switch_dawnSetting_Schedule.enabled=NO;
    [switch_dawnSetting_Schedule setOn:NO animated:YES];
    switch_dusk_Schedule.enabled=NO;
    [switch_dusk_Schedule setOn:NO animated:YES];
    switch_dawn_Schedule.enabled=NO;
    [switch_dawn_Schedule setOn:NO animated:YES];
    switch_timeFromTo_Schedule.enabled=NO;
    [switch_timeFromTo_Schedule setOn:NO animated:YES];
    startTime=@"00:00:00";
    endTime=@"00:00:00";
}

-(void)dawn_dusk_switch_Enable
{
    switch_duskSetting_Schedule.enabled=YES;
    switch_dawnSetting_Schedule.enabled=YES;
    switch_dusk_Schedule.enabled=YES;
    switch_dawn_Schedule.enabled=YES;
    switch_timeFromTo_Schedule.enabled=YES;
    btn_DawnMinus_Schedule.userInteractionEnabled=NO;
    btn_DawnPlus_Schedule.userInteractionEnabled=NO;
    btn_DuskPlus_Schedule.userInteractionEnabled=NO;
    btn_DuskMinus_Schedule.userInteractionEnabled=NO;
    
    btn_DawnPlus_Schedule.backgroundColor = lblRGBA(98, 99, 102, 1);
    btn_DawnMinus_Schedule.backgroundColor = lblRGBA(98, 99, 102, 1);
    btn_DuskMinus_Schedule.backgroundColor = lblRGBA(98, 99, 102, 1);
    btn_DuskPlus_Schedule.backgroundColor = lblRGBA(98, 99, 102, 1);
    
    intDawnPlusHrs=0,intDawnMinusHrs=0,intDuskPlusHrs=0,intDuskMinusHrs=0;
    incDawnStatus=NO,decDawnStatus=NO,incDuskStatus=NO,decDuskStatus=NO;
    lbl_Dawn_Schedule_Hours.text=@"0 HOUR";
    lbl_Dusk_Schedule_Hours.text=@"0 HOUR";
    btn_StartTime.userInteractionEnabled=NO;
    btn_EndTime.userInteractionEnabled=NO;
}


#pragma mark - IBActions
-(IBAction)toggleSwitch_lightSchedule_Action:(id)sender
{
    
    if ([txtfld_ScheduleName resignFirstResponder]) {
        [txtfld_ScheduleName resignFirstResponder];
    }
    UIButton *btnTag = (UIButton *)sender;
    switch(btnTag.tag){
        case 0:  //Dusk To Dawn
            if ([switch_duskSetting_Schedule isOn] && (![switch_duskSetting_Schedule isSelected]))
            {
                //Write code for SwitchON Action
                NSLog(@"switch calling on");
                str_ScheduleCat_ID=@"2";
                [self dawn_dusk_switch_Disable];
                switch_duskSetting_Schedule.enabled=YES;
                [switch_duskSetting_Schedule setSelected:YES];
                [switch_duskSetting_Schedule setOn:YES animated:YES];
                if([strDeviceType_Schedule isEqualToString:@"lights"]){
                    [switch_duskSetting_Schedule setOnTintColor:lblRGBA(255, 206, 52, 1)];
                }else{
                    [switch_duskSetting_Schedule setOnTintColor:lblRGBA(49, 165, 222, 1)];
                }
            }
            else if ((![switch_duskSetting_Schedule isOn]) && [switch_duskSetting_Schedule isSelected])
            {
                //Write code for SwitchOFF Action
                NSLog(@"switch calling");
                str_ScheduleCat_ID=@"0";
                [switch_duskSetting_Schedule setBackgroundColor:lblRGBA(98, 99, 102, 1)];
                [self dawn_dusk_switch_Enable];
                [switch_duskSetting_Schedule setSelected:NO];
            }
            break;
        case 1: //Dawn To Dusk
            if ([switch_dawnSetting_Schedule isOn] && (![switch_dawnSetting_Schedule isSelected]))
            {
                //Write code for SwitchON Action
                str_ScheduleCat_ID=@"1";
                [self dawn_dusk_switch_Disable];
                switch_dawnSetting_Schedule.enabled=YES;
                [switch_dawnSetting_Schedule setSelected:YES];
                [switch_dawnSetting_Schedule setOn:YES animated:YES];
                if([strDeviceType_Schedule isEqualToString:@"lights"]){
                    [switch_dawnSetting_Schedule setOnTintColor:lblRGBA(255, 206, 52, 1)];
                }else{
                    [switch_dawnSetting_Schedule setOnTintColor:lblRGBA(49, 165, 222, 1)];
                }
            }
            else if ((![switch_dawnSetting_Schedule isOn]) && [switch_dawnSetting_Schedule isSelected])
            {
                //Write code for SwitchOFF Action
                str_ScheduleCat_ID=@"0";
                [switch_dawnSetting_Schedule setBackgroundColor:lblRGBA(98, 99, 102, 1)];
                [self dawn_dusk_switch_Enable];
                [switch_dawnSetting_Schedule setSelected:NO];
            }
            break;
        case 2: //Dusk
            if ([switch_dusk_Schedule isOn] && (![switch_dusk_Schedule isSelected]))
            {
                //Write code for SwitchON Action
                str_ScheduleCat_ID=@"4";
                [self dawn_dusk_switch_Disable];
                switch_dusk_Schedule.enabled=YES;
                [switch_dusk_Schedule setOn:YES animated:YES];
                [switch_dusk_Schedule setSelected:YES];
                btn_DuskMinus_Schedule.userInteractionEnabled=YES;
                btn_DuskPlus_Schedule.userInteractionEnabled=YES;
                if([strDeviceType_Schedule isEqualToString:@"lights"]){
                    [switch_dusk_Schedule setOnTintColor:lblRGBA(255, 206, 52, 1)];
                }else{
                    [switch_dusk_Schedule setOnTintColor:lblRGBA(49, 165, 222, 1)];
                }
            }
            else if ((![switch_dusk_Schedule isOn]) && [switch_dusk_Schedule isSelected])
            {
                //Write code for SwitchOFF Action
                str_ScheduleCat_ID=@"0";
                // startTime=@"00:00:00";
                //endTime=@"00:00:00";
                [switch_dusk_Schedule setBackgroundColor:lblRGBA(98, 99, 102, 1)];
                [self dawn_dusk_switch_Enable];
                [switch_dusk_Schedule setSelected:NO];
            }
            break;
        case 3: //Dawn
            if ([switch_dawn_Schedule isOn] && (![switch_dawn_Schedule isSelected]))
            {
                //Write code for SwitchON Action
                str_ScheduleCat_ID=@"3";
                [self dawn_dusk_switch_Disable];
                switch_dawn_Schedule.enabled=YES;
                [switch_dawn_Schedule setOn:YES animated:YES];
                [switch_dawn_Schedule setSelected:YES];
                btn_DawnMinus_Schedule.userInteractionEnabled=YES;
                btn_DawnPlus_Schedule.userInteractionEnabled=YES;
                if([strDeviceType_Schedule isEqualToString:@"lights"]){
                    [switch_dawn_Schedule setOnTintColor:lblRGBA(255, 206, 52, 1)];
                }else{
                    [switch_dawn_Schedule setOnTintColor:lblRGBA(49, 165, 222, 1)];
                }
            }
            else if ((![switch_dawn_Schedule isOn]) && [switch_dawn_Schedule isSelected])
            {
                //Write code for SwitchOFF Action
                str_ScheduleCat_ID=@"0";
                // startTime=@"00:00:00";
                // endTime=@"00:00:00";
                [switch_dawn_Schedule setBackgroundColor:lblRGBA(98, 99, 102, 1)];
                [self dawn_dusk_switch_Enable];
                [switch_dawn_Schedule setSelected:NO];
                
            }
            
            break;
        case 4: //Manual
            if ([switch_timeFromTo_Schedule isOn] && (![switch_timeFromTo_Schedule isSelected]))
            {
                //Write code for SwitchON Action
                str_ScheduleCat_ID=@"5";
                [self dawn_dusk_switch_Disable];
                switch_timeFromTo_Schedule.enabled=YES;
                [switch_timeFromTo_Schedule setOn:YES animated:YES];
                [switch_timeFromTo_Schedule setSelected:YES];
                btn_StartTime.userInteractionEnabled=YES;
                btn_EndTime.userInteractionEnabled=YES;
                if([strDeviceType_Schedule isEqualToString:@"lights"]){
                    [switch_timeFromTo_Schedule setOnTintColor:lblRGBA(255, 206, 52, 1)];
                }else{
                    [switch_timeFromTo_Schedule setOnTintColor:lblRGBA(49, 165, 222, 1)];
                }
            }
            else if ((![switch_timeFromTo_Schedule isOn]) && [switch_timeFromTo_Schedule isSelected])
            {
                //Write code for SwitchOFF Action
                str_ScheduleCat_ID=@"0";
                // startTime=@"00:00:00";
                // endTime=@"00:00:00";
                [btn_StartTime setTitle:@"00:00AM" forState:UIControlStateNormal];
                [btn_EndTime setTitle:@"00:00PM" forState:UIControlStateNormal];
                [switch_timeFromTo_Schedule setBackgroundColor:lblRGBA(98, 99, 102, 1)];
                [self dawn_dusk_switch_Enable];
                [switch_timeFromTo_Schedule setSelected:NO];
            }
            break;
        case 5: //Run on switch header
            if([switch_RunOnOddEven_Schedule isOn] && (![switch_RunOnOddEven_Schedule isSelected]))
            {
                //Write code for SwitchON Action
                str_Schedule_Day_Type=@"RunOn";
                [self changeODD_EVEN_Days_State];
                view_OddEven_Schedule.userInteractionEnabled=YES;
                [view_OddEven_Schedule setAlpha:1.0];
                [switch_RunOnOddEven_Schedule setOn:YES animated:YES];
                [switch_RunOnOddEven_Schedule setSelected:YES];
                if([strDeviceType_Schedule isEqualToString:@"lights"]){
                    [switch_RunOnOddEven_Schedule setOnTintColor:lblRGBA(255, 206, 52, 1)];
                }else{
                    [switch_RunOnOddEven_Schedule setOnTintColor:lblRGBA(49, 165, 222, 1)];
                }
            }
            else if((![switch_RunOnOddEven_Schedule isOn]) && [switch_RunOnOddEven_Schedule isSelected])
            {
                //Write code for SwitchOFF Action
                str_Schedule_Day_Type=@"";
                oddDays=NO,evenDays=NO;
                strOddDay=@"false";
                strEvenDay=@"false";
                [self resetODD_EVEN_Days_State];
                [switch_RunOnOddEven_Schedule setBackgroundColor:lblRGBA(98, 99, 102, 1)];
                view_OddEven_Schedule.userInteractionEnabled=NO;
                [view_OddEven_Schedule setAlpha:0.4];
                [switch_RunOnOddEven_Schedule setSelected:NO];
                [switch_evenDays_Schedule setSelected:NO];
                [switch_evenDays_Schedule setOn:NO animated:YES];
                [switch_oddDays_Schedule setSelected:NO];
                [switch_oddDays_Schedule setOn:NO animated:YES];
            }
            break;
        case 6: //Odd switch run on
            if ([switch_oddDays_Schedule isOn] && (![switch_oddDays_Schedule isSelected]))
            {
                //Write code for SwitchON Action
                oddDays=YES;
                strOddDay=@"true";
                [switch_oddDays_Schedule setSelected:YES];
                [switch_oddDays_Schedule setOn:YES animated:YES];
                if([strDeviceType_Schedule isEqualToString:@"lights"]){
                    [switch_oddDays_Schedule setOnTintColor:lblRGBA(255, 206, 52, 1)];
                }else{
                    [switch_oddDays_Schedule setOnTintColor:lblRGBA(49, 165, 222, 1)];
                }
            }
            else if ((![switch_oddDays_Schedule isOn]) && [switch_oddDays_Schedule isSelected])
            {
                //Write code for SwitchOFF Action
                oddDays=NO;
                strOddDay=@"false";
                [switch_oddDays_Schedule setBackgroundColor:lblRGBA(98, 99, 102, 1)];
                [switch_oddDays_Schedule setSelected:NO];
                // [switch_oddDays_Schedule setOn:YES animated:YES];
            }
            
            //[self changeDays_Months_Settings_For_Odd]; not need
            break;
        case 7: //Even switch run on
            if ([switch_evenDays_Schedule isOn] && (![switch_evenDays_Schedule isSelected]))
            {
                //Write code for SwitchON Action
                evenDays=YES;
                strEvenDay=@"true";
                [switch_evenDays_Schedule setSelected:YES];
                [switch_evenDays_Schedule setOn:YES animated:YES];
                if([strDeviceType_Schedule isEqualToString:@"lights"]){
                    [switch_evenDays_Schedule setOnTintColor:lblRGBA(255, 206, 52, 1)];
                }else{
                    [switch_evenDays_Schedule setOnTintColor:lblRGBA(49, 165, 222, 1)];
                }
            }
            else if ((![switch_evenDays_Schedule isOn]) && [switch_evenDays_Schedule isSelected])
            {
                //Write code for SwitchOFF Action
                evenDays=NO;
                strEvenDay=@"false";
                [switch_evenDays_Schedule setSelected:NO];
                //[switch_evenDays_Schedule setOn:NO animated:YES];
                [switch_evenDays_Schedule setBackgroundColor:lblRGBA(98, 99, 102, 1)];
            }
            
            // [self changeDays_Months_Settings_For_Even];  not need
            break;
    }
}

-(IBAction)monthSelected_lightSchedule_Action:(id)sender
{
    if ([txtfld_ScheduleName resignFirstResponder]) {
        [txtfld_ScheduleName resignFirstResponder];
    }
    UIButton *btnTag = (UIButton *)sender;
//    str_Schedule_Month=@"Month";
    switch(btnTag.tag){
        case 0:
        {
            if(monJan==YES){
                monJan=NO;
                strJan=@"false";
//                str_Schedule_Month=@"";
                btn_Jan_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monJan=YES;
                strJan=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Jan_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Jan_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
            
        }
            break;
        case 1:
        {
            if(monFeb==YES){
                monFeb=NO;
                strFeb=@"false";
//                str_Schedule_Month=@"";
                btn_Feb_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monFeb=YES;
                strFeb=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Feb_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Feb_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 2:
        {
            if(monMar==YES){
                monMar=NO;
                strMar=@"false";
//                str_Schedule_Month=@"";
                btn_Mar_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monMar=YES;
                strMar=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Mar_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Mar_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 3:
        {
            if(monApr==YES){
                monApr=NO;
                strApr=@"false";
//                str_Schedule_Month=@"";
                btn_Apr_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monApr=YES;
                strApr=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Apr_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Apr_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 4:
        {
            if(monMay==YES){
                monMay=NO;
                strMay=@"false";
//                str_Schedule_Month=@"";
                btn_May_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monMay=YES;
                strMay=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_May_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_May_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 5:
        {
            if(monJun==YES){
                monJun=NO;
                strJun=@"false";
//                str_Schedule_Month=@"";
                btn_June_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monJun=YES;
                strJun=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_June_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_June_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 6:
        {
            if(monJly==YES){
                monJly=NO;
                strJly=@"false";
//                str_Schedule_Month=@"";
                btn_July_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monJly=YES;
                strJly=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_July_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_July_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 7:
        {
            if(monAug==YES){
                monAug=NO;
                strAug=@"false";
//                str_Schedule_Month=@"";
                btn_Aug_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monAug=YES;
                strAug=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Aug_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Aug_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 8:
        {
            if(monSep==YES){
                monSep=NO;
                strSep=@"false";
                str_Schedule_Month=@"";
                btn_Sep_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monSep=YES;
                strSep=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Sep_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Sep_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 9:
        {
            if(monOct==YES){
                monOct=NO;
                strOct=@"false";
//                str_Schedule_Month=@"";
                btn_Oct_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monOct=YES;
                strOct=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Oct_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Oct_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 10:
        {
            if(monNov==YES){
                monNov=NO;
                strNov=@"false";
//                str_Schedule_Month=@"";
                btn_Nov_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monNov=YES;
                strNov=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Nov_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Nov_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 11:
        {
            if(monDec==YES){
                monDec=NO;
                strDec=@"false";
//                str_Schedule_Month=@"";
                btn_Dec_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monDec=YES;
                strDec=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Dec_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Dec_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
    }
    if (monJan==YES || monFeb==YES || monMar==YES || monApr==YES || monMay==YES || monJun==YES || monJly==YES || monAug==YES || monSep==YES || monOct==YES || monNov==YES || monDec==YES) {
        str_Schedule_Month=@"Month";
    }else{
        str_Schedule_Month=@"";
    }
}

-(IBAction)networkHome_Setting_Schedule_Action:(id)sender
{
    if ([txtfld_ScheduleName resignFirstResponder]) {
        [txtfld_ScheduleName resignFirstResponder];
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIButton *btnTag = (UIButton *)sender;
    NSLog(@"btn tag ==%ld",(long)btnTag.tag);
    switch (btnTag.tag) {
        case 0:
        {
            txtfld_ScheduleName.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_ScheduleName.text];
            if(txtfld_ScheduleName.text.length==0)
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"Please enter schedule name"];
                return;
            }
            else if([str_ScheduleCat_ID isEqualToString:@"0"]){
                [Common showAlert:kAlertTitleWarning withMessage:@"Please select any one schedule time"];
                return;
            }
            else if([str_Schedule_Day_Type isEqualToString:@""])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"Please select either run on days or manual days"];
                return;
            }
            else if([str_Schedule_Month isEqualToString:@""]){
                [Common showAlert:kAlertTitleWarning withMessage:@"Please select atleast one month"];
                return;
            }
            if([str_ScheduleCat_ID isEqualToString:@"3"])
            {
//                if ([btn_DawnPlus_Schedule.backgroundColor isEqual:lblRGBA(255, 206, 52, 1)]) {
//                    if ([endTime isEqualToString:@"00:00:00"]) {
//                        endTime = startTime;
//                        startTime = @"00:00:00";
//                    }
//                }else if ([btn_DawnMinus_Schedule.backgroundColor isEqual:lblRGBA(255, 206, 52, 1)]){
//                    if ([startTime isEqualToString:@"00:00:00"]) {
//                        startTime = endTime;
//                        endTime = @"00:00:00";
//                    }
//                }
                if ([lbl_Dawn_Schedule_Hours.text isEqualToString:@"0 HOUR"]) {
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please provide hours"];
                    return;
                }
                if ([btn_DawnPlus_Schedule.backgroundColor isEqual:lblRGBA(255, 206, 52, 1)]||[btn_DawnPlus_Schedule.backgroundColor isEqual:lblRGBA(49, 165, 222, 1)])
                {
                    NSLog(@"plus");
                    startTime=[NSString stringWithFormat:@"00:00:00"];
                    NSString *stringToHours = [NSString stringWithFormat:@"%d", intDawnPlusHrs];
                    if(stringToHours.length>1)
                    {
                        endTime=[NSString stringWithFormat:@"%d:00:00",intDawnPlusHrs];
                        
                    }else{
                        endTime=[NSString stringWithFormat:@"0%d:00:00",intDawnPlusHrs];
                    }
                }
                
                else if([btn_DawnMinus_Schedule.backgroundColor isEqual:lblRGBA(255, 206, 52, 1)]||[btn_DawnMinus_Schedule.backgroundColor isEqual:lblRGBA(49, 165, 222, 1)])
                {
                    NSLog(@"minus");
                    endTime=[NSString stringWithFormat:@"00:00:00"];
                    NSString *stringToHours = [NSString stringWithFormat:@"%d", intDawnMinusHrs];
                    if(stringToHours.length>1)
                    {
                        startTime=[NSString stringWithFormat:@"%d:00:00",intDawnMinusHrs];
                    }else{
                        startTime=[NSString stringWithFormat:@"0%d:00:00",intDawnMinusHrs];
                    }
                }
            }else if ([str_ScheduleCat_ID isEqualToString:@"4"]){
                
                if ([lbl_Dusk_Schedule_Hours.text isEqualToString:@"0 HOUR"]) {
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please provide hours"];
                    return;
                }
                if ([btn_DuskPlus_Schedule.backgroundColor isEqual:lblRGBA(255, 206, 52, 1)]||[btn_DuskPlus_Schedule.backgroundColor isEqual:lblRGBA(49, 165, 222, 1)])
                {
                    NSLog(@"plus");
                    startTime=[NSString stringWithFormat:@"00:00:00"];
                    NSString *stringToHours = [NSString stringWithFormat:@"%d", intDuskPlusHrs];
                    if(stringToHours.length>1)
                    {
                        endTime=[NSString stringWithFormat:@"%d:00:00",intDuskPlusHrs];
                        
                    }else{
                        endTime=[NSString stringWithFormat:@"0%d:00:00",intDuskPlusHrs];
                    }
                }
                
                else if([btn_DuskMinus_Schedule.backgroundColor isEqual:lblRGBA(255, 206, 52, 1)]||[btn_DuskMinus_Schedule.backgroundColor isEqual:lblRGBA(49, 165, 222, 1)])
                {
                    NSLog(@"minus");
                    endTime=[NSString stringWithFormat:@"00:00:00"];
                    NSString *stringToHours = [NSString stringWithFormat:@"%d", intDuskMinusHrs];
                    if(stringToHours.length>1)
                    {
                        startTime=[NSString stringWithFormat:@"%d:00:00",intDuskMinusHrs];
                    }else{
                        startTime=[NSString stringWithFormat:@"0%d:00:00",intDuskMinusHrs];
                    }
                }
            }
            else if([str_ScheduleCat_ID isEqualToString:@"5"])
            {
                if([btn_StartTime.titleLabel.text isEqualToString:@"00:00AM"]&&[btn_EndTime.titleLabel.text isEqualToString:@"00:00PM"])
                {
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please select start time and end time"];
                    return;
                }
                else if([btn_StartTime.titleLabel.text isEqualToString:@"00:00AM"])
                {
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please select start time "];
                    return;
                }
                else if([btn_EndTime.titleLabel.text isEqualToString:@"00:00PM"])
                {
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please select end time "];
                    return;
                }
                else if([btn_StartTime.titleLabel.text isEqualToString:btn_EndTime.titleLabel.text])
                {
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please select different end time"];
                    return;
                }
                else{
                    if ([btn_EndTime.titleLabel.text rangeOfString:@"AM"].location != NSNotFound && [btn_StartTime.titleLabel.text rangeOfString:@"PM"].location != NSNotFound) {
                        NSLog(@"string contains AM");
                        [Common showAlert:kAlertTitleWarning withMessage:@"Please select end time on same day"];
                        return;
                    }
                    else if (([btn_EndTime.titleLabel.text rangeOfString:@"AM"].location != NSNotFound && [btn_StartTime.titleLabel.text rangeOfString:@"AM"].location != NSNotFound) || ([btn_EndTime.titleLabel.text rangeOfString:@"PM"].location != NSNotFound && [btn_StartTime.titleLabel.text rangeOfString:@"PM"].location != NSNotFound)) {
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"HH:mm:ss"];
                        
                        NSDate *zeroDate = [dateFormatter dateFromString:formatedDateFrom];
                        NSDate *offsetDate = [dateFormatter dateFromString:formatedDateTo];
                        NSTimeInterval timeDifference = [offsetDate timeIntervalSinceDate:zeroDate];
                        CGFloat minutes = (timeDifference/60);
                        NSLog(@"minutes==%f",minutes);
                        NSLog(@"%0.2fmins",minutes);
                        if (minutes<0) {
                            [Common showAlert:kAlertTitleWarning withMessage:@"Please select end time on same day"];
                            return;
                        }
                    }
                }
                startTime=formatedDateFrom;   //formatedDateFromRail not need
                endTime=formatedDateTo;    // formatedDateToRail not need
            }
            if([str_Schedule_Day_Type isEqualToString:@"RunOn"]){
                if(oddDays==NO && evenDays==NO)
                {
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please Select ODD or EVEN Days"];
                    return;
                }
            }
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_ScheduleAdd) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(schedule_Add_Device) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 1:
        {
            if ([appDelegate.strNoidLogo isEqualToString:@"NetworkHome"]) {
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
            }else{
                [Common resetNetworkFlags];
                SWRevealViewController *NHVC = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
                NHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                NSArray *newStack = @[NHVC];
                [Common viewFadeIn:self.navigationController.view];
                [self.navigationController setViewControllers:newStack animated:NO];
            }
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
        case 3: //skip sch and save
        {
            if([appDelegate.strDevice_Added_Mode isEqualToString:@"NetworkHome"])
            {
                for (UIViewController *controller in [self.navigationController viewControllers])
                {
                    if ([controller isKindOfClass:[SWRevealViewController class]])
                    {
                        [Common viewFadeIn:self.navigationController.view];
                        [self.navigationController popToViewController:controller animated:NO];
                        break;
                    }
                }
            }else{
                appDelegate.strDevice_Added_Status = @"NEWPOPUPLOAD";
                SWRevealViewController *NHVC = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
                NHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                NSArray *newStack = @[NHVC];
                [Common viewFadeIn:self.navigationController.view];
                [self.navigationController setViewControllers:newStack animated:NO];
            }
        }
            break;
        case 4:
        {
            [Common viewFadeIn:self.navigationController.view];
            [self.navigationController popViewControllerAnimated:NO];
        }
            break;
    }
}

-(IBAction)dawn_dusk_increment_decrement_Action:(id)sender
{
    if ([txtfld_ScheduleName resignFirstResponder]) {
        [txtfld_ScheduleName resignFirstResponder];
    }
    NSLog(@"start time = %@ and end time = %@",startTime,endTime);
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:  //DAWN PLUS
        {
            NSLog(@"dawnplushrs=%d",intDawnPlusHrs);
            NSLog(@"dawnminushrs=%d",intDawnMinusHrs);
            
            if (intDawnMinusHrs<=23 && intDawnMinusHrs!=0){
                if(incDawnStatus==YES){
                    intDawnPlusHrs=intDawnPlusHrs+1;
                    intDawnMinusHrs=0;
                }else{
                    intDawnPlusHrs = intDawnMinusHrs-1;
                    intDawnMinusHrs = intDawnPlusHrs;
                }
                if (intDawnPlusHrs==0) {
                    btn_DawnPlus_Schedule.backgroundColor = lblRGBA(98, 99, 102, 1);
                    btn_DawnMinus_Schedule.backgroundColor = lblRGBA(98, 99, 102, 1);
                }
            }
            else if (intDawnPlusHrs<23 || intDawnPlusHrs==0)
            {
                intDawnPlusHrs = intDawnPlusHrs+1;
                incDawnStatus=YES;
                decDawnStatus=NO;
                if(intDawnMinusHrs==0&&decDawnStatus==NO){
                    if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                        btn_DawnPlus_Schedule.backgroundColor = lblRGBA(49, 165, 222, 1);
                    }else{
                        btn_DawnPlus_Schedule.backgroundColor = lblRGBA(255, 206, 52, 1);
                        
                    }
                    
                }
            }
            else if(intDawnPlusHrs>=23) {
                incDawnStatus=YES;
                decDawnStatus=NO;
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_DawnPlus_Schedule.backgroundColor = lblRGBA(49, 165, 222, 1);
                }else{
                    btn_DawnPlus_Schedule.backgroundColor = lblRGBA(255, 206, 52, 1);
                }
                
                return;
            }
            
            if (intDawnPlusHrs<=1) {
                lbl_Dawn_Schedule_Hours.text = [NSString stringWithFormat:@"%d HOUR",intDawnPlusHrs];
               // startTime=[NSString stringWithFormat:@"00:00:00"];
                
            }else{
                lbl_Dawn_Schedule_Hours.text = [NSString stringWithFormat:@"%d HOURS",intDawnPlusHrs];
               // startTime=[NSString stringWithFormat:@"00:00:00"];
            }
//            NSString *stringToHours = [NSString stringWithFormat:@"%d", intDawnPlusHrs];
//            if(stringToHours.length>1)
//            {
//               / endTime=[NSString stringWithFormat:@"%d:00:00",intDawnPlusHrs];
//                
//            }else{
//                endTime=[NSString stringWithFormat:@"0%d:00:00",intDawnPlusHrs];
//            }
            
            
        }
            //[self dawn_dusk_Time_Disable];
            
            break;
        case 1:    //DAWN MINUS
        {
            if (intDawnPlusHrs<=23 && intDawnPlusHrs!=0) {
                if(decDawnStatus==YES){
                    intDawnMinusHrs=intDawnMinusHrs+1;
                    intDawnPlusHrs=0;
                }else{
                    intDawnMinusHrs = intDawnPlusHrs-1;
                    intDawnPlusHrs = intDawnMinusHrs;
                }
                //  btn_DawnPlus_Schedule.backgroundColor = lblRGBA(255, 206, 52, 1);
                if (intDawnMinusHrs==0) {
                    btn_DawnMinus_Schedule.backgroundColor = lblRGBA(98, 99, 102, 1);
                    btn_DawnPlus_Schedule.backgroundColor = lblRGBA(98, 99, 102, 1);
                }
            }else if (intDawnMinusHrs==0 || intDawnMinusHrs<23) {
                incDawnStatus=NO;
                decDawnStatus=YES;
                intDawnMinusHrs = intDawnMinusHrs+1;
                if(intDawnPlusHrs==0&&incDawnStatus==NO){
                    if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                        btn_DawnMinus_Schedule.backgroundColor = lblRGBA(49, 165, 222, 1);
                    }else{
                        btn_DawnMinus_Schedule.backgroundColor = lblRGBA(255, 206, 52, 1);
                    }
                    
                }
            }else if (intDawnMinusHrs>=23){
                incDawnStatus=NO;
                decDawnStatus=YES;
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_DawnMinus_Schedule.backgroundColor = lblRGBA(49, 165, 222, 1);
                }else{
                    btn_DawnMinus_Schedule.backgroundColor = lblRGBA(255, 206, 52, 1);
                }
                
                return;
            }
            
            if (intDawnMinusHrs<=1) {
                lbl_Dawn_Schedule_Hours.text = [NSString stringWithFormat:@"%d HOUR",intDawnMinusHrs];
                
                //endTime=[NSString stringWithFormat:@"00:00:00"];
            }else{
                lbl_Dawn_Schedule_Hours.text = [NSString stringWithFormat:@"%d HOURS",intDawnMinusHrs];
                
                //endTime=[NSString stringWithFormat:@"00:00:00"];
            }
//            NSString *stringToHours = [NSString stringWithFormat:@"%d", intDawnMinusHrs];
//            if(stringToHours.length>1)
//            {
//                startTime=[NSString stringWithFormat:@"%d:00:00",intDawnMinusHrs];
//            }else{
//                startTime=[NSString stringWithFormat:@"0%d:00:00",intDawnMinusHrs];
//            }
        }
            //  [self dawn_dusk_Time_Disable];
            
            break;
        case 2: //DUSK PLUS
        {
            NSLog(@"duskplushrs=%d",intDuskPlusHrs);
            NSLog(@"duskminushrs=%d",intDuskMinusHrs);
            
            if (intDuskMinusHrs<=23 && intDuskMinusHrs!=0){
                if(incDuskStatus==YES){
                    intDuskPlusHrs=intDuskPlusHrs+1;
                    intDuskMinusHrs=0;
                }else{
                    intDuskPlusHrs = intDuskMinusHrs-1;
                    intDuskMinusHrs = intDuskPlusHrs;
                }
                if (intDuskPlusHrs==0) {
                    btn_DuskPlus_Schedule.backgroundColor = lblRGBA(98, 99, 102, 1);
                    btn_DuskMinus_Schedule.backgroundColor = lblRGBA(98, 99, 102, 1);
                }
            }
            else if (intDuskPlusHrs<23 || intDuskPlusHrs==0)
            {
                intDuskPlusHrs = intDuskPlusHrs+1;
                incDuskStatus=YES;
                decDuskStatus=NO;
                if(intDuskMinusHrs==0&&decDuskStatus==NO){
                    if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                        btn_DuskPlus_Schedule.backgroundColor = lblRGBA(49, 165, 222, 1);
                    }else{
                        btn_DuskPlus_Schedule.backgroundColor = lblRGBA(255, 206, 52, 1);
                    }
                    
                }
            }
            else if(intDuskPlusHrs>=23) {
                incDuskStatus=YES;
                decDuskStatus=NO;
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_DuskPlus_Schedule.backgroundColor = lblRGBA(49, 165, 222, 1);
                }else{
                    btn_DuskPlus_Schedule.backgroundColor = lblRGBA(255, 206, 52, 1);
                }
                
                return;
            }
            
            if (intDuskPlusHrs<=1) {
                lbl_Dusk_Schedule_Hours.text = [NSString stringWithFormat:@"%d HOUR",intDuskPlusHrs];
                //startTime=[NSString stringWithFormat:@"00:00:00"];
                
            }else{
                lbl_Dusk_Schedule_Hours.text = [NSString stringWithFormat:@"%d HOURS",intDuskPlusHrs];
               // startTime=[NSString stringWithFormat:@"00:00:00"];
                
            }
//            NSString *stringToHours = [NSString stringWithFormat:@"%d", intDuskPlusHrs];
//            if(stringToHours.length>1)
//            {
//                endTime=[NSString stringWithFormat:@"%d:00:00",intDuskPlusHrs];
//            }else{
//                endTime=[NSString stringWithFormat:@"0%d:00:00",intDuskPlusHrs];
//            }
        }
            break;
        case 3:   //DUSK MINUS
        {
            if (intDuskPlusHrs<=23 && intDuskPlusHrs!=0) {
                if(decDuskStatus==YES){
                    intDuskMinusHrs=intDuskMinusHrs+1;
                    intDuskPlusHrs=0;
                }else{
                    intDuskMinusHrs = intDuskPlusHrs-1;
                    intDuskPlusHrs = intDuskMinusHrs;
                }
                //  btn_DawnPlus_Schedule.backgroundColor = lblRGBA(255, 206, 52, 1);
                if (intDuskMinusHrs==0) {
                    btn_DuskPlus_Schedule.backgroundColor = lblRGBA(98, 99, 102, 1);
                    btn_DuskMinus_Schedule.backgroundColor = lblRGBA(98, 99, 102, 1);
                }
            }else if (intDuskMinusHrs==0 || intDuskMinusHrs<23) {
                incDuskStatus=NO;
                decDuskStatus=YES;
                intDuskMinusHrs = intDuskMinusHrs+1;
                if(intDuskPlusHrs==0&&incDuskStatus==NO){
                    if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                        btn_DuskMinus_Schedule.backgroundColor = lblRGBA(49, 165, 222, 1);
                    }else{
                        btn_DuskMinus_Schedule.backgroundColor = lblRGBA(255, 206, 52, 1);
                    }
                    
                }
            }else if (intDuskMinusHrs>=23){
                incDuskStatus=NO;
                decDuskStatus=YES;
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_DuskMinus_Schedule.backgroundColor = lblRGBA(49, 165, 222, 1);
                }else{
                    btn_DuskMinus_Schedule.backgroundColor = lblRGBA(255, 206, 52, 1);
                }
                
                return;
            }
            
            if (intDuskMinusHrs<=1) {
                lbl_Dusk_Schedule_Hours.text = [NSString stringWithFormat:@"%d HOUR",intDuskMinusHrs];
                
                //endTime=[NSString stringWithFormat:@"00:00:00"];
            }else{
                lbl_Dusk_Schedule_Hours.text = [NSString stringWithFormat:@"%d HOURS",intDuskMinusHrs];
                
               // endTime=[NSString stringWithFormat:@"00:00:00"];
            }
//            NSString *stringToHours = [NSString stringWithFormat:@"%d", intDuskMinusHrs];
//            if(stringToHours.length>1)
//            {
//                startTime=[NSString stringWithFormat:@"%d:00:00",intDuskMinusHrs];
//            }else{
//                startTime=[NSString stringWithFormat:@"0%d:00:00",intDuskMinusHrs];
//            }
        }
            break;
            
    }
}

-(IBAction)daySelected_lightSchedule_Action:(id)sender
{
    if ([txtfld_ScheduleName resignFirstResponder]) {
        [txtfld_ScheduleName resignFirstResponder];
    }
    UIButton *btnTag = (UIButton *)sender;
//    str_Schedule_Day_Type=@"ManualDays";
    switch (btnTag.tag) {
        case 0:
        {
            if(dayMon==YES){
                dayMon=NO;
//                str_Schedule_Day_Type=@"";
                strMon=@"false";
                btn_Mon_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                dayMon=YES;
                strMon=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Mon_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Mon_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 1:
        {
            if(dayTus==YES){
                dayTus=NO;
                strTue=@"false";
//                str_Schedule_Day_Type=@"";
                btn_Tues_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                dayTus=YES;
                strTue=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Tues_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Tues_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 2:
        {
            if(dayWed==YES){
                dayWed=NO;
                strWed=@"false";
//                str_Schedule_Day_Type=@"";
                btn_Wed_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                dayWed=YES;
                strWed=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Wed_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Wed_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 3:
        {
            if(dayThurs==YES){
                dayThurs=NO;
                strThr=@"false";
//                str_Schedule_Day_Type=@"";
                btn_Thur_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                dayThurs=YES;
                strThr=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Thur_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Thur_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 4:
        {
            if(dayFri==YES){
                dayFri=NO;
                strFri=@"false";
//                str_Schedule_Day_Type=@"";
                btn_Fri_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                dayFri=YES;
                strFri=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Fri_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Fri_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 5:
        {
            if(daySat==YES){
                daySat=NO;
                strSat=@"false";
//                str_Schedule_Day_Type=@"";
                btn_Sat_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                daySat=YES;
                strSat=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Sat_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Sat_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 6:
        {
            if(daySun==YES){
                daySun=NO;
                strSun=@"false";
//                str_Schedule_Day_Type=@"";
                btn_Sun_Schedule.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                daySun=YES;
                strSun=@"true";
                if ([strDeviceType_Schedule isEqualToString:@"others"]) {
                    btn_Sun_Schedule.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Sun_Schedule.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
    }
    if (dayMon==YES || dayTus==YES || dayWed==YES || dayThurs==YES || dayFri==YES || daySat==YES || daySun==YES) {
        str_Schedule_Day_Type=@"ManualDays";
    }else {
        str_Schedule_Day_Type=@"";
    }
}
-(IBAction)timePicker_Action:(id)sender
{
    if ([txtfld_ScheduleName resignFirstResponder]) {
        [txtfld_ScheduleName resignFirstResponder];
    }
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Start Time
        {
            timerType=@"From";
            [scrollView_Schedule setUserInteractionEnabled:NO];
            [scrollView_Schedule setAlpha:0.4];
            [UIView animateWithDuration:.25 animations:^{
                pickerView .frame=CGRectMake(0, self.view.frame.size.height-pickerView.frame.size.height+20, pickerView.frame.size.width, pickerView.frame.size.height);
            }];
            
        }
            break;
        case 1: //End Time
        {
            timerType=@"To";
            [scrollView_Schedule setUserInteractionEnabled:NO];
            [scrollView_Schedule setAlpha:0.4];
            [UIView animateWithDuration:.25 animations:^{
                pickerView .frame=CGRectMake(0, self.view.frame.size.height-pickerView.frame.size.height+20, pickerView.frame.size.width, pickerView.frame.size.height);
            }];
        }
            break;
        case 2: //Ok
        {
            hour=1;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"HH:mm:ss";
            NSDateFormatter *dateFormatter12 = [[NSDateFormatter alloc] init];
            dateFormatter12.dateFormat = @"hh:mm a";
            if([timerType isEqualToString:@"From"])
            {
                formatedDateFrom = [dateFormatter stringFromDate:timePicker.date];
                DateFrom = [dateFormatter12 stringFromDate:timePicker.date];
                NSLog(@"formatted date==%@",formatedDateFrom);
                [btn_StartTime setTitle:DateFrom forState:UIControlStateNormal];
                
            }
            else
            {
                formatedDateTo = [dateFormatter stringFromDate:timePicker.date];
                DateTo = [dateFormatter12 stringFromDate:timePicker.date];
                NSLog(@"formatted date==%@",formatedDateTo);
                [btn_EndTime setTitle:DateTo forState:UIControlStateNormal];
            }
            
            
//            NSDate * from = [dateFormatter dateFromString:formatedDateFrom];
//            NSDate * to = [dateFormatter dateFromString:formatedDateTo];
//            NSTimeInterval interval = [from timeIntervalSinceDate:to];
//            
//            hours = fabs(interval / 3600);
//            NSLog(@"Difference %d",hours);
            
           // if([btn_StartTime.titleLabel.text isEqualToString:@"00:00AM"]&&[btn_EndTime.titleLabel.text isEqualToString:@"00:00PM"])
           // {
                if([timerType isEqualToString:@"From"])
                {
                    [btn_StartTime setTitle:DateFrom forState:UIControlStateNormal];
                }else
                {
                    [btn_EndTime setTitle:DateTo forState:UIControlStateNormal];
                }
//            }
//            else{
//                if ([to compare:from] != NSOrderedDescending) {
//                    hour = 24-hours;
//                    NSLog(@"%d",hour);
//                }else{
//                    // hour=hours;
//                    NSLog(@"%d",hours);
//                }
//            }
            [UIView animateWithDuration:.25 animations:^{
                pickerView.frame=CGRectMake(0, 2000, pickerView.frame.size.width, pickerView.frame.size.height);
            }];
            [scrollView_Schedule setUserInteractionEnabled:YES];
            [scrollView_Schedule setAlpha:1.0];
        }
            break;
        case 3: //Cancel
        {
            [UIView animateWithDuration:.25 animations:^{
                pickerView.frame=CGRectMake(0, 2000, pickerView.frame.size.width, pickerView.frame.size.height);
            }];
            [scrollView_Schedule setUserInteractionEnabled:YES];
            [scrollView_Schedule setAlpha:1.0];
        }
            break;
    }
}


#pragma mark - Textfield Delegates
/* **********************************************************************************
 Date : 23/09/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the textfield is selected.
 Method Name : textFieldShouldBeginEditing(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

/* **********************************************************************************
 Date : 23/09/2015
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"Characters Entered");
    if ((range.location == 0 && [string isEqualToString:@" "]) || (range.location == 0 && [string isEqualToString:@"'"]))
    {
        return NO;
    }
    NSLog(@"string === %@",string);
    NSString * proposedNewString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"whole string === %@",proposedNewString);
    if(textField==txtfld_ScheduleName)
    {
        NSUInteger newLength = [txtfld_ScheduleName.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_DEVICENAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldDigitsPWd));
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    
    textField.text=@"";
    
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - Orientation
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
        TLVC.strNoidLogo_Status=@"";
        [self.navigationController pushViewController:TLVC animated:NO];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        NSLog(@"Landscape right");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        [self.navigationController pushViewController:TLVC animated:NO];
        TLVC.strNoidLogo_Status=@"";
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
    }
}

#pragma mark - Webservice implementation
-(void)schedule_Add_Device
{
    //  self.strDeviceID=@"0";
    NSDictionary *parameters;
    defaults=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/%@/deviceSchedules?isAllowDuplicateSchedule=%@",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],self.strDeviceID,strAllowDuplicate];
    NSLog(@"method name==%@",strMethodNameWith_Value);
    NSMutableDictionary *dictSchedule_Details=[[NSMutableDictionary alloc] init];
    [dictSchedule_Details setObject:self.strDeviceID forKey:kDeviceID];
    [dictSchedule_Details setObject:txtfld_ScheduleName.text forKey:kscheduleName];
    [dictSchedule_Details setObject:[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID] forKey:kControllerID];
    if([strDeviceType_Schedule isEqualToString:@"lights"]){
        [dictSchedule_Details setObject:@"1" forKey:kDeviceType];
    }else{
        [dictSchedule_Details setObject:@"3" forKey:kDeviceType];
    }
    [dictSchedule_Details setObject:strJan forKey:kJan];
    [dictSchedule_Details setObject:strFeb forKey:kFeb];
    [dictSchedule_Details setObject:strMar forKey:kMar];
    [dictSchedule_Details setObject:strApr forKey:kApr];
    [dictSchedule_Details setObject:strMay forKey:kMay];
    [dictSchedule_Details setObject:strJun forKey:kJun];
    [dictSchedule_Details setObject:strJly forKey:kJly];
    [dictSchedule_Details setObject:strAug forKey:kAug];
    [dictSchedule_Details setObject:strSep forKey:kSep];
    [dictSchedule_Details setObject:strOct forKey:kOct];
    [dictSchedule_Details setObject:strNov forKey:kNov];
    [dictSchedule_Details setObject:strDec forKey:kDec];
    [dictSchedule_Details setObject:strSun forKey:kSun];
    [dictSchedule_Details setObject:strMon forKey:kMon];
    [dictSchedule_Details setObject:strTue forKey:kTue];
    [dictSchedule_Details setObject:strWed forKey:kWed];
    [dictSchedule_Details setObject:strThr forKey:kThr];
    [dictSchedule_Details setObject:strFri forKey:kFri];
    [dictSchedule_Details setObject:strSat forKey:kSat];
    [dictSchedule_Details setObject:strOddDay forKey:kOddDay];
    [dictSchedule_Details setObject:strEvenDay forKey:kEvenDay];
    [dictSchedule_Details setObject:str_ScheduleCat_ID forKey:kScheduleCategoryID];
    [dictSchedule_Details setObject:startTime forKey:kStartTime];
    [dictSchedule_Details setObject:endTime forKey:kEndTime];
    // [dictSchedule_Details setObject:@"1" forKey:kScheduleMode];
    NSLog(@"dict values ==%@",dictSchedule_Details);
    parameters=[SCM scheduleAddDevice:dictSchedule_Details];
    NSLog(@"%@",parameters);
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for add schedule device==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseAddSchedule) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for add schedule device==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_ScheduleAdd) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedAddSchedule) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodNameWith_Value];
    //  [self stop_PinWheel_ScheduleAdd];
}
-(void)responseAddSchedule
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self stop_PinWheel_ScheduleAdd];
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            if([strStatus_Schedule isEqualToString:@"lightSchedule"]) {
                appDelegate.strScheduleWay=@"YES";
                [Common viewFadeIn:self.navigationController.view];
                [self.navigationController popViewControllerAnimated:NO];
            }
            else{
                if([appDelegate.strDevice_Added_Mode isEqualToString:@"NetworkHome"])
                {
                    for (UIViewController *controller in [self.navigationController viewControllers])
                    {
                        if ([controller isKindOfClass:[SWRevealViewController class]])
                        {
                            [Common viewFadeIn:self.navigationController.view];
                            [self.navigationController popToViewController:controller animated:NO];
                            break;
                        }
                    }
                }else{
                    appDelegate.strDevice_Added_Status=@"NEWPOPUPLOAD";
                    SWRevealViewController *NHVC = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
                    NHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                    NSArray *newStack = @[NHVC];
                    [Common viewFadeIn:self.navigationController.view];
                    [self.navigationController setViewControllers:newStack animated:NO];
                }
            }
        }else{
            [self stop_PinWheel_ScheduleAdd];
            if([responseMessage isEqualToString:@"SCHEDULE_DUPLICATE"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NOID"
                                                                message:@"This schedule conflicts with an existing schedule, do you want to save anyway?"
                                                               delegate:self
                                                      cancelButtonTitle:@"YES"
                                                      otherButtonTitles:@"CANCEL",nil];
                alert.tag=1;
                [alert show];
            }
            else if([responseMessage isEqualToString:@"NAME_ALREADY_USED"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"This Schedule Name Already Exists"];
                return;
            }
            else{
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_ScheduleAdd];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView.tag==1)
    {
        // the user clicked OK
        if (buttonIndex == 0) {
            // do something here...
            if([Common reachabilityChanged]==YES){
                strAllowDuplicate=@"true";
                [self performSelectorOnMainThread:@selector(start_PinWheel_ScheduleAdd) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(schedule_Add_Device) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
            
        }
    }
    
}
-(void)responseFailedAddSchedule
{
    [Common showAlert:@"NOID" withMessage:strResponseError];
}
#pragma mark - PinWheel Methods
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : This method is called to start the Progress HUD
 Method Name : start_PinWheel_Registeration(User Defined Method)
 ************************************************************************************* */
-(void)start_PinWheel_ScheduleAdd{
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
-(void)stop_PinWheel_ScheduleAdd{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
}

/*
{
    device =     {
        id = 0;
    };
    schedule =     {
        controller =         {
            id = 1169;
        };
        deviceType =         {
            id = 1;
        };
        scheduleName = ters;
        scheduleSetting =         {
            scheduleDay =             {
                april = false;
                august = false;
                december = false;
                february = false;
                january = true;
                july = false;
                june = false;
                march = false;
                may = false;
                november = false;
                october = false;
                september = false;
            };
            scheduleMonth =             {
                april = false;
                august = false;
                december = false;
                february = false;
                january = true;
                july = false;
                june = false;
                march = false;
                may = false;
                november = false;
                october = false;
                september = false;
            };
        };
    };
}
*/

@end
