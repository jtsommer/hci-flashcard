//
//  StudyReminderViewController.m
//  hci-flashcard-iPhone
//
//  Created by luaromer on 3/12/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "StudyReminderViewController.h"
#import "AppDelegate.h"

@interface StudyReminderViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)buttonPressed:(id)sender;

@end

@implementation StudyReminderViewController

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
    NSDate *now = [NSDate date];
    
    [_datePicker setDate: now];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    NSString *deckname = self.deckref.name;
    NSDate *selected = [_datePicker date];

    NSString *message = [[NSString alloc] initWithFormat:@"date & time selected: %@", selected];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Date and Time selected" message:message delegate:nil cancelButtonTitle:@"sure" otherButtonTitles: nil];
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    [notification setAlertBody:[NSString stringWithFormat:@"Reminder to study %@", deckname]];
    [notification setFireDate:selected];
    [notification setTimeZone:[NSTimeZone defaultTimeZone ]];
    [[UIApplication sharedApplication] setScheduledLocalNotifications:[NSArray arrayWithObject:notification]];

    [alert show];
}
@end
