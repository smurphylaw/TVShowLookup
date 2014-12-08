//
//  SMDetailEpisodeTableViewCell.h
//  TV Show Lookup
//
//  Created by Murphy on 12/7/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMDetailEpisodeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *episodeName;
@property (weak, nonatomic) IBOutlet UILabel *seasonNumber;
@property (weak, nonatomic) IBOutlet UILabel *episodeNumber;

@end
