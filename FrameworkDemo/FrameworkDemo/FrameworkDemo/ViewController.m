//
//  ViewController.m
//  FrameworkDemo
//
//  Created by wangzz on 14-6-9.
//  Copyright (c) 2014年 FOOGRY. All rights reserved.
//

#import "ViewController.h"
#import <Dylib/Dylib.h>
#import <dlfcn.h>

/*
 /Applications/Xcode6-Beta.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator8.0.sdk/System/Library/Frameworks
 */

static void *libHandle = NULL;

@interface ViewController ()
{
    NSString    *_libPath;
}

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
- (IBAction)onTriggerButtonAction:(id)sender
{
    // Get the Person class (required with runtime-loaded libraries).
    Class rootClass = NSClassFromString(@"Person");
    if (rootClass) {
        id object = [[rootClass alloc] init];
        [(Person *)object run];
    }
}

- (IBAction)onBundleLoadAtPathAction1:(id)sender
{
    NSString *documentsPath = [NSString stringWithFormat:@"%@/Documents/Dylib.framework",NSHomeDirectory()];
    [self bundleLoadDylibWithPath:documentsPath];
}

- (IBAction)onBundleLoadAtPathAction2:(id)sender
{
    NSString *newPath = [NSString stringWithFormat:@"%@/Documents/new/Dylib.framework",NSHomeDirectory()];
    [self bundleLoadDylibWithPath:newPath];
}

- (IBAction)onDlopenLoadAtPathAction1:(id)sender
{
    NSString *documentsPath = [NSString stringWithFormat:@"%@/Documents/Dylib.framework/Dylib",NSHomeDirectory()];
    [self dlopenLoadDylibWithPath:documentsPath];
}

- (IBAction)onDlopenLoadAtPathAction2:(id)sender
{
    NSString *newPath = [NSString stringWithFormat:@"%@/Documents/new/Dylib.framework/Dylib",NSHomeDirectory()];
    [self dlopenLoadDylibWithPath:newPath];
}

- (IBAction)onBundleUnloadAction:(id)sender
{
    [self bundleUnloadDylibWithPath:_libPath];
}

- (IBAction)onDlopenUnloadAction:(id)sender
{
    [self dlopenUnloadDylibWithHandle:libHandle];
}


#pragma mark - Private Method
- (void)bundleLoadDylibWithPath:(NSString *)path
{
    _libPath = path;
    NSError *err = nil;
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    if ([bundle loadAndReturnError:&err]) {
        NSLog(@"bundle load framework success.");
    } else {
        NSLog(@"bundle load framework err:%@",err);
    }
}

- (void)dlopenLoadDylibWithPath:(NSString *)path
{
    libHandle = NULL;
    libHandle = dlopen([path cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
    if (libHandle == NULL) {
        char *error = dlerror();
        NSLog(@"dlopen error: %s", error);
    } else {
        NSLog(@"dlopen load framework success.");
    }
}

- (BOOL)bundleUnloadDylibWithPath:(NSString *)path
{
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    BOOL result = [bundle unload];
    if (!result) {
        NSLog(@"bundle unload dylib failed:%@",path);
    } else {
        NSLog(@"bundle unload dylib success");
    }
    
    return result;
}

- (BOOL)dlopenUnloadDylibWithHandle:(void *)handle
{
    BOOL result = dlclose(handle);
    if (!result) {
        NSLog(@"dlopen unload dylib failed.");
    } else {
        NSLog(@"dlopen unload dylib success");
    }
    
    return result;
}



@end
