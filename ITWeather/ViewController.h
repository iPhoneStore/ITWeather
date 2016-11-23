//
//  ViewController.h
//  ITWeather
//
//  Created by Mac on 16.11.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *weatherCondition;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

