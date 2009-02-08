//
//  RootViewController.h
//  ArcgisRest
//
//  Created by Guilhem Vellut on 1/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGSFolder.h"

@interface FolderViewController : UITableViewController {
	UIToolbar* toolbar;
	UINavigationController* infoNavController;
	
	NSMutableData* receivedData;
	AGSFolder* folder;
}

@property (retain) AGSFolder* folder;

@end
