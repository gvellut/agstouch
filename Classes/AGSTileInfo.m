//
//  AGSTileInfo.m
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AGSTileInfo.h"

@implementation AGSTileInfo

@synthesize rows;
@synthesize cols;
@synthesize dpi;
@synthesize format;
@synthesize compressionQuality;
@synthesize origin;
@synthesize spatialReference;
@synthesize lods;

- (void) dealloc {
	[format release];
	[origin release];
	[spatialReference release];
	[lods release];
	[super dealloc];
}


@end

@implementation AGSLod

@synthesize level;
@synthesize resolution;
@synthesize scale;

@end
