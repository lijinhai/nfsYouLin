//
//  ErrorVC.m
//  nfsYouLin
//
//  Created by Macx on 16/9/28.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ErrorVC.h"

@interface ErrorVC ()

@end

@implementation ErrorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITextView* errorView = [[UITextView alloc] initWithFrame:self.view.bounds];
    errorView.text = self.error;
    errorView.editable = NO;
    errorView.textColor = [UIColor blackColor];
    [self.view addSubview:errorView];
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
