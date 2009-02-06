//
//  AGSResource.m
//  ArcgisRest
//
//  Created by Guilhem Vellut on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AGSResource.h"

@implementation AGSResource

@synthesize URL;
@synthesize name;
@synthesize contentIsFetched;

-(AGSResource*) initResourceWithURL:(NSString*) URL_ name:(NSString*)name_ {
	if([URL_ hasSuffix: @"/"])		
		self.URL = URL_; 
	else
		self.URL = [URL_ stringByAppendingString:@"/"];
	self.name = name_;
	
	return self;
}


- (void) fetchContent:(NSObject*) delegateDL {
	if(contentIsFetched)
		return;
	
	[self getContentFromURL:delegateDL];
	
}



- (void) getContentFromURL:(NSObject*)delegateDL {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES; 
	
	NSString* jsonPart;
	if([URL rangeOfString: @"?"].location == NSNotFound)
		jsonPart = @"?f=json";
	else
		jsonPart = @"&f=json";
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: 
									[NSURL URLWithString: 
									 [URL stringByAppendingString: jsonPart]]];
	[request setHTTPMethod: @"GET"];
	[[NSURLConnection alloc] initWithRequest:request delegate:delegateDL];
}

- (void) handleResourceData: (NSDictionary*) data {
	//do nothing here
}

- (void)dealloc {
	[name release];
	[URL release];
    [super dealloc];
}

@end
