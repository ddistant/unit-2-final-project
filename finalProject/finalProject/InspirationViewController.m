//
//  InspirationViewController.m
//  finalProject
//
//  Created by Justine Gartner on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "InspirationViewController.h"
#import "VideoDetailViewController.h"

@interface InspirationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic) NSMutableArray *results;

@end

@implementation InspirationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - Table View Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        
        [self instantiateVideoDetailController];
    }
}


#pragma mark - Table View Datasource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        //return count of Tutorials API Array
        return 10;
        
    }else if (self.segmentedControl.selectedSegmentIndex == 1){
        
        //return the results of the Videos API Array
        return 10;
        
    }else {
        
        //return count of MeetUps API results array
        return 10;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        //replace with custom Tutorials Cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InspirationCellIdentifier" forIndexPath:indexPath];
        
        //testing cell
        cell.textLabel.text = @"testTutorialsCellTitle";
        cell.detailTextLabel.text = @"testCellDetail";
        
        return cell;
       
        
    }else if (self.segmentedControl.selectedSegmentIndex == 1){
        
        //replace with custom Videos cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InspirationCellIdentifier" forIndexPath:indexPath];
        
        //testing cell
        cell.textLabel.text = @"testVideosCellTitle";
        cell.detailTextLabel.text = @"testCellDetail";
        
        return cell;
        
    }else {
        
        //replace with custom Meet-Ups cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InspirationCellIdentifier" forIndexPath:indexPath];
        
        //testing cell
        cell.textLabel.text = @"testMeet-UpsCellTitle";
        cell.detailTextLabel.text = @"testCellDetail";
        
        return cell;
    }
}


#pragma mark - segmented control

- (IBAction)segmentedControlSelected:(UISegmentedControl *)sender {
    
    [self.tableView reloadData];
    
}


#pragma mark - video detail view controller

-(void)instantiateVideoDetailController{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    VideoDetailViewController *videoDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"VideoDetailViewController"];
    
    [self presentViewController:videoDetailVC animated:YES completion:nil];
    
    NSLog(@"did select row in Video segment");
    
}


@end
