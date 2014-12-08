//
//  TVShowDataStore.m
//  TV Show Lookup
//
//  Created by Murphy on 12/5/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import "TVShowDataStore.h"
#import "SMMasterTableViewCell.h"
#import "SMMasterViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface TVShowDataStore()

@end

@implementation TVShowDataStore

static NSString * const reuseIdentifier = @"tvShowListCell";

+(instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init {
    self = [super init];
    
    self.tvShowList = [NSArray array];
    return self;
}

/*
 -(void)addRandomData {
    
    SMMasterTableViewCell *cell1 = [SMMasterTableViewCell new];
    cell1.tvShowName.text = @"The Big Bang Theory";
    cell1.castNames.text = @"Jim Parson, Kaley Cuoco";
    cell1.showCategory.text = @"Comedy";
    cell1.showRating.text = @"9.2";
    
    
    SMMasterTableViewCell *cell2 = [SMMasterTableViewCell new];
    cell1.tvShowName.text = @"Person Of Interest";
    cell1.castNames.text = @"Michael Emerson, Jim Caviezel";
    cell1.showCategory.text = @"Drama";
    cell1.showRating.text = @"8.9";
    
    self.tvShowList = [NSArray arrayWithObjects:cell1, cell2, nil];
}
 */

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger itemsCount = self.tvShowList.count;
    return itemsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMMasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // NSString *tvShow = self.tvShowList[indexPath.row][@"name"];
    NSDictionary *tvShow = self.tvShowList[indexPath.row];
    NSString *network = [self.tvShowList valueForKeyPath:@"network.name"][indexPath.row];

    cell.tvShowName.text = tvShow[@"name"];
    cell.showStatus.text = tvShow[@"status"];
    cell.showNetwork.text = network;
    NSURL *imageURL = [NSURL URLWithString:[tvShow valueForKeyPath:@"image.original"]];
    [cell.showLogo setImageWithURL:imageURL];
    
    // This is just for debug reference - not needed for production
    cell.cellId = indexPath.row;
    
    return cell;
}

@end
