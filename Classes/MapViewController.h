//
//  MapViewController.h
//  freemap-iphone
//
//  Created by admin on 8/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapView.h"

@interface MapViewController : UIViewController {
	IBOutlet MapView* mapView;
	AGSMapService* mapService;
}

@property (retain) MapView* mapView;
@property (retain) AGSMapService* mapService;

@end
