//
//  AddSprinklerScheldule.h
//  NOID
//
//  Created by iExemplar on 01/08/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Common.h"
#import "EditableTableController.h"

@protocol ProcessDataDelegateSprinklerProfile <NSObject>
@required
-(void)processSuccessful_Back_To_NetworkHome_Via_Sprinkler:(BOOL)success;
- (BOOL)editableTableController:(EditableTableController *)controller canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)moveTableView:(EditableTableController *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (NSIndexPath *)moveTableView:(EditableTableController *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;
@end

@interface AddSprinklerScheldule : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate,EditableTableControllerDelegate>
{
    UITapGestureRecognizer *tapGuster_ViewContainer,*tapGuster_ViewHeader,*tapGuster_ViewSlider;
    id <ProcessDataDelegateSprinklerProfile> delegate;
    AppDelegate *appDelegate;
//    int stTime_Hours;
    NSString *strScheduleName,*strScheduleID,*strResponseError;
    int every_Days;
    BOOL dayMon,dayTus,dayWed,dayThurs,dayFri,daySat,daySun;
    BOOL runEveryDay,runONDay,runOddDay,runEvenDay,runWeekDay;
    BOOL monJan,monFeb,monMar,monApr,monMay,monJun,monJly,monAug,monSep,monOct,monNov,monDec;
    NSUserDefaults *defaults;
    NSDictionary *responseDict;
    NSString *times;
    int zoneSelection_Count;
    NSString *strSun,*strMon,*strWed,*strTue,*strThrus,*strFri,*strSat;
    NSString *strOdd,*strEven,*strRunEvery;
    NSString *strJan,*strFeb,*strMar,*strApr,*strMay,*strJun,*strJly,*strAug,*strSep,*strOct,*strNov,*strDec;
    int currentTag;
    NSMutableArray *arrAlready_Selected_Zone;
}
@property (retain) id delegate;
@property(nonatomic,strong)IBOutlet UITextField *txt_ScheduleName;
@property(nonatomic,strong)IBOutlet UIButton *btn_back_networkHome;
@property(nonatomic,strong)IBOutlet UIButton *btn_back_networkHomeText;
@property(nonatomic,strong)IBOutlet UIButton *btn_networkHome_logo;
@property(nonatomic,strong)IBOutlet UIButton *btn_settings;

@property(nonatomic,strong)IBOutlet UISwitch *switch_RunON_Interval;
@property(nonatomic,strong)IBOutlet UISwitch *switch_SelectDay_Watering;
@property(nonatomic,strong)IBOutlet UISwitch *switch_ODD_Days_Sprinkler;
@property(nonatomic,strong)IBOutlet UISwitch *switch_Even_Days_Sprinkler;
@property(nonatomic,strong)IBOutlet UISwitch *switch_RunEveryDay;


@property(nonatomic,strong)IBOutlet UIView *viewHeader;
@property(nonatomic,strong)IBOutlet UIView *viewSlider;

@property(nonatomic,strong)IBOutlet UIView *viewRunOn_Interval_SubView;

@property(nonatomic,strong)IBOutlet UIButton *btnSelectWatering;
@property(nonatomic,strong)IBOutlet UIButton *btnRunOnDays;
@property(nonatomic,strong)IBOutlet UIButton *btnOddDaySchedule;
@property(nonatomic,strong)IBOutlet UIButton *btnEvenDaySchedule;
@property(nonatomic,strong)IBOutlet UIButton *btnRunEveryDay;

@property(nonatomic,strong)IBOutlet UIScrollView *scrollViewConainer;


//Common Days
@property(nonatomic,strong)IBOutlet UIButton *btn_Sun_day;
@property(nonatomic,strong)IBOutlet UIButton *btn_Mon_Day;
@property(nonatomic,strong)IBOutlet UIButton *btn_Tue_Day;
@property(nonatomic,strong)IBOutlet UIButton *btn_Wed_Day;
@property(nonatomic,strong)IBOutlet UIButton *btn_Turs_day;
@property(nonatomic,strong)IBOutlet UIButton *btn_Fri_Day;
@property(nonatomic,strong)IBOutlet UIButton *btn_Sat_Day;


//Up and Down for Time:
//@property(nonatomic,strong)IBOutlet UIButton *btnUp_StTime;
//@property(nonatomic,strong)IBOutlet UIButton *btnEnd_StTime;
//@property(nonatomic,strong)IBOutlet UILabel *lblStTime;


//Run every
@property(nonatomic,strong)IBOutlet UIButton *btnPlus;
@property(nonatomic,strong)IBOutlet UIButton *btnMinus;
@property(nonatomic,strong)IBOutlet UILabel *lblTime;
@property(nonatomic,strong)IBOutlet UILabel *lblDays;



//Common Month
@property(nonatomic,strong)IBOutlet UIButton *btn_Jan;
@property(nonatomic,strong)IBOutlet UIButton *btn_Feb;
@property(nonatomic,strong)IBOutlet UIButton *btn_Mar;
@property(nonatomic,strong)IBOutlet UIButton *btn_Apr;
@property(nonatomic,strong)IBOutlet UIButton *btn_May;
@property(nonatomic,strong)IBOutlet UIButton *btn_Jun;
@property(nonatomic,strong)IBOutlet UIButton *btn_Jly;
@property(nonatomic,strong)IBOutlet UIButton *btn_Aug;
@property(nonatomic,strong)IBOutlet UIButton *btn_Sep;
@property(nonatomic,strong)IBOutlet UIButton *btn_Oct;
@property(nonatomic,strong)IBOutlet UIButton *btn_Nov;
@property(nonatomic,strong)IBOutlet UIButton *btn_Dec;

@property (nonatomic, weak) IBOutlet UITableView *tableViewSprinkler;
@property (nonatomic, strong) NSMutableArray *arr_itemsWatering;

@property (nonatomic, strong) EditableTableController *editableTableController;
@property (nonatomic, strong) NSString *itemBeingMoved;
@property (nonatomic,strong) IBOutlet UIView *viewWatering;
@property (nonatomic,strong) IBOutlet UIView *viewCompletion;
@property (nonatomic,strong) IBOutlet UIView *viewSaveSch;
@property (nonatomic,strong) IBOutlet UIView *viewDeleteSch;
@property (nonatomic,strong) NSString *strStatus_Schedule;

@property (nonatomic,strong) NSString *strScheduleAction;
@property (nonatomic,strong) NSMutableDictionary *dictScheduleList;

@property (strong, nonatomic) IBOutlet UIView *viewAlert_deleteSchSprinkler;
@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker_ZoneSchedule;
@property (nonatomic, strong) IBOutlet UIButton *btnOkPicker_Sprinkler;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelPicker_Sprinkler;

@property (strong, nonatomic) IBOutlet UIView *pickerView_ZoneSchedule;
@property(nonatomic,strong)IBOutlet UIButton *btn_StartTime_Schedule;

-(IBAction)back_AddSprinklerSchedule_Action:(id)sender;
-(IBAction)switchManualRunTime_Action:(id)sender;
-(IBAction)sprinkler_Schedule_Save_Delete_Action:(id)sender;
-(IBAction)settings_HomeNoid_Action_InAddSchedule:(id)sender;
-(IBAction)daySelected_lightSchedule_Action:(id)sender;
-(IBAction)monthSelected_lightSchedule_Action:(id)sender;
-(IBAction)sprinklerSchedule_Proceed_cancel_Action:(id)sender;
-(IBAction)timePicker_Schedule_Action:(id)sender;
-(IBAction)ShowWarning_Permission_Schedule:(id)sender;
@end
