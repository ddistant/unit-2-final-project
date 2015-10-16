//
//  ComposePostViewController.m
//  finalProject
//
//  Created by Justine Gartner on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "ComposePostViewController.h"

@interface ComposePostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;

@end

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *skill = [[NSUserDefaults standardUserDefaults] objectForKey:LearnerSkillKey];
    
    self.textView.text = [NSString stringWithFormat: @"How is your learning process going?\n\nWhat do you hope to accomplish today?\n\nWhat %@ lessons have been helpful?\n\nWhat are some of your challenges?", skill];
    
}

- (IBAction)cancelButtonTapped:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonTapped:(id)sender {
    
    JournalEntry *post = [[JournalEntry alloc] init];
    post.entryTimestamp = [NSDate date];
    post.entryTitle = self.titleTextField.text;
    post.entryText = self.textView.text;
    [post saveEventually:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
    
}

@end
