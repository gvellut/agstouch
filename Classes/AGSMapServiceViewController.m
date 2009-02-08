//
//  AGSMapServiceViewController.m
//  ArcgisRest
//
//  Created by Guilhem Vellut on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AGSMapServiceViewController.h"
#import "AGSSpatialReference.h"
#import "AGSTileInfo.h"
#import "AGSEnvelope.h"
#import "AGSLayer.h"
#import "JSON.h"
#import "MapViewController.h"


#define SERVICE_DESCRIPTION 0
#define MAP_NAME 1
#define COPYRIGHT_TEXT 2
#define LAYERS 3
#define SPATIAL_REFERENCE 4
#define UNITS 5
#define TILE_INFO 6
#define INITIAL_EXTENT 7
#define FULL_EXTENT 8
#define DOCUMENT_INFO 9

#define DESCRIPTION 10 //not displayed
#define NUM_SECTIONS 10

#define BOLD_TITLE_CELL_ID @"BoldTitleCell"
#define NORMAL_CELL_ID @"NormalCell"
#define LONG_TEXT_CELL_ID @"LongTextCell"

#define LONG_TEXT_VIEW_TAG 1
#define BOLD_TEXT_KEY_VIEW_TAG 1
#define BOLD_TEXT_VALUE_VIEW_TAG 2

#define LONG_TEXT_FONT_SIZE 14
#define LONG_TEXT_PADDING_TOP 8.0
#define LONG_TEXT_PADDING_BOTTOM 8.0
#define LONG_TEXT_PADDING_LEFT 5.0
#define LONG_TEXT_PADDING_RIGHT 5.0

#define BOLD_TEXT_FONT_SIZE 14
#define BOLD_TEXT_LABEL_WIDTH 185.0
#define BOLD_TEXT_PADDING_TOP 12.0
#define BOLD_TEXT_PADDING_BOTTOM 12.0


#define GROUPED_BORDER_PADDING_LEFT_RIGHT 20.0
#define DEFAULT_GROUPED_BORDER_CELL_WIDTH 300.0
#define  DEFAULT_GROUPED_BORDER_CELL_HEIGHT 44.0f


@interface AGSMapServiceViewController (hidden)

- (UITableViewCell*) getNormalCell: (UITableView*) tableView;
- (UITableViewCell*) getLongTextCell: (UITableView*) tableView;
- (UITableViewCell*) getLongTextCell:(UITableView*) tableView forString: (NSString*) text;
- (UITableViewCell*) getBoldTitleCell: (UITableView*) tableView;
- (UITableViewCell*) getBoldTitleCell: (UITableView*) tableView forKey: (NSString*) key value:(NSString*) value;
- (int) heightForLongText : (NSString*) text;
- (int) heightForBoldText : (NSString*) text;
- (UITableViewCell*) renderEnvelope: (UITableView*) tableView envelope: (AGSEnvelope*) envelope  row: (int) row ;
- (UITableViewCell*) renderDocumentInfo: (UITableView*) tableView info: (NSDictionary*) info  row: (int) row ;
- (void) showMap: (id) sender;
@end


@implementation AGSMapServiceViewController

@synthesize mapService;


- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self) {
        UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain
																		 target:self action:@selector(showMap:)];
        self.navigationItem.rightBarButtonItem = mapButton; 
    }
	
    return self;
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if(mapService != nil) 
		self.title = [mapService.name stringByReplacingOccurrencesOfString:@"_" withString:@" "];
	
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	if(mapService != nil) {
		[mapService fetchContent:self];
		receivedData= [[NSMutableData data] retain];
	}
	
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
	[mapService handleResourceData:[stringReply JSONValue]];
	
	[self.tableView reloadData];
	[connection release];
    [receivedData release];	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if(mapService == nil || ! mapService.contentIsFetched)
		return 1;
    return NUM_SECTIONS;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(mapService == nil || ! mapService.contentIsFetched)
		return nil;
	
	switch (section) {
		case SERVICE_DESCRIPTION:
			return @"Service description";
		case MAP_NAME:
			return @"Map name";
		case DESCRIPTION:
			return @"Description";
		case COPYRIGHT_TEXT:
			return @"Copyright text";
		case LAYERS :
			return @"Layers";
		case SPATIAL_REFERENCE :
			return @"Spatial reference (WKID)";
		case TILE_INFO :
			return @"Tile Info";
		case INITIAL_EXTENT :
			return @"Initial extent";
		case FULL_EXTENT :
			return @"Full extent";
		case UNITS :
			return @"Units";
		case DOCUMENT_INFO :
			return @"Document info";
		default:
			return nil;
	}
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(mapService == nil || ! mapService.contentIsFetched)
		return 0;
	
	switch (section) {
		case SERVICE_DESCRIPTION:
			return 1;
		case MAP_NAME:
			return 1;
		case DESCRIPTION:
			return 1;
		case COPYRIGHT_TEXT:
			return 1;
		case LAYERS :
			return [mapService.layers count];
		case SPATIAL_REFERENCE :
			return 1;
		case TILE_INFO : //TODO change
			return 1;
		case INITIAL_EXTENT :
			return 5;
		case FULL_EXTENT :
			return 5;
		case UNITS :
			return 1;
		case DOCUMENT_INFO :
			return 6;		
		default:
			return 0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set up the cell...
	switch (indexPath.section) {
		case SERVICE_DESCRIPTION:
			return [self getLongTextCell: tableView forString: mapService.serviceDescription];
		case MAP_NAME: {
			UITableViewCell* cell = [self getNormalCell: tableView];
			cell.text = mapService.mapName;
			return cell;		
		} case DESCRIPTION:
			return [self getLongTextCell: tableView forString:mapService.description];
		case COPYRIGHT_TEXT:
			return [self getLongTextCell: tableView forString:mapService.copyrightText];
		case LAYERS : {
			UITableViewCell* cell = [self getNormalCell: tableView];
			cell.text = ((AGSLayer*)[mapService.layers objectAtIndex:indexPath.row]).name;
			return cell;
		} case SPATIAL_REFERENCE : {
			UITableViewCell* cell = [self getNormalCell: tableView];
			cell.text = [[NSNumber numberWithInt:  mapService.spatialReference.wkid] stringValue];
			return cell;
		} case TILE_INFO : {//TODO change
			UITableViewCell* cell = [self getNormalCell: tableView];
			cell.text = @"TileInfo";
			return cell;
		} case INITIAL_EXTENT : 
			return [self renderEnvelope:tableView envelope:mapService.initialExtent row:indexPath.row];
		case FULL_EXTENT :
			return [self renderEnvelope:tableView envelope:mapService.fullExtent row:indexPath.row];
		case UNITS : {
			UITableViewCell* cell = [self getNormalCell: tableView];
			cell.text = mapService.units;
			return cell;
		} case DOCUMENT_INFO :
			return [self renderDocumentInfo: tableView info:mapService.documentInfo row:indexPath.row];		
		default:
			return nil;
	}
	
}


- (UITableViewCell*) getNormalCell: (UITableView*) tableView {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NORMAL_CELL_ID];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:NORMAL_CELL_ID] autorelease];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}


- (UITableViewCell*) getLongTextCell:(UITableView*) tableView {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: LONG_TEXT_CELL_ID];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:LONG_TEXT_CELL_ID] autorelease];
	
		float defaultWidth = DEFAULT_GROUPED_BORDER_CELL_WIDTH - LONG_TEXT_PADDING_RIGHT - LONG_TEXT_PADDING_LEFT;
		float defaultHeight = DEFAULT_GROUPED_BORDER_CELL_HEIGHT - LONG_TEXT_PADDING_TOP - LONG_TEXT_PADDING_BOTTOM;
		
		CGRect cr = CGRectMake(LONG_TEXT_PADDING_LEFT, LONG_TEXT_PADDING_TOP, defaultWidth, defaultHeight ); 
		UILabel* textView = [[UILabel alloc] initWithFrame:cr];
		textView.tag = LONG_TEXT_VIEW_TAG;
		textView.numberOfLines = 0;
		textView.lineBreakMode = UILineBreakModeWordWrap;
		textView.font = [UIFont systemFontOfSize: LONG_TEXT_FONT_SIZE];
		textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:textView];
		[textView release];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	return cell;
}

- (UITableViewCell*) getLongTextCell:(UITableView*) tableView forString:(NSString*) text {
	UITableViewCell* cell = [self getLongTextCell:tableView];
	UILabel* textView = (UILabel*)[cell.contentView viewWithTag:LONG_TEXT_VIEW_TAG];
	textView.text = text;
	return cell;
}


- (UITableViewCell*) getBoldTitleCell: (UITableView*) tableView {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: BOLD_TITLE_CELL_ID];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:BOLD_TITLE_CELL_ID] autorelease];
		
		UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(10.0, 15.0, 90.0, 14.0)] autorelease];
		label.tag = BOLD_TEXT_KEY_VIEW_TAG;
		label.font = [UIFont boldSystemFontOfSize:12.0];
		label.textAlignment = UITextAlignmentLeft;
		label.textColor = [UIColor blueColor];
		label.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:label];
		
		float defaultHeight = DEFAULT_GROUPED_BORDER_CELL_HEIGHT - BOLD_TEXT_PADDING_TOP - BOLD_TEXT_PADDING_BOTTOM;
		UILabel* value = [[[UILabel alloc] initWithFrame:CGRectMake(105.0, 12.0, BOLD_TEXT_LABEL_WIDTH, defaultHeight)] autorelease];
		value.tag = BOLD_TEXT_VALUE_VIEW_TAG;
		value.numberOfLines = 0;
		value.font = [UIFont boldSystemFontOfSize: BOLD_TEXT_FONT_SIZE];
		value.textColor = [UIColor blackColor];
		value.lineBreakMode = UILineBreakModeWordWrap;
		value.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:value];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}



- (UITableViewCell*) getBoldTitleCell: (UITableView*) tableView forKey:(NSString*)key value:(NSString*) value {
	UITableViewCell* cell = [self getBoldTitleCell:tableView];
	
	UILabel* labelView = (UILabel*)[cell.contentView viewWithTag:BOLD_TEXT_KEY_VIEW_TAG];
	labelView.text = key;
	
	UILabel* valueView =(UILabel*)[cell.contentView viewWithTag:BOLD_TEXT_VALUE_VIEW_TAG];
	valueView.text = value;
	
	return cell;
}



- (UITableViewCell*) renderEnvelope: (UITableView*) tableView envelope: (AGSEnvelope*) envelope row: (int) row {
	
	switch(row) {
		case 0 :
			return [self getBoldTitleCell:tableView forKey:@"XMIN" value:[[NSNumber numberWithDouble:envelope.xmin] stringValue]];
			break;
		case 1 :
			return [self getBoldTitleCell:tableView forKey:@"XMAX" value:[[NSNumber numberWithDouble:envelope.xmax] stringValue]];
			break;
		case 2 :
			return [self getBoldTitleCell:tableView forKey:@"YMIN" value:[[NSNumber numberWithDouble:envelope.ymin] stringValue]];
			break;
		case 3 :
			return [self getBoldTitleCell:tableView forKey:@"YMAX" value:[[NSNumber numberWithDouble:envelope.ymax] stringValue]];
			break;
		default :
			return [self getBoldTitleCell:tableView forKey:@"WKID" value: [[NSNumber numberWithInt: envelope.spatialReference.wkid] stringValue]]; 
	}
			
}

- (UITableViewCell*) renderDocumentInfo: (UITableView*) tableView info: (NSDictionary*) info  row: (int) row  {
	UITableViewCell* cell = [self getBoldTitleCell:tableView];
	switch(row) {
		case 0 :
			return [self getBoldTitleCell:tableView forKey:@"Title" value:[info objectForKey:@"Title"]];
			break;
		case 1 :
			return [self getBoldTitleCell:tableView forKey:@"Author" value:[info objectForKey:@"Author"]];
			break;
		case 2 :
			return [self getBoldTitleCell:tableView forKey:@"Comments" value: [info objectForKey:@"Comments"]];
			break;
		case 3 :
			return [self getBoldTitleCell:tableView forKey:@"Subject" value:[info objectForKey:@"Subject"]];
			break;
		case 4 :
			return [self getBoldTitleCell:tableView forKey:@"Category" value:[info objectForKey:@"Category"]]; 
			break;
		default :
			return [self getBoldTitleCell:tableView forKey:@"Keywords" value:[info objectForKey:@"Keywords"]];
			break;			  
	}
	return cell;	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	float height;
	
	float paddingLong = LONG_TEXT_PADDING_TOP + LONG_TEXT_PADDING_BOTTOM;
	float paddingBold = BOLD_TEXT_PADDING_TOP + BOLD_TEXT_PADDING_BOTTOM;
	
	switch (indexPath.section) {
		case SERVICE_DESCRIPTION:
			height = [self heightForLongText:mapService.serviceDescription] + paddingLong;
			break;
		case DESCRIPTION:
			height = [self heightForLongText:mapService.description]  + paddingLong;
			break;
		case COPYRIGHT_TEXT:
			height = [self heightForLongText:mapService.copyrightText] + paddingLong;
			break;
		case DOCUMENT_INFO: {
			NSDictionary* info = mapService.documentInfo;
			switch (indexPath.row) {
				case 0 :
					height = [self heightForBoldText:[info objectForKey:@"Title"]] + paddingBold;
					break;
				case 1 :
					height =  [self heightForBoldText:[info objectForKey:@"Author"]]  + paddingBold;
					break;
				case 2 :
					height =  [self heightForBoldText:[info objectForKey:@"Comments"]]   + paddingBold;
					break;
				case 3 :
					height =  [self heightForBoldText:[info objectForKey:@"Subject"]]  + paddingBold;
					break;
				case 4 :
					height =  [self heightForBoldText:[info objectForKey:@"Category"]]  + paddingBold; 
					break;
				default :
					height =  [self heightForBoldText:[info objectForKey:@"Keywords"]]  + paddingBold;
					break;	
				}
			break;
		}default :
			height = DEFAULT_GROUPED_BORDER_CELL_HEIGHT;
	}
	
	if(height < DEFAULT_GROUPED_BORDER_CELL_HEIGHT)
		return DEFAULT_GROUPED_BORDER_CELL_HEIGHT;
	return height;
	
}

- (int) heightForLongText : (NSString*) text {
	//320 - GROUPED_BORDER_PADDING_LEFT_RIGHT - LONG_TEXT_PADDING_RIGHT - LONG_TEXT_PADDING_LEFT = 290.0
	return [text sizeWithFont:[UIFont systemFontOfSize: LONG_TEXT_FONT_SIZE] 
			constrainedToSize:CGSizeMake(290.0, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
}

- (int) heightForBoldText : (NSString*) text {
	if([text isEqualToString:@""])
		return 20.0; //DEFAULT_CELL_HEIGHT - BOLD_TEXT_PADDING_RIGHT - BOLD_TEXT_PADDING_LEFT 
	return [text sizeWithFont:[UIFont boldSystemFontOfSize: BOLD_TEXT_FONT_SIZE] 
			constrainedToSize:CGSizeMake(BOLD_TEXT_LABEL_WIDTH, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
}


- (void) showMap: (id) sender {
	MapViewController* mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
	[self.navigationController pushViewController: mapViewController animated:YES];
	[mapViewController release];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}




- (void)dealloc {
	[mapService release];
    [super dealloc];
}


@end

