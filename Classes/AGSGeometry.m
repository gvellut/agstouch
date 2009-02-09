//
//  AGSGeometry.m
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AGSGeometry.h"
#import "AGSSpatialReference.h"

@implementation AGSGeometry

@synthesize spatialReference;

- (AGSGeometry*) initWithWkid:(int) wkid {
	self.spatialReference = [AGSSpatialReference sRWithWkid:wkid];
	return self;
}

- (void) dealloc {
	[spatialReference release];
	[super dealloc];
}


@end
