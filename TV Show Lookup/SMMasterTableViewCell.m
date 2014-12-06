//
//  SMMasterTableViewCell.m
//  TV Show Lookup
//
//  Created by Murphy on 12/5/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import "SMMasterTableViewCell.h"

@implementation SMMasterTableViewCell

@synthesize tvShowName;
@synthesize castNames;
@synthesize showCategory;
@synthesize showRating;
@synthesize showLogo;
@synthesize cellId;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
