//
//  BreathingViewController.m
//  Emergency 911
//
//  Created by Anas Bouzoubaa on 26/11/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

#import "BreathingViewController.h"
#import "CurrentReport.h"

@interface BreathingViewController ()

@property (strong, nonatomic) IBOutlet UIButton *breathingButton;
@property (strong, nonatomic) IBOutlet UIButton *notBreathingButton;

@end

@implementation BreathingViewController

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
    if (sender == self.breathingButton) {
        [report setBreathing:breathing];
    } else {
        [report setBreathing:notBreathing];
    }
}

@end
