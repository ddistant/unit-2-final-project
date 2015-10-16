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
    [JournalEntry fetchAll:^(NSArray *results, NSError *error) {
        self.learner.journalEntries = [NSMutableArray arrayWithArray:results];
        [self.tableView reloadData];
    }];
    
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
    return self.learner.journalEntries.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JournalCellIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text = self.learner.journalEntries[indexPath.row][@"entryTitle"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.learner.journalEntries[indexPath.row][@"entryTimestamp"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.learner.journalEntries removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


@end
