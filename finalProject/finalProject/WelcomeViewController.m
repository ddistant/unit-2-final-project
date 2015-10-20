//
//  WelcomeViewController.m
//  finalProject
//
//  Created by Justine Gartner on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import <Parse/Parse.h>
#import "WelcomeViewController.h"
#import "LearnerProfileViewController.h"
#import "Learner.h"

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic) Learner *learner;
@property (nonatomic) NSString *learnerSkill;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.learner = [[Learner alloc] init];
    
    self.textField.font = [UIFont fontWithName:@"TikalSansMedium" size:15];
    
}


#pragma mark - Navigation


- (IBAction)goButtonTapped:(UIButton *)sender {
    
    if (![self.textField.text isEqualToString:@""]) {
        
        self.learnerSkill = self.textField.text;
        
        [self segueToLearnerProfileViewControllerWith:self.learnerSkill];

    }
    
}

-(void)segueToLearnerProfileViewControllerWith: (NSString *)learnerSkill{
    
    UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    
    LearnerProfileViewController *learnerProfileVC = (LearnerProfileViewController *)([tabBarController viewControllers][0]);
    
    learnerProfileVC.learner = self.learner;
    
    [learnerProfileVC.learner setSkillWith:self.learnerSkill];
    
    [learnerProfileVC.learner saveLearnerSkill];
    
    [self presentViewController:tabBarController animated:YES completion:nil];
}

@end
