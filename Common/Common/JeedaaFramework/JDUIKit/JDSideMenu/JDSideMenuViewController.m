//
//  JDLeftMenuViewController.m
//  qinyuan
//
//  Created by 田凯 on 15/3/11.
//  Copyright (c) 2015年 田凯. All rights reserved.
//

#import "JDSideMenuViewController.h"

@interface JDSideMenuViewController (){
    CGPoint _mainViewCenter;
    CGPoint _menuViewCenter;
    CGFloat _showAlpha;
    CGFloat _hideAlpha;
    UIImageView *_bgView;
    JDSideMenuView *_LeftView;
    JDSideMenuView *_RightView;
    UIView *_maskView;
    UIView *_backMaskView;
    UIView *_MainView;
    BOOL _isShowed;
    UIDeviceOrientation _orientation;
}

@end

@implementation JDSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _isShowed=false;
    _showAlpha=0.0f;
    _hideAlpha=0.9f;
    _orientation=[UIDevice currentDevice].orientation;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrame:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self buildInterface:self.view.bounds.size];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buildInterface:(CGSize)size{
    if (_MainView) {
        return;
    }
    if(_bgView){
        UIView * maskView=[[UIView alloc] initWithFrame:self.view.bounds];
        maskView.backgroundColor=[UIColor blackColor];
        maskView.alpha=0.2f;
        [self.view addSubview:maskView];
        maskView.translatesAutoresizingMaskIntoConstraints=false;
        [self.view addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:maskView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]
                                    ,
                                    [NSLayoutConstraint constraintWithItem:maskView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]
                                    ,[NSLayoutConstraint constraintWithItem:maskView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                                    [NSLayoutConstraint constraintWithItem:maskView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]
                                    ]];
        _backMaskView=maskView;
        UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerHandler:)];
        [panGesture setMaximumNumberOfTouches:1];
        [panGesture setMinimumNumberOfTouches:1];
        [maskView addGestureRecognizer:panGesture];
    }
    
    if (self.leftMenuController) {
        _LeftView = [[JDSideMenuView alloc] initWithFrame:CGRectMake(-size.width/2.0, 0, size.width/5.0*4, size.height)];
        UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerHandler:)];
        [panGesture setMaximumNumberOfTouches:1];
        [panGesture setMinimumNumberOfTouches:1];
        [_LeftView addGestureRecognizer:panGesture];
        [self.view addSubview:_LeftView];

        [_LeftView setContentView: self.leftMenuController.view];
        [self addChildViewController:self.leftMenuController];
    }
    _maskView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _maskView.backgroundColor=[UIColor blackColor];
    _maskView.alpha=0.0f;
    _maskView.userInteractionEnabled=false;
    [self.view addSubview:_maskView];

    
    if (self.mainController) {
        UIViewController *vc=self.mainController;
        UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerHandler:)];
        [panGesture setMaximumNumberOfTouches:1];
        [panGesture setMinimumNumberOfTouches:1];
        [vc.view addGestureRecognizer:panGesture];
        _MainView=vc.view;
        [self.view addSubview: vc.view];
        [self addChildViewController:vc];
    }
     
    
}
-(UIImageView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView=[[UIImageView alloc] init];
    [self.view insertSubview:_bgView atIndex:0];
    _bgView.contentMode=UIViewContentModeScaleAspectFill;
    [_bgView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]
                                ,
                                [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]
                                ,[NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]
                                ]];
    
    return _bgView;
}
-(void)setBackgroundImage:(UIImage *)image{
    [[self bgView] setImage: image];
}
-(void)changeFrame:(NSNotification *)notification{
    UIDeviceOrientation orientation=[[UIDevice currentDevice] orientation];
    if ((orientation==UIDeviceOrientationFaceDown)|(orientation==UIDeviceOrientationFaceUp)) {
        return;
    }
    if(orientation==_orientation){
        return;
    }
    CGSize size = [[UIScreen mainScreen] bounds].size;
    if (self.leftMenuController) {
        switch (orientation) {
            case UIDeviceOrientationLandscapeLeft:
            case UIDeviceOrientationLandscapeRight:
                size=CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
                break;
            default:
                size=CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
                break;
        }
        DLog(@"<Common> JDSideMenuView size ( width:%f,height:%f )",size.width,size.height);
        [_LeftView setFrame: CGRectMake(-size.width/2.0, 0, size.width/5.0*4, size.height)];
    }
    [self hidenMenu];
    _orientation=orientation;
}
#pragma mark - pan gesture handler
-(void)panGestureRecognizerHandler:(UIPanGestureRecognizer *)sender{
    CGPoint translation = [sender translationInView:self.view];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            if(!_isShowed){
                if (self.leftMenuController) {
                    [self.leftMenuController viewWillAppear:false];
                }
                _LeftView.center=CGPointMake(-CGRectGetWidth(self.view.bounds)/2.0+CGRectGetWidth(_LeftView.bounds)/2.0, CGRectGetMidY(_LeftView.bounds));
                _MainView.center=CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
                _maskView.alpha=_hideAlpha;
            }else{
                if (self.leftMenuController) {
                    [self.leftMenuController viewWillDisappear:false];
                }
            }
            _mainViewCenter=_MainView.center;
            _menuViewCenter=_LeftView.center;
            _maskView.frame=self.view.bounds;
            break;
        case UIGestureRecognizerStateChanged:
                if (_isShowed) {
                    if(_MainView.center.x<=CGRectGetMidX(self.view.bounds) ){
                        return;
                    }
                    _MainView.center=CGPointMake(_mainViewCenter.x+translation.x, _mainViewCenter.y);
                    CGFloat scale=-translation.x/CGRectGetWidth(self.view.bounds)/4.0*3;
                    _MainView.transform=CGAffineTransformMakeScale(0.75+scale/2.0,0.75+scale/2.0);
                    _LeftView.center=CGPointMake(_menuViewCenter.x+translation.x/4.0*3, _menuViewCenter.y);
                    _LeftView.transform=CGAffineTransformMakeScale(1-scale,1-scale);
                    _maskView.alpha=_showAlpha+scale/5.0*8;
                }else{
                    if (_LeftView.center.x>=CGRectGetMidX(_LeftView.bounds) | translation.x<0) {
                        return;
                    }
                    _MainView.center=CGPointMake(_mainViewCenter.x+translation.x, _mainViewCenter.y);
                    CGFloat scale=translation.x/CGRectGetWidth(self.view.bounds)/4.0*3;
                    _MainView.transform=CGAffineTransformMakeScale(1-scale/2.0,1-scale/2.0);
                    _LeftView.center=CGPointMake(_menuViewCenter.x+translation.x/4.0*3, _menuViewCenter.y);
                    _LeftView.transform=CGAffineTransformMakeScale(0.5+scale,0.5+ scale);
                    _maskView.alpha=_hideAlpha-scale/5.0*8;
                    
                }
            break;
        case UIGestureRecognizerStateEnded:
            if (_isShowed) {
                if (_LeftView.center.x<=CGRectGetMidX(_LeftView.bounds)/4.0*3.0) {
                    [self hidenMenu];
                }else{
                    [self showMenu];
                }
                
            }else {
                if ( _LeftView.center.x>=CGRectGetMidX(_LeftView.bounds)/4.0*1.0){
                    [self showMenu];
                }else{
                    [self hidenMenu];
                }
            }
            break;
        default:
            break;
    }
}
-(void)showMenu{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    _LeftView.transform=CGAffineTransformIdentity;
    _LeftView.center=CGPointMake(CGRectGetMidX(_LeftView.bounds), _menuViewCenter.y);
    _MainView.transform=CGAffineTransformMakeScale(0.75,0.75);
    _MainView.center=CGPointMake(CGRectGetMidX(self.view.bounds)+(CGRectGetMidX(_LeftView.bounds)-(-CGRectGetWidth(self.view.bounds)/2.0+CGRectGetWidth(_LeftView.bounds)/2.0))/3.0*4,CGRectGetMidY(self.view.bounds));
    _maskView.alpha=_showAlpha;
    _isShowed=true;
    [UIView commitAnimations];
    if (self.leftMenuController) {
        [self.leftMenuController viewDidAppear:false];
    }
}
-(void)hidenMenu{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    _LeftView.transform=CGAffineTransformMakeScale(0.5, 0.5);
    _LeftView.center=CGPointMake(-CGRectGetWidth(self.view.bounds)/2.0+CGRectGetWidth(_LeftView.bounds)/2.0, CGRectGetMidY(_LeftView.bounds));
    _MainView.transform=CGAffineTransformIdentity;
    _MainView.center=CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    _maskView.alpha=_hideAlpha;
    _isShowed=false;
    [UIView commitAnimations];
    if (self.leftMenuController) {
        [self.leftMenuController viewDidDisappear:false];
    }
}

#pragma  mark - rotate orientation 
-(BOOL)shouldAutorotate{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    DLog(@" %@ supportedInterfaceOrientations",NSStringFromClass([self class]));
    return UIInterfaceOrientationMaskAll;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

@end
