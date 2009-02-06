//
//  AGSService.m
//  ArcgisRest
//
//  Created by Guilhem Vellut on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AGSService.h"
#import "AGSMapService.h"


@implementation AGSService

@synthesize type;

-(AGSService*) initServiceWithURL:(NSString*) URL_ name:(NSString*)name_  type: (NSString*)type_  {
	[super initResourceWithURL: URL_ name: name_];	
	self.type = type_;
	self.contentIsFetched = NO;
	
		
	return self;
}

+(AGSService*) serviceWithURL:(NSString*)URL_ name:(NSString*)name_ type:(NSString*)type_  {
	if([type_ isEqualToString:@"MapServer"]){
		AGSMapService* mapService = [[AGSMapService alloc] initMapServiceWithURL:URL_ name:name_ type:type_ ];
		[mapService autorelease];
		return mapService;
	} else {
		AGSService* service = [[AGSService alloc] initServiceWithURL:URL_ name:name_ type:type_];
		[service autorelease];
		return service;
	}
}

- (void)dealloc {
	[type release];
    [super dealloc];
}

@end
