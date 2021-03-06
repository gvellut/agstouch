//
//  AGSLayer.m
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AGSLayer.h"


@implementation AGSLayer

@synthesize layerId;
@synthesize defaultVisibility;
@synthesize isGroup;

-(AGSLayer*) initLayerWithURL:(NSString*)URL_ layerId: (int) layerId_ name:(NSString*)name_ isGroup:(Boolean) isGroup_ fetchContent:(Boolean) fetchContent_ {
	[super initResourceWithURL: URL_ name: name_];
	
	self.layerId = layerId_;
	self.contentIsFetched = NO;
	self.isGroup = isGroup_;
	
	if(fetchContent_)
		[self fetchContent];
	
	return self;
}

-(void) fetchContent {
	if(contentIsFetched)
		return;
	
	contentIsFetched = YES;
}

@end
