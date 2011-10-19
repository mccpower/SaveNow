//
//  FirstViewController.m
//  EFM
//
//  Created by Noemi on 11/4/10.
//  Copyright Pynsoft 2010. All rights reserved.
//

#import "SobresController.h"
#import "SobreDetalleController.h"

static NSUInteger kNumberOfPages = 6;

@interface SobresController (PrivateMethods)
- (void)loadScrollViewWithPage:(int)page;
- (void)miScrollViewDidScroll:(UIScrollView *)sender;
@end
//Comentario 1 xD

@implementation SobresController
@synthesize miScrollView,miPageControl,viewControllers;


#pragma mark -
#pragma mark Application lifecycle
- (void)awakeFromNib
{
	/*// view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
    
    // a page is the width of the scroll view
    miScrollView.pagingEnabled = YES;
    miScrollView.contentSize = CGSizeMake(miScrollView.frame.size.width * kNumberOfPages, miScrollView.frame.size.height);
    miScrollView.showsHorizontalScrollIndicator = NO;
    miScrollView.showsVerticalScrollIndicator = NO;
    miScrollView.scrollsToTop = NO;
    miScrollView.delegate = self;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
    
    miPageControl.numberOfPages = kNumberOfPages;
    miPageControl.currentPage = 0;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
	 */
	//SobreDetalleController *controller = [self.viewControllers objectAtIndex:0];
	//[controller cargarDetalleVista];
}

- (void)viewDidAppear:(BOOL)animated
{
	SobreDetalleController *controller = [self.viewControllers objectAtIndex:0];
	[controller cargarDetalleVista];
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    // replace the placeholder if necessary
    SobreDetalleController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[SobreDetalleController alloc] initWithPageNumber:page];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = miScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
		frame.size.height=393;
        controller.view.frame = frame;
		NSLog(@"%@", NSStringFromCGRect(frame));

        [miScrollView addSubview:controller.view];

	
       // NSDictionary *elemento = [self.listaItems objectAtIndex:page];
	//	controller.lblTitulo.text =[elemento valueForKey:@"titulo"];
		//controller.numberTitle.text = [numberItem valueForKey:NameKey];
    }
			[controller cargarDetalleVista];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = miScrollView.frame.size.width;
    int page = floor((miScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    miPageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}
//Hace que 
- (IBAction)changePage:(id)sender
{
    int page = miPageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = miScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
	[miScrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
	
	
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
		
		//NSString *path = [[NSBundle mainBundle] pathForResource:@"SobresDetalleTextos" ofType:@"plist"];
		//self.listaItemsTextos = [NSArray arrayWithContentsOfFile:path];
	
	
		// view controllers are created lazily
		// in the meantime, load the array with placeholders which will be replaced on demand
		NSMutableArray *controllers = [[NSMutableArray alloc] init];
		for (unsigned i = 0; i < kNumberOfPages; i++)
		{
			[controllers addObject:[NSNull null]];
		}
		self.viewControllers = controllers;
		[controllers release];
		
		// a page is the width of the scroll view
		miScrollView.pagingEnabled = YES;
		//miScrollView.contentSize = CGSizeMake(miScrollView.frame.size.width * kNumberOfPages, miScrollView.frame.size.height);
		miScrollView.contentSize = CGSizeMake(miScrollView.frame.size.width * kNumberOfPages,1);
	
		miScrollView.showsHorizontalScrollIndicator = NO;
		miScrollView.showsVerticalScrollIndicator = NO;
		miScrollView.scrollsToTop = NO;
		miScrollView.delegate = self;
	    miScrollView.clipsToBounds = YES;
		miScrollView.scrollEnabled = YES;

	
		//Para evitar que la vista rebote
		miScrollView.bounces = NO;
		
		
		miPageControl.numberOfPages = kNumberOfPages;
		miPageControl.currentPage = 0;
		
		// pages are created on demand
		// load the visible page
		// load the page on either side to avoid flashes when the user starts scrolling
		//
		[self loadScrollViewWithPage:0];
		[self loadScrollViewWithPage:1];
	
		
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[viewControllers release];
    [miScrollView release];
    [miPageControl release];
    
	
    [super dealloc];
}

@end
