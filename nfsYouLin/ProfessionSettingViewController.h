//
//  ProfessionSettingViewController.h
//  nfsYouLin
//
//  Created by jinhai on 16/7/6.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfessionSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{

    NSArray *DataSource;

}
@property (weak, nonatomic) IBOutlet UITableView *workSettingTable;

@property (weak, nonatomic) IBOutlet UITextField *workerNameTextField;

@property(nonatomic,retain) NSString *workerValue;

@property(nonatomic,retain) NSString *statusState;

typedef void (^ReturnWorkerTextBlock)(NSString *showText);
@property (nonatomic, copy) ReturnWorkerTextBlock returnWorkerTextBlock;
- (void)returnText:(ReturnWorkerTextBlock)block;

typedef void (^ReturnWorkerShowBlock)(NSString *showVal);
@property (nonatomic, copy) ReturnWorkerShowBlock returnWorkerShowBlock;
- (void)returnShow:(ReturnWorkerShowBlock)block;

- (IBAction)profession_DiaEndOnExit:(id)sender;
- (IBAction)View_TouchDown:(id)sender;


@end


