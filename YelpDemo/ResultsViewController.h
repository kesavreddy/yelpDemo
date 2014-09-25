//
//  ResultsViewController.h
//  YelpDemo
//
//  Created by Venkata Reddy on 9/21/14.
//  Copyright (c) 2014 Venkata Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SettingsViewController.h"

@interface ResultsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,SettingsViewControllerDelegate,CLLocationManagerDelegate>

-(void)createSearchBar;
-(void)showFiltersView;
- (void)fetchData:(NSString*) searchText WithCategory:(NSString*)category withSortBy:(NSUInteger)sortBy withRadius:(NSInteger) radius withDeals:(NSString*) deals;
@end
