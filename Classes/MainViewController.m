//
//  MainViewController.m
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "FolderViewController.h"
#import "AGSFolder.h"


@implementation MainViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    self = [super initWithNibName:nibName bundle:nibBundle];
	[self setupUI];
    return self;
}


- (id)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	[self setupUI];
	return self;
}

- (void) setupUI {
	if (self) {
        UIBarButtonItem *browseButton = [[UIBarButtonItem alloc] initWithTitle:@"Browse" style:UIBarButtonItemStylePlain
																		target:self action:@selector(browse:)];
        self.navigationItem.rightBarButtonItem = browseButton; 
		
		
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	portField.clearButtonMode = UITextFieldViewModeUnlessEditing;
	hostField.clearButtonMode = UITextFieldViewModeUnlessEditing;
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	self.title = @"AGS Touch";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}



- (void) browse: (id) sender {
	NSString* port = portField.text;
	NSString* host = hostField.text;
	FolderViewController* rootViewController = [[FolderViewController alloc] initWithNibName:@"FolderViewController" bundle:nil];
	rootViewController.folder = [[AGSFolder alloc] initWithURL: [@"http://" stringByAppendingFormat:@"%@:%@/ArcGIS/rest/services", host, port] name:@"/"];
	[self.navigationController pushViewController: rootViewController animated:YES];
	[rootViewController release];
}




@end
