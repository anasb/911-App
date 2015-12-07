//
//  ViewController.m
//  Emergency 911
//
//  Created by Anas Bouzoubaa on 26/11/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

#import "InjuredIndividualViewController.h"
#import "CurrentReport.h"
#import <INTULocationManager/INTULocationManager.h>
#import "TwitterInterface.h"

@interface InjuredIndividualViewController ()

@property (nonatomic, strong) IBOutlet UIButton *myselfButton;
@property (nonatomic, strong) IBOutlet UIButton *someoneElseButton;

@end

@implementation InjuredIndividualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get user location first
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyHouse
                                       timeout:10.0
                          delayUntilAuthorized:YES
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             // nothing to do here
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 
                                                 NSArray *keywords = @[@"fire", @"gunshot", @"accident", @"assault", @"explosion"];
                                                 
                                                 for (NSString *keyword in keywords) {
                                                     [TwitterInterface queryTwitterAPIWithKeyword:keyword
                                                                                       atLatitude:currentLocation.coordinate.latitude
                                                                                     andLongitude:currentLocation.coordinate.longitude
                                                                                     successBlock:^(NSArray *statuses) {
                                                                                         
                                                                                         // Save number of tweets for that keyword
                                                                                         NSString *num = [NSString stringWithFormat:@"%lu", (unsigned long)statuses.count];
                                                                                         [[[CurrentReport sharedReport] tweetsRelatedTo] setObject:num forKey:keyword];
                                                                                         
                                                                                     } errorBlock:nil];
                                                 }
                                                 

                                                 
                                             });
                                         }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CurrentReport *report = [CurrentReport sharedReport];
    if (sender == self.myselfButton) {
        [report setInjuredIndividual:myself];
    } else {
        [report setInjuredIndividual:someoneElse];
    }
}

@end
