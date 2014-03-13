//
//  DropboxConversionViewController.m
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/12/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "DropboxConversionViewController.h"
#import <DBChooser/DBChooser.h>

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
