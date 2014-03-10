//
//  CreateNewCardViewController.m
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/9/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "CreateNewCardViewController.h"

@interface CreateNewCardViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *frontCardTextView;
@property (weak, nonatomic) IBOutlet UITextView *backCardTextView;
@property (strong, nonatomic) NSArray *textViews;
@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) UIBarButtonItem *doneButton;
@end

@implementation CreateNewCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.textViews = @[self.frontCardTextView, self.backCardTextView];
    
    // Create buttons
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextTextView)];
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
}

- (void) nextTextView {
    [self.backCardTextView becomeFirstResponder];
}

- (void) doneEditing {
    [self.backCardTextView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    // Select all text of the given text field, defers one run loop to activate after insertion
    // Thanks http://stackoverflow.com/a/19065568/3274404
    [textView performSelector:@selector(selectAll:) withObject:self afterDelay:0.0];
    int i = [self.textViews indexOfObject:textView];
    if (i < [self.textViews count] - 1) {
        self.navigationItem.rightBarButtonItem = self.nextButton;
    } else {
        self.navigationItem.rightBarButtonItem = self.doneButton;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    // Probably don't need to overwrite this, when switching text views this gets called after
    // textViewShouldBeginEditing: on the new text field so deleting the button here is bad
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
