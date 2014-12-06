//
//  DetailViewController.h
//  TV Show Lookup
//
//  Created by Murphy on 12/5/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *tvShowSummary;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *networkName;
@property (weak, nonatomic) IBOutlet UILabel *tvShowStatus;
@property (weak, nonatomic) IBOutlet UILabel *datePremiered;

@property (weak, nonatomic) IBOutlet UIImageView *tvShowLogo;


@property (weak, nonatomic) IBOutlet UITableView *castTableView;
@property (weak, nonatomic) IBOutlet UITableView *episodeTableView;


@end

