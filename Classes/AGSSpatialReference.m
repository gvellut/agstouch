//
//  AGSSpatialReference.m
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AGSSpatialReference.h"


@implementation AGSSpatialReference
@synthesize wkid;

- (AGSSpatialReference*) initSRWithWkid:(int) wkid_ {
	self.wkid = wkid_;
	return self;
}

+ (AGSSpatialReference*) sRWithWkid:(int) wkid_ {
	return [[[AGSSpatialReference alloc] initSRWithWkid:wkid_] autorelease];
}

@end
