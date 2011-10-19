//
//  EFMAppDelegate.m
//  EFM
//
//  Created by Noemi on 11/4/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "EFMAppDelegate.h"


@implementation EFMAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize tabBarItemSobres;
@synthesize tabBarItemPreferencias;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the tab bar controller's view to the window and display.
	
    [window addSubview:tabBarController.view];
	tabBarItemSobres.title=NSLocalizedString(@"tabSobres",@"");
	tabBarItemPreferencias.title=NSLocalizedString(@"tabPreferencias",@"");
	
	//Reviso si existe ya un documento creado en Documents y sino copio el del bundle
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"SobresDetalleData.plist"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
	{
		NSString *myPathInfo = [[NSBundle mainBundle] pathForResource:@"SobresDetalleData" ofType:@"plist"];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[fileManager copyItemAtPath:myPathInfo toPath:myPathDocs error:NULL];
	}		
	
	    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

