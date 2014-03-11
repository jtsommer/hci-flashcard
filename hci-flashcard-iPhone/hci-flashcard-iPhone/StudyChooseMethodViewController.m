//
//  StudyChooseMethodViewController.m
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/10/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "StudyChooseMethodViewController.h"

#import "Deck.h"

@interface StudyChooseMethodViewController ()
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end