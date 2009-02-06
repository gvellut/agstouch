//
//  AGSMapServiceViewController.h
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGSMapService.h"


@interface AGSMapServiceViewController : UITableViewController {
	AGSMapService* mapService;
}

@property (retain) AGSMapService* mapService;

@end
