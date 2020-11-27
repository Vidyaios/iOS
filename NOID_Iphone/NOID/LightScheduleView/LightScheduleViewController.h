//
//  LightScheduleViewController.h
//  NOID
//
//  Created by iExemplar on 23/09/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface LightScheduleViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>
{
    AppDelegate *appDelegate;
    int intDawnPlusHrs,intDawnMinusHrs,intDuskPlusHrs,intDuskMinusHrs;
    BOOL incDawnStatus,decDawnStatus,incDuskStatus,decDuskStatus;
    BOOL dayMon,dayTus,dayWed,dayThurs,dayFri,daySat,daySun;
    BOOL monJan,monFeb,monMar,monApr,monMay,monJun,monJly,monAug,monSep,monOct,monNov,monDec;
    BOOL oddDays,evenDays;
    NSString *str_ScheduleCat_ID,*str_Schedule_Day_Type,*str_Schedule_Month,*startTime,*endTime;
    NSString *strJan,*strFeb,*strMar,*strApr,*strMay,*strJun,*strJly,*strAug,*strSep,*strOct,*strNov,*strDec,*strSun,*strMon,*strTue,*strWed,*strThr,*strFri,*strSat,*strOddDay,*strEvenDay;
    NSString *timerType,*formatedDateFrom,*formatedDateTo,*formatedDateFromRail,*formatedDateToRail,*strResponseError;
    NSUserDefaults *defaults;
    NSDictionary *responseDict;
    int hour,hours;
    NSString *DateFrom,*DateTo,*strAllowDuplicate;
}
@property (strong, nonatomic) NSString *strPreviousView;
@property (strong, nonatomic) NSString *strDeviceType_Schedule;
@property (strong, nonatomic) NSString *strStatus_Schedule;
@property (strong, nonatomic) NSString *strControllerStatus;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_Schedule;

@property (strong, nonatomic) IBOutlet UIButton *btn_header_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_backArrow_Schedule;
@property (strong, nonatomic) IBOutlet UILabel *lbl_header_Schedule;

@property (strong, nonatomic) IBOutlet UITextField *txtfld_ScheduleName;
@property (strong, nonatomic) IBOutlet UIView *view_SaveSchedule;
@property (strong, nonatomic) IBOutlet UIView *view_SkipSchedule;
@property (strong, nonatomic) IBOutlet UIView *view_OddEven_Schedule;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Dawn_Schedule;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Dusk_Schedule;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Dawn_Schedule_Hours;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Dusk_Schedule_Hours;

@property (strong, nonatomic) IBOutlet UIButton *btn_DuskPlus_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_DawnPlus_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_DuskMinus_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_DawnMinus_Schedule;

@property (strong, nonatomic) IBOutlet UIButton *btn_Mon_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Tues_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Wed_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Thur_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Fri_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Sat_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Sun_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Jan_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Feb_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Mar_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Apr_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_May_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_June_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_July_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Aug_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Sep_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Oct_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Nov_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_Dec_Schedule;
@property (strong, nonatomic) IBOutlet UIButton *btn_StartTime;
@property (strong, nonatomic) IBOutlet UIButton *btn_EndTime;
@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIButton *btnOk_picker;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel_picker;

@property (strong, nonatomic) IBOutlet UISwitch *switch_duskSetting_Schedule;
@property (strong, nonatomic) IBOutlet UISwitch *switch_dawnSetting_Schedule;
@property (strong, nonatomic) IBOutlet UISwitch *switch_dusk_Schedule;
@property (strong, nonatomic) IBOutlet UISwitch *switch_dawn_Schedule;
@property (strong, nonatomic) IBOutlet UISwitch *switch_timeFromTo_Schedule;
@property (strong, nonatomic) IBOutlet UISwitch *switch_RunOnOddEven_Schedule;
@property (strong, nonatomic) IBOutlet UISwitch *switch_oddDays_Schedule;
@property (strong, nonatomic) IBOutlet UISwitch *switch_evenDays_Schedule;
@property (strong, nonatomic) NSString *strDeviceID;

-(IBAction)toggleSwitch_lightSchedule_Action:(id)sender;
-(IBAction)daySelected_lightSchedule_Action:(id)sender;
-(IBAction)monthSelected_lightSchedule_Action:(id)sender;
-(IBAction)networkHome_Setting_Schedule_Action:(id)sender;
-(IBAction)dawn_dusk_increment_decrement_Action:(id)sender;
-(IBAction)timePicker_Action:(id)sender;
@end
