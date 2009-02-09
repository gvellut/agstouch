//
//  MapView.m
//  freemap-iphone
//
//  Created by Michel Barakat on 10/20/08.
//  Copyright 2008 Høgskolen i Østfold. All rights reserved.
//

#import "MapView.h"

#define SCREEN_WIDTH 320.0
#define SCREEN_HEIGHT 416.0		


@implementation MapView

@synthesize image;
@synthesize mapState;

- (id)initWithCoder:(NSCoder*)coder {
	[super initWithCoder:coder];
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	[super initWithFrame:frame];
	return self;
}

- (void) setupMapWithMapService:(AGSMapService*) mapService InitialExtent:(AGSEnvelope*) envelope {
	mapState = [[MapState alloc] initWithMapService: mapService EnvelopedAt: envelope];
	//buffer x2
	[mapState setScreenViewportSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
	[image setBounds: CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
	
}

- (void)drawRect:(CGRect)rect {
	if(! receivedData) {
		[mapState fetchMapImage : self];
		receivedData= [[NSMutableData data] retain];
	}
	
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"rr");
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"rd");
    [receivedData appendData:data];	
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
	NSLog(@"fail");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
	
    [connection release];
    [receivedData release];
	receivedData = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"fl");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
	
	UIImage* mapImage = [UIImage imageWithData:receivedData];	
	[image setImage:mapImage];
	[image setCenter:CGPointMake(SCREEN_WIDTH/2, 
								 SCREEN_HEIGHT/2)];
	[image setTransform: CGAffineTransformIdentity];
	[image setNeedsDisplay];
	
	[connection release];
	[receivedData release];	
	receivedData = nil;
}


- (void)moveMap:(CGPoint) transition {
	image.center = CGPointMake(image.center.x + transition.x, 
							   image.center.y + transition.y);
	image.transform = CGAffineTransformIdentity;
}

- (void)moveMapToCenter:(CGPoint) newCenterPoint {
	
	const CGPoint transition = 
    CGPointMake([self center].x - newCenterPoint.x, 
                [self center].y - newCenterPoint.y);
	
	[self moveMap:transition];
}

- (void)zoomOnMapWithScaleFactor:(CGFloat) scaleFactor {
	if (scaleFactor < 0.25) {
		scaleFactor = 0.25;
	} else if (scaleFactor > 4.0) {
		scaleFactor = 4.0;
	}
	image.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {	
	const NSSet *allTouches = [event allTouches];
  
	switch ([allTouches count]) {
		case 1: {
			const UITouch *touch = [allTouches anyObject];
			if ([touch tapCount] == 1) {
				userAction = UA_MOVE;
				lastTouchLocation = [touch locationInView:touch.view];
			} else {
				userAction = UA_MOVE_TO_POINT;
				lastTouchLocation = [touch locationInView:touch.view];
			}
			break;
		}
			
		case 2: {
			userAction = UA_ZOOM;
      
			UITouch *firstTouch = [[allTouches allObjects] objectAtIndex:0];
			UITouch *secondTouch = [[allTouches allObjects] objectAtIndex:1];
			
			const CGPoint firstPoint = [firstTouch locationInView:firstTouch.view];
			const CGPoint secondPoint = [secondTouch locationInView:secondTouch.view];
			lastDistance = [MapView euclideanDistanceFromPoint:firstPoint 
                                                 ToPoint:secondPoint];
			zoomScaleFactor = 1.0;
			break;
		}
   }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	const NSSet *allTouches = [event allTouches];
  
  switch (userAction) {
	  case UA_MOVE: {
		  UITouch *touch = [allTouches anyObject];
		  const CGPoint touchLocation = [touch locationInView:touch.view];
		  const CGPoint transition = 
		  CGPointMake(touchLocation.x - lastTouchLocation.x, 
                    touchLocation.y - lastTouchLocation.y);
		  [self moveMap:transition];
		  lastTouchLocation = touchLocation;
		  break;
	  }case UA_MOVE_TO_POINT:
		  break;
	  case UA_ZOOM: {
		  if ([[allTouches allObjects] count] != 2) {
			  break;
		  }
		  UITouch *firstTouch = [[allTouches allObjects] objectAtIndex:0];
		  UITouch *secondTouch = [[allTouches allObjects] objectAtIndex:1];
      
		  const CGPoint firstPoint = [firstTouch locationInView:firstTouch.view];
		  const CGPoint secondPoint = [secondTouch locationInView:secondTouch.view];
		  CGFloat currentDistance = [MapView euclideanDistanceFromPoint:firstPoint 
                                                           ToPoint:secondPoint];
      
		  if (lastDistance > currentDistance) {
			  zoomScaleFactor = zoomScaleFactor * 
			  (1 - ((lastDistance - currentDistance) / lastDistance));
		  } else if (lastDistance < currentDistance) {
			  zoomScaleFactor = zoomScaleFactor * 
			  (1 + ((currentDistance - lastDistance) / currentDistance));
		  }
      
		  [self zoomOnMapWithScaleFactor:zoomScaleFactor];
		  lastDistance = currentDistance;
		  break;
	  }
  }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {  
	const NSSet *allTouches = [event allTouches];
  switch (userAction) {
	  case UA_MOVE:{
		  CGPoint cen = image.center;
		  [mapState moveMap: cen];
		  [self setNeedsDisplay];
		  break;
	  }case UA_MOVE_TO_POINT:
      
    break;
	  case UA_ZOOM: {
		  if([allTouches count] == 2) {
		  [mapState zoomMap: zoomScaleFactor];
		  [self setNeedsDisplay];
		  }
      
	  }break;
  }
}

- (void)dealloc {
	[image release];
	[mapState release];
	[super dealloc];
}

+ (CGFloat)euclideanDistanceFromPoint:(CGPoint)firstPoint
                              ToPoint:(CGPoint)secondPoint {
  float x = secondPoint.x - firstPoint.x;
  float y = secondPoint.y - firstPoint.y;
  
  return sqrt(x * x + y * y);
}

@end

