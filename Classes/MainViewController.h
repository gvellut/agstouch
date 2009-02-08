//
//  MainViewController.h
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MainViewController : UIViewController {
	IBOutlet UITextField* hostField;
	IBOutlet UITextField* portField;
}

- (void) browse: (id) sender;

- (void) setupUI;

@end
