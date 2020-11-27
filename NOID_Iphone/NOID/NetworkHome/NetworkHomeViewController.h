//
//  NetworkHomeViewController.h
//  NOID
//
//  Created by iExemplar on 25/06/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "LightsViewController.h"
#import "AddSprinklerScheldule.h"
#import "DeviceSetUpViewController.h"
#import "SprinklerDeviceSetupViewController.h"
#import "SWRevealViewController.h"
#import <MapKit/MapKit.h>
#import "MapOverlay.h"
#import "MapOverlayView.h"
#import "TimeLineViewController.h"

@interface NetworkHomeViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ProcessDataDelegateSettings,ProcessDataDelegateLightsProfile,ProcessDataDelegateSprinklerProfile,UITextFieldDelegate,ProcessDataDelegateDeviceSetUpProfile,ProcessDataDelegateSprinklerDeviceSetUpProfile,SWRevealViewControllerDelegate,MKMapViewDelegate,ProcessDataDelegateTimeLine>
{
    UITapGestureRecognizer *tapViewContainer,*tapViewHeader,*tapViewTitle,*tapScrollView,*tapViewAlert;
    int wheaterTag,cardTag;
    UITapGestureRecognizer *TapView1,*TapView2,*TapView3,*TapView4,*TapView5,*TapView6,*TapView7,*TapView8,*TapChangeWeather,*TapPopUpViewHide;
    BOOL cellExpandStatusAlert;
    NSInteger indexValue;
    NSString *deviceActions,*strAlertType;
    UISwipeGestureRecognizer *swipeDownLightsAlert,*swipeDownOthersAlert,*swipeDownAlert;
    UISwitch *deviceSwitch;
    CGFloat yOffset;
    NSString *str_Selected_Tap,*str_Previous_Tap,*strStatusDevice,*strStatusSchedule;
    
    NSString *strTYPES,*respMSG,*strManualType;
    NSMutableArray *arr_Schedule_Sprinklers;
    NSUserDefaults *defaults;
    AppDelegate *appDelegate;
    NSString *strResponseError,*strWeatherName,*strLoadedStatus;
    NSDictionary *responseDict,*responseDict_Weather,*dictProperty_NetworkDetails;
    NSMutableArray *arrWeatherDetails,*arrDevices;
    NSString *Time,*strTimer_Status,*strWeatherType,*strLoaderViewStatus;
    NSDate *end;
    NSTimeInterval interval;
    int deviceTag;
    float yOffSet_Content_Alert;
    NSInteger viewTagValueAlert;
    NSMutableArray *arrPropertyDevices,*arrMessageList;
    NSString *strSUID,*propertyLoaderStatus,*strEncoded_ControllerImage,*strUpdatedLat,*strUpdatedLong,*str_Zone_ActiveSchedule;
    int timerMinutes,selectedIndexPin;
    UIView *viewCurrent;
    int tag_Pos_Alerts,messageCount,sprinkler_On_Count;
    NSString *strzoneModeStatus;
    float yaxis_Device,yaxis_Schedule;
    NSString *newVacModeStatus,*vacationModeStatus;
    NSString *select_Map_ZoneStatus,*select_Map_ZoneStatusID,*select_Map_ZoneLevel,*select_Map_DeviceID,*select_Map_DeviceType,*select_Map_ZoneID,*strCallout,*select_Map_DeviceMode;
    UIView *viewCallout;
     int current_Active_On_Tag,currentWeather_tag;
    NSString *strCurrent_WeatherImage,*strTimeZoneIDFor_User,*strTimeZoneIDFor_Weather;
}
@property (strong, nonatomic) NetworkHomeViewController *NHVC;
@property (nonatomic, retain) NSTimer *logTimer;
@property (weak, nonatomic) IBOutlet UIButton *sidebarButton;
@property(nonatomic,retain) IBOutlet UIView *alertFooter;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_Alert;
@property(nonatomic,retain) IBOutlet UIButton *btnSliderHeader_Bar;
@property(nonatomic,retain) IBOutlet UIButton *btnSliderHeader_Image;
@property(nonatomic,retain) IBOutlet UIView *viewLightsCard_FooterView;
@property(nonatomic,retain) IBOutlet UIScrollView *scroll_View_LightsCard;

//new Sprinkler Smooth Card
@property(nonatomic,retain) IBOutlet UIView *viewSprinklerAlert;
@property(nonatomic,retain) IBOutlet UIView *viewSprinklerAlert_Schedule_FooterView;
@property(nonatomic,retain) IBOutlet UIView *viewSprinklerAlert_Device_FooterView;
@property(nonatomic,retain) IBOutlet UIView *viewSprinklerAlert_ScheduleView;
@property(nonatomic,retain) IBOutlet UIView *viewSprinklerAlert_DeviceView;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView_SprinklerCard;

@property(nonatomic,retain) IBOutlet UIView *viewSprinkler_Alert;
@property(nonatomic,retain) IBOutlet UIView *tabView_Sprinkler;
@property(nonatomic,retain) IBOutlet UIView *tab_ScheduleView;
@property(nonatomic,retain) IBOutlet UIView *tab_DeviceView;
@property(nonatomic,retain) IBOutlet UIView *tabDetailView_Sprinkler;
@property(nonatomic,retain) IBOutlet UIView *viewSprinklersCard_DataView;
@property(nonatomic,retain) IBOutlet UIView *viewSprinklersCard_FooterView;
@property(nonatomic,retain) IBOutlet UIView *viewSprinklersCard_Schedule_FooterView;
@property(nonatomic,retain) IBOutlet UIScrollView *scroll_View_SprinklersCard;
@property(nonatomic,retain) IBOutlet UIScrollView *scroll_View_Sprinklers_Schedule;
@property(nonatomic,retain) IBOutlet UIScrollView *scroll_View_Sprinklers_Device;
@property(strong,nonatomic) IBOutlet UIView *viewSprinkler_SwipeDownView;
@property(nonatomic,retain) IBOutlet UIButton *btn_sprinkler_swipeDown;
@property(nonatomic,retain) IBOutlet UIView *view_VacationMode;
@property(nonatomic,retain) IBOutlet UIView *view_AddSchedule;
@property(nonatomic,retain) IBOutlet UIView *infoPopupView;
@property(nonatomic,retain) IBOutlet UIImageView *imgViewAdd_Sch;
@property(nonatomic,retain) IBOutlet UILabel *lblViewAdd_Sch;

@property (strong, nonatomic) IBOutlet UIView *header_View_Lights;
@property(nonatomic,retain) NSMutableArray *arrDeivce_Name;
@property(nonatomic,retain) NSMutableArray *arrDeivce_Images;
@property(nonatomic,retain)NSMutableArray *arr_ScheduleName;
@property(nonatomic,retain) NSMutableArray *arr_ScheduleTime;

@property (strong, nonatomic) IBOutlet UITableView *tbleView_Lights;
@property (strong, nonatomic) IBOutlet UITableView *tbleView_Sprinklers;
@property (strong, nonatomic)IBOutlet UITableView *tbleView_ScheduleSprinklers;
@property (strong, nonatomic) IBOutlet UIView *popUpScheduleView;
@property (nonatomic,strong) IBOutlet UIView *view_infoAlert;

@property (strong, nonatomic) IBOutlet UIView *view_alert;
@property (strong, nonatomic) IBOutlet UIView *headerView_NetworkHome;
@property (strong, nonatomic) IBOutlet UIView *BodyView_NetworkHome;
@property (strong, nonatomic) IBOutlet UIView *BodyView_Weather;
@property (strong, nonatomic) IBOutlet UIView *BodyView_Container;
@property (strong, nonatomic) IBOutlet UIView *BodyView_PropertyMap;
@property (strong, nonatomic) IBOutlet UIView *ViewLightDevice;
@property (strong, nonatomic) IBOutlet UIView *titleBarView1_swipe;
@property (strong, nonatomic) IBOutlet UIView *alertSwipeDownView;
@property (strong, nonatomic) IBOutlet UIView *deviceSwipeDownView;
@property (strong, nonatomic) IBOutlet UIView *lightsAddDeviceViewButton;
@property (strong, nonatomic) IBOutlet UIView *sprinklerAddDeviceViewButton;
@property (strong, nonatomic) IBOutlet UIView *sprinklerScheduleView;
@property (strong, nonatomic) IBOutlet UIView *view_Schedule;
@property (strong, nonatomic) IBOutlet UIView *view_Devices;

@property (strong, nonatomic) IBOutlet UIButton *btn_swipeDownAlert;
@property (strong, nonatomic) IBOutlet UIButton *btn_swipeDownDeviceAlerts;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_weather;
@property (strong,nonatomic) IBOutlet UIScrollView *scroll_SprinklerScheduleVw;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

//weather configuration
@property (strong, nonatomic) IBOutlet UILabel *lbl_timeAgo;

@property (strong, nonatomic) IBOutlet UILabel *lbl_temp1;
@property (strong, nonatomic) IBOutlet UILabel *lbl_temp2;
@property (strong, nonatomic) IBOutlet UILabel *lbl_temp3;
@property (strong, nonatomic) IBOutlet UILabel *lbl_temp4;
@property (strong, nonatomic) IBOutlet UILabel *lbl_temp5;
@property (strong, nonatomic) IBOutlet UILabel *lbl_temp6;
@property (strong, nonatomic) IBOutlet UILabel *lbl_temp7;
@property (strong, nonatomic) IBOutlet UILabel *lbl_temp8;
@property (strong, nonatomic) IBOutlet UILabel *lbl_maxtemp1;
@property (strong, nonatomic) IBOutlet UILabel *lbl_maxtemp2;
@property (strong, nonatomic) IBOutlet UILabel *lbl_maxtemp3;
@property (strong, nonatomic) IBOutlet UILabel *lbl_maxtemp4;
@property (strong, nonatomic) IBOutlet UILabel *lbl_maxtemp5;
@property (strong, nonatomic) IBOutlet UILabel *lbl_maxtemp6;
@property (strong, nonatomic) IBOutlet UILabel *lbl_maxtemp7;
@property (strong, nonatomic) IBOutlet UILabel *lbl_maxtemp8;
@property (strong, nonatomic) IBOutlet UIImageView *img_weather1;
@property (strong, nonatomic) IBOutlet UIImageView *img_weather2;
@property (strong, nonatomic) IBOutlet UIImageView *img_weather3;
@property (strong, nonatomic) IBOutlet UIImageView *img_weather4;
@property (strong, nonatomic) IBOutlet UIImageView *img_weather5;
@property (strong, nonatomic) IBOutlet UIImageView *img_weather6;
@property (strong, nonatomic) IBOutlet UIImageView *img_weather7;
@property (strong, nonatomic) IBOutlet UIImageView *img_weather8;
@property (nonatomic,strong) IBOutlet UIView *view_Weather1;
@property (nonatomic,strong) IBOutlet UIView *view_Weather2;
@property (nonatomic,strong) IBOutlet UIView *view_Weather3;
@property (nonatomic,strong) IBOutlet UIView *view_Weather4;
@property (nonatomic,strong) IBOutlet UIView *view_Weather5;
@property (nonatomic,strong) IBOutlet UIView *view_Weather6;
@property (nonatomic,strong) IBOutlet UIView *view_Weather7;
@property (nonatomic,strong) IBOutlet UIView *view_Weather8;
@property (nonatomic,strong) IBOutlet UIView *view_changeWeather;
@property (strong, nonatomic) IBOutlet UILabel *lbl_dayWeather1;
@property (strong, nonatomic) IBOutlet UILabel *lbl_dayWeather2;
@property (strong, nonatomic) IBOutlet UILabel *lbl_dayWeather3;
@property (strong, nonatomic) IBOutlet UILabel *lbl_dayWeather4;
@property (strong, nonatomic) IBOutlet UILabel *lbl_dayWeather5;
@property (strong, nonatomic) IBOutlet UILabel *lbl_dayWeather6;
@property (strong, nonatomic) IBOutlet UILabel *lbl_dayWeather7;
@property (strong, nonatomic) IBOutlet UILabel *lbl_dayWeather8;

@property (weak, nonatomic) IBOutlet UILabel *lbl_NetworkName_weather;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Date_weather;
@property (weak, nonatomic) IBOutlet UILabel *lbl_latlong_weather;
@property (weak, nonatomic) IBOutlet UIImageView *img_WeatherCondition;
@property (weak, nonatomic) IBOutlet UILabel *lbl_maxTempBig_weather;
@property (weak, nonatomic) IBOutlet UILabel *lbl_minTempBig_weather;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Summery_weather;
@property(nonatomic,retain) IBOutlet UILabel *lbl_Weather_WindCount;

@property (strong, nonatomic) IBOutlet UIView *ViewSprinklerDevice;
@property (strong, nonatomic) IBOutlet UILabel *lbl_vacationMode;

@property (strong, nonatomic) IBOutlet UIButton *btn_back_networkHome;
@property (strong, nonatomic) IBOutlet UIButton *btn_networkHome_logo;
@property (strong, nonatomic) IBOutlet UIButton *btn_settings;
@property (nonatomic,strong) IBOutlet UIButton *btn_Vacation;
@property (nonatomic,strong) IBOutlet UIButton *btn_AddSchedule;
@property (nonatomic,strong) IBOutlet UIButton *btn_Info;

@property (strong,nonatomic) NSString *str_Pop_Type;
@property (nonatomic,retain) NSString *str_CheckAction;

@property (strong, nonatomic) IBOutlet UIView *viewLightNetworkHome;
@property (strong, nonatomic) IBOutlet UIView *viewOthersNetworkHome;
@property (strong, nonatomic) IBOutlet UIView *viewSprinklerNetworkHome;
@property (strong, nonatomic) IBOutlet UITableView *tableView_Alerts;
@property (strong, nonatomic) NSMutableArray *arrAlerts_MSG;
@property (strong, nonatomic) NSString *strCheckTimeLine;

@property (strong, nonatomic) IBOutlet UIImageView *imgScheduleSprinkler;
@property (strong, nonatomic) IBOutlet UILabel *lbl_addSchedule;

@property (strong, nonatomic) IBOutlet UIView *view_alertMsgExpand;
@property (strong, nonatomic) IBOutlet UILabel *lbl_networkName;
@property(nonatomic,retain) IBOutlet UIImageView *imgView_Header_Property;

@property (strong, nonatomic) IBOutlet UIButton *btn_currentWeather;
@property (strong, nonatomic) IBOutlet UILabel *lbl_maxTemp_Weather;
@property (strong, nonatomic) IBOutlet UILabel *lbl_minTemp_Weather;
@property (strong, nonatomic) IBOutlet UIButton *btn_Alert_Count;
@property (strong, nonatomic) IBOutlet UIButton *btn_Message_Count;

@property (strong, nonatomic) IBOutlet UILabel *lblDeviceType;
@property (strong, nonatomic) IBOutlet UIImageView *imgDeviceType;
@property (strong, nonatomic) IBOutlet UIView *view_manualOffAlert;
@property (strong, nonatomic) IBOutlet UIButton *btn_Weather_WindImg;

@property (strong, nonatomic) IBOutlet MKMapView *mapViewProperty;
@property (nonatomic,strong) MKAnnotationView *selectedAnnotationView;

@property (strong, nonatomic) IBOutlet UIButton *deleteProfilebtn;
@property (strong, nonatomic) IBOutlet UIButton *cameraProfilebtn;
@property (strong, nonatomic) IBOutlet UIButton *gallaryProfilebtn;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Ozone;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Pressure;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Humidity;
@property (strong, nonatomic) IBOutlet UILabel *lbl_weather_subSunsetTime;
@property (strong, nonatomic) IBOutlet UIButton *btn_Weather_SunRiseImg;

@property (strong, nonatomic) IBOutlet UIView *viewAlert_AddDevice;
@property (strong, nonatomic) IBOutlet UIButton *btnPropertyMap;

@property (nonatomic,strong) MKAnnotationView *parentAnnotationView;
@property (strong, nonatomic) UIButton *btn_PropertyMap_Location;
@property (strong, nonatomic) IBOutlet UIView *view_Sprinkler_manualOffAlert;
@property (strong, nonatomic) IBOutlet UIView *view_manualOnAlert;

-(IBAction)alert_Action:(id)sender;
-(IBAction)hideView_Action:(id)sender;
-(IBAction)weather_Action:(id)sender;
-(IBAction)PropertyMap_Action:(id)sender;
-(IBAction)settings_Action:(id)sender;
-(IBAction)device_View_Action:(id)sender;
-(IBAction)add_Schedule_Action:(id)sender;
-(IBAction)addDevice_lights_Other_Action:(id)sender;
-(IBAction)addDevice_Sprinkler_Action:(id)sender;
-(IBAction)refreshWeatherMap_Action:(id)sender;
-(IBAction)manualOff_Action:(id)sender;
-(IBAction)change_delete_Deviceimg_Action_Network_Home:(id)sender;
-(IBAction)Back_TO_Home_Action:(id)sender;
-(IBAction)addDevice_propertyMap_Action:(id)sender;
-(IBAction)sprinkler_ManualOn_Action:(id)sender;
-(IBAction)sprinkler_ManualOff_Action:(id)sender;
@end
