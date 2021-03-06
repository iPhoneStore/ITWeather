//
//  ITWeather.m
//  ITWeather
//
//  Created by Ivan on 11/17/16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import "ITWeather.h"
#import "ITServerManager.h"

@implementation ITWeather

- (instancetype)initWithObject:(NSDictionary*) response
{
    self = [super init];
    if (self) {
        
        self.city = [response objectForKey:@"name"];
        self.weatherCondition = [[[response objectForKey:@"weather"] firstObject] objectForKey:@"description"];
        self.iconName = [[[[response objectForKey:@"weather"] firstObject] objectForKey:@"icon"] stringByAppendingString:@".png"];
        self.temperature = [[[response objectForKey:@"main"] objectForKey:@"temp"] floatValue];
        
    }
    return self;
}

- (instancetype)initShortWeatherWithObject:(NSDictionary*) response
{
    self = [super init];
    if (self) {
        
        self.iconName = [[[[response objectForKey:@"weather"] firstObject] objectForKey:@"icon"] stringByAppendingString:@".png"];
        self.minTemperature = [[[response objectForKey:@"temp"] objectForKey:@"min"] floatValue];
        self.maxTemperature = [[[response objectForKey:@"temp"] objectForKey:@"max"] floatValue];
        self.date = [NSDate dateWithTimeIntervalSince1970:[[response objectForKey:@"dt"] doubleValue]];
        
    }
    return self;
}

@end
