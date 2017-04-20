//
//  Book.h
//  MessageForwardDemo
//
//  Created by LaiYoung_ on 2017/4/20.
//  Copyright © 2017年 LaiYoung_. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BookProviderProtocol <NSObject>

- (void)purchaseBookWithTitle:(NSString *)title;

@end

@interface Book : NSObject

@end
