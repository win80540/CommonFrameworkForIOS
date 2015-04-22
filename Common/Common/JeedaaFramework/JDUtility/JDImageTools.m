//
//  JDImageTools.m
//  wetoolsSAAS
//
//  Created by 田凯 on 14-6-5.
//  Copyright (c) 2014年 田凯. All rights reserved.
//

#import "JDImageTools.h"
#import "HttpHelp.h"
@implementation JDImageTools
static CGRect oldframe;

-(id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        [self buildInterface];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self buildInterface];
    }
    return self;
}
-(void)buildInterface{
    self.scale=1.0f;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(deviceOrientationDidChange:)
     
                                                 name:UIDeviceOrientationDidChangeNotification
     
                                               object:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

}
-(void)dealloc{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
//图片预览
+(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    JDImageTools *backgroundView=[[JDImageTools alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    backgroundView.imageView=[[UIImageView alloc]initWithFrame:oldframe];
    backgroundView.imageView.image=image;
    backgroundView.imageView.tag=1;
    [backgroundView addSubview:backgroundView.imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}
+(void)showImage:(UIImage *)image FromView:(UIView *)view
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    JDImageTools *backgroundView=[[JDImageTools alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    oldframe=[view convertRect:view.bounds toView:window];
    backgroundView.imageView=[[UIImageView alloc]initWithFrame:oldframe];
    backgroundView.imageView.image=image;
    backgroundView.imageView.tag=1;
    [backgroundView addSubview:backgroundView.imageView];
    [window addSubview:backgroundView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}
+(void)showThumbImage:(UIImage *)image WithOriginalImageUrl:(NSString *)url FromView:(UIView *)view
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    JDImageTools *backgroundView=[[JDImageTools alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    oldframe=[view convertRect:view.bounds toView:window];
    backgroundView.imageView=[[UIImageView alloc]initWithFrame:oldframe];
    backgroundView.imageView.image=image;
    backgroundView.imageView.tag=1;
    backgroundView.imageView.userInteractionEnabled=true;
    [backgroundView addSubview:backgroundView.imageView];
    [window addSubview:backgroundView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:backgroundView action:@selector(onlyPanGestureHandler:)];
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc] initWithTarget:backgroundView action:@selector(pinchHandler:)];
    UIRotationGestureRecognizer *rotationGesture=[[UIRotationGestureRecognizer alloc] initWithTarget:backgroundView action:@selector(rotationHandler:)];
    
    [backgroundView.imageView addGestureRecognizer:rotationGesture];
    [backgroundView.imageView addGestureRecognizer:pinchGesture];
    [backgroundView.imageView addGestureRecognizer:panGesture];

    
   
    
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        if (url) {
            //加载原图
            UIActivityIndicatorView *activeIndicator= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            UIView *maskView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            maskView.backgroundColor=[UIColor blackColor];
            maskView.alpha=0.5;
            [maskView addSubview:activeIndicator];
            [activeIndicator setCenter:CGPointMake(maskView.bounds.size.width/2.0, maskView.bounds.size.height/2.0)];
            [activeIndicator startAnimating];
            [backgroundView addSubview:maskView];
            [[HttpHelp sharedHTTPHelp] loadImage:url Success:^(UIImage *originalImage) {
                backgroundView.imageView.image=originalImage;
                [maskView removeFromSuperview];
            } Error:^(NSError *error) {
                [maskView removeFromSuperview];
            }];
        }
    
        
    }];
}
+(void)showImage:(NSArray *)imageArray currentIndex:(NSInteger)index FromView:(UIView *)view
{
    UIImage *image= [imageArray objectAtIndex:index];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    JDImageTools *backgroundView=[[JDImageTools alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    oldframe=[view convertRect:view.bounds toView:window];
    backgroundView.imageView=[[UIImageView alloc]initWithFrame:oldframe];
    backgroundView.imageView.image=image;
    backgroundView.imageView.tag=index;
    backgroundView.imageView.userInteractionEnabled=YES;
    [backgroundView addSubview:backgroundView.imageView];
    [window addSubview:backgroundView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    backgroundView.imageViewsDic=[[NSMutableDictionary alloc] initWithObjects:@[backgroundView.imageView] forKeys:@[[NSString stringWithFormat:@"%d",(int)index]]];
    backgroundView.imageArray=[NSMutableArray arrayWithArray:imageArray] ;
    backgroundView.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-20)/2.0, [UIScreen mainScreen].bounds.size.height-40, 20, 20)];
    backgroundView.pageControl.numberOfPages=imageArray.count;
    backgroundView.pageControl.currentPage=index;
    [backgroundView addSubview:backgroundView.pageControl];
    backgroundView.pageControl=backgroundView.pageControl;
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:backgroundView action:@selector(panGestureHandler:)];
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc] initWithTarget:backgroundView action:@selector(pinchHandler:)];
    UIRotationGestureRecognizer *rotationGesture=[[UIRotationGestureRecognizer alloc] initWithTarget:backgroundView action:@selector(rotationHandler:)];
    
    [backgroundView.imageView addGestureRecognizer:rotationGesture];
    [backgroundView.imageView addGestureRecognizer:pinchGesture];
    [backgroundView.imageView addGestureRecognizer:panGesture];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:nil];
}
//方向变化
-(void)deviceOrientationDidChange:(NSObject*)sender{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIDevice* device = [sender valueForKey:@"object"];
    NSLog(@"%d",(int)device.orientation);
    self.currentOrientation=device.orientation;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];

    switch (device.orientation) {
        case UIDeviceOrientationLandscapeRight:
        {
            self.transform=CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI_2);
            self.frame=CGRectMake(0, 0, size.width, size.height);
            
            if (self.imageViewsDic) {
                UIImageView *imageView = [self.imageViewsDic objectForKey:[NSString stringWithFormat:@"%d",(int)self.pageControl.currentPage]];
                UIImage *image = [self.imageArray objectAtIndex:self.pageControl.currentPage];
                CGSize imgSize=[JDImageTools calculateImage:image AdaptiveInSize:CGSizeMake(size.height, size.width)];
                for (NSString *key in self.imageViewsDic.allKeys){
                    if([key compare:[NSString stringWithFormat:@"%d",(int)self.pageControl.currentPage]]==NSOrderedSame)
                        continue;
                    UIImageView *tempView = [self.imageViewsDic objectForKey:key];
                    [tempView removeFromSuperview];
                    [self.imageViewsDic removeObjectForKey:key];
                }
                imageView.bounds=CGRectMake(0, 0, imgSize.width, imgSize.height);
                imageView.center=CGPointMake(size.height/2.0,size.width/2.0);
                self.pageControl.frame=CGRectMake(20, size.width-20, size.height-40, 20);
            }else{
                CGSize imgSize = [JDImageTools calculateImage:self.imageView.image AdaptiveInSize:CGSizeMake(size.height, size.width)];
                self.imageView.bounds=CGRectMake(0, 0, imgSize.width, imgSize.height);
                self.imageView.center=CGPointMake(size.height/2.0,size.width/2.0);
            }
            

        }break;
        case UIDeviceOrientationLandscapeLeft:
        {
            self.transform=CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
            self.frame=CGRectMake(0, 0, size.width, size.height);
           
            if (self.imageViewsDic) {
                UIImageView *imageView = [self.imageViewsDic objectForKey:[NSString stringWithFormat:@"%d",(int)self.pageControl.currentPage]];
                UIImage *image = [self.imageArray objectAtIndex:self.pageControl.currentPage];
                CGSize imgSize=[JDImageTools calculateImage:image AdaptiveInSize:CGSizeMake(size.height, size.width)];
                for (NSString *key in self.imageViewsDic.allKeys){
                    if([key compare:[NSString stringWithFormat:@"%d",(int)self.pageControl.currentPage]]==NSOrderedSame)
                        continue;
                    UIImageView *tempView = [self.imageViewsDic objectForKey:key];
                    [tempView removeFromSuperview];
                    [self.imageViewsDic removeObjectForKey:key];
                }
                imageView.bounds=CGRectMake(0, 0, imgSize.width, imgSize.height);
                imageView.center=CGPointMake(size.height/2.0,size.width/2.0);
                self.pageControl.frame=CGRectMake(20, size.width-20, size.height-40, 20);
            }else{
                 CGSize imgSize = [JDImageTools calculateImage:self.imageView.image AdaptiveInSize:CGSizeMake(size.height, size.width)];
                self.imageView.bounds=CGRectMake(0, 0, imgSize.width, imgSize.height);
                self.imageView.center=CGPointMake(size.height/2.0,size.width/2.0);
            }
        }
            break;
        default:
        {
            self.transform=CGAffineTransformIdentity;
            self.frame=CGRectMake(0, 0, size.width, size.height);
            
            if (self.imageViewsDic) {
                
                UIImageView *imageView = [self.imageViewsDic objectForKey:[NSString stringWithFormat:@"%d",(int)self.pageControl.currentPage]];
                UIImage *image = [self.imageArray objectAtIndex:self.pageControl.currentPage];
                CGSize imgSize=[JDImageTools calculateImage:image AdaptiveInSize:size];
                for (NSString *key in self.imageViewsDic.allKeys){
                    if([key compare:[NSString stringWithFormat:@"%d",(int)self.pageControl.currentPage]]==NSOrderedSame)
                        continue;
                    UIImageView *tempView = [self.imageViewsDic objectForKey:key];
                    [tempView removeFromSuperview];
                    [self.imageViewsDic removeObjectForKey:key];
                }
                imageView.bounds=CGRectMake(0, 0, imgSize.width, imgSize.height);
                imageView.center=CGPointMake(size.width/2.0,size.height/2.0);
                self.pageControl.frame=CGRectMake(20, size.height-20, size.width-40, 20);
                
            }else{
                CGSize imgSize = [JDImageTools calculateImage:self.imageView.image AdaptiveInSize:CGSizeMake(size.width,size.height)];
                self.imageView.bounds=CGRectMake(0, 0, imgSize.width, imgSize.height);
                self.imageView.center=CGPointMake(size.width/2.0,size.height/2.0);            }

        }
            break;
    }
    
    [UIView commitAnimations];
    
}

//翻页完成时显示的view
-(void)layoutImageView:(UIImageView *)imageView{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIImage *image= [self.imageArray objectAtIndex:imageView.tag];
    switch (self.currentOrientation) {
        case UIDeviceOrientationLandscapeRight:
        {
            self.transform=CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI_2);
            self.frame=CGRectMake(0, 0, size.width, size.height);
            CGSize imgSize = [JDImageTools calculateImage:image AdaptiveInSize:CGSizeMake(size.height, size.width)];
            imageView.bounds=CGRectMake(0, 0, imgSize.width, imgSize.height);
            imageView.center=CGPointMake(size.height/2.0,size.width/2.0);
            
        }break;
        case UIDeviceOrientationLandscapeLeft:
        {
            self.transform=CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
            self.frame=CGRectMake(0, 0, size.width, size.height);
            CGSize imgSize = [JDImageTools calculateImage:image AdaptiveInSize:CGSizeMake(size.height, size.width)];
            imageView.bounds=CGRectMake(0, 0, imgSize.width, imgSize.height);
            imageView.center=CGPointMake(size.height/2.0,size.width/2.0);
        }
            break;
        default:
        {
            self.transform=CGAffineTransformIdentity;
            self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            CGSize imgSize = [JDImageTools calculateImage:image AdaptiveInSize:CGSizeMake(size.width,size.height)];
            imageView.bounds=CGRectMake(0, 0, imgSize.width, imgSize.height);
            imageView.center=CGPointMake(size.width/2.0,size.height/2.0);
        }
            break;
    }

}

//翻页动画时上下页
-(void)layoutImageView:(UIImageView *)imageView CurrentView:(UIView *)view IsNext:(BOOL)isNext{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIImage *image= [self.imageArray objectAtIndex:imageView.tag];
    CGSize imgSize;
    switch (self.currentOrientation) {
        case UIDeviceOrientationLandscapeRight:
        case UIDeviceOrientationLandscapeLeft:
            size=CGSizeMake(size.height, size.width);
            imgSize = [JDImageTools calculateImage:image AdaptiveInSize:CGSizeMake(size.height, size.width)];
            break;
        default:
            imgSize = [JDImageTools calculateImage:image AdaptiveInSize:CGSizeMake(size.width,size.height)];
            break;
            break;
    }
    if (isNext) {
        imageView.frame=CGRectMake(view.frame.origin.x+view.frame.size.width,(size.height-imgSize.height)/2.0, imgSize.width, imgSize.height);
    }else{
        imageView.frame=CGRectMake(view.frame.origin.x-size.width,(size.height-imgSize.height)/2.0, imgSize.width, imgSize.height);
    }

}
//翻页完成时上下页 定位并还原
-(void)layoutImageView:(UIImageView *)imageView IsNext:(BOOL)isNext
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGSize imgSize=imageView.image.size;
    UIImage *image= [self.imageArray objectAtIndex:imageView.tag];
    switch (self.currentOrientation) {
        case UIDeviceOrientationLandscapeRight:
        case UIDeviceOrientationLandscapeLeft:
            size=CGSizeMake(size.height, size.width);
            imgSize = [JDImageTools calculateImage:image AdaptiveInSize:CGSizeMake(size.height, size.width)];
            break;
        default:
            imgSize = [JDImageTools calculateImage:image AdaptiveInSize:CGSizeMake(size.width,size.height)];
            break;
    }
    if (isNext) {
        imageView.frame=CGRectMake(0,0, imgSize.width, imgSize.height);
        imageView.center=CGPointMake(size.width+imgSize.width/2.0, size.height/2.0);
    }else{
        imageView.frame=CGRectMake(0,0, imgSize.width, imgSize.height);
        imageView.center=CGPointMake(imgSize.width/2.0-size.width, size.height/2.0);
    }

}



//新建ImageView
-(UIImageView *)createImageView{
    UIImageView *imageView=[[UIImageView alloc] init];
    imageView.userInteractionEnabled=YES;
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureHandler:)];
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandler:)];
    UIRotationGestureRecognizer *rotationGesture=[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationHandler:)];
    [imageView addGestureRecognizer:rotationGesture];
    [imageView addGestureRecognizer:pinchGesture];
    [imageView addGestureRecognizer:panGesture];
    [self insertSubview:imageView belowSubview:self.pageControl];
    return imageView;
}


//重用ImageView
-(UIImageView *)dequeueReusableImageView:(NSInteger )index{
   UIImageView* imageView= [self.imageViewsDic objectForKey:[NSString stringWithFormat:@"%d",(int)index+2]];
    if (nil==imageView) {
        imageView=[self.imageViewsDic objectForKey:[NSString stringWithFormat:@"%d",(int)index-2]];
        if (nil!=imageView) {
            [self.imageViewsDic removeObjectForKey:[NSString stringWithFormat:@"%d",(int)index-2]];
        }
    }else{
        [self.imageViewsDic removeObjectForKey:[NSString stringWithFormat:@"%d",(int)index+2]];
    }
    return imageView;
}

+(CGSize)calculateImage:(UIImage *)image MaxSizeInSize:(CGSize)size IsAbsoluteSize:(BOOL)isAbsolute{
    CGSize resultSize = image.size;
    if (!isAbsolute) {
        CGFloat scale=[UIScreen mainScreen].scale;
        resultSize = CGSizeMake(resultSize.width/scale, resultSize.height/scale);
    }
    CGFloat rate = 1.0f;
    rate = MIN(size.width/resultSize.width, size.height/resultSize.height);
    if (rate>1.0f) {
        rate=1;
    }
    resultSize = CGSizeMake(resultSize.width*rate, resultSize.height*rate);
    return resultSize;
}
+(CGSize)calculateImage:(UIImage *)image MaxSizeInSize:(CGSize)size MinSize:(CGSize)minSize  IsAbsoluteSize:(BOOL)isAbsolute{
    CGSize resultSize = image.size;
    if (!isAbsolute) {
        CGFloat scale=[UIScreen mainScreen].scale;
        resultSize = CGSizeMake(resultSize.width/scale, resultSize.height/scale);
    }
    CGFloat rate = 1.0f;
    rate = MIN(size.width/resultSize.width, size.height/resultSize.height);
    if (rate>1.0f) {
        rate=MIN(minSize.width/resultSize.width, minSize.height/resultSize.height);
    }
    resultSize = CGSizeMake(resultSize.width*rate, resultSize.height*rate);
    return resultSize;
}
+(CGSize)calculateImage:(UIImage *)image AdaptiveInSize:(CGSize)size {
    CGSize resultSize = image.size;
    CGFloat rate = 1.0f;
    rate = MIN(size.width/resultSize.width, size.height/resultSize.height);
    resultSize = CGSizeMake(resultSize.width*rate, resultSize.height*rate);
    return resultSize;
}
+(CGSize)calculateImage:(UIImage *)image AdaptiveInSize:(CGSize)size MinSize:(CGSize)minSize{
    CGSize resultSize = image.size;
    CGFloat rate = 1.0f;
    rate = MIN(size.width/resultSize.width, size.height/resultSize.height);
    resultSize = CGSizeMake(resultSize.width*rate, resultSize.height*rate);
    rate = MIN(minSize.width/resultSize.width, minSize.height/resultSize.height);
    if (rate>1) {
        resultSize = CGSizeMake(resultSize.width*rate, resultSize.height*rate);
    }
    return resultSize;
}
//拖动+翻页
-(void)onlyPanGestureHandler:(UIPanGestureRecognizer *)sender{
    CGPoint translation = [sender translationInView:self];
    __block CGRect rect=sender.view.frame;
    CGSize screenSize;
    switch (self.currentOrientation) {
        case UIDeviceOrientationLandscapeRight:
        case UIDeviceOrientationLandscapeLeft:
            screenSize=CGSizeMake( [UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width);
            break;
        default:
            screenSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            break;
    }
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
            
                rect.origin.x+=translation.x;
                rect.origin.y+=translation.y;
                sender.view.frame=rect;
            
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {

                    if (rect.size.height>screenSize.height) {
                        if(rect.size.height+rect.origin.y<screenSize.height){
                            CGFloat y= rect.origin.x+rect.size.width-screenSize.height;
                            rect.origin.y+=y;
                        }else if(rect.origin.y>0){
                            rect.origin.y=0;
                        }
                    }
                    sender.view.frame=rect;
            
        }
         
        
            break;
        default:
            break;
    }
    
    [sender setTranslation:CGPointZero inView:self];
    
}
//拖动+翻页
-(void)panGestureHandler:(UIPanGestureRecognizer *)sender{
    CGPoint translation = [sender translationInView:self];
    __block CGRect rect=sender.view.frame;
    CGSize screenSize;
    switch (self.currentOrientation) {
        case UIDeviceOrientationLandscapeRight:
        case UIDeviceOrientationLandscapeLeft:
            screenSize=CGSizeMake( [UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width);
            break;
        default:
            screenSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            break;
    }
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
            //transition
            //DLog(@"UIGestureRecognizerStateChanged");
            if (rect.origin.x>0&&translation.x>0) {
                //向前翻页
                if (sender.view.tag>=1) {
                    //有上一页
                    DLog(@"image index:%d",(int)sender.view.tag);
                    UIImageView *imageView=[self.imageViewsDic objectForKey:[NSString stringWithFormat:@"%d",(int)sender.view.tag-1]];
                    if (nil==imageView) {
                        UIImage* image= [self.imageArray objectAtIndex:sender.view.tag-1];
                        imageView=[self dequeueReusableImageView:sender.view.tag-1];
                        if (nil==imageView) {
                            imageView=[self createImageView];
                        }
                        imageView.image=image;
                        [self.imageViewsDic setObject:imageView forKey:[NSString stringWithFormat:@"%d",(int)sender.view.tag-1]];
                        imageView.tag=sender.view.tag-1;
                        [self layoutImageView:imageView CurrentView:sender.view IsNext:NO];
                    }
                    CGRect preRect=imageView.frame;
                    preRect.origin.x+=translation.x;
                    imageView.frame=preRect;
                    rect.origin.x+=translation.x;
                    sender.view.frame=rect;
                }else{
                    //无上一页
                    rect.origin.x+=translation.x;
                    rect.origin.y+=translation.y;
                    sender.view.frame=rect;
                }
            }else if (rect.origin.x+rect.size.width<screenSize.width&&translation.x<0) {
                //向后翻页
                if (sender.view.tag+1<self.imageArray.count) {
                    //有下一页
                    DLog(@"image index:%d",(int)sender.view.tag);
                    UIImageView *imageView=[self.imageViewsDic objectForKey:[NSString stringWithFormat:@"%d",(int)sender.view.tag+1]];
                    if (nil==imageView) {
                        UIImage* image= [self.imageArray objectAtIndex:sender.view.tag+1];
                        imageView=[self dequeueReusableImageView:sender.view.tag+1];
                        if (nil==imageView) {
                            imageView=[self createImageView];
                        }
                        imageView.image=image;
                        imageView.tag=sender.view.tag+1;
                        [self.imageViewsDic setObject:imageView forKey:[NSString stringWithFormat:@"%d",(int)sender.view.tag+1]];
                        [self layoutImageView:imageView CurrentView:sender.view IsNext:YES];
                    }
                    CGRect preRect=imageView.frame;
                    preRect.origin.x+=translation.x;
                    imageView.frame=preRect;
                    rect.origin.x+=translation.x;
                    sender.view.frame=rect;
                }else{
                    rect.origin.x+=translation.x;
                    rect.origin.y+=translation.y;
                    sender.view.frame=rect;
                }
            }else{
             rect.origin.x+=translation.x;
             rect.origin.y+=translation.y;
             sender.view.frame=rect;
            }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            
                [UIView animateWithDuration:.3f animations:^{
                    UIImageView *preView=[self.imageViewsDic objectForKey:[NSString stringWithFormat:@"%d",(int)sender.view.tag-1]];
                    UIImageView *folView=[self.imageViewsDic objectForKey:[NSString stringWithFormat:@"%d",(int)sender.view.tag+1]];
                    if (nil!=preView&&rect.origin.x>[UIScreen mainScreen].bounds.size.width/2.0) {
                        //向前翻页
                        self.pageControl.currentPage=sender.view.tag-1;
                        [self layoutImageView:preView];
                        //preView.hidden=YES;
                        //隐藏并还原Transform当前页
                        [self layoutImageView:(UIImageView *)sender.view IsNext:YES];
                        self.scale=1.0f;
                        return;
                    } else  if(nil!=folView & rect.origin.x+rect.size.width<screenSize.width/2.0){
                        //向后翻页
                        self.pageControl.currentPage=sender.view.tag+1;
                        [self layoutImageView:folView];
                        //隐藏并还原Transform当前页
                        [self layoutImageView:(UIImageView *)sender.view IsNext:NO];
                        self.scale=1.0f;
                        return;
                    } else {
                        if(rect.origin.x+rect.size.width<screenSize.width)
                        {
                            CGFloat x=screenSize.width- (rect.origin.x+rect.size.width);
                            rect.origin.x+=x;
                            //未向后翻页还原
                            if(nil!=folView){
                                [self layoutImageView:folView IsNext:YES];
                            }
                        }else  if(rect.origin.x>0){
                            //未向前翻页还原
                            rect.origin.x=0;
                            if (nil!=preView) {
                                [self layoutImageView:preView IsNext:NO];
                            }
                        }
                        if (rect.size.height>screenSize.height) {
                            if(rect.size.height+rect.origin.y<screenSize.height){
                                CGFloat y= rect.origin.x+rect.size.width-screenSize.height;
                                rect.origin.y+=y;
                            }else if(rect.origin.y>0){
                                rect.origin.y=0;
                            }
                        }
                        sender.view.frame=rect;
                        //[self layoutImageView:(UIImageView *)sender.view];
                    }
                }];
        }
            break;
        default:
            break;
    }

   [sender setTranslation:CGPointZero inView:self];

}

//旋转
-(void)rotationHandler:(UIRotationGestureRecognizer*)sender{
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
        {
            sender.view.transform=CGAffineTransformRotate(sender.view.transform, sender.rotation);
            DLog(@"%lf",sender.rotation);
            [self printTransform:sender.view.transform];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            //获取旋转角
            CGFloat newRotate = acosf(sender.view.transform.a);
            if (sender.view.transform.b< 0) {
                //逆时针旋转
                newRotate= 2*M_PI-newRotate;
                DLog(@"+++++++++ degree : %f", newRotate/M_PI*180);
                if (newRotate>=M_PI/2+M_PI) {
                    CGFloat angleD=2*M_PI-newRotate;
                    CGFloat angleD2=newRotate-M_PI/2-M_PI;
                    if (angleD<angleD2) {
                        sender.view.transform=CGAffineTransformRotate(sender.view.transform, angleD);
                    }else{
                        sender.view.transform=CGAffineTransformRotate(sender.view.transform, -angleD2);
                    }
                }else{
                    CGFloat angleD=M_PI/2+M_PI-newRotate;
                    CGFloat angleD2=newRotate-M_PI;
                    if (angleD<angleD2) {
                        sender.view.transform=CGAffineTransformRotate(sender.view.transform, angleD);
                    }else{
                        sender.view.transform=CGAffineTransformRotate(sender.view.transform, -angleD2);
                    }
                }

            }else{
                //顺时针旋转
                 DLog(@"+++++++++ degree : %f", newRotate/M_PI*180);
                if (newRotate>=M_PI/2) {
                    CGFloat angleD=M_PI-newRotate;
                    CGFloat angleD2=newRotate-M_PI/2;
                    if (angleD<angleD2) {
                        sender.view.transform=CGAffineTransformRotate(sender.view.transform, angleD);
                    }else{
                        sender.view.transform=CGAffineTransformRotate(sender.view.transform, -angleD2);
                    }
                    
                }else{
                    CGFloat angleD=M_PI/2-newRotate;
                    if (angleD>newRotate) {
                        sender.view.transform=CGAffineTransformRotate(sender.view.transform, -newRotate);
                    }else{
                        sender.view.transform=CGAffineTransformRotate(sender.view.transform, angleD);
                    }
                }
                
            }
            
            
            
        }break;
            
        default:
            break;
    }
    sender.rotation=0;
}

//缩放
-(void)pinchHandler:(UIPinchGestureRecognizer *)sender{
    CGFloat scale=sender.scale;
    CGAffineTransform transform = CGAffineTransformScale(sender.view.transform, scale, scale);
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
        {
            //transition
            //DLog(@"UIGestureRecognizerStateChanged");
            self.scale*=sender.scale;
            if (self.scale>0.8&&self.scale<3.2) {
                sender.view.transform=transform;
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            if(self.scale>3)
            {
                CAKeyframeAnimation *scaleAn=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                scaleAn.keyTimes=@[[NSNumber numberWithFloat:.00f],[NSNumber numberWithFloat:.20f],[NSNumber numberWithFloat:.30f]];
                scaleAn.duration=.3f;
                scaleAn.values=@[[NSNumber numberWithFloat:transform.a],[NSNumber numberWithFloat:2.90f],[NSNumber numberWithFloat:3.00f]];
                scaleAn.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                [sender.view.layer addAnimation:scaleAn forKey:@"scale"];
                sender.view.transform=CGAffineTransformScale(CGAffineTransformIdentity, 3.0, 3.0);
                self.scale=3.0;

            }else if(self.scale<1){
                CAKeyframeAnimation *scaleAn=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                scaleAn.keyTimes=@[[NSNumber numberWithFloat:.00f],[NSNumber numberWithFloat:.20f],[NSNumber numberWithFloat:.30f]];
                scaleAn.duration=.3f;
                scaleAn.values=@[[NSNumber numberWithFloat:transform.a],[NSNumber numberWithFloat:1.15f],[NSNumber numberWithFloat:1.00f]];
                scaleAn.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                [sender.view.layer addAnimation:scaleAn forKey:@"scale"];
                sender.view.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                self.scale=1.0;
            }
            
        }
            break;
        default:
            break;
    }
     sender.scale=1;
}
-(void)printTransform:(CGAffineTransform) transform{
    DLog(@"a:%f,b:%f,c:%f,d:%f,tx:%f,ty:%f",transform.a,transform.b,transform.c,transform.d,transform.tx,transform.ty);

}

//关闭预览
+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        
        
    }];
}

+ (UIImage *)resizeImage:(UIImage *)image Size:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *updatedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return updatedImg;
}
//裁剪图片;
+(UIImage *)clipImage:(UIImage *)image rect:(CGRect)rect{
    UIImage *srcimg=[image copy];
    rect.size.width=rect.size.width*2.0;
    rect.size.height=rect.size.height*2.0;
    CGFloat rate=srcimg.size.height/srcimg.size.width;
    CGFloat dRate=rect.size.height/rect.size.width;
    if (rate>=dRate) {
        CGRect newRect=CGRectMake(0, 0, rect.size.width, rate*rect.size.width);
        srcimg=[self resizeImage:srcimg Size:newRect];
    }else{
        CGRect newRect=CGRectMake(0, 0, rect.size.height/rate, rect.size.height);
        srcimg=[self resizeImage:srcimg Size:newRect];
    }
    CGRect clipRect=CGRectMake(0, 0, 0, 0);
    clipRect.origin.y= srcimg.size.height/2.0-rect.size.height/2.0;
    clipRect.origin.x=srcimg.size.width/2.0-rect.size.width/2.0;
    clipRect.size=rect.size;
    CGImageRef cgimage=CGImageCreateWithImageInRect(srcimg.CGImage, clipRect);
    UIImage *desimage= [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
    return desimage;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
//截取屏幕区域
+(UIImage *)snapshotRect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, [UIScreen mainScreen].scale);
    [[UIApplication sharedApplication].keyWindow drawViewHierarchyInRect:CGRectMake(0, 0, rect.size.width, rect.size.height) afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}
//制作纯色图片
+(UIImage *)image:(UIImage *)image FillColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//替换图片颜色
+ (UIImage*)replaceColor:(UIColor*)color ToColor:(UIColor *)toColor inImage:(UIImage*)image withTolerance:(float)tolerance
{
    CGImageRef imageRef = [image CGImage];
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bitmapByteCount = bytesPerRow * height;
    
    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));
    
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CGColorRef cgColor = [color CGColor];
    const CGFloat *components = CGColorGetComponents(cgColor);
    float r = components[0];
    float g = components[1];
    float b = components[2];
    float a = components[3]; // not needed
    
    r = r * 255.0;
    g = g * 255.0;
    b = b * 255.0;
    a = a * 255.0;
    
    components=CGColorGetComponents(toColor.CGColor);
    float tR=components[0];
    float tG=components[1];
    float tB=components[2];
    float tA=components[3];
    tR *=  255.0;
    tG *= 255.0;
    tB *= 255.0;
    tA *= 255.0;
    const float redRange[2] = {
        MAX(r - (tolerance / 2.0), 0.0),
        MIN(r + (tolerance / 2.0), 255.0)
    };
    
    const float greenRange[2] = {
        MAX(g - (tolerance / 2.0), 0.0),
        MIN(g + (tolerance / 2.0), 255.0)
    };
    
    const float blueRange[2] = {
        MAX(b - (tolerance / 2.0), 0.0),
        MIN(b + (tolerance / 2.0), 255.0)
    };
    
    int byteIndex = 0;
    
    while (byteIndex < bitmapByteCount) {
        unsigned char red   = rawData[byteIndex];
        unsigned char green = rawData[byteIndex + 1];
        unsigned char blue  = rawData[byteIndex + 2];
        
        if (((red >= redRange[0]) && (red <= redRange[1])) &&
            ((green >= greenRange[0]) && (green <= greenRange[1])) &&
            ((blue >= blueRange[0]) && (blue <= blueRange[1]))) {
            // make the pixel transparent
            //
            rawData[byteIndex] = tR;
            rawData[byteIndex + 1] = tG;
            rawData[byteIndex + 2] = tB;
            rawData[byteIndex + 3] = tA;
        }
        
        byteIndex += 4;
    }
    
    UIImage *result = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    
    CGContextRelease(context);
    free(rawData);
    
    return result;
}

//将颜色替换为透明
+(UIImage *)changeColorTo:(NSMutableArray*) array Transparent: (UIImage *)image
{
    CGImageRef rawImageRef=image.CGImage;
    
    //    const float colorMasking[6] = {222, 255, 222, 255, 222, 255};
    
    const CGFloat colorMasking[6] = {[[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue], [[array objectAtIndex:2] floatValue], [[array objectAtIndex:3] floatValue], [[array objectAtIndex:4] floatValue], [[array objectAtIndex:5] floatValue]};
    
    
    UIGraphicsBeginImageContext(image.size);
    CGImageRef maskedImageRef=CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    {
        //if in iphone
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, image.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    }
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), maskedImageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();
    return result;
}


@end
