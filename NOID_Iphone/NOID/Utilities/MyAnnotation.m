//
//  MyAnnotation.h
//  Ufficient
//
//  Created by iExemplar Software on 26/02/14.
//  Copyright (c) 2014 Iexemplar. All rights reserved.
//
/*
 @property(copy,nonatomic)NSString *annCardType;
 @property(copy,nonatomic)NSString *annCardID;
 @property(copy,nonatomic)NSString *anncardName;
 */
#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize coordinate,annLong,annLat,annCardID,anncardName,annCardType;
@synthesize annUnreadCount,annCardZoneID,annZoneLevel,annZoneStatus,annZoneStatusID,annDeviceMode;


- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}

- (id)initWithLocation:(CLLocationCoordinate2D)location
{
    self=[super init];
    if(self){
        //_title=[newTitle copy];
        coordinate=location;
    }
    return self;
}
@end
