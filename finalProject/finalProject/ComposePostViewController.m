//
//  ComposePostViewController.m
//  finalProject
//
//  Created by Justine Gartner on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "ComposePostViewController.h"
#import "NYAlertViewController.h"
#import "ColorData.h"

@interface ComposePostViewController () <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (nonatomic) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *cameraIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) JournalEntry *post;

@end

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *skill = [[NSUserDefaults standardUserDefaults] objectForKey:LearnerSkillKey];

    self.textView.delegate = self;
    self.textView.text = [NSString stringWithFormat: @"How is your learning process going?\n\nWhat do you hope to accomplish today?\n\nWhat %@ lessons have been helpful?\n\nWhat are some of your challenges?", skill];
    self.textView.textColor = [UIColor lightGrayColor]; //optional
    [self.photoImageView setHidden:YES];
    [self.addPhotoButton setHidden:NO];
    [self.addPhotoButton setUserInteractionEnabled:YES];
    [self.cameraIconImageView setHidden:NO];
    
    [self setUpUI];
}

-(void)setUpUI{
    
    self.titleTextField.font = [UIFont fontWithName:@"TikalSansMedium" size:15];
    self.textView.font = [UIFont fontWithName:@"TikalSansMedium" size:15];

    [self.saveButton.titleLabel setFont: [UIFont fontWithName:@"TikalSansMedium" size:20]];
    [self.cancelButton.titleLabel setFont:[UIFont fontWithName:@"TikalSansMedium" size:18]];
    
    [self.saveButton setTitleColor:[ColorData sharedModel].chartreuseYel forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[ColorData sharedModel].icicleGry forState:UIControlStateNormal];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSString *skill = [[NSUserDefaults standardUserDefaults] objectForKey:LearnerSkillKey];
    
    if ([textView.text isEqualToString:[NSString stringWithFormat: @"How is your learning process going?\n\nWhat do you hope to accomplish today?\n\nWhat %@ lessons have been helpful?\n\nWhat are some of your challenges?", skill]]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *skill = [[NSUserDefaults standardUserDefaults] objectForKey:LearnerSkillKey];
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = [NSString stringWithFormat: @"How is your learning process going?\n\nWhat do you hope to accomplish today?\n\nWhat %@ lessons have been helpful?\n\nWhat are some of your challenges?", skill];
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}


- (IBAction)addPhotoButtonTapped:(id)sender {
    
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

- (IBAction)cancelButtonTapped:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonTapped:(id)sender {
    
    NSString *skill = [[NSUserDefaults standardUserDefaults] objectForKey:LearnerSkillKey];
    NSString *placeholder = [NSString stringWithFormat: @"How is your learning process going?\n\nWhat do you hope to accomplish today?\n\nWhat %@ lessons have been helpful?\n\nWhat are some of your challenges?", skill];
    
    if (![self.textView.text isEqualToString:placeholder]){
        
        self.post = [[JournalEntry alloc] init];
        self.post.entryTimestamp = [NSDate date];
        self.post.entryTitle = self.titleTextField.text;
        self.post.entryText = self.textView.text;
        
        if (self.photoImageView.image != nil) {
            
            NSData *imageData = UIImageJPEGRepresentation(self.photoImageView.image, 0.5f);
            self.post.entryPhoto = [PFFile fileWithData:imageData];
            
        }
        
        [self.post saveInBackground];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

#pragma mark - UIImagePickerDelegate methods

-(void) choosePhoto {
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.delegate = self;
    [self.imagePicker setAllowsEditing:NO];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
}

-(void) takePhoto {
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.delegate = self;
    [self.imagePicker setAllowsEditing:YES];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self.photoImageView setHidden:NO];
    [self.cameraIconImageView setHidden:YES];
    
    picker = self.imagePicker;
    UIImage *imageChosen = info[UIImagePickerControllerOriginalImage];
    self.photoImageView.image = imageChosen;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
