//
//  ComposePostViewController.m
//  finalProject
//
//  Created by Justine Gartner on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "ComposePostViewController.h"

@interface ComposePostViewController () <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (nonatomic) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *cameraIconImageView;

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
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message: nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {}];
    
    UIAlertAction *choosePhoto = [UIAlertAction actionWithTitle:@"Choose photo" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            
                                                            [self choosePhoto];
                                                        }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {}];
    
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:choosePhoto];
    [actionSheet addAction:cancel];
    [self presentViewController:actionSheet animated:YES completion:nil];
 
}

- (IBAction)cancelButtonTapped:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonTapped:(id)sender {
    
    JournalEntry *post = [[JournalEntry alloc] init];
    post.entryTimestamp = [NSDate date];
    post.entryTitle = self.titleTextField.text;
    post.entryText = self.textView.text;
    post.entryPhoto = self.photoImageView.image;
    [post saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
