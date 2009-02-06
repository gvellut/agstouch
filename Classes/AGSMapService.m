//
//  AGSMapService.m
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AGSMapService.h"
#import "AGSEnvelope.h"
#import "AGSSpatialReference.h"
#import "AGSLayer.h"

@implementation AGSMapService

@synthesize serviceDescription;
@synthesize mapName;
@synthesize description;
@synthesize copyrightText;
@synthesize layers;
@synthesize spatialReference;
@synthesize singleFusedMapCache;
@synthesize tileInfo;
@synthesize initialExtent;
@synthesize fullExtent;
@synthesize units;
@synthesize documentInfo;

-(AGSMapService*) initMapServiceWithURL:(NSString*) URL_ name:(NSString*)name_  type: (NSString*)type_  fetchContent:(Boolean) fetchContent_ {
	[super initServiceWithURL:URL_ name:name_ type:type_ fetchContent:fetchContent_];	 
	return self;
}

-(void) fetchContent {
	if(contentIsFetched)
		return;
	
	NSDictionary* raw = [self getContentFromURL];
	self.serviceDescription = [raw objectForKey:@"serviceDescription"];
	self.mapName = [raw objectForKey:@"mapName"];
	self.description = [raw objectForKey:@"description"];
	self.copyrightText = [raw objectForKey:@"copyrightText"];
	self.layers = [[[NSMutableArray alloc] init] autorelease];
	NSArray* rawLayers =  [raw objectForKey:@"layers"];
	for(NSDictionary* layerDic in rawLayers){
		int layerId = [[layerDic objectForKey:@"id"] intValue];
		NSString* layerURL = [self.URL  stringByAppendingPathComponent:[[NSNumber numberWithInt:layerId] stringValue]];
		NSString* layerName = [layerDic objectForKey:@"name"];
		[self.layers addObject: [[[AGSLayer alloc] initLayerWithURL:layerURL layerId:layerId name:layerName fetchContent:NO] autorelease]];
	}
	int wkid = [[[raw objectForKey:@"spatialReference"] objectForKey:@"wkid"] intValue];
	self.spatialReference = [AGSSpatialReference sRWithWkid: wkid];
	self.singleFusedMapCache = [[raw objectForKey:@"singleFusedMapCache"] boolValue];
	if(singleFusedMapCache) {
		//tileInfo
	}
	
	self.initialExtent = [AGSEnvelope envelopeFromDictionary: [raw objectForKey:@"initialExtent"]];
	self.fullExtent = [AGSEnvelope envelopeFromDictionary: [raw objectForKey:@"fullExtent"]];
	self.units = [raw objectForKey:@"units"];
	self.documentInfo = [raw objectForKey:@"documentInfo"];
	
	
	contentIsFetched = YES;
}
		
- (void)dealloc {
	[serviceDescription release];
	[mapName release];
	[description release];
	[copyrightText release];
	[layers release];
	[spatialReference release];
	[tileInfo release];
	[initialExtent release];
	[fullExtent release];
	[units release];
	[documentInfo release];
	
    [super dealloc];
}


@end
