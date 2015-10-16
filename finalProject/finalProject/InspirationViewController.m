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
#import "MeetUpResult.h"
#import "MeetUpTableViewCell.h"

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
    
    [self setUpTableView];
    [self setUpCustomTableViewCells];
    
    [self fetchYouTubeData];
    [self fetchCourseraData];
    [self fetchMeetupData];
    
}

#pragma mark - set up UI

-(void)setUpTableView{
    
    //tell the table view to auto adjust the height of each cell
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
}

-(void)setUpCustomTableViewCells{
    
    //grab the nibs from the main bundle
    UINib *meetUpNib = [UINib nibWithNibName:@"MeetUpTableViewCell" bundle:nil];
    UINib *videoNib = [UINib nibWithNibName:@"VideoTableViewCell" bundle:nil];
    UINib *courseNib = [UINib nibWithNibName:@"CourseTableViewCell" bundle:nil];
    
    //register the nibs for the cell identifier
    [self.tableView registerNib:meetUpNib forCellReuseIdentifier:@"MeetUpCellIdentifier"];
    [self.tableView registerNib:videoNib forCellReuseIdentifier:@"VideoCellIdentifier"];
    [self.tableView registerNib:courseNib forCellReuseIdentifier:@"CourseCellIdentifier"];
    
}


#pragma mark - Fetch API Data

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
        
        if (results.count < 1) {
            
            [self createAlertWithTitle:@"Search Error" AndMessage:@"No videos found"];
            
        }else {
            
            self.videoSearchResults = [[NSMutableArray alloc] init];
            
            for (NSDictionary *result in results) {
                
                [self.videoSearchResults addObject:result];
            }
            
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
}
- (void) fetchMeetupData {
    
    NSString *query = [[NSUserDefaults standardUserDefaults] objectForKey:LearnerSkillKey];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.meetup.com/2/open_events?&sign=true&zip=11215&photo-host=public&topic=%@&page=20&key=742c27514d305c6a3a72223524146c46&q=search&query=%@", query, query];
    
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    //fetch data from Meetup endpoint and add to array
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET: encodedString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *results = responseObject[@"results"];
        
        if (results.count < 1) {
            
            [self createAlertWithTitle:@"Search Error" AndMessage:@"No meetups found"];
            
        }else {
            
            self.meetupSearchResults = [[NSMutableArray alloc] init];
            
            for (NSDictionary *result in results) {
                
                MeetUpResult *event = [[MeetUpResult alloc] initWithJSON:result];
                
                [self.meetupSearchResults addObject:event];
            }
            
            [self.tableView reloadData];
            
        }

        
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
        
        if (results.count < 1) {
            
            [self createAlertWithTitle:@"Search Error" AndMessage:@"No tutorials found"];
            
        }else {
            
            self.courseraSearchResults = [[NSMutableArray alloc] init];
            
            for (NSDictionary *result in results) {
                
                [self.courseraSearchResults addObject:result];
            }
            
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
    
}

#pragma mark - Alert Controller

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
        
        MeetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetUpCellIdentifier" forIndexPath:indexPath];
        
        MeetUpResult *event = self.meetupSearchResults[indexPath.row];
        
        cell.eventNameLabel.text = event.eventName;
        cell.groupNameLabel.text = event.groupName;
        cell.descriptionLabel.text = event.eventDescription;
        cell.locationNameLabel.text = event.locationName;
        cell.locationAddressLabel.text = event.locationAddress;
        
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
