//
//  LightsViewController.h
//  NOID
//
//  Created by iExemplar on 09/07/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@protocol ProcessDataDelegateLightsProfile <NSObject>
@required
-(void)processSuccessful_Back_To_NetworkHome_Via_Lights:(BOOL)success;
@end

@interface LightsViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,MKAnnotation,UIGestureRecognizerDelegate,MKOverlay>
{
    id <ProcessDataDelegateLightsProfile> delegate;
    AppDelegate *appDelegate;
    NSString *changeTabStatus,*strSelectedTab,*strPreviousTab;
    NSIndexPath *selectedRowIndex;
    NSInteger selectedIndex,indexValue;
    BOOL vacationModeStatus,cellExpandStatus;
    
    NSDictionary *responseDict;
    NSString *strResponseError,*strDevice_TraceID,*strEncoded_ControllerImage;
    NSUserDefaults *defaultsDevice_Details;
    BOOL imageStatus;
    NSString *latitude,*longitude,*geoStatus;

    UISwitch *duskSwitch_Stngs,*dawnSwitch_Stngs,*duskSwitch_DuskView,*dawnSwitch_DawnView,*switchTime,*switch_ODD_Days,*switch_Even_Days,*switch_RunOn_Header;
    UIButton *btn_Mon_Day,*btn_Wed_Day,*btn_Fri_Day,*btn_Sun_day,*btn_Tue_Day,*btn_Turs_day,*btn_Sat_Day;
    UIButton *btn_Jan,*btn_Feb,*btn_Mar,*btn_Apr,*btn_May,*btn_Jun,*btn_July,*btn_Aug,*btn_Sep,*btn_Oct,*btn_Nov,*btn_Dec;
    NSString *strStatus,*strStatus_Schedule;
    NSInteger viewTagValue;
    float yOffSet_Content;
    UIView *viewSchedule_RunON_Header;
    NSString *strSelected_SchID;
    NSMutableDictionary *dictBody_Schedule;
    int tag_Pos;
    UIView *viewCurrent;
    
    NSString *strJan,*strFeb,*strMar,*strApr,*strMay,*strJun,*strJly,*strAug,*strSep,*strOct,*strNov,*strDec,*strSun,*strMon,*strTue,*strWed,*strThr,*strFri,*strSat,*strOddDay,*strEvenDay,*str_Schedule_Month,*str_Schedule_Day_Type,*strSelecteCategoryID,*startTime,*endTime;
    
    int intDawnPlusHrs,intDawnMinusHrs,intDuskPlusHrs,intDuskMinusHrs;
    BOOL incDawnStatus,decDawnStatus,incDuskStatus,decDuskStatus;
    BOOL dayMon,dayTus,dayWed,dayThurs,dayFri,daySat,daySun;
    BOOL monJan,monFeb,monMar,monApr,monMay,monJun,monJly,monAug,monSep,monOct,monNov,monDec;
    BOOL oddDays,evenDays;
    
    UIButton *btn_StartTime,*btn_EndTime,*btn_Dusk_Minus,*btn_Dusk_Plus,*btn_Dawn_Plus,*btn_Dawn_Minus;
    UILabel *lblDuskHours_View,*lblDawnHours_View;
    NSString *timerType,*formatedDateFrom,*formatedDateTo,*formatedDateFromRail,*formatedDateToRail,*strDeviceEditMode,*strDeviceImage,*strDeviceOldName,*strDeviceCatType,*strDeviceCategoryChangedStatus;
    NSMutableDictionary *dictGetSch_Content;
    MKAnnotationView *annotationView;
    int hour,hours;
    NSString *DateFrom,*DateTo,*strVactionStatusFlag,*strVacStatus,*strAllowDuplicate,*strprorationTime,*strHubActiveStatus,*strScheduleStatus;
    UIButton *btnDuskDawnStng,*btnDawnDuskStng,*btnDusk,*btnDawn,*btnManual,*btnRunOn,*btnOdd,*btnEven;
}
@property (retain) id delegate;
@property (strong, nonatomic) NSString *strZoneID;
@property (strong, nonatomic) NSString *strZoneStatusID;
@property (strong, nonatomic) NSString *strZoneLevel;
@property (strong, nonatomic) NSString *strZoneStatus;
@property (strong, nonatomic) NSString *strDeviceID;
@property (strong, nonatomic) NSString *strDeviceMode;
@property (strong, nonatomic) NSString *strDeviceName;
@property (strong, nonatomic) NSString *strPreviousView;
@property (strong, nonatomic) NSString *strDeviceType;
@property (nonatomic, retain) NSString *str_CheckAction;
@property (nonatomic, retain) NSString *str_HasSchedule;

@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UIView *Device_Del_View;
@property (strong, nonatomic) IBOutlet UIView *view_BackLights;
@property (strong, nonatomic) IBOutlet UIView *header_View_Lights;
@property (strong, nonatomic) IBOutlet UIView *lightsContainerView;
@property (strong, nonatomic) IBOutlet UIView *lightslocationView;
@property (strong, nonatomic) IBOutlet UIView *lightsprofileView;
@property (strong, nonatomic) IBOutlet UIView *lightScheduleView;
@property (strong, nonatomic) IBOutlet UIView *lightTabView;
@property (strong, nonatomic) IBOutlet UIView *deviceCategoryView;
@property (strong, nonatomic) IBOutlet UIView *popUpScheduleView;
@property (nonatomic, strong) IBOutlet UIView *view_VacationMode;
@property (nonatomic, strong) IBOutlet UIView *view_AddSchedule;
@property (nonatomic, strong) IBOutlet UIView *view_infoAlert;
@property (strong, nonatomic) IBOutlet UIView *infoAlertView;

@property (strong, nonatomic) IBOutlet UITextField *txtfld_DeviceName_Lights;

@property (strong, nonatomic) IBOutlet UIButton *btn_edit_lights;
@property (strong, nonatomic) IBOutlet UIButton *btn_edit_category;
@property (strong, nonatomic) IBOutlet UIButton *btn_close_lights;
@property (strong, nonatomic) IBOutlet UIButton *btn_close_categoryDevice;
@property (strong, nonatomic) IBOutlet UIButton *btn_save_lights;
@property (strong, nonatomic) IBOutlet UIButton *btn_save_categoryDevice;
@property (strong, nonatomic) IBOutlet UIButton *deleteProfilebtn;
@property (strong, nonatomic) IBOutlet UIButton *cameraProfilebtn;
@property (strong, nonatomic) IBOutlet UIButton *gallaryProfilebtn;
@property (strong, nonatomic) IBOutlet UIButton *header_Back_Arrow_Btn;
@property (strong, nonatomic) IBOutlet UIButton *header_Back_Text_Btn;
@property (strong, nonatomic) IBOutlet UIButton *btn_DeviceCategory;
@property (nonatomic, strong) IBOutlet UIButton *btn_Vacation;
@property (nonatomic, strong) IBOutlet UIButton *btn_AddSchedule;
@property (nonatomic, strong) IBOutlet UIButton *btn_Info;
@property (strong, nonatomic) IBOutlet UIButton *btnUserLocation;

@property (strong, nonatomic) IBOutlet UILabel *lbl_deviceName_lights;
@property (strong, nonatomic) IBOutlet UILabel *lbl_HeaderName_lights;
@property (strong, nonatomic) IBOutlet UILabel *lbl_lightsLocation;
@property (strong, nonatomic) IBOutlet UILabel *lbl_lightsProfile;
@property (strong, nonatomic) IBOutlet UILabel *lbl_lightSchedule;
@property (strong, nonatomic) IBOutlet UILabel *lbl_vacationMode;
@property (strong, nonatomic) IBOutlet UILabel *lbl_addSchedule_lights;

@property (strong, nonatomic) IBOutlet UITableView *tableView_Category;

@property (strong, nonatomic) NSMutableArray *arrDeviceCategory;
@property (nonatomic, retain) NSMutableArray *arr_Schedule;

@property (strong, nonatomic) IBOutlet UIImageView *imglightsLocation;
@property (strong, nonatomic) IBOutlet UIImageView *imglightsProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imglightSchedule;
@property (strong, nonatomic) IBOutlet UIImageView *img_addSchedule_lights;

@property (nonatomic, retain) IBOutlet MKMapView *mapView_lights;
@property (nonatomic, retain) CLLocationManager *locationManager_lights;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewSchedule;

@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (nonatomic, strong) IBOutlet UIButton *btnOkPicker;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelPicker;

@property (strong, nonatomic) IBOutlet UIView *viewAlert_PlanDowngrade;
@property (strong, nonatomic) IBOutlet UIView *viewAlert_PlanDowngrade_Confirm;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PlanDowngrade_Charge;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PlanDowngrade_Quote;

@property (strong, nonatomic) IBOutlet UIView *view_Category_device;
@property (strong, nonatomic) IBOutlet UILabel *lbl_deleteDevice_Zone;
@property (strong, nonatomic) IBOutlet UILabel *lbl_deleteZone_popUp;
@property (strong, nonatomic) IBOutlet UILabel *lbl_deviceName;
@property (strong, nonatomic) IBOutlet UIView *view_DeleteDevice;
@property (strong, nonatomic) IBOutlet UIView *view_EditDevice;

-(IBAction)Edit_lights_Action:(id)sender;
-(IBAction)Close_lights_Action:(id)sender;
-(IBAction)Save_lights_Action:(id)sender;
-(IBAction)back_NetworkHome_Action_In_LightProfile:(id)sender;
-(IBAction)back_Action_LightsProfile:(id)sender;
-(IBAction)delete_Device_Action:(id)sender;
-(IBAction)close_DC_Action:(id)sender;
-(IBAction)change_delete_Deviceimg_Action:(id)sender;
-(IBAction)setting_lightsProfile_Action:(id)sender;
-(IBAction)changeTab_From_lightsProfile_Action:(id)sender;
-(IBAction)delete_ScheduleCell:(id)sender;
-(IBAction)closeAlert:(id)sender;
-(IBAction)closeInfoAlert:(id)sender;
-(IBAction)category_DropDown_Action:(id)sender;
-(IBAction)planDowngrade_Confirmation_Action:(id)sender;

@end
