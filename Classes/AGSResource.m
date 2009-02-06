//
//  AGSResource.m
//  ArcgisRest
//
//  Created by Guilhem Vellut on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AGSResource.h"
#import "JSON/JSON.h"


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

-(void) fetchContent {
	contentIsFetched = YES;
}


- (NSDictionary*) getContentFromURL {
	NSError *error;
	NSURLResponse *response;
	NSData *dataReply;
	NSString *stringReply;
	NSString* jsonPart;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES; 
	
	if([URL rangeOfString: @"?"].location == NSNotFound)
		jsonPart = @"?f=json";
	else
		jsonPart = @"&f=json";
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: 
									[NSURL URLWithString: 
									 [URL stringByAppendingString: jsonPart]]];
	[request setHTTPMethod: @"GET"];
	dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	stringReply = [[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
	
	return [stringReply JSONValue];	
}


- (void)dealloc {
	[name release];
	[URL release];
    [super dealloc];
}

@end
