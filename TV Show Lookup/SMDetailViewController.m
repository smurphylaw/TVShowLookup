//
//  DetailViewController.m
//  TV Show Lookup
//
//  Created by Murphy on 12/5/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import "SMDetailViewController.h"
#import "SMMasterViewController.h"
#import "TVShowDataStore.h"
#import "SMDetailCastTableViewCell.h"
#import "SMDetailEpisodeTableViewCell.h"
#import "BackgroundLayer.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface SMDetailViewController ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation SMDetailViewController

#pragma mark - Managing the detail item

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:nil
                                            delegateQueue:nil];
        
        // [self fetchFeed];
    }
    
    return self;
}

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        self.cast = @[];
        self.episodes = @[];


        // Update the view.
        [self configureView];

        // Get subview data
        [self fetchCast];
        [self fetchEpisodes];
    }
}

- (void)configureView {
//    TVShowDataStore *tv = [TVShowDataStore sharedInstance];
    NSDictionary *tvShow = (NSDictionary *) self.detailItem;
    NSString *network = [tvShow valueForKeyPath:@"network.name"];
    
    NSString *deleteHTMLPattern = @"<[^>]+>";
    NSRegularExpression *removeHTML = [NSRegularExpression regularExpressionWithPattern:deleteHTMLPattern
                                                                                options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSString *summaryWithoutFormatting = [removeHTML stringByReplacingMatchesInString:tvShow[@"summary"] options:NSMatchingAnchored range:NSMakeRange(0, [tvShow[@"summary"] length]) withTemplate:@""];
    NSString *nextStep = @"";
    nextStep = [removeHTML stringByReplacingMatchesInString:summaryWithoutFormatting options:NULL range:NSMakeRange(0, [summaryWithoutFormatting length]) withTemplate:@""];

    while (![nextStep isEqualToString:summaryWithoutFormatting]) {
        summaryWithoutFormatting = [nextStep copy];
        nextStep = [removeHTML stringByReplacingMatchesInString:summaryWithoutFormatting options:NULL range:NSMakeRange(0, [summaryWithoutFormatting length]) withTemplate:@""];
    }
    // NSLog(summaryWithoutFormatting);
    self.title = tvShow[@"name"];
    self.tvShowStatus = tvShow[@"status"];
    self.tvShowSummary.text = summaryWithoutFormatting;
    self.datePremiered.text = tvShow[@"premiered"];
    self.networkName.text = network;
    
    NSURL *imageURL = [NSURL URLWithString:[tvShow valueForKeyPath:@"image.original"]];
    [self.tvShowLogo setImageWithURL:imageURL];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger itemsCount = 0;
    
    if (tableView == self.castTableView) {
        itemsCount = [self.cast count];
    } else {
        if (tableView == self.episodeTableView){
        itemsCount = [self.episodes count];
        } }
    return itemsCount;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.castTableView) {
        
        SMDetailCastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"castCell" forIndexPath:indexPath];
    
        // NSString *tvShow = self.tvShowList[indexPath.row][@"name"];
        NSDictionary *castMember = self.cast[indexPath.row];
    
        cell.castRealName.text = [castMember valueForKeyPath:@"person.name"];
        cell.castCharacter.text = [castMember valueForKeyPath:@"character.name"];

        // to get person images later..
        //    NSURL *imageURL = [NSURL URLWithString:[tvShow valueForKeyPath:@"image.original"]];
        //    [cell.showLogo setImageWithURL:imageURL];
        
        return cell;
        
    } else {
        if (tableView == self.episodeTableView) {
        SMDetailEpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"episodesCell" forIndexPath:indexPath];
        
        NSDictionary *episodes = self.episodes[indexPath.row];
        
        cell.episodeName.text = [episodes valueForKeyPath:@"name"];
        cell.episodeNumber.text = [[episodes valueForKeyPath:@"number"] description];
            cell.seasonNumber.text = [[episodes valueForKeyPath:@"season"] description];
            
        return cell;
        
    } }
    
    return nil;
}

#pragma mark - Fetch feed

-(void)fetchCast {
    
    // This gets you data for just the show with id = 1: Under the Dome.
    //    NSString *requestString = @"http://api.tvmaze.com/shows/1";
  //  for (int showID = 1; showID < maxShowID; showID++) {
        NSString *requestString = [@"http://api.tvmaze.com/shows/" stringByAppendingFormat:@"%@/cast",self.detailItem[@"id"]];
        NSURL *url = [NSURL URLWithString:requestString];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            
            NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:0
                                                                         error:nil];
            
            self.cast = jsonObject;
            [self.castTableView reloadData];
            
            NSLog(@"%@", jsonObject);
            
        }];
        
        [dataTask resume];
    
}

-(void)fetchEpisodes {
    
    // This gets you data for just the show with id = 1: Under the Dome.
    //    NSString *requestString = @"http://api.tvmaze.com/shows/1";
    //  for (int showID = 1; showID < maxShowID; showID++) {
    NSString *requestString = [@"http://api.tvmaze.com/shows/" stringByAppendingFormat:@"%@/episodes",self.detailItem[@"id"]];
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                              options:0
                                                                error:nil];
        
        self.episodes = jsonObject;
        [self.episodeTableView reloadData];
        
        NSLog(@"%@", jsonObject);
        
    }];
    
    [dataTask resume];
    
}


@end
