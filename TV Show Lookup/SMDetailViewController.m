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
        self.episodes = @{};
        NSDictionary *tvShow = (NSDictionary * )self.detailItem;

        // Retrieve cast and episode data
//        self.cast = [[TVShowDataStore sharedInstance] castForShow:tvShow[@"id"]];
//        self.episodes = [[TVShowDataStore sharedInstance] episodesForShow:tvShow[@"id"]];
        [self fetchCast];

        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
//    TVShowDataStore *tv = [TVShowDataStore sharedInstance];
    NSDictionary *tvShow = (NSDictionary *) self.detailItem;
    NSString *network = [tvShow valueForKeyPath:@"network.name"];
    
    self.title = tvShow[@"name"];
    self.tvShowStatus = tvShow[@"status"];
    self.tvShowSummary.text = tvShow[@"summary"];
    self.datePremiered.text = tvShow[@"premiered"];
    self.networkName.text = network;
    
    
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
        // other tables here -- add if clauses
    }
    return itemsCount;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMDetailCastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"castCell" forIndexPath:indexPath];
    
    // NSString *tvShow = self.tvShowList[indexPath.row][@"name"];
    NSDictionary *castMember = self.cast[indexPath.row];
    
    cell.castRealName.text = [castMember valueForKeyPath:@"person.name"];
    cell.castCharacter.text = [castMember valueForKeyPath:@"character.name"];

    // to get person images later..
//    NSURL *imageURL = [NSURL URLWithString:[tvShow valueForKeyPath:@"image.original"]];
//    [cell.showLogo setImageWithURL:imageURL];
    
    // This is just for debug reference - not needed for production
  //  cell.cellId = indexPath.row;
    
    return cell;
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

@end
