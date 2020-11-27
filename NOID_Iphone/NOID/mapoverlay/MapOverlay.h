//
//  MapOverlay.h
//  iCardinal
//
//  Created by Edmar Miyake on 8/1/11.
//  Copyright 2011 I.ndigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@interface MapOverlay : NSObject <MKOverlay> {

}
-(CLLocationCoordinate2D)coordinate:(CLLocationCoordinate2D) coordinate;
- (MKMapRect)boundingMapRect;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end