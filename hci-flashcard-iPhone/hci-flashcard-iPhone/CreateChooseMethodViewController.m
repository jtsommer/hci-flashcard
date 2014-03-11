//
//  CreateChooseMethodViewController.m
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/9/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "CreateChooseMethodViewController.h"
#import "CreateNewCardViewController.h"

@interface CreateChooseMethodViewController ()
@property (weak, nonatomic) IBOutlet UITextField *deckNameTextField;

@end

NSString * const TYPE_NEW_CARD_SEGUE = @"typeNewCardSegue";

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
        self.deckNameTextField.enabled = NO;
    }
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:TYPE_NEW_CARD_SEGUE]) {
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
                NSLog(@"Deck already exists");
            }
        } else {
            NSLog(@"Empty Deck name");
        }
    }
    return NO;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:TYPE_NEW_CARD_SEGUE]) {
//        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        CreateNewCardViewController *newCardController = (CreateNewCardViewController *)segue.destinationViewController;
//        newCardController.deckName = self.deckNameTextField.text;
        newCardController.deckref = self.deckref;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
