//
//  ITServerManager.m
//  ITWeather
//
//  Created by Mac on 16.11.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

#import "ITServerManager.h"

#import "AFNetWorking.h"
#import "ITUserDefaultManager.h"

#import "ITWeather.h"

const static NSString* appID = @"6341251da659dac90fc19a8be89a09bb";
const static NSString* baseURL = @"http://api.openweathermap.org/data/2.5/";

@interface ITServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager* sessinManager;

@end

@implementation ITServerManager


+ (instancetype)manager
{
    
    static ITServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ITServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        AFHTTPSessionManager* sessionManager = [[AFHTTPSessionManager alloc] init];
        _sessinManager = sessionManager;
    }
    return self;
}

- (void) checkInternet:(void(^)(BOOL statusInternet)) success{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        BOOL statusInternet =  NO;
        
        if (![AFStringFromNetworkReachabilityStatus(status) isEqualToString:@"Not Reachable"]){
            statusInternet = YES;
        }
        
        if (success){
            [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            success(statusInternet);
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

#pragma mark - GetWeatherForGPS

-(void) getWeatherWithGPS:(CLLocationCoordinate2D) coordinate
             successBlock:(void(^)(ITWeather* weather)) success
             failureBlock:(void(^)(NSError* error)) failure{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString* url = [baseURL stringByAppendingString:@"weather?"];
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           appID,@"APPID",
                           [[ITUserDefaultManager userManager] lang], @"lang",
                           [[ITUserDefaultManager userManager] units],@"units",
                           @(coordinate.latitude),@"lat",
                           @(coordinate.longitude),@"lon",nil];
    
    [self.sessinManager GET:url
                 parameters:param
                   progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        
                        ITWeather* weather = [[ITWeather alloc] initWithObject:responseObject];
                        
                        [[ITUserDefaultManager userManager] setDefaultCity:weather.city];
                        
                        [self getIcon:weather.iconName successBlock:^(NSData *imageData) {
                            
                            weather.icon = [UIImage imageWithData:imageData];
                            
                            if(success){
                                success(weather);
                            }
                            
                        } failureBlock:^(NSError *error) {
                            
                        }];
                    }
                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        NSLog(@"Error : %@", [error localizedDescription]);
                    }];
}

- (void) getWeatherWithGPS:(CLLocationCoordinate2D) coordinate
                  countDay:(NSString*) countDay
              successBlock:(void(^)(NSArray* weatherArray)) success
              failureBlock:(void(^)(NSError* error)) failure{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString* url = [baseURL stringByAppendingString:@"forecast/daily?"];
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           appID,@"APPID",
                           [[ITUserDefaultManager userManager] lang], @"lang",
                           [[ITUserDefaultManager userManager] units],@"units",
                           countDay,@"cnt",
                           @(coordinate.latitude),@"lat",
                           @(coordinate.longitude),@"lon",nil];
    
    [self.sessinManager GET:url
                 parameters:param
                   progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        
                        NSArray* arrayWeather = [responseObject objectForKey:@"list"];
                        
                        NSMutableArray* resultWeatherArray = [NSMutableArray array];
                        
                        for (NSDictionary *dict in arrayWeather){
                            
                            ITWeather* weather = [[ITWeather alloc] initShortWeatherWithObject:dict];
                            
                            [resultWeatherArray addObject:weather];
                        }
                        
                        if ([resultWeatherArray count]>0){
                            [resultWeatherArray removeObjectAtIndex:0];
                        }
                        
                        if (success){
                            success(resultWeatherArray);
                        }
                        
                    }
                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        NSLog(@"Error : %@", [error localizedDescription]);
                    }];
}


#pragma mark - GetWeatherForCity

-(void) getWeatherForCity:(NSString*) city
             successBlock:(void(^)(ITWeather* weather)) success
             failureBlock:(void(^)(NSError* error)) failure{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString* url = [baseURL stringByAppendingString:@"weather?"];
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           appID,@"APPID",
                           [[ITUserDefaultManager userManager] lang], @"lang",
                           city,@"q",
                           [[ITUserDefaultManager userManager] units],@"units",nil];
    
    [self.sessinManager GET:url
                 parameters:param
                   progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        
                        ITWeather* weather = [[ITWeather alloc] initWithObject:responseObject];
                       
                        [self getIcon:weather.iconName successBlock:^(NSData *imageData) {
                            
                            weather.icon = [UIImage imageWithData:imageData];
                            
                            if(success){
                                success(weather);
                            }
                            
                        } failureBlock:^(NSError *error) {
                            
                        }];
                    }
                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        NSLog(@"Error : %@", [error localizedDescription]);
                    }];
}

- (void) getWeatherForCity:(NSString*) city
                  countDay:(NSString*) countDay
             successBlock:(void(^)(NSArray* weatherArray)) success
              failureBlock:(void(^)(NSError* error)) failure{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString* url = [baseURL stringByAppendingString:@"forecast/daily?"];
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           appID,@"APPID",
                           [[ITUserDefaultManager userManager] lang], @"lang",
                           city,@"q",
                           [[ITUserDefaultManager userManager] units],@"units",
                           countDay,@"cnt",nil];
    
    [self.sessinManager GET:url
                 parameters:param
                   progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        
                        NSArray* arrayWeather = [responseObject objectForKey:@"list"];
                        
                        NSMutableArray* resultWeatherArray = [NSMutableArray array];
                        
                        for (NSDictionary *dict in arrayWeather){
                            
                            ITWeather* weather = [[ITWeather alloc] initShortWeatherWithObject:dict];
                            
                            [resultWeatherArray addObject:weather];
                        }
                        
                        if ([resultWeatherArray count]>0){
                            [resultWeatherArray removeObjectAtIndex:0];
                        }
                        
                        if (success){
                            success(resultWeatherArray);
                        }
                        
                    }
                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        NSLog(@"Error : %@", [error localizedDescription]);
                    }];
}

-(void) getIcon:(NSString*) nameIcon
   successBlock:(void(^)(NSData* imageData)) success
   failureBlock:(void(^)(NSError* error)) failure{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString* URLString = [@"http://openweathermap.org/img/w/" stringByAppendingString:nameIcon];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:nil
                                                                  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager]
                                        URLForDirectory:NSDocumentDirectory
                                        inDomain:NSUserDomainMask
                                        appropriateForURL:nil
                                        create:NO
                                        error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                                  }
                                                            completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                
                                                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                
                                                                if (success){
                                                                    success([NSData dataWithContentsOfURL:filePath]);
                                                                }
                                                                
    }];
    
    [downloadTask resume];
}



@end
