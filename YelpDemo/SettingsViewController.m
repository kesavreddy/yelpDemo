//
//  SettingsViewController.m
//  YelpDemo
//
//  Created by Venkata Reddy on 9/21/14.
//  Copyright (c) 2014 Venkata Reddy. All rights reserved.
//

#import "SettingsViewController.h"
#import "ResultsViewController.h"

@interface SettingsViewController ()

//@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *sectionLabels;
@property (strong,nonatomic) NSMutableDictionary *finalFilters;

@property (strong, nonatomic) NSArray *catKeys;
@property (strong, nonatomic) NSArray *radiusKeys;
@property (strong, nonatomic) NSArray *sortbyKeys;
@property (strong, nonatomic) NSArray *dealsKeys;

//holds all the values for each section
@property (strong, nonatomic) NSArray *categoryValues;
@property (strong, nonatomic) NSArray *radiusValues;
@property (strong, nonatomic) NSArray *sortByValues;
@property (strong, nonatomic) NSArray *dealsValues;

@end

@implementation SettingsViewController
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
        NSLog(@"initWithNibName:- %@",self.finalFilters);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        // load section labels
        self.sectionLabels = @[@"Distance",@"Sort by",@"Categories",@"Deals"];
        self.selectedFilters = [NSMutableDictionary dictionary];
        
        self.catKeys = [NSArray arrayWithObjects:@"active",@"arts",@"auto", @"beautysvc", @"food", nil];
        self.categoryValues = [NSArray arrayWithObjects:@"Active Life", @"Arts & Entertainment", @"Automotive", @"Beauty & Spas", @"Food", nil];
        
        self.radiusKeys = [NSArray arrayWithObjects:@"1609",@"3218",@"8047", @"16093", nil];
        self.radiusValues = [NSArray arrayWithObjects:@"1 mile", @"2 miles", @"5 miles", @"10 miles", nil];
        
        self.sortbyKeys = [NSArray arrayWithObjects:@"0",@"1",@"2", nil];
        self.sortByValues = [NSArray arrayWithObjects:@"Best Matched", @"Distance", @"Highest Rated", nil];
        
        self.dealsKeys = [NSArray arrayWithObjects:@"0",@"1", nil];
        self.dealsValues = [NSArray arrayWithObjects:@"Yes", @"No", nil];
        // load default filter for categoy as food
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
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
    NSInteger noOfRows = 0;
    switch (section){
            case 0:
                noOfRows = self.radiusValues.count;
                break;
            case 1:
                noOfRows = self.sortByValues.count;
                break;
            case 2:
                noOfRows = self.categoryValues.count;
                break;
            case 3:
                noOfRows = self.dealsValues.count;
                break;
    }
    return noOfRows;
}

// fill header text for all section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 50)];
    headerLabel.text = self.sectionLabels[section];
    headerLabel.font = [UIFont systemFontOfSize:15];
    headerLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    [headerView addSubview:headerLabel];

    return headerView;
}

// Set height for section heade label
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

// number of section in table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectionLabels count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"row selected :- %ld at section :- %ld",indexPath.row,indexPath.section);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *selectedRow = self.selectedFilters[@(indexPath.section)];
    if ([selectedRow containsObject:@(indexPath.row)]){
        //[self.selectedFilters removeObjectForKey:@(indexPath.row)];
        self.selectedFilters[@(indexPath.section)] = @[];
    } else {
        self.selectedFilters[@(indexPath.section)] = @[@(indexPath.row)];
    }
    [tableView reloadData];
}

- (UITableViewCell *)tableView:tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSArray *selectedRow = self.selectedFilters[@(indexPath.section)];
    //NSLog(@"selectedRow :-%@ at section:-%ld",selectedRow,indexPath.section);
    if ([selectedRow containsObject:@(indexPath.row)]){
        cell.imageView.image = [UIImage imageNamed:@"selected_star"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"unselected_star"];
    }
    switch (indexPath.section){
        case 0:{
            cell.textLabel.text = self.radiusValues[indexPath.row];
            break;}
        case 1:{
            cell.textLabel.text = self.sortByValues[indexPath.row];
            break;}
        case 2:{
            cell.textLabel.text = self.categoryValues[indexPath.row];
            break;}
        case 3:{
            cell.textLabel.text = self.dealsValues[indexPath.row];
            break;}
    }
    return cell;
}

/// When user cancel filters settings
- (void) cancelFilters{
    NSLog(@"cancelFilters:- %@",self.finalFilters);
    self.selectedFilters = self.finalFilters;
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:NO];
//     [self.navigationController popViewControllerAnimated:YES];
}

// When user want to narrow his search
- (void) searchWithFilters{
    NSLog(@"searchWithFilters:- %@",self.selectedFilters);
    // iniatize to default filters
    NSMutableDictionary *filterParams = [[NSMutableDictionary alloc] init];
    filterParams[@"category_filter"]=@"";
    filterParams[@"deals_filter"]=@"";
    filterParams[@"radius_filter"]=@"";
    filterParams[@"sort"]=@"";
    
    self.finalFilters = self.selectedFilters;
    
    NSInteger count = [self.finalFilters count];
    NSArray* keys = [self.selectedFilters allKeys];
    NSArray* values = [self.selectedFilters allValues];
    NSInteger index;
    id object,key,value;
    NSString* filter;
    NSArray* arry;
    for (int i = 0; i < count; i++) {
        key = keys[i];
        value = values[i];
        //NSLog(@"%@ -> %@", key, value);
        arry = value;
        NSLog(@"%ld",[arry count]);
        if ([arry count] > 0){
            object = arry[0];
            index = [object integerValue];
            switch ([key integerValue]) {
                // for distance
                case 0:
                    filter = [self.radiusKeys objectAtIndex:index];
                    NSLog(@" distance at index %ld for %@",(long)index,filter);
                    [filterParams setObject:filter forKey:@"radius_filter"];
                    NSLog(@"After");
                    break;
                // for sortBy
                case 1:
                                        NSLog(@" sort at index %ld",(long)index);
                    filter = [self.sortbyKeys objectAtIndex:index];
                    [filterParams setObject:filter forKey:@"sort"];
                    break;
                // for category
                case 2:
                                        NSLog(@" cat at index %ld",(long)index);
                    filter = [self.catKeys objectAtIndex:index];
                    [filterParams setObject:filter forKey:@"category_filter"];
                    break;
                // for deals
                case 3:
                                        NSLog(@" deals at index %ld",(long)index);
                    filter = [self.dealsKeys objectAtIndex:index];
                    [filterParams setObject:filter forKey:@"deals_filter"];
                    break;
            }
        }
        
    }
    NSLog(@" filter param %@",filterParams);
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate filterSettingsChange:self didClickonSearch:self.finalFilters withfilters:filterParams];
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
