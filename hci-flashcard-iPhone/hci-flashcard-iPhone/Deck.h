//
//  Deck.h
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/6/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flashcard;

@interface Deck : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Flashcard *cards;

@end
