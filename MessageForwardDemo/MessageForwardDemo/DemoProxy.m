//
//  DemoProxy.m
//  MessageForwardDemo
//
//  Created by LaiYoung_ on 2017/4/20.
//  Copyright © 2017年 LaiYoung_. All rights reserved.
//

#import "DemoProxy.h"
#import <objc/runtime.h>

@interface DemoProxy() {
    Book                *_book;
    Clothes             *_clothes;
    NSMutableDictionary *_methodsMap;
}

@end

@implementation DemoProxy

+ (instancetype)dealerProxy {
    return [[self alloc] init];
}

/** NSProxy 只能自定义init */
- (instancetype)init {
    _methodsMap = [NSMutableDictionary dictionary];
    _book = [[Book alloc] init];
    _clothes = [[Clothes alloc] init];
    [self proxy_registerMethodsWithTarget:_book];
    [self proxy_registerMethodsWithTarget:_clothes];
    return self;
}

- (void)proxy_registerMethodsWithTarget:(id)target {
    unsigned int numberOfMethods = 0;
    //* 获取方法列表 */
    Method *method_list = class_copyMethodList([target class], &numberOfMethods);
    for (int index = 0; index < numberOfMethods; index++ ) {
        //* 获取方法名存入字典 */
        Method temp_method = method_list[index];
        SEL temp_sel = method_getName(temp_method);
        const char *temp_method_name = sel_getName(temp_sel);
        [_methodsMap setObject:target forKey:[NSString stringWithUTF8String:temp_method_name]];
    }
    free(method_list);
}

#pragma mark - NSProxy override methods

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSString *methodName = NSStringFromSelector(sel);
    id target = _methodsMap[methodName];
    if (target && [target respondsToSelector:sel]) {
        return [target methodSignatureForSelector:sel];
    } else {
        return [super methodSignatureForSelector:sel];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSString *methodName = NSStringFromSelector(invocation.selector);
    
    id target = _methodsMap[methodName];
    if (target && [target respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:target];
    } else {
        [super forwardInvocation:invocation];
    }
    
}

@end
