//
//  ResultsCell.h
//  YelpDemo
//
//  Created by Venkata Reddy on 9/21/14.
//  Copyright (c) 2014 Venkata Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingsView;
@property (weak, nonatomic) IBOutlet UILabel *reviewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addessLabel;
@property (weak, nonatomic) IBOutlet UILabel *catLabel;

@end
