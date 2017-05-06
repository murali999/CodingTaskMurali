//
//  BooksViewController.h
//  CodingTaskMurali
//
//  Created by Murali on 05/05/17.
//  Copyright © 2017 Murali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BooksViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableBooks;
@property (strong,nonatomic) NSArray *responseData;
@end
