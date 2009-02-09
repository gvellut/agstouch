//
//  MapState.m
//  freemap-iphone
//
//  Created by Michel Barakat on 10/20/08.
//  Copyright 2008 Høgskolen i Østfold. All rights reserved.
//

#import "MapState.h"
#import "AGSSpatialReference.h"

@implementation MapState

@synthesize mapService;
@synthesize envelope;
@synthesize screenEnvelope;
@synthesize centerCoords;
@synthesize centerScreenCoords;

- (id)initWithMapService:(AGSMapService*) initMapService
			 EnvelopedAt:(AGSEnvelope*) initEnvelope {
	self.mapService = initMapService;
	self.envelope = [AGSEnvelope envelopeWithXmin:initEnvelope.xmin xmax:initEnvelope.xmax 
											 ymin:initEnvelope.ymin ymax:initEnvelope.ymax 
											 wkid:initEnvelope.spatialReference.wkid];
	self.centerCoords = [envelope center];
	return self;
}


- (void)setScreenViewportSize:(CGSize) screenViewportSize {
	assert(!boundBoxesSet);
	
	const double screenHalfHeight = screenViewportSize.height / 2;
	const double screenHalfWidth = screenViewportSize.width / 2;
	
	const CGPoint centerPoint = CGPointMake(screenHalfWidth, screenHalfHeight);
	
	[screenEnvelope release];
	self.screenEnvelope = [AGSEnvelope alloc];
	screenEnvelope.ymax = centerPoint.y + screenHalfHeight;
	screenEnvelope.ymin = centerPoint.y - screenHalfHeight;
	screenEnvelope.xmin = centerPoint.x - screenHalfWidth;
	screenEnvelope.xmax = centerPoint.x + screenHalfWidth;
	self.centerScreenCoords = [screenEnvelope center];
	
	[self fitRealEnvelopeToScreenEnvelope];
	
	boundBoxesSet = YES;
}

- (void) moveMap:(CGPoint) center {
	double sDX = screenEnvelope.xmax - screenEnvelope.xmin;
	double sDY = screenEnvelope.ymax - screenEnvelope.ymin;
	double rDX = envelope.xmax - envelope.xmin;
	double rDY = envelope.ymax - envelope.ymin; 
	double scX = rDX / sDX * (center.x - centerScreenCoords.x);
	double scY = rDY / sDY * (center.y - centerScreenCoords.y); 
	centerCoords.x = centerCoords.x - scX;
	centerCoords.y = centerCoords.y + scY;
	envelope.xmin = centerCoords.x - rDX / 2;
	envelope.xmax = centerCoords.x + rDX / 2;
	envelope.ymax = centerCoords.y + rDY / 2;
	envelope.ymin = centerCoords.y - rDY / 2;
}

- (void) zoomMap: (double) zoomScaleFactor {

	if (zoomScaleFactor < 0.25) {
		zoomScaleFactor = 0.25;
	} else if (zoomScaleFactor > 4.0) {
		zoomScaleFactor = 4.0;
	}
		
	double rDX = envelope.xmax - envelope.xmin;
	double rDY = envelope.ymax - envelope.ymin; 
	rDX /= zoomScaleFactor;
	rDY /= zoomScaleFactor;
	envelope.xmin = centerCoords.x - rDX / 2;
	envelope.xmax = centerCoords.x + rDX / 2;
	envelope.ymax = centerCoords.y + rDY / 2;
	envelope.ymin = centerCoords.y - rDY / 2;
	
}

- (void) fetchMapImage:(NSObject*) delegateDL {
	[mapService exportImage:envelope 
					   Size: CGSizeMake(screenEnvelope.xmax - screenEnvelope.xmin, screenEnvelope.ymax - screenEnvelope.ymin)
				   Callback:delegateDL]; 
}

- (void) fitRealEnvelopeToScreenEnvelope {
	//smallest real envelope that has the same proportions as the screen and contains the previous real envelope
	
	double sDX = screenEnvelope.xmax - screenEnvelope.xmin;
	double sDY = screenEnvelope.ymax - screenEnvelope.ymin;
	double sP = sDX / sDY;
	
	double rDX = envelope.xmax - envelope.xmin;
	double rDY = envelope.ymax - envelope.ymin;
	double rP = rDX / rDY;
	
	if(sP < rP) {
		rDY = rDY / sP * rP;
		envelope.ymin = centerCoords.y - rDY / 2;
		envelope.ymax = centerCoords.y + rDY / 2;
	} else {
		rDX = rDX * sP / rP;
		envelope.xmin = centerCoords.x - rDX / 2;
		envelope.xmax = centerCoords.x + rDX / 2;
	}

}


- (void)dealloc {
	[mapService release];
	[envelope release];
	[screenEnvelope release];
	[centerCoords release];
	[centerScreenCoords release];
	[super dealloc];
}

@end
