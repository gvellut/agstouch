//
//  AGSFolder.m
//  ArcgisRest
//
//  Created by Guilhem Vellut on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AGSFolder.h"
#import "AGSService.h"

@implementation AGSFolder

@synthesize subFolders;
@synthesize services;

- (AGSFolder*) initWithURL:(NSString*) URL_ name: (NSString*)name_ fetchContent:(Boolean) fetchContent_ {
	[super initResourceWithURL:URL_ name:name_];
	
	self.contentIsFetched = NO;
	
	if(fetchContent_) {
		[self fetchContent];
	}
	   
	return self;
}

- (AGSFolder*) navigateToSubFolder:(NSString*) folderName {
	[self fetchContent];
	
	for(AGSFolder* folder in subFolders) {
		if([folder.name isEqualToString: folderName]){
			[folder fetchContent];
			return folder;
		}
	}
	return nil;
}
	
		
		   
- (void) fetchContent {
	if(contentIsFetched)
		return;
	
	NSDictionary* dic = [self getContentFromURL];

	NSArray* subFolderNames = [dic valueForKey: @"folders"];
	self.subFolders = [[NSMutableArray alloc] initWithCapacity:[subFolderNames count]];

	if(subFolderNames != nil) {
		for(NSString* subFolderName in subFolderNames) {
			NSArray* subFolderNameComponents = [subFolderName  pathComponents];
			NSString* strippedSubFolderName = [subFolderNameComponents objectAtIndex: [subFolderNameComponents count] - 1];
			NSString* subFolderURL = [self.URL stringByAppendingString:strippedSubFolderName];
			AGSFolder* agsFolder = [[AGSFolder alloc] initWithURL:subFolderURL name:strippedSubFolderName fetchContent:NO];
			[subFolders addObject:agsFolder];
			[agsFolder release];
		}
	}
	
	NSArray* serviceDescriptions = [dic valueForKey: @"services"];
	self.services = [[NSMutableArray alloc] initWithCapacity:[serviceDescriptions count]];
	
	if(serviceDescriptions != nil) {
		for(NSDictionary* serviceDescription in serviceDescriptions) {
			NSArray* serviceNameComponents = [[serviceDescription valueForKey:@"name"]  pathComponents];
			NSString* serviceName = [serviceNameComponents objectAtIndex: [serviceNameComponents count] - 1];
			NSString* serviceType = [serviceDescription valueForKey:@"type"];
			NSString* serviceURL = [[self.URL stringByAppendingString:serviceName] stringByAppendingPathComponent:serviceType];
			AGSService* agsService = [AGSService serviceWithURL:serviceURL name: serviceName type: serviceType fetchContent:NO];
			[services addObject:agsService];		}
	}
	
	self.contentIsFetched = YES;
}

- (void)  navigateSubFoldersInDepth {
	[self fetchContent];
	
	for(AGSFolder* folder in subFolders) {
		[folder  navigateSubFoldersInDepth];
	}
}




- (void)dealloc {
	[subFolders release];
	[services release];
    [super dealloc];
}



@end
