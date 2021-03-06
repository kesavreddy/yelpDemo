//
//  ResultsViewController.m
//  YelpDemo
//
//  Created by Venkata Reddy on 9/21/14.
//  Copyright (c) 2014 Venkata Reddy. All rights reserved.
//

// tutorial for location manager - http://www.appcoda.com/how-to-get-current-location-iphone-user/

#import "ResultsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DetailedViewController.h"
#import "ResultsCell.h"
#import "YelpClient.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface ResultsViewController (){
        BOOL isSearch;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic,strong) NSArray *results;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) UIRefreshControl *refreshControl ;
@property (strong,nonatomic) NSMutableDictionary *filters;
@property (strong,nonatomic) UITableViewCell *_stubCell;
@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //fetch once current location
    //CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    //self.currentLocation = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
    
    
    //Location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    self.currentLocation = [[CLLocation alloc] initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    NSLog(@"current location %@",self.currentLocation);
    
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    // Get data
    [self fetchData:@""];
    UINib *cellNib = [UINib nibWithNibName:@"ResultsCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"ResultsCell"];
    
    self.filters = [NSMutableDictionary dictionary];
    
    __stubCell = [cellNib instantiateWithOwner:nil options:nil][0]; //instantiate cell object

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{
    if (isSearch){
        return self.searchResult.count;
    } else{
        return self.results.count;
    }
}

- (UITableViewCell *)tableView:tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultsCell *cell = [tableview dequeueReusableCellWithIdentifier:@"ResultsCell"];
    NSDictionary *result;
     if (isSearch) {
         if (self.searchResult.count > indexPath.row) {
             result = self.searchResult[indexPath.row];
         }
     } else {
         result = self.results[indexPath.row];
     }

    cell.titleLabel.text = result[@"name"];
    
    NSString *postUrl = result[@"image_url"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:postUrl]];
    
    NSString *ratingUrl = result[@"rating_img_url"];
    [cell.ratingsView setImageWithURL:[NSURL URLWithString:ratingUrl]];
    
    NSString * addr = [result[@"location"][@"address"] componentsJoinedByString:@""];
    cell.addessLabel.text = addr;
    
    NSInteger reviews = [result[@"review_count"] integerValue];
    cell.reviewsLabel.text = [NSString stringWithFormat:@"%ld reviews",reviews] ;

    NSArray *categories = result[@"categories"];
    NSString *tempCat = [[NSString alloc]init];
    for (int pos=0; pos<[categories count]; pos++) {
        if(pos > 0 ) {
            tempCat = [tempCat stringByAppendingString:@", "];
        }
        tempCat = [tempCat stringByAppendingString:categories[pos][0]];
    }
    cell.catLabel.text = tempCat;//[result[@"categories"] componentsJoinedByString:@", "];
    
    NSString *latStr =[result valueForKeyPath:@"location.coordinate.latitude"];
    NSString *longStr =[result valueForKeyPath:@"location.coordinate.longitude"];
    if(latStr != nil && longStr != nil) {
        CLLocationDegrees lat = [latStr floatValue];
        CLLocationDegrees lang = [longStr floatValue];
        CLLocation *listingLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lang];
        if(self.currentLocation != nil){
            CLLocationDistance distance = [self.currentLocation distanceFromLocation:listingLocation] * 0.000621371;
            cell.distLabel.text = [NSString stringWithFormat:@"%.1f mi",distance];
        } else {
            cell.distLabel.text =@"";
        }
    }else {
        cell.distLabel.text =@"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ResultsCell *resultCell = (ResultsCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *result = self.results[indexPath.row];
    
    DetailedViewController *detailViewController = [[DetailedViewController alloc] init];
    detailViewController.content = result;
    detailViewController.listingTitle = resultCell.titleLabel.text;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

// return dynamic row height based on the content
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [__stubCell layoutSubviews];
    CGFloat height = [__stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height + 1;
//    NSLog(@"row height :-%f",[resultCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height);
}

-(void) createSearchBar {
     UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20.0, 10.0, 200.0, 25.0)];
     self.searchBar = searchBar;
     self.searchBar.barStyle=UIBarStyleDefault;
     self.searchBar.showsCancelButton=NO;
     self.searchBar.autocorrectionType=UITextAutocorrectionTypeNo;
     self.searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;

    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    self.searchBar.delegate = self;
    [self.searchBar resignFirstResponder];
    [searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBarView;
    
    //add filter button to nav controller
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Filters" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
    [button.layer setCornerRadius:4.0f];
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor: [[UIColor redColor] CGColor]];
    button.frame=CGRectMake(0.0, 100.0, 60.0, 30.0);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showFiltersView)  forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *filterBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = filterBtn;
}

-(void) showFiltersView {
    NSLog(@"On Click on Filter");
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.delegate = self;
    settingsViewController.selectedFilters = self.filters;
    //[self.navigationController pushViewController:settingsViewController animated:YES];
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:settingsViewController animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];

}

/*
 * When user start searching
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"search box clicked");
    if([searchText isEqualToString:@""] || searchText==nil) {
        isSearch = NO;
        [self.tableView reloadData];
        return;
    }
    isSearch = YES;
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.results filteredArrayUsingPredicate:resultPredicate]];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchText = searchBar.text;
    NSLog(@"searchText %@",searchText);
    isSearch = YES;
    [self.searchBar resignFirstResponder];
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.results filteredArrayUsingPredicate:resultPredicate]];
    [self.tableView reloadData];

}

/*
 * Get latest data from yelp api without any filters
 */
- (void)fetchData:(NSString*) searchText {
    [self fetchData:searchText WithCategory:@"" withSortBy:0 withRadius:1609 withDeals:@"true"];
}

/*
 * Get latest data from yelp api based on filters
 */
- (void)fetchData:(NSString*) searchText WithCategory:(NSString*)category withSortBy:(NSUInteger)sortBy withRadius:(NSInteger) radius withDeals:(NSString*) deals {
    // Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self.client searchWithTerm:searchText WithCategory:category WithDeals:deals WithRadius:radius WithSort:sortBy success:^(AFHTTPRequestOperation *operation, id response) {
        self.results = response[@"businesses"];
        if ([self.results count] > 0){
            self.tableView.tableHeaderView = nil;
        } else {
            NSLog(@"results is empty");
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,30)];
            label.text = @"No results that match your search filters!!";
            [view addSubview:label];
            self.tableView.tableHeaderView = view;
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

/*
 * Get latest data from yelp api based on filters
 */
- (void)fetchData:(NSString*) searchText withFilters:(NSDictionary *)filters{
    // Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self.client searchWithTerm:searchText withFilters:filters success:^(AFHTTPRequestOperation *operation, id response) {
        self.results = response[@"businesses"];
        if ([self.results count] > 0){
            self.tableView.tableHeaderView = nil;
        } else {
            NSLog(@"results is empty");
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,30)];
            label.text = @"No results that match your search filters!!";
            [view addSubview:label];
            self.tableView.tableHeaderView = view;
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    self.currentLocation = newLocation;
    
    if (self.currentLocation != nil) {
        NSLog(@"lat = %.8f and lang =%.8f", self.currentLocation.coordinate.longitude, self.currentLocation.coordinate.latitude);
        // Stop Location Manager
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
        NSLog(@"didUpdateLocations: %@", locations);
}

- (void)filterSettingsChange:(SettingsViewController *)controller didClickonSearch:(NSMutableDictionary *)filterSettings withfilters:(NSMutableDictionary *)filters {
    // store it to local prop so that while open filters page we can show what user settings are
    NSLog(@"delegate method called %@ and %@", filterSettings,filters);
    self.filters = filterSettings;
    // now fetch data with filters settings
    //NSArray* keys = [filterSettings allKeys];
    
    [self fetchData:@"" withFilters:filters];
    [self.tableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
