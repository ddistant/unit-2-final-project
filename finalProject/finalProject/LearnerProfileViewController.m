//
//  LearnerProfileViewController.m
//  finalProject
//
//  Created by Justine Gartner on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "LearnerProfileViewController.h"

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
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.learnerUsernameLabel.text = textField.text;
    }];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    {};
}


#pragma mark - UI

-(void)setUpUI{
    
    self.learnerSkillLabel.text = self.learner.skill.skillName;
}

#pragma mark - tableView data source methods

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
