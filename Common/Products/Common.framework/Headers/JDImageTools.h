//
//  JDImageTools.h
//  wetoolsSAAS
//
//  Created by 田凯 on 14-6-5.
//  Copyright (c) 2014年 田凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JDImageTools : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property(strong,atomic) UIScrollView *scrollView;
@property(strong,atomic) UIPageControl *pageControl;
@property(strong,atomic) NSMutableArray *imageArray;
@property(strong,atomic) NSMutableDictionary *imageViewsDic;
@property(strong,atomic) UIImageView *imageView;
@property(assign,atomic) UIDeviceOrientation currentOrientation;
@property(strong,atomic) UIImage *image;
@property(assign,atomic) CGFloat scale;
//预览
+(void)showImage:(UIImageView *)avatarImageView;
//预览
+(void)showImage:(UIImage *)image FromView:(UIView *)view;
//预览缩略图 并加载原图
+(void)showThumbImage:(UIImage *)image WithOriginalImageUrl:(NSString *)url FromView:(UIView *)view;
//预览图片组
+(void)showImage:(NSArray *)imageArrays currentIndex:(NSInteger)index FromView:(UIView *)view;
//关闭预览
+(void)hideImage:(UITapGestureRecognizer*)tap;
//压缩
+ (UIImage *)resizeImage:(UIImage *)image Size:(CGRect)rect;
//裁剪
+(UIImage *)clipImage:(UIImage *)image rect:(CGRect)rect;
//统一图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage;
//调整成合适大小
+(CGSize)calculateImage:(UIImage *)image AdaptiveInSize:(CGSize)size;
//调整成合适大小
+(CGSize)calculateImage:(UIImage *)image AdaptiveInSize:(CGSize)size MinSize:(CGSize)minSize;
//按比例获取不大于制定区域的大小，isAbsolute 为false时根据屏幕像素密度缩放
+(CGSize)calculateImage:(UIImage *)image MaxSizeInSize:(CGSize)size IsAbsoluteSize:(BOOL)isAbsolute;
//按比例获取不大于制定区域的大小，isAbsolute 为false时根据屏幕像素密度缩放
+(CGSize)calculateImage:(UIImage *)image MaxSizeInSize:(CGSize)size MinSize:(CGSize)minSize IsAbsoluteSize:(BOOL)isAbsolute;
-(void)printTransform:(CGAffineTransform) transform;
//截取屏幕区域
+(UIImage *)snapshotRect:(CGRect)rect;
//制作纯色图片
+(UIImage *)image:(UIImage *)image FillColor:(UIColor *)color;
//替换图片颜色
+ (UIImage*)replaceColor:(UIColor*)color ToColor:(UIColor *)toColor inImage:(UIImage*)image withTolerance:(float)tolerance;
//将颜色替换为透明
+(UIImage *)changeColorTo:(NSMutableArray*) array Transparent: (UIImage *)image;
@end
