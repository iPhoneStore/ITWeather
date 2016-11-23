//
//  ITUserDefaultManager.h
//  ITWeather
//
//  Created by Mac on 18.11.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class ITWeather;

@interface ITUserDefaultManager : NSObject

@property (strong, nonatomic) NSDate* lastUpdate;
@property (assign, nonatomic) BOOL updateSetting;

@property (strong, nonatomic) NSString* defaultCity;
@property (strong, nonatomic) NSString* lang;
@property (strong, nonatomic) NSString* units;
@property (assign, nonatomic) CGFloat coordLongitude;
@property (assign, nonatomic) CGFloat coordLatitude;

@property(strong, nonatomic) NSUserDefaults* userDefault;

+ (instancetype)userManager;

-(void) saveWeatherWeek:(NSArray*) arrayWeather;
-(void) saveWeatherNow:(ITWeather*) weather;

-(ITWeather*) readWeatherNow:(NSString*) city;
-(NSArray*) readWeatherWeek:(NSString*) city;

@end
