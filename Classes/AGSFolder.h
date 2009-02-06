//
//  AGSFolder.h
//  ArcgisRest
//
//  Created by Guilhem Vellut on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGSResource.h"

@interface AGSFolder : AGSResource {
	NSMutableArray* subFolders;
	NSMutableArray* services;
}

@property (retain) NSMutableArray* subFolders;
@property (retain) NSMutableArray* services;

- (AGSFolder*) initWithURL:(NSString*) URL name: (NSString*) name ;

- (void) handleResourceData: (NSDictionary*) data;
@end
