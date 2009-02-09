//
//  MapViewController.m
//  freemap-iphone
//
//  Created by admin on 8/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

@synthesize mapView;
@synthesize mapService;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil {
	[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	return self;
}

- (void)viewDidLoad {	
	self.navigationItem.title = @"Map";
	[mapView setupMapWithMapService:mapService InitialExtent:mapService.initialExtent];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


- (void)dealloc {
	[mapView release];
	[mapService release];
	[super dealloc];
}


@end
