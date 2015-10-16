//
//  InspirationViewController.m
//  finalProject
//
//  Created by Justine Gartner on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "InspirationViewController.h"
#import "VideoDetailViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Learner.h"

const NSString *YouTubeAPIKey = @"AIzaSyDWWRZm36qjmntxljA2-MjDlEdLAPVSrJk";

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
    
    [self fetchYouTubeData];
    [self fetchCourseraData];
    [self fetchMeetupData];
    
}

- (void) fetchYouTubeData {
    /* Endpoints required
     
     title - video title
     
     description - short video description
     
     thumbnails - a dictionary of thumbnails
     
     videoID - how YouTube determines which video to play in the player
     
     */
    
    //create YouTube URL
    
    NSString *query = [[NSUserDefaults standardUserDefaults] objectForKey:LearnerSkillKey];
    
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=20&order=viewCount&q=%@&type=video&key=%@", query, YouTubeAPIKey];
    
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //fetch data from YouTube endpoint and add to array
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET: encodedString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *results = responseObject[@"items"];
        
        self.videoSearchResults = [[NSMutableArray alloc] init];
        
        for (NSDictionary *result in results) {
            
            [self.videoSearchResults addObject:result];
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
}
- (void) fetchMeetupData {
    
    NSString *query = [[NSUserDefaults standardUserDefaults] objectForKey:LearnerSkillKey];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.meetup.com/2/open_events?&sign=true&zip=11215&photo-host=public&page=20&key=742c27514d305c6a3a72223524146c46&q=search&query=%@", query];
    
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //fetch data from Coursera endpoint and add to array
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET: encodedString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *results = responseObject[@"results"];
        
        self.meetupSearchResults = [[NSMutableArray alloc] init];
        
        for (NSDictionary *result in results) {
            
            [self.meetupSearchResults addObject:result];
            if (results.count < 1) {
                [self createAlertWithTitle:@"Search Error" AndMessage:@"No meetups found"];
            }
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
    
}
- (void) fetchCourseraData {
       
    NSString *query = [[NSUserDefaults standardUserDefaults] objectForKey:LearnerSkillKey];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.coursera.org/api/catalog.v1/courses?fields=smallIcon,shortDescription,name&q=search&query=%@", query];
    
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //fetch data from Coursera endpoint and add to array
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET: encodedString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *results = responseObject[@"elements"];
        
        self.courseraSearchResults = [[NSMutableArray alloc] init];
        
        for (NSDictionary *result in results) {
            
            [self.courseraSearchResults addObject:result];
            if (results.count < 1) {
                [self createAlertWithTitle:@"Search Error" AndMessage:@"No tutorials found"];
            }
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
    
}

- (void) createAlertWithTitle:(NSString *)title AndMessage:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
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
        
    //return count of Coursera API Array
        return  self.courseraSearchResults.count;
                
    } else if (self.segmentedControl.selectedSegmentIndex == 1){
        
        //return the results of the Videos API Array
        return self.videoSearchResults.count;
        
    } else {
        
        //return count of MeetUps API results array
        return self.meetupSearchResults.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.segmentedControl.selectedSegmentIndex == UIControlEventValueChanged ) {
        [self.tableView reloadData];
    }
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        //replace with custom Tutorials Cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InspirationCellIdentifier" forIndexPath:indexPath];
        
        //testing cell
        cell.textLabel.text = self.courseraSearchResults[indexPath.row][@"name"];
        cell.detailTextLabel.text = self.courseraSearchResults[indexPath.row][@"shortDescription"];
        
        NSString *imageURLString = self.courseraSearchResults[indexPath.row][@"smallIcon"];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData scale:1.0];
        cell.imageView.image = image;
    
        return cell;
       
        
    } else if (self.segmentedControl.selectedSegmentIndex == 1){
        
        //replace with custom Videos cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InspirationCellIdentifier" forIndexPath:indexPath];
        
        //testing cell
        cell.textLabel.text = self.videoSearchResults[indexPath.row][@"snippet"][@"title"];;
        cell.detailTextLabel.text = self.videoSearchResults[indexPath.row][@"snippet"][@"description"];
        NSString *imageURLString = self.videoSearchResults[indexPath.row][@"snippet"][@"thumbnails"][@"default"][@"url"];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        cell.imageView.image = [UIImage imageWithData:imageData];
        
        return cell;
        
    } else {
        
        //replace with custom Meet-Ups cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InspirationCellIdentifier" forIndexPath:indexPath];
        
        //cell
        cell.textLabel.text = self.meetupSearchResults[indexPath.row][@"name"];
        cell.detailTextLabel.text = self.meetupSearchResults[indexPath.row][@"description"];
        cell.imageView.image = nil;
        
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
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    videoDetailVC.videoID = self.videoSearchResults[indexPath.row][@"id"][@"videoId"];
    
    [self presentViewController:videoDetailVC animated:YES completion:nil];
    
    NSLog(@"did select row in Video segment");
    
}


@end
