//
//  ITCoreLocation.m
//  ITWeather
//
//  Created by Ivan on 11/18/16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import "ITCoreLocation.h"

@implementation ITCoreLocation

- (CLLocationCoordinate2D) findCurrentLocation{
    
    CLLocationManager* locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager locationServicesEnabled]){
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        
        [locationManager startUpdatingLocation];
    }
    
    CLLocation* location = [locationManager location];
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

@end
