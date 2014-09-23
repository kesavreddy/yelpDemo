//
//  DetailedViewController.h
//  YelpDemo
//
//  Created by Venkata Reddy on 9/21/14.
//  Copyright (c) 2014 Venkata Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedViewController : UIViewController
@property (nonatomic,strong)NSDictionary* content;
@property (nonatomic,strong)NSString* listingTitle;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@end
