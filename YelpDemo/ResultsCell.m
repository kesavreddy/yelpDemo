//
//  ResultsCell.m
//  YelpDemo
//
//  Created by Venkata Reddy on 9/21/14.
//  Copyright (c) 2014 Venkata Reddy. All rights reserved.
//

#import "ResultsCell.h"

@implementation ResultsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    //UIView *view = [[UIView alloc] initWithFrame:self.frame];
    //view.backgroundColor = [UIColor colorWithRed:255 green:250 blue:240 alpha:0.2];
    //self.selectedBackgroundView = view;
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
