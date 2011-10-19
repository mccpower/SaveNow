//
//  EFMAppDelegate.h
//  EFM
//
//  Created by Noemi on 11/4/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFMAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	UITabBarItem *tabBarItemSobres;
	UITabBarItem *tabBarItemPreferencias;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic,retain) IBOutlet UITabBarItem *tabBarItemSobres;
@property (nonatomic,retain) IBOutlet UITabBarItem *tabBarItemPreferencias;

@end
