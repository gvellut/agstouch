//
//  AGSEnvelope.h
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGSGeometry.h"


@interface AGSEnvelope : AGSGeometry {
	double xmin;
	double ymin;
	double xmax;
	double ymax;
}

@property double xmin;
@property double ymin;
@property double xmax;
@property double ymax;

- (AGSEnvelope*) initEnvelopeWithXmin:(double) xmin xmax:(double) xmax ymin :(double) ymin ymax : (double) ymax wkid:(int) wkid;
+ (AGSEnvelope*) envelopeWithXmin:(double) xmin xmax:(double) xmax ymin :(double) ymin ymax : (double) ymax wkid:(int) wkid;
+ (AGSEnvelope*) envelopeFromDictionary:(NSDictionary*) e;
@end
