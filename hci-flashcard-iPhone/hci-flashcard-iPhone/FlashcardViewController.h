//
//  FlashcardViewController.h
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/11/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Deck;

@interface FlashcardViewController : UIViewController
@property (strong, nonatomic) Deck *deckref;
@property (strong, nonatomic) NSString *group;
@end
