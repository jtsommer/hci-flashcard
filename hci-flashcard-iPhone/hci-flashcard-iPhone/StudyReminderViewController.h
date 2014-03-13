//
//  StudyReminderViewController.h
//  hci-flashcard-iPhone
//
//  Created by luaromer on 3/12/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface StudyReminderViewController : UIViewController
@property (strong,nonatomic) Deck *deckref;
@end
