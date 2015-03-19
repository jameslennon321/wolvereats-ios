//
//  MyTripViewController.h
//  WolverEats
//
//  Created by Cameron Cohen on 3/2/15.
//  Copyright (c) 2015 James Lennon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTripViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) NSDictionary *tripData;
@property (nonatomic, strong) NSArray *tripOrderData;

- (id)initWithData:(NSDictionary *)tripData;

@end
