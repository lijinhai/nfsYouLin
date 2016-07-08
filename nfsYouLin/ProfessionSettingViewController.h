//
//  ProfessionSettingViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfessionSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    NSArray *DataSource;

}
@property (weak, nonatomic) IBOutlet UITableView *workSettingTable;

@property (weak, nonatomic) IBOutlet UITextField *workerNameTextField;

@property(nonatomic,retain) NSString *workerValue;

typedef void (^ReturnWorkerTextBlock)(NSString *showText);
@property (nonatomic, copy) ReturnWorkerTextBlock returnWorkerTextBlock;
- (void)returnText:(ReturnWorkerTextBlock)block;
@end


