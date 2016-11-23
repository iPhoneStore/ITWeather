//
//  ViewController.m
//  ITWeather
//
//  Created by Mac on 16.11.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import "ViewController.h"
#import "ITMenuViewController.h"
#import "ITWeatherCell.h"

#import "ITServerManager.h"
#import "ITUserDefaultManager.h"

#import "ITWeather.h"


@interface ViewController ()

@property (strong, nonatomic) ITWeather* weatherNow;
@property (strong, nonatomic) NSArray* weatherArray;

@property (strong, nonatomic) ITUserDefaultManager* userManager;

@end

static NSString *countDay = @"9";//max 16 day, default 9 day

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Попытка залить проект на Git
    
    self.userManager = [ITUserDefaultManager userManager];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:[self.userManager lastUpdate]];
    
    NSLog(@"Update? %@", [self.userManager updateSetting]?@"Yes":@"No");
    NSLog(@"TimeInterval: %f", timeInterval);
    
    if ((timeInterval<60*60) & ![self.userManager updateSetting]){
    
        if (self.weatherArray == nil){
            
            [self setWeatherWithOffInternet:[self.userManager defaultCity]];//получить погоду из кэша
            
        }
        
    }else{
        
        [self.userManager setUpdateSetting:NO];
        
        [self getWeather:[self.userManager defaultCity]];//Получить из интернета погоду за сегодня и countDay
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getWeather:(NSString*) city{
    
    [[ITServerManager manager] checkInternet:^(BOOL statusInternet) {
        if (statusInternet){
            
            NSLog(@"coordLatitude: %f, coordLongitude: %f",self.userManager.coordLatitude,self.userManager.coordLongitude);

            if (((CGFloat)self.userManager.coordLatitude == 0.0) & ((CGFloat)self.userManager.coordLongitude == 0.0)){
                
                [self setWeatherWithOnInternet:city];
                
            }else{
                
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.userManager.coordLatitude, self.userManager.coordLongitude);
                
                [self setWeatherWithOnInternerAndGPS:coordinate];
            }
            
        } else {
            
            [self setWeatherWithOffInternet:city];
        }
    }];
}

- (void) setWeatherWithOnInternerAndGPS:(CLLocationCoordinate2D) coord{
    
    [[ITServerManager manager] getWeatherWithGPS:coord successBlock:^(ITWeather *weather) {
        
        [self setValueWeatherNow:weather];//получить погоду на сейчас
        
        [self.userManager saveWeatherNow:weather];//Сохранить полученую погоду в UserDefault
        
        
    } failureBlock:^(NSError *error) {
        
    }];
    
    //получить погоду для таблицы за countDay(default 9)
    [[ITServerManager manager] getWeatherWithGPS:coord
                                        countDay:countDay
                                    successBlock:^(NSArray* weatherArray) {
                                        
                                        self.weatherArray = weatherArray;
                                        
                                        [self.userManager saveWeatherWeek:weatherArray];//Сохранить полученую погоду в UserDefault
                                        
                                        [self.tableView reloadData];
                                        
                                    }
                                    failureBlock:^(NSError *error) {
                                        
                                    }];
    
    
}


- (void) setWeatherWithOnInternet:(NSString*) city{
    
    [[ITServerManager manager] getWeatherForCity:city successBlock:^(ITWeather *weather) {
        
        [self setValueWeatherNow:weather];//получить погоду на сейчас
        
        [self.userManager saveWeatherNow:weather];//Сохранить полученую погоду в UserDefault
        
        
    } failureBlock:^(NSError *error) {
        
    }];
    
    //получить погоду для таблицы за countDay(default 9)
    [[ITServerManager manager] getWeatherForCity:city
                                        countDay:countDay
                                    successBlock:^(NSArray* weatherArray) {
                                        
                                        self.weatherArray = weatherArray;
                                        
                                        [self.userManager saveWeatherWeek:weatherArray];//Сохранить полученую погоду в UserDefault
                                        
                                        [self.tableView reloadData];
                                        
                                    }
                                    failureBlock:^(NSError *error) {
                                        
                                    }];
    
}

- (void) setWeatherWithOffInternet:(NSString*) city{
    
    ITWeather* weather = [self.userManager readWeatherNow:city];
    
    if(weather != nil){
        
        [self setValueWeatherNow:weather];
        
        self.weatherArray = [self.userManager readWeatherWeek:city];
        
        [self.tableView reloadData];
        
    }

}

- (void) setValueWeatherNow:(ITWeather*) weather{
    
    self.weatherNow = weather;
    
    self.cityName.text = weather.city;
    self.weatherCondition.text = weather.weatherCondition;
    
    if ([[self.userManager units] isEqualToString:@"metric"]){
        self.temperature.text = [[NSString stringWithFormat:@"%1.1f",weather.temperature] stringByAppendingString:@"°C"];
    }else{
        self.temperature.text = [[NSString stringWithFormat:@"%1.1f",weather.temperature] stringByAppendingString:@"F"];
    }
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
    
    cell.minTemperature.text = [NSString stringWithFormat:@"%1.f",weather.minTemperature];
    cell.maxTemperature.text = [NSString stringWithFormat:@"%1.f",weather.maxTemperature];
    
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
