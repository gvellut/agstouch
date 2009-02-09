//
//  AGSMapService.h
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGSService.h"

@class AGSSpatialReference;
@class AGSTileInfo;
@class AGSEnvelope;

@interface AGSMapService : AGSService {
	NSString* serviceDescription;
	NSString* mapName;
	NSString* description;
	NSString* copyrightText;
	NSMutableArray* layers;
	AGSSpatialReference* spatialReference;
	Boolean singleFusedMapCache;
	AGSTileInfo* tileInfo;
	AGSEnvelope* initialExtent;
	AGSEnvelope* fullExtent;
	NSString* units;
	NSDictionary* documentInfo;
}

@property (retain) NSString* serviceDescription;
@property (retain) NSString* mapName;
@property (retain) NSString* description;
@property (retain) NSString* copyrightText;
@property (retain) NSMutableArray* layers;
@property (retain) AGSSpatialReference* spatialReference;
@property Boolean singleFusedMapCache;
@property (retain) AGSTileInfo* tileInfo;
@property (retain) AGSEnvelope* initialExtent;
@property (retain) AGSEnvelope* fullExtent;
@property (retain) NSString* units;
@property (retain) NSDictionary* documentInfo;

-(AGSMapService*) initMapServiceWithURL:(NSString*)serviceURL name:(NSString*)name type:(NSString*)type ;

- (void) handleResourceData: (NSDictionary*) data;

- (void) exportImage:(AGSEnvelope*) extent Size: (CGSize) size Callback:(NSObject*)delegateDL;
@end
