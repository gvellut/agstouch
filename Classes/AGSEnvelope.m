//
//  AGSEnvelope.m
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AGSEnvelope.h"


@implementation AGSEnvelope

@synthesize xmin;
@synthesize ymin;
@synthesize xmax;
@synthesize ymax;

- (AGSEnvelope*) initEnvelopeWithXmin:(double) xmin_ xmax:(double) xmax_ ymin :(double) ymin_ ymax : (double) ymax_ wkid:(int) wkid_ {
	[super initWithWkid:wkid_];
	self.xmin = xmin_;
	self.xmax = xmax_;
	self.ymin = ymin_;
	self.ymax = ymax_;
	return self;
}


+ (AGSEnvelope*) envelopeWithXmin:(double) xmin_ xmax:(double) xmax_ ymin :(double) ymin_ ymax : (double) ymax_ wkid:(int) wkid_ {
	return [[[AGSEnvelope alloc] initEnvelopeWithXmin:xmin_ xmax:xmax_ ymin:ymin_ ymax:ymax_ wkid:wkid_] autorelease];
}

+ (AGSEnvelope*) envelopeFromDictionary:(NSDictionary*) e {
	return [AGSEnvelope envelopeWithXmin: [[e objectForKey:@"xmin"] doubleValue]
									xmax:[[e objectForKey:@"xmax"] doubleValue]
									ymin:[[e objectForKey:@"ymin"] doubleValue]
									ymax:[[e objectForKey:@"ymax"] doubleValue]
									wkid:[[[e objectForKey:@"spatialReference"] objectForKey:@"wkid"] intValue]];
}

- (void) dealloc {
	[super dealloc];
}


@end
