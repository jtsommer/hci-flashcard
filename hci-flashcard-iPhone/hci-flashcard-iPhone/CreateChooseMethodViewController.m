//
//  CreateChooseMethodViewController.m
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/9/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "CreateChooseMethodViewController.h"
#import "CreateNewCardViewController.h"

@interface CreateChooseMethodViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *deckNameTextField;

@end

NSString * const TYPE_NEW_CARD_SEGUE = @"typeNewCardSegue";
NSString * const DRAW_CARD_SEGUE = @"drawNewCardSegue";
NSString * const CSV_CONVERT_SEGUE = @"csvConvertSegue";

@implementation CreateChooseMethodViewController

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
        self.deckNameTextField.text = self.deckref.name;
        self.navigationItem.title = [NSString stringWithFormat:@"Create - %@", self.deckref.name];
        self.deckNameTextField.enabled = NO;
    }
}

- (void) presentAlertViewForError:(NSString *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change Deck Name"
                                                    message:error
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark TextField Delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Transition Views

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:TYPE_NEW_CARD_SEGUE] || [identifier isEqualToString:DRAW_CARD_SEGUE] || [identifier isEqualToString:CSV_CONVERT_SEGUE]) {
        if (self.deckref) {
            return YES;
        } else if (self.deckNameTextField.text.length > 0) {
            Deck *d = [Deck findFirstByAttribute:@"name" withValue:self.deckNameTextField.text];
            if (!d) {
                // Create a new deck, name is unique
                self.deckref = [Deck createEntity];
                self.deckref.name = self.deckNameTextField.text;
                return YES;
            } else {
                [self presentAlertViewForError:[NSString stringWithFormat:@"A flashcard deck with name \"%@\" already exists", self.deckNameTextField.text]];
            }
        } else {
            [self presentAlertViewForError:@"Please enter a name for your new flashcard deck"];
        }
    }
    return NO;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:TYPE_NEW_CARD_SEGUE]) {
//        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        CreateNewCardViewController *newCardController = (CreateNewCardViewController *)segue.destinationViewController;
        newCardController.deckref = self.deckref;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
