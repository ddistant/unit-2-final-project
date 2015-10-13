//
//  LearnerProfileViewController.m
//  finalProject
//
//  Created by Justine Gartner on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "LearnerProfileViewController.h"

@interface LearnerProfileViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *learnerProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *learnerUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *learnerSkillLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LearnerProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.learner = [[Learner alloc] init];
    
    [self.learner loadLearnerSkill];
    
    [self setUpUI];
    
}

#pragma mark - UI

-(void)setUpUI{
    
    self.learnerSkillLabel.text = self.learner.skill.skillName;
}

#pragma mark - Table View Datasource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //return count of API results array
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JournalCellIdentifier" forIndexPath:indexPath];
    
    //configure cell
    
    return cell;
}


@end
