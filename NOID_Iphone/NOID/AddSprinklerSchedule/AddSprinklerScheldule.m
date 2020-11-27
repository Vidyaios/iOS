//
//  AddSprinklerScheldule.m
//  NOID
//
//  Created by iExemplar on 01/08/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "AddSprinklerScheldule.h"
#import "AsyncImageView.h"
#import "MBProgressHUD.h"
#import "Utils.h"
#import "Common.h"
#import "SettingsViewController.h"
#import "NetworkHomeViewController.h"
#import "TimeLineViewController.h"
#import "EditableTableController.h"
#import "ServiceConnectorModel.h"
#import "AFNetworking.h"
#import "Base64.h"

#define kButtonIndex 1000

//static CGFloat CellHeight = 122.0f;
static CGFloat CellHeight;
static NSString *CellIdentifier = @"CellIdentifier";

static NSInteger NumberOfItems = 5;
static NSString *Item = @"ZONE_%i";

@interface AddSprinklerScheldule ()
{
    UILabel *lbl_Button[kButtonIndex];
    UIButton *plusButton[kButtonIndex];
    UIButton *minusButton[kButtonIndex];
    NSString *strLoad;
    UISwitch *deviceSwitch_Alerts[kButtonIndex];
    UIButton *btnCell;
    UILabel *lblMin[kButtonIndex];
}
@end

@implementation AddSprinklerScheldule
@synthesize delegate,txt_ScheduleName,btn_back_networkHome,btn_back_networkHomeText,btn_networkHome_logo,btn_settings;
@synthesize switch_Even_Days_Sprinkler,switch_ODD_Days_Sprinkler,switch_RunEveryDay,switch_RunON_Interval,switch_SelectDay_Watering;
@synthesize viewHeader,viewSlider,viewRunOn_Interval_SubView,scrollViewConainer;
@synthesize btn_Fri_Day,btn_Mon_Day,btn_Sat_Day,btn_Sun_day,btn_Tue_Day,btn_Turs_day,btn_Wed_Day;
@synthesize btnPlus,btnMinus,lblTime;
@synthesize btn_Apr,btn_Aug,btn_Dec,btn_Feb,btn_Jan,btn_Jly,btn_Jun,btn_Mar,btn_May,btn_Nov,btn_Oct,btn_Sep;
@synthesize tableViewSprinkler,arr_itemsWatering,viewWatering,viewCompletion;
@synthesize strScheduleAction,dictScheduleList,viewDeleteSch,viewSaveSch,strStatus_Schedule,viewAlert_deleteSchSprinkler,timePicker_ZoneSchedule,pickerView_ZoneSchedule,btn_StartTime_Schedule;
@synthesize btnRunEveryDay,btnEvenDaySchedule,btnOddDaySchedule,btnSelectWatering,btnRunOnDays,lblDays,btnCancelPicker_Sprinkler,btnOkPicker_Sprinkler;

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp_ToggleSwitch_Sprinkler];
    [self flagSetup_Sprinkler_Schedule];
    [self setupDays_SwitchOn];
    [self parse_Watering_Source];
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_AddSprinklers) withObject:self waitUntilDone:YES];
        if([strScheduleAction isEqualToString:@"EDIT"])
        {
            [self performSelectorInBackground:@selector(getUpdatedSpinklerZoneList) withObject:self];
        }else{
            [self performSelectorInBackground:@selector(getSpinklerZoneList) withObject:self];
        }
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
    //Do any additional setup after loading the view.
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

#pragma mark - User Defined Actions

-(void)flagSetup_Sprinkler_Schedule{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
    NSLog(@"dict==%@",self.dictScheduleList);
    NSLog(@"device action ==%@",self.strScheduleAction);
    if([strScheduleAction isEqualToString:@"EDIT"])
    {
        self.viewSaveSch.frame=CGRectMake(self.viewSaveSch.frame.origin.x, self.viewSaveSch.frame.origin.y,self.viewSaveSch.frame.size.width, self.viewSaveSch.frame.size.height);
        self.viewDeleteSch.frame=CGRectMake(self.viewDeleteSch.frame.origin.x, self.viewDeleteSch.frame.origin.y,self.viewDeleteSch.frame.size.width, self.viewDeleteSch.frame.size.height);
        //get zone array
        arrAlready_Selected_Zone=[[NSMutableArray alloc] init];
        arrAlready_Selected_Zone=[self.dictScheduleList objectForKey:@"zoneScheduleTime"];
        
       // zoneSelection_Count=(int)arrAlready_Selected_Zone.count;
        //name parsing
        txt_ScheduleName.text=[self.dictScheduleList objectForKey:@"scheduleName"];
        
        times=[self.dictScheduleList objectForKey:@"startTime"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm:ss";
        NSDate *date = [dateFormatter dateFromString:[self.dictScheduleList objectForKey:@"startTime"]];
        dateFormatter.dateFormat = @"hh:mm a";
        NSString *pmamDateString = [dateFormatter stringFromDate:date];
        [btn_StartTime_Schedule setTitle:pmamDateString forState:UIControlStateNormal];
        //Days Parsing weekdays , run on days and  runevery n days
        
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleDay"] objectForKey:@"sunday"] boolValue]==YES)
        {
            daySun=YES;
            strSun=@"true";
        }else{
            daySun=NO;
            strSun=@"false";
            btn_Sun_day.userInteractionEnabled=NO;
            btn_Sun_day.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleDay"] objectForKey:@"monday"] boolValue]==YES)
        {
            dayMon=YES;
            strMon=@"true";
        }else{
            dayMon=NO;
            strMon=@"false";
            btn_Mon_Day.userInteractionEnabled=NO;
            btn_Mon_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleDay"] objectForKey:@"tuesday"] boolValue]==YES)
        {
            dayTus=YES;
            strTue=@"true";
        }else{
            dayTus=NO;
            strTue=@"false";
            btn_Tue_Day.userInteractionEnabled=NO;
            btn_Tue_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleDay"] objectForKey:@"wednesday"] boolValue]==YES)
        {
            dayWed=YES;
            strWed=@"true";
        }else{
            dayWed=NO;
            strWed=@"false";
            btn_Wed_Day.userInteractionEnabled=NO;
            btn_Wed_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleDay"] objectForKey:@"thursday"] boolValue]==YES)
        {
            dayThurs=YES;
            strThrus=@"true";
        }else{
            dayThurs=NO;
            strThrus=@"false";
            btn_Turs_day.userInteractionEnabled=NO;
            btn_Turs_day.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleDay"] objectForKey:@"friday"] boolValue]==YES)
        {
            dayFri=YES;
            strFri=@"true";
        }else{
            dayFri=NO;
            strFri=@"false";
            btn_Fri_Day.userInteractionEnabled=NO;
            btn_Fri_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleDay"] objectForKey:@"saturday"] boolValue]==YES)
        {
            daySat=YES;
            strSat=@"true";
        }else{
            daySat=NO;
            strSat=@"false";
            btn_Sat_Day.userInteractionEnabled=NO;
            btn_Sat_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleDay"] objectForKey:@"oddDay"] boolValue]==YES)
        {
            runOddDay=YES;
            strOdd=@"true";
        }else{
            runOddDay=NO;
            strOdd=@"false";
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleDay"] objectForKey:@"evenDay"] boolValue]==YES)
        {
            runEvenDay=YES;
            strEven=@"true";
        }else{
            runEvenDay=NO;
            strEven=@"false";
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleDay"] objectForKey:@"everyNDay"] intValue]>=1)
        {
            runEveryDay=YES;
            every_Days=[[[self.dictScheduleList objectForKey:@"zoneScheduleDay"] objectForKey:@"everyNDay"] intValue];
            strRunEvery=[NSString stringWithFormat:@"%d",every_Days];
            lblTime.text=strRunEvery;
            btnPlus.userInteractionEnabled=YES;
            btnMinus.userInteractionEnabled=YES;
            btnPlus.alpha = 1.0;
            btnMinus.alpha = 1.0;
            lblTime.alpha = 1.0;
            lblDays.alpha = 1.0;
        }else{
            runEveryDay=NO;
            every_Days=1;
            strRunEvery=@"0";
            lblTime.text=@"0";
        }
        
        
        //Month Parsing
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleMonth"] objectForKey:@"january"] boolValue]==YES)
        {
            monJan=YES;
            strJan=@"true";
        }else{
            monJan=NO;
            strJan=@"false";
            btn_Jan.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleMonth"] objectForKey:@"february"] boolValue]==YES)
        {
            monFeb=YES;
            strFeb=@"true";
        }else{
            monFeb=NO;
            strFeb=@"false";
            btn_Feb.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleMonth"] objectForKey:@"march"] boolValue]==YES)
        {
            monMar=YES;
            strMar=@"true";
        }else{
            monMar=NO;
            strMar=@"false";
            btn_Mar.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleMonth"] objectForKey:@"april"] boolValue]==YES)
        {
            monApr=YES;
            strApr=@"true";
        }else{
            monApr=NO;
            strApr=@"false";
            btn_Apr.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleMonth"] objectForKey:@"may"] boolValue]==YES)
        {
            monMay=YES;
            strMay=@"true";
        }else{
            monMay=NO;
            strMay=@"false";
            btn_May.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleMonth"] objectForKey:@"june"] boolValue]==YES)
        {
            monJun=YES;
            strJun=@"true";
        }else{
            monJun=NO;
            strJun=@"false";
            btn_Jun.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleMonth"] objectForKey:@"july"] boolValue]==YES)
        {
            monJly=YES;
            strJly=@"true";
        }else{
            monJly=NO;
            strJly=@"false";
            btn_Jly.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleMonth"] objectForKey:@"august"] boolValue]==YES)
        {
            monAug=YES;
            strAug=@"true";
        }else{
            monAug=NO;
            strAug=@"false";
            btn_Aug.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleMonth"] objectForKey:@"september"] boolValue]==YES)
        {
            monSep=YES;
            strSep=@"true";
        }else{
            monSep=NO;
            strSep=@"false";
            btn_Sep.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleMonth"] objectForKey:@"october"] boolValue]==YES)
        {
            monOct=YES;
            strOct=@"true";
        }else{
            monOct=NO;
            strOct=@"false";
            btn_Oct.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleMonth"] objectForKey:@"november"] boolValue]==YES)
        {
            monNov=YES;
            strNov=@"true";
        }else{
            monNov=NO;
            strNov=@"false";
            btn_Nov.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        if([[[self.dictScheduleList objectForKey:@"zoneScheduleMonth"] objectForKey:@"december"] boolValue]==YES)
        {
            monDec=YES;
            strDec=@"true";
        }else{
            monDec=NO;
            strDec=@"false";
            btn_Dec.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        
        
        if(daySun==YES||dayMon==YES||dayTus==YES||dayWed==YES||dayThurs==YES||dayFri==YES||daySat==YES)
        {
            runWeekDay=YES;
            btn_Sun_day.userInteractionEnabled=YES;
            btn_Mon_Day.userInteractionEnabled=YES;
            btn_Tue_Day.userInteractionEnabled=YES;
            btn_Wed_Day.userInteractionEnabled=YES;
            btn_Turs_day.userInteractionEnabled=YES;
            btn_Fri_Day.userInteractionEnabled=YES;
            btn_Sat_Day.userInteractionEnabled=YES;
        }else{
            runWeekDay=NO;
        }
        
        
        if(runOddDay==YES||runEvenDay==YES)
        {
            runONDay=YES;
            self.viewRunOn_Interval_SubView.userInteractionEnabled=YES;
            self.viewRunOn_Interval_SubView.alpha=1.0;
        }else{
            runONDay=NO;
            self.viewRunOn_Interval_SubView.userInteractionEnabled=NO;
            self.viewRunOn_Interval_SubView.alpha=0.4;
        }
        
        strScheduleID = [self.dictScheduleList objectForKey:@"id"];
        // zoneSelection_Count=0;
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
        {
            NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
            if([appDelegate.strNetworkPermission isEqualToString:@"2"])
            {
                txt_ScheduleName.userInteractionEnabled=NO;
            }
        }
    }else{
        self.viewDeleteSch.hidden=YES;
        
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            self.viewSaveSch.frame=CGRectMake(93, self.viewSaveSch.frame.origin.y,self.viewSaveSch.frame.size.width, self.viewSaveSch.frame.size.height);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            self.viewSaveSch.frame=CGRectMake(120, self.viewSaveSch.frame.origin.y,self.viewSaveSch.frame.size.width, self.viewSaveSch.frame.size.height);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            self.viewSaveSch.frame=CGRectMake(109, self.viewSaveSch.frame.origin.y,self.viewSaveSch.frame.size.width, self.viewSaveSch.frame.size.height);
        }
        
        strScheduleAction=@"";
        self.viewRunOn_Interval_SubView.userInteractionEnabled=NO;
        self.viewRunOn_Interval_SubView.alpha=0.4;
        every_Days=1;
        dayMon=YES;
        dayTus=YES;
        dayWed=YES;
        dayThurs=YES;
        dayFri=YES;
        daySat=YES;
        daySun=YES;
        runWeekDay=YES;
        monJan=YES,monFeb=YES,monMar=YES,monApr=YES,monMay=YES,monJun=YES;
        monJly=YES,monAug=YES,monSep=YES,monOct=YES,monNov=YES,monDec=YES;
        runEvenDay=NO,runOddDay=NO,runEveryDay=NO,runONDay=NO;
        times=@"09:00:00";
        [btn_StartTime_Schedule setTitle:@"09:00AM" forState:UIControlStateNormal];
        zoneSelection_Count=0;
        
        // self.scrollViewConainer.hidden=YES;
        strScheduleID = @"0";
        
        
        strSun=@"true",strMon=@"true",strTue=@"true",strWed=@"true",strThrus=@"true",strFri=@"true",strSat=@"true";
        strJan=@"true",strFeb=@"true",strMar=@"true",strApr=@"true",strMay=@"true",strJun=@"true";
        strJly=@"true",strAug=@"true",strSep=@"true",strOct=@"true",strNov=@"true",strDec=@"true";
        strOdd=@"false",strEven=@"false",strRunEvery=@"0";
        
        lblTime.text=@"0";
    }
    
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        CellHeight = 75;  //65
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        CellHeight = 83; //73
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        CellHeight = 76; //66
    }
    self.viewAlert_deleteSchSprinkler.hidden=YES;
//    [timePicker_ZoneSchedule setValue:[UIColor blackColor] forKeyPath:@"textColor"];
//    timePicker_ZoneSchedule.backgroundColor = [UIColor whiteColor];
    
    [timePicker_ZoneSchedule setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"textColor"];
    timePicker_ZoneSchedule.backgroundColor = lblRGBA(65, 64, 66, 1);
    btnOkPicker_Sprinkler.layer.cornerRadius=5.0;
    btnCancelPicker_Sprinkler.layer.cornerRadius=5.0;
    
    btnRunEveryDay.userInteractionEnabled=NO;
    btnRunOnDays.userInteractionEnabled=NO;
    btnOddDaySchedule.userInteractionEnabled=NO;
    btnEvenDaySchedule.userInteractionEnabled=NO;
    btnSelectWatering.userInteractionEnabled=NO;
}

-(void)scroll_Footer_Setup_AddSprinklerCard:(float)yAxis{
    
    self.scrollViewConainer.contentSize = CGSizeMake(self.scrollViewConainer.frame.size.width,yAxis);
}
-(void)setupDays_SwitchOn
{
    if([strScheduleAction isEqualToString:@"EDIT"])
    {
        if(runWeekDay==YES)
        {
            [switch_SelectDay_Watering setOnTintColor:[UIColor colorWithRed:136.0/255 green:197.0/255 blue:65.0/255 alpha:1.000]];
            [switch_SelectDay_Watering setOn:YES animated:NO];
            [switch_SelectDay_Watering setSelected:YES];
            switch_SelectDay_Watering.enabled=YES;
            if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
            {
                NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
                if([appDelegate.strNetworkPermission isEqualToString:@"2"])
                {
                    btnSelectWatering.userInteractionEnabled=YES;
                    switch_SelectDay_Watering.userInteractionEnabled=NO;
                }
            }
        }
        else if(runONDay==YES)
        {
            [switch_RunON_Interval setOnTintColor:[UIColor colorWithRed:136.0/255 green:197.0/255 blue:65.0/255 alpha:1.000]];
            [switch_RunON_Interval setOn:YES animated:NO];
            [switch_RunON_Interval setSelected:YES];
            switch_RunON_Interval.enabled=YES;
            if(runOddDay==YES)
            {
                [switch_ODD_Days_Sprinkler setOnTintColor:[UIColor colorWithRed:136.0/255 green:197.0/255 blue:65.0/255 alpha:1.000]];
                [switch_ODD_Days_Sprinkler setOn:YES animated:NO];
                [switch_ODD_Days_Sprinkler setSelected:YES];
               
            }
            switch_ODD_Days_Sprinkler.enabled=YES;
            if(runEvenDay==YES)
            {
                [switch_Even_Days_Sprinkler setOnTintColor:[UIColor colorWithRed:136.0/255 green:197.0/255 blue:65.0/255 alpha:1.000]];
                [switch_Even_Days_Sprinkler setOn:YES animated:NO];
                [switch_Even_Days_Sprinkler setSelected:YES];
               
            }
             switch_Even_Days_Sprinkler.enabled=YES;
            if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
            {
                NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
                if([appDelegate.strNetworkPermission isEqualToString:@"2"])
                {
                    btnOddDaySchedule.userInteractionEnabled=YES;
                    btnEvenDaySchedule.userInteractionEnabled=YES;
                    btnRunOnDays.userInteractionEnabled=YES;
                    switch_Even_Days_Sprinkler.userInteractionEnabled=NO;
                    switch_ODD_Days_Sprinkler.userInteractionEnabled=NO;
                    switch_RunON_Interval.userInteractionEnabled=NO;
                }
            }
        }else
        {
            [switch_RunEveryDay setOnTintColor:[UIColor colorWithRed:136.0/255 green:197.0/255 blue:65.0/255 alpha:1.000]];
            [switch_RunEveryDay setOn:YES animated:NO];
            [switch_RunEveryDay setSelected:YES];
            switch_RunEveryDay.enabled=YES;
            btnRunEveryDay.userInteractionEnabled=NO;
            if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
            {
                NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
                if([appDelegate.strNetworkPermission isEqualToString:@"2"])
                {
                    btnRunEveryDay.userInteractionEnabled=YES;
                    switch_RunEveryDay.userInteractionEnabled=NO;
                }
            }
        }
    }else{
        [switch_SelectDay_Watering setOnTintColor:[UIColor colorWithRed:136.0/255 green:197.0/255 blue:65.0/255 alpha:1.000]];
        [switch_SelectDay_Watering setOn:YES animated:NO];
        [switch_SelectDay_Watering setSelected:YES];
        switch_SelectDay_Watering.enabled=YES;
        if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
        {
            NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
            if([appDelegate.strNetworkPermission isEqualToString:@"2"])
            {
                btnRunEveryDay.userInteractionEnabled=YES;
                switch_RunEveryDay.userInteractionEnabled=NO;
            }
        }
    }
    
    [switch_SelectDay_Watering addTarget:self action:@selector(selectDayWatering_Toggle_Settings:) forControlEvents:UIControlEventValueChanged];
    [switch_RunEveryDay addTarget:self action:@selector(select_Run_Day_Watering_Toggle_Settings:) forControlEvents:UIControlEventValueChanged];
    [switch_RunON_Interval addTarget:self action:@selector(select_Run_ON_Watering_Toggle_Settings:) forControlEvents:UIControlEventValueChanged];
    [switch_ODD_Days_Sprinkler addTarget:self action:@selector(select_Odd_Day_Watering_Toggle_Settings:) forControlEvents:UIControlEventValueChanged];
    [switch_Even_Days_Sprinkler addTarget:self action:@selector(select_Even_Day_Watering_Toggle_Settings:) forControlEvents:UIControlEventValueChanged];
}


-(void)initialSetUp_ToggleSwitch_Sprinkler
{
    [switch_RunON_Interval setOn:NO animated:NO];
    [switch_RunON_Interval setSelected:NO];
    [switch_RunON_Interval setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_RunON_Interval.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_RunON_Interval.tintColor=lblRGBA(98, 99, 102, 1);
    switch_RunON_Interval.layer.masksToBounds=YES;
    switch_RunON_Interval.layer.cornerRadius=16.0;
    switch_RunON_Interval.enabled=NO;
    
    [switch_SelectDay_Watering setOn:NO animated:NO];
    [switch_SelectDay_Watering setSelected:NO];
    [switch_SelectDay_Watering setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_SelectDay_Watering.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_SelectDay_Watering.tintColor=lblRGBA(98, 99, 102, 1);
    switch_SelectDay_Watering.layer.masksToBounds=YES;
    switch_SelectDay_Watering.layer.cornerRadius=16.0;
    switch_SelectDay_Watering.enabled=NO;
    
    [switch_RunEveryDay setOn:NO animated:NO];
    [switch_RunEveryDay setSelected:NO];
    [switch_RunEveryDay setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_RunEveryDay.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_RunEveryDay.tintColor=lblRGBA(98, 99, 102, 1);
    switch_RunEveryDay.layer.masksToBounds=YES;
    switch_RunEveryDay.layer.cornerRadius=16.0;
    switch_RunEveryDay.enabled=NO;
    
    [switch_Even_Days_Sprinkler setOn:NO animated:NO];
    [switch_Even_Days_Sprinkler setSelected:NO];
    [switch_Even_Days_Sprinkler setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_Even_Days_Sprinkler.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_Even_Days_Sprinkler.tintColor=lblRGBA(98, 99, 102, 1);
    switch_Even_Days_Sprinkler.layer.masksToBounds=YES;
    switch_Even_Days_Sprinkler.layer.cornerRadius=16.0;
    switch_Even_Days_Sprinkler.enabled=NO;
    
    [switch_ODD_Days_Sprinkler setOn:NO animated:NO];
    [switch_ODD_Days_Sprinkler setSelected:NO];
    [switch_ODD_Days_Sprinkler setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_ODD_Days_Sprinkler.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_ODD_Days_Sprinkler.tintColor=lblRGBA(98, 99, 102, 1);
    switch_ODD_Days_Sprinkler.layer.masksToBounds=YES;
    switch_ODD_Days_Sprinkler.layer.cornerRadius=16.0;
    switch_ODD_Days_Sprinkler.enabled=NO;
    
    btnPlus.userInteractionEnabled=NO;
    btnMinus.userInteractionEnabled=NO;
    btnPlus.alpha = 0.6;
    btnMinus.alpha = 0.6;
    lblTime.alpha = 0.6;
    lblDays.alpha = 0.6;
    
    txt_ScheduleName.delegate=self;
    [txt_ScheduleName setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];
    txt_ScheduleName.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txt_ScheduleName.leftView = paddingView;
    txt_ScheduleName.leftViewMode = UITextFieldViewModeAlways;
}


- (void)processCompleteSprinklers
{
    [[self delegate] processSuccessful_Back_To_NetworkHome_Via_Sprinkler:YES];
    [Common viewFadeIn:self.navigationController.view];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Textfield Delegates
/* **********************************************************************************
 Date : 14/09/2015
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
 Date : 14/09/2015
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

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
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
    NSUInteger newLength = [txt_ScheduleName.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_DEVICENAME] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered])&&(newLength <= UnitfieldDigitsPWd));
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text=@"";
    return NO;
}

#pragma mark - PinWheel Method
-(void)start_PinWheel_AddSprinklers{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"YES";
}
-(void)stop_PinWheel_Lights_AddSprinklers{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
}

#pragma mark - IB Actions

-(IBAction)back_AddSprinklerSchedule_Action:(id)sender
{
    if ([txt_ScheduleName resignFirstResponder]) {
        [txt_ScheduleName resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)select_Run_Day_Watering_Toggle_Settings:(UISwitch *)twistedSwitch
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    
    if ([txt_ScheduleName resignFirstResponder]) {
        [txt_ScheduleName resignFirstResponder];
    }
    NSLog(@"watering");
    if([twistedSwitch isOn] && (![twistedSwitch isSelected]))
    {
        NSLog(@"Switch is ON");
        [self switch_RunTime_Disable_Updte];
        switch_RunEveryDay.enabled=YES;
        [switch_RunEveryDay setOn:YES animated:YES];
        [switch_RunEveryDay setSelected:YES];
        [switch_RunEveryDay setOnTintColor:[UIColor colorWithRed:136.0/255 green:197.0/255 blue:65.0/255 alpha:1.000]];
        btnMinus.userInteractionEnabled=YES;
        btnPlus.userInteractionEnabled=YES;
        btnPlus.alpha = 1.0;
        btnMinus.alpha = 1.0;
        lblTime.alpha = 1.0;
        lblDays.alpha = 1.0;
        runEveryDay=YES;
        strRunEvery=@"1";
        lblTime.text=@"1";
    }
    else if((![twistedSwitch isOn]) && [twistedSwitch isSelected])
    {
        NSLog(@"Switch is OFF");
        [switch_RunEveryDay setBackgroundColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:102.0/255 alpha:1.000]];
        [switch_RunEveryDay setSelected:NO];
        [self switch_RunTime_Enable_Updte];
        btnMinus.userInteractionEnabled=NO;
        btnPlus.userInteractionEnabled=NO;
        btnPlus.alpha = 0.6;
        btnMinus.alpha = 0.6;
        lblTime.alpha = 0.6;
        lblDays.alpha = 0.6;
        lblTime.text=@"0";
        runEveryDay=NO;
        strRunEvery=@"0";
        every_Days=1;
    }
}
-(void)selectDayWatering_Toggle_Settings:(UISwitch *)twistedSwitch
{
    if ([txt_ScheduleName resignFirstResponder]) {
        [txt_ScheduleName resignFirstResponder];
    }
    NSLog(@"watering");
    if([twistedSwitch isOn] && (![twistedSwitch isSelected]))
    {
        NSLog(@"Switch is ON");
        [self switch_RunTime_Disable_Updte];
        switch_SelectDay_Watering.enabled=YES;
        [switch_SelectDay_Watering setOn:YES animated:YES];
        [switch_SelectDay_Watering setSelected:YES];
        [switch_SelectDay_Watering setOnTintColor:[UIColor colorWithRed:136.0/255 green:197.0/255 blue:65.0/255 alpha:1.000]];
        [self runOnDisabled_DaysEnabled];
    }
    else if((![twistedSwitch isOn]) && [twistedSwitch isSelected])
    {
        NSLog(@"Switch is OFF");
        [switch_SelectDay_Watering setBackgroundColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:102.0/255 alpha:1.000]];
        [switch_SelectDay_Watering setSelected:NO];
        [self runOnEnabled_DaysDisable];
        [self switch_RunTime_Enable_Updte];
    }
}
-(void)select_Run_ON_Watering_Toggle_Settings:(UISwitch *)twistedSwitch
{
    if ([txt_ScheduleName resignFirstResponder]) {
        [txt_ScheduleName resignFirstResponder];
    }
    NSLog(@"watering");
    if([twistedSwitch isOn] && (![twistedSwitch isSelected]))
    {
        NSLog(@"Switch is ON");
        [self switch_RunTime_Disable_Updte];
        switch_RunON_Interval.enabled=YES;
        [switch_RunON_Interval setOn:YES animated:YES];
        [switch_RunON_Interval setSelected:YES];
        [switch_RunON_Interval setOnTintColor:[UIColor colorWithRed:136.0/255 green:197.0/255 blue:65.0/255 alpha:1.000]];
        switch_ODD_Days_Sprinkler.enabled=YES;
        switch_Even_Days_Sprinkler.enabled=YES;
        self.viewRunOn_Interval_SubView.userInteractionEnabled=YES;
        self.viewRunOn_Interval_SubView.alpha=1.0;
        runONDay=YES;
    }
    else if((![twistedSwitch isOn]) && [twistedSwitch isSelected])
    {
        NSLog(@"Switch is OFF");
        [switch_RunON_Interval setBackgroundColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:102.0/255 alpha:1.000]];
        [switch_ODD_Days_Sprinkler setBackgroundColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:102.0/255 alpha:1.000]];
        [switch_Even_Days_Sprinkler setBackgroundColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:102.0/255 alpha:1.000]];
        [switch_RunON_Interval setSelected:NO];
        [switch_ODD_Days_Sprinkler setSelected:NO];
        [switch_Even_Days_Sprinkler setSelected:NO];
        switch_ODD_Days_Sprinkler.enabled=YES;
        switch_Even_Days_Sprinkler.enabled=YES;
        [self switch_RunTime_Enable_Updte];
        [switch_ODD_Days_Sprinkler setOn:NO animated:YES];
        [switch_Even_Days_Sprinkler setOn:NO animated:YES];
        self.viewRunOn_Interval_SubView.userInteractionEnabled=NO;
        self.viewRunOn_Interval_SubView.alpha=0.6;
        runONDay=NO,runOddDay=NO,runEvenDay=NO;
        strOdd=@"false",strEven=@"false";
    }
}
-(void)select_Odd_Day_Watering_Toggle_Settings:(UISwitch *)twistedSwitch
{
    NSLog(@"watering");
    if([twistedSwitch isOn] && (![twistedSwitch isSelected]))
    {
        NSLog(@"Switch is ON");
        switch_ODD_Days_Sprinkler.enabled=YES;
        [switch_ODD_Days_Sprinkler setOn:YES animated:YES];
        [switch_ODD_Days_Sprinkler setSelected:YES];
        [switch_ODD_Days_Sprinkler setOnTintColor:[UIColor colorWithRed:136.0/255 green:197.0/255 blue:65.0/255 alpha:1.000]];
        runOddDay=YES;
        strOdd=@"true";
    }
    else if((![twistedSwitch isOn]) && [twistedSwitch isSelected])
    {
        NSLog(@"Switch is OFF");
        [switch_ODD_Days_Sprinkler setBackgroundColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:102.0/255 alpha:1.000]];
        [switch_ODD_Days_Sprinkler setSelected:NO];
        runOddDay=NO;
        strOdd=@"false";
    }
}
-(void)select_Even_Day_Watering_Toggle_Settings:(UISwitch *)twistedSwitch
{
    NSLog(@"watering");
    if([twistedSwitch isOn] && (![twistedSwitch isSelected]))
    {
        NSLog(@"Switch is ON");
        switch_Even_Days_Sprinkler.enabled=YES;
        [switch_Even_Days_Sprinkler setOn:YES animated:YES];
        [switch_Even_Days_Sprinkler setSelected:YES];
        [switch_Even_Days_Sprinkler setOnTintColor:[UIColor colorWithRed:136.0/255 green:197.0/255 blue:65.0/255 alpha:1.000]];
        runEvenDay=YES;
        strEven=@"true";
    }
    else if((![twistedSwitch isOn]) && [twistedSwitch isSelected])
    {
        NSLog(@"Switch is OFF");
        [switch_Even_Days_Sprinkler setBackgroundColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:102.0/255 alpha:1.000]];
        [switch_Even_Days_Sprinkler setSelected:NO];
        runEvenDay=NO;
        strEven=@"false";
    }
}
-(void)runOnEnabled_DaysDisable
{
    //switch_RunOn_Header.enabled=YES;
    btn_Sun_day.userInteractionEnabled=NO;
    btn_Sun_day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Mon_Day.userInteractionEnabled=NO;
    btn_Mon_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Tue_Day.userInteractionEnabled=NO;
    btn_Tue_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Wed_Day.userInteractionEnabled=NO;
    btn_Wed_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Turs_day.userInteractionEnabled=NO;
    btn_Turs_day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Fri_Day.userInteractionEnabled=NO;
    btn_Fri_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Sat_Day.userInteractionEnabled=NO;
    btn_Sat_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
    daySun=NO,dayMon=NO,dayTus=NO,dayWed=NO,dayThurs=NO,dayFri=NO,daySat=NO;
    runEvenDay=NO,runEveryDay=NO,runOddDay=NO,runONDay=NO,runWeekDay=NO;
    
    strSun=@"false",strMon=@"false",strTue=@"false",strWed=@"false",strThrus=@"false",strFri=@"false",strSat=@"false";
    strOdd=@"false",strEven=@"false",strRunEvery=@"0";
}
-(void)runOnDisabled_DaysEnabled
{
    btn_Sun_day.userInteractionEnabled=YES;
    btn_Sun_day.backgroundColor=lblRGBA(136, 197, 65, 1);
    btn_Mon_Day.userInteractionEnabled=YES;
    btn_Mon_Day.backgroundColor=lblRGBA(136, 197, 65, 1);
    btn_Tue_Day.userInteractionEnabled=YES;
    btn_Tue_Day.backgroundColor=lblRGBA(136, 197, 65, 1);
    btn_Wed_Day.userInteractionEnabled=YES;
    btn_Wed_Day.backgroundColor=lblRGBA(136, 197, 65, 1);
    btn_Turs_day.userInteractionEnabled=YES;
    btn_Turs_day.backgroundColor=lblRGBA(136, 197, 65, 1);
    btn_Fri_Day.userInteractionEnabled=YES;
    btn_Fri_Day.backgroundColor=lblRGBA(136, 197, 65, 1);
    btn_Sat_Day.userInteractionEnabled=YES;
    btn_Sat_Day.backgroundColor=lblRGBA(136, 197, 65, 1);
    daySun=YES,dayMon=YES,dayTus=YES,dayWed=YES,dayThurs=YES,dayFri=YES,daySat=YES;
    runWeekDay=YES;
    strSun=@"true",strMon=@"true",strTue=@"true",strWed=@"true",strThrus=@"true",strFri=@"true",strSat=@"true";
}
-(void)switch_RunTime_Disable_Updte
{
    switch_SelectDay_Watering.enabled=NO;
    [switch_SelectDay_Watering setOn:NO animated:YES];
    switch_Even_Days_Sprinkler.enabled=NO;
    [switch_Even_Days_Sprinkler setOn:NO animated:YES];
    switch_ODD_Days_Sprinkler.enabled=NO;
    [switch_ODD_Days_Sprinkler setOn:NO animated:YES];
    switch_RunEveryDay.enabled=NO;
    [switch_RunEveryDay setOn:NO animated:YES];
    switch_RunON_Interval.enabled=NO;
    [switch_RunON_Interval setOn:NO animated:YES];
    viewRunOn_Interval_SubView.userInteractionEnabled=NO;
    viewRunOn_Interval_SubView.alpha=0.6;
    btnPlus.userInteractionEnabled=NO;
    btnMinus.userInteractionEnabled=NO;
    btnPlus.alpha = 0.6;
    btnMinus.alpha = 0.6;
    lblTime.alpha = 0.6;
    lblDays.alpha = 0.6;
    lblTime.text=@"0";
    [self runOnEnabled_DaysDisable];
}

-(void)switch_RunTime_Enable_Updte
{
    switch_SelectDay_Watering.enabled=YES;
    switch_RunON_Interval.enabled=YES;
    switch_RunEveryDay.enabled=YES;
}
-(IBAction)switchManualRunTime_Action:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }

    if ([txt_ScheduleName resignFirstResponder]) {
        [txt_ScheduleName resignFirstResponder];
    }
    UISwitch *switchTag=(UISwitch *)sender;
    NSLog(@"switchTag==%ld",(long)switchTag.tag);
    switch (switchTag.tag) {
        case 2:
        {
            //Run every Plus
            if(every_Days==30)
            {
                return;
            }
            every_Days=every_Days+1;
            lblTime.text=[NSString stringWithFormat:@"%d",every_Days];
            
        }
            break;
        case 3:
        {
            //Run Every Minus
            if(every_Days==1)
            {
                return;
            }
            every_Days=every_Days-1;
            
            lblTime.text=[NSString stringWithFormat:@"%d",every_Days];
            
        }
            break;
    }
}

-(IBAction)settings_HomeNoid_Action_InAddSchedule:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([txt_ScheduleName resignFirstResponder]) {
        [txt_ScheduleName resignFirstResponder];
    }
    UISwitch *switchTag=(UISwitch *)sender;
    NSLog(@"switchTag==%ld",(long)switchTag.tag);
    switch (switchTag.tag) {
        case 0:
        {
            SettingsViewController *SVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
            [Common viewFadeInSettings:self.navigationController.view];
            [self.navigationController pushViewController:SVC animated:NO];
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
    }
}

-(IBAction)sprinklerSchedule_Proceed_cancel_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Schedule name proceed
        {
//            txt_ScheduleName.text=[Common Trimming_Right_End_WhiteSpaces:txt_ScheduleName.text];
//            if ([txt_ScheduleName resignFirstResponder]) {
//                [txt_ScheduleName resignFirstResponder];
//            }
//            if(txt_ScheduleName.text.length==0){
//                [Common showAlert:@"Warning" withMessage:@"Please enter schedule name"];
//                return;
//            }
//            if([Common reachabilityChanged]==YES){
//                [self performSelectorOnMainThread:@selector(start_PinWheel_AddSprinklers) withObject:self waitUntilDone:YES];
//                [self performSelectorInBackground:@selector(check_ZoneName_Availablity) withObject:self];
//            }else{
//                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
//            }
        }
            break;
        case 1: //schedule name cancel
        {
//            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
    }
}

-(IBAction)sprinkler_Schedule_Save_Delete_Action:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Schedule saves
        {
            
            txt_ScheduleName.text=[Common Trimming_Right_End_WhiteSpaces:txt_ScheduleName.text];
            if ([txt_ScheduleName resignFirstResponder]) {
                [txt_ScheduleName resignFirstResponder];
            }
            if(txt_ScheduleName.text.length==0){
                [Common showAlert:@"Warning" withMessage:@"Please enter schedule name"];
                return;
            }

            
            NSLog(@"st time ==%@",times);
            if(runONDay==NO&&runEveryDay==NO&&runWeekDay==NO)
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"Please select atleast one schedule run time"];
                return;
            }
            else if(runWeekDay==YES)
            {
                
                if(daySun==NO&&dayMon==NO&&dayTus==NO&&dayWed==NO&&dayThurs==NO&&daySat==NO&&dayFri==NO)
                {
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please select atleast one  day"];
                    return;
                }
            }
            else if(runONDay==YES)
            {
                if(runOddDay==NO&&runEvenDay==NO)
                {
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please Select ODD or EVEN Days"];
                    return;
                }
            }
            else if(runEveryDay==YES)
            {
                strRunEvery=self.lblTime.text;
                if(every_Days<1)
                {
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please set atleast 1 to run every days"];
                    return;
                }
            }
            
            if(monJan==NO&&monFeb==NO&&monMar==NO&&monApr==NO&&monMay==NO&&monJun==NO&&monJly==NO&&monAug==NO&&monSep==NO&&monOct==NO&&monNov==NO&&monDec==NO)
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"Please select atleast one month"];
                return;
            }
            
            if(zoneSelection_Count==0)
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"Please select atleast one zone"];
                return;
            }
            
            // [Common showAlert:kAlertTitleSuccess withMessage:@"MASS"];
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_AddSprinklers) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(add_Sprinkler_Schedule) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 1: //schedule delete
        {
            self.viewAlert_deleteSchSprinkler.hidden=NO;
            self.viewHeader.alpha = 0.4;
            self.scrollViewConainer.alpha = 0.4;
        }
            break;
        case 2: //Okay
        {
            self.viewAlert_deleteSchSprinkler.hidden=YES;
            self.viewHeader.alpha = 1.0;
            self.scrollViewConainer.alpha = 1.0;
            
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_AddSprinklers) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(deleteScheduleSprinkler) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 3: //Cancel
        {
            self.viewAlert_deleteSchSprinkler.hidden=YES;
            self.viewHeader.alpha = 1.0;
            self.scrollViewConainer.alpha = 1.0;
        }
            break;
    }
}

-(IBAction)timePicker_Schedule_Action:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    if ([txt_ScheduleName resignFirstResponder]) {
        [txt_ScheduleName resignFirstResponder];
    }
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Start Time
        {
            [scrollViewConainer setUserInteractionEnabled:NO];
            [scrollViewConainer setAlpha:0.4];
            [UIView animateWithDuration:.25 animations:^{
                pickerView_ZoneSchedule .frame=CGRectMake(0, self.view.frame.size.height-pickerView_ZoneSchedule.frame.size.height+20, pickerView_ZoneSchedule.frame.size.width, pickerView_ZoneSchedule.frame.size.height);
            }];
        }
            break;
        case 1: //Ok
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"hh:mm a";
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            dateFormatter1.dateFormat = @"HH:mm:ss";
             times = [dateFormatter1 stringFromDate:timePicker_ZoneSchedule.date];
            NSLog(@"%@",times);
            NSString *formatedDate = [dateFormatter stringFromDate:timePicker_ZoneSchedule.date];
            NSLog(@"formatted date==%@",formatedDate);
            [btn_StartTime_Schedule setTitle:formatedDate forState:UIControlStateNormal];
            [UIView animateWithDuration:.25 animations:^{
                pickerView_ZoneSchedule.frame=CGRectMake(0, 2000, pickerView_ZoneSchedule.frame.size.width, pickerView_ZoneSchedule.frame.size.height);
            }];
            [scrollViewConainer setUserInteractionEnabled:YES];
            [scrollViewConainer setAlpha:1.0];
        }
            break;
        case 2: //Cancel
        {
            [UIView animateWithDuration:.25 animations:^{
                pickerView_ZoneSchedule.frame=CGRectMake(0, 2000, pickerView_ZoneSchedule.frame.size.width, pickerView_ZoneSchedule.frame.size.height);
            }];
            [scrollViewConainer setUserInteractionEnabled:YES];
            [scrollViewConainer setAlpha:1.0];
        }
            break;
    }
}

-(IBAction)ShowWarning_Permission_Schedule:(id)sender;
{
    [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
}

-(IBAction)daySelected_lightSchedule_Action:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    if ([txt_ScheduleName resignFirstResponder]) {
        [txt_ScheduleName resignFirstResponder];
    }
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            if(dayMon==YES){
                dayMon=NO;
                btn_Mon_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
                strMon=@"false";
            }else{
                dayMon=YES;
                btn_Mon_Day.backgroundColor=lblRGBA(136, 197, 65, 1);
                strMon=@"true";
            }
        }
            break;
        case 1:
        {
            if(dayTus==YES){
                dayTus=NO;
                btn_Tue_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
                strTue=@"false";
            }else{
                dayTus=YES;
                btn_Tue_Day.backgroundColor=lblRGBA(136, 197, 65, 1);
                strTue=@"true";
            }
        }
            break;
        case 2:
        {
            if(dayWed==YES){
                dayWed=NO;
                btn_Wed_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
                strWed=@"false";
            }else{
                dayWed=YES;
                btn_Wed_Day.backgroundColor=lblRGBA(136, 197, 65, 1);
                strWed=@"true";
            }
        }
            break;
        case 3:
        {
            if(dayThurs==YES){
                dayThurs=NO;
                btn_Turs_day.backgroundColor=lblRGBA(98, 99, 102, 1);
                strThrus=@"false";
            }else{
                dayThurs=YES;
                btn_Turs_day.backgroundColor=lblRGBA(136, 197, 65, 1);
                strThrus=@"true";
            }
        }
            break;
        case 4:
        {
            if(dayFri==YES){
                dayFri=NO;
                btn_Fri_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
                strFri=@"false";
            }else{
                dayFri=YES;
                btn_Fri_Day.backgroundColor=lblRGBA(136, 197, 65, 1);
                strFri=@"true";
            }
        }
            break;
        case 5:
        {
            if(daySat==YES){
                daySat=NO;
                btn_Sat_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
                strSat=@"false";
            }else{
                daySat=YES;
                btn_Sat_Day.backgroundColor=lblRGBA(136, 197, 65, 1);
                strSat=@"true";
            }
        }
            break;
        case 6:
        {
            if(daySun==YES){
                daySun=NO;
                btn_Sun_day.backgroundColor=lblRGBA(98, 99, 102, 1);
                strSun=@"false";
            }else{
                daySun=YES;
                btn_Sun_day.backgroundColor=lblRGBA(136, 197, 65, 1);
                strSun=@"true";
            }
        }
            break;
    }
}
-(IBAction)monthSelected_lightSchedule_Action:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    if ([txt_ScheduleName resignFirstResponder]) {
        [txt_ScheduleName resignFirstResponder];
    }
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            if(monJan==YES){
                monJan=NO;
                btn_Jan.backgroundColor=lblRGBA(98, 99, 102, 1);
                strJan=@"false";
            }else{
                monJan=YES;
                btn_Jan.backgroundColor=lblRGBA(136, 197, 65, 1);
                strJan=@"true";
            }
        }
            break;
        case 1:
        {
            if(monFeb==YES){
                monFeb=NO;
                btn_Feb.backgroundColor=lblRGBA(98, 99, 102, 1);
                strFeb=@"false";
            }else{
                monFeb=YES;
                btn_Feb.backgroundColor=lblRGBA(136, 197, 65, 1);
                strFeb=@"true";
            }
        }
            break;
        case 2:
        {
            if(monMar==YES){
                monMar=NO;
                btn_Mar.backgroundColor=lblRGBA(98, 99, 102, 1);
                strMar=@"false";
            }else{
                monMar=YES;
                btn_Mar.backgroundColor=lblRGBA(136, 197, 65, 1);
                strMar=@"true";
            }
        }
            break;
        case 3:
        {
            if(monApr==YES){
                monApr=NO;
                btn_Apr.backgroundColor=lblRGBA(98, 99, 102, 1);
                strApr=@"false";
                
            }else{
                monApr=YES;
                btn_Apr.backgroundColor=lblRGBA(136, 197, 65, 1);
                strApr=@"true";
            }
        }
            break;
        case 4:
        {
            if(monMay==YES){
                monMay=NO;
                btn_May.backgroundColor=lblRGBA(98, 99, 102, 1);
                strMay=@"false";
                
            }else{
                monMay=YES;
                btn_May.backgroundColor=lblRGBA(136, 197, 65, 1);
                strMay=@"true";
            }
        }
            break;
        case 5:
        {
            if(monJun==YES){
                monJun=NO;
                btn_Jun.backgroundColor=lblRGBA(98, 99, 102, 1);
                strJun=@"false";
                
            }else{
                monJun=YES;
                btn_Jun.backgroundColor=lblRGBA(136, 197, 65, 1);
                strJun=@"true";
            }
        }
            break;
        case 6:
        {
            if(monJly==YES){
                monJly=NO;
                btn_Jly.backgroundColor=lblRGBA(98, 99, 102, 1);
                strJly=@"false";
                
            }else{
                monJly=YES;
                btn_Jly.backgroundColor=lblRGBA(136, 197, 65, 1);
                strJly=@"true";
            }
        }
            break;
        case 7:
        {
            if(monAug==YES){
                monAug=NO;
                btn_Aug.backgroundColor=lblRGBA(98, 99, 102, 1);
                strAug=@"false";
                
            }else{
                monAug=YES;
                btn_Aug.backgroundColor=lblRGBA(136, 197, 65, 1);
                strAug=@"true";
            }
        }
            break;
        case 8:
        {
            if(monSep==YES){
                monSep=NO;
                btn_Sep.backgroundColor=lblRGBA(98, 99, 102, 1);
                strSep=@"false";
                
            }else{
                monSep=YES;
                btn_Sep.backgroundColor=lblRGBA(136, 197, 65, 1);
                strSep=@"true";
            }
        }
            break;
        case 9:
        {
            if(monOct==YES){
                monOct=NO;
                btn_Oct.backgroundColor=lblRGBA(98, 99, 102, 1);
                strOct=@"false";
                
            }else{
                monOct=YES;
                btn_Oct.backgroundColor=lblRGBA(136, 197, 65, 1);
                strOct=@"true";
            }
        }
            break;
        case 10:
        {
            if(monNov==YES){
                monNov=NO;
                btn_Nov.backgroundColor=lblRGBA(98, 99, 102, 1);
                strNov=@"false";
                
            }else{
                monNov=YES;
                btn_Nov.backgroundColor=lblRGBA(136, 197, 65, 1);
                strNov=@"true";
            }
        }
            break;
        case 11:
        {
            if(monDec==YES){
                monDec=NO;
                btn_Dec.backgroundColor=lblRGBA(98, 99, 102, 1);
                strDec=@"false";
                
            }else{
                monDec=YES;
                btn_Dec.backgroundColor=lblRGBA(136, 197, 65, 1);
                strDec=@"true";
            }
        }
            break;
    }
}
-(void)parse_Watering_Source
{
    _itemBeingMoved = nil;
    arr_itemsWatering=[[NSMutableArray alloc] init];
    strLoad=@"";
//    [self setupDatasource];
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
    //return here which orientation you are going to support
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        NSLog(@"Landscape left");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        [self.navigationController pushViewController:TLVC animated:NO];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        NSLog(@"Landscape right");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        [self.navigationController pushViewController:TLVC animated:NO];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        
    }
}

#pragma mark - Setup

- (void)setupDatasource
{
    for (NSInteger i = 0; i < NumberOfItems; i++)
    {
        NSString *item = [NSString stringWithFormat:Item, i];
        [arr_itemsWatering addObject:item];
    }
    
}

- (void)setupTableView
{
    self.tableViewSprinkler.delegate=self;
    self.tableViewSprinkler.dataSource=self;
    self.tableViewSprinkler.estimatedRowHeight = CellHeight;
    [self.tableViewSprinkler registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableViewSprinkler setBackgroundView:nil];
    [self.tableViewSprinkler setBackgroundColor:lblRGBA(70, 71, 73, 1)];
    self.editableTableController = [[EditableTableController alloc] initWithTableView:self.tableViewSprinkler];
    self.editableTableController.delegate = self;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"indexpath ==%ld",(long)indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}
#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arr_itemsWatering count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSLog(@"coming");
    if([strLoad isEqualToString:@""])
    {
        NSLog(@"coming inside");
        
        UIImageView *imgViewZone = [[UIImageView alloc]init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            imgViewZone.frame = CGRectMake(0,5, 74, 65);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            imgViewZone.frame = CGRectMake(0,5, 96, 73);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            imgViewZone.frame = CGRectMake(0,5, 86, 66);
        }
        if([[arr_itemsWatering objectAtIndex:indexPath.row] valueForKey:kZoneThumbnailImage] == [NSNull null]){
            imgViewZone.image=[UIImage imageNamed:@"dcardSprinkler"];
        }
        else if([[[arr_itemsWatering objectAtIndex:indexPath.row] valueForKey:kZoneThumbnailImage] isEqualToString:@""]){
            imgViewZone.image=[UIImage imageNamed:@"dcardSprinkler"];
        }
        else{
            imgViewZone.image=[UIImage imageWithData:[Base64 decode:[[arr_itemsWatering objectAtIndex:indexPath.row] valueForKey:kZoneThumbnailImage]]];
        }
        [cell addSubview:imgViewZone];
        
        UILabel *lblZone_Name=[[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblZone_Name.frame = CGRectMake(80,11, 140, 29);  //6
            [lblZone_Name setFont:[UIFont fontWithName:@"NexaBold" size:11]];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblZone_Name.frame = CGRectMake(103,12, 193, 28); //7
            [lblZone_Name setFont:[UIFont fontWithName:@"NexaBold" size:13]];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lblZone_Name.frame = CGRectMake(100,12, 118, 28);//6
            [lblZone_Name setFont:[UIFont fontWithName:@"NexaBold" size:12]];
        }
        lblZone_Name.text=[[arr_itemsWatering objectAtIndex:indexPath.row] valueForKey:kZoneName];
        lblZone_Name.textColor=[UIColor whiteColor];
        //lblZone_Name.numberOfLines=2;
        [cell addSubview:lblZone_Name];
        
        lbl_Button[indexPath.row] =[[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lbl_Button[indexPath.row].frame = CGRectMake(81,42, 24, 19); //37
            [lbl_Button[indexPath.row] setFont:[UIFont fontWithName:@"NexaBold" size:11]];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lbl_Button[indexPath.row].frame = CGRectMake(104,45, 26, 24); //40
            [lbl_Button[indexPath.row] setFont:[UIFont fontWithName:@"NexaBold" size:13]];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lbl_Button[indexPath.row].frame = CGRectMake(100,42, 27, 22); //37
            [lbl_Button[indexPath.row] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
        }
        lbl_Button[indexPath.row].backgroundColor = [UIColor whiteColor];
        lbl_Button[indexPath.row].textColor=lblRGBA(99, 100, 102, 1);
        lbl_Button[indexPath.row].textAlignment=NSTextAlignmentCenter;
        lbl_Button[indexPath.row].text=[[arr_itemsWatering objectAtIndex:indexPath.row] valueForKey:kZoneDuration];
        [cell addSubview:lbl_Button[indexPath.row]];
        
        plusButton[indexPath.row] = [UIButton buttonWithType: UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            plusButton[indexPath.row].frame = CGRectMake(107, 42, 19, 19);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            plusButton[indexPath.row].frame = CGRectMake(132, 45, 24, 24);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            plusButton[indexPath.row].frame = CGRectMake(130, 42, 22, 22);
        }
        [plusButton[indexPath.row] setBackgroundColor:lblRGBA(136, 197, 65, 1)];
        [plusButton[indexPath.row] setImage:[UIImage imageNamed:@"PlusImagei6plus"] forState:UIControlStateNormal];
        [plusButton[indexPath.row] setTag:indexPath.row];
        [plusButton[indexPath.row] addTarget:self action:@selector(addProjectPressed:) forControlEvents:UIControlEventTouchUpInside];
        plusButton[indexPath.row].userInteractionEnabled=NO;
        [cell addSubview:plusButton[indexPath.row]];
        
        minusButton[indexPath.row] = [UIButton buttonWithType: UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            minusButton[indexPath.row].frame = CGRectMake(128, 42, 19, 19);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            minusButton[indexPath.row].frame = CGRectMake(158, 45, 24, 24);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            minusButton[indexPath.row].frame = CGRectMake(154, 42, 22, 22);
        }
        [minusButton[indexPath.row] setBackgroundColor:lblRGBA(98, 99, 102, 1)];
        [minusButton[indexPath.row] setImage:[UIImage imageNamed:@"MinusImagei6plus"] forState:UIControlStateNormal];
        [minusButton[indexPath.row] setTag:indexPath.row];
        [minusButton[indexPath.row] addTarget:self action:@selector(deleteProjectPressed:) forControlEvents:UIControlEventTouchUpInside];
        minusButton[indexPath.row].userInteractionEnabled=NO;
        [cell addSubview:minusButton[indexPath.row]];
        
        lblMin[indexPath.row]=[[UILabel alloc] init];
        if([lbl_Button[indexPath.row].text isEqualToString:@"0"]||[lbl_Button[indexPath.row].text isEqualToString:@"1"])
        {
            lblMin[indexPath.row].text=@"MINUTE";
        }else{
            lblMin[indexPath.row].text=@"MINUTES";
        }
        
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblMin[indexPath.row].frame=CGRectMake(150, 42, 100, 21);
            lblMin[indexPath.row].font=[UIFont fontWithName:@"NexaBold" size:11];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblMin[indexPath.row].frame=CGRectMake(185, 45, 100, 21);
            lblMin[indexPath.row].font=[UIFont fontWithName:@"NexaBold" size:13];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lblMin[indexPath.row].frame=CGRectMake(182, 42, 100, 21);
            lblMin[indexPath.row].font=[UIFont fontWithName:@"NexaBold" size:11];
        }
        
        lblMin[indexPath.row].textColor=[UIColor whiteColor];
        [cell addSubview:lblMin[indexPath.row]];
        
        deviceSwitch_Alerts[indexPath.row] = [[UISwitch alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            deviceSwitch_Alerts[indexPath.row].frame = CGRectMake(265, 10, 51, 31); //5
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            deviceSwitch_Alerts[indexPath.row].frame = CGRectMake(262, 13, 51, 31); //8
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            deviceSwitch_Alerts[indexPath.row].frame = CGRectMake(266, 10, 51, 31); //10
        }
        deviceSwitch_Alerts[indexPath.row].autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        deviceSwitch_Alerts[indexPath.row].backgroundColor=[UIColor whiteColor];
        deviceSwitch_Alerts[indexPath.row].layer.masksToBounds=YES;
        deviceSwitch_Alerts[indexPath.row].layer.cornerRadius=16.0;
        deviceSwitch_Alerts[indexPath.row].tag=indexPath.row;
        [deviceSwitch_Alerts[indexPath.row] addTarget:self action:@selector(switchToggledZones:) forControlEvents:UIControlEventValueChanged];
        [deviceSwitch_Alerts[indexPath.row] setOn:NO animated:NO];
        [deviceSwitch_Alerts[indexPath.row] setSelected:NO];
        [cell addSubview:deviceSwitch_Alerts[indexPath.row]];
        [deviceSwitch_Alerts[indexPath.row] setBackgroundColor:lblRGBA(99, 99, 99, 1)];
        [deviceSwitch_Alerts[indexPath.row] setTintColor:lblRGBA(99, 99, 102, 1)];
        [deviceSwitch_Alerts[indexPath.row] setThumbTintColor:lblRGBA(255, 255, 255, 1)];
        [deviceSwitch_Alerts[indexPath.row] setExclusiveTouch:YES];
        
        if([[[arr_itemsWatering objectAtIndex:indexPath.row] valueForKey:kZoneStatus] isEqualToString:@"ON"])
        {
            [deviceSwitch_Alerts[indexPath.row] setOnTintColor:[UIColor colorWithRed:136.0/255 green:197.0/255 blue:65.0/255 alpha:1.000]];
            [deviceSwitch_Alerts[indexPath.row] setOn:YES animated:NO];
            [deviceSwitch_Alerts[indexPath.row] setSelected:YES];
            deviceSwitch_Alerts[indexPath.row].enabled=YES;
            plusButton[indexPath.row].userInteractionEnabled=YES;
            minusButton[indexPath.row].userInteractionEnabled=YES;
        }

        btnCell = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            imgViewZone.frame = CGRectMake(0,5, 74, 65);
            btnCell.frame = CGRectMake(0, 0, tableViewSprinkler.frame.size.width, 65);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btnCell.frame = CGRectMake(0, 0, tableViewSprinkler.frame.size.width, 73);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            btnCell.frame = CGRectMake(0, 0, tableViewSprinkler.frame.size.width, 66);
        }
        btnCell.backgroundColor = [UIColor clearColor];
        [btnCell addTarget:self action:@selector(ShowWarning_Permission_Schedule:) forControlEvents:UIControlEventTouchUpInside];
        btnCell.userInteractionEnabled=NO;
        [cell addSubview:btnCell];

        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
        {
            NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
            if([appDelegate.strNetworkPermission isEqualToString:@"2"])
            {
                btnCell.userInteractionEnabled=YES;
            }
        }

//        cell.backgroundColor=lblRGBA(70, 71, 73, 1);
        
        if(indexPath.row==arr_itemsWatering.count-1)
        {
            strLoad=@"YES";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = view;

        UIView *view_Header = [[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_Header.frame = CGRectMake(0, 0, tableView.bounds.size.width+50, 5);
        }else{
            view_Header.frame = CGRectMake(0, 0, tableView.bounds.size.width, 5);
        }
        [view_Header setBackgroundColor:lblRGBA(65, 64, 66, 1)];
        view_Header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        view_Header.layer.masksToBounds=YES;
        [cell addSubview:view_Header];
        
        UIView *view_Footer=[[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_Footer.frame=CGRectMake(0, 70, tableView.bounds.size.width+50, 5);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_Footer.frame=CGRectMake(0, 78, tableView.bounds.size.width, 5);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            view_Footer.frame=CGRectMake(0, 71, tableView.bounds.size.width, 5);
        }
        
        [view_Footer setBackgroundColor:lblRGBA(65, 64, 66, 1)];
        view_Footer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        view_Footer.layer.masksToBounds=YES;
        [cell addSubview:view_Footer];
    }
    return cell;
}


- (void)switchToggledZones:(UISwitch *)twistedSwitch
{
    UITableViewCell* cell = (UITableViewCell*)[twistedSwitch superview];
    NSIndexPath* indexPath = [tableViewSprinkler indexPathForCell:cell];
    NSLog(@"row =%ld",(long)[indexPath row]);
    currentTag=(int)[indexPath row];
    NSLog(@"duration==%@",[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneDuration]);
    int deviceTag;
    if ([twistedSwitch isOn] && (![twistedSwitch isSelected]))
    {
        //Write code for SwitchON Action
        
        zoneSelection_Count=zoneSelection_Count+1;
        [twistedSwitch setSelected:YES];
        NSLog(@"on");
        deviceTag=(int)twistedSwitch.tag;
        NSLog(@"switch tag==%d",deviceTag);
        if([lbl_Button[deviceTag].text isEqualToString:@"0"])
        {
            lbl_Button[deviceTag].text=@"1";
        }
        //        if([[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneDuration] isEqualToString:@"0"])
        //        {
        //
        //        }
        [deviceSwitch_Alerts[deviceTag] setOnTintColor:lblRGBA(135, 197, 65, 1)];
        plusButton[deviceTag].userInteractionEnabled=YES;
        minusButton[deviceTag].userInteractionEnabled=YES;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //[dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kDeviceID] forKey:kDeviceID];
        [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneID] forKey:kZoneID];
        [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneName] forKey:kZoneName];
        [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneThumbnailImage]  forKey:kZoneThumbnailImage];
        [dict setObject:@"ON" forKey:kZoneStatus];
        [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneDuration]  forKey:kZoneDuration];
        if([lbl_Button[deviceTag].text isEqualToString:@"1"])
        {
            lbl_Button[deviceTag].text=@"1";
            [dict setObject:@"1"  forKey:kZoneDuration];
        }
        [arr_itemsWatering replaceObjectAtIndex:currentTag withObject:dict];
    }
    else if ((![twistedSwitch isOn]) && [twistedSwitch isSelected])
    {
        zoneSelection_Count=zoneSelection_Count-1;
        [twistedSwitch setSelected:NO];
        NSLog(@"off");
        deviceTag=(int)twistedSwitch.tag;
        NSLog(@"switch tag==%d",deviceTag);
        plusButton[deviceTag].userInteractionEnabled=NO;
        minusButton[deviceTag].userInteractionEnabled=NO;
        //lbl_Button[deviceTag].text=@"1";
        [deviceSwitch_Alerts[deviceTag] setBackgroundColor:lblRGBA(99, 99, 102, 1)];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //[dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kDeviceID] forKey:kDeviceID];
        [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneID] forKey:kZoneID];
        [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneName] forKey:kZoneName];
        [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneThumbnailImage]  forKey:kZoneThumbnailImage];
        [dict setObject:@"OFF" forKey:kZoneStatus];
        [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneDuration]  forKey:kZoneDuration];
        [arr_itemsWatering replaceObjectAtIndex:currentTag withObject:dict];
    }
}
-(void)addProjectPressed:(UIButton *)sender;
{
    UITableViewCell* cell = (UITableViewCell*)[sender superview];
    NSIndexPath* indexPath = [tableViewSprinkler indexPathForCell:cell];
    NSLog(@"row =%ld",(long)[indexPath row]);
    currentTag=(int)[indexPath row];
    NSLog(@"duration==%@",[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneDuration]);
    NSLog(@"tag==%ld",(long)sender.tag);
    NSString *strVal=lbl_Button[sender.tag].text;
    NSLog(@"strval==%@",strVal);
    int val=[strVal intValue];
    val=val+1;
    lbl_Button[sender.tag].text=[NSString stringWithFormat:@"%d",val];
    if(val>1)
    {
        lblMin[sender.tag].text=@"MINUTES";
    }else{
        lblMin[sender.tag].text=@"MINUTE";
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //[dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kDeviceID] forKey:kDeviceID];
    [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneID] forKey:kZoneID];
    [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneName] forKey:kZoneName];
    [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneThumbnailImage]  forKey:kZoneThumbnailImage];
    [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneStatus]  forKey:kZoneStatus];
    [dict setObject:[NSString stringWithFormat:@"%d",val]  forKey:kZoneDuration];
    [arr_itemsWatering replaceObjectAtIndex:currentTag withObject:dict];
    NSLog(@"array replacing ==%@",[arr_itemsWatering objectAtIndex:currentTag]);
    NSLog(@"full array ==%@",arr_itemsWatering);
}
-(void)deleteProjectPressed:(UIButton *)sender;
{
    UITableViewCell* cell = (UITableViewCell*)[sender superview];
    NSIndexPath* indexPath = [tableViewSprinkler indexPathForCell:cell];
    NSLog(@"row =%ld",(long)[indexPath row]);
    currentTag=(int)[indexPath row];
    NSLog(@"duration==%@",[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneDuration]);
    NSLog(@"tag==%ld",(long)sender.tag);
    NSLog(@"The button title is %@",sender.titleLabel.text);
    NSString *strVal=lbl_Button[sender.tag].text;
    NSLog(@"strval==%@",strVal);
    int val=[strVal intValue];
    if(val==1)
    {
        return;
    }
    val=val-1;
    lbl_Button[sender.tag].text=[NSString stringWithFormat:@"%d",val];
    if(val>1)
    {
        lblMin[sender.tag].text=@"MINUTES";
    }else{
        lblMin[sender.tag].text=@"MINUTE";
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //[dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kDeviceID] forKey:kDeviceID];
    [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneID] forKey:kZoneID];
    [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneName] forKey:kZoneName];
    [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneThumbnailImage]  forKey:kZoneThumbnailImage];
    [dict setObject:[[arr_itemsWatering objectAtIndex:currentTag] valueForKey:kZoneStatus]  forKey:kZoneStatus];
    [dict setObject:[NSString stringWithFormat:@"%d",val]  forKey:kZoneDuration];
    [arr_itemsWatering replaceObjectAtIndex:currentTag withObject:dict];
    
}
#pragma mark - EditableTableViewDelegate
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        //for example [activityIndicator stopAnimating];
        //strLoad=@"YES";
        CGFloat tableHeight = 0.0f;
        for (int i = 0; i < [arr_itemsWatering count]; i ++) {
            tableHeight += [self tableView:self.tableViewSprinkler heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        self.tableViewSprinkler.frame = CGRectMake(self.tableViewSprinkler.frame.origin.x, self.tableViewSprinkler.frame.origin.y, self.tableViewSprinkler.frame.size.width, tableHeight);
        
        self.viewWatering.frame=CGRectMake(self.viewWatering.frame.origin.x, self.viewWatering.frame.origin.y, self.viewWatering.frame.size.width, self.tableViewSprinkler.frame.origin.y+self.tableViewSprinkler.frame.size.height+20);
        
        self.viewCompletion.frame=CGRectMake(self.viewCompletion.frame.origin.x, self.viewWatering.frame.origin.y+self.viewWatering.frame.size.height, self.viewCompletion.frame.size.width, self.viewCompletion.frame.size.height);
        
        self.scrollViewConainer.contentSize=CGSizeMake(self.scrollViewConainer.frame.origin.x, self.viewCompletion.frame.size.height+self.viewCompletion.frame.origin.y);
    }
}
- (void)editableTableController:(EditableTableController *)controller willBeginMovingCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"willBeginMovingCellAtIndexPath");
    [self.tableViewSprinkler beginUpdates];
    
    [self.tableViewSprinkler deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableViewSprinkler insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    self.itemBeingMoved = [self.arr_itemsWatering objectAtIndex:indexPath.row];
    //[self.items replaceObjectAtIndex:indexPath.row withObject:self.placeholderItem];
    
    [self.tableViewSprinkler endUpdates];
}

- (BOOL)editableTableController:(EditableTableController *)controller canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)moveTableView:(EditableTableController *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *item = [self.arr_itemsWatering objectAtIndex:fromIndexPath.row];
    [self.arr_itemsWatering removeObjectAtIndex:fromIndexPath.row];
    [self.arr_itemsWatering insertObject:item atIndex:toIndexPath.row];
    //    [[self.movies objectAtIndex:fromIndexPath.section] removeObjectAtIndex:fromIndexPath.row];
    //    [[self.movies objectAtIndex:toIndexPath.section] insertObject:movie atIndex:toIndexPath.row];
    
}
- (NSIndexPath *)moveTableView:(EditableTableController *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    //	Uncomment these lines to enable moving a row just within it's current section
    //	if ([sourceIndexPath section] != [proposedDestinationIndexPath section]) {
    //		proposedDestinationIndexPath = sourceIndexPath;
    //	}
    
    return proposedDestinationIndexPath;
}

- (void)editableTableController:(EditableTableController *)controller movedCellWithInitialIndexPath:(NSIndexPath *)initialIndexPath fromAboveIndexPath:(NSIndexPath *)fromIndexPath toAboveIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"movedCellWithInitialIndexPath");
    [self.tableViewSprinkler beginUpdates];
    
    [self.tableViewSprinkler moveRowAtIndexPath:toIndexPath toIndexPath:fromIndexPath];
    
    NSString *item = [self.arr_itemsWatering objectAtIndex:toIndexPath.row];
    [self.arr_itemsWatering removeObjectAtIndex:toIndexPath.row];
    
    if (fromIndexPath.row == [self.arr_itemsWatering count])
    {
        [self.arr_itemsWatering addObject:item];
    }
    else
    {
        [self.arr_itemsWatering insertObject:item atIndex:fromIndexPath.row];
    }
    
    [self.tableViewSprinkler endUpdates];
}
- (void)editableTableController:(EditableTableController *)controller didMoveCellFromInitialIndexPath:(NSIndexPath *)initialIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"didMoveCellFromInitialIndexPath");
    NSLog(@"initial index path =%ld and toindexpath =%ld" ,(long)initialIndexPath.row,(long)toIndexPath.row);
    [self.arr_itemsWatering replaceObjectAtIndex:toIndexPath.row withObject:self.itemBeingMoved];
    
    [self.tableViewSprinkler reloadRowsAtIndexPaths:@[toIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    self.itemBeingMoved = nil;
}

#pragma mark - WebService
-(void)getSpinklerZoneList
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults objectForKey:@"ACCOUNTID"]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/zones",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for sprinkler zone list==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseSpinklerZoneList) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for sprinkler zone list ==%@",resErrorString);
        strResponseError = resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights_AddSprinklers) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorSprinklerSchedule) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)responseSpinklerZoneList
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            arr_itemsWatering = [[NSMutableArray alloc] init];
            NSMutableArray *arrZoneDetails=[[NSMutableArray alloc] init];
            arrZoneDetails = [[responseDict valueForKey:@"data"]valueForKey:@"zoneDetails"];
            NSLog(@"device list==%@",arrZoneDetails);
            NSLog(@"device data count==%lu",(unsigned long)arrZoneDetails.count);
            
            NSMutableArray *arrList = [[NSMutableArray alloc] init];
            NSMutableDictionary *dict_ZoneList;
            for (int alertindex=0; alertindex<[arrZoneDetails count]; alertindex++) {
                arrList = [[arrZoneDetails objectAtIndex:alertindex] valueForKey:@"zoneList"];
                for (int index=0; index<[arrList count]; index++) {
                    if(![[[[arrList objectAtIndex:index] valueForKey:@"status"] stringValue] isEqualToString:@"2"])
                    {
                        NSLog(@"%@",[[arrList objectAtIndex:index] valueForKey:@"name"]);
                        dict_ZoneList = [[NSMutableDictionary alloc] init];
                       // [dict_ZoneList setObject:[[[arrZoneDetails objectAtIndex:alertindex] valueForKey:@"deviceId"] stringValue] forKey:kDeviceID];
                        [dict_ZoneList setObject:[[arrList objectAtIndex:index] valueForKey:@"name"] forKey:kZoneName];
                        [dict_ZoneList setObject:[[arrList objectAtIndex:index] valueForKey:@"thumbnailImage"]  forKey:kZoneThumbnailImage];
                        [dict_ZoneList setObject:[[[arrList objectAtIndex:index] valueForKey:@"id"] stringValue] forKey:kZoneID];
                        [dict_ZoneList setObject:@"OFF"  forKey:kZoneStatus];
                        [dict_ZoneList setObject:@"0"  forKey:kZoneDuration];
                        [arr_itemsWatering addObject:dict_ZoneList];
                    }
                }
            }
            NSLog(@"%@",arr_itemsWatering);
            [self setupTableView];
            self.scrollViewConainer.hidden=NO;
            [self stop_PinWheel_Lights_AddSprinklers];
        }else{
            [self stop_PinWheel_Lights_AddSprinklers];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            [self adjustableTableZone];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Lights_AddSprinklers];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
        [self adjustableTableZone];
    }
}
-(void)getUpdatedSpinklerZoneList
{
    
    defaults=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"accounts/%@/networks/%@/controllers/%@/zoneSchedules?zoneScheduleId=%@",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],[dictScheduleList objectForKey:@"id"]];
    NSLog(@"method name==%@",strMethodNameWith_Value);
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Schedule details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseZoneScheduleDetails) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Schedule details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights_AddSprinklers) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorSprinklerSchedule) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)responseZoneScheduleDetails
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            arr_itemsWatering = [[NSMutableArray alloc] init];
            NSMutableArray *arrZoneDetails=[[NSMutableArray alloc] init];
            NSMutableArray *arrSelectedZoneDetails=[[NSMutableArray alloc] init];
            NSMutableArray *arrzoneSchDetails=[[responseDict valueForKey:@"data"] valueForKey:@"zoneScheduleDetails"];
            if([arrzoneSchDetails count]>0)
            {
                arrSelectedZoneDetails=[[arrzoneSchDetails objectAtIndex:0] valueForKey:@"zoneScheduleTime"];
                if([arrSelectedZoneDetails count]>0)
                {
                    NSLog(@"arrselected zone details count =%lu",(unsigned long)arrSelectedZoneDetails.count);
                    arrZoneDetails = [[arrzoneSchDetails objectAtIndex:0] valueForKey:@"remainingZoneList"];
                    NSLog(@"rest of the zones list==%@",arrZoneDetails);
                    NSLog(@"rest zone data count==%lu",(unsigned long)arrZoneDetails.count);
                    zoneSelection_Count=0;
                    NSMutableDictionary *dict_ZoneList;
                    for (int index=0; index<[arrSelectedZoneDetails count]; index++) {
                        NSLog(@"%@",[[arrSelectedZoneDetails objectAtIndex:index] valueForKey:@"name"]);
                        dict_ZoneList = [[NSMutableDictionary alloc] init];
                        [dict_ZoneList setObject:[[arrSelectedZoneDetails objectAtIndex:index] valueForKey:@"name"] forKey:kZoneName];
                        [dict_ZoneList setObject:[[arrSelectedZoneDetails objectAtIndex:index] valueForKey:@"thumbnailImage"]  forKey:kZoneThumbnailImage];
                        [dict_ZoneList setObject:[[[arrSelectedZoneDetails objectAtIndex:index] valueForKey:@"selectedZoneId"] stringValue] forKey:kZoneID];
                        if([[[[arrSelectedZoneDetails objectAtIndex:index] valueForKey:@"duration"] stringValue] isEqualToString:@"0"])
                        {
                            [dict_ZoneList setObject:@"OFF"  forKey:kZoneStatus];
                        }else{
                            [dict_ZoneList setObject:@"ON"  forKey:kZoneStatus];
                            zoneSelection_Count=zoneSelection_Count+1;
                        }
                        
                        [dict_ZoneList setObject:[[[arrSelectedZoneDetails objectAtIndex:index] valueForKey:@"duration"] stringValue]  forKey:kZoneDuration];
                        [arr_itemsWatering addObject:dict_ZoneList];
                    }
                    NSLog(@"arr_itemsWatering =%@",arr_itemsWatering);
                    
                    for (int index=0; index<[arrZoneDetails count]; index++) {
                        NSLog(@"%@",[[arrZoneDetails objectAtIndex:index] valueForKey:@"name"]);
                        dict_ZoneList = [[NSMutableDictionary alloc] init];
                        [dict_ZoneList setObject:[[arrZoneDetails objectAtIndex:index] valueForKey:@"name"] forKey:kZoneName];
                        [dict_ZoneList setObject:[[arrZoneDetails objectAtIndex:index] valueForKey:@"thumbnailImage"]  forKey:kZoneThumbnailImage];
                        [dict_ZoneList setObject:[[[arrZoneDetails objectAtIndex:index] valueForKey:@"id"] stringValue] forKey:kZoneID];
                        [dict_ZoneList setObject:@"OFF"  forKey:kZoneStatus];
                        [dict_ZoneList setObject:@"0"  forKey:kZoneDuration];
                        [arr_itemsWatering addObject:dict_ZoneList];
                    }
                    NSLog(@"arr_itemsWatering =%@",arr_itemsWatering);
                    [self setupTableView];
                    self.scrollViewConainer.hidden=NO;
                }
                else{
                    arrZoneDetails = [[arrzoneSchDetails objectAtIndex:0] valueForKey:@"remainingZoneList"];
                    NSLog(@"rest of the zones list==%@",arrZoneDetails);
                    NSLog(@"rest zone data count==%lu",(unsigned long)arrZoneDetails.count);
                    if([arrZoneDetails count]>0)
                    {
                        zoneSelection_Count=0;
                        NSMutableDictionary *dict_ZoneList;
                        for (int index=0; index<[arrZoneDetails count]; index++) {
                            NSLog(@"%@",[[arrZoneDetails objectAtIndex:index] valueForKey:@"name"]);
                            dict_ZoneList = [[NSMutableDictionary alloc] init];
                            [dict_ZoneList setObject:[[arrZoneDetails objectAtIndex:index] valueForKey:@"name"] forKey:kZoneName];
                            [dict_ZoneList setObject:[[arrZoneDetails objectAtIndex:index] valueForKey:@"thumbnailImage"]  forKey:kZoneThumbnailImage];
                            [dict_ZoneList setObject:[[[arrZoneDetails objectAtIndex:index] valueForKey:@"id"] stringValue] forKey:kZoneID];
                            [dict_ZoneList setObject:@"OFF"  forKey:kZoneStatus];
                            [dict_ZoneList setObject:@"0"  forKey:kZoneDuration];
                            [arr_itemsWatering addObject:dict_ZoneList];
                        }
                        NSLog(@"arr_itemsWatering =%@",arr_itemsWatering);
                        [self setupTableView];
                        self.scrollViewConainer.hidden=NO;
                    }else
                    {
                        [self setupTableView];
                        [self adjustableTableZone];
                    }
                }
            }
            else{
                [self setupTableView];
                [self adjustableTableZone];
            }
            [self stop_PinWheel_Lights_AddSprinklers];
        }else{
            [self stop_PinWheel_Lights_AddSprinklers];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            [self adjustableTableZone];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Lights_AddSprinklers];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
        [self adjustableTableZone];
    }
}
-(void)responseErrorSprinklerSchedule
{
    [Common showAlert:kAlertTitleWarning withMessage:strResponseError];
}

-(void)check_ZoneName_Availablity
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults objectForKey:@"ACCOUNTID"]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *schname = txt_ScheduleName.text;
    schname = [schname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/uniqueNames?id=%@&scheduleName=%@",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],strScheduleID,schname];
    NSLog(@"methodname ==%@",strMethodNameWith_Value);
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for sprinkler zone list==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseZoneNameAvailablity) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for sprinkler zone list ==%@",resErrorString);
        strResponseError = resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights_AddSprinklers) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorSprinklerSchedule) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)responseZoneNameAvailablity
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
//            strScheduleName=txt_ScheduleName.text;
            [self stop_PinWheel_Lights_AddSprinklers];
        }else{
            [self stop_PinWheel_Lights_AddSprinklers];
            [Common showAlert:@"Warning" withMessage:@"This Schedule Name Already Exists"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Lights_AddSprinklers];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)add_Sprinkler_Schedule
{
    NSString *selected_Zones=@"";
    for (int index=0; index<[arr_itemsWatering count]; index++) {
        if ([[[arr_itemsWatering objectAtIndex:index] valueForKey:kZoneStatus] isEqualToString:@"ON"]) {
            NSString *strZone=[NSString stringWithFormat:@"{\"zone\":{\"id\":\"%@\"},\"zoneOrder\":\"%@\",\"duration\":\"%@\"}",[[arr_itemsWatering objectAtIndex:index] valueForKey:kZoneID],[NSString stringWithFormat:@"%d",index+1],[[arr_itemsWatering objectAtIndex:index] valueForKey:kZoneDuration]];
            if([selected_Zones isEqualToString:@""])
            {
                selected_Zones=[NSString stringWithFormat:@"%@",strZone];
            }else{
                selected_Zones=[NSString stringWithFormat:@"%@,%@",selected_Zones,strZone];
            }
            
        }else{
            NSString *strZone=[NSString stringWithFormat:@"{\"zone\":{\"id\":\"%@\"},\"zoneOrder\":\"%@\",\"duration\":\"%@\"}",[[arr_itemsWatering objectAtIndex:index] valueForKey:kZoneID],[NSString stringWithFormat:@"%d",index+1],@"0"];
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
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults objectForKey:@"ACCOUNTID"]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"accounts/%@/networks/%@/controllers/%@/zoneSchedules",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];
    NSDictionary *parameters;
    NSLog(@"para==%@",strMethodNameWith_Value);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictAddScheduleDetails=[[NSMutableDictionary alloc] init];
    [dictAddScheduleDetails setObject:txt_ScheduleName.text forKey:kscheduleName];
    [dictAddScheduleDetails setObject:times forKey:kScheduleTime];
    [dictAddScheduleDetails setObject:strJan forKey:kJan];
    [dictAddScheduleDetails setObject:strFeb forKey:kFeb];
    [dictAddScheduleDetails setObject:strMar forKey:kMar];
    [dictAddScheduleDetails setObject:strApr forKey:kApr];
    [dictAddScheduleDetails setObject:strMay forKey:kMay];
    [dictAddScheduleDetails setObject:strJun forKey:kJun];
    [dictAddScheduleDetails setObject:strJly forKey:kJly];
    [dictAddScheduleDetails setObject:strAug forKey:kAug];
    [dictAddScheduleDetails setObject:strSep forKey:kSep];
    [dictAddScheduleDetails setObject:strOct forKey:kOct];
    [dictAddScheduleDetails setObject:strNov forKey:kNov];
    [dictAddScheduleDetails setObject:strDec forKey:kDec];
    [dictAddScheduleDetails setObject:strOdd forKey:kOddDay];
    [dictAddScheduleDetails setObject:strEven forKey:kEvenDay];
    [dictAddScheduleDetails setObject:strRunEvery forKey:kRunEvery];
    [dictAddScheduleDetails setObject:strSun forKey:kSun];
    [dictAddScheduleDetails setObject:strMon forKey:kMon];
    [dictAddScheduleDetails setObject:strTue forKey:kTue];
    [dictAddScheduleDetails setObject:strWed forKey:kWed];
    [dictAddScheduleDetails setObject:strThrus forKey:kThr];
    [dictAddScheduleDetails setObject:strFri forKey:kFri];
    [dictAddScheduleDetails setObject:strSat forKey:kSat];
    [dictAddScheduleDetails setObject:strSun forKey:kSun];
    [dictAddScheduleDetails setObject:jsonZones forKey:kScheduleZones];
    
    if([strScheduleAction isEqualToString:@"EDIT"])
    {
        [dictAddScheduleDetails setObject:[dictScheduleList objectForKey:@"id"] forKey:kScheduleID];
        [dictAddScheduleDetails setObject:[[dictScheduleList objectForKey:@"zoneScheduleMonth"] objectForKey:@"id"] forKey:kScheduleMonthID];
        [dictAddScheduleDetails setObject:[[dictScheduleList objectForKey:@"zoneScheduleDay"] objectForKey:@"id"]forKey:kScheduleDayID];
        parameters=[SCM updateSprinklerSchedule:dictAddScheduleDetails];
        
    }else{
        parameters=[SCM addSprinklerSchedule:dictAddScheduleDetails];
    }

    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Add new Schedule==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseScheduleAdding) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Add new Schedule==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights_AddSprinklers) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorSprinklerSchedule) withObject:self waitUntilDone:YES];
    };
    if([strScheduleAction isEqualToString:@"EDIT"])
    {
        [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
    }else{
        [SCM serviceConnector:parameters andMethodName:strMethodNameWith_Value];
    }
}


-(void)responseScheduleAdding
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self stop_PinWheel_Lights_AddSprinklers];
            if([strScheduleAction isEqualToString:@"EDIT"])
            {
                if([strStatus_Schedule isEqualToString:@"lightSchedule"])
                {
                    appDelegate.strScheduleWay=@"YES";
                    [Common viewFadeIn:self.navigationController.view];
                    [self.navigationController popViewControllerAnimated:NO];
                    return;
                }
                if([appDelegate.strDevice_Added_Mode isEqualToString:@"NetworkHome"])
                {
                    appDelegate.strDevice_Added_Status=@"SPRINKLER";
                    for (UIViewController *controller in [self.navigationController viewControllers])
                    {
                        if ([controller isKindOfClass:[SWRevealViewController class]])
                        {
                            [Common viewFadeIn:self.navigationController.view];
                            [self.navigationController popToViewController:controller animated:NO];
                            break;
                        }
                    }
                    
                }
            }else{
                if([strStatus_Schedule isEqualToString:@"lightSchedule"])
                {
                    appDelegate.strScheduleWay=@"YES";
                    [Common viewFadeIn:self.navigationController.view];
                    [self.navigationController popViewControllerAnimated:NO];
                    return;
                }
                
                if([appDelegate.strDevice_Added_Mode isEqualToString:@"NetworkHome"])
                {
                    if (![appDelegate.strDevice_Added_Status isEqualToString:@"OLDPOPUPLOAD"]) {
                        appDelegate.strDevice_Added_Status=@"SPRINKLER";
                    }
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
            [self stop_PinWheel_Lights_AddSprinklers];
            if([responseMessage isEqualToString:@"NAME_ALREADY_USED"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"Schedule name already exists"];
                return;
            }else if ([responseMessage isEqualToString:@"SCHEDULE_DUPLICATE"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"New schedule setting overlaps with existing schedules. Please update and save."];
                return;
            }
            
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Lights_AddSprinklers];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)deleteScheduleSprinkler
{
    defaults=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"accounts/%@/networks/%@/controllers/%@/zoneSchedules?zoneScheduleId=%@",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],[dictScheduleList objectForKey:@"id"]];
    NSLog(@"method name==%@",strMethodNameWith_Value);
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for delete Schedule==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseDelete_SprinklerSchedule) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for delete Schedule==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights_AddSprinklers) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorSprinklerSchedule) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorDELETE:strMethodNameWith_Value];
}
-(void)responseDelete_SprinklerSchedule
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self stop_PinWheel_Lights_AddSprinklers];
            if([strStatus_Schedule isEqualToString:@"lightSchedule"])
            {
                appDelegate.strScheduleWay=@"YES";
                [Common viewFadeIn:self.navigationController.view];
                [self.navigationController popViewControllerAnimated:NO];
                return;
            }
            if([appDelegate.strDevice_Added_Mode isEqualToString:@"NetworkHome"])
            {
                appDelegate.strDevice_Added_Status=@"SPRINKLER";
                for (UIViewController *controller in [self.navigationController viewControllers])
                {
                    if ([controller isKindOfClass:[SWRevealViewController class]])
                    {
                        [Common viewFadeIn:self.navigationController.view];
                        [self.navigationController popToViewController:controller animated:NO];
                        break;
                    }
                }
                
            }
        }else{
            [self stop_PinWheel_Lights_AddSprinklers];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Lights_AddSprinklers];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
-(void)adjustableTableZone
{
    self.tableViewSprinkler.frame = CGRectMake(self.tableViewSprinkler.frame.origin.x, self.tableViewSprinkler.frame.origin.y, self.tableViewSprinkler.frame.size.width, self.tableViewSprinkler.frame.size.height);
    
    self.viewWatering.frame=CGRectMake(self.viewWatering.frame.origin.x, self.viewWatering.frame.origin.y, self.viewWatering.frame.size.width, self.tableViewSprinkler.frame.origin.y+self.tableViewSprinkler.frame.size.height+20);
    
    self.viewCompletion.frame=CGRectMake(self.viewCompletion.frame.origin.x, self.viewWatering.frame.origin.y+self.viewWatering.frame.size.height, self.viewCompletion.frame.size.width, self.viewCompletion.frame.size.height);
    
    self.scrollViewConainer.contentSize=CGSizeMake(self.scrollViewConainer.frame.origin.x, self.viewCompletion.frame.size.height+self.viewCompletion.frame.origin.y);
}
@end
