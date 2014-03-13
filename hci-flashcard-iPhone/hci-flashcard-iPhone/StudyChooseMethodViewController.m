//
//  StudyChooseMethodViewController.m
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/10/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "StudyChooseMethodViewController.h"
#import "StudyViewCardsViewController.h"
#import "FlashcardViewController.h"
#import "StudyReminderViewController.h"
#import "Deck.h"

@interface StudyChooseMethodViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *deckNameLabel;
@property (strong, nonatomic) NSString *segueToPerform;
@property (strong, nonatomic) NSString *group;
@end

// Strings for button action selection
NSString * const ACTION_STUDY = @"Study deck with which cards?";
NSString * const ACTION_MC = @"Generate multiple choice for which cards?";
NSString * const ACTION_VIEW = @"View which cards?";

// Strings for segues
NSString * const SEGUE_STUDY    = @"studyStudySegue";
NSString * const SEGUE_MC       = @"studyMCSegue";
NSString * const SEGUE_VIEW     = @"studyViewSegue";
NSString * const SEGUE_REMINDER = @"studyReminderSegue";

@implementation StudyChooseMethodViewController

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
        self.deckNameLabel.text = self.deckref.name;
    }
}

- (void) showCardSelectionAlertForTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:GROUP_ENTIRE_DECK, GROUP_LEARNED, GROUP_NOT_LEARNED, nil];
    [alert show];
}

#pragma mark Button Actions
- (IBAction)studyDeckPressed:(id)sender {
    [self showCardSelectionAlertForTitle:ACTION_STUDY];
    self.segueToPerform = SEGUE_STUDY;
}

- (IBAction)multipleChoicePressed:(id)sender {
    [self showCardSelectionAlertForTitle:ACTION_MC];
    self.segueToPerform = SEGUE_MC;
}

- (IBAction)viewCardsPressed:(id)sender {
    [self showCardSelectionAlertForTitle:ACTION_VIEW];
    self.segueToPerform = SEGUE_VIEW;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SEGUE_VIEW]) {
        StudyViewCardsViewController *viewCardsController = (StudyViewCardsViewController *)segue.destinationViewController;
        viewCardsController.deckref = self.deckref;
        viewCardsController.group = self.group;
    } else if ([segue.identifier isEqualToString:SEGUE_REMINDER]) {
        StudyReminderViewController *viewCardsController = (StudyReminderViewController *)segue.destinationViewController;
        viewCardsController.deckref = self.deckref;
    } else if ([segue.identifier isEqualToString:SEGUE_STUDY]) {
        FlashcardViewController *flashcardController = (FlashcardViewController *)segue.destinationViewController;
        flashcardController.deckref = self.deckref;
    }
        
}



#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *selection = [alertView buttonTitleAtIndex:buttonIndex];
    if ([selection isEqualToString:@"Cancel"]) {
        return;
    }
    self.group = selection;
//    if ([selection isEqualToString:GROUP_ENTIRE_DECK]) {
//        NSLog(@"Do something with entire deck");
//    } else if ([selection isEqualToString:GROUP_LEARNED]) {
//        NSLog(@"Do something with learned cards");
//    } else if ([selection isEqualToString:GROUP_NOT_LEARNED]) {
//        NSLog(@"Do something with unlearned cards");
//    }
    [self performSegueWithIdentifier:self.segueToPerform sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
