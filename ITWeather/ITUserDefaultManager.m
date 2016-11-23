//
//  ITUserDefaultManager.m
//  ITWeather
//
//  Created by Mac on 18.11.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import "ITUserDefaultManager.h"
#import "ITWeather.h"

static NSString* kSettingsLastUpdate        = @"lastUpdate";
static NSString* kSettingsUpdateSetting     = @"updateSetting";

static NSString* kSettingsDefaultCity       = @"defaultCity";
static NSString* kSettingsTemperature       = @"temperature";
static NSString* kSettingsCondition         = @"condition";
static NSString* kSettingsUnits             = @"units";
static NSString* kSettingsLang              = @"lang";
static NSString* kSettingsCoordLatitude     = @"coordLatitude";
static NSString* kSettingsCoordLongitude    = @"coordLongitude";

static NSString* kWeatherNow    = @"weatherNow";
static NSString* kWeatherWeek    = @"weatherWeek";
static NSString* kWeatherCity    = @"city";
static NSString* kWeatherCondition    = @"weatherCondition";
static NSString* kWeatherTemperature    = @"temperature";
static NSString* kWeatherIconName    = @"iconName";
static NSString* kWeatherMinTemperature    = @"minTemperature";
static NSString* kWeatherMaxTemperature    = @"maxTemperature";
static NSString* kWeatherDate    = @"date";

@implementation ITUserDefaultManager

+ (instancetype)userManager
{
    static ITUserDefaultManager* userManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager = [[ITUserDefaultManager alloc] init];
    });
    
    return userManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
        
        self.userDefault=userDefault;
        
        if([userDefault objectForKey:kSettingsDefaultCity]){
            _defaultCity = [userDefault objectForKey:kSettingsDefaultCity];
            
            _units = [userDefault objectForKey:kSettingsUnits];
            _lang = [userDefault objectForKey:kSettingsLang];
            
            _coordLatitude = 0;
            _coordLongitude = 0;
            
            _lastUpdate =[userDefault objectForKey:kSettingsLastUpdate];
        }else{
            self.defaultCity = @"Minsk";
            
            self.units = @"metric";
            self.lang = @"ru";
            
            self.coordLatitude = 0;
            self.coordLongitude = 0;
        }
        
    }
    return self;
}

#pragma mark - SaveAndReadPropertyOfUserDefault

-(void) saveWeatherNow:(ITWeather*) weather{
    
    self.lastUpdate = [NSDate date];
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:weather.city forKey:kWeatherCity];
    [dictionary setValue:weather.weatherCondition forKey:kWeatherCondition];
    [dictionary setValue:@(weather.temperature) forKey:kWeatherTemperature];
    
    [self.userDefault setObject:dictionary forKey:kWeatherNow];
}

-(void) saveWeatherWeek:(NSArray*) arrayWeather{
    
    NSMutableArray* resultArrayWeather = [NSMutableArray array];
    
    for (ITWeather* weather in arrayWeather){
        
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        
        [dictionary setValue:@(weather.minTemperature) forKey:kWeatherMinTemperature];
        [dictionary setValue:@(weather.maxTemperature) forKey:kWeatherMaxTemperature];
        [dictionary setValue:weather.iconName forKey:kWeatherIconName];
        [dictionary setValue:weather.date forKey:kWeatherDate];
        
        [resultArrayWeather addObject:dictionary];
    }
    
    [self.userDefault setObject:resultArrayWeather forKey:kWeatherWeek];
}


-(ITWeather*) readWeatherNow:(NSString*) city{
    
    ITWeather* weather = [[ITWeather alloc] init];
    
    weather.city = [[self.userDefault objectForKey:kWeatherNow] objectForKey:kWeatherCity];
    weather.weatherCondition = [[self.userDefault objectForKey:kWeatherNow] objectForKey:kWeatherCondition];
    weather.temperature = [[[self.userDefault objectForKey:kWeatherNow] objectForKey:kWeatherTemperature] floatValue];
    
    return weather;
}

-(NSArray*) readWeatherWeek:(NSString*) city{
    
    NSMutableArray* resultArray = [NSMutableArray array];
    
    for (NSDictionary* dictionary in [self.userDefault objectForKey:kWeatherWeek]){
        
        ITWeather* weather = [[ITWeather alloc] init];
        
        weather.date = [dictionary objectForKey:kWeatherDate];
        weather.minTemperature = [[dictionary objectForKey:kWeatherMinTemperature] floatValue];
        weather.maxTemperature = [[dictionary objectForKey:kWeatherMaxTemperature] floatValue];
        weather.iconName = [dictionary objectForKey:kWeatherIconName];
        
        [resultArray addObject:weather];
    }

    return resultArray;
}

#pragma mark - SetLastUpdate

- (void)setUpdateSetting:(BOOL)updateSetting{
    
    [self.userDefault setObject:@(updateSetting) forKey:kSettingsUpdateSetting];
    
    _updateSetting = updateSetting;
    
}

- (void)setLastUpdate:(NSDate *)lastUpdate{
    
    [self.userDefault setObject:lastUpdate forKey:kSettingsLastUpdate];
    
    _lastUpdate = lastUpdate;
}

#pragma mark - SetProperyAndSaveUserDefault

- (void) setDefaultCity:(NSString *)defaultCity{
    
    self.updateSetting = YES;
    
    [self.userDefault setObject:defaultCity forKey:kSettingsDefaultCity];
    _defaultCity=defaultCity;
    
}

- (void) setLang:(NSString *)lang{
    
    self.updateSetting = YES;
    
    [self.userDefault setObject:lang forKey:kSettingsLang];
    
    _lang=lang;
    
}

- (void) setUnits:(NSString *)units{
    
    self.updateSetting = YES;
    
    [self.userDefault setObject:units forKey:kSettingsUnits];
    _units=units;
    
}

- (void)setCoordLatitude:(CGFloat)coordLatitude{
    
    self.updateSetting = YES;
    
    [self.userDefault setObject:@(coordLatitude) forKey:kSettingsCoordLatitude];
    _coordLatitude=coordLatitude;
}

- (void)setCoordLongitude:(CGFloat)coordLongitude{
    
    self.updateSetting = YES;
    
    [self.userDefault setObject:@(coordLongitude) forKey:kSettingsCoordLongitude];
    _coordLongitude=coordLongitude;
}

@end
