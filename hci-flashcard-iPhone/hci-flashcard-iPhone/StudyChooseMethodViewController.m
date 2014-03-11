//
//  StudyChooseMethodViewController.m
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/10/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "StudyChooseMethodViewController.h"

#import "Deck.h"

@interface StudyChooseMethodViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *deckNameLabel;

@end

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

- (void) showCardSelectionAlertForString:(NSString *)action {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ which cards?", action] message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Entire Deck", @"Cards I Know", @"Cards I Don't Know", nil];
    [alert show];
}

#pragma mark Button Actions
- (IBAction)studyDeckPressed:(id)sender {
    [self showCardSelectionAlertForString:@"Study deck with"];
}

- (IBAction)multipleChoicePressed:(id)sender {
    [self showCardSelectionAlertForString:@"Generate multiple choice for"];
}

- (IBAction)viewCardsPressed:(id)sender {
    [self showCardSelectionAlertForString:@"View"];
}



#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
