//
//  MasterViewController.m
//  TV Show Lookup
//
//  Created by Murphy on 12/5/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import "SMMasterViewController.h"
#import "SMDetailViewController.h"
#import "TVShowDataStore.h"
#import "BackgroundLayer.h"

@interface SMMasterViewController ()

//@property NSMutableArray *objects;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation SMMasterViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:nil
                                            delegateQueue:nil];
        
        [self fetchFeed];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = [TVShowDataStore sharedInstance];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    // UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    // self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (SMDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
 
}

-(void)viewWillAppear:(BOOL)animated {
    CAGradientLayer *bgLayer = [BackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    self.title = @"TV Show Lookup";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)insertNewObject:(id)sender {
    
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    NSArray *tvShow = [TVShowDataStore sharedInstance].tvShowList;
    if (tvShow != nil) {
    [self.objects addObject:[tvShow objectAtIndex:0]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        NSLog(@"TV Show list is nil!");
    }

}*/

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SMDetailViewController *controller = (SMDetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:[TVShowDataStore sharedInstance].tvShowList[indexPath.row]];
    // recommend adding check to make sure it's there to avoid crash
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        controller.navigationItem.leftBarButtonItem.title = @"Back";
        self.title = @"Back";
    
}

#pragma mark - Table View

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
 //       [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark - Fetch feed

int maxShowID = 10; // arbitrary - fetch first ten records.

-(void)fetchFeed {
    
    // This gets you data for just the show with id = 1: Under the Dome.
    //    NSString *requestString = @"http://api.tvmaze.com/shows/1";
    for (int showID = 1; showID < maxShowID; showID++) {
        NSString *requestString = [@"http://api.tvmaze.com/shows/" stringByAppendingFormat:@"%i",showID];
        NSURL *url = [NSURL URLWithString:requestString];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:0
                                                                         error:nil];
            
            [TVShowDataStore sharedInstance].tvShowList = [[TVShowDataStore sharedInstance].tvShowList arrayByAddingObject:jsonObject];
            [self.tableView reloadData];
            
            NSLog(@"%@", jsonObject);
            
        }];
        
        [dataTask resume];
    }
}

@end
