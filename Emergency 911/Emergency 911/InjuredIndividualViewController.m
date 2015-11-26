//
//  ViewController.m
//  Emergency 911
//
//  Created by Anas Bouzoubaa on 26/11/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

#import "InjuredIndividualViewController.h"
#import "CurrentReport.h"

@interface InjuredIndividualViewController ()

@property (nonatomic, strong) IBOutlet UIButton *myselfButton;
@property (nonatomic, strong) IBOutlet UIButton *someoneElseButton;

@end

@implementation InjuredIndividualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
