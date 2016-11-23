//
//  ITServerManager.h
//  ITWeather
//
//  Created by Mac on 16.11.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ITWeather;

@interface ITServerManager : NSObject

+ (instancetype)manager;

- (void) checkInternet:(void(^)(BOOL statusInternet)) success;

-(void) getWeatherWithGPS:(CLLocationCoordinate2D) coordinate
                    successBlock:(void(^)(ITWeather* weather)) success
                    failureBlock:(void(^)(NSError* error)) failure;

- (void) getWeatherWithGPS:(CLLocationCoordinate2D) coordinate
                  countDay:(NSString*) countDay
              successBlock:(void(^)(NSArray* weatherArray)) success
              failureBlock:(void(^)(NSError* error)) failure;

- (void) getWeatherForCity:(NSString*) city
         successBlock:(void(^)(ITWeather* weather)) success
              failureBlock:(void(^)(NSError* error)) failure;

- (void) getWeatherForCity:(NSString*) city
                  countDay:(NSString*) countDay
              successBlock:(void(^)(NSArray* weatherArray)) success
              failureBlock:(void(^)(NSError* error)) failure;


-(void) getIcon:(NSString*) nameIcon
   successBlock:(void(^)(NSData* imageData)) success
   failureBlock:(void(^)(NSError* error)) failure;

@end
