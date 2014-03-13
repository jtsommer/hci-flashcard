//
//  CreateDrawCardViewController.h
//  hci-flashcard-iPhone
//
//  Created by luaromer on 3/13/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Flashcard;
@class Deck;

@interface CreateDrawCardViewController : UIViewController  {
    CGPoint lastPoint;
    CGFloat mark;
    CGFloat into;
    CGFloat black;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;


@property (strong, nonatomic) Flashcard *card;
@property (strong, nonatomic) NSString *deckName;
@property (strong, nonatomic) Deck *deckref;
@end
