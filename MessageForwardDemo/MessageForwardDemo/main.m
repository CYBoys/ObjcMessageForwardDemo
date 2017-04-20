//
//  main.m
//  MessageForwardDemo
//
//  Created by LaiYoung_ on 2017/4/20.
//  Copyright © 2017年 LaiYoung_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "DemoProxy.h"

#pragma mark - TEST1

@interface Test1 : NSObject

@end

@implementation Test1

/** 私有方法也可以 */
- (NSString *)run1 {
    return @"Test1 run1";
}

- (void)run2 {
    NSLog(@"Test2 run2");
}

@end

#pragma mark - TEST

@interface Test : NSObject
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
- (void)run;
- (NSString *)run1;
- (void)run2;
- (NSString *)name;
- (NSString *)setName:(NSString *)name;
- (void)test:(NSString *)test test1:(NSString *)test1;

@end

void run(id self, SEL cmd) {
    NSLog(@"Test run");
}

void nameSetter(id self, SEL cmd, id value) {
    NSString *fullName = value;
    NSArray *names = [fullName componentsSeparatedByString:@" "];
    Test *test = (Test *)self;
    test.firstName = names[0];
    test.lastName = names[1];
}

void test(id self, SEL cmd, id value, id value1) {
    NSLog(@"\nself = %@\ncmd = %@\nvalue = %@\nvalue1 = %@\n",NSStringFromClass([self class]),NSStringFromSelector(cmd),value,value1);
}

@implementation Test

/** 转发第一步,动态解析，新增方法，默认返回NO，如果这个函数返回YES，那么就不会再走后面的第二步，第三步。 */
/** 编码类型https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selStr = NSStringFromSelector(sel);
    if ([selStr isEqualToString:@"run"]) {
        class_addMethod(self, sel, (IMP)run, "v@:");
        return YES;
    }
    if ([selStr isEqualToString:@"setName:"]) {
        class_addMethod(self, sel, (IMP)nameSetter, "v@:@");//v 代表返回类型，v后面的@代表self，:代表sel，:后面的@代表对象参数，有多少个写多少个@，详见编码类型
        return YES;
    }
    if ([selStr isEqualToString:@"test:test1:"]) {
        class_addMethod(self, sel, (IMP)test, "v@:@@");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

/** 转发第二步，只有当第一步返回为NO的时候，才会走到此函数。此函数的作用是，重定向到其他对象，比如A对象没实现@"run"这个函数，B对象实现了。那么就重定向到B对象去实现 */
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *selStr = NSStringFromSelector(aSelector);
    if ([selStr isEqualToString:@"run2"]) {
        return [[Test1 alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

/** 转发第三步（最后一步），先方法签名，再转发 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selStr = NSStringFromSelector(aSelector);
    if ([selStr isEqualToString:@"run1"]) {
        //此处返回的sig是方法forwardInvocation的参数anInvocation中的methodSignature
        return [[[Test1 alloc] init] methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSString *selStr = NSStringFromSelector(anInvocation.selector);
    if ([selStr isEqualToString:@"run1"]) {
        [anInvocation invokeWithTarget:[[Test1 alloc] init]];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

@end


#pragma mark - MAIN

int main(int argc, const char * argv[]) {
//* --------------------------消息转发----------------------------- */
    Test *test = [[Test alloc] init];
    [test run];
    
//    [test respondsToSelector:@selector(run)];//respondsToSelector 也会走消息转发
    
//    NSString *runStr = [test run1];
//    NSLog(@"runStr = %@",runStr);
    
//    [test setName:@"forward test"];
    
//    [test test:@"1" test1:@"2"];
    
//    [test run2];
    
    
//* --------------------------伪多继承----------------------------- */
//    DemoProxy *demoProxy = [DemoProxy dealerProxy];
//    [demoProxy purchaseBookWithTitle:@"iOS 从入门到放弃"];
//    [demoProxy purchaseClothesWithName:@"阿玛尼"];
    return 0;
}
