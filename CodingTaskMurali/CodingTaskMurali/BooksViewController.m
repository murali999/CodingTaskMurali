//
//  BooksViewController.m
//  CodingTaskMurali
//
//  Created by Murali on 05/05/17.
//  Copyright © 2017 Murali. All rights reserved.
//

#import "BooksViewController.h"
#import "UIImageView+AFNetworking.h"

@interface BooksViewController ()

@end

@implementation BooksViewController
NSURLSessionConfiguration *config2;
NSURLSession *session2;
- (void)viewDidLoad {
    [super viewDidLoad];
    _responseData = [[NSArray alloc] init];
    config2 = [NSURLSessionConfiguration defaultSessionConfiguration];
    session2 = [NSURLSession sessionWithConfiguration:config2];
    [self getData];
}

-(void)getData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionDataTask *dataTask = [session2 dataTaskWithURL:[NSURL URLWithString:@"http://34.199.13.140/api/candidateMobileGetRecommendedBookList/"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *parseError;
            _responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableBooks reloadData];
            });
            
            NSLog(@"Books data %@",_responseData);
        }];
        [dataTask resume];
    });
    
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
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:iv.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path  = maskPath.CGPath;
    iv.layer.mask = maskLayer;
    iv.clipsToBounds = YES;
    iv.layer.masksToBounds = YES;
    
    iv.contentMode = UIViewContentModeScaleAspectFill;
    
    CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width - 130, FLT_MAX);
    
    UILabel *lblArtName = [[UILabel alloc] initWithFrame:CGRectMake(125, 5, self.view.frame.size.width - 140, 85)];
    CGSize expectedLabelSize = [[data valueForKey:@"bookName"] sizeWithFont:lblArtName.font constrainedToSize:maximumLabelSize lineBreakMode:lblArtName.lineBreakMode];
    CGRect newFrame = lblArtName.frame;
    newFrame.size.height = expectedLabelSize.height;
    lblArtName.frame = newFrame;
    lblArtName.numberOfLines = 0;
    lblArtName.text = [[data valueForKey:@"bookName"] uppercaseString];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
