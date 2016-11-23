//
//  ITMenuViewController.m
//  ITWeather
//
//  Created by Mac on 17.11.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import "ITMenuViewController.h"
#import "ITServerManager.h"
#import "ITUserDefaultManager.h"
#import "ITCoreLocation.h"

@interface ITMenuViewController ()

@end

@implementation ITMenuViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    self.navigationController.view.backgroundColor =
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.cityTextField.text = [[ITUserDefaultManager userManager] defaultCity];
    
    self.gpsSwitch.selected = YES;
    
    if (((CGFloat)[ITUserDefaultManager userManager].coordLatitude == 0.0) & ((CGFloat)[ITUserDefaultManager userManager].coordLongitude == 0.0)){
        self.gpsSwitch.on = NO;
    }else{
        self.gpsSwitch.on = YES;
    }
    
    
    if ([[[ITUserDefaultManager userManager] units] isEqualToString:@"metric"]){
        self.unitsSegment.selectedSegmentIndex=metric;
    }else{
        self.unitsSegment.selectedSegmentIndex=imperial;
    }
    
    if ([[[ITUserDefaultManager userManager] lang] isEqualToString:@"ru"]){
        self.langSegment.selectedSegmentIndex = RU;
    }else{
        self.langSegment.selectedSegmentIndex = ENG;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate


- (IBAction)actionUnit:(UISegmentedControl *)sender {
    
    NSString* unit = @"";
    
    if (sender.selectedSegmentIndex == metric){
        unit = @"metric";
    }else{
        unit = @"imperial";
    }
    
    [[ITUserDefaultManager userManager] setUnits:unit];
}

- (IBAction)actionLang:(UISegmentedControl *)sender {
    
    NSString* lang = @"";
    
    if (sender.selectedSegmentIndex == RU){
        lang = @"ru";
    }else{
        lang = @"en";
    }
    
    [[ITUserDefaultManager userManager] setLang:lang];
}

- (IBAction)actionCityTextField:(UITextField *)sender {
    
    [[ITUserDefaultManager userManager] setDefaultCity:[NSString stringWithFormat:@"%@",sender.text]];
}

- (IBAction)actionGPS:(UISwitch *)sender {
    
    if (sender.isOn){
        
        ITCoreLocation* coreLocation = [[ITCoreLocation alloc] init];
        
        CLLocationCoordinate2D location = [coreLocation findCurrentLocation];
        
        [[ITUserDefaultManager userManager] setCoordLatitude:location.latitude];
        [[ITUserDefaultManager userManager] setCoordLongitude:location.longitude];
    }else{
        [[ITUserDefaultManager userManager] setCoordLatitude:0];
        [[ITUserDefaultManager userManager] setCoordLongitude:0];
    }
    
}
@end
