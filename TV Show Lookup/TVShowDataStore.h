//
//  TVShowDataStore.h
//  TV Show Lookup
//
//  Created by Murphy on 12/5/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TVShowDataStore : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSArray *tvShowList;

+(instancetype)sharedInstance;

@end
