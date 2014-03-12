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
@property (strong, nonatomic) NSNumber *interfaceState;
@end

const int FLASHCARD_STATE_FRONT = 1;
const int FLASHCARD_STATE_BACK = 2;
int currentState = 1;

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
    currentState = FLASHCARD_STATE_FRONT;
}

#pragma mark Input Actions

- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.numberOfTapsRequired == 1) {
        if (currentState == FLASHCARD_STATE_FRONT) {
            [self flipToFlashcardBack];
        } else if (currentState == FLASHCARD_STATE_BACK) {
            [self flipToFlashcardFront];
        }
    }
}

#pragma mark Flashcard Methods

- (void)flipViewToSelf {
    [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations: nil completion:nil];
}

- (void)flipToFlashcardBack {
    [self flipViewToSelf];
    self.textLabel.text = @"changed";
    currentState = FLASHCARD_STATE_BACK;
}

- (void)flipToFlashcardFront {
    [self flipViewToSelf];
    self.textLabel.text = @"Study";
    currentState = FLASHCARD_STATE_FRONT;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
