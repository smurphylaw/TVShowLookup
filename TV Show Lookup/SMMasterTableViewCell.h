//
//  SMMasterTableViewCell.h
//  TV Show Lookup
//
//  Created by Murphy on 12/5/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMMasterTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *tvShowName;
@property (strong, nonatomic) IBOutlet UILabel *castNames;
@property (strong, nonatomic) IBOutlet UILabel *showCategory;
@property (strong, nonatomic) IBOutlet UILabel *showRating;

@property (strong, nonatomic) IBOutlet UIImageView *showLogo;

@property (assign, atomic) NSInteger cellId;


@end
