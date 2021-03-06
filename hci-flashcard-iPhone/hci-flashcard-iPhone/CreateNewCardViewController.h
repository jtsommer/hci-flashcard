//
//  CreateNewCardViewController.h
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/9/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Flashcard;
@class Deck;

@interface CreateNewCardViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) Flashcard *card;
@property (strong, nonatomic) NSString *deckName;
@property (strong, nonatomic) Deck *deckref;
@end
