//
//  AGSService.h
//  ArcgisRest
//
//  Created by Guilhem Vellut on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGSResource.h"

@interface AGSService : AGSResource {
	NSString* type;
}

@property (retain) NSString* type;

-(AGSService*) initServiceWithURL:(NSString*)serviceURL name:(NSString*)name type:(NSString*)type fetchContent:(Boolean) fetchContent;

+(AGSService*) serviceWithURL:(NSString*)serviceURL name:(NSString*)name type:(NSString*)type fetchContent:(Boolean) fetchContent;

@end
