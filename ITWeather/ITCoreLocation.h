//
//  ITCoreLocation.h
//  ITWeather
//
//  Created by Ivan on 11/18/16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ITCoreLocation : NSObject <CLLocationManagerDelegate>

- (CLLocationCoordinate2D) findCurrentLocation;

@end
