//
//  SettingsViewController.h
//  YelpDemo
//
//  Created by Venkata Reddy on 9/21/14.
//  Copyright (c) 2014 Venkata Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;
@protocol SettingsViewControllerDelegate <NSObject>
- (void)addItemViewController:(SettingsViewController *)controller didFinishEnteringItem:(NSString *)item;

@end
@interface SettingsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;
- (void) cancelFilters;
- (void) searchWithFilters;
@end
