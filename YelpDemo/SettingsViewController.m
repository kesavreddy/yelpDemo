//
//  SettingsViewController.m
//  YelpDemo
//
//  Created by Venkata Reddy on 9/21/14.
//  Copyright (c) 2014 Venkata Reddy. All rights reserved.
//

#import "SettingsViewController.h"
#import "ResultsCell.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *sectionLabels;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // load section labels
    self.sectionLabels = @[@"Price",@"Most Popular",@"Distance",@"Sort by",@"General Features"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    
    //set navigation title
    self.navigationItem.title = @"Filter Results";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //add cancel button
    UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    buttonCancel.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
    [buttonCancel.layer setCornerRadius:4.0f];
    [buttonCancel.layer setMasksToBounds:YES];
    [buttonCancel.layer setBorderWidth:1.0f];
    [buttonCancel.layer setBorderColor: [[UIColor grayColor] CGColor]];
    buttonCancel.frame=CGRectMake(0.0, 100.0, 60.0, 30.0);
    [buttonCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonCancel addTarget:self action:@selector(cancelFilters)  forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithCustomView:buttonCancel];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    //add search button
    UIButton *buttonSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSearch setTitle:@"Search" forState:UIControlStateNormal];
    buttonSearch.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
    [buttonSearch.layer setCornerRadius:4.0f];
    [buttonSearch.layer setMasksToBounds:YES];
    [buttonSearch.layer setBorderWidth:1.0f];
    [buttonSearch.layer setBorderColor: [[UIColor grayColor] CGColor]];
    buttonSearch.frame=CGRectMake(0.0, 100.0, 60.0, 30.0);
    [buttonSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonSearch addTarget:self action:@selector(searchWithFilters)  forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithCustomView:buttonSearch];
    self.navigationItem.rightBarButtonItem = searchBtn;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 50)];
    headerLabel.text = self.sectionLabels[section];
    headerLabel.font = [UIFont systemFontOfSize:20];
    headerLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    [headerView addSubview:headerLabel];

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (UITableViewCell *)tableView:tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSLog(@"cell %@",cell);
    return cell;
}

- (void) cancelFilters{
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:NO];
//     [self.navigationController popViewControllerAnimated:YES];
}

- (void) searchWithFilters{
    [self.navigationController popViewControllerAnimated:YES];
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
