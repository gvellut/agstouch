//
//  MapView.h
//  freemap-iphone
//
//  Created by Michel Barakat on 10/20/08.
//  Copyright 2008 Høgskolen i Østfold. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MapState.h"
#import "AGSMapService.h"
#import "AGSEnvelope.h"

enum UserAction {
  UA_MOVE = 0,
  UA_MOVE_TO_POINT,
  UA_ZOOM
};

@interface MapView : UIView {
  
	UIImageView *image;
	MapState* mapState;
	
	CGPoint lastTouchLocation;
    CGFloat lastDistance;
    CGFloat zoomScaleFactor;
  
    enum UserAction userAction;
	NSMutableData* receivedData;
}

@property (retain) IBOutlet UIImageView* image;
@property (readonly, retain)  MapState *mapState;

- (void) setupMapWithMapService:(AGSMapService*) mapService InitialExtent:(AGSEnvelope*) envelope;

+ (CGFloat)euclideanDistanceFromPoint:(CGPoint)firstPoint
                              ToPoint:(CGPoint)secondPoint;

- (void)moveMap:(CGPoint) transition;
- (void)moveMapToCenter:(CGPoint) newCenterPoint;
- (void)zoomOnMapWithScaleFactor:(CGFloat) scaleFactor;

@end
