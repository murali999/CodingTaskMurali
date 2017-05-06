//
//  ViewController.m
//  CodingTaskMurali
//
//  Created by Murali on 05/05/17.
//  Copyright © 2017 Murali. All rights reserved.
//

#import "ViewController.h"
#import "UIBarButtonItem+Badge.h"
#import "CourcesViewController.h"
#import "BooksViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController ()
@end

@implementation ViewController

NSURLSessionConfiguration *config;
NSURLSession *session;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _responseData = [[NSArray alloc] init];
    config = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:config];
    
    _notifItem.badgeValue = @"1";
    _segmentedControl.borderColor = [UIColor colorWithRed:38.0f/255.0f green:123.0f/255.0f blue:185.0f/255.0f alpha:1.0f];
    _segmentedControl.selectedIndex = 0;
    _segmentedControl.items = [NSArray arrayWithObjects:@"ARTICLES",@"COURSES",@"BOOKS",nil];
    [_segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventAllEvents];
    
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat screenHeight = self.view.frame.size.height;
    
    CGFloat scrollY = _segmentedControl.frame.origin.y+_segmentedControl.frame.size.height + 10;
    
    [_scrollView setFrame:CGRectMake(0, scrollY, screenWidth, screenHeight - scrollY - 49)];
    
    [_tableArticles setFrame:CGRectMake(_tableArticles.frame.origin.x, _tableArticles.frame.origin.y, _tableArticles.frame.size.width, screenHeight - scrollY - 49)];
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CourcesViewController *bViewController = [sb instantiateViewControllerWithIdentifier:@"courses"];
    CGRect frame1 = bViewController.view.frame;
    frame1.origin.x = screenWidth;
    frame1.size.width = screenWidth;
    frame1.size.height = _tableArticles.frame.size.height;
    bViewController.view.frame = frame1;
    [bViewController.tableCourses setFrame:_tableArticles.frame];
    [self addChildViewController:bViewController];
    [self.scrollView addSubview:bViewController.view];
    [bViewController didMoveToParentViewController:self];
    
    BooksViewController *cViewController = [sb instantiateViewControllerWithIdentifier:@"books"];
    CGRect frame = cViewController.view.frame;
    frame.origin.x = screenWidth*2;
    frame.size.width = screenWidth;
    frame.size.height = _tableArticles.frame.size.height;
    cViewController.view.frame = frame;
    [cViewController.tableBooks setFrame:_tableArticles.frame];
    [self addChildViewController:cViewController];
    [self.scrollView addSubview:cViewController.view];
    [cViewController didMoveToParentViewController:self];
    
    self.scrollView.contentSize = CGSizeMake(screenWidth*3, screenHeight - scrollY - 49);
    self.scrollView.pagingEnabled = YES;
    
    [self getData];
}

-(void)getData{
    [_activityIndicator removeFromSuperview];
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _activityIndicator.layer.cornerRadius = 05;
    _activityIndicator.opaque = NO;
    _activityIndicator.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    _activityIndicator.center = self.view.center;
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activityIndicator setColor:[UIColor whiteColor]];//colorWithRed:0.6 green:0.8 blue:1.0 alpha:1.0]];
    [self.view addSubview: _activityIndicator];
    
    [_activityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"http://34.199.13.140/api/candidateMobileGetRecommendedArticleList/"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *parseError;
            _responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_activityIndicator stopAnimating];
                [_tableArticles reloadData];
            });
            
            NSLog(@"Articles data%@",_responseData);
        }];
        [dataTask resume];
    });
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        _segmentedControl.selectedIndex = page;
        previousPage = page;
    }
}

-(void)segmentValueChanged:(id)sender{
    NSInteger index = _segmentedControl.selectedIndex;
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _responseData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseID"];
    }
    
    cell.contentView.backgroundColor = [UIColor blackColor];

    NSDictionary *data = [_responseData objectAtIndex:indexPath.row];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10, 120)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius  = 10.0f;
    [cell addSubview:view];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    [view addSubview:iv];
    
    NSString *gridId = [[data objectForKey:@"coverImage"] valueForKey:@"gridId"];
    NSString *url = [NSString stringWithFormat:@"http://34.199.13.140/api/candidateMobileReadImage/%@",gridId];
    [iv setImageWithURL:[NSURL URLWithString:url]];
    
    iv.contentMode = UIViewContentModeScaleAspectFill;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:iv.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path  = maskPath.CGPath;
    iv.layer.mask = maskLayer;
    iv.clipsToBounds = YES;
    iv.layer.masksToBounds = YES;
    
    CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width - 130, FLT_MAX);
    
    UILabel *lblArtName = [[UILabel alloc] initWithFrame:CGRectMake(125, 5, self.view.frame.size.width - 140, 85)];
    CGSize expectedLabelSize = [[data valueForKey:@"articleName"] sizeWithFont:lblArtName.font constrainedToSize:maximumLabelSize lineBreakMode:lblArtName.lineBreakMode];
    CGRect newFrame = lblArtName.frame;
    newFrame.size.height = expectedLabelSize.height;
    lblArtName.frame = newFrame;
    lblArtName.numberOfLines = 0;
    lblArtName.text = [[data valueForKey:@"articleName"] uppercaseString];
    [view addSubview:lblArtName];
    
    UILabel *lblDomain = [[UILabel alloc] initWithFrame:CGRectMake(125, 90, self.view.frame.size.width - 130, 20)];
    lblDomain.textColor = [UIColor grayColor];
    lblDomain.text = [[data valueForKey:@"domain"] uppercaseString];
    [view addSubview:lblDomain];
    
    [lblArtName setFont:[UIFont systemFontOfSize:13.0f]];
    [lblDomain setFont:[UIFont systemFontOfSize:13.0f]];
    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
