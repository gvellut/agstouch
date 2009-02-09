//
//  MapState.h
//  freemap-iphone
//
//  Created by Michel Barakat on 10/20/08.
//  Copyright 2008 Høgskolen i Østfold. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGSMapService.h"
#import "AGSEnvelope.h"
#import "AGSPoint.h"


@interface MapState : NSObject {
	AGSMapService* mapService;
	AGSEnvelope* envelope;
	AGSEnvelope* screenEnvelope;
	AGSPoint* centerScreenCoords;
	AGSPoint* centerCoords;
	Boolean boundBoxesSet;
}


@property (retain) AGSMapService* mapService;
@property (retain) AGSEnvelope* envelope;
@property (retain) AGSEnvelope* screenEnvelope;
@property (retain) AGSPoint* centerCoords;
@property (retain) AGSPoint* centerScreenCoords;

- (id)initWithMapService:(AGSMapService*) initMapService
			 EnvelopedAt:(AGSEnvelope*) initEnvelope;
- (void) moveMap:(CGPoint) delta;
- (void) zoomMap: (double) zoomScaleFactor;
- (void) fitRealEnvelopeToScreenEnvelope;
- (void)setScreenViewportSize:(CGSize) screenViewportSize;
- (void) fetchMapImage:(NSObject*) delegateDL;

@end
