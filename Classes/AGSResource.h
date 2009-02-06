//
//  AGSResource.h
//  ArcgisRest
//
//  Created by Guilhem Vellut on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AGSResource : NSObject {
	NSString* URL;
	NSString* name;
	Boolean contentIsFetched;
}

@property (retain) NSString* name;
@property (retain) NSString* URL;
@property Boolean contentIsFetched;

- (void) fetchContent:(NSObject*)delegateDL;

- (void) getContentFromURL:(NSObject*)delegateDL;

-(AGSResource*) initResourceWithURL:(NSString*) URL_ name:(NSString*)name_;

@end
