//
//  InspirationViewController.m
//  finalProject
//
//  Created by Justine Gartner on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#import "InspirationViewController.h"
#import "VideoDetailViewController.h"
#import "Learner.h"
#import "CourseResult.h"
#import "CourseTableViewCell.h"
#import "MeetUpResult.h"
#import "MeetUpTableViewCell.h"
#import "VideoResult.h"
#import "VideoTableViewCell.h"
#import "NSString+NSString_Sanitize.h"
#import "Quotes.h"

const NSString *YouTubeAPIKey = @"AIzaSyDWWRZm36qjmntxljA2-MjDlEdLAPVSrJk";

@interface InspirationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *refineSearchButton;
@property (weak, nonatomic) IBOutlet UITextField *refineSearchTextField;
@property (weak, nonatomic) IBOutlet UILabel *quotesLabel;

@property (nonatomic) NSMutableArray *results;

@end

@implementation InspirationViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        // non-selected tab bar image
        UIImage *defaultImage = [[UIImage imageNamed:@"Idea-teal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // selected tab bar image
        UIImage *selectedImage = [[UIImage imageNamed:@"Idea Filled-teal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // set the tab bar item with a title and both images
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Inspiration" image:defaultImage selectedImage:selectedImage];
        
        return self;
    }
    return nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setUpTableView];
    [self setUpCustomTableViewCells];
    
    [self fetchYouTubeData];
    [self fetchCourseraData];
    [self fetchMeetupData];
    
    Quotes *quoteArray = [[Quotes alloc] init];
    
    
    u_int32_t rnd = arc4random_uniform((u_int32_t)[quoteArray.quotes count]);
    NSLog(@"%@", @(rnd));
    
    
    self.quotesLabel.text = [quoteArray.quotes objectAtIndex:rnd];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.refineSearchTextField.hidden = YES;
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
                
                VideoResult *video = [[VideoResult alloc] initWithJSON:result];
                
                [self.videoSearchResults addObject:video];
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
                
                CourseResult *course = [[CourseResult alloc] initWithJSON:result];
                
                [self.courseraSearchResults addObject:course];
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
    else if (self.segmentedControl.selectedSegmentIndex == 2) {
        
        MeetUpResult *event = self.meetupSearchResults[indexPath.row];

        [[UIApplication sharedApplication] openURL:event.eventURLLabel];
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
        
        CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCellIdentifier" forIndexPath:indexPath];
        
        CourseResult *course = self.courseraSearchResults[indexPath.row];
        
        cell.courseNameLabel.text = course.courseName;
        cell.descriptionLabel.text = course.courseDescription;
        
        NSURL *url = [NSURL URLWithString:course.iconURL];
        
        [cell.iconImageView sd_setImageWithURL:url
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         
                                         cell.iconImageView.image = image;
                                         
                                     }];
        
        return cell;
        
        
    } else if (self.segmentedControl.selectedSegmentIndex == 1){
        
        VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCellIdentifier" forIndexPath:indexPath];
        
        VideoResult *video = self.videoSearchResults[indexPath.row];
        
        cell.titleLabel.text = video.title;
        cell.descriptionLabel.text = video.videoDescription;
        
        NSURL *url = [NSURL URLWithString:video.thumbnailURL];
        
        [cell.thumbnailImageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            cell.thumbnailImageView.image = image;
            
        }];
        
        return cell;
        
    } else {
        
        MeetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetUpCellIdentifier" forIndexPath:indexPath];
        
        MeetUpResult *event = self.meetupSearchResults[indexPath.row];
        
        cell.eventNameLabel.text = event.eventName;
        cell.groupNameLabel.text = event.groupName;
        
        NSString *stringToSanitze = [event.eventDescription stringByStrippingHTML];
        cell.descriptionLabel.text = stringToSanitze;
        
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
    
    VideoResult *video = self.videoSearchResults[indexPath.row];
    
    videoDetailVC.videoID = video.videoID;
    
    [self presentViewController:videoDetailVC animated:YES completion:nil];
    
    NSLog(@"did select row in Video segment");
    
}

- (IBAction)refineSearchButtonTapped:(UIButton *)sender {
    
    self.refineSearchTextField.hidden = NO;
    
}



@end
