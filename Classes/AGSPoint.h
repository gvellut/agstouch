//
//  AGSPoint.h
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGSGeometry.h"


@interface AGSPoint : AGSGeometry {
	double x;
	double y; 
}

@property double x;
@property double y;

@end
