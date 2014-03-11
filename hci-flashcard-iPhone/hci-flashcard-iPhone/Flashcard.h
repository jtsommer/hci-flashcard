//
//  Flashcard.h
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/10/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Deck;

@interface Flashcard : NSManagedObject

@property (nonatomic, retain) NSString * back;
@property (nonatomic, retain) NSString * front;
@property (nonatomic, retain) NSNumber * learned;
@property (nonatomic, retain) Deck *deck;

@end
