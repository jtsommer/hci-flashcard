//
//  CreateDrawCardViewController.m
//  hci-flashcard-iPhone
//
//  Created by luaromer on 3/13/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "CreateDrawCardViewController.h"
#import "Flashcard.h"
#import "Deck.h"

@interface CreateDrawCardViewController ()

@property (weak, nonatomic) IBOutlet UITextView *frontCardTextView;
@property (weak, nonatomic) IBOutlet UIView *backCardDrawView;
@property (strong, nonatomic) NSArray *textViews;
@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) UIBarButtonItem *doneButton;
- (IBAction)draw:(id)sender;
- (IBAction)erase:(id)sender;

@end

@implementation CreateDrawCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    mark = 0.0/255.0;
    into = 0.0/255.0;
    black = 0.0/255.0;
    brush = 5.0;
    opacity = 1.0;
    
    [super viewDidLoad];
}
    /*
	// Do any additional setup after loading the view.
    self.textViews = @[self.frontCardTextView];
    
    // Create buttons
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextTextView)];
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    // Set Navigation title
    if (!self.deckName) {
        self.deckName = self.deckref.name;
    }
    self.navigationItem.title = [NSString stringWithFormat:@"New - %@", self.deckName];
    // Create a flashcard if none exists
    if (!self.card) {
        self.card = [Flashcard createEntity];
    }
}

#pragma mark Text View Methods

- (void) nextTextView {
    //[self.backCardTextView becomeFirstResponder];
}

- (void) doneEditing {
    //[self.backCardTextView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)animateTextView:(UITextView*)textView up:(BOOL)up {
    const int movementDistance = -10; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextView" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    // Select all text of the given text field, defers one run loop to activate after insertion
    // Thanks http://stackoverflow.com/a/19065568/3274404
    [textView performSelector:@selector(selectAll:) withObject:self afterDelay:0.0];
    int i = [self.textViews indexOfObject:textView];
    if (i < [self.textViews count] - 1) {
        self.navigationItem.rightBarButtonItem = self.nextButton;
    } else {
        self.navigationItem.rightBarButtonItem = self.doneButton;
    }
    // If this is the second text field animate upwards from behind the keyboard
    //if ([textView isEqual:self.backCardTextView]) {
    //    [self animateTextView:textView up:YES];
    //}
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    // Probably don't need to overwrite this, when switching text views this gets called after
    // textViewShouldBeginEditing: on the new text field so deleting the button here is bad
    //if ([textView isEqual:self.backCardTextView]) {
    //    [self animateTextView:textView up:NO];
    //}
    return YES;
}

#pragma mark Button Actions

- (void) saveTextViewsToCard {
    if (self.deckref) {
        self.card.front = self.frontCardTextView.text;
    //    self.card.back = self.backCardTextView.text;
        self.card.deck = self.deckref;
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:nil];
    } else {
        NSLog(@"Deck not found. You done goofed :-(");
    }
}

- (IBAction)savePressed:(id)sender {
    [self saveTextViewsToCard];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)createPressed:(id)sender {
    [self saveTextViewsToCard];
    // Create a new flashcard so the old one doesn't get overwritten
    self.card = [Flashcard createEntity];
    self.frontCardTextView.text = @"Front side text goes here...";
    //self.backCardTextView.text = @"Back side text goes here...";
}

     */
     
//drawing actions
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), mark, into, black, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), mark, into, black, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

- (IBAction)draw:(id)sender {
    
    mark = 0.0/255.0;
    into = 0.0/255.0;
    black = 0.0/255.0;
    brush = 5.0;

}

- (IBAction)erase:(id)sender {
    
    mark = 248.0/255.0;
    into = 248.0/255.0;
    black = 248.0/255.0;
    brush = 18.0;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end