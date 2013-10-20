//
//  SelShaderViewController.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/19/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "SelShaderViewController.h"
#import "GameViewController.h"

@interface SelShaderViewController ()
{
	NSMutableArray *_items;
}

@end

@implementation SelShaderViewController

- (id)initWithStyle:(UITableViewStyle)style
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[_items release];
	[super dealloc];
}

- (void)viewDidLoad
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidLoad];
	
	_items = [[NSMutableArray alloc]init];
	NSString* labels[] = {
#if 0
		NONE = 0,
		OVERLAY,
		DODGE,
		BURN
#endif
		@"無効",
		@"オーバーレイ",
		@"覆い焼き(覆い焼きカラー？)",
		@"焼き込み",
		@"加算（覆い焼きリニア？）",
		@"ぼかし",
		@"諧調落とし（作成中）",
	};
	const int count = sizeof(labels) / sizeof(labels[0]);
	for (int i = 0; i < count; i++) {
		NSString* strCell = labels[i];
		[_items addObject:strCell];
	}

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
    // Return the number of rows in the section.
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//NSLog(@"%s : row :%d", __PRETTY_FUNCTION__, indexPath.row);
	NSString *CellIdentifier = [_items objectAtIndex: indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		//NSLog(@"alloc cell");
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	cell.textLabel.text = CellIdentifier;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"%s : row : %d", __PRETTY_FUNCTION__, indexPath.row);
	GAMEVIEW_SHADER shader = (GAMEVIEW_SHADER)indexPath.row;
	if (shader != NONE) {
		GameViewController *controller = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
		controller.setupShader = shader;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}

	/*
	 */
}

@end
