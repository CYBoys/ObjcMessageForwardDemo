//
//  Book.m
//  MessageForwardDemo
//
//  Created by LaiYoung_ on 2017/4/20.
//  Copyright © 2017年 LaiYoung_. All rights reserved.
//

#import "Book.h"

@interface Book()
<
BookProviderProtocol
>

@end

@implementation Book

- (void)purchaseBookWithTitle:(NSString *)title {
    NSLog(@"\nclass = %@\nYou've bought \"%@\"",NSStringFromClass([self class]),title);
}

@end
