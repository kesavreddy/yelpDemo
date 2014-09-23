//
//  ResultsViewController.h
//  YelpDemo
//
//  Created by Venkata Reddy on 9/21/14.
//  Copyright (c) 2014 Venkata Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ResultsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,CLLocationManagerDelegate>
-(void)createSearchBar;
-(void)showFiltersView;
@end
