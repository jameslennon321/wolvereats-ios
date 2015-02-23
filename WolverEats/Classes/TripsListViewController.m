//
//  TripsListViewController.m
//  WolverEats
//
//  Created by James Lennon on 2/4/15.
//  Copyright (c) 2015 James Lennon. All rights reserved.
//

#import "TripsListViewController.h"
#import "TripViewController.h"
#import "Backend.h"
#import <UIScrollView+SVPullToRefresh.h>
#import "NSDate+Helper.h"


@interface TripsListViewController ()

@end

@implementation TripsListViewController

- (id) init {
    if ((self = [super init])) {
        //also have to create the tripsCEll - dont forget
        NSLog(@"trips coming");
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
#warning FIX THIS SO IT MAKES THE TABLE VIEW DISPLAY - ITS COMING UP BLANK

        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        
        [_tableView addPullToRefreshWithActionHandler:^{
            
            // prepend data to dataSource, insert cells at top of table view
            // call [tableView.pullToRefreshView stopAnimating] when done
            [Backend sendRequestWithURL:@"trips/get_all_trips" Parameters:@{} Callback:^(NSDictionary * data) {
                _tripsData = [data objectForKey:@"trips"];
                [_tableView.pullToRefreshView stopAnimating];
                [_tableView reloadData];
            }];
        }];
        [_tableView triggerPullToRefresh];

    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tripsData count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:@"tripCell"];
    //if (!cell) {
      //  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tripCell"];
    //}
    NSDictionary* trip = _tripsData[indexPath.row];
    
    /*UILabel* restaurant = [UILabel alloc] initWithFrame:CGRectMake(10, 10, 291, 26);
    restaurant.text = trip[@"restaurant_name"];
    restaurant.textAlignment = NSTextAlignmentCenter;
    restaurant.font = [UIFont systemFontOfSize:10];
    [cell.l addSubview:welcome];*/
    
    int eta = [trip[@"eta"] intValue];
    NSDate *etaDate = [NSDate dateWithTimeIntervalSince1970:eta];
    UILabel* time = (UILabel*)[cell viewWithTag:102];
    NSString *etaString = [NSDate stringFromDate:etaDate withFormat:@"hh:mm"];
    time.text = [NSString stringWithFormat:@"%@", etaString];
    
    //change when James writes prof URL code in server
    NSURL *profURL = [NSURL URLWithString:@"http://placehold.it/30x30"];
    UIImageView *profView = (UIImageView*)[cell viewWithTag:103];

    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        NSData *image = [[NSData alloc] initWithContentsOfURL:profURL];
        
        
        //this will set the image when loading is finished
        dispatch_async(dispatch_get_main_queue(), ^{
            profView.image = [UIImage imageWithData:image];
        });
    });
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* trip = _tripsData[indexPath.row];
    TripViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"trip"];
    vc.tripData = trip;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
