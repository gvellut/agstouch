//
//  AGSGeometry.h
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AGSSpatialReference;

@interface AGSGeometry : NSObject {
	AGSSpatialReference* spatialReference;
}

@property (retain) AGSSpatialReference* spatialReference;

- (AGSGeometry*) initWithWkid:(int) wkid;

@end
