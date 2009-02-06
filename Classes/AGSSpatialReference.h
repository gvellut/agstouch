//
//  AGSSpatialReference.h
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AGSSpatialReference : NSObject {
	int wkid;
}

@property int wkid;

- (AGSSpatialReference*) initSRWithWkid:(int) wkid_;
+ (AGSSpatialReference*) sRWithWkid:(int) wkid_;

@end
