//
//  SecondViewController.m
//  hci-flashcard-iPhone
//
//  Created by jtsommer on 3/2/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "CreateEditListViewController.h"
#import "Deck.h"
#import "CreateChooseMethodViewController.h"

@interface CreateEditListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *decks;
@end

@implementation CreateEditListViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.decks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeckCell"];
    
    Deck *deck = self.decks[indexPath.row];
    cell.textLabel.text = deck.name;
    
    return cell;
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"createDeckSelected"]) {
        //        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        CreateChooseMethodViewController *chooseMethodController = (CreateChooseMethodViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Deck *deck = self.decks[indexPath.row];
        chooseMethodController.deckref = deck;
    }
}

- (void)fetchDecks {
    self.decks = [[Deck findAllSortedBy:@"name" ascending:YES] mutableCopy];
    NSLog(@"Fetch Decks - Create");
}

- (void)viewDidLoad
{
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

@end
