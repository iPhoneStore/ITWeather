//
//  ITWeather.h
//  ITWeather
//
//  Created by Ivan on 11/17/16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface ITWeather : NSObject

@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSString* weatherCondition;
@property (assign, nonatomic) CGFloat temperature;
@property (strong, nonatomic) NSString* iconName;
@property (strong, nonatomic) UIImage* icon;

@property (assign, nonatomic) CGFloat minTemperature;
@property (assign, nonatomic) CGFloat maxTemperature;
@property (strong, nonatomic) NSDate* date;

- (instancetype)initWithObject:(NSDictionary*) response;

- (instancetype)initShortWeatherWithObject:(NSDictionary*) response;


@end
