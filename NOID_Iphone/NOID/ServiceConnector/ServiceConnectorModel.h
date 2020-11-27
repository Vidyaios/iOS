//
//  ServiceConnectorModel.h
//  CardShare
//
//  Created by iExemplar on 2/25/15.
//  Copyright (c) 2015 iExemplar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "Utils.h"
@interface ServiceConnectorModel : NSObject
{
    NSUserDefaults *defaults;
}
-(void) serviceConnector:(NSDictionary *)parameters andMethodName:(NSString *)methodName;
-(void) serviceConnectorPUT:(NSDictionary *)parameters andMethodName:(NSString *)methodName;
-(void) serviceConnectorGET:(NSString *)methodName;
-(void) serviceConnectorDELETE:(NSString *)methodName;

-(NSDictionary *) registerationList:(NSMutableDictionary *)dictRegisteration_Details;
-(NSDictionary *) signinList:(NSDictionary *)dictSignIn_Details;
-(NSDictionary *) controllerAvailabilty:(NSDictionary *)dictController_Details;
-(NSDictionary *) controller_Add_Device_Details:(NSDictionary *)dictController_Device_Details;
-(NSDictionary *) controller_Add:(NSDictionary *)dictController;
-(NSDictionary *) controller_Add_Wifi:(NSDictionary *)dictController;
-(NSDictionary *) controller_Update_Device_Details:(NSDictionary *)dictController_Device_Details;
-(NSDictionary *) add_Lights_Others_Device_Details:(NSDictionary *)dictController_Device_Details;
-(NSDictionary *) update_Noid_Device_Details:(NSDictionary *)dictController_Device_Details;
-(NSDictionary *) userSettingsUpdate:(NSDictionary *)dictUserDetails;
-(NSDictionary *) addCreditCardDetails:(NSDictionary *)dictCardDetails;
-(NSDictionary *) updateCreditCardDetails:(NSDictionary *)dictCardDetails;
-(NSDictionary *) scheduleAddDevice:(NSDictionary *)dictDetails;
-(NSDictionary *) scheduleUpdateDevice:(NSDictionary *)dictDetails;
-(NSDictionary *)addUserMangementSettings:(NSDictionary *)dictCardDetails;
-(NSDictionary *) updateScheduleName:(NSDictionary *)dictDetails;
-(NSDictionary *)updateUserAccountDetails:(NSDictionary *)dictusermanagement;
-(NSDictionary *) resetPassword:(NSDictionary *)dictResetPassword;
-(NSDictionary *) sendGridMailTC:(NSDictionary *)dictTC;
-(NSDictionary *) controller_WifiAdd_Device_Details:(NSDictionary *)dictController_Device_Details;
-(NSDictionary *) accpetNetworksShared:(NSDictionary *)dictDetails;
-(NSDictionary *)updateUserAccName:(NSDictionary *)dictDetails;
-(NSDictionary *)signOut:(NSDictionary *)dictDetails;
-(NSDictionary *) device_Status_Update:(NSDictionary *)dict_Device_Status;
-(NSDictionary *) device_Category_Update:(NSDictionary *)dict_Device_Status;
-(NSDictionary *) device_Mode_Update:(NSDictionary *)dict_Device_Mode;
-(NSDictionary *) upgrade_Plan:(NSDictionary *)dict_Plan;
-(NSDictionary *) upgrade_Device_Plan:(NSDictionary *)dict_Plan;
-(NSDictionary *) downgrade_Plan:(NSDictionary *)dict_Plan;
-(NSDictionary *) downgrade_Device_Plan:(NSDictionary *)dict_Plan;
-(NSDictionary *)update_PropertyDeviceLocation:(NSDictionary *)dictDetails;
-(NSDictionary *)update_Property_MapImage:(NSDictionary *)dict_Property_Image;
-(NSDictionary *)update_Read_Message_Status:(NSDictionary *)dictReadMsg_Update;
-(NSDictionary *) add_Sprinkler_Device_Details:(NSDictionary *)dictController_Device_Details;
-(NSDictionary *) additional_Sprinkler_Device_Details:(NSDictionary *)dictController_Device_Details;
-(NSDictionary *) update_Noid_Zone_Details:(NSDictionary *)dictController_Device_Details;
-(NSDictionary *) zone_Status_Update:(NSDictionary *)dict_Device_Status;
-(NSDictionary *)addSprinklerSchedule:(NSDictionary *)dictDetails;
-(NSDictionary *)updateSprinklerSchedule:(NSDictionary *)dictDetails;
-(NSDictionary *) zone_ON_OFF_Status:(NSDictionary *)dict_Zone_ON_OFF;
@property (nonatomic, copy) formCallbackVoid callbackVoid;
@property (nonatomic, copy) formCallbackString callbackString;
@property (nonatomic, copy) formCallbackDictionary callbackValue;

-(void) serviceConnectorGETTEST:(NSString *)methodName;

@end
