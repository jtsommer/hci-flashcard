//
//  CreateNewCardViewController.m
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/9/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "CreateNewCardViewController.h"
#import "Flashcard.h"
#import "Deck.h"

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
    // Set Navigation title
    if (!self.deckName) {
        self.deckName = self.deckref.name;
    }
    self.navigationItem.title = [NSString stringWithFormat:@"New - %@", self.deckName];
    // Create a flashcard if none exists
    if (!self.card) {
        self.card = [Flashcard createEntity];
    }
}

#pragma mark Text View Methods

- (void) nextTextView {
    [self.backCardTextView becomeFirstResponder];
}

- (void) doneEditing {
    [self.backCardTextView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)animateTextView:(UITextView*)textView up:(BOOL)up {
    const int movementDistance = -130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextView" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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
    // If this is the second text field animate upwards from behind the keyboard
    if ([textView isEqual:self.backCardTextView]) {
        [self animateTextView:textView up:YES];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    // Probably don't need to overwrite this, when switching text views this gets called after
    // textViewShouldBeginEditing: on the new text field so deleting the button here is bad
    if ([textView isEqual:self.backCardTextView]) {
        [self animateTextView:textView up:NO];
    }
    return YES;
}

#pragma mark Button Actions

- (void) saveTextViewsToCard {
    if (self.deckref) {
        NSLog(@"Deck Found!");
        self.card.front = self.frontCardTextView.text;
        self.card.back = self.backCardTextView.text;
        self.card.deck = self.deckref;
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:nil];
    } else {
        NSLog(@"Deck not found. You done goofed :-(");
    }
}

- (IBAction)savePressed:(id)sender {
    [self saveTextViewsToCard];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)createPressed:(id)sender {
    [self saveTextViewsToCard];
    // Create a new flashcard so the old one doesn't get overwritten
    self.card = [Flashcard createEntity];
    self.frontCardTextView.text = @"Front side text goes here...";
    self.backCardTextView.text = @"Back side text goes here...";
}


#pragma mark

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
