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

-(AGSMapService*) initMapServiceWithURL:(NSString*) URL_ name:(NSString*)name_  type: (NSString*)type_  {
	[super initServiceWithURL:URL_ name:name_ type:type_];	 
	return self;
}


- (void) handleResourceData: (NSDictionary*) raw {
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
		NSObject * subLayerIds = [layerDic objectForKey:@"subLayerIds"];
		Boolean isGroup = subLayerIds != [NSNull null] ;
		[self.layers addObject: [[[AGSLayer alloc] initLayerWithURL:layerURL layerId:layerId name:layerName isGroup:isGroup fetchContent:NO] autorelease]];
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

- (void) exportImage:(AGSEnvelope*) extent Size: (CGSize) size Callback:(NSObject*)delegateDL {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES; 
	
	NSString* bboxPart = [@"bbox=" stringByAppendingFormat:@"%.10f,%.10f,%.10f,%.10f", extent.xmin, extent.ymin, extent.xmax, extent.ymax];
	NSString* sizePart = [@"size=" stringByAppendingFormat:@"%d,%d", (int)size.width, (int)size.height]; 
	NSString* formatPart = @"f=image";
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: 
									[NSURL URLWithString: 
									 [URL stringByAppendingFormat:@"export?%@&%@&%@", bboxPart, formatPart, sizePart]]];
	[request setHTTPMethod: @"GET"];
	[[NSURLConnection alloc] initWithRequest:request delegate:delegateDL];
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
