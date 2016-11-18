//
//  ITMenuViewController.h
//  ITWeather
//
//  Created by Mac on 17.11.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    metric,
    imperial
} unitsENUM;

typedef enum{
    RU,
    ENG
} langENUM;

@interface ITMenuViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *langSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitsSegment;



- (IBAction)actionUnit:(UISegmentedControl *)sender;
- (IBAction)actionLang:(UISegmentedControl *)sender;
- (IBAction)actionCityTextField:(UITextField *)sender;
- (IBAction)actionGPS:(UISwitch *)sender;


@end
