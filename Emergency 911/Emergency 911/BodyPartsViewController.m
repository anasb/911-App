//
//  BodyPartsViewController.m
//  Emergency 911
//
//  Created by Anas Bouzoubaa on 05/12/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

#import "BodyPartsViewController.h"
#import "CurrentReport.h"
#import <HealthKit/HealthKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <INTULocationManager/INTULocationManager.h>

@interface BodyPartsViewController () <MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UIImageView *chestImage;
@property (strong, nonatomic) IBOutlet UIImageView *leftArmImage;
@property (strong, nonatomic) IBOutlet UIImageView *rightArmImage;
@property (strong, nonatomic) IBOutlet UIImageView *leftLegImage;
@property (strong, nonatomic) IBOutlet UIImageView *rightLegImage;

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) HKHealthStore *healthStore;

@end

@implementation BodyPartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.location = [[CLLocation alloc] init];
    self.healthStore = [[HKHealthStore alloc] init];
    
    NSArray *images = @[self.headImage,
                        self.chestImage,
                        self.leftArmImage,
                        self.rightArmImage,
                        self.leftLegImage,
                        self.rightLegImage];
    
    for (UIImageView *img in images) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBodyPart:)];
        [img setUserInteractionEnabled:YES];
        [img addGestureRecognizer:gesture];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tappedBodyPart:(UITapGestureRecognizer*)sender
{
	UIImageView *btn = (UIImageView*)sender.view;
    if (btn == self.headImage) {
        [[CurrentReport sharedReport] setBodyPartHurt:@"Head"];
    } else if (btn == self.chestImage) {
        [[CurrentReport sharedReport] setBodyPartHurt:@"Chest"];
    } else if (btn == self.leftArmImage) {
        [[CurrentReport sharedReport] setBodyPartHurt:@"Left arm"];
    } else if (btn == self.rightArmImage) {
        [[CurrentReport sharedReport] setBodyPartHurt:@"Right arm"];
    } else if (btn == self.leftLegImage) {
        [[CurrentReport sharedReport] setBodyPartHurt:@"Left leg"];
    } else if (btn == self.rightLegImage) {
        [[CurrentReport sharedReport] setBodyPartHurt:@"Right leg"];
    }
    
    [self getLocation];
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
                                                 [self getHealthKitData];
                                             });
                                         }];
}

- (void) getHealthKitData
{
    NSDate *DOB = [self.healthStore dateOfBirthWithError:nil];

    NSString *sex;
    HKBiologicalSexObject *sexObj = [self.healthStore biologicalSexWithError:nil];
    if (sexObj.biologicalSex == HKBiologicalSexMale) {
        sex = @"Male";
    } else if (sexObj.biologicalSex == HKBiologicalSexFemale) {
        sex = @"Female";
    }

    NSString *bloodType;
    HKBloodTypeObject *bloodTypeObj = [self.healthStore bloodTypeWithError:nil];
    
    switch (bloodTypeObj.bloodType) {
        case HKBloodTypeAPositive: {
            bloodType = @"A+";
            break;
        }
        case HKBloodTypeANegative: {
            bloodType = @"A-";
            break;
        }
        case HKBloodTypeBPositive: {
            bloodType = @"B+";
            break;
        }
        case HKBloodTypeBNegative: {
            bloodType = @"B-";
            break;
        }
        case HKBloodTypeABPositive: {
            bloodType = @"AB+";
            break;
        }
        case HKBloodTypeABNegative: {
            bloodType = @"AB+";
            break;
        }
        case HKBloodTypeOPositive: {
            bloodType = @"O+";
            break;
        }
        case HKBloodTypeONegative: {
            bloodType = @"O-";
            break;
        }
        default: {
            break;
        }
    }
    
    // Get BMI
    __block HKQuantity *BMI;
    HKQuantityType *bmiType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    HKSampleQuery *bmiQuery = [[HKSampleQuery alloc] initWithSampleType:bmiType  predicate:nil limit:1 sortDescriptors:nil resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        if (results.count > 0) {
            HKQuantitySample *sample = (HKQuantitySample*)results[0];
            dispatch_async(dispatch_get_main_queue(), ^{
                BMI = sample.quantity;
            });
        }
        
    }];
    [self.healthStore executeQuery:bmiQuery];
    
    // Get Height
    __block HKQuantity *height;
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKSampleQuery *heightQuery = [[HKSampleQuery alloc] initWithSampleType:heightType  predicate:nil limit:1 sortDescriptors:nil resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        if (results.count > 0) {
            HKQuantitySample *sample = (HKQuantitySample*)results[0];
            dispatch_async(dispatch_get_main_queue(), ^{
                height = sample.quantity;
            });
        }
        
    }];
    [self.healthStore executeQuery:heightQuery];
    
    // Get Weight
    __block HKQuantity *weight;
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKSampleQuery *weightQuery = [[HKSampleQuery alloc] initWithSampleType:weightType  predicate:nil limit:1 sortDescriptors:nil resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        if (results.count > 0) {
            HKQuantitySample *sample = (HKQuantitySample*)results[0];
            dispatch_async(dispatch_get_main_queue(), ^{
                weight = sample.quantity;
            });
        }
        
    }];
    [self.healthStore executeQuery:weightQuery];
    
    // Get HR
    __block NSString *heartRate;
    HKQuantityType *heartType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    HKSampleQuery *heartQuery = [[HKSampleQuery alloc] initWithSampleType:heartType  predicate:nil limit:1 sortDescriptors:nil resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        if (results.count > 0) {
            HKQuantitySample *sample = (HKQuantitySample*)results[0];
            dispatch_async(dispatch_get_main_queue(), ^{
                double minutes_ago = floor([[NSDate date] timeIntervalSinceDate:sample.endDate]/60);
                NSString *mn_ago_string = minutes_ago <= 60.0 ? [NSString stringWithFormat:@"%ld mn ago", (long)minutes_ago] : [NSString stringWithFormat:@"> than 1h ago"];
                heartRate = [NSString stringWithFormat:@"%ld (%@)", (long)[sample.quantity doubleValueForUnit:[HKUnit unitFromString:@"count/min"]], mn_ago_string];
            });
        }
        
    }];
    [self.healthStore executeQuery:heartQuery];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sendTextMessageWithBirth:DOB andSex:sex andBloodType:bloodType andBMI:BMI andHeight:height andWeight:weight andHeartRate:heartRate];
    });
}

- (void)sendTextMessageWithBirth:(NSDate*)DOB
                          andSex:(NSString*)sex
                    andBloodType:(NSString*)bloodType
                          andBMI:(HKQuantity*)BMI
                       andHeight:(HKQuantity*)height
                       andWeight:(HKQuantity*)weight
                    andHeartRate:(NSString*)heartRate
{
    [SVProgressHUD dismiss];
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if (![MFMessageComposeViewController canSendText]) {
        [SVProgressHUD showErrorWithStatus:@"Can't send a text from this device"];
        return;
    }
        
    NSString *body = @"";
    
    // Location
    if (self.location) {
        body = [body stringByAppendingFormat:@"GPS: %f,%f (+/- %.01fm).\n", \
                self.location.coordinate.latitude, self.location.coordinate.longitude, self.location.horizontalAccuracy];
    }
    
    // Name
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME"]) {
        body = [body stringByAppendingFormat:@"Name: %@. ", [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME"]];
    }
    
    // Age
    if (DOB) {
        NSDate* now = [NSDate date];
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSCalendarUnitYear
                                           fromDate:DOB
                                           toDate:now
                                           options:0];
        NSInteger age = [ageComponents year];
        body = [body stringByAppendingFormat:@"Age: %li. ", (long)age];
    }
    
    // Sex
    if (sex) {
        body = [body stringByAppendingFormat:@"Sex: %@. ", sex];
    }
    
    // Height
    if (height) {
        body = [body stringByAppendingFormat:@"Height: %.02fft. ", [height doubleValueForUnit:[HKUnit footUnit]]];
    }
    
    // Weight
    if (weight) {
        body = [body stringByAppendingFormat:@"Weight: %ldlbs. ", (long)[weight doubleValueForUnit:[HKUnit poundUnit]]];
    }
    
    // BMI
    if (BMI) {
        body = [body stringByAppendingFormat:@"BMI: %.01f.\n", [BMI doubleValueForUnit:[HKUnit countUnit]]];
    }
    
    // HR
    if (heartRate) {
        body = [body stringByAppendingFormat:@"HR: %@.\n", heartRate];
    }
    
    // Breathing
    NSString *tmp = [[CurrentReport sharedReport] breathing] == notBreathing ? @" not " : @" ";
    body = [body stringByAppendingFormat:@"Victim%@breathing. ", tmp];
    
    // Severity
    tmp = [[CurrentReport sharedReport] injurySeverity] == nonCritical ? @"Non c" : @"C";
    body = [body stringByAppendingFormat:@"%@ritical injury. ", tmp];
    
    // Trauma
    body = [body stringByAppendingFormat:@"%@. ", [[CurrentReport sharedReport] traumaType]];
    
    // Body Part
    body = [body stringByAppendingFormat:@"\nBody Part hurt: %@.", [[CurrentReport sharedReport] bodyPartHurt]];
    
    // Related Tweets
    NSMutableDictionary *tweets = [[CurrentReport sharedReport] tweetsRelatedTo];
    if ([[tweets allKeys] count] > 0) {
        body = [body stringByAppendingString:@"\nNearby tweets related to:"];
        for (NSString *key in tweets) {
            body = [body stringByAppendingFormat:@"\n%@: %@", [key capitalizedString], [tweets objectForKey:key]];
        }
    }
    
    controller.body = body;
    controller.recipients = @[@"2911"];
    controller.messageComposeDelegate = self;

    // Fix blank view bug?
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:controller animated:YES completion:nil];
    });
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
