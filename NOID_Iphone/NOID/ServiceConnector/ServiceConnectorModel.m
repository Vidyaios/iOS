//
//  ServiceConnectorModel.m
//  CardShare
//
//  Created by iExemplar on 2/25/15.
//  Copyright (c) 2015 iExemplar. All rights reserved.
//

#import "ServiceConnectorModel.h"
#import "Common.h"
#define _AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_ 1
@implementation ServiceConnectorModel
@synthesize callbackValue=_callbackValue;
@synthesize callbackString=_callbackString;
-(void) serviceConnector:(NSDictionary *)parameters andMethodName:(NSString *)methodName
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSURL *baseURL = [NSURL URLWithString:[defaults objectForKey:@"NOIDURL"]];
    NSLog(@"param==%@",parameters);
    NSLog(@"method name ==%@",methodName);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setTimeoutInterval:20.0];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:methodName parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *responseStatus_Code = (NSHTTPURLResponse *)task.response;
        NSLog(@"Response statusCode: %li", (long)responseStatus_Code.statusCode);
        if(responseStatus_Code.statusCode==200){
            NSMutableDictionary *response=(NSMutableDictionary *)responseObject;
            NSLog(@"meesage==%@",response);
            [self responseMSG:response];
        }else{
            [self resError:[NSString stringWithFormat:@"%li",(long)responseStatus_Code.statusCode]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error.code==NSURLErrorTimedOut) {
            NSLog(@"Time out");
        }
        NSLog(@"error  %@",[error localizedDescription]);
        // [self resError];
        [self resError:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
    }];
    NSLog(@"manager==%@",manager);
}
-(void) serviceConnectorPUT:(NSDictionary *)parameters andMethodName:(NSString *)methodName
{
    // NSURL *baseURL = [NSURL URLWithString:getNoidAppUrl];
    defaults=[NSUserDefaults standardUserDefaults];
    NSURL *baseURL = [NSURL URLWithString:[defaults objectForKey:@"NOIDURL"]];
    NSLog(@"param==%@",parameters);
    NSLog(@"method name ==%@",methodName);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setTimeoutInterval:20.0];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager PUT:methodName parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *responseStatus_Code = (NSHTTPURLResponse *)task.response;
        NSLog(@"Response statusCode: %li", (long)responseStatus_Code.statusCode);
        if(responseStatus_Code.statusCode==200){
            NSMutableDictionary *response=(NSMutableDictionary *)responseObject;
            NSLog(@"meesage==%@",response);
            [self responseMSG:response];
        }else{
            [self resError:[NSString stringWithFormat:@"%li",(long)responseStatus_Code.statusCode]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error.code==NSURLErrorTimedOut) {
            NSLog(@"Time out");
        }
        NSLog(@"error  %@",[error localizedDescription]);
        // [self resError];
        [self resError:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
    }];
    NSLog(@"manager==%@",manager);
}
-(void) serviceConnectorGET:(NSString *)methodName
{
    // NSURL *baseURL = [NSURL URLWithString:getNoidAppUrl];
    defaults=[NSUserDefaults standardUserDefaults];
    NSURL *baseURL = [NSURL URLWithString:[defaults objectForKey:@"NOIDURL"]];
    NSLog(@"URL==%@",baseURL);
    NSLog(@"methodname==%@",methodName);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setTimeoutInterval:20.0];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:methodName parameters:@"" success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *responseStatus_Code = (NSHTTPURLResponse *)task.response;
        NSLog(@"Response statusCode: %li", (long)responseStatus_Code.statusCode);
        if(responseStatus_Code.statusCode==200){
            NSMutableDictionary *response=(NSMutableDictionary *)responseObject;
            NSLog(@"meesage==%@",response);
            [self responseMSG:response];
        }else{
            [self resError:[NSString stringWithFormat:@"%li",(long)responseStatus_Code.statusCode]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error.code==NSURLErrorTimedOut) {
            NSLog(@"Time out");
        }
        NSLog(@"error  %@",[error localizedDescription]);
        [self resError:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
    }];
}

-(void) serviceConnectorDELETE:(NSString *)methodName
{
    
    //  NSURL *baseURL = [NSURL URLWithString:getNoidAppUrl];
    defaults=[NSUserDefaults standardUserDefaults];
    NSURL *baseURL = [NSURL URLWithString:[defaults objectForKey:@"NOIDURL"]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setTimeoutInterval:20.0];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager DELETE:methodName parameters:@"" success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *responseStatus_Code = (NSHTTPURLResponse *)task.response;
        NSLog(@"Response statusCode: %li", (long)responseStatus_Code.statusCode);
        if(responseStatus_Code.statusCode==200){
            NSMutableDictionary *response=(NSMutableDictionary *)responseObject;
            NSLog(@"meesage==%@",response);
            [self responseMSG:response];
        }else{
            [self resError:[NSString stringWithFormat:@"%li",(long)responseStatus_Code.statusCode]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error.code==NSURLErrorTimedOut) {
            NSLog(@"Time out");
        }
        NSLog(@"error  %@",[error localizedDescription]);
        // [self resError];
        [self resError:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
    }];
    NSLog(@"manager==%@",manager);
}


-(void)responseMSG :(NSMutableDictionary *)response{
    _callbackValue(response);
}
-(void)resError:(NSString *)errorString
{
    //  _callbackVoid();
    _callbackString(errorString);
}

//All JSON
//JSON Request Registeration
-(NSDictionary *) registerationList:(NSDictionary *)dictRegisteration_Details
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictRegisteration_Details valueForKey:kFirstName] forKey:@"firstName"];
    [parameters setObject:[dictRegisteration_Details valueForKey:kLastName] forKey:@"lastName"];
    [parameters setObject:[dictRegisteration_Details valueForKey:kEmailID] forKey:@"email"];
    [parameters setObject:[dictRegisteration_Details valueForKey:kPassword] forKey:@"password"];
    [parameters setObject:[dictRegisteration_Details valueForKey:kDeviceToken] forKey:@"tokenId"];
    [parameters setObject:[dictRegisteration_Details valueForKey:kDeviceToken] forKey:@"tokenMacId"];
    [parameters setObject:[dictRegisteration_Details valueForKey:kLong] forKey:@"longitude"];
    [parameters setObject:[dictRegisteration_Details valueForKey:kLat] forKey:@"latitude"];
    [parameters setObject:[dictRegisteration_Details valueForKey:kInAppStatus] forKey:@"inAppStatus"];
    [parameters setObject:[dictRegisteration_Details valueForKey:KTimeZone] forKey:@"timeZone"];
    [parameters setObject:[dictRegisteration_Details valueForKey:kLanguage] forKey:@"language"];
    [parameters setObject:[dictRegisteration_Details valueForKey:kTemperatureType] forKey:@"temperatureType"];
    [parameters setObject:[dictRegisteration_Details valueForKey:kYearFormat] forKey:@"dateFormat"];
    [parameters setObject:[dictRegisteration_Details valueForKey:kOrgTimeZone] forKey:@"timeZoneId"];
    
    
    NSMutableDictionary *tokenType= [[NSMutableDictionary alloc] init];
    [tokenType setObject:[dictRegisteration_Details valueForKey:kTokenType] forKey:@"id"];
    [parameters setObject:tokenType forKey:@"tokenType"];

    return parameters;
}
/*
 ￼￼"id": 1005,
 ￼"firstName": "first n",
 ￼"lastName": "last n",
 ￼"email": "email15@g.com",
 ￼"temperatureType": "c",
 ￼"inAppStatus": 1,
 ￼"timeZone": "asia/kolkatta",
 ￼"language": "english",
 ￼"latitude": 0,
 ￼"longitude": 0
 ￼}
 */

//JSON Request Update User Settings
-(NSDictionary *) userSettingsUpdate:(NSDictionary *)dictUserDetails
{
    defaults=[NSUserDefaults standardUserDefaults];

    NSDictionary *parameters = @{@"id":[dictUserDetails valueForKey:kAccountID],
                                 @"firstName":[dictUserDetails valueForKey:kFirstName],
                                 @"lastName": [dictUserDetails valueForKey:kLastName],
                                 @"email":[dictUserDetails valueForKey:kEmailID],
                                 @"temperatureType":[dictUserDetails valueForKey:kTemperatureType],
                                 @"inAppStatus":[dictUserDetails valueForKey:kInAppStatus],
                                 @"timeZone":[dictUserDetails valueForKey:KTimeZone],
                                 @"language":[dictUserDetails valueForKey:kLanguage],
                                 @"latitude":[dictUserDetails valueForKey:kLat],
                                 @"longitude":[dictUserDetails valueForKey:kLong],
                                 @"timeZoneId":[dictUserDetails valueForKey:kOrgTimeZone]
                                 };
    return parameters;
}


//JSON Request Registeration
-(NSDictionary *) signinList:(NSDictionary *)dictSignIn_Details
{
//    defaults=[NSUserDefaults standardUserDefaults];
//    NSDictionary *parameters = @{@"email":[dictSignIn_Details valueForKey:kEmailID],
//                                 @"password":[dictSignIn_Details valueForKey:kPassword]
//                                 };
//    return parameters;
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictSignIn_Details valueForKey:kEmailID] forKey:@"email"];
    [parameters setObject:[dictSignIn_Details valueForKey:kPassword] forKey:@"password"];
    [parameters setObject:[dictSignIn_Details valueForKey:kDeviceToken] forKey:@"tokenId"];
    [parameters setObject:[dictSignIn_Details valueForKey:kDeviceToken] forKey:@"tokenMacId"];
    NSMutableDictionary *tokenType= [[NSMutableDictionary alloc] init];
    [tokenType setObject:[dictSignIn_Details valueForKey:kTokenType] forKey:@"id"];
    [parameters setObject:tokenType forKey:@"tokenType"];
    
    NSLog(@"%@",parameters);
    return parameters;
}

//JSON Request Reset Password
-(NSDictionary *) resetPassword:(NSDictionary *)dictResetPassword
{
    NSLog(@"dict ==%@",dictResetPassword);
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictResetPassword valueForKey:kEmailID] forKey:@"email"];
    NSLog(@"%@",parameters);
    
    return parameters;
}

//JSON Request Terms and conditions
-(NSDictionary *) sendGridMailTC:(NSDictionary *)dictTC
{
    NSDictionary *parameters = @{@"emailAddress":[dictTC valueForKey:kEmailID],
                                 @"emailType":[dictTC valueForKey:kEmailType]
                                 };
    return parameters;
}

//JSON Request Controller Availability
-(NSDictionary *) controllerAvailabilty:(NSDictionary *)dictController_Details
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"controllerId":[dictController_Details valueForKey:kControllerID]
                                 };
    return parameters;
}


//JSON Request ADD WIFI Controller Device Details
-(NSDictionary *) controller_WifiAdd_Device_Details:(NSDictionary *)dictController_Device_Details
{
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictController_Device_Details valueForKey:kDeviceName] forKey:@"name"];
    [parameters setObject:[dictController_Device_Details valueForKey:kDeviceImage] forKey:@"image"];
    [parameters setObject:[dictController_Device_Details valueForKey:KThumbnailImage] forKey:@"thumbnailImage"];
    NSMutableDictionary *controllerTrace= [[NSMutableDictionary alloc] init];
    [controllerTrace setObject:[dictController_Device_Details valueForKey:kControllerID] forKey:@"id"];
    [parameters setObject:controllerTrace forKey:@"controllerTrace"];
    NSLog(@"%@",parameters);
    return parameters;
    
}

//JSON Request ADD Controller Device Details
-(NSDictionary *) controller_Add_Device_Details:(NSDictionary *)dictController_Device_Details
{
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictController_Device_Details valueForKey:kDeviceName] forKey:@"name"];
    [parameters setObject:[dictController_Device_Details valueForKey:kDeviceImage] forKey:@"image"];
    [parameters setObject:[dictController_Device_Details valueForKey:KThumbnailImage] forKey:@"thumbnailImage"];
    
    NSMutableDictionary *controllerTrace= [[NSMutableDictionary alloc] init];
    [controllerTrace setObject:[dictController_Device_Details valueForKey:kControllerID] forKey:@"id"];
    [parameters setObject:controllerTrace forKey:@"controllerTrace"];
    
    NSMutableDictionary *billing= [[NSMutableDictionary alloc] init];
    [billing setObject:[dictController_Device_Details valueForKey:kBillingPlanID] forKey:@"id"];
    [parameters setObject:billing forKey:@"billingPlan"];
    NSLog(@"%@",parameters);
    return parameters;
}
//JSON Request ADD Controller Device Details
-(NSDictionary *) controller_Update_Device_Details:(NSDictionary *)dictController_Device_Details
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictController_Device_Details valueForKey:kDeviceName] forKey:@"name"];
    [parameters setObject:[dictController_Device_Details valueForKey:kDeviceImage] forKey:@"image"];
    [parameters setObject:[dictController_Device_Details valueForKey:KThumbnailImage] forKey:@"thumbnailImage"];
    [parameters setObject:[dictController_Device_Details valueForKey:kNetworkID] forKey:@"id"];
    NSLog(@"%@",parameters);
    return parameters;
}
//JSON Request ADD Cellular Controller
-(NSDictionary *) controller_Add:(NSDictionary *)dictController
{
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    
    //create network object
    NSMutableDictionary *dict_Sub_OBJ= [[NSMutableDictionary alloc] init];
    [dict_Sub_OBJ setObject:[dictController valueForKey:kNetworkID] forKey:@"id"];
    //attach the object
    [parameters setObject:dict_Sub_OBJ forKey:@"network"];
    //create billing object
    dict_Sub_OBJ= [[NSMutableDictionary alloc] init];
    [dict_Sub_OBJ setObject:[dictController valueForKey:kBillingPlanID] forKey:@"id"];
    //attach the object
    [parameters setObject:dict_Sub_OBJ forKey:@"billingPlan"];
    //create controller trace id
    dict_Sub_OBJ= [[NSMutableDictionary alloc] init];
    [dict_Sub_OBJ setObject:[dictController valueForKey:kControllerID] forKey:@"id"];
    //attach the object
    [parameters setObject:dict_Sub_OBJ forKey:@"controllerTrace"];
    
    NSLog(@"%@",parameters);
    return parameters;
}
//JSON Request ADD Wifi Controller
-(NSDictionary *) controller_Add_Wifi:(NSDictionary *)dictController
{
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    
    //create network object
    NSMutableDictionary *dict_Sub_OBJ= [[NSMutableDictionary alloc] init];
    [dict_Sub_OBJ setObject:[dictController valueForKey:kNetworkID] forKey:@"id"];
    //attach the object
    [parameters setObject:dict_Sub_OBJ forKey:@"network"];
    //create controller trace id
    dict_Sub_OBJ= [[NSMutableDictionary alloc] init];
    [dict_Sub_OBJ setObject:[dictController valueForKey:kControllerID] forKey:@"id"];
    //attach the object
    [parameters setObject:dict_Sub_OBJ forKey:@"controllerTrace"];
    
    NSLog(@"%@",parameters);
    return parameters;
}

//JSON Request ADD Lights / Others  Device Details
-(NSDictionary *) add_Lights_Others_Device_Details:(NSDictionary *)dictController_Device_Details
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictController_Device_Details valueForKey:kDeviceName] forKey:@"name"];
    [parameters setObject:[dictController_Device_Details valueForKey:kDeviceImage] forKey:@"image"];
    [parameters setObject:[dictController_Device_Details valueForKey:KThumbnailImage] forKey:@"thumbnailImage"];
    //create Device Trace object
    NSMutableDictionary *account= [[NSMutableDictionary alloc] init];
    [account setObject:[dictController_Device_Details valueForKey:kDeviceTraceID] forKey:@"id"];
    //attach the object
    [parameters setObject:account forKey:@"deviceTrace"];
    
    //create Device Mode object
    NSMutableDictionary *deviceMode= [[NSMutableDictionary alloc] init];
    [deviceMode setObject:[dictController_Device_Details valueForKey:kDeviceMode] forKey:@"id"];
    //attach the object
    [parameters setObject:deviceMode forKey:@"deviceMode"];
    
    //create Device Status object
    NSMutableDictionary *deviceStatus= [[NSMutableDictionary alloc] init];
    [deviceStatus setObject:[dictController_Device_Details valueForKey:kDeviceStatus] forKey:@"id"];
    //attach the object
    [parameters setObject:deviceStatus forKey:@"deviceStatus"];
    
    //create Device Type object
    NSMutableDictionary *deviceType= [[NSMutableDictionary alloc] init];
    [deviceType setObject:[dictController_Device_Details valueForKey:kDeviceType] forKey:@"id"];
    //attach the object
    [parameters setObject:deviceType forKey:@"deviceType"];
    
    NSLog(@"%@",parameters);
    return parameters;
}
//JSON Request Delete Device
-(NSDictionary *) deleteDeviceJSON:(NSDictionary *)dictDevice_Detaitls
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"id":[dictDevice_Detaitls valueForKey:kDeviceID]
                                 };
    return parameters;
}
//JSON Request update_Noid_Device_Details
-(NSDictionary *) update_Noid_Device_Details:(NSDictionary *)dictController_Device_Details
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictController_Device_Details valueForKey:kDeviceName] forKey:@"name"];
    [parameters setObject:[dictController_Device_Details valueForKey:kDeviceImage] forKey:@"image"];
    [parameters setObject:[dictController_Device_Details valueForKey:kDeviceID] forKey:@"id"];
    [parameters setObject:[dictController_Device_Details valueForKey:KThumbnailImage] forKey:@"thumbnailImage"];
    //create weight object
    NSMutableDictionary *account= [[NSMutableDictionary alloc] init];
    [account setObject:[dictController_Device_Details valueForKey:kDeviceTraceID] forKey:@"id"];
    //attach the object
    [parameters setObject:account forKey:@"deviceTrace"];
    NSLog(@"%@",parameters);
    return parameters;
}

-(NSDictionary *) update_Noid_Zone_Details:(NSDictionary *)dictController_Device_Details
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictController_Device_Details valueForKey:kZoneID] forKey:@"id"];
    [parameters setObject:[dictController_Device_Details valueForKey:kZoneName] forKey:@"name"];
    [parameters setObject:@"" forKey:@"image"];
    [parameters setObject:[dictController_Device_Details valueForKey:kZoneThumbnailImage] forKey:@"thumbnailImage"];
    //create weight object
    NSMutableDictionary *zoneStatus= [[NSMutableDictionary alloc] init];
    [zoneStatus setObject:[dictController_Device_Details valueForKey:kZoneStatusID] forKey:@"id"];
    //attach the object
    [parameters setObject:zoneStatus forKey:@"zoneStatus"];
    
    [parameters setObject:[dictController_Device_Details valueForKey:kZoneLevel] forKey:@"zoneLevel"];
    [parameters setObject:[dictController_Device_Details valueForKey:kZoneStatus] forKey:@"status"];

    NSLog(@"%@",parameters);
    return parameters;
}

//JSON Request add Credti Card Detilas
-(NSDictionary *) addCreditCardDetails:(NSDictionary *)dictCardDetails
{
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    // [parameters setObject:[dictCardDetails valueForKey:kCardType] forKey:@"cardType"];
    [parameters setObject:[dictCardDetails valueForKey:kCardName] forKey:@"nameOnCard"];
    [parameters setObject:[dictCardDetails valueForKey:kCardNumber] forKey:@"cardNumber"];
    [parameters setObject:[dictCardDetails valueForKey:kCardExpiryMonth] forKey:@"expiryMonth"];
    [parameters setObject:[dictCardDetails valueForKey:kCardExpiryYear] forKey:@"expiryYear"];
    [parameters setObject:[dictCardDetails valueForKey:kCardCSCCode] forKey:@"cvc"];
    [parameters setObject:[dictCardDetails valueForKey:kCardZipCode] forKey:@"zipCode"];
    NSMutableDictionary *cardType= [[NSMutableDictionary alloc] init];
    [cardType setObject:[dictCardDetails valueForKey:kCardType] forKey:@"id"];
    [parameters setObject:cardType forKey:@"cardType"];
    
    return parameters;
}

//JSON Request add Credti Card Detilas
/*
-(NSDictionary *) updateCreditCardDetails:(NSDictionary *)dictCardDetails
{
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    //  [parameters setObject:[dictCardDetails valueForKey:kCreditCardID] forKey:@"id"];
    // [parameters setObject:[dictCardDetails valueForKey:kCardType] forKey:@"cardType"];
    [parameters setObject:[dictCardDetails valueForKey:kCardName] forKey:@"nameOnCard"];
    [parameters setObject:[dictCardDetails valueForKey:kCardNumber] forKey:@"cardNumber"];
    [parameters setObject:[dictCardDetails valueForKey:kCardExpiryMonth] forKey:@"expiryMonth"];
    [parameters setObject:[dictCardDetails valueForKey:kCardExpiryYear] forKey:@"expiryYear"];
    [parameters setObject:[dictCardDetails valueForKey:kCardCSCCode] forKey:@"cvc"];
    [parameters setObject:[dictCardDetails valueForKey:kCardZipCode] forKey:@"zipCode"];
    NSMutableDictionary *cardType= [[NSMutableDictionary alloc] init];
    [cardType setObject:[dictCardDetails valueForKey:kCardType] forKey:@"id"];
    [parameters setObject:cardType forKey:@"cardType"];
    
    return parameters;
}
 */
-(NSDictionary *) updateCreditCardDetails:(NSDictionary *)dictCardDetails
{
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    //  [parameters setObject:[dictCardDetails valueForKey:kCreditCardID] forKey:@"id"];
    // [parameters setObject:[dictCardDetails valueForKey:kCardType] forKey:@"cardType"];
    [parameters setObject:[dictCardDetails valueForKey:kCardName] forKey:@"nameOnCard"];
    [parameters setObject:[dictCardDetails valueForKey:kCardNumber] forKey:@"cardNumber"];
    [parameters setObject:[dictCardDetails valueForKey:kCardExpiryMonth] forKey:@"expiryMonth"];
    [parameters setObject:[dictCardDetails valueForKey:kCardExpiryYear] forKey:@"expiryYear"];
    [parameters setObject:[dictCardDetails valueForKey:kCardCSCCode] forKey:@"cvc"];
    [parameters setObject:[dictCardDetails valueForKey:kCardZipCode] forKey:@"zipCode"];
    NSMutableDictionary *cardType= [[NSMutableDictionary alloc] init];
    [cardType setObject:[dictCardDetails valueForKey:kCardType] forKey:@"id"];
    [parameters setObject:cardType forKey:@"cardType"];
    
    return parameters;
}
//JSON Request ADD UserManagement Details
-(NSDictionary *)addUserMangementSettings:(NSDictionary *)dictusermanagement{
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictusermanagement valueForKey:kFirstName] forKey:@"firstName"];
    [parameters setObject:[dictusermanagement valueForKey:kLastName] forKey:@"lastName"];
    [parameters setObject:[dictusermanagement valueForKey:kEmailID] forKey:@"email"];
    
    [parameters setObject:[dictusermanagement valueForKey:knetworkid] forKey:@"network"];
    
    NSLog(@"%@",parameters);
    
    return parameters;
}

//

//JSON Request add Schedule Device
-(NSDictionary *) scheduleAddDevice:(NSDictionary *)dictDetails
{
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    //create Device object
    NSMutableDictionary *deviceID= [[NSMutableDictionary alloc] init];
    [deviceID setObject:[dictDetails valueForKey:kDeviceID] forKey:@"id"];
    //attach the Device object
    [parameters setObject:deviceID forKey:@"device"];
    
    //create schdeule object
    NSMutableDictionary *schedule= [[NSMutableDictionary alloc] init];
    [schedule setObject:[dictDetails valueForKey:kscheduleName] forKey:@"scheduleName"];
    
    NSMutableDictionary *controller= [[NSMutableDictionary alloc] init];
    [controller setObject:[dictDetails valueForKey:kControllerID] forKey:@"id"];
    [schedule setObject:controller forKey:@"controller"];
    
    NSMutableDictionary *deviceType= [[NSMutableDictionary alloc] init];
    [deviceType setObject:[dictDetails valueForKey:kDeviceType] forKey:@"id"];
    [schedule setObject:deviceType forKey:@"deviceType"];
    
    NSMutableDictionary *scheduleSetings= [[NSMutableDictionary alloc] init];
    //  NSMutableDictionary *scheduleMonth= [[NSMutableDictionary alloc] init];
    NSMutableDictionary *month= [[NSMutableDictionary alloc] init];
    [month setObject:[dictDetails valueForKey:kJan] forKey:@"january"];
    [month setObject:[dictDetails valueForKey:kFeb] forKey:@"february"];
    [month setObject:[dictDetails valueForKey:kMar] forKey:@"march"];
    [month setObject:[dictDetails valueForKey:kApr] forKey:@"april"];
    [month setObject:[dictDetails valueForKey:kMay] forKey:@"may"];
    [month setObject:[dictDetails valueForKey:kJun] forKey:@"june"];
    [month setObject:[dictDetails valueForKey:kJly] forKey:@"july"];
    [month setObject:[dictDetails valueForKey:kAug] forKey:@"august"];
    [month setObject:[dictDetails valueForKey:kSep] forKey:@"september"];
    [month setObject:[dictDetails valueForKey:kOct] forKey:@"october"];
    [month setObject:[dictDetails valueForKey:kNov] forKey:@"november"];
    [month setObject:[dictDetails valueForKey:kDec] forKey:@"december"];
    [scheduleSetings setObject:month forKey:@"scheduleMonth"];
    
    NSMutableDictionary *day= [[NSMutableDictionary alloc] init];
    [day setObject:[dictDetails valueForKey:kSun] forKey:@"sunday"];
    [day setObject:[dictDetails valueForKey:kMon] forKey:@"monday"];
    [day setObject:[dictDetails valueForKey:kTue] forKey:@"tuesday"];
    [day setObject:[dictDetails valueForKey:kWed] forKey:@"wednesday"];
    [day setObject:[dictDetails valueForKey:kThr] forKey:@"thursday"];
    [day setObject:[dictDetails valueForKey:kFri] forKey:@"friday"];
    [day setObject:[dictDetails valueForKey:kSat] forKey:@"saturday"];
    [day setObject:[dictDetails valueForKey:kOddDay] forKey:@"oddDay"];
    [day setObject:[dictDetails valueForKey:kEvenDay] forKey:@"evenDay"];
    
    [scheduleSetings setObject:day forKey:@"scheduleDay"];
    
    NSMutableDictionary *schTime= [[NSMutableDictionary alloc] init];
    [schTime setObject:[dictDetails valueForKey:kStartTime] forKey:@"startTime"];
    [schTime setObject:[dictDetails valueForKey:kEndTime] forKey:@"endTime"];
    NSMutableDictionary *schCategory= [[NSMutableDictionary alloc] init];
    [schCategory setObject:[dictDetails valueForKey:kScheduleCategoryID] forKey:@"id"];

    [schTime setObject:schCategory forKey:@"scheduleCategory"];
    
    [scheduleSetings setObject:schTime forKey:@"scheduleTime"];
    
    [schedule setObject:scheduleSetings forKey:@"scheduleSetting"];
    
    //attach the schedule object
    [parameters setObject:schedule forKey:@"schedule"];
    
    
    //create Device Mode
//    NSMutableDictionary *deviceMode= [[NSMutableDictionary alloc] init];
//    [deviceMode setObject:[dictDetails valueForKey:kScheduleMode] forKey:@"id"];
//    //attach the Device object
//    [parameters setObject:deviceMode forKey:@"scheduleMode"];
    
    NSLog(@"%@",parameters);
    return parameters;
}

//JSON Request add Schedule Device
-(NSDictionary *) scheduleUpdateDevice:(NSDictionary *)dictDetails
{
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    //create Device object
    NSMutableDictionary *deviceID= [[NSMutableDictionary alloc] init];
    [deviceID setObject:[dictDetails valueForKey:kDeviceID] forKey:@"id"];
    //attach the Device object
    [parameters setObject:deviceID forKey:@"device"];
    
    //create schdeule object
    NSMutableDictionary *schedule= [[NSMutableDictionary alloc] init];
    [schedule setObject:[dictDetails valueForKey:kscheduleName] forKey:@"scheduleName"];
    [schedule setObject:[dictDetails valueForKey:kScheduleID] forKey:@"id"];
    
    NSMutableDictionary *controller= [[NSMutableDictionary alloc] init];
    [controller setObject:[dictDetails valueForKey:kControllerID] forKey:@"id"];
    [schedule setObject:controller forKey:@"controller"];
    
    NSMutableDictionary *deviceType= [[NSMutableDictionary alloc] init];
    [deviceType setObject:[dictDetails valueForKey:kDeviceType] forKey:@"id"];
    [schedule setObject:deviceType forKey:@"deviceType"];
    
    NSMutableDictionary *scheduleSetings= [[NSMutableDictionary alloc] init];
    //  NSMutableDictionary *scheduleMonth= [[NSMutableDictionary alloc] init];
    NSMutableDictionary *month= [[NSMutableDictionary alloc] init];
    [month setObject:[dictDetails valueForKey:kJan] forKey:@"january"];
    [month setObject:[dictDetails valueForKey:kFeb] forKey:@"february"];
    [month setObject:[dictDetails valueForKey:kMar] forKey:@"march"];
    [month setObject:[dictDetails valueForKey:kApr] forKey:@"april"];
    [month setObject:[dictDetails valueForKey:kMay] forKey:@"may"];
    [month setObject:[dictDetails valueForKey:kJun] forKey:@"june"];
    [month setObject:[dictDetails valueForKey:kJly] forKey:@"july"];
    [month setObject:[dictDetails valueForKey:kAug] forKey:@"august"];
    [month setObject:[dictDetails valueForKey:kSep] forKey:@"september"];
    [month setObject:[dictDetails valueForKey:kOct] forKey:@"october"];
    [month setObject:[dictDetails valueForKey:kNov] forKey:@"november"];
    [month setObject:[dictDetails valueForKey:kDec] forKey:@"december"];
    [month setObject:[dictDetails valueForKey:kScheduleMonthID] forKey:@"id"];
    [scheduleSetings setObject:month forKey:@"scheduleMonth"];
    
    NSMutableDictionary *day= [[NSMutableDictionary alloc] init];
    [day setObject:[dictDetails valueForKey:kSun] forKey:@"sunday"];
    [day setObject:[dictDetails valueForKey:kMon] forKey:@"monday"];
    [day setObject:[dictDetails valueForKey:kTue] forKey:@"tuesday"];
    [day setObject:[dictDetails valueForKey:kWed] forKey:@"wednesday"];
    [day setObject:[dictDetails valueForKey:kThr] forKey:@"thursday"];
    [day setObject:[dictDetails valueForKey:kFri] forKey:@"friday"];
    [day setObject:[dictDetails valueForKey:kSat] forKey:@"saturday"];
    [day setObject:[dictDetails valueForKey:kOddDay] forKey:@"oddDay"];
    [day setObject:[dictDetails valueForKey:kScheduleDayID] forKey:@"id"];
    [day setObject:[dictDetails valueForKey:kEvenDay] forKey:@"evenDay"];
    
    [scheduleSetings setObject:day forKey:@"scheduleDay"];
    
    NSMutableDictionary *schTime= [[NSMutableDictionary alloc] init];
    [schTime setObject:[dictDetails valueForKey:kStartTime] forKey:@"startTime"];
    [schTime setObject:[dictDetails valueForKey:kEndTime] forKey:@"endTime"];
    [schTime setObject:[dictDetails valueForKey:kScheduleTimeID] forKey:@"id"];
    NSMutableDictionary *schCategory= [[NSMutableDictionary alloc] init];
    [schCategory setObject:[dictDetails valueForKey:kScheduleCategoryID] forKey:@"id"];
    [schTime setObject:schCategory forKey:@"scheduleCategory"];
    
    [scheduleSetings setObject:schTime forKey:@"scheduleTime"];
    [scheduleSetings setObject:[dictDetails valueForKey:kScheduleSettingID] forKey:@"id"];
    [schedule setObject:scheduleSetings forKey:@"scheduleSetting"];
    
    //attach the schedule object
    [parameters setObject:schedule forKey:@"schedule"];
    
    //id
    [parameters setObject:[dictDetails valueForKey:kSchMainID] forKey:@"id"];
    NSLog(@"%@",parameters);
    return parameters;
}

//JSON Request update schedule name
-(NSDictionary *) updateScheduleName:(NSDictionary *)dictDetails
{
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictDetails valueForKey:kSchMainID] forKey:@"id"];
    [parameters setObject:[dictDetails valueForKey:kscheduleName] forKey:@"scheduleName"];
    return parameters;
}

//JSON Request Update User Account Details
-(NSDictionary *)updateUserAccountDetails:(NSDictionary *)dictusermanagement{
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictusermanagement valueForKey:kAccountID] forKey:@"id"];
    [parameters setObject:[dictusermanagement valueForKey:kFirstName] forKey:@"firstName"];
    [parameters setObject:[dictusermanagement valueForKey:kLastName] forKey:@"lastName"];
    [parameters setObject:[dictusermanagement valueForKey:kEmailID] forKey:@"email"];
    [parameters setObject:[dictusermanagement valueForKey:knetworkid] forKey:@"network"];
    
    NSLog(@"%@",parameters);
    
    return parameters;
}

//JSON Request Accept Network
-(NSDictionary *) accpetNetworksShared:(NSDictionary *)dictDetails
{
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictDetails valueForKey:kNetworkID] forKey:@"id"];
    
    NSMutableDictionary *inviteStatusDict= [[NSMutableDictionary alloc] init];
    [inviteStatusDict setObject:[dictDetails valueForKey:kaccesstype] forKey:@"id"];
    [parameters setObject:inviteStatusDict forKey:@"inviteeNetworkStatus"];
    
    NSLog(@"%@",parameters);
    return parameters;
}

//create JSON to update User Account Name
-(NSDictionary *)updateUserAccName:(NSDictionary *)dictDetails
{
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictDetails valueForKey:kAccountID] forKey:@"id"];
    [parameters setObject:[dictDetails valueForKey:kAccountName] forKey:@"firstName"];
    [parameters setObject:[dictDetails valueForKey:kAccountLastName] forKey:@"lastName"];
    NSLog(@"%@",parameters);
    return parameters;
}

-(NSDictionary *)signOut:(NSDictionary *)dictDetails
{
    NSLog(@"dict ==%@",dictDetails);
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictDetails valueForKey:kDeviceToken] forKey:@"tokenMacId"];
    
    NSMutableDictionary *tokenType= [[NSMutableDictionary alloc] init];
    [tokenType setObject:[dictDetails valueForKey:kTokenType] forKey:@"id"];
    [parameters setObject:tokenType forKey:@"tokenType"];
    
    NSLog(@"%@",parameters);
    return parameters;
}
-(void) serviceConnectorGETTEST:(NSString *)methodName
{
    // NSURL *baseURL = [NSURL URLWithString:getNoidAppUrl];
    defaults=[NSUserDefaults standardUserDefaults];
    NSURL *baseURL = [NSURL URLWithString:@"http://192.168.2.93:8080"];
    NSLog(@"URL==%@",baseURL);
    NSLog(@"methodname==%@",methodName);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setTimeoutInterval:20.0];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:methodName parameters:@"" success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *responseStatus_Code = (NSHTTPURLResponse *)task.response;
        NSLog(@"Response statusCode: %li", (long)responseStatus_Code.statusCode);
        if(responseStatus_Code.statusCode==200){
            NSMutableDictionary *response=(NSMutableDictionary *)responseObject;
            // NSLog(@"meesage==%@",response);
            [self responseMSG:response];
        }else{
            [self resError:[NSString stringWithFormat:@"%li",(long)responseStatus_Code.statusCode]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error.code==NSURLErrorTimedOut) {
            NSLog(@"Time out");
        }
        NSLog(@"error  %@",[error localizedDescription]);
        [self resError:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
    }];
}

-(NSDictionary *) device_Status_Update:(NSDictionary *)dict_Device_Status
{
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dict_Device_Status valueForKey:kDeviceID] forKey:@"id"];
    
    //Create Deivce Status Object
    NSMutableDictionary *deviceStatus= [[NSMutableDictionary alloc] init];
    [deviceStatus setObject:[dict_Device_Status valueForKey:kDeviceStatus] forKey:@"id"];
    //attach the object
    [parameters setObject:deviceStatus forKey:@"deviceStatus"];
    NSLog(@"%@",parameters);
    return parameters;
}


-(NSDictionary *) device_Category_Update:(NSDictionary *)dict_Device_Status
{
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dict_Device_Status valueForKey:kDeviceID] forKey:@"id"];
    
    //Create Deivce Status Object
    NSMutableDictionary *deviceStatus= [[NSMutableDictionary alloc] init];
    [deviceStatus setObject:[dict_Device_Status valueForKey:kDeviceStatus] forKey:@"id"];
    //attach the object
    [parameters setObject:deviceStatus forKey:@"deviceType"];
    NSLog(@"%@",parameters);
    return parameters;
}

-(NSDictionary *) device_Mode_Update:(NSDictionary *)dict_Device_Mode
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dict_Device_Mode valueForKey:kDeviceID] forKey:@"id"];
    NSMutableDictionary *deviceMode= [[NSMutableDictionary alloc] init];
    [deviceMode setObject:[dict_Device_Mode valueForKey:kDeviceMode] forKey:@"id"];
    //attach the object
    [parameters setObject:deviceMode forKey:@"deviceMode"];
    NSLog(@"%@",parameters);
    return parameters;
}
-(NSDictionary *) upgrade_Plan:(NSDictionary *)dict_Plan
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dict_Plan valueForKey:kquoteTypeId] forKey:@"quoteTypeId"];
    [parameters setObject:[dict_Plan valueForKey:kdeviceTypeId] forKey:@"deviceTypeId"];
    [parameters setObject:[dict_Plan valueForKey:kprorationDateTime] forKey:@"prorationDateTime"];
    
    NSLog(@"%@",parameters);
    return parameters;
}
-(NSDictionary *) upgrade_Device_Plan:(NSDictionary *)dict_Plan
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dict_Plan valueForKey:kquoteTypeId] forKey:@"quoteTypeId"];
    [parameters setObject:[dict_Plan valueForKey:kdeviceTypeId] forKey:@"deviceTypeId"];
    [parameters setObject:[dict_Plan valueForKey:kControllerID] forKey:@"controllerId"];
    [parameters setObject:[dict_Plan valueForKey:kprorationDateTime] forKey:@"prorationDateTime"];
    
    NSLog(@"%@",parameters);
    return parameters;
}
-(NSDictionary *) downgrade_Plan:(NSDictionary *)dict_Plan
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dict_Plan valueForKey:kquoteTypeId] forKey:@"quoteTypeId"];
    [parameters setObject:[dict_Plan valueForKey:kdeviceTypeId] forKey:@"deviceTypeId"];
    [parameters setObject:[dict_Plan valueForKey:kControllerID] forKey:@"controllerId"];
    [parameters setObject:[dict_Plan valueForKey:kprorationDateTime] forKey:@"prorationDateTime"];
    
    NSLog(@"%@",parameters);
    return parameters;
}
-(NSDictionary *) downgrade_Device_Plan:(NSDictionary *)dict_Plan
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dict_Plan valueForKey:kquoteTypeId] forKey:@"quoteTypeId"];
    [parameters setObject:[dict_Plan valueForKey:kdeviceTypeId] forKey:@"deviceTypeId"];
    [parameters setObject:[dict_Plan valueForKey:kControllerID] forKey:@"controllerId"];
    [parameters setObject:[dict_Plan valueForKey:kDeviceID] forKey:@"deviceId"];
    [parameters setObject:[dict_Plan valueForKey:kprorationDateTime] forKey:@"prorationDateTime"];
    
    NSLog(@"%@",parameters);
    return parameters;
}
//create JSON to update User Account Name
-(NSDictionary *)update_PropertyDeviceLocation:(NSDictionary *)dictDetails
{
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictDetails valueForKey:kLat] forKey:@"mapLatitude"];
    [parameters setObject:[dictDetails valueForKey:kLong] forKey:@"mapLongitude"];
    NSLog(@"%@",parameters);
    return parameters;
}
-(NSDictionary *)update_Property_MapImage:(NSDictionary *)dict_Property_Image
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dict_Property_Image valueForKey:kpropertyMapImage] forKey:@"propertyMapImage"];
    [parameters setObject:[dict_Property_Image valueForKey:kcenterLat] forKey:@"centerLatitude"];
    [parameters setObject:[dict_Property_Image valueForKey:kcenterLong] forKey:@"centerLongitude"];
    [parameters setObject:[dict_Property_Image valueForKey:ktopLeftLat] forKey:@"topLeftLatitude"];
    [parameters setObject:[dict_Property_Image valueForKey:ktopLeftLong] forKey:@"topLeftLongitude"];
    [parameters setObject:[dict_Property_Image valueForKey:ktopRightLat] forKey:@"topRightLatitude"];
    [parameters setObject:[dict_Property_Image valueForKey:ktopRightLong] forKey:@"topRightLongitude"];
    [parameters setObject:[dict_Property_Image valueForKey:kbottomLeftLat] forKey:@"bottomLeftLatitude"];
    [parameters setObject:[dict_Property_Image valueForKey:kbottomLeftLong] forKey:@"bottomLeftLongitude"];
    [parameters setObject:[dict_Property_Image valueForKey:kbottomRightLat] forKey:@"bottomRightLatitude"];
    [parameters setObject:[dict_Property_Image valueForKey:kbottomRightLong] forKey:@"bottomRightLongitude"];
    [parameters setObject:[dict_Property_Image valueForKey:kzoomLevel] forKey:@"zoomLevel1"];
    
    NSLog(@"%@",parameters);
    return parameters;

}

-(NSDictionary *)update_Read_Message_Status:(NSDictionary *)dictReadMsg_Update
{
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictReadMsg_Update valueForKey:kMessageID] forKey:@"id"];
    [parameters setObject:[dictReadMsg_Update valueForKey:kMessageAction] forKey:@"action"];
    NSLog(@"%@",parameters);
    return parameters;
}

-(NSDictionary *) add_Sprinkler_Device_Details:(NSDictionary *)dictController_Device_Details
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictController_Device_Details valueForKey:kZoneLevel] forKey:@"zone"];
    
    //create Device Trace object
    NSMutableDictionary *account= [[NSMutableDictionary alloc] init];
    [account setObject:[dictController_Device_Details valueForKey:kDeviceTraceID] forKey:@"id"];
    //attach the object
    [parameters setObject:account forKey:@"deviceTrace"];
    
    //create Device Type object
    NSMutableDictionary *deviceType= [[NSMutableDictionary alloc] init];
    [deviceType setObject:[dictController_Device_Details valueForKey:kdeviceTypeId] forKey:@"id"];
    //attach the object
    [parameters setObject:deviceType forKey:@"deviceType"];
    
    NSLog(@"%@",parameters);
    return parameters;
}

-(NSDictionary *) additional_Sprinkler_Device_Details:(NSDictionary *)dictController_Device_Details
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    [parameters setObject:[dictController_Device_Details valueForKey:kDeviceName] forKey:@"name"];
    [parameters setObject:[dictController_Device_Details valueForKey:kDeviceImage] forKey:@"image"];
    [parameters setObject:[dictController_Device_Details valueForKey:KThumbnailImage] forKey:@"thumbnailImage"];
    //create Device Trace object
    
    //create Device Status object
    NSMutableDictionary *deviceStatus= [[NSMutableDictionary alloc] init];
    [deviceStatus setObject:[dictController_Device_Details valueForKey:kDeviceStatus] forKey:@"id"];
    //attach the object
    [parameters setObject:deviceStatus forKey:@"zoneStatus"];
    
    [parameters setObject:[dictController_Device_Details valueForKey:kZoneLevel] forKey:@"zoneLevel"];
    [parameters setObject:[dictController_Device_Details valueForKey:kZoneStatus] forKey:@"status"];
    
    NSLog(@"%@",parameters);
    return parameters;
}

-(NSDictionary *)addSprinklerSchedule:(NSDictionary *)dictDetails{
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    
    //create Zone Schedule Object
    NSMutableDictionary *zoneSch= [[NSMutableDictionary alloc] init];
    [zoneSch setObject:[dictDetails valueForKey:kscheduleName] forKey:@"scheduleName"];
    [zoneSch setObject:[dictDetails valueForKey:kscheduleName] forKey:@"scheduleDesc"];
    [zoneSch setObject:[dictDetails valueForKey:kScheduleTime] forKey:@"startTime"];
    //attach the object
    [parameters setObject:zoneSch forKey:@"zoneSchedule"];
    
    //create Device Mode object
    NSMutableDictionary *zoneSchMonth= [[NSMutableDictionary alloc] init];
    [zoneSchMonth setObject:[dictDetails valueForKey:kJan] forKey:@"january"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kFeb] forKey:@"february"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kMar] forKey:@"march"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kApr] forKey:@"april"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kMay] forKey:@"may"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kJun] forKey:@"june"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kJly] forKey:@"july"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kAug] forKey:@"august"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kSep] forKey:@"september"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kOct] forKey:@"october"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kNov] forKey:@"november"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kDec] forKey:@"december"];
    //attach the object
    [parameters setObject:zoneSchMonth forKey:@"zoneScheduleMonth"];
    
    //create Device Status object
    NSMutableDictionary *zoneSchDay= [[NSMutableDictionary alloc] init];
    [zoneSchDay setObject:[dictDetails valueForKey:kSun] forKey:@"sunday"];
    [zoneSchDay setObject:[dictDetails valueForKey:kMon] forKey:@"monday"];
    [zoneSchDay setObject:[dictDetails valueForKey:kTue] forKey:@"tuesday"];
    [zoneSchDay setObject:[dictDetails valueForKey:kWed] forKey:@"wednesday"];
    [zoneSchDay setObject:[dictDetails valueForKey:kThr] forKey:@"thursday"];
    [zoneSchDay setObject:[dictDetails valueForKey:kFri] forKey:@"friday"];
    [zoneSchDay setObject:[dictDetails valueForKey:kSat] forKey:@"saturday"];
    [zoneSchDay setObject:[dictDetails valueForKey:kOddDay] forKey:@"oddDay"];
    [zoneSchDay setObject:[dictDetails valueForKey:kRunEvery] forKey:@"everyNDay"];
    [zoneSchDay setObject:[dictDetails valueForKey:kEvenDay] forKey:@"evenDay"];
    //attach the object
    [parameters setObject:zoneSchDay forKey:@"zoneScheduleDay"];
    
    
    
    [parameters setObject:[dictDetails valueForKey:kScheduleZones] forKey:@"zoneScheduleTime"];
    
    NSLog(@"%@",parameters);
    return parameters;
}

-(NSDictionary *)updateSprinklerSchedule:(NSDictionary *)dictDetails{
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    
    //create Zone Schedule Object
    NSMutableDictionary *zoneSch= [[NSMutableDictionary alloc] init];
    [zoneSch setObject:[dictDetails valueForKey:kscheduleName] forKey:@"scheduleName"];
    [zoneSch setObject:[dictDetails valueForKey:kscheduleName] forKey:@"scheduleDesc"];
    [zoneSch setObject:[dictDetails valueForKey:kScheduleTime] forKey:@"startTime"];
    [zoneSch setObject:[dictDetails valueForKey:kScheduleID] forKey:@"id"];
    //attach the object
    [parameters setObject:zoneSch forKey:@"zoneSchedule"];
    
    //create Device Mode object
    NSMutableDictionary *zoneSchMonth= [[NSMutableDictionary alloc] init];
    [zoneSchMonth setObject:[dictDetails valueForKey:kJan] forKey:@"january"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kFeb] forKey:@"february"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kMar] forKey:@"march"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kApr] forKey:@"april"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kMay] forKey:@"may"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kJun] forKey:@"june"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kJly] forKey:@"july"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kAug] forKey:@"august"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kSep] forKey:@"september"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kOct] forKey:@"october"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kNov] forKey:@"november"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kDec] forKey:@"december"];
    [zoneSchMonth setObject:[dictDetails valueForKey:kScheduleMonthID] forKey:@"id"];
    //attach the object
    [parameters setObject:zoneSchMonth forKey:@"zoneScheduleMonth"];
    
    //create Device Status object
    NSMutableDictionary *zoneSchDay= [[NSMutableDictionary alloc] init];
    [zoneSchDay setObject:[dictDetails valueForKey:kSun] forKey:@"sunday"];
    [zoneSchDay setObject:[dictDetails valueForKey:kMon] forKey:@"monday"];
    [zoneSchDay setObject:[dictDetails valueForKey:kTue] forKey:@"tuesday"];
    [zoneSchDay setObject:[dictDetails valueForKey:kWed] forKey:@"wednesday"];
    [zoneSchDay setObject:[dictDetails valueForKey:kThr] forKey:@"thursday"];
    [zoneSchDay setObject:[dictDetails valueForKey:kFri] forKey:@"friday"];
    [zoneSchDay setObject:[dictDetails valueForKey:kSat] forKey:@"saturday"];
    [zoneSchDay setObject:[dictDetails valueForKey:kOddDay] forKey:@"oddDay"];
    [zoneSchDay setObject:[dictDetails valueForKey:kRunEvery] forKey:@"everyNDay"];
    [zoneSchDay setObject:[dictDetails valueForKey:kEvenDay] forKey:@"evenDay"];
    [zoneSchDay setObject:[dictDetails valueForKey:kScheduleDayID] forKey:@"id"];
    //attach the object
    [parameters setObject:zoneSchDay forKey:@"zoneScheduleDay"];
    
    
    
    [parameters setObject:[dictDetails valueForKey:kScheduleZones] forKey:@"zoneScheduleTime"];
    
    NSLog(@"%@",parameters);
    return parameters;
}

-(NSDictionary *) zone_Status_Update:(NSDictionary *)dict_Device_Status
{
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    
    //Create Deivce Status Object
    NSMutableDictionary *deviceStatus= [[NSMutableDictionary alloc] init];
    [deviceStatus setObject:[dict_Device_Status valueForKey:kZoneStatusID] forKey:@"id"];
    //attach the object
    [parameters setObject:deviceStatus forKey:@"deviceMode"];
    NSLog(@"%@",parameters);
    return parameters;
}

-(NSDictionary *) zone_ON_OFF_Status:(NSDictionary *)dict_Zone_ON_OFF
{
    
    NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
    
    //Create Deivce Status Object
    NSMutableDictionary *zoneStatus= [[NSMutableDictionary alloc] init];
    [zoneStatus setObject:[dict_Zone_ON_OFF valueForKey:kZoneStatusID] forKey:@"id"];
    //attach the object
    [parameters setObject:zoneStatus forKey:@"zoneStatus"];
    NSLog(@"%@",parameters);
    return parameters;
}

@end
