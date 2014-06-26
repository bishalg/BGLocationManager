//
//  BGSplashScreenVC.m
//  Location Manager
//
//  Created by Bishal Ghimire on 6/25/14.
//  Copyright (c) 2014 Big B Soft. All rights reserved.
//

#import "BGSplashScreenVC.h"

// Location Manager
#import "BGLocationManager.h"

// Navigate 2 VC
#import "BGLocationMapVC.h"
#import "BGManualLocationVC.h"

@interface BGSplashScreenVC () <UIActionSheetDelegate, BGLocationManagerDelegate>

@end

@implementation BGSplashScreenVC

#pragma Delegate

- (void)lbLocationManager:(BGLocationManager *)locationManager didUpdateWithLocation:(CLLocation *)location {
    NSLog(@"locationManager = %@" , locationManager);
    [self navigate2MapVC];
}

- (void)lbLocationManager:(BGLocationManager *)locationManager didFailWithErrorMsg:(NSString *)errorMsg andError:(NSError *)error    {
    if (error) {
        [self navigate2ManualLocation];        
    }
    NSLog(@"Error = %@ \n %@" , errorMsg, error);
}

- (void)navigate2MapVC {
    BGLocationMapVC *locationMapVC = [BGLocationMapVC new];
    [self.navigationController pushViewController:locationMapVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self navigate2ManualLocation];
            break;
        case 1:
            [self startLocationManager];
            break;
            
        default:
            break;
    }
    NSLog(@"Index = %d", buttonIndex);
}

- (void)permissionDialog {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Use You Location"
                                                    message:@"Using Your Current Location lets you view ads of nearby areas"
                                                   delegate:nil
                                          cancelButtonTitle:@"Not Now"
                                          otherButtonTitles:@"Give Access", nil];
    alert.delegate = self;
    [alert show];
}

- (void)startLocationManager {
    BGLocationManager *locationManager = [BGLocationManager sharedLocationManager];
    locationManager.delegate = self;
//    [locationManager locationWithAccuracy:kCLLocationAccuracyNearestTenMeters withCallBack:^(BGLocationManager *locationManager, NSString *errorMsg, NSError *error) {
//        if (!error) {
//            NSLog(@"Location - %@" , locationManager);
//        } else {
//            NSLog(@"Erro - %@", error);
//        }
//    }];
}

- (void)navigate2ManualLocation {
    BGManualLocationVC *manualLocation = [BGManualLocationVC new];
    [self.navigationController pushViewController:manualLocation animated:YES];
}

#pragma View Life Cycle

// Do any additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self permissionDialog];
}

// Dispose of any resources that can be recreated.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
