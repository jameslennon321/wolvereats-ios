//
//  MyTripsListViewController.m
//  WolverEats
//
//  Created by Cameron Cohen on 3/2/15.
//  Copyright (c) 2015 James Lennon. All rights reserved.
//

#import "MyTripsListViewController.h"
#import "MyTripsListTableViewCell.h"
#import "Backend.h"
#import <UIScrollView+SVPullToRefresh.h>
#import "NSDate+Helper.h"
#import "TripViewController.h"

@interface MyTripsListViewController ()

@end

@implementation MyTripsListViewController

- (id) init {
    if ((self = [super init])) {
        
        self.title = @"My Trips";
        self.tabBarItem.image = [UIImage imageNamed:@"MyTripsTab.png"];

    
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIEdgeInsets inset = UIEdgeInsetsMake(60, 0, 0, 0);
        _tableView.contentInset = inset;
        _tableView.scrollIndicatorInsets = inset;
        
        [_tableView registerClass:[MyTripsListTableViewCell class] forCellReuseIdentifier:@"MyTripCell"];
        
        [self.view addSubview:_tableView];
        
        
        [_tableView addPullToRefreshWithActionHandler:^{
            // prepend data to dataSource, insert cells at top of table view
            // call [tableView.pullToRefreshView stopAnimating] when done
            [Backend sendRequestWithURL:@"trips/get_user_active_trips" Parameters:@{} Callback:^(NSDictionary * data) {
                _activeTripsData = [data objectForKey:@"trips"];
                
                [_tableView.pullToRefreshView stopAnimating];
                [_tableView reloadData];
            }];
        }];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [_tableView triggerPullToRefresh];
    //[self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Active Trips";
    else{
        return @"Old Trips";
    }
}


- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_activeTripsData count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyTripsListTableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:@"MyTripCell"];
    //[cell setNeedsUpdateConstraints];
    
    NSDictionary* trip = _activeTripsData[indexPath.row];
    
    NSString *restaurantString = trip[@"restaurant_name"];
    cell.restaurantLabel.text = restaurantString;
    
    int eta = [trip[@"eta"] intValue];
    NSDate *etaDate = [NSDate dateWithTimeIntervalSince1970:eta];
    NSString *etaS = [NSDate stringFromDate:etaDate withFormat:@"hh:mm"];
    NSString *etaString = @"Arriving at ";
    cell.etaLabel.text = [NSString stringWithFormat:@"%@%@", etaString,etaS];
    

   NSString* tripId = trip[@"trip_id"];
                           
    [Backend sendRequestWithURL:@"orders/get_trip_orders" Parameters:@{@"trip_id":tripId} Callback:^(NSDictionary * data) {
      _orders = data;
        
        if ([_orders count] == 0)
        {
            cell.numOrdersLabel.text = @"0";
            cell.numOrdersLabel.backgroundColor =[UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
            //cell.numOrdersLabel.backgroundColor = [UIColor colorWithRed:249.0f/255.0f green:199.0f/255.0f blue:199.0f/255.0f alpha:1.0f];
        }
        else{
            
            NSInteger* size = [_orders count];
            cell.numOrdersLabel.text = [NSString stringWithFormat:@"%li", size];
            cell.numOrdersLabel.backgroundColor = [UIColor colorWithRed:188.0f/255.0f green:239.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
        }
        }];
    
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* trip = _activeTripsData[indexPath.row];
    TripViewController *vc = [[TripViewController alloc] initWithData:trip];
    [self.navigationController pushViewController:vc animated:YES];
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