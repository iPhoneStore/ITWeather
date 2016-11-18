//
//  ITWeatherCell.h
//  ITWeather
//
//  Created by Mac on 17.11.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITWeatherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameDay;
@property (weak, nonatomic) IBOutlet UILabel *minTemperature;
@property (weak, nonatomic) IBOutlet UILabel *maxTemperature;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end
