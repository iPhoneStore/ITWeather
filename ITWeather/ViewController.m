//
//  ViewController.m
//  ITWeather
//
//  Created by Mac on 16.11.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import "ViewController.h"
#import "ITServerManager.h"
#import "ITWeatherCell.h"
#import "ITMenuViewController.h"

#import "ITWeather.h"


@interface ViewController ()

@property (strong, nonatomic) ITWeather* weatherNow;
@property (strong, nonatomic) NSArray* weatherArray;

@end

static NSString *countDay = @"9";//max 16 day, default 9 day

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaultCityName = [[ITServerManager manager] defaultCity];
    
    [self getWeather:self.defaultCityName];//Получить погоду за сегодня и countDay
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.defaultCityName = [[ITServerManager manager] defaultCity];
    
    [self getWeather:self.defaultCityName];//Получить погоду за сегодня и countDay
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getWeather:(NSString*) city{
    
    [self setValueWeatherNow:city];//получить погоду на сейчас
    
    
    //получить погоду для таблицы за countDay(default 9)
    [[ITServerManager manager] getWeatherForCity:city
                                        countDay:countDay
                                    successBlock:^(NSArray* weatherArray) {
                                        self.weatherArray = weatherArray;
                                        [self.tableView reloadData];
                                    }
                                    failureBlock:^(NSError *error) {
                                        
                                    }];
    
}

- (void) setValueWeatherNow:(NSString*) city{
    
    [[ITServerManager manager] getWeatherForCity:city successBlock:^(ITWeather *weather) {
        
        self.weatherNow = weather;
        
        self.cityName.text = weather.city;
        self.weatherCondition.text = weather.weatherCondition;
        
        if ([[[ITServerManager manager] units] isEqualToString:@"metric"]){
            self.temperature.text = [weather.temperature stringByAppendingString:@"°C"];
        }else{
            self.temperature.text = [weather.temperature stringByAppendingString:@"F"];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - Action

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.weatherArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ITWeatherCell* cell = [tableView dequeueReusableCellWithIdentifier:@"weatherWeakCell"];
    
    ITWeather* weather = [self.weatherArray objectAtIndex:indexPath.row];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"eeee";
    
    cell.nameDay.text = [dateFormatter stringFromDate:weather.date];
    
    cell.minTemperature.text = [NSString stringWithFormat:@"%1.f",weather.minTemperature.doubleValue];
    cell.maxTemperature.text = [NSString stringWithFormat:@"%1.f",weather.maxTemperature.doubleValue];
    
    [[ITServerManager manager] getIcon:weather.iconName successBlock:^(NSData *imageData) {
        
        cell.icon.image = [UIImage imageWithData:imageData];
        
    } failureBlock:^(NSError *error) {
        
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate


#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"menuSegue"]){
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        ITMenuViewController* vc = [[ITMenuViewController alloc] init];
        
        vc = segue.destinationViewController;
        
    }
}
@end
