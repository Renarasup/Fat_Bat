//
//  LevelSelectViewController.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/15/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "LevelSelectViewController.h"

@implementation LevelSelectViewController{
    NSArray<NSString *> *_lines;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set bg color
    self.view.backgroundColor = [UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0];
    
    //configure table view
    self.tableView.backgroundColor = [UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //get lines from level file
    NSString *string = [LevelFileHandler levelsFile];
    _lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //reload table's data
    [self.tableView reloadData];
    
    //show navigation bar and set title
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Select a Level";
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; //one section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lines.count; //one row for each level
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //get level name
    NSArray *words = [_lines[indexPath.row] componentsSeparatedByString:@" "];
    NSString *levelName = words[0];
    

    //load level file and spereate into lines
    NSString *levelFile = [LevelFileHandler levelWithName:levelName];
    NSArray *lines = [LevelFileHandler getLinesFromLevelFile:levelFile];
    
    //get color from line 2
    NSArray *rgbValues = [lines[1] componentsSeparatedByString:@" "];
    UIColor *levelColor = [UIColor colorWithRed:[rgbValues[0] floatValue]/255.0 green:[rgbValues[1] floatValue]/255.0 blue:[rgbValues[2] floatValue]/255.0 alpha:1.0];
    
    
    //create table cell
    static NSString *CellIdentifier = @"levelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    //configure table cell
    cell.backgroundColor = [UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0];
    cell.textLabel.textColor = levelColor;
    cell.textLabel.text = [levelName stringByReplacingOccurrencesOfString:@"_" withString:@" "];;
    cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    
    //set detail text based on completion status
    cell.detailTextLabel.font = [UIFont fontWithName:FONT_NAME size:DETAIL_FONT_SIZE];
    if ([words[1] isEqualToString:@"NO"]) {
        cell.detailTextLabel.text = @"~Incomplete";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }else{
        cell.detailTextLabel.text = @"~Completed";
        cell.detailTextLabel.textColor = [UIColor greenColor];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //get level name
    NSArray *words = [_lines[indexPath.row] componentsSeparatedByString:@" "];
    NSString *levelName = words[0];
    
    //init game controller with level name
    GameViewController *gameViewController = [[GameViewController alloc] initWithLevelName:levelName];
    
    // Push view controller
    [self.navigationController pushViewController:gameViewController animated:YES];
}

@end
