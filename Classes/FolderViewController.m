//
//  RootViewController.m
//  ArcgisRest
//
//  Created by Guilhem Vellut on 1/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FolderViewController.h"
#import "ArcgisRestAppDelegate.h"
#import "AGSService.h"
#import "AGSMapService.h"
#import "AGSMapServiceViewController.h"
#import "JSON.h"


@implementation FolderViewController

@synthesize folder;

/*
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
 // self.navigationItem.rightBarButtonItem = self.editButtonItem;
 }
 */

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if(folder == nil) {
		self.folder = [[AGSFolder alloc] initWithURL: @"http://sampleserver1.arcgisonline.com/ArcGIS/rest/services" name:@"/"];
		[folder release];
	}
	
	self.title = folder.name;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	[folder fetchContent: self];
	receivedData= [[NSMutableData data] retain];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];	
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
	
    [connection release];
    [receivedData release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
	
	NSString* stringReply = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	[folder handleResourceData:[stringReply JSONValue]];
	
	[self.tableView reloadData];
	[connection release];
    [receivedData release];	
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0){
		return [folder.subFolders count];
	} else {
		return [folder.services count];
	}
}

//RootViewController.m
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 0)
		return @"Folders";
	else
		return @"Services";
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.font = [UIFont systemFontOfSize:14];
	
	if(indexPath.section == 0){
		//folder	
		cell.text = ((AGSFolder*)[folder.subFolders objectAtIndex:indexPath.row]).name;
	}else {
		//service
		AGSService* service = [folder.services objectAtIndex: indexPath.row];
		cell.text = [NSString stringWithFormat:
					 [service.name stringByAppendingString:@" (%@)"], 
					 service.type];
		if(! [service isKindOfClass: [AGSMapService class]])
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
    return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 0)
		return UITableViewCellAccessoryDisclosureIndicator;
	else {
		AGSService* service = [folder.services objectAtIndex:indexPath.row];
		if([service isKindOfClass:[AGSMapService class]])
			return UITableViewCellAccessoryDisclosureIndicator;
	}
	return UITableViewCellAccessoryNone;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	if(indexPath.section == 0) {
		FolderViewController* subFolderViewController = [[FolderViewController alloc] initWithNibName:@"FolderViewController" bundle:nil];
		subFolderViewController.folder = [folder.subFolders objectAtIndex:indexPath.row];
		[self.navigationController pushViewController: subFolderViewController animated:YES];
		[subFolderViewController release];
	} else {
		AGSService* service = [folder.services objectAtIndex:indexPath.row];
		if([service isKindOfClass:[AGSMapService class]]){
			AGSMapServiceViewController* mapServiceViewController = [[AGSMapServiceViewController alloc] initWithNibName:@"AGSMapServiceViewController" bundle:nil];
			mapServiceViewController.mapService = (AGSMapService*) service;
			[self.navigationController pushViewController:mapServiceViewController animated:YES];
			[mapServiceViewController release];
		}
	}
}



- (void)dealloc {
	[folder release];
    [super dealloc];
}


@end

