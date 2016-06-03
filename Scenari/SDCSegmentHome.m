//
//  SDCSegmentHome.m
//  Scenari
//
//  Created by Neegbeah Reeves on 6/2/16.
//  Copyright © 2016 Brown Box Works. All rights reserved.
//

#import "SDCSegmentHome.h"
#import "SDCSegmentedViewController.h"


@interface SDCSegmentHome()

@property (strong,nonatomic) SDCSegmentedViewController * s;

@end

@implementation SDCSegmentHome

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SDCSegmentedViewController *segmentedViewController = segue.destinationViewController;
    segmentedViewController.position = SDCSegmentedViewControllerControlPositionNavigationBar;
    segmentedViewController.switchesWithSwipe = NO;
    
    
    [segmentedViewController addStoryboardSegments:@[@"recent", @"popular"]];
    
    
    
    
    
}



@end
