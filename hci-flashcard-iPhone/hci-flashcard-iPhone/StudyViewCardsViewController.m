//
//  StudyViewCardsViewController.m
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/11/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "StudyViewCardsViewController.h"
#import "Deck.h"
#import "Flashcard.h"

@interface StudyViewCardsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *flashcardSet;
@end

@implementation StudyViewCardsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Self count %d", self.flashcardSet.count);
    return self.flashcardSet.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudyViewCards"];
    
    Flashcard *flashcard = self.flashcardSet[indexPath.row];
    cell.textLabel.text = flashcard.front;

    
    return cell;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.deckref) {
        if (!self.group) {
            self.group = GROUP_ENTIRE_DECK;
            NSLog(@"Group wasn't passed to StudyViewCardsViewController");
        }
        NSPredicate *filterGroup;
        if ([self.group isEqualToString:GROUP_ENTIRE_DECK]) {
            // Don't filter, group is all cards
            self.flashcardSet = [self.deckref.cards allObjects];
        } else if ([self.group isEqualToString:GROUP_NOT_LEARNED]) {
            filterGroup = [NSPredicate predicateWithFormat:@"learned == NO"];
        } else {
            // Group learned
            filterGroup = [NSPredicate predicateWithFormat:@"learned == YES"];
        }
        // Use filtered card set for data
        if (filterGroup) {
            self.flashcardSet = [[self.deckref.cards filteredSetUsingPredicate:filterGroup] allObjects];
        }
    } else {
        NSLog(@"Deck wasn't passed to StudyViewCardsViewController");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
