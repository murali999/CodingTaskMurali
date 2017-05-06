//
//  ViewController.h
//  CodingTaskMurali
//
//  Created by Murali on 05/05/17.
//  Copyright © 2017 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodingTaskMurali-swift.h"

@interface ViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *notifItem;
@property (weak, nonatomic) IBOutlet ADVSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableArticles;
@property (strong,nonatomic) NSArray *responseData;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

