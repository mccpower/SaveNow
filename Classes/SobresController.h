//
//  FirstViewController.h
//  EFM
//
//  Created by Noemi on 11/4/10.
//  Copyright Pynsoft 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SobreDetalleController.h"

@interface SobresController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIScrollView *miScrollView;
	IBOutlet UIPageControl *miPageControl;
	NSMutableArray *viewControllers;
	BOOL pageControlUsed;
}


@property (nonatomic, retain) IBOutlet UIScrollView *miScrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *miPageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;

- (IBAction)changePage:(id)sender;

@end
