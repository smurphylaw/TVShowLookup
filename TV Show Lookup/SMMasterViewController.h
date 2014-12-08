//
//  MasterViewController.h
//  TV Show Lookup
//
//  Created by Murphy on 12/5/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMDetailViewController;

@interface SMMasterViewController : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) SMDetailViewController *detailViewController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

