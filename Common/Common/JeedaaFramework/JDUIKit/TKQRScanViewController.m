//
//  TKQRScanf.m
//  seabuy
//
//  Created by 田凯 on 15/2/12.
//  Copyright (c) 2015年 田凯. All rights reserved.
//



#import "TKQRScanViewController.h"
#import <AVFoundation/AVFoundation.h>
@implementation TKQRScanViewController{
    BOOL _isReading;
    AVCaptureSession*   _captureSession; // 二维码生成的绘画
    AVCaptureVideoPreviewLayer *_videoPreviewLayer; // 二维码生成的图层
    UIView *_line;
    CGPoint _scanCenter;
    CGRect _scanRect;
}

-(void)viewDidLoad{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //设置自定义界面
    [self setOverlayPickerView];
    [self startReading];

}
- (void)capture {
    //扫描二维码
    [self startReading];
}
- (void)setOverlayPickerView
{
    CGFloat maxWidth=[UIScreen mainScreen].bounds.size.width;
    CGFloat maxHeight=[UIScreen mainScreen].bounds.size.height;
    CGFloat edgeLength=280;
    CGPoint center=CGPointMake(maxWidth/2.0, maxHeight/2.0);
    CGRect scanRect=CGRectMake(center.x - edgeLength/2.0, center.y -edgeLength/2.0, edgeLength, edgeLength);
    _scanCenter=center;
    _scanRect=scanRect;
    //清除原有控件
    for (UIView *temp in [self.view subviews]) {
        for (UIButton *button in [temp subviews]) {
            if ([button isKindOfClass:[UIButton class]]) {
                [button removeFromSuperview];
            }
        }
        for (UIToolbar *toolbar in [temp subviews]) {
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                [toolbar setHidden:YES];
                [toolbar removeFromSuperview];
            }
        }
    }
    //画中间的基准线
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(scanRect.origin.x+20, scanRect.origin.y+5, scanRect.size.width-40, 1)];
    _line=line;
    line.backgroundColor = [UIColor redColor];
    [self.view addSubview:line];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, scanRect.origin.y)];
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //用于说明的label
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(15, 20, [UIScreen mainScreen].bounds.size.width-15*2, 50);
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码或条码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [upView addSubview:labIntroudction];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, scanRect.origin.y, scanRect.origin.x, scanRect.size.height)];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(maxWidth-scanRect.origin.x, scanRect.origin.y, scanRect.origin.x, scanRect.size.height)];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, scanRect.origin.y+scanRect.size.height, maxWidth, maxHeight-scanRect.origin.y-scanRect.size.height)];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    //用于取消操作的button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.alpha = 0.4;
    [cancelButton setFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height-90, [UIScreen mainScreen].bounds.size.width-20*2, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [cancelButton addTarget:self action:@selector(dismissOverlayView:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    [NSTimer scheduledTimerWithTimeInterval:1.8f target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
}

//取消button方法
- (void)dismissOverlayView:(id)sender{
    [self dismissModalViewControllerAnimated: YES];
}

-(void)lineAnimation{
    [UIView animateWithDuration:1.4f animations:^{
        _line.center=CGPointMake(_scanCenter.x, _scanRect.origin.y+_scanRect.size.height-5);
    } completion:^(BOOL finished) {
        _line.center=CGPointMake(_scanCenter.x, _scanRect.origin.y+5);
    }];
}
#pragma mark - 读取二维码
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)startReading {
    _isReading = YES;
    NSError *error;
    // 1. 摄像头设备
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 2. 设置输入
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    // 因为模拟器是没有摄像头的，因此在此最好做一个判断
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }

    // 3. 设置输出(Metadata元数据)
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureMetadataOutput setRectOfInterest:CGRectMake(_scanRect.origin.x/[UIScreen mainScreen].bounds.size.width, _scanRect.origin.y/[UIScreen mainScreen].bounds.size.height, _scanRect.size.width/[UIScreen mainScreen].bounds.size.width, _scanRect.size.height/[UIScreen mainScreen].bounds.size.height) ];
    
    // 3.1 设置输出的代理
    // 说明：使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    // 4. 拍摄会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 添加session的输入和输出
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    [_captureSession addOutput:captureMetadataOutput];
    
    // 4.1 设置输出的格式
    // 提示：一定要先设置会话的输出为output之后，再指定输出的元数据类型！
    if (self.qrcodeFlag)
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    else
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
    
    // 5. 设置预览图层（用来让用户能够看到扫描情况）
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
     // 5.1 设置preview图层的属性
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    // 5.2 设置preview图层的大小
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
     // 5.3 将图层添加到视图的图层
    [self.view.layer insertSublayer:_videoPreviewLayer atIndex:0];

    // 6. 启动会话
    [_captureSession startRunning];
    
    return YES;
}


-(void)stopReading{
    // 1. 如果扫描完成，停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
    _isReading=false;
    // 2. 删除预览图层
    [_videoPreviewLayer removeFromSuperlayer];
}
#pragma mark - 输出代理方法
// 此方法是在识别到QRCode，并且完成转换
// 如果QRCode的内容越大，转换需要的时间就越长
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"aljsdlfjalkjdsfljalskdjflkasdnx,cnv,xcnvm,xnv,xncv,mnxm,nv,mxnv");
    // 会频繁的扫描，调用代理方法
     if (!_isReading) return;
    
    
    // 3. 设置界面显示扫描结果
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSLog(metadataObj.stringValue);
        [self stopReading];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(tkQRScan:FinishedWithString:)]) {
            [self.delegate tkQRScan:self FinishedWithString:[NSString stringWithString:metadataObj.stringValue]];
        }
        //Do Something....
    } 
}



@end
