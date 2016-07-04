//
//  scanQrCodeViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/6/23.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "scanQrCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";

@interface scanQrCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) UIView *sanFrameView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL lastResut;
@property (strong, nonatomic) CALayer *scanLayer;
@end

@implementation scanQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_button setTintColor:[UIColor yellowColor]];
    [_button setTitle:@"开始" forState:UIControlStateNormal];
    _lastResut = YES;
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    [self stopReading];
}


- (BOOL)startReading
{
    [_button setTitle:@"停止" forState:UIControlStateNormal];
    // 获取 AVCaptureDevice 实例
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"为什么 %@", [error localizedDescription]);
        return NO;
    }
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // 添加输出流
    [_captureSession addOutput:captureMetadataOutput];
    
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 设置元数据类型 AVMetadataObjectTypeQRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    //设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //设置图层的frame
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    //将图层添加到预览view的图层上
    [self.view.layer addSublayer:_videoPreviewLayer];
    //设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.6f, 0.6f);
    //扫描框
    _sanFrameView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.2f, self.view.bounds.size.height * 0.2f, self.view.bounds.size.width - self.view.bounds.size.width * 0.4f, self.view.bounds.size.height - self.view.bounds.size.height * 0.4f)];
    _sanFrameView.layer.borderColor = [UIColor whiteColor].CGColor;
    _sanFrameView.layer.borderWidth = 2.0f;
    [self.view addSubview:_sanFrameView];
    //扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _sanFrameView.bounds.size.width, 1);
    _scanLayer.backgroundColor = [UIColor redColor].CGColor;
    [_sanFrameView.layer addSublayer:_scanLayer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    // 开始会话
    [_captureSession startRunning];
    
    return YES;
}
- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_videoPreviewLayer.frame.size.height < _scanLayer.frame.origin.y +50) {
        _scanLayer.frame = CGRectMake(0, 0, _videoPreviewLayer.bounds.size.width, 1);
    }else{
        frame.origin.y += 20;
        [UIView animateWithDuration:0.01f animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

- (void)stopReading
{
    [_button setTitle:@"开始" forState:UIControlStateNormal];
    // 停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
}

- (void)reportScanResult:(NSString *)result
{
    [self stopReading];
    if (!_lastResut) {
        return;
    }
    _lastResut = NO;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"二维码扫描" message:result preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    // 以及处理了结果，下次扫描
    _lastResut = YES;
}

#pragma AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
        } else {
            NSLog(@"不是二维码");
        }
        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
    }
}
- (IBAction)startScanner:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"开始"]) {
        [self startReading];
    } else {
        [self stopReading];
    }
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
