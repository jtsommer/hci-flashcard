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

// Strings for card groups
//NSString * const GROUP_ENTIRE_DECK = @"Entire Deck";
//NSString * const GROUP_LEARNED = @"Cards I Know";
//NSString * const GROUP_NOT_LEARNED = @"Cards I Don't Know";

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
    return self.flashcardSet.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseDeck"];
    
    Flashcard *flashcard = self.flashcardSet[indexPath.row];
    cell.textLabel.text = flashcard.front;

    
    return cell;
    
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.deckref) {
        NSLog(@"Deck was passed properly");
        self.flashcardSet = [self.deckref.cards allObjects];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
