//
//  ClassificationViewController.m
//  Emergency 911
//
//  Created by Anas Bouzoubaa on 26/11/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

#import "ClassificationViewController.h"
#import "CurrentReport.h"

@interface ClassificationViewController ()

@property (strong, nonatomic) IBOutlet UIButton *criticalButton;
@property (strong, nonatomic) IBOutlet UIButton *nonCriticalButton;

@end

@implementation ClassificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CurrentReport *report = [CurrentReport sharedReport];
    if (sender == self.criticalButton) {
        [report setInjurySeverity:critical];
    } else {
        [report setInjurySeverity:nonCritical];
    }
}

@end
