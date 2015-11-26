//
//  ViewController.m
//  Emergency 911
//
//  Created by Anas Bouzoubaa on 26/11/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) IBOutlet UIButton *myselfButton;
@property (nonatomic, assign) IBOutlet UIButton *someoneElseButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender == self.myselfButton) {
        //
    } else {
        //
    }
}

@end
