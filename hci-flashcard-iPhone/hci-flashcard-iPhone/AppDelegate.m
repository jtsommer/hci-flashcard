//
//  AppDelegate.m
//  hci-flashcard-iPhone
//
//  Created by jtsommer on 3/2/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "AppDelegate.h"
#import "Deck.h"
#import "Flashcard.h"
#import <DBChooser/DBChooser.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Setup Core Data with Magical Record
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"FlashcardModel.sqlite"];
    
    // Setup App with prefilled placeholder decks.
	if (![[NSUserDefaults standardUserDefaults] objectForKey:@"MR_HasPrefilledDecks"]) {
		// Create a placeholder Math deck
		Deck *deckMath = [Deck createEntity];
		deckMath.name  = @"Math";
		
		// Create a placeholder Math deck
		Deck *deckChemistry = [Deck createEntity];
		deckChemistry.name  = @"Chemistry";
		
		// Create a placeholder Math deck
		Deck *deckEconomics = [Deck createEntity];
		deckEconomics.name  = @"Economics";
		
		// Create a placeholder Math deck
		Deck *deckWriting = [Deck createEntity];
		deckWriting.name  = @"Writing";
		
		// Save Managed Object Context
		[[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:nil];
		
		// Set User Default to prevent another preload of data on startup.
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MR_HasPrefilledDecks"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
    return YES;
}

#pragma mark Dropbox

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBChooser defaultChooser] handleOpenURL:url]) {
        // This was a Chooser response and handleOpenURL automatically ran the
        // completion block
        return YES;
    }
    
    return NO;
    return NO;
}

#pragma mark
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}

@end
