//
//  ConsciousViewController.m
//  Emergency 911
//
//  Created by Anas Bouzoubaa on 26/11/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

#import "ConsciousViewController.h"
#import "CurrentReport.h"

@interface ConsciousViewController ()

@property (strong, nonatomic) IBOutlet UIButton *consciousButton;
@property (strong, nonatomic) IBOutlet UIButton *unconsciousButton;

@end

@implementation ConsciousViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
