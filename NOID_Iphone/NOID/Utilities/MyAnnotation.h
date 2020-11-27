//
//  MyAnnotation.h
//  Ufficient
//
//  Created by iExemplar Software on 26/02/14.
//  Copyright (c) 2014 Iexemplar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation>
{
    /*CLLocationCoordinate2D coordinate;
    
    BOOL yesno;
    
    NSString *title,*subtitle;*/
}

@property (nonatomic,readonly)CLLocationCoordinate2D coordinate;
@property(copy,nonatomic)NSString *annCardType;
@property(copy,nonatomic)NSString *annCardID;
@property(copy,nonatomic)NSString *annCardZoneID;
@property(copy,nonatomic)NSString *anncardName;
@property(copy,nonatomic)NSString *annLat;
@property(copy,nonatomic)NSString *annLong;
@property(copy,nonatomic)NSString *annUnreadCount;
@property(copy,nonatomic)NSString *annZoneStatusID;
@property(copy,nonatomic)NSString *annZoneStatus;
@property(copy,nonatomic)NSString *annZoneLevel;
@property(copy,nonatomic)NSString *annDeviceMode;


- (id)initWithLocation:(CLLocationCoordinate2D)location;
-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end

