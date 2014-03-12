//
//  FlashcardViewController.m
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/11/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "FlashcardViewController.h"

@interface FlashcardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

const int FLASHCARD_STATE_FRONT = 1;
const int FLASHCARD_STATE_BACK = 2;

@implementation FlashcardViewController

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
}

#pragma mark Input Actions

- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.numberOfTapsRequired == 1) {
        [self flipToFlashcardBack];
    }
}

#pragma mark Flashcard Methods

- (void)flipViewToSelf {
    [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations: nil completion:nil];
}

- (void)flipToFlashcardBack {
    [self flipViewToSelf];
    self.textLabel.text = @"changed";
}

- (void)flipToFlascardFront {
    [self flipViewToSelf];
    self.textLabel.text = @"Study";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
