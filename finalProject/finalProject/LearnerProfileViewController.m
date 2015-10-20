//
//  LearnerProfileViewController.m
//  finalProject
//
//  Created by Justine Gartner on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "LearnerProfileViewController.h"
#import "JournalEntryTableViewCell.h"
#import "JournalEntryHeaderView.h"
#import "ColorData.h"



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

@property (nonatomic) JournalEntryTableViewCell *testCell;

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
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
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message: nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *setUsername = [UIAlertAction actionWithTitle:@"Set username" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            
                                                            [self setUsername];
                                                        }];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    UIAlertAction *choosePhoto = [UIAlertAction actionWithTitle:@"Choose photo" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                      
                                                          [self choosePhoto];
                                                      }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {}];
    
    
    [actionSheet addAction:setUsername];
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:choosePhoto];
    [actionSheet addAction:cancel];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void) setUsername {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Set username"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    __block UITextField *inputField;
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        inputField = textField;
    }];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              self.learnerUsernameLabel.text = inputField.text;
                                                              self.learner.learnerName = inputField.text;
                                                              [[NSUserDefaults standardUserDefaults] setObject:inputField.text forKey:@"username"];
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
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
}

#pragma mark - custom table view cells

-(void)setUpCustomTableViewCells{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.backgroundColor = [ColorData sharedModel].icicleGry;
    
    UINib *journalEntryNib = [UINib nibWithNibName:@"JournalEntryTableViewCell" bundle:nil];
    UINib *journalEntryHeader = [UINib nibWithNibName:@"JournalEntryHeaderView" bundle:nil];
    
    [self.tableView registerNib: journalEntryNib forCellReuseIdentifier:@"JournalEntryCellIdentifier"];
    [self.tableView registerNib:journalEntryHeader forHeaderFooterViewReuseIdentifier:@"JournalEntryHeaderIdentifier"];
    
    //self.testCell = [journalEntryNib instantiateWithOwner:nil options:nil][0];
}

#pragma mark - tableView data source methods

//- (void)configureCell:(JournalEntryTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    
//    JournalEntry *journalEntry = self.learner.journalEntries[indexPath.section];
//    
//    //cell.journalEntryLabel.text = journalEntry.entryText;
//    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    //[self configureCell:self.testCell atIndexPath:indexPath];
//    //[self.testCell layoutSubviews];
//    
//    CGFloat height = [self.testCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
//    return height + 1;
//}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.learner.journalEntries.count < 1) {
        
        return 0;
        
    }else {
        
        return self.learner.journalEntries.count;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.learner.journalEntries.count < 1) {
        
        return 0;
        
    }else {
        
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JournalEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JournalEntryCellIdentifier" forIndexPath:indexPath];
    
    JournalEntry *journalEntry = self.learner.journalEntries[indexPath.section];
    
    
    if (journalEntry.entryText != nil) {
        
        cell.journalEntryLabel.text = journalEntry.entryText;
        
    }
    
    if (journalEntry.entryPhoto != nil) {
        
        [journalEntry.entryPhoto getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if (!error) {
                
                cell.journalEntryImageView.image = [UIImage imageWithData:data];
            }
        }];
        
        
    }else {
        
        [self.view addSubview:cell.journalEntryImageView];
        //[self.view addSubview:cell.journalEntryLabel];
        
        cell.journalEntryImageView.frame = CGRectZero;
        //[cell.journalEntryLabel sizeToFit];
        
    }
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.learner.journalEntries removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        PFQuery *query = [PFQuery queryWithClassName:[JournalEntry parseClassName]];
        [query whereKey:@"entryTitle" equalTo:[self.learner.journalEntries objectAtIndex:indexPath.row][@"entryTitle"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            PFObject *object = objects[0];
            [object deleteInBackground];
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    NSString *formattedDateString = [dateFormatter stringFromDate:journalEntry.entryTimestamp];
    NSString *timestampString = [NSString stringWithFormat:@"%@", formattedDateString];
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
