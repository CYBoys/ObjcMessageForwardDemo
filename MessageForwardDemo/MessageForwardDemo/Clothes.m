//
//  Clothes.m
//  MessageForwardDemo
//
//  Created by LaiYoung_ on 2017/4/20.
//  Copyright © 2017年 LaiYoung_. All rights reserved.
//

#import "Clothes.h"

@interface Clothes()
<
ClothesProviderProtocol
>

@end

@implementation Clothes

- (void)purchaseClothesWithName:(NSString *)name {
    NSLog(@"\nclass = %@\nYou've bought some clothes name \"%@\"",NSStringFromClass([self class]),name);
}

@end
