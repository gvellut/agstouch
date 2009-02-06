//
//  AGSTileInfo.h
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AGSPoint;
@class AGSSpatialReference;

@interface AGSTileInfo : NSObject {
	int rows;
	int cols;
	int dpi;
	NSString* format;
	int compressionQuality;
	AGSPoint* origin;
	AGSSpatialReference* spatialReference;
	NSMutableArray* lods;
}

@property int rows;
@property int cols;
@property int dpi;
@property (retain) NSString* format;
@property int compressionQuality;
@property (retain) AGSPoint* origin;
@property (retain) AGSSpatialReference* spatialReference;
@property (retain) NSMutableArray* lods;

@end

@interface AGSLod: NSObject {
	int level;
	double resolution;
	double scale;
}

@property int level;
@property double resolution;
@property double scale;

@end

