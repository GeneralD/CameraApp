//
// Created by Yumenosuke Koukata on 11/4/13.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GPUImageOutput;
@protocol GPUImageInput;

@interface FilterData : NSObject
@property(nonatomic, strong) GPUImageOutput <GPUImageInput> *filter;
@property(nonatomic, copy) NSString *name;
@end
