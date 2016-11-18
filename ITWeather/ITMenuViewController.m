//
//  ITMenuViewController.m
//  ITWeather
//
//  Created by Mac on 17.11.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import "ITMenuViewController.h"
#import "ITServerManager.h"

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
    /*
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    
    imageView.image = [UIImage imageNamed:@"Start-Background.jpg"];
    
    [self.tableView addSubview:imageView];
    */
    
    self.navigationController.view.backgroundColor =
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.cityTextField.text = [[ITServerManager manager] defaultCity];
    
    if ([[[ITServerManager manager] units] isEqualToString:@"metric"]){
        self.unitsSegment.selectedSegmentIndex=metric;
    }else{
        self.unitsSegment.selectedSegmentIndex=imperial;
    }
    
    if ([[[ITServerManager manager] lang] isEqualToString:@"ru"]){
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
    
    [[ITServerManager manager] setUnits:unit];
}

- (IBAction)actionLang:(UISegmentedControl *)sender {
    
    NSString* lang = @"";
    
    if (sender.selectedSegmentIndex == RU){
        lang = @"ru";
    }else{
        lang = @"";
    }
    
    [[ITServerManager manager] setLang:lang];
}

- (IBAction)actionCityTextField:(UITextField *)sender {
    
    [[ITServerManager manager] setDefaultCity:[NSString stringWithFormat:@"%@",sender.text]];
}

- (IBAction)actionGPS:(UISwitch *)sender {
    
    //найти по GPS нахождение пользователя и установить город по умолчанию.
    
}
@end
