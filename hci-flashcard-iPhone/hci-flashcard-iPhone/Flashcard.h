//
//  Flashcard.h
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/6/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Flashcard : NSManagedObject

@property (nonatomic, retain) NSString * front;
@property (nonatomic, retain) NSString * back;
@property (nonatomic, retain) NSManagedObject *deck;

@end
