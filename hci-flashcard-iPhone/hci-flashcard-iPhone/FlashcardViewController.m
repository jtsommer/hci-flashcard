//
//  FlashcardViewController.m
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/11/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "FlashcardViewController.h"
#import "Deck.h"
#import "Flashcard.h"

@interface FlashcardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *learnedControl;
@property (strong, nonatomic) NSNumber *interfaceState;
@property (strong, nonatomic) NSArray *flashcardSet;
@end

NSInteger currentIndex = 0;

typedef NS_ENUM(NSInteger, FlashcardStateIdentifier) {
    FlashcardStateFront,
    FlashcardStateBack
};

typedef NS_ENUM(NSInteger, LearnedControlState) {
    LearnedControlLearned = 0,
    LearnedControlNotLearned = 1
};

FlashcardStateIdentifier currentState;

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
    
    if (self.deckref) {
        if (!self.group) {
            self.group = GROUP_ENTIRE_DECK;
            NSLog(@"Group wasn't passed to FlashcardViewController");
        }
        NSPredicate *filterGroup;
        if ([self.group isEqualToString:GROUP_ENTIRE_DECK]) {
            // Don't filter, group is all cards
            self.flashcardSet = [self.deckref.cards allObjects];
        } else if ([self.group isEqualToString:GROUP_NOT_LEARNED]) {
            filterGroup = [NSPredicate predicateWithFormat:@"learned == NO"];
        } else {
            // Group learned
            filterGroup = [NSPredicate predicateWithFormat:@"learned == YES"];
        }
        // Use filtered card set for data
        if (filterGroup) {
            self.flashcardSet = [[self.deckref.cards filteredSetUsingPredicate:filterGroup] allObjects];
        }
    } else {
        NSLog(@"Deck wasn't passed to StudyViewCardsViewController");
    }
    
    if (self.flashcardSet.count > 0) {
        if (self.currentCard) {
            // A start card was passed into the view
            currentIndex = [self.flashcardSet indexOfObject:self.currentCard];
        } else {
            currentIndex = 0;
            self.currentCard = self.flashcardSet[currentIndex];
        }
        self.textLabel.text = self.currentCard.front;
        self.learnedControl.selectedSegmentIndex = self.currentCard.learned.integerValue;
    }
    
    currentState = FlashcardStateFront;
    [self.view makeToast:@"Tap anywhere to see flashcard back" duration:3.0 position:@"top"];
}

#pragma mark Input Actions

- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)learnedControlValueChanged:(id)sender {
    if (self.currentCard) {
        self.currentCard.learned = [NSNumber numberWithInteger:self.learnedControl.selectedSegmentIndex];
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    }
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.numberOfTapsRequired == 1) {
        if (currentState == FlashcardStateFront) {
            [self flipToFlashcardBack];
        } else if (currentState == FlashcardStateBack) {
            [self flipToFlashcardFront];
        }
    }
}

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self slideViewToSelf:UIViewAnimationTransitionFlipFromRight];
        [self nextCard];
    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self slideViewToSelf:UIViewAnimationTransitionFlipFromLeft];
        [self previousCard];
    }
}

#pragma mark Flashcard Methods

- (void)flipViewToSelf {
    [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations: nil completion:nil];
}


// Huge thanks to http://stackoverflow.com/q/9055465/3274404 on which this function was based
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

- (void)updateFlashcardCurrentState {
    [self updateFlashcardForState:currentState];
}

- (void)updateFlashcardForState:(FlashcardStateIdentifier)state {
    if (self.currentCard) {
        if (state == FlashcardStateFront) {
            self.textLabel.text = self.currentCard.front;
        } else if (state == FlashcardStateBack) {
            self.textLabel.text = self.currentCard.back;
        }
        self.learnedControl.selectedSegmentIndex = self.currentCard.learned.integerValue;
    }
}

- (void)flipToFlashcardBack {
    [self flipViewToSelf];
    currentState = FlashcardStateBack;
    [self updateFlashcardCurrentState];
}

- (void)flipToFlashcardFront {
    [self flipViewToSelf];
    currentState = FlashcardStateFront;
    [self updateFlashcardCurrentState];
}

- (void)nextCard {
    // Always flip to front when switching cards
    currentState = FlashcardStateFront;
    currentIndex++;
    if (currentIndex >= self.flashcardSet.count) {
        currentIndex = 0;
    }
    self.currentCard = self.flashcardSet[currentIndex];
    [self updateFlashcardCurrentState];
}

- (void)previousCard {
    // Always flip to front when switching cards
    currentState = FlashcardStateFront;
    currentIndex--;
    if (currentIndex < 0) {
        currentIndex = self.flashcardSet.count - 1;
        // No cards case, don't let it freak out with a negative index
        if (currentIndex < 0) {
            currentIndex = 0;
        }
    }
    self.currentCard = self.flashcardSet[currentIndex];
    [self updateFlashcardCurrentState];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
