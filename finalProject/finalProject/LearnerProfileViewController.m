//
//  LearnerProfileViewController.m
//  finalProject
//
//  Created by Justine Gartner on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "LearnerProfileViewController.h"
#import "JournalEntryTextOnlyTableViewCell.h"
#import "JournalEntryTableViewCell.h"
#import "JournalEntryHeaderView.h"
#import "ColorData.h"
#import "NYAlertViewController.h"


@interface LearnerProfileViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (weak, nonatomic) IBOutlet UIImageView *learnerProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *learnerUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *learnerSkillLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) UIImagePickerController *imagePicker;

@end

@implementation LearnerProfileViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        // non-selected tab bar image
        UIImage *defaultImage = [[UIImage imageNamed:@"Create New"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // selected tab bar image
        UIImage *selectedImage = [[UIImage imageNamed:@"Create New Filled"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // set the tab bar item with a title and both images
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Journal" image:defaultImage selectedImage:selectedImage];
        
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.learner = [[Learner alloc] init];
    [self.learner loadLearnerSkill];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self.learner loadLearnerSkill];
    
    [JournalEntry fetchAll:^(NSArray *results, NSError *error) {
        
        self.learner.journalEntries = [NSMutableArray arrayWithArray:results];
        
        [self.tableView reloadData];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self setUpUI];
    [self setUpCustomTableViewCells];
    
}

- (IBAction)photoButtonTapped:(id)sender {
    
    [self showActionSheet];
}

- (void) setUsername {
    
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    // Set a title and message
    alertViewController.title = NSLocalizedString(@"Username", nil);
    alertViewController.message = nil;
    
    // Customize appearance as desired
    alertViewController.buttonCornerRadius = 20.0f;
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"TikalSansMedium" size:19.0f];
    alertViewController.messageFont = [UIFont fontWithName:@"TikalSansMedium" size:16.0f];
    alertViewController.buttonTitleFont = [UIFont fontWithName:@"TikalSansMedium" size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:@"TikalSansMedium" size:alertViewController.cancelButtonTitleFont.pointSize];
    
    alertViewController.swipeDismissalGestureEnabled = YES;
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    
    __block UITextField *inputField;
    [alertViewController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        inputField = textField;
    }];
    
    // Add alert actions
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              
                                                              self.learnerUsernameLabel.text = inputField.text;
                                                              self.learner.learnerName = inputField.text;
                                                              [[NSUserDefaults standardUserDefaults] setObject:inputField.text forKey:@"username"];
                                                              
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                              
                                                          }]];
    
    
    
    // Present the alert view controller
    [self presentViewController:alertViewController animated:YES completion:nil];
}

#pragma mark - Custom Alert Controller

-(void)showActionSheet{
    
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    // Set a title and message
    alertViewController.title = nil;
    alertViewController.message = nil;
    
    
    // Customize appearance as desired
    alertViewController.buttonCornerRadius = 20.0f;
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"TikalSansMedium" size:19.0f];
    alertViewController.messageFont = [UIFont fontWithName:@"TikalSansMedium" size:16.0f];
    alertViewController.buttonTitleFont = [UIFont fontWithName:@"TikalSansMedium" size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:@"TikalSansMedium" size:alertViewController.cancelButtonTitleFont.pointSize];
    
    alertViewController.swipeDismissalGestureEnabled = YES;
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    
    // Add alert actions
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Set Username", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                              [self setUsername];
                                                              
                                                          }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Take Photo", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                              [self takePhoto];
                                                           
                                                          }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Choose Photo", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                              [self choosePhoto];
                                                              
                                                          }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          
                                                          }]];

    
    // Present the alert view controller
    [self presentViewController:alertViewController animated:YES completion:nil];
}


#pragma mark - UI

-(void)setUpUI{
    
    self.learnerSkillLabel.text = self.learner.skill.skillName;
    
    if ([self.learner.learnerName isEqualToString:@""]) {
        
        self.learnerUsernameLabel.text = @"Set a username";
    
    } else {
        
        self.learner.learnerName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        self.learnerUsernameLabel.text = self.learner.learnerName;
    }
    
    
    if (([[NSUserDefaults standardUserDefaults] objectForKey:@"userPhoto"] == nil)) {
        self.learnerProfileImageView.image = [UIImage imageNamed:@"avatar_icon"];
    } else {
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhoto"];
        self.learnerProfileImageView.image = [UIImage imageWithData:imageData];
    }
    
}

#pragma mark - custom table view cells

-(void)setUpCustomTableViewCells{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.backgroundColor = [ColorData sharedModel].icicleGry;
    
    UINib *journalEntryTextOnlyNib = [UINib nibWithNibName:@"JournalEntryTextOnlyTableViewCell" bundle:nil];
    UINib *journalEntryNib = [UINib nibWithNibName:@"JournalEntryTableViewCell" bundle:nil];
    UINib *journalEntryHeader = [UINib nibWithNibName:@"JournalEntryHeaderView" bundle:nil];
    
    [self.tableView registerNib:journalEntryTextOnlyNib forCellReuseIdentifier:@"JournalEntryTextOnlyCellIdentifier"];
    [self.tableView registerNib: journalEntryNib forCellReuseIdentifier:@"JournalEntryCellIdentifier"];
    [self.tableView registerNib:journalEntryHeader forHeaderFooterViewReuseIdentifier:@"JournalEntryHeaderIdentifier"];
    
    //self.testCell = [journalEntryNib instantiateWithOwner:nil options:nil][0];
}

#pragma mark - tableView data source methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.learner.journalEntries.count) {
        
        return self.learner.journalEntries.count;
        
    }else {
        
        return 0;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JournalEntry *journalEntry = self.learner.journalEntries[indexPath.section];
    
    if (journalEntry.entryPhoto) {
        
        JournalEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JournalEntryCellIdentifier" forIndexPath:indexPath];
        
        [journalEntry.entryPhoto getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if (!error) {
                
                cell.journalEntryImageView.image = [UIImage imageWithData:data];
                cell.journalEntryLabel.text = journalEntry.entryText;
            }
        }];
        
        return cell;
        
    }else {
        
        JournalEntryTextOnlyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JournalEntryTextOnlyCellIdentifier" forIndexPath:indexPath];
        
        cell.journalEntryTextLabel.text = journalEntry.entryText;

        
        return cell;
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        PFObject *objectToDel = [self.learner.journalEntries objectAtIndex:indexPath.section];
        
        [tableView beginUpdates];
        
        [self.learner.journalEntries removeObjectAtIndex:indexPath.section];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // Section is now completely empty, so delete the entire section.
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                 withRowAnimation:UITableViewRowAnimationFade];
        
        
        [tableView endUpdates];
        
        
        [objectToDel deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            
            if (succeeded){
                
                NSLog(@"Object successfully deleted.");
                
                
            }else if (error){
                
                NSLog(@"Error");
                
            }
            
            [tableView reloadData];
            
        }];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    JournalEntryHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JournalEntryHeaderIdentifier"];
    
    JournalEntry *journalEntry = self.learner.journalEntries[section];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *formatterDateString = [dateFormatter stringFromDate:journalEntry.entryTimestamp];
    NSString *timestampString = [NSString stringWithFormat:@"%@", formatterDateString];
    
    headerView.titleLabel.text = journalEntry.entryTitle;
    headerView.timestampLabel.text = timestampString;
   
    
    return headerView;
}

#pragma mark - UIImagePickerDelegate methods

-(void) choosePhoto {
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.delegate = self;
    [self.imagePicker setAllowsEditing:NO];
    [self presentViewController:_imagePicker animated:YES completion:nil];
    
}

-(void) takePhoto {
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.delegate = self;
    [self.imagePicker setAllowsEditing:YES];
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    picker = _imagePicker;
    UIImage *imageChosen = info[UIImagePickerControllerOriginalImage];
    self.learnerProfileImageView.image = imageChosen;
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(imageChosen) forKey:@"userPhoto"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
