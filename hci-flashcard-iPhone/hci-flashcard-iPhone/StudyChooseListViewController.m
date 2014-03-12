//
//  FirstViewController.m
//  hci-flashcard-iPhone
//
//  Created by jtsommer on 3/2/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "StudyChooseListViewController.h"
#import "Deck.h"
#import "StudyChooseMethodViewController.h"

@interface StudyChooseListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *decks;
@end

@implementation StudyChooseListViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// Load list of decks from DB
    [self fetchDecks];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.decks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseDeck"];
    
    Deck *deck = self.decks[indexPath.row];
    cell.textLabel.text = deck.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Cards: %d", deck.cards.count];
    
    return cell;
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"studyDeckSelected"]) {
        //        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        StudyChooseMethodViewController *chooseMethodController = (StudyChooseMethodViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"Index row selected %d ", indexPath.row);
        Deck *deck = self.decks[indexPath.row];
        chooseMethodController.deckref = deck;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self fetchDecks];
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
    if (parent) {
        // viewDidLoad doesn't get called when coming back off the navigation stack
        // Fetch decks and refresh the table here so if a new deck was created
        // it will load properly
        [self fetchDecks];
        [self.tableView reloadData];
    }
}

- (void)fetchDecks {
    self.decks = [[Deck findAllSortedBy:@"name" ascending:YES] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
