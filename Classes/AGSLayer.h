//
//  AGSLayer.h
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGSResource.h"

@interface AGSLayer : AGSResource {
	int layerId;
	Boolean isGroup;
	Boolean defaultVisibility;
}

@property int layerId;
@property Boolean defaultVisibility;
@property Boolean isGroup;

-(AGSLayer*) initLayerWithURL:(NSString*)layerURL layerId: (int) layerId_ name:(NSString*)name isGroup:(Boolean)isGroup fetchContent:(Boolean) fetchContent;


@end
