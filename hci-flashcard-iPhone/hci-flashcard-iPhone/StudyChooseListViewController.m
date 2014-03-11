//
//  FirstViewController.m
//  hci-flashcard-iPhone
//
//  Created by jtsommer on 3/2/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "StudyChooseListViewController.h"
#import "Deck.h"

@interface StudyChooseListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *decks;
@end

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

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self fetchDecks];

    
}

- (void)fetchDecks {
    self.decks = [[Deck findAllSortedBy:@"name" ascending:YES] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
