//
//  NewTopicViewController.m
//  nfsYouLin
//
//  Created by Macx on 16/6/16.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NewTopicViewController.h"

@interface NewTopicViewController ()

@end

@implementation NewTopicViewController

- (id) initWithTitle: (NSString*) title
{
    self = [super init];
    if(self)
    {
        self.navigationItem.title = title;
    }
    
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 测
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 150, 50)];
    [label setText:@"打发打发"];
    [label setTextColor:[UIColor greenColor]];
    [self.view addSubview:label];

    
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
