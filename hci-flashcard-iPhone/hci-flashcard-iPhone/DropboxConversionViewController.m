//
//  DropboxConversionViewController.m
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/12/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "DropboxConversionViewController.h"
#import <DBChooser/DBChooser.h>
#import "CHCSVParser.h"
#import "Deck.h"
#import "Flashcard.h"

@interface DropboxConversionViewController ()

@end

@implementation DropboxConversionViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark Dropbox

#pragma mark

- (IBAction)linkPressed:(id)sender {
    [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypeDirect
                                    fromViewController:self completion:^(NSArray *results)
     {
         if ([results count]) {
             // Process results from Chooser
             DBChooserResult *result = results[0];
             NSURL *link = result.link;
             if ([[link pathExtension] isEqualToString:@"csv"]) {
                 // Fetch the datafile from dropbox
                 // This is pretty sketchy, only works on short csv files
                 NSString *csv = [NSString stringWithContentsOfURL:link encoding:NSUTF8StringEncoding error:nil];
                 NSArray *rows = [csv CSVComponents];
                 for (int i = 0; i < rows.count; i++) {
                     NSArray *row = rows[i];
                     Flashcard *new = [Flashcard createEntity];
                     new.front = row[0];
                     new.back = row[1];
                     new.deck = self.deckref;
                 }
             } else {
                 [self.navigationController.view makeToast:@"Dropbox imported file must be a .csv file" duration:3.0 position:@"top"];
             }
         } else {
             // User canceled the action
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
