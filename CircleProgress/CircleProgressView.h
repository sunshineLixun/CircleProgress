//
//  CircleProgressView.h
//  CircleProgress
//
//  Created by lixun on 16/9/11.
//  Copyright © 2016年 sunshine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView



@property (nonatomic) NSTimeInterval elapsedTime;

/**
 *  总时间
 */
@property (nonatomic) NSTimeInterval timeLimit;

@end
