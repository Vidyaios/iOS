//
//  TimeLineViewController.m
//  NOID
//
//  Created by Karthik on 9/1/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "TimeLineViewController.h"
#import "Common.h"
#import "SWRevealViewController.h"
#import "MultipleNetworkViewController.h"
#import "NetworkHomeViewController.h"
#define kButtonIndex 1000

@interface TimeLineViewController ()
{
    UIButton *viewDevice[kButtonIndex];
    UIButton *viewDeviceOthers[kButtonIndex];
    UIButton *viewDeviceSprinklers[kButtonIndex];
    UIButton *viewTimeLine_Header[kButtonIndex];
    UIImageView *imgViewDot[kButtonIndex];
    UIImageView *imgViewDotOthers[kButtonIndex];
    UIImageView *imgViewDotSprinklers[kButtonIndex];
    UIButton *btnCell_Device;
}

@end

@implementation TimeLineViewController
@synthesize TimelineAlert,view_HeaderViewTimeLine,view_BodyViewTimeLine,view_SprinklerTimeLineBar,view_LightsTimeLineBar,
view_OthersTimeLineBar,view_DetailViewTimeLine,view_Profile_Header,btn_PreviousInTimeLine,btn_NextInTimeLine,btn_PreviousInDetailTimeLine,btn_NextInDetailTimeLine,
swtchLight,btnLogo_TimeLine,btnBackarrow_TImeline,btnBack_TimeLine,img_detailView,lbl_deviceName,delegate,imgView_MatrixBar1,imgView_MatrixBar10,imgView_MatrixBar11,imgView_MatrixBar12,imgView_MatrixBar2,imgView_MatrixBar3,imgView_MatrixBar4,imgView_MatrixBar5,imgView_MatrixBar6,imgView_MatrixBar7,imgView_MatrixBar8,imgView_MatrixBar9,lbl_ScheduleName,lblTimes,strNoidLogo_Status;

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.strTimeLineStatus=@"YES";
    appDelegate.strLaunchOrientation=@"";
    [self timerTickTimeLine];
    timerTL = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(timerTickTimeLine) userInfo:nil repeats:YES];
    [self start_PinWheel_TimeLine];
    [self initialSetupInTimeLine];
    [self loadTimeLine];
    [TimelineAlert setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [timerTL invalidate];
}

- (void)timerTickTimeLine{
    NSDate *now = [NSDate date];
    NSLog(@"time called");
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm a";  // very simple format  "8:47:22 AM"
    }
    self.lblTimes.text = [dateFormatter stringFromDate:now];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableArray *viewStackArr=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSLog(@"Stack count %lu",(unsigned long)[viewStackArr count]);
    NSLog(@"stack List == %@",viewStackArr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Defined Methods
-(void)loadTimeLine
{
    arrTimeLineHeaders = [[NSMutableArray alloc] init];
    arrTimeLineHeaders = [[NSMutableArray alloc] initWithObjects:@"SSt",@"SMid",@"SEnd",@"LSt",@"LMid",@"LEnd", @"OSt",@"OMid",@"OEnd", nil];
    
    
    arrLights = [[NSMutableArray alloc] init];
    arrOthers = [[NSMutableArray alloc] init];
    arrSprinkler = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"light" forKey:@"DeviceType"];
    [dict setObject:@"05:30:10" forKey:@"Time"];
    [dict setObject:@"Morning Light" forKey:@"Name"];
    [dict setObject:@"Morning Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardLight" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"100" forKey:@"Id"];
    [arrLights addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"light" forKey:@"DeviceType"];
    [dict setObject:@"02:12:10" forKey:@"Time"];
    [dict setObject:@"Noon Light" forKey:@"Name"];
    [dict setObject:@"Evening Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"PropertyMapbg_image" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"101" forKey:@"Id"];
    [arrLights addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"light" forKey:@"DeviceType"];
    [dict setObject:@"08:00:00" forKey:@"Time"];
    [dict setObject:@"Kitchen Light" forKey:@"Name"];
    [dict setObject:@"Afternoon Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardLight" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"102" forKey:@"Id"];
    [arrLights addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"light" forKey:@"DeviceType"];
    [dict setObject:@"08:00:00" forKey:@"Time"];
    [dict setObject:@"Toilet Light" forKey:@"Name"];
    [dict setObject:@"Midnight Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"PropertyMapbg_image" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"103" forKey:@"Id"];
    [arrLights addObject:dict];
    
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"light" forKey:@"DeviceType"];
    [dict setObject:@"17:12:59" forKey:@"Time"];
    [dict setObject:@"Wall Light" forKey:@"Name"];
    [dict setObject:@"Evening Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardLight" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"104" forKey:@"Id"];
    [arrLights addObject:dict];
    
    
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"sprinkler" forKey:@"DeviceType"];
    [dict setObject:@"00:00:00" forKey:@"Time"];
    [dict setObject:@"Morning Sprinkler" forKey:@"Name"];
    [dict setObject:@"Morning Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardSprinkler" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"113" forKey:@"Id"];
    [arrSprinkler addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"sprinkler" forKey:@"DeviceType"];
    [dict setObject:@"01:18:00" forKey:@"Time"];
    [dict setObject:@"Kitchen Sprinkler" forKey:@"Name"];
    [dict setObject:@"Afternoon Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"PropertyMapbg_image" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"114" forKey:@"Id"];
    [arrSprinkler addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"sprinkler" forKey:@"DeviceType"];
    [dict setObject:@"14:30:00" forKey:@"Time"];
    [dict setObject:@"Mokka Sprinkler" forKey:@"Name"];
    [dict setObject:@"Evening Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"PropertyMapbg_image" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"120" forKey:@"Id"];
    [arrSprinkler addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"sprinkler" forKey:@"DeviceType"];
    [dict setObject:@"18:15:00" forKey:@"Time"];
    [dict setObject:@"MIME Sprinkler" forKey:@"Name"];
    [dict setObject:@"Afternoon Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardSprinkler" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"121" forKey:@"Id"];
    [arrSprinkler addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"sprinkler" forKey:@"DeviceType"];
    [dict setObject:@"21:12:00" forKey:@"Time"];
    [dict setObject:@"Toilet Sprinkler" forKey:@"Name"];
    [dict setObject:@"Midnight Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"PropertyMapbg_image" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"122" forKey:@"Id"];
    [arrSprinkler addObject:dict];
    
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"01:00:00" forKey:@"Time"];
    [dict setObject:@"Morning Other" forKey:@"Name"];
    [dict setObject:@"Midnight Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"126" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"01:20:00" forKey:@"Time"];
    [dict setObject:@"Noon Other" forKey:@"Name"];
    [dict setObject:@"Morning Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"127" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"08:10:00" forKey:@"Time"];
    [dict setObject:@"Kitehck Other" forKey:@"Name"];
    [dict setObject:@"Evening Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"128" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"08:10:00" forKey:@"Time"];
    [dict setObject:@"Wall Other" forKey:@"Name"];
    [dict setObject:@"Afternoon Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"129" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"08:10:00" forKey:@"Time"];
    [dict setObject:@"Thilak Other" forKey:@"Name"];
    [dict setObject:@"Midnight Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"130" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"light" forKey:@"DeviceType"];
    [dict setObject:@"02:12:10" forKey:@"Time"];
    [dict setObject:@"Mount Light" forKey:@"Name"];
    [dict setObject:@"Morning Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"PropertyMapbg_image" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"105" forKey:@"Id"];
    [arrLights addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"light" forKey:@"DeviceType"];
    [dict setObject:@"20:00:00" forKey:@"Time"];
    [dict setObject:@"Ice Light" forKey:@"Name"];
    [dict setObject:@"Morning Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardLight" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"106" forKey:@"Id"];
    [arrLights addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"light" forKey:@"DeviceType"];
    [dict setObject:@"15:00:00" forKey:@"Time"];
    [dict setObject:@"Water Light" forKey:@"Name"];
    [dict setObject:@"Evening Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"PropertyMapbg_image" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"107" forKey:@"Id"];
    [arrLights addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"light" forKey:@"DeviceType"];
    [dict setObject:@"18:00:00" forKey:@"Time"];
    [dict setObject:@"Gravy Light" forKey:@"Name"];
    [dict setObject:@"Afternoon Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardLight" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"108" forKey:@"Id"];
    [arrLights addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"light" forKey:@"DeviceType"];
    [dict setObject:@"20:00:00" forKey:@"Time"];
    [dict setObject:@"Bedroom Light" forKey:@"Name"];
    [dict setObject:@"Midnight Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardLight" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"109" forKey:@"Id"];
    [arrLights addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"light" forKey:@"DeviceType"];
    [dict setObject:@"23:00:00" forKey:@"Time"];
    [dict setObject:@"Hall Light" forKey:@"Name"];
    [dict setObject:@"Midnight Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardLight" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"110" forKey:@"Id"];
    [arrLights addObject:dict];
    
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"light" forKey:@"DeviceType"];
    [dict setObject:@"20:00:00" forKey:@"Time"];
    [dict setObject:@"Cake Light" forKey:@"Name"];
    [dict setObject:@"Evening Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardLight" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"111" forKey:@"Id"];
    [arrLights addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"light" forKey:@"DeviceType"];
    [dict setObject:@"23:59:59" forKey:@"Time"];
    [dict setObject:@"Vviel Light" forKey:@"Name"];
    [dict setObject:@"Afternoon Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"PropertyMapbg_image" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"112" forKey:@"Id"];
    [arrLights addObject:dict];
    
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"sprinkler" forKey:@"DeviceType"];
    [dict setObject:@"00:00:00" forKey:@"Time"];
    [dict setObject:@"Morning Sprinkler" forKey:@"Name"];
    [dict setObject:@"Morning Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardSprinkler" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"113" forKey:@"Id"];
    [arrSprinkler addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"sprinkler" forKey:@"DeviceType"];
    [dict setObject:@"01:18:00" forKey:@"Time"];
    [dict setObject:@"Kitchen Sprinkler" forKey:@"Name"];
    [dict setObject:@"Afternoon Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"PropertyMapbg_image" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"114" forKey:@"Id"];
    [arrSprinkler addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"sprinkler" forKey:@"DeviceType"];
    [dict setObject:@"14:30:00" forKey:@"Time"];
    [dict setObject:@"Mokka Sprinkler" forKey:@"Name"];
    [dict setObject:@"Evening Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"PropertyMapbg_image" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"120" forKey:@"Id"];
    [arrSprinkler addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"sprinkler" forKey:@"DeviceType"];
    [dict setObject:@"18:15:00" forKey:@"Time"];
    [dict setObject:@"MIME Sprinkler" forKey:@"Name"];
    [dict setObject:@"Afternoon Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardSprinkler" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"121" forKey:@"Id"];
    [arrSprinkler addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"sprinkler" forKey:@"DeviceType"];
    [dict setObject:@"21:12:00" forKey:@"Time"];
    [dict setObject:@"Toilet Sprinkler" forKey:@"Name"];
    [dict setObject:@"Midnight Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"PropertyMapbg_image" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"122" forKey:@"Id"];
    [arrSprinkler addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"sprinkler" forKey:@"DeviceType"];
    [dict setObject:@"19:30:00" forKey:@"Time"];
    [dict setObject:@"Morning Hot Sprinler" forKey:@"Name"];
    [dict setObject:@"Midnight Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardSprinkler" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"123" forKey:@"Id"];
    [arrSprinkler addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"sprinkler" forKey:@"DeviceType"];
    [dict setObject:@"15:45:00" forKey:@"Time"];
    [dict setObject:@"WOW Sprinkler" forKey:@"Name"];
    [dict setObject:@"Midnight Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"PropertyMapbg_image" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"124" forKey:@"Id"];
    [arrSprinkler addObject:dict];
    
    
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"sprinkler" forKey:@"DeviceType"];
    [dict setObject:@"13:42:00" forKey:@"Time"];
    [dict setObject:@"Lunch Sprinkler" forKey:@"Name"];
    [dict setObject:@"Evening Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardSprinkler" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"125" forKey:@"Id"];
    [arrSprinkler addObject:dict];
    
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"01:00:00" forKey:@"Time"];
    [dict setObject:@"Morning Other" forKey:@"Name"];
    [dict setObject:@"Midnight Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"126" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"01:20:00" forKey:@"Time"];
    [dict setObject:@"Noon Other" forKey:@"Name"];
    [dict setObject:@"Morning Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"127" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"08:10:00" forKey:@"Time"];
    [dict setObject:@"Kitehck Other" forKey:@"Name"];
    [dict setObject:@"Evening Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"128" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"08:10:00" forKey:@"Time"];
    [dict setObject:@"Wall Other" forKey:@"Name"];
    [dict setObject:@"Afternoon Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"129" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"08:10:00" forKey:@"Time"];
    [dict setObject:@"Thilak Other" forKey:@"Name"];
    [dict setObject:@"Midnight Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"130" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"11:22:00" forKey:@"Time"];
    [dict setObject:@"Bedrrom Other" forKey:@"Name"];
    [dict setObject:@"Morning Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"131" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"08:10:00" forKey:@"Time"];
    [dict setObject:@"Road Other" forKey:@"Name"];
    [dict setObject:@"Midnight Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"132" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"08:10:00" forKey:@"Time"];
    [dict setObject:@"Door Other" forKey:@"Name"];
    [dict setObject:@"Morning Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"133" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    //
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"16:10:00" forKey:@"Time"];
    [dict setObject:@"Hallas Other" forKey:@"Name"];
    [dict setObject:@"Evening Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"134" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"21:22:00" forKey:@"Time"];
    [dict setObject:@"Bichu Other" forKey:@"Name"];
    [dict setObject:@"Afternoon Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"135" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"08:10:00" forKey:@"Time"];
    [dict setObject:@"Water Other" forKey:@"Name"];
    [dict setObject:@"Midnight Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"136" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"08:10:00" forKey:@"Time"];
    [dict setObject:@"BBC Other" forKey:@"Name"];
    [dict setObject:@"Midnight Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"137" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"08:10:00" forKey:@"Time"];
    [dict setObject:@"Tusk Other" forKey:@"Name"];
    [dict setObject:@"Morning Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"138" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"other" forKey:@"DeviceType"];
    [dict setObject:@"21:22:00" forKey:@"Time"];
    [dict setObject:@"Back Lamb Other" forKey:@"Name"];
    [dict setObject:@"Dark Night Schedule" forKey:@"ScheduleName"];
    [dict setObject:@"dcardOther" forKey:@"Image"];
    [dict setObject:@"OFF" forKey:@"Status"];
    [dict setObject:@"139" forKey:@"Id"];
    [arrOthers addObject:dict];
    
    
    
    
    //Light Suffle
    NSUInteger count = [arrLights count];
    
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [arrLights exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    NSLog(@"arrT=%@",arrLights);
    
    //Other Suffle
    NSUInteger countOther = [arrOthers count];
    
    for (NSUInteger i = 0; i < countOther; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = countOther - i;
        NSInteger n = (arc4random() % nElements) + i;
        [arrOthers exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    NSLog(@"arrT=%@",arrOthers);
    
    
    //Sprinkler Suffle
    NSUInteger countSprinkler = [arrSprinkler count];
    
    for (NSUInteger i = 0; i < countSprinkler; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = countSprinkler - i;
        NSInteger n = (arc4random() % nElements) + i;
        [arrSprinkler exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    NSLog(@"arrT=%@",arrSprinkler);
    
    [self stop_PinWheel_TimeLine];
    [self performSelector:@selector(initialAnimationSetup) withObject:nil afterDelay:1.0];
}

-(void)initialAnimationSetup{
    
    if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
        [UIView animateWithDuration:.8 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            view_SprinklerTimeLineBar.frame  = CGRectMake(55,view_SprinklerTimeLineBar.frame.origin.y,view_SprinklerTimeLineBar.frame.size.width,view_SprinklerTimeLineBar.frame.size.height);
            view_OthersTimeLineBar.frame  = CGRectMake(55,view_OthersTimeLineBar.frame.origin.y,view_OthersTimeLineBar.frame.size.width,view_OthersTimeLineBar.frame.size.height);
            view_LightsTimeLineBar.frame  = CGRectMake(55,view_LightsTimeLineBar.frame.origin.y,view_LightsTimeLineBar.frame.size.width,view_LightsTimeLineBar.frame.size.height);
        }completion:^(BOOL finished) {
            [self parse_AllDeviceTimeLine_Methods];
        }];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
        [UIView animateWithDuration:.8 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            view_SprinklerTimeLineBar.frame  = CGRectMake(64,view_SprinklerTimeLineBar.frame.origin.y,view_SprinklerTimeLineBar.frame.size.width,view_SprinklerTimeLineBar.frame.size.height);
            view_OthersTimeLineBar.frame  = CGRectMake(64,view_OthersTimeLineBar.frame.origin.y,view_OthersTimeLineBar.frame.size.width,view_OthersTimeLineBar.frame.size.height);
            view_LightsTimeLineBar.frame  = CGRectMake(64,view_LightsTimeLineBar.frame.origin.y,view_LightsTimeLineBar.frame.size.width,view_LightsTimeLineBar.frame.size.height);
        }completion:^(BOOL finished) {
            [self parse_AllDeviceTimeLine_Methods];
        }];
    }
    else{
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            view_SprinklerTimeLineBar.frame  = CGRectMake(72,view_SprinklerTimeLineBar.frame.origin.y,view_SprinklerTimeLineBar.frame.size.width,view_SprinklerTimeLineBar.frame.size.height);
            view_OthersTimeLineBar.frame  = CGRectMake(72,view_OthersTimeLineBar.frame.origin.y,view_OthersTimeLineBar.frame.size.width,view_OthersTimeLineBar.frame.size.height);
            view_LightsTimeLineBar.frame  = CGRectMake(72,view_LightsTimeLineBar.frame.origin.y,view_LightsTimeLineBar.frame.size.width,view_LightsTimeLineBar.frame.size.height);
        }completion:^(BOOL finished) {
            [self parse_AllDeviceTimeLine_Methods];
        }];
    }
}

-(void)parse_AllDeviceTimeLine_Methods
{
    [self parseMatrixLine];
    [self parseDevicesHeader];
    [self parseDevices];
    [self parseDevicesSprinklers];
    [self parseDevicesOthers];
    [self shuffleHeader];
    [self performSelector:@selector(shuffleDevice) withObject:nil afterDelay:1.0];
    [self performSelector:@selector(shuffleDeviceSprinklers) withObject:nil afterDelay:1.2];
    [self performSelector:@selector(shuffleDeviceOthers) withObject:nil afterDelay:1.4];
}

-(void)initialSetupInTimeLine{
    strStatusCheck=@"";
    preTag=0;
    CurrentTag=0;
    preTagOther=0;
    currentTagOther=0;
    preTagSprinkler=0;
    currentTagSprinkler=0;
    [view_DetailViewTimeLine setHidden:YES];
    [btn_PreviousInTimeLine setHidden:YES];
    [btn_PreviousInDetailTimeLine setHidden:YES];
    [btn_NextInTimeLine setHidden:YES];
    [btn_NextInDetailTimeLine setHidden:YES];
    
    [swtchLight setOn:YES animated:NO];
    [swtchLight setThumbTintColor:lblRGBA(255, 206, 52, 1)];
    swtchLight.backgroundColor=lblRGBA(255, 255,255,1);
    swtchLight.tintColor=lblRGBA(255, 255, 255, 1);
    swtchLight.layer.masksToBounds=YES;
    swtchLight.layer.cornerRadius=16.0;
    
    lightsPopUpViewStatus=YES;
    otherPopUpViewStatus=YES;
    sprinklerPopUpViewStatus=YES;
    
    imgView_MatrixBar1.hidden=YES;
    imgView_MatrixBar2.hidden=YES;
    imgView_MatrixBar3.hidden=YES;
    imgView_MatrixBar4.hidden=YES;
    imgView_MatrixBar5.hidden=YES;
    imgView_MatrixBar6.hidden=YES;
    imgView_MatrixBar7.hidden=YES;
    imgView_MatrixBar8.hidden=YES;
    imgView_MatrixBar9.hidden=YES;
    imgView_MatrixBar10.hidden=YES;
    imgView_MatrixBar11.hidden=YES;
    imgView_MatrixBar12.hidden=YES;
}

-(void)shuffleDots
{
    
    for(int index=0;index<[arrLights count];index++)
    {
        [self parseScheduleDots:index];
    }
}

-(void)shuffleDotsOthers
{
    for(int index=0;index<[arrOthers count];index++)
    {
        [self parseScheduleDotsOthers:index];
    }
}
-(void)shuffleDotsSprinklers
{
    for(int index=0;index<[arrSprinkler count];index++)
    {
        [self parseScheduleDotsSprinklers:index];
    }
}

-(void)parseScheduleDots:(int)index
{
    int dotCount=1;
    for(int jx=0;jx<[arrLights count];jx++)
    {
        NSLog(@"index time == %@",[[arrLights objectAtIndex:index] valueForKey:@"Time"]);
        NSLog(@"looping index time == %@",[[arrLights objectAtIndex:jx] valueForKey:@"Time"]);
        if([arrLights objectAtIndex:index]!=[arrLights objectAtIndex:jx])
        {
            if([[[arrLights objectAtIndex:index] valueForKey:@"Time"] isEqualToString:[[arrLights objectAtIndex:jx] valueForKey:@"Time"]])
            {
                dotCount=dotCount+1;
            }
        }
    }
    if(dotCount>1)
    {
        float ycord=viewDevice[index].frame.size.height+viewDevice[index].frame.origin.y+2;
        float xcord;
        if(dotCount==2)
        {
            xcord=viewDevice[index].frame.origin.x+viewDevice[index].frame.size.width/2+2;
        }else{
            xcord=viewDevice[index].frame.origin.x+viewDevice[index].frame.size.width/2-8;
        }
        
        for(int count=0;count<dotCount;count++)
        {
            if(count==0)
            {
                imgViewDot[count]=[[UIImageView alloc] init];
                imgViewDot[count].frame=CGRectMake(xcord, ycord, 4, 4);
                ycord=imgViewDot[count].frame.origin.y;
                xcord=imgViewDot[count].frame.origin.x+imgViewDot[count].frame.size.width+2;
            }
            imgViewDot[count]=[[UIImageView alloc] init];
            if(count%3!=0)
            {
                imgViewDot[count].frame=CGRectMake(xcord, ycord, 4, 4);
                ycord=imgViewDot[count-1].frame.origin.y;
                xcord=xcord+imgViewDot[count-1].frame.size.width+2;
            }else{
                imgViewDot[count].frame=CGRectMake(viewDevice[index].frame.origin.x+viewDevice[index].frame.size.width/2-8,ycord+imgViewDot[count-1].frame.size.height+2,4,4);
                xcord = imgViewDot[count].frame.origin.x+imgViewDot[count].frame.size.width+2;
                ycord = imgViewDot[count].frame.origin.y;
            }
            imgViewDot[count].image=[UIImage imageNamed:@"dotLight"];
            [self.view_BodyViewTimeLine addSubview:imgViewDot[count]];
            [self.view bringSubviewToFront:imgViewDot[count]];
        }
    }
}

-(void)parseScheduleDotsOthers:(int)index
{
    int dotCount=1;
    for(int jx=0;jx<[arrOthers count];jx++)
    {
        NSLog(@"index time == %@",[[arrOthers objectAtIndex:index] valueForKey:@"Time"]);
        NSLog(@"looping index time == %@",[[arrOthers objectAtIndex:jx] valueForKey:@"Time"]);
        if([arrOthers objectAtIndex:index]!=[arrOthers objectAtIndex:jx])
        {
            if([[[arrOthers objectAtIndex:index] valueForKey:@"Time"] isEqualToString:[[arrOthers objectAtIndex:jx] valueForKey:@"Time"]])
            {
                dotCount=dotCount+1;
            }
        }
    }
    if(dotCount>1)
    {
        float ycord=viewDeviceOthers[index].frame.size.height+viewDeviceOthers[index].frame.origin.y+2;
        float xcord;
        if(dotCount==2)
        {
            xcord=viewDeviceOthers[index].frame.origin.x+viewDeviceOthers[index].frame.size.width/2+2;
        }else{
            xcord=viewDeviceOthers[index].frame.origin.x+viewDeviceOthers[index].frame.size.width/2-8;
        }
        
        for(int count=0;count<dotCount;count++)
        {
            if(count==0)
            {
                imgViewDotOthers[count]=[[UIImageView alloc] init];
                imgViewDotOthers[count].frame=CGRectMake(xcord, ycord, 4, 4);
                ycord=imgViewDotOthers[count].frame.origin.y;
                xcord=imgViewDotOthers[count].frame.origin.x+imgViewDotOthers[count].frame.size.width+2;
            }
            imgViewDotOthers[count]=[[UIImageView alloc] init];
            if(count%3!=0)
            {
                imgViewDotOthers[count].frame=CGRectMake(xcord, ycord, 4, 4);
                ycord=imgViewDotOthers[count-1].frame.origin.y;
                xcord=xcord+imgViewDotOthers[count-1].frame.size.width+2;
            }else{
                imgViewDotOthers[count].frame=CGRectMake(viewDeviceOthers[index].frame.origin.x+viewDeviceOthers[index].frame.size.width/2-8,ycord+imgViewDotOthers[count-1].frame.size.height+2,4,4);
                xcord = imgViewDotOthers[count].frame.origin.x+imgViewDotOthers[count].frame.size.width+2;
                ycord = imgViewDotOthers[count].frame.origin.y;
            }
            imgViewDotOthers[count].image=[UIImage imageNamed:@"dotOther"];
            [self.view_BodyViewTimeLine addSubview:imgViewDotOthers[count]];
            [self.view bringSubviewToFront:imgViewDotOthers[count]];
        }
    }
}

-(void)parseScheduleDotsSprinklers:(int)index
{
    int dotCount=1;
    for(int jx=0;jx<[arrSprinkler count];jx++)
    {
        NSLog(@"index time == %@",[[arrSprinkler objectAtIndex:index] valueForKey:@"Time"]);
        NSLog(@"looping index time == %@",[[arrSprinkler objectAtIndex:jx] valueForKey:@"Time"]);
        if([arrSprinkler objectAtIndex:index]!=[arrSprinkler objectAtIndex:jx])
        {
            if([[[arrSprinkler objectAtIndex:index] valueForKey:@"Time"] isEqualToString:[[arrSprinkler objectAtIndex:jx] valueForKey:@"Time"]])
            {
                dotCount=dotCount+1;
            }
        }
    }
    if(dotCount>1)
    {
        float ycord=viewDeviceSprinklers[index].frame.size.height+viewDeviceSprinklers[index].frame.origin.y+2;
        float xcord;
        if(dotCount==2)
        {
            xcord=viewDeviceSprinklers[index].frame.origin.x+viewDeviceSprinklers[index].frame.size.width/2+2;
        }else{
            xcord=viewDeviceSprinklers[index].frame.origin.x+viewDeviceSprinklers[index].frame.size.width/2-8;
        }
        
        for(int count=0;count<dotCount;count++)
        {
            if(count==0)
            {
                imgViewDotSprinklers[count]=[[UIImageView alloc] init];
                imgViewDotSprinklers[count].frame=CGRectMake(xcord, ycord, 4, 4);
                ycord=imgViewDotSprinklers[count].frame.origin.y;
                xcord=imgViewDotSprinklers[count].frame.origin.x+imgViewDotSprinklers[count].frame.size.width+2;
            }
            imgViewDotSprinklers[count]=[[UIImageView alloc] init];
            if(count%3!=0)
            {
                imgViewDotSprinklers[count].frame=CGRectMake(xcord, ycord, 4, 4);
                ycord=imgViewDotSprinklers[count-1].frame.origin.y;
                xcord=xcord+imgViewDotSprinklers[count-1].frame.size.width+2;
            }else{
                imgViewDotSprinklers[count].frame=CGRectMake(viewDeviceSprinklers[index].frame.origin.x+viewDeviceSprinklers[index].frame.size.width/2-8,ycord+imgViewDotSprinklers[count-1].frame.size.height+2,4,4);
                xcord = imgViewDotSprinklers[count].frame.origin.x+imgViewDotSprinklers[count].frame.size.width+2;
                ycord = imgViewDotSprinklers[count].frame.origin.y;
            }
            imgViewDotSprinklers[count].image=[UIImage imageNamed:@"dotSprinkler"];
            [self.view_BodyViewTimeLine addSubview:imgViewDotSprinklers[count]];
            [self.view bringSubviewToFront:imgViewDotSprinklers[count]];
        }
    }
}

-(void)shuffleDevice
{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        NSLog(@"count =%lu",(unsigned long)arrLights.count);
        for(int index=0;index<[arrLights count];index++)
        {
            if(index/2==1)
            {
                if(index%2==0)
                {
                    [self delayMethodForDeviceIcon:0.7 andIndex:index];
                }else{
                    [self delayMethodForDeviceIcon:0.5 andIndex:index];
                }
                
            }else{
                if(index/2==1)
                {
                    [self delayMethodForDeviceIcon:0.6 andIndex:index];
                }
                else
                {
                    if(index%2==0)
                    {
                        [self delayMethodForDeviceIcon:0.8 andIndex:index];
                    }else{
                        [self delayMethodForDeviceIcon:1.1 andIndex:index];
                    }
                }
                
            }
        }
    } completion:^(BOOL finished) {
        [self performSelector:@selector(shuffleDots) withObject:nil afterDelay:0.9];
    }];
}

-(void)shuffleDeviceOthers
{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        NSLog(@"count =%lu",(unsigned long)arrOthers.count);
        for(int index=0;index<[arrOthers count];index++)
        {
            if(index/2==1)
            {
                if(index%2==0)
                {
                    [self delayMethodForDeviceIconOthers:1.1 andIndex:index];
                }else{
                    [self delayMethodForDeviceIconOthers:0.9 andIndex:index];
                }
            }else{
                if(index/2==1)
                {
                    [self delayMethodForDeviceIconOthers:1.0 andIndex:index];
                }
                else
                {
                    if(index%2==0)
                    {
                        [self delayMethodForDeviceIconOthers:1.2 andIndex:index];
                    }else{
                        [self delayMethodForDeviceIconOthers:1.5 andIndex:index];
                    }
                }
            }
        }
    } completion:^(BOOL finished) {
        [self performSelector:@selector(shuffleDotsOthers) withObject:nil afterDelay:1.4];
    }];
}

-(void)shuffleDeviceSprinklers
{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        NSLog(@"count =%lu",(unsigned long)arrSprinkler.count);
        for(int index=0;index<[arrSprinkler count];index++)
        {
            if(index/2==1)
            {
                if(index%2==0)
                {
                    [self delayMethodForDeviceIconSprinklers:0.9 andIndex:index];
                }else{
                    [self delayMethodForDeviceIconSprinklers:0.7 andIndex:index];
                }
            }else{
                if(index/2==1)
                {
                    [self delayMethodForDeviceIconSprinklers:0.8 andIndex:index];
                }
                else
                {
                    if(index%2==0)
                    {
                        [self delayMethodForDeviceIconSprinklers:1.0 andIndex:index];
                    }else{
                        [self delayMethodForDeviceIconSprinklers:1.2 andIndex:index];
                    }
                }
            }
        }
    } completion:^(BOOL finished) {
        [self performSelector:@selector(shuffleDotsSprinklers) withObject:nil afterDelay:1.6];
    }];
}


-(void)delayMethodForDeviceIcon:(double)delayInSeconds andIndex:(int)index
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [Common viewFadeInTimeLine:viewDevice[index]];
        [viewDevice[index] setHidden:NO];
    });
}

-(void)delayMethodForDeviceIconOthers:(double)delayInSeconds andIndex:(int)index
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // unhide views, animate if desired
        // [self parseDevices:i];
        [Common viewFadeInTimeLine:viewDeviceOthers[index]];
        [viewDeviceOthers[index] setHidden:NO];
    });
}
-(void)delayMethodForDeviceIconSprinklers:(double)delayInSeconds andIndex:(int)index
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // unhide views, animate if desired
        // [self parseDevices:i];
        [Common viewFadeInTimeLine:viewDeviceSprinklers[index]];
        [viewDeviceSprinklers[index] setHidden:NO];
    });
}

-(void)shuffleHeader
{
    
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        NSUInteger count = [arrTimeLineHeaders count];
        NSLog(@"count =%lu",(unsigned long)arrTimeLineHeaders.count);
        for(int index=0;index<count;index++)
        {
            if(index/2==1)
            {
                if(index%2==0)
                {
                    [self delayMethodForHeader:0.5 andIndex:index];
                }else{
                    [self delayMethodForHeader:0.9 andIndex:index];
                }
            }else{
                if(index/2==1)
                {
                    [self delayMethodForHeader:0.7 andIndex:index];
                }
                else
                {
                    if(index%2==0)
                    {
                        [self delayMethodForHeader:0.6 andIndex:index];
                    }else{
                        [self delayMethodForHeader:0.8 andIndex:index];
                    }
                }
            }
        }
    } completion:^(BOOL finished) {
//        [self performSelector:@selector(shuffleDevice) withObject:nil afterDelay:1.0];
    }];
}

-(void)delayMethodForHeader:(double)delayInSeconds andIndex:(int)index
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // unhide views, animate if desired
        [Common viewFadeInTimeLine:viewTimeLine_Header[index]];
        [viewTimeLine_Header[index] setHidden:NO];
    });
}

-(void)parseMatrixLine
{
    CGFloat matrixLineWidth = self.view_LightsTimeLineBar.frame.size.width/12;
    NSLog(@"segment==%f",matrixLineWidth);
    
    imgView_MatrixBar1.frame = CGRectMake(matrixLineWidth+self.view_LightsTimeLineBar.frame.origin.x, imgView_MatrixBar1.frame.origin.y, imgView_MatrixBar1.frame.size.width, imgView_MatrixBar1.frame.size.height);
    imgView_MatrixBar2.frame = CGRectMake((matrixLineWidth*2)+self.view_LightsTimeLineBar.frame.origin.x, imgView_MatrixBar2.frame.origin.y, imgView_MatrixBar2.frame.size.width, imgView_MatrixBar2.frame.size.height);
    imgView_MatrixBar3.frame = CGRectMake((matrixLineWidth*3)+self.view_LightsTimeLineBar.frame.origin.x, imgView_MatrixBar3.frame.origin.y, imgView_MatrixBar3.frame.size.width, imgView_MatrixBar3.frame.size.height);
    imgView_MatrixBar4.frame = CGRectMake((matrixLineWidth*4)+self.view_LightsTimeLineBar.frame.origin.x, imgView_MatrixBar4.frame.origin.y, imgView_MatrixBar4.frame.size.width, imgView_MatrixBar4.frame.size.height);
    imgView_MatrixBar5.frame = CGRectMake((matrixLineWidth*5)+self.view_LightsTimeLineBar.frame.origin.x, imgView_MatrixBar5.frame.origin.y, imgView_MatrixBar5.frame.size.width, imgView_MatrixBar5.frame.size.height);
    imgView_MatrixBar6.frame = CGRectMake((matrixLineWidth*6)+self.view_LightsTimeLineBar.frame.origin.x, imgView_MatrixBar6.frame.origin.y, imgView_MatrixBar6.frame.size.width, imgView_MatrixBar6.frame.size.height);
    imgView_MatrixBar7.frame = CGRectMake((matrixLineWidth*7)+self.view_LightsTimeLineBar.frame.origin.x, imgView_MatrixBar7.frame.origin.y, imgView_MatrixBar7.frame.size.width, imgView_MatrixBar7.frame.size.height);
    imgView_MatrixBar8.frame = CGRectMake((matrixLineWidth*8)+self.view_LightsTimeLineBar.frame.origin.x, imgView_MatrixBar8.frame.origin.y, imgView_MatrixBar8.frame.size.width, imgView_MatrixBar8.frame.size.height);
    imgView_MatrixBar9.frame = CGRectMake((matrixLineWidth*9)+self.view_LightsTimeLineBar.frame.origin.x, imgView_MatrixBar9.frame.origin.y, imgView_MatrixBar9.frame.size.width, imgView_MatrixBar9.frame.size.height);
    imgView_MatrixBar10.frame = CGRectMake((matrixLineWidth*10)+self.view_LightsTimeLineBar.frame.origin.x, imgView_MatrixBar10.frame.origin.y, imgView_MatrixBar10.frame.size.width, imgView_MatrixBar10.frame.size.height);
    imgView_MatrixBar11.frame = CGRectMake((matrixLineWidth*11)+self.view_LightsTimeLineBar.frame.origin.x, imgView_MatrixBar11.frame.origin.y, imgView_MatrixBar11.frame.size.width, imgView_MatrixBar11.frame.size.height);
    imgView_MatrixBar12.frame = CGRectMake((matrixLineWidth*12)+self.view_LightsTimeLineBar.frame.origin.x, imgView_MatrixBar12.frame.origin.y, imgView_MatrixBar12.frame.size.width, imgView_MatrixBar12.frame.size.height);
    
    imgView_MatrixBar1.hidden=NO;
    imgView_MatrixBar2.hidden=NO;
    imgView_MatrixBar3.hidden=NO;
    imgView_MatrixBar4.hidden=NO;
    imgView_MatrixBar5.hidden=NO;
    imgView_MatrixBar6.hidden=NO;
    imgView_MatrixBar7.hidden=NO;
    imgView_MatrixBar8.hidden=NO;
    imgView_MatrixBar9.hidden=NO;
    imgView_MatrixBar10.hidden=NO;
    imgView_MatrixBar11.hidden=NO;
    imgView_MatrixBar12.hidden=NO;
    
    NSLog(@"%@",[Common deviceType]);
    viewInnerShade=[[UIView alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
        viewInnerShade.frame=CGRectMake(0, 0, 24, 24);
        viewInnerShade.layer.cornerRadius=12.0;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
        viewInnerShade.frame=CGRectMake(0, 0, 26, 26);
        viewInnerShade.layer.cornerRadius=13.0;
    }else{
        viewInnerShade.frame=CGRectMake(0, 0, 30, 30);
        viewInnerShade.layer.cornerRadius=15.0;
    }
    viewInnerShade.clipsToBounds = YES;
    viewInnerShade.layer.masksToBounds=YES;
    viewInnerShade.backgroundColor=lblRGBA(88, 89, 91, 1);
    viewInnerShade.hidden=YES;
    
    viewOuterShade=[[UIView alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
        viewOuterShade.frame=CGRectMake(0, 0, 30, 30);
        viewOuterShade.layer.cornerRadius=15.0;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
        viewOuterShade.frame=CGRectMake(0, 0, 36, 36);
        viewOuterShade.layer.cornerRadius=17.0;
    }else{
        viewOuterShade.frame=CGRectMake(0, 0, 40, 40);
        viewOuterShade.layer.cornerRadius=19.0;
    }
    viewOuterShade.clipsToBounds = YES;
    viewOuterShade.layer.masksToBounds=YES;
    viewOuterShade.backgroundColor=lblRGBA(77, 77, 79, 1);
    viewOuterShade.hidden=YES;
    
    [self.view_BodyViewTimeLine addSubview:viewInnerShade];
    [self.view_BodyViewTimeLine addSubview:viewOuterShade];

    viewPopUpAlerts=[[UIView alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
        viewPopUpAlerts.frame=CGRectMake(0, 0, 114, 48);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
        viewPopUpAlerts.frame=CGRectMake(0, 0, 120, 55);
    }else{
        viewPopUpAlerts.frame=CGRectMake(0, 0, 125, 60);
    }
    viewPopUpAlerts.hidden=YES;
    [self.view_BodyViewTimeLine addSubview:viewPopUpAlerts];
    
    scrollViewPopupAlerts=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewPopUpAlerts.frame.size.width, viewPopUpAlerts.frame.size.height)];
    scrollViewPopupAlerts.delegate=self;
    [viewPopUpAlerts addSubview:scrollViewPopupAlerts];
}

-(void)parseDevicesHeader
{
    
    /********* Sprinkler Header **********/
    NSLog(@"%f",self.view_SprinklerTimeLineBar.frame.size.width);
    CGFloat sprinklerViewWidth = self.view_SprinklerTimeLineBar.frame.size.width/1440;
    NSLog(@"segment==%f",sprinklerViewWidth);
    
    viewTimeLine_Header[0] = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
        viewTimeLine_Header[0].frame = CGRectMake(self.view_SprinklerTimeLineBar.frame.origin.x-28, self.view_SprinklerTimeLineBar.frame.origin.y-13, 28, 28);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
        viewTimeLine_Header[0].frame = CGRectMake(self.view_SprinklerTimeLineBar.frame.origin.x-36, self.view_SprinklerTimeLineBar.frame.origin.y-17, 36, 36);
    }else
    {
        viewTimeLine_Header[0].frame = CGRectMake(self.view_SprinklerTimeLineBar.frame.origin.x-40, self.view_SprinklerTimeLineBar.frame.origin.y-19, 40, 40);
    }
    [viewTimeLine_Header[0] setBackgroundImage:[UIImage imageNamed:@"sprinklerStartTimeLineIcon"] forState:UIControlStateNormal];
    viewTimeLine_Header[0].hidden=YES;
    [viewTimeLine_Header[0] setTag:0];
    [self.view_BodyViewTimeLine addSubview:viewTimeLine_Header[0]];
    
    viewTimeLine_Header[1]= [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
        viewTimeLine_Header[1].frame = CGRectMake((self.view_SprinklerTimeLineBar.frame.size.width/2)-12+self.view_SprinklerTimeLineBar.frame.origin.x, self.view_SprinklerTimeLineBar.frame.origin.y-11, 24, 24);
        viewTimeLine_Header[1].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:9];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
        viewTimeLine_Header[1].frame = CGRectMake((self.view_SprinklerTimeLineBar.frame.size.width/2)-16+self.view_SprinklerTimeLineBar.frame.origin.x, self.view_SprinklerTimeLineBar.frame.origin.y-15, 32, 32);
        viewTimeLine_Header[1].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:11];
    }else
    {
        viewTimeLine_Header[1].frame = CGRectMake((self.view_SprinklerTimeLineBar.frame.size.width/2)-18+self.view_SprinklerTimeLineBar.frame.origin.x, self.view_SprinklerTimeLineBar.frame.origin.y-17, 36, 36);
        viewTimeLine_Header[1].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:14];
    }

    [viewTimeLine_Header[1] setBackgroundImage:[UIImage imageNamed:@"sprinklerMidTImeLine"] forState:UIControlStateNormal];
    [viewTimeLine_Header[1] setTitle:@"12P" forState:UIControlStateNormal];
    [viewTimeLine_Header[1] setTitleColor:lblRGBA(136, 197, 65, 1) forState:UIControlStateNormal];
    viewTimeLine_Header[1].hidden=YES;
    [viewTimeLine_Header[1] setTag:1];
    [self.view_BodyViewTimeLine addSubview:viewTimeLine_Header[1]];
    
    viewTimeLine_Header[2] = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
        viewTimeLine_Header[2].frame = CGRectMake(self.view_SprinklerTimeLineBar.frame.origin.x+self.view_SprinklerTimeLineBar.frame.size.width, self.view_SprinklerTimeLineBar.frame.origin.y-13, 28, 28);
        viewTimeLine_Header[2].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:9];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
        viewTimeLine_Header[2].frame = CGRectMake(self.view_SprinklerTimeLineBar.frame.origin.x+self.view_SprinklerTimeLineBar.frame.size.width, self.view_SprinklerTimeLineBar.frame.origin.y-17, 36, 36);
        viewTimeLine_Header[2].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:12];
    }else
    {
        viewTimeLine_Header[2].frame = CGRectMake(self.view_SprinklerTimeLineBar.frame.origin.x+self.view_SprinklerTimeLineBar.frame.size.width, self.view_SprinklerTimeLineBar.frame.origin.y-19, 40, 40);
        viewTimeLine_Header[2].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:14];
    }

    [viewTimeLine_Header[2] setBackgroundImage:[UIImage imageNamed:@"bigsprinklerTimeLineIcon"] forState:UIControlStateNormal];
    [viewTimeLine_Header[2] setTitle:@"12A" forState:UIControlStateNormal];
    [viewTimeLine_Header[2] setTitleColor:lblRGBA(136, 197, 65, 1) forState:UIControlStateNormal];
    viewTimeLine_Header[2].hidden=YES;
    [viewTimeLine_Header[2] setTag:2];
    [self.view_BodyViewTimeLine addSubview:viewTimeLine_Header[2]];
    
    
    /******** Lights Header ******/
    NSLog(@"%f",self.view_LightsTimeLineBar.frame.size.width);
    CGFloat lightViewWidth = self.view_LightsTimeLineBar.frame.size.width/1440;
    NSLog(@"segment==%f",lightViewWidth);
    //view_LightStart
    viewTimeLine_Header[3] = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
        viewTimeLine_Header[3].frame = CGRectMake(self.view_LightsTimeLineBar.frame.origin.x-28, self.view_LightsTimeLineBar.frame.origin.y-13, 28, 28);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
        viewTimeLine_Header[3].frame = CGRectMake(self.view_LightsTimeLineBar.frame.origin.x-36, self.view_LightsTimeLineBar.frame.origin.y-17, 36, 36);
    }else
    {
        viewTimeLine_Header[3].frame = CGRectMake(self.view_LightsTimeLineBar.frame.origin.x-40, self.view_LightsTimeLineBar.frame.origin.y-19, 40, 40);
    }

    [viewTimeLine_Header[3] setBackgroundImage:[UIImage imageNamed:@"lightStartTimeLineIcon"] forState:UIControlStateNormal];
    viewTimeLine_Header[3].hidden=YES;
    [viewTimeLine_Header[3] setTag:3];
    [self.view_BodyViewTimeLine addSubview:viewTimeLine_Header[3]];
    
    viewTimeLine_Header[4]= [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
        viewTimeLine_Header[4].frame = CGRectMake((self.view_LightsTimeLineBar.frame.size.width/2)-12+self.view_LightsTimeLineBar.frame.origin.x, self.view_LightsTimeLineBar.frame.origin.y-11, 24, 24);
        viewTimeLine_Header[4].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:9];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
        viewTimeLine_Header[4].frame = CGRectMake((self.view_LightsTimeLineBar.frame.size.width/2)-16+self.view_LightsTimeLineBar.frame.origin.x, self.view_LightsTimeLineBar.frame.origin.y-15, 32, 32);
        viewTimeLine_Header[4].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:11];
    }else
    {
        viewTimeLine_Header[4].frame = CGRectMake((self.view_LightsTimeLineBar.frame.size.width/2)-18+self.view_LightsTimeLineBar.frame.origin.x, self.view_LightsTimeLineBar.frame.origin.y-17, 36, 36);
        viewTimeLine_Header[4].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:14];
    }
    [viewTimeLine_Header[4] setBackgroundImage:[UIImage imageNamed:@"lightMidTImeLine"] forState:UIControlStateNormal];
    [viewTimeLine_Header[4] setTitle:@"12P" forState:UIControlStateNormal];
    [viewTimeLine_Header[4] setTitleColor:lblRGBA(255, 205, 52, 1) forState:UIControlStateNormal];
    viewTimeLine_Header[4].hidden=YES;
    [viewTimeLine_Header[4] setTag:4];
    [self.view_BodyViewTimeLine addSubview:viewTimeLine_Header[4]];
    
    viewTimeLine_Header[5] = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
        viewTimeLine_Header[5].frame = CGRectMake(self.view_LightsTimeLineBar.frame.origin.x+self.view_LightsTimeLineBar.frame.size.width, self.view_LightsTimeLineBar.frame.origin.y-13, 28, 28);
        viewTimeLine_Header[5].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:9];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
        viewTimeLine_Header[5].frame = CGRectMake(self.view_LightsTimeLineBar.frame.origin.x+self.view_LightsTimeLineBar.frame.size.width, self.view_LightsTimeLineBar.frame.origin.y-17, 36, 36);
        viewTimeLine_Header[5].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:12];
    }else
    {
        viewTimeLine_Header[5].frame = CGRectMake(self.view_LightsTimeLineBar.frame.origin.x+self.view_LightsTimeLineBar.frame.size.width, self.view_LightsTimeLineBar.frame.origin.y-19, 40, 40);
        viewTimeLine_Header[5].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:14];
    }

    [viewTimeLine_Header[5] setBackgroundImage:[UIImage imageNamed:@"biglightTimeLineIcon"] forState:UIControlStateNormal];
    [viewTimeLine_Header[5] setTitle:@"12A" forState:UIControlStateNormal];
    [viewTimeLine_Header[5] setTitleColor:lblRGBA(255, 205, 52, 1) forState:UIControlStateNormal];
    viewTimeLine_Header[5].hidden=YES;
    [viewTimeLine_Header[5] setTag:5];
    [self.view_BodyViewTimeLine addSubview:viewTimeLine_Header[5]];
    
    /******** OtherHeader **********/
    NSLog(@"%f",self.view_OthersTimeLineBar.frame.size.width);
    CGFloat otherViewWidth = self.view_OthersTimeLineBar.frame.size.width/1440;
    NSLog(@"segment==%f",otherViewWidth);
    
    viewTimeLine_Header[6] = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
        viewTimeLine_Header[6].frame = CGRectMake(self.view_OthersTimeLineBar.frame.origin.x-28, self.view_OthersTimeLineBar.frame.origin.y-13, 28, 28);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
        viewTimeLine_Header[6].frame = CGRectMake(self.view_OthersTimeLineBar.frame.origin.x-36, self.view_OthersTimeLineBar.frame.origin.y-17, 36, 36);
    }else
    {
        viewTimeLine_Header[6].frame = CGRectMake(self.view_OthersTimeLineBar.frame.origin.x-40, self.view_OthersTimeLineBar.frame.origin.y-19, 40, 40);
    }
    [viewTimeLine_Header[6] setBackgroundImage:[UIImage imageNamed:@"otherStartTimeLineIcon"] forState:UIControlStateNormal];
    viewTimeLine_Header[6].hidden=YES;
    [viewTimeLine_Header[6] setTag:6];
    [self.view_BodyViewTimeLine addSubview:viewTimeLine_Header[6]];
    
    viewTimeLine_Header[7]= [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
        viewTimeLine_Header[7].frame = CGRectMake((self.view_OthersTimeLineBar.frame.size.width/2)-12+self.view_OthersTimeLineBar.frame.origin.x, self.view_OthersTimeLineBar.frame.origin.y-11, 24, 24);
        viewTimeLine_Header[7].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:9];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
        viewTimeLine_Header[7].frame = CGRectMake((self.view_OthersTimeLineBar.frame.size.width/2)-16+self.view_OthersTimeLineBar.frame.origin.x, self.view_OthersTimeLineBar.frame.origin.y-15, 32, 32);
        viewTimeLine_Header[7].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:11];
    }else
    {
        viewTimeLine_Header[7].frame = CGRectMake((self.view_OthersTimeLineBar.frame.size.width/2)-18+self.view_OthersTimeLineBar.frame.origin.x, self.view_OthersTimeLineBar.frame.origin.y-17, 36, 36);
        viewTimeLine_Header[7].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:14];
    }
    [viewTimeLine_Header[7] setBackgroundImage:[UIImage imageNamed:@"otherMidTImeLine"] forState:UIControlStateNormal];
    [viewTimeLine_Header[7] setTitle:@"12P" forState:UIControlStateNormal];
    [viewTimeLine_Header[7] setTitleColor:lblRGBA(49, 165, 222, 1) forState:UIControlStateNormal];
    viewTimeLine_Header[7].hidden=YES;
    [viewTimeLine_Header[7] setTag:7];
    [self.view_BodyViewTimeLine addSubview:viewTimeLine_Header[7]];
    
    viewTimeLine_Header[8] = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
        viewTimeLine_Header[8].frame = CGRectMake(self.view_OthersTimeLineBar.frame.origin.x+self.view_OthersTimeLineBar.frame.size.width, self.view_OthersTimeLineBar.frame.origin.y-13, 28, 28);
        viewTimeLine_Header[8].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:9];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
        viewTimeLine_Header[8].frame = CGRectMake(self.view_OthersTimeLineBar.frame.origin.x+self.view_OthersTimeLineBar.frame.size.width, self.view_OthersTimeLineBar.frame.origin.y-17, 36, 36);
        viewTimeLine_Header[8].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:12];
    }else
    {
        viewTimeLine_Header[8].frame = CGRectMake(self.view_OthersTimeLineBar.frame.origin.x+self.view_OthersTimeLineBar.frame.size.width, self.view_OthersTimeLineBar.frame.origin.y-19, 40, 40);
        viewTimeLine_Header[8].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:14];
    }

    [viewTimeLine_Header[8] setBackgroundImage:[UIImage imageNamed:@"bigotherTimeLineIcon"] forState:UIControlStateNormal];
    [viewTimeLine_Header[8] setTitle:@"12A" forState:UIControlStateNormal];
    [viewTimeLine_Header[8] setTitleColor:lblRGBA(49, 165, 222, 1) forState:UIControlStateNormal];
    viewTimeLine_Header[8].hidden=YES;
    [viewTimeLine_Header[8] setTag:8];
    [self.view_BodyViewTimeLine addSubview:viewTimeLine_Header[8]];
}

-(void)parseDevices
{
    NSLog(@"%f",self.view_LightsTimeLineBar.frame.size.width);
    CGFloat lightViewWidth = self.view_LightsTimeLineBar.frame.size.width/1440;
    NSLog(@"segment==%f",lightViewWidth);
    
    NSString *zeroString = @"00:00:00";
    NSString *timeString=@"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *zeroDate,*offsetDate;
    NSTimeInterval timeDifference;
    CGFloat minutes;

    for (int index=0; index<[arrLights count]; index++) {
        timeString = [[arrLights objectAtIndex:index] valueForKey:@"Time"];
        
        zeroDate = [dateFormatter dateFromString:zeroString];
        offsetDate = [dateFormatter dateFromString:timeString];
        timeDifference = [offsetDate timeIntervalSinceDate:zeroDate];
        minutes = (timeDifference/60);
        NSLog(@"minutes==%f",minutes);
        NSLog(@"%0.2fmins",minutes);
        NSLog(@"%f",(minutes*lightViewWidth));
        
        viewDevice[index] = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
            viewDevice[index].frame = CGRectMake(self.view_LightsTimeLineBar.frame.origin.x+(minutes*lightViewWidth)-9, self.view_LightsTimeLineBar.frame.origin.y-8, 18, 18);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
            viewDevice[index].frame = CGRectMake(self.view_LightsTimeLineBar.frame.origin.x+(minutes*lightViewWidth)-10, self.view_LightsTimeLineBar.frame.origin.y-9, 20, 20);
        }else
        {
            viewDevice[index].frame = CGRectMake(self.view_LightsTimeLineBar.frame.origin.x+(minutes*lightViewWidth)-12, self.view_LightsTimeLineBar.frame.origin.y-11, 24, 24);
        }
        [viewDevice[index] setBackgroundImage:[UIImage imageNamed:@"lightDeviceTImeLine"] forState:UIControlStateNormal];
        viewDevice[index].tag = index;
        viewDevice[index].hidden=YES;
        [viewDevice[index] addTarget:self action:@selector(selectDeviceAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view_BodyViewTimeLine addSubview:viewDevice[index]];
    }
//    [self performSelectorOnMainThread:@selector(shuffleDevice) withObject:nil waitUntilDone:YES];
}

-(void)parseDevicesOthers
{
    NSLog(@"%f",self.view_OthersTimeLineBar.frame.size.width);
    CGFloat otherViewWidth = self.view_OthersTimeLineBar.frame.size.width/1440;
    NSLog(@"segment==%f",otherViewWidth);
    
    NSString *zeroString = @"00:00:00";
    NSString *timeString=@"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *zeroDate,*offsetDate;
    NSTimeInterval timeDifference;
    CGFloat minutes;
    
    for (int index=0; index<[arrOthers count]; index++) {
        timeString = [[arrOthers objectAtIndex:index] valueForKey:@"Time"];
        
        zeroDate = [dateFormatter dateFromString:zeroString];
        offsetDate = [dateFormatter dateFromString:timeString];
        timeDifference = [offsetDate timeIntervalSinceDate:zeroDate];
        minutes = (timeDifference/60);
        NSLog(@"minutes==%f",minutes);
        NSLog(@"%0.2fmins",minutes);
        NSLog(@"%f",(minutes*otherViewWidth));
        
        viewDeviceOthers[index] = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
            viewDeviceOthers[index].frame = CGRectMake(self.view_OthersTimeLineBar.frame.origin.x+(minutes*otherViewWidth)-9, self.view_OthersTimeLineBar.frame.origin.y-8, 18, 18);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
            viewDeviceOthers[index].frame = CGRectMake(self.view_OthersTimeLineBar.frame.origin.x+(minutes*otherViewWidth)-10, self.view_OthersTimeLineBar.frame.origin.y-9, 20, 20);
        }else
        {
            viewDeviceOthers[index].frame = CGRectMake(self.view_OthersTimeLineBar.frame.origin.x+(minutes*otherViewWidth)-12, self.view_OthersTimeLineBar.frame.origin.y-11, 24, 24);
        }
        [viewDeviceOthers[index] setBackgroundImage:[UIImage imageNamed:@"otherDeviceTImeLine"] forState:UIControlStateNormal];

        viewDeviceOthers[index].tag = index;
        viewDeviceOthers[index].hidden=YES;
        [viewDeviceOthers[index] addTarget:self action:@selector(selectDeviceActionOther:) forControlEvents:UIControlEventTouchUpInside];
        [self.view_BodyViewTimeLine addSubview:viewDeviceOthers[index]];
    }
//    [self performSelectorOnMainThread:@selector(shuffleDeviceOthers)  withObject:nil waitUntilDone:YES];
}

-(void)parseDevicesSprinklers
{
    NSLog(@"%f",self.view_SprinklerTimeLineBar.frame.size.width);
    CGFloat sprinklerViewWidth = self.view_SprinklerTimeLineBar.frame.size.width/1440;
    NSLog(@"segment==%f",sprinklerViewWidth);
    
    NSString *zeroString = @"00:00:00";
    NSString *timeString=@"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *zeroDate,*offsetDate;
    NSTimeInterval timeDifference;
    CGFloat minutes;
    
    for (int index=0; index<[arrSprinkler count]; index++) {
        timeString = [[arrSprinkler objectAtIndex:index] valueForKey:@"Time"];
        
        zeroDate = [dateFormatter dateFromString:zeroString];
        offsetDate = [dateFormatter dateFromString:timeString];
        timeDifference = [offsetDate timeIntervalSinceDate:zeroDate];
        minutes = (timeDifference/60);
        NSLog(@"minutes==%f",minutes);
        NSLog(@"%0.2fmins",minutes);
        NSLog(@"%f",(minutes*sprinklerViewWidth));
        
        viewDeviceSprinklers[index] = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
            viewDeviceSprinklers[index].frame = CGRectMake(self.view_SprinklerTimeLineBar.frame.origin.x+(minutes*sprinklerViewWidth)-9, self.view_SprinklerTimeLineBar.frame.origin.y-8, 18, 18);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
            viewDeviceSprinklers[index].frame = CGRectMake(self.view_SprinklerTimeLineBar.frame.origin.x+(minutes*sprinklerViewWidth)-10, self.view_SprinklerTimeLineBar.frame.origin.y-9, 20, 20);
        }else
        {
            viewDeviceSprinklers[index].frame = CGRectMake(self.view_SprinklerTimeLineBar.frame.origin.x+(minutes*sprinklerViewWidth)-12, self.view_SprinklerTimeLineBar.frame.origin.y-11, 24, 24);
        }
        
        [viewDeviceSprinklers[index] setBackgroundImage:[UIImage imageNamed:@"sprinklerDeviceTImeLine"] forState:UIControlStateNormal];
        
        viewDeviceSprinklers[index].tag = index;
        viewDeviceSprinklers[index].hidden=YES;
        [viewDeviceSprinklers[index] addTarget:self action:@selector(selectDeviceActionSprinkler:) forControlEvents:UIControlEventTouchUpInside];
        [self.view_BodyViewTimeLine addSubview:viewDeviceSprinklers[index]];
    }
//    [self performSelectorOnMainThread:@selector(shuffleDeviceSprinklers) withObject:nil waitUntilDone:YES];
}

-(void)selectDeviceAction:(UIButton *)sender
{
    preTagOther=0;
    currentTagOther=0;
    preTagSprinkler=0;
    currentTagSprinkler=0;
    NSLog(@"seleted button tag == %ld",(long)sender.tag);
    CurrentTag=(int)sender.tag;
    if(CurrentTag==preTag)
    {
        return;
    }else{
        if(viewPopUpAlerts.hidden==NO)
        {
            viewPopUpAlerts.hidden=YES;
            NSArray *viewsToRemove = [scrollViewPopupAlerts subviews];
            for (UIScrollView *v in viewsToRemove) {
                [v removeFromSuperview];
            }
        }
        if(self.view_DetailViewTimeLine.hidden==NO)
        {
            self.view_DetailViewTimeLine.hidden=YES;
        }
        preTag=CurrentTag;
        
        viewInnerShade.frame=CGRectMake(viewDevice[CurrentTag].frame.origin.x-3, viewDevice[CurrentTag].frame.origin.y-3, viewInnerShade.frame.size.width, viewInnerShade.frame.size.height);

        if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
            viewOuterShade.frame=CGRectMake(viewInnerShade.frame.origin.x-3, viewInnerShade.frame.origin.y-3, viewOuterShade.frame.size.width, viewOuterShade.frame.size.height);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
            viewOuterShade.frame=CGRectMake(viewInnerShade.frame.origin.x-5, viewInnerShade.frame.origin.y-5, viewOuterShade.frame.size.width, viewOuterShade.frame.size.height);
        }else{
            viewOuterShade.frame=CGRectMake(viewInnerShade.frame.origin.x-5, viewInnerShade.frame.origin.y-5, viewOuterShade.frame.size.width, viewOuterShade.frame.size.height);
        }
        

        [self.view_BodyViewTimeLine bringSubviewToFront:viewOuterShade];
        [self.view_BodyViewTimeLine bringSubviewToFront:viewInnerShade];
        [self.view_BodyViewTimeLine bringSubviewToFront:viewDevice[CurrentTag]];
        viewInnerShade.hidden=NO;
        viewOuterShade.hidden=NO;
        
        [self showGlowAnimation];
    
    btn_PreviousInTimeLine.frame=CGRectMake(btn_PreviousInTimeLine.frame.origin.x, view_LightsTimeLineBar.frame.origin.y-btn_PreviousInTimeLine.frame.size.height/2, btn_PreviousInTimeLine.frame.size.width, btn_PreviousInTimeLine.frame.size.height);
    btn_NextInTimeLine.frame=CGRectMake(btn_NextInTimeLine.frame.origin.x, view_LightsTimeLineBar.frame.origin.y-btn_PreviousInTimeLine.frame.size.height/2, btn_NextInTimeLine.frame.size.width, btn_NextInTimeLine.frame.size.height);
    btn_PreviousInTimeLine.hidden=NO;
    btn_NextInTimeLine.hidden=NO;
    
    [self parseSelectedDeviceList:(int)sender.tag];
    }
}

-(void)showGlowAnimation
{
    [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat animations:^{
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = @(0.6);
        animation.toValue = @(1.0);
        animation.repeatCount = INFINITY;//YES ? HUGE_VAL : 0;
        animation.duration = 2.0;
        animation.autoreverses = YES;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [viewOuterShade.layer addAnimation:animation forKey:@"pulse"];
    } completion:nil];
}

-(void)selectDeviceActionSprinkler:(UIButton *)sender
{
    preTag=0;
    CurrentTag=0;
    preTagOther=0;
    currentTagOther=0;
    preTag=0;
    CurrentTag=0;
    preTagOther=0;
    currentTagOther=0;
    NSLog(@"seleted button tag == %ld",(long)sender.tag);
    currentTagSprinkler=(int)sender.tag;
    if(currentTagSprinkler==preTagSprinkler)
    {
        return;
    }else{
        if(viewPopUpAlerts.hidden==NO)
        {
            viewPopUpAlerts.hidden=YES;
            NSArray *viewsToRemove = [scrollViewPopupAlerts subviews];
            for (UIScrollView *v in viewsToRemove) {
                [v removeFromSuperview];
            }
        }
        if(self.view_DetailViewTimeLine.hidden==NO)
        {
            self.view_DetailViewTimeLine.hidden=YES;
        }
        preTagSprinkler=currentTagSprinkler;
        
        viewInnerShade.frame=CGRectMake(viewDeviceSprinklers[currentTagSprinkler].frame.origin.x-3, viewDeviceSprinklers[currentTagSprinkler].frame.origin.y-3, viewInnerShade.frame.size.width, viewInnerShade.frame.size.height);
        
        if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
            viewOuterShade.frame=CGRectMake(viewInnerShade.frame.origin.x-3, viewInnerShade.frame.origin.y-3, viewOuterShade.frame.size.width, viewOuterShade.frame.size.height);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
            viewOuterShade.frame=CGRectMake(viewInnerShade.frame.origin.x-5, viewInnerShade.frame.origin.y-5, viewOuterShade.frame.size.width, viewOuterShade.frame.size.height);
        }else{
            viewOuterShade.frame=CGRectMake(viewInnerShade.frame.origin.x-5, viewInnerShade.frame.origin.y-5, viewOuterShade.frame.size.width, viewOuterShade.frame.size.height);
        }
        
        
        [self.view_BodyViewTimeLine bringSubviewToFront:viewOuterShade];
        [self.view_BodyViewTimeLine bringSubviewToFront:viewInnerShade];
        [self.view_BodyViewTimeLine bringSubviewToFront:viewDeviceSprinklers[currentTagSprinkler]];
        viewInnerShade.hidden=NO;
        viewOuterShade.hidden=NO;
        
        [self showGlowAnimation];
        
        btn_PreviousInTimeLine.frame=CGRectMake(btn_PreviousInTimeLine.frame.origin.x, view_SprinklerTimeLineBar.frame.origin.y-btn_PreviousInTimeLine.frame.size.height/2, btn_PreviousInTimeLine.frame.size.width, btn_PreviousInTimeLine.frame.size.height);
        btn_NextInTimeLine.frame=CGRectMake(btn_NextInTimeLine.frame.origin.x, view_SprinklerTimeLineBar.frame.origin.y-btn_PreviousInTimeLine.frame.size.height/2, btn_NextInTimeLine.frame.size.width, btn_NextInTimeLine.frame.size.height);
        btn_PreviousInTimeLine.hidden=NO;
        btn_NextInTimeLine.hidden=NO;
        
        [self parseSelectedDeviceListSprinkler:(int)sender.tag];
    }
}

-(void)selectDeviceActionOther:(UIButton *)sender
{
    preTag=0;
    CurrentTag=0;
    preTagSprinkler=0;
    currentTagSprinkler=0;
    NSLog(@"seleted button tag == %ld",(long)sender.tag);
    currentTagOther=(int)sender.tag;
    if(currentTagOther==preTagOther)
    {
        return;
    }else{
        if(viewPopUpAlerts.hidden==NO)
        {
            viewPopUpAlerts.hidden=YES;
            NSArray *viewsToRemove = [scrollViewPopupAlerts subviews];
            for (UIScrollView *v in viewsToRemove) {
                [v removeFromSuperview];
            }
        }
        if(self.view_DetailViewTimeLine.hidden==NO)
        {
            self.view_DetailViewTimeLine.hidden=YES;
        }
        preTagOther=currentTagOther;
        
        viewInnerShade.frame=CGRectMake(viewDeviceOthers[currentTagOther].frame.origin.x-3, viewDeviceOthers[currentTagOther].frame.origin.y-3, viewInnerShade.frame.size.width, viewInnerShade.frame.size.height);
        
        if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
            viewOuterShade.frame=CGRectMake(viewInnerShade.frame.origin.x-3, viewInnerShade.frame.origin.y-3, viewOuterShade.frame.size.width, viewOuterShade.frame.size.height);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
            viewOuterShade.frame=CGRectMake(viewInnerShade.frame.origin.x-5, viewInnerShade.frame.origin.y-5, viewOuterShade.frame.size.width, viewOuterShade.frame.size.height);
        }else{
            viewOuterShade.frame=CGRectMake(viewInnerShade.frame.origin.x-5, viewInnerShade.frame.origin.y-5, viewOuterShade.frame.size.width, viewOuterShade.frame.size.height);
        }
        
        
        [self.view_BodyViewTimeLine bringSubviewToFront:viewOuterShade];
        [self.view_BodyViewTimeLine bringSubviewToFront:viewInnerShade];
        [self.view_BodyViewTimeLine bringSubviewToFront:viewDeviceOthers[currentTagOther]];
        viewInnerShade.hidden=NO;
        viewOuterShade.hidden=NO;
        
        [self showGlowAnimation];
        
        btn_PreviousInTimeLine.frame=CGRectMake(btn_PreviousInTimeLine.frame.origin.x, view_OthersTimeLineBar.frame.origin.y-btn_PreviousInTimeLine.frame.size.height/2, btn_PreviousInTimeLine.frame.size.width, btn_PreviousInTimeLine.frame.size.height);
        btn_NextInTimeLine.frame=CGRectMake(btn_NextInTimeLine.frame.origin.x, view_OthersTimeLineBar.frame.origin.y-btn_PreviousInTimeLine.frame.size.height/2, btn_NextInTimeLine.frame.size.width, btn_NextInTimeLine.frame.size.height);
        btn_PreviousInTimeLine.hidden=NO;
        btn_NextInTimeLine.hidden=NO;
        
        [self parseSelectedDeviceListOther:(int)sender.tag];
    }
}

-(void)parseSelectedDeviceList:(int)tag
{
    int dotCount=1;
    arrSelectedDevice=[[NSMutableArray alloc] init];
    for(int jx=0;jx<[arrLights count];jx++)
    {
        NSLog(@"index time == %@",[[arrLights objectAtIndex:tag] valueForKey:@"Time"]);
        NSLog(@"looping index time == %@",[[arrLights objectAtIndex:jx] valueForKey:@"Time"]);
        if([[[arrLights objectAtIndex:tag] valueForKey:@"Time"] isEqualToString:[[arrLights objectAtIndex:jx] valueForKey:@"Time"]])
        {
            dotCount=dotCount+1;
            [arrSelectedDevice addObject:[arrLights objectAtIndex:jx]];
        }
    }
    if(dotCount>2)
    {
        //202 - popup width 92 - popup height 20 - for my assumpiton
        if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
            float xaxis=viewDevice[tag].frame.origin.x+(viewDevice[tag].frame.size.width/2)-114/2;
            viewPopUpAlerts.frame=CGRectMake(xaxis, viewDevice[tag].frame.origin.y-48-10, 114, 48);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
            float xaxis=viewDevice[tag].frame.origin.x+(viewDevice[tag].frame.size.width/2)-120/2;
            viewPopUpAlerts.frame=CGRectMake(xaxis, viewDevice[tag].frame.origin.y-55-10, 120, 55);
        }else{
            float xaxis=viewDevice[tag].frame.origin.x+(viewDevice[tag].frame.size.width/2)-125/2;
            viewPopUpAlerts.frame=CGRectMake(xaxis, viewDevice[tag].frame.origin.y+40+5, 125, 60);
        }
        viewPopUpAlerts.backgroundColor=lblRGBA(255, 206, 52, 1);
        [self.view_BodyViewTimeLine bringSubviewToFront:viewPopUpAlerts];
        
        float yAxis=0;
        NSLog(@"array count =%lu",(unsigned long)arrSelectedDevice.count);
        
        UIImageView *imgView_Divider;
        for(int range=0;range<[arrSelectedDevice count];range++)
        {
            btnCell_Device =[UIButton buttonWithType:UIButtonTypeCustom];
            [btnCell_Device setTitle:[[arrSelectedDevice objectAtIndex:range] objectForKey:@"ScheduleName"] forState:UIControlStateNormal];
            btnCell_Device.titleLabel.textColor=lblRGBA(255, 255, 255, 1);
            btnCell_Device.backgroundColor=[UIColor clearColor];
            if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
                btnCell_Device.frame=CGRectMake(0, yAxis, viewPopUpAlerts.frame.size.width, 15);
                btnCell_Device.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:9];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
                btnCell_Device.frame=CGRectMake(0, yAxis, viewPopUpAlerts.frame.size.width, 17);
                btnCell_Device.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:10];
            }else{
                btnCell_Device.frame=CGRectMake(0, yAxis, viewPopUpAlerts.frame.size.width, 19);
                btnCell_Device.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:11];
            }
            [btnCell_Device addTarget:self action:@selector(selectMultiple_DeviceAction:) forControlEvents:UIControlEventTouchUpInside];
            [btnCell_Device setTag:range];
            [scrollViewPopupAlerts addSubview:btnCell_Device];
            yAxis=btnCell_Device.frame.origin.y+btnCell_Device.frame.size.height;
            imgView_Divider=[[UIImageView alloc] init];
            imgView_Divider.frame=CGRectMake(0, yAxis, btnCell_Device.frame.size.width, 1);
            imgView_Divider.image=[UIImage imageNamed:@"timelineWhite"];
            [scrollViewPopupAlerts addSubview:imgView_Divider];
            yAxis=imgView_Divider.frame.origin.y+imgView_Divider.frame.size.height;
            
            scrollViewPopupAlerts.contentSize=CGSizeMake(scrollViewPopupAlerts.frame.size.width, yAxis);
        }
        viewPopUpAlerts.hidden=NO;
    }
    else{
        [self showDetailView_WithDetails:(int)tag];
    }
}

-(void)parseSelectedDeviceListOther:(int)tag
{
    int dotCount=1;
    arrSelectedDevice=[[NSMutableArray alloc] init];
    for(int jx=0;jx<[arrLights count];jx++)
    {
        NSLog(@"index time == %@",[[arrOthers objectAtIndex:tag] valueForKey:@"Time"]);
        NSLog(@"looping index time == %@",[[arrOthers objectAtIndex:jx] valueForKey:@"Time"]);
        if([[[arrOthers objectAtIndex:tag] valueForKey:@"Time"] isEqualToString:[[arrOthers objectAtIndex:jx] valueForKey:@"Time"]])
        {
            dotCount=dotCount+1;
            [arrSelectedDevice addObject:[arrOthers objectAtIndex:jx]];
        }
    }
    if(dotCount>2)
    {
        //202 - popup width 92 - popup height 20 - for my assumpiton
        if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
            float xaxis=viewDeviceOthers[tag].frame.origin.x+(viewDeviceOthers[tag].frame.size.width/2)-114/2;
            viewPopUpAlerts.frame=CGRectMake(xaxis, viewDeviceOthers[tag].frame.origin.y-48-10, 114, 48);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
            float xaxis=viewDeviceOthers[tag].frame.origin.x+(viewDeviceOthers[tag].frame.size.width/2)-120/2;
            viewPopUpAlerts.frame=CGRectMake(xaxis, viewDeviceOthers[tag].frame.origin.y-55-10, 120, 55);
        }else{
            float xaxis=viewDeviceOthers[tag].frame.origin.x+(viewDeviceOthers[tag].frame.size.width/2)-125/2;
            viewPopUpAlerts.frame=CGRectMake(xaxis, viewDeviceOthers[tag].frame.origin.y+40+5, 125, 60);
        }
        viewPopUpAlerts.backgroundColor=lblRGBA(49, 165, 222, 1);
        [self.view_BodyViewTimeLine bringSubviewToFront:viewPopUpAlerts];
        
        float yAxis=0;
        NSLog(@"array count =%lu",(unsigned long)arrSelectedDevice.count);
        
        UIImageView *imgView_Divider;
        for(int range=0;range<[arrSelectedDevice count];range++)
        {
            btnCell_Device =[UIButton buttonWithType:UIButtonTypeCustom];
            [btnCell_Device setTitle:[[arrSelectedDevice objectAtIndex:range] objectForKey:@"ScheduleName"] forState:UIControlStateNormal];
            btnCell_Device.titleLabel.textColor=lblRGBA(255, 255, 255, 1);
            btnCell_Device.backgroundColor=[UIColor clearColor];
            if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
                btnCell_Device.frame=CGRectMake(0, yAxis, viewPopUpAlerts.frame.size.width, 15);
                btnCell_Device.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:9];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
                btnCell_Device.frame=CGRectMake(0, yAxis, viewPopUpAlerts.frame.size.width, 17);
                btnCell_Device.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:10];
            }else{
                btnCell_Device.frame=CGRectMake(0, yAxis, viewPopUpAlerts.frame.size.width, 19);
                btnCell_Device.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:11];
            }
            [btnCell_Device addTarget:self action:@selector(selectMultiple_DeviceActionOthers:) forControlEvents:UIControlEventTouchUpInside];
            [btnCell_Device setTag:range];
            [scrollViewPopupAlerts addSubview:btnCell_Device];
            yAxis=btnCell_Device.frame.origin.y+btnCell_Device.frame.size.height;
            imgView_Divider=[[UIImageView alloc] init];
            imgView_Divider.frame=CGRectMake(0, yAxis, btnCell_Device.frame.size.width, 1);
            imgView_Divider.image=[UIImage imageNamed:@"timelineWhite"];
            [scrollViewPopupAlerts addSubview:imgView_Divider];
            yAxis=imgView_Divider.frame.origin.y+imgView_Divider.frame.size.height;
            
            scrollViewPopupAlerts.contentSize=CGSizeMake(scrollViewPopupAlerts.frame.size.width, yAxis);
        }
        viewPopUpAlerts.hidden=NO;
    }
    else{
        [self showDetailView_WithDetailsOthers:(int)tag];
    }
}

-(void)parseSelectedDeviceListSprinkler:(int)tag
{
    int dotCount=1;
    arrSelectedDevice=[[NSMutableArray alloc] init];
    for(int jx=0;jx<[arrSprinkler count];jx++)
    {
        NSLog(@"index time == %@",[[arrSprinkler objectAtIndex:tag] valueForKey:@"Time"]);
        NSLog(@"looping index time == %@",[[arrSprinkler objectAtIndex:jx] valueForKey:@"Time"]);
        if([[[arrSprinkler objectAtIndex:tag] valueForKey:@"Time"] isEqualToString:[[arrSprinkler objectAtIndex:jx] valueForKey:@"Time"]])
        {
            dotCount=dotCount+1;
            [arrSelectedDevice addObject:[arrSprinkler objectAtIndex:jx]];
        }
    }
    if(dotCount>2)
    {
        //202 - popup width 92 - popup height 20 - for my assumpiton
        if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
            float xaxis=viewDeviceSprinklers[tag].frame.origin.x+(viewDeviceSprinklers[tag].frame.size.width/2)-114/2;
            viewPopUpAlerts.frame=CGRectMake(xaxis, viewDeviceSprinklers[tag].frame.origin.y-48-10, 114, 48);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
            float xaxis=viewDeviceSprinklers[tag].frame.origin.x+(viewDeviceSprinklers[tag].frame.size.width/2)-120/2;
            viewPopUpAlerts.frame=CGRectMake(xaxis, viewDeviceSprinklers[tag].frame.origin.y-55-10, 120, 55);
        }else{
            float xaxis=viewDeviceSprinklers[tag].frame.origin.x+(viewDeviceSprinklers[tag].frame.size.width/2)-125/2;
            viewPopUpAlerts.frame=CGRectMake(xaxis, viewDeviceSprinklers[tag].frame.origin.y+40+5, 125, 60);
        }
        viewPopUpAlerts.backgroundColor=lblRGBA(136, 197, 65, 1);
        [self.view_BodyViewTimeLine bringSubviewToFront:viewPopUpAlerts];
        
        float yAxis=0;
        NSLog(@"array count =%lu",(unsigned long)arrSelectedDevice.count);
        
        UIImageView *imgView_Divider;
        for(int range=0;range<[arrSelectedDevice count];range++)
        {
            btnCell_Device =[UIButton buttonWithType:UIButtonTypeCustom];
            [btnCell_Device setTitle:[[arrSelectedDevice objectAtIndex:range] objectForKey:@"ScheduleName"] forState:UIControlStateNormal];
            btnCell_Device.titleLabel.textColor=lblRGBA(255, 255, 255, 1);
            btnCell_Device.backgroundColor=[UIColor clearColor];
            if ([[Common deviceType] isEqualToString:@"iPhone5landscape"]){
                btnCell_Device.frame=CGRectMake(0, yAxis, viewPopUpAlerts.frame.size.width, 15);
                btnCell_Device.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:9];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6landscape"]){
                btnCell_Device.frame=CGRectMake(0, yAxis, viewPopUpAlerts.frame.size.width, 17);
                btnCell_Device.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:10];
            }else{
                btnCell_Device.frame=CGRectMake(0, yAxis, viewPopUpAlerts.frame.size.width, 19);
                btnCell_Device.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:11];
            }
            [btnCell_Device addTarget:self action:@selector(selectMultiple_DeviceActionSprinklers:) forControlEvents:UIControlEventTouchUpInside];
            [btnCell_Device setTag:range];
            [scrollViewPopupAlerts addSubview:btnCell_Device];
            yAxis=btnCell_Device.frame.origin.y+btnCell_Device.frame.size.height;
            imgView_Divider=[[UIImageView alloc] init];
            imgView_Divider.frame=CGRectMake(0, yAxis, btnCell_Device.frame.size.width, 1);
            imgView_Divider.image=[UIImage imageNamed:@"timelineWhite"];
            [scrollViewPopupAlerts addSubview:imgView_Divider];
            yAxis=imgView_Divider.frame.origin.y+imgView_Divider.frame.size.height;
            
            scrollViewPopupAlerts.contentSize=CGSizeMake(scrollViewPopupAlerts.frame.size.width, yAxis);
        }
        viewPopUpAlerts.hidden=NO;
    }
    else{
        [self showDetailView_WithDetailsSprinklers:(int)tag];
    }
}

-(void)selectMultiple_DeviceAction:(UIButton *)sender
{
    NSLog(@"selected sub device tag == %ld",(long)sender.tag);
    NSLog(@"selected sub device id == %@",[[arrSelectedDevice objectAtIndex:sender.tag] objectForKey:@"Id"]);
    for(int index=0;index<[arrLights count];index++)
    {
        NSLog(@"index == %d",index);
        if([[[arrLights objectAtIndex:index] objectForKey:@"Id"] isEqualToString:[[arrSelectedDevice objectAtIndex:sender.tag] objectForKey:@"Id"]])
        {
            [self showDetailView_WithDetails:index];
            return;
        }
    }
}

-(void)selectMultiple_DeviceActionOthers:(UIButton *)sender
{
    NSLog(@"selected sub device tag == %ld",(long)sender.tag);
    NSLog(@"selected sub device id == %@",[[arrSelectedDevice objectAtIndex:sender.tag] objectForKey:@"Id"]);
    for(int index=0;index<[arrOthers count];index++)
    {
        NSLog(@"index == %d",index);
        if([[[arrOthers objectAtIndex:index] objectForKey:@"Id"] isEqualToString:[[arrSelectedDevice objectAtIndex:sender.tag] objectForKey:@"Id"]])
        {
            [self showDetailView_WithDetailsOthers:index];
            return;
        }
    }
}
-(void)selectMultiple_DeviceActionSprinklers:(UIButton *)sender
{
    NSLog(@"selected sub device tag == %ld",(long)sender.tag);
    NSLog(@"selected sub device id == %@",[[arrSelectedDevice objectAtIndex:sender.tag] objectForKey:@"Id"]);
    for(int index=0;index<[arrSprinkler count];index++)
    {
        NSLog(@"index == %d",index);
        if([[[arrSprinkler objectAtIndex:index] objectForKey:@"Id"] isEqualToString:[[arrSelectedDevice objectAtIndex:sender.tag] objectForKey:@"Id"]])
        {
            [self showDetailView_WithDetailsSprinklers:index];
            return;
        }
    }
}

-(void)showDetailView_WithDetails:(int)tagVal
{
    selectedTag = tagVal;
    deviceTypes=@"light";
    self.img_detailView.image=[UIImage imageNamed:[[arrLights objectAtIndex:tagVal] objectForKey:@"Image"]];
    self.lbl_deviceName.text=[[arrLights objectAtIndex:tagVal] objectForKey:@"Name"];
    self.lbl_ScheduleName.text=[[arrLights objectAtIndex:tagVal] objectForKey:@"ScheduleName"];
    if([[[arrLights objectAtIndex:tagVal] objectForKey:@"Status"] isEqualToString:@"OFF"]){
        [swtchLight setOn:NO animated:NO];
        [swtchLight setThumbTintColor:lblRGBA(98, 99, 102, 1)];
        view_Profile_Header.backgroundColor=lblRGBA(98, 99, 102, 1);
    }else
    {
        [swtchLight setOn:YES animated:NO];
        view_Profile_Header .backgroundColor=lblRGBA(255, 206, 52, 1);
        [swtchLight setThumbTintColor:lblRGBA(255, 206, 52, 1)];
    }
    view_DetailViewTimeLine.hidden=NO;
}

-(void)showDetailView_WithDetailsOthers:(int)tagVal
{
    selectedTag = tagVal;
    deviceTypes=@"other";
    self.img_detailView.image=[UIImage imageNamed:[[arrOthers objectAtIndex:tagVal] objectForKey:@"Image"]];
    self.lbl_deviceName.text=[[arrOthers objectAtIndex:tagVal] objectForKey:@"Name"];
    self.lbl_ScheduleName.text=[[arrOthers objectAtIndex:tagVal] objectForKey:@"ScheduleName"];
    //[swtchLight setOn:YES animated:NO];
    if([[[arrOthers objectAtIndex:tagVal] objectForKey:@"Status"] isEqualToString:@"OFF"]){
        [swtchLight setOn:NO animated:NO];
        [swtchLight setThumbTintColor:lblRGBA(98, 99, 102, 1)];
        view_Profile_Header.backgroundColor=lblRGBA(98, 99, 102, 1);
    }else
    {
        [swtchLight setOn:YES animated:NO];
        view_Profile_Header.backgroundColor=lblRGBA(49, 165, 222, 1);
        [swtchLight setThumbTintColor:lblRGBA(49, 165, 222, 1)];
        
    }
    view_DetailViewTimeLine.hidden=NO;
}
-(void)showDetailView_WithDetailsSprinklers:(int)tagVal
{
    selectedTag = tagVal;
    deviceTypes=@"sprinkler";
    self.img_detailView.image=[UIImage imageNamed:[[arrSprinkler objectAtIndex:tagVal] objectForKey:@"Image"]];
    self.lbl_deviceName.text=[[arrSprinkler objectAtIndex:tagVal] objectForKey:@"Name"];
    self.lbl_ScheduleName.text=[[arrSprinkler objectAtIndex:tagVal] objectForKey:@"ScheduleName"];
    //[swtchLight setOn:YES animated:NO];
    if([[[arrSprinkler objectAtIndex:tagVal] objectForKey:@"Status"] isEqualToString:@"OFF"]){
        [swtchLight setOn:NO animated:NO];
        [swtchLight setThumbTintColor:lblRGBA(98, 99, 102, 1)];
        view_Profile_Header.backgroundColor=lblRGBA(98, 99, 102, 1);
    }else
    {
        [swtchLight setOn:YES animated:NO];
        view_Profile_Header.backgroundColor=lblRGBA(136, 197, 65, 1);
        [swtchLight setThumbTintColor:lblRGBA(136, 197, 65, 1)];
    }
    view_DetailViewTimeLine.hidden=NO;
}

#pragma mark - UITapGesture Methods
-(void)hidePopUp_onTouch_TimeLine
{
    tapHeader_TimeLine = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapHeader_TimeLine:)];
    [self.view_HeaderViewTimeLine addGestureRecognizer:tapHeader_TimeLine];
    tapBodyView_TimeLine = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapBodyView_TimeLine:)];
    [self.view_BodyViewTimeLine addGestureRecognizer:tapBodyView_TimeLine];
    tapTitleView_TimeLine = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapTitleView_TimeLine:)];
    [self.view_TitleViewTimeLine addGestureRecognizer:tapTitleView_TimeLine];
}

-(void)removeTapGesture_TimeLine
{
    [self.view_HeaderViewTimeLine removeGestureRecognizer:tapHeader_TimeLine];
    [self.view_BodyViewTimeLine removeGestureRecognizer:tapBodyView_TimeLine];
   // [self.view_DetailViewTimeLine removeGestureRecognizer:tapDetailView_TimeLine];
}

-(void)ViewTapHeader_TimeLine:(UITapGestureRecognizer *)recognizer{
    [self checkPopUp_DismissedOrNot];
    [self enable_disable_DetailView];
}

-(void)ViewTapBodyView_TimeLine:(UITapGestureRecognizer *)recognizer{
    [self checkPopUp_DismissedOrNot];
    [self enable_disable_DetailView];
}

-(void)ViewTapTitleView_TimeLine:(UITapGestureRecognizer *)recognizer{
    [self checkPopUp_DismissedOrNot];
    [self enable_disable_DetailView];
}

#pragma mark - IBActions
-(IBAction)switch_Actions_TimeLine:(id)sender
{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    if([sender isOn]){
        NSLog(@"Switch is ON");
        
        if([deviceTypes isEqualToString:@"light"])
        {
            view_Profile_Header .backgroundColor=lblRGBA(255, 206, 52, 1);
            [swtchLight setThumbTintColor:lblRGBA(255, 206, 52, 1)];
            [dict setObject:[[arrLights objectAtIndex:selectedTag] objectForKey:@"DeviceType"] forKey:@"DeviceType"];
            [dict setObject:[[arrLights objectAtIndex:selectedTag] objectForKey:@"Time"] forKey:@"Time"];
            [dict setObject:[[arrLights objectAtIndex:selectedTag] objectForKey:@"Name"] forKey:@"Name"];
            [dict setObject:[[arrLights objectAtIndex:selectedTag] objectForKey:@"ScheduleName"] forKey:@"ScheduleName"];
            [dict setObject:[[arrLights objectAtIndex:selectedTag] objectForKey:@"Image"] forKey:@"Image"];
            [dict setObject:[[arrLights objectAtIndex:selectedTag] objectForKey:@"Id"] forKey:@"Id"];
            [dict setObject:@"ON" forKey:@"Status"];
            [arrLights replaceObjectAtIndex:selectedTag withObject:dict];
        }else if([deviceTypes isEqualToString:@"other"])
        {
            view_Profile_Header.backgroundColor=lblRGBA(49, 165, 222, 1);
            [swtchLight setThumbTintColor:lblRGBA(49, 165, 222, 1)];
            [dict setObject:[[arrOthers objectAtIndex:selectedTag] objectForKey:@"DeviceType"] forKey:@"DeviceType"];
            [dict setObject:[[arrOthers objectAtIndex:selectedTag] objectForKey:@"Time"] forKey:@"Time"];
            [dict setObject:[[arrOthers objectAtIndex:selectedTag] objectForKey:@"Name"] forKey:@"Name"];
            [dict setObject:[[arrOthers objectAtIndex:selectedTag] objectForKey:@"ScheduleName"] forKey:@"ScheduleName"];
            [dict setObject:[[arrOthers objectAtIndex:selectedTag] objectForKey:@"Image"] forKey:@"Image"];
            [dict setObject:[[arrOthers objectAtIndex:selectedTag] objectForKey:@"Id"] forKey:@"Id"];
            [dict setObject:@"ON" forKey:@"Status"];
            [arrOthers replaceObjectAtIndex:selectedTag withObject:dict];
        }
        else{
            view_Profile_Header.backgroundColor=lblRGBA(136, 197, 65, 1);
            [swtchLight setThumbTintColor:lblRGBA(136, 197, 65, 1)];
            
            [dict setObject:[[arrSprinkler objectAtIndex:selectedTag] objectForKey:@"DeviceType"] forKey:@"DeviceType"];
            [dict setObject:[[arrSprinkler objectAtIndex:selectedTag] objectForKey:@"Time"] forKey:@"Time"];
            [dict setObject:[[arrSprinkler objectAtIndex:selectedTag] objectForKey:@"Name"] forKey:@"Name"];
            [dict setObject:[[arrSprinkler objectAtIndex:selectedTag] objectForKey:@"ScheduleName"] forKey:@"ScheduleName"];
            [dict setObject:[[arrSprinkler objectAtIndex:selectedTag] objectForKey:@"Image"] forKey:@"Image"];
            [dict setObject:[[arrSprinkler objectAtIndex:selectedTag] objectForKey:@"Id"] forKey:@"Id"];
            [dict setObject:@"ON" forKey:@"Status"];
            [arrSprinkler replaceObjectAtIndex:selectedTag withObject:dict];
        }
        
        
        
    } else{
        NSLog(@"Switch is OFF");
        [swtchLight setThumbTintColor:lblRGBA(98, 99, 102, 1)];
        view_Profile_Header.backgroundColor=lblRGBA(98, 99, 102, 1);
        if([deviceTypes isEqualToString:@"light"])
        {
            [dict setObject:[[arrLights objectAtIndex:selectedTag] objectForKey:@"DeviceType"] forKey:@"DeviceType"];
            [dict setObject:[[arrLights objectAtIndex:selectedTag] objectForKey:@"Time"] forKey:@"Time"];
            [dict setObject:[[arrLights objectAtIndex:selectedTag] objectForKey:@"Name"] forKey:@"Name"];
            [dict setObject:[[arrLights objectAtIndex:selectedTag] objectForKey:@"ScheduleName"] forKey:@"ScheduleName"];
            [dict setObject:[[arrLights objectAtIndex:selectedTag] objectForKey:@"Image"] forKey:@"Image"];
            [dict setObject:[[arrLights objectAtIndex:selectedTag] objectForKey:@"Id"] forKey:@"Id"];
            [dict setObject:@"OFF" forKey:@"Status"];
            [arrLights replaceObjectAtIndex:selectedTag withObject:dict];
        }
        else if([deviceTypes isEqualToString:@"light"])
        {
            [dict setObject:[[arrOthers objectAtIndex:selectedTag] objectForKey:@"DeviceType"] forKey:@"DeviceType"];
            [dict setObject:[[arrOthers objectAtIndex:selectedTag] objectForKey:@"Time"] forKey:@"Time"];
            [dict setObject:[[arrOthers objectAtIndex:selectedTag] objectForKey:@"Name"] forKey:@"Name"];
            [dict setObject:[[arrOthers objectAtIndex:selectedTag] objectForKey:@"ScheduleName"] forKey:@"ScheduleName"];
            [dict setObject:[[arrOthers objectAtIndex:selectedTag] objectForKey:@"Image"] forKey:@"Image"];
            [dict setObject:[[arrOthers objectAtIndex:selectedTag] objectForKey:@"Id"] forKey:@"Id"];
            [dict setObject:@"OFF" forKey:@"Status"];
            [arrOthers replaceObjectAtIndex:selectedTag withObject:dict];
        }else{
            [dict setObject:[[arrSprinkler objectAtIndex:selectedTag] objectForKey:@"DeviceType"] forKey:@"DeviceType"];
            [dict setObject:[[arrSprinkler objectAtIndex:selectedTag] objectForKey:@"Time"] forKey:@"Time"];
            [dict setObject:[[arrSprinkler objectAtIndex:selectedTag] objectForKey:@"Name"] forKey:@"Name"];
            [dict setObject:[[arrSprinkler objectAtIndex:selectedTag] objectForKey:@"ScheduleName"] forKey:@"ScheduleName"];
            [dict setObject:[[arrSprinkler objectAtIndex:selectedTag] objectForKey:@"Image"] forKey:@"Image"];
            [dict setObject:[[arrSprinkler objectAtIndex:selectedTag] objectForKey:@"Id"] forKey:@"Id"];
            [dict setObject:@"OFF" forKey:@"Status"];
            [arrSprinkler replaceObjectAtIndex:selectedTag withObject:dict];
        }
    }
}

-(IBAction)openClose_Alert_TimeLine_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //back
        {
            strStatusCheck=@"";
            view_HeaderViewTimeLine.alpha=0.6;
            view_BodyViewTimeLine.alpha=0.6;
            view_DetailViewTimeLine.alpha=0.6;
            [TimelineAlert setHidden:NO];
        }
            break;
        case 1: //close
        {
            view_HeaderViewTimeLine.alpha=1.0;
            view_BodyViewTimeLine.alpha=1.0;
            view_DetailViewTimeLine.alpha=1.0;
            [TimelineAlert setHidden:YES];
            strStatusCheck=@"";
        }
            break;
        case 2: //noid logo
        {
            view_HeaderViewTimeLine.alpha=0.6;
            view_BodyViewTimeLine.alpha=0.6;
            view_DetailViewTimeLine.alpha=0.6;
            strStatusCheck=@"NETWORKHOME";
            [TimelineAlert setHidden:NO];
//            [self processCompleteTimeLine];
        }
            break;
        case 3: //view device
        {
            strStatusCheck=@"VIEWDEVICE";
            view_HeaderViewTimeLine.alpha=0.6;
            view_BodyViewTimeLine.alpha=0.6;
            view_DetailViewTimeLine.alpha=0.6;
            [TimelineAlert setHidden:NO];
        }
    }
}

-(void)checkPopUp_DismissedOrNot
{
//    if (lightsPopUpViewStatus==NO) {
//        [view_InnerShade setHidden:YES];
//        [view_OuterShade setHidden:YES];
//        [view_Popup setHidden:YES];
//        lightsPopUpViewStatus=YES;
//    }else if (otherPopUpViewStatus==NO){
//        [view_InnerShade_other setHidden:YES];
//        [view_OuterShade_other setHidden:YES];
//        [view_popUp_other setHidden:YES];
//        otherPopUpViewStatus=YES;
//    }else{
//        [view_InnerShade_sprinkler setHidden:YES];
//        [view_OuterShade_sprinkler setHidden:YES];
//        [view_popUp_Sprinkler setHidden:YES];
//        sprinklerPopUpViewStatus=YES;
//    }
}

-(void)enable_disable_DetailView
{
    if (lightsPopUpViewStatus==NO || otherPopUpViewStatus==NO || sprinklerPopUpViewStatus==NO) {
        [view_DetailViewTimeLine setHidden:NO];
        [btn_PreviousInTimeLine setHidden:NO];
        [btn_PreviousInDetailTimeLine setHidden:NO];
        [btn_NextInTimeLine setHidden:NO];
        [btn_NextInDetailTimeLine setHidden:NO];
        [self hidePopUp_onTouch_TimeLine];
    }else{
        [view_DetailViewTimeLine setHidden:YES];
        [btn_PreviousInTimeLine setHidden:YES];
        [btn_PreviousInDetailTimeLine setHidden:YES];
        [btn_NextInTimeLine setHidden:YES];
        [btn_NextInDetailTimeLine setHidden:YES];
        [self removeTapGesture_TimeLine];
    }
}

-(IBAction)changeDeviceProfile_onClick_Action:(id)sender
{
//    UIButton *btntag = (UIButton *)sender;
//    lbl_deviceName.text = [sender titleForState:UIControlStateNormal];
//    if (lightsPopUpViewStatus==NO) {
//        img_detailView.image = [arr_imgLightDevice objectAtIndex:btntag.tag];
//    }else if (otherPopUpViewStatus==NO){
//        img_detailView.image = [arr_imgOtherDevice objectAtIndex:btntag.tag];
//    }else{
//        img_detailView.image = [arr_imgSprinklerDevice objectAtIndex:btntag.tag];
//    }
}

-(IBAction)back_Action_InTimeLine:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        //[bodyView setHidden:YES];
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationMaskPortrait] forKey:@"orientation"];
        [Common viewFadeIn:self.navigationController.view];
        [self.navigationController popViewControllerAnimated:YES];
       
    });
}
-(IBAction)networkhome_Welcome_ActionInTimeLine:(id)sender{
    SWRevealViewController *NHVC = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
    NHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self.navigationController pushViewController:NHVC animated:YES];
}

#pragma mark - Orientation
/* **********************************************************************************
 Date : 24/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Set the Orientation of the view
 Method Name : shouldAutorotate(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)shouldAutorotate
{
    return NO;
    
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate.strLaunchOrientation isEqualToString:@"YES"]) {
        return YES;
    }
   return   UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortraitUpsideDown;
    //return here which orientation you are going to support
}
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        [self dismiss_TimeLine];
    }
    else if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait) {
        [self dismiss_TimeLine];
    }
}
-(void)dismiss_TimeLine{
    NSLog(@"status==%@",strStatusCheck);
    NSLog(@"noid logo status==%@",strNoidLogo_Status);
    if([strStatusCheck isEqualToString:@"NETWORKHOME"]){
        NSLog(@"push");
        if ([strNoidLogo_Status isEqualToString:@"networkHome"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self processCompleteTimeLine];
            });
        }else{
            SWRevealViewController *NHVC = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
            NHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            [self.navigationController pushViewController:NHVC animated:NO];
        }
    }else if ([strStatusCheck isEqualToString:@"VIEWDEVICE"]){
        LightsViewController *LVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LightsViewController"];
        LVC.strDeviceType=@"lights";
        NSArray *newStack = @[LVC];
        [self.navigationController setViewControllers:newStack animated:YES];
    }
    else{
        NSLog(@"pop");
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)processCompleteTimeLine{
    [[self delegate] processSuccessful_Back_To_TimeLine:YES];
    [Common viewFadeIn:self.navigationController.view];
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - PinWheel Methods
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : This method is called to start the Progress HUD
 Method Name : start_PinWheel_Registeration(User Defined Method)
 ************************************************************************************* */
-(void)start_PinWheel_TimeLine{
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
-(void)stop_PinWheel_TimeLine{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
}


@end
