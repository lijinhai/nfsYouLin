//
//  ChooseSexTypeViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseSexTypeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{

    NSArray *DataSource;

}

@property (weak, nonatomic) IBOutlet UITableView *sexTable;
@property(nonatomic,retain) NSString *sexValue;

typedef void (^ReturnSexTextBlock)(NSString *sexText);
@property (nonatomic, copy) ReturnSexTextBlock returnSexTextBlock;
- (void)returnText:(ReturnSexTextBlock)block;

@end
