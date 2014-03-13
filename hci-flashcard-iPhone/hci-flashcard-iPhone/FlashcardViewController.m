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
    [self.view makeToast:@"Tap anywhere to see flashcard back" duration:4.0 position:@"top"];
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

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swipe Left");
        [self slideViewToSelf:UIViewAnimationTransitionFlipFromRight];
        self.textLabel.text = @"Left";
    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe Right");
        [self slideViewToSelf:UIViewAnimationTransitionFlipFromLeft];
        self.textLabel.text = @"Right";
    }
}

#pragma mark Flashcard Methods

- (void)flipViewToSelf {
    [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations: nil completion:nil];
}

- (void)slideViewToSelf: (UIViewAnimationTransition) direction {
    
    UIGraphicsBeginImageContext(self.view.window.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    iv.image = image;
    UIWindow *w = self.view.window;
    [w insertSubview:iv belowSubview:self.view];
    // Switch based on direction
    CGFloat newX;
    if (direction == UIViewAnimationTransitionFlipFromLeft) {
        newX = -self.view.frame.size.width;
    } else {
        newX = self.view.frame.size.width;
    }
    self.view.frame = CGRectMake(newX, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        iv.frame = CGRectMake(-newX, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [iv removeFromSuperview];
    }];

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
