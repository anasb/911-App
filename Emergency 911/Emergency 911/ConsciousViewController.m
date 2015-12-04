//
//  ConsciousViewController.m
//  Emergency 911
//
//  Created by Anas Bouzoubaa on 26/11/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

#import "ConsciousViewController.h"
#import "CurrentReport.h"
#import <INTULocationManager/INTULocationManager.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface ConsciousViewController () <MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *consciousButton;
@property (strong, nonatomic) IBOutlet UIButton *unconsciousButton;

@property (nonatomic, strong) CLLocation *location;

@end

@implementation ConsciousViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.location = [[CLLocation alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (sender == self.consciousButton) {
        [[CurrentReport sharedReport] setConsciousness:conscious];
    } else {
        
        //TODO: Add text message sending here
        [[CurrentReport sharedReport] setConsciousness:unconscious];
    }
}

- (IBAction)tappedUnconscious:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Contact 911" message:@"If the victim is unconscious, you need to inform 911 right away. Send Text?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *textAction = [UIAlertAction actionWithTitle:@"Contact 911" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getLocation];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:textAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getLocation
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"Creating your 911 report"];
    
    // Get user location first
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyHouse
                                       timeout:0.2
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 _location = currentLocation;
                                                 [self sendTextMessage];
                                             });
                                         }];
}

- (void)sendTextMessage
{
    [SVProgressHUD dismiss];
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText]) {
        
        NSString *body = @"";
        NSLog(@"%@", self.location);
        
        if (!self.location) {
            body = [NSString stringWithFormat:@"Unconscious Victim"];
        } else {
            body = [NSString stringWithFormat:@"Unconscious Victim \
                               GPS: %f,%f \
                               Accuracy: +/- %.01fm", \
                               self.location.coordinate.latitude, self.location.coordinate.longitude, self.location.horizontalAccuracy];
        }
        controller.body = body;
        controller.recipients = @[@"911"];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"Can't send a text from this device"];
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
