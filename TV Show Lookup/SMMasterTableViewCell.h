//
//  SMMasterTableViewCell.h
//  TV Show Lookup
//
//  Created by Murphy on 12/5/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMMasterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tvShowName;
@property (weak, nonatomic) IBOutlet UILabel *castNames;
@property (weak, nonatomic) IBOutlet UILabel *showCategory;
@property (weak, nonatomic) IBOutlet UILabel *showRating;

@property (weak, nonatomic) IBOutlet UIImageView *showLogo;


@end
