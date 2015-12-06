//
//  SignupViewController.m
//  Emergency 911
//
//  Created by Anas Bouzoubaa on 05/12/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

#import "SignupViewController.h"
#import <HealthKit/HealthKit.h>

@interface SignupViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) HKHealthStore *healthStore;

@end

@implementation SignupViewController

//------------------------------------------------------------------------------------------
#pragma mark - View lifecycle -
//------------------------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.healthStore = [[HKHealthStore alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.nameTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//------------------------------------------------------------------------------------------
#pragma mark - IBActions -
//------------------------------------------------------------------------------------------

- (IBAction)editingEnded:(id)sender {
    [self.nameTextField resignFirstResponder];
}

- (IBAction)doneAction:(id)sender {
    
    // No name, return
    if (self.nameTextField.text.length == 0) {
        [self.nameTextField becomeFirstResponder];
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"USER_SIGNED_UP"];
    [defaults setObject:self.nameTextField.text forKey:@"USER_NAME"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)requestHealthKit:(id)sender {
    
    NSSet *readTypes = [NSSet setWithObjects:
                        [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                        [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                        [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                        [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
                        [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBloodType],
                        [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                        [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                        nil];
    
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:readTypes completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            //
            
            
        } else {
            
            
        }
        
    }];
}

@end
