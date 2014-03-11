//
//  FirstViewController.m
//  hci-flashcard-iPhone
//
//  Created by jtsommer on 3/2/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "StudyChooseListViewController.h"
#import "Deck.h"

@interface StudyChooseListViewController ()
@property (strong, nonatomic) NSMutableArray *decks;
@end

NSString * const SORT_KEY_NAME   = @"name";
NSString * const SORT_KEY_RATING = @"beerDetails.rating";
NSString * const WB_SORT_KEY     = @"WB_SORT_KEY";

@implementation StudyChooseListViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// Load list of decks from DB
    [self fetchDecks];
    for (int i = 0; i < self.decks.count; i++) {
        Deck *d = (Deck *) self.decks[i];
        NSLog(@"Deck Name %@", d.name);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)fetchDecks {
    self.decks = [[Deck findAllSortedBy:@"name" ascending:YES] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
