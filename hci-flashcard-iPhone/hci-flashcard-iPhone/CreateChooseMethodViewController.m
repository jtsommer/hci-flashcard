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
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"typeNewCardsSegue"]) {
//        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        CreateNewCardViewController *newCardController = (CreateNewCardViewController *)segue.destinationViewController;
        newCardController.deckName = self.deckNameTextField.text;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
