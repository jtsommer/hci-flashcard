//
//  SecondViewController.m
//  hci-flashcard-iPhone
//
//  Created by jtsommer on 3/2/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "CreateEditListViewController.h"
#import "Deck.h"

@interface CreateEditListViewController () <UITableViewDataSource, UITableViewDelegate>

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

- (void)fetchDecks {
    self.decks = [[Deck findAllSortedBy:@"name" ascending:YES] mutableCopy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self fetchDecks];
}

@end
