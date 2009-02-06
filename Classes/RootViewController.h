//
//  RootViewController.h
//  ArcgisRest
//
//  Created by Guilhem Vellut on 1/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGSFolder.h"

@interface RootViewController : UITableViewController {
	UIToolbar* toolbar;
	UINavigationController* infoNavController;
	
	AGSFolder* folder;
}

@property (retain) AGSFolder* folder;

@end