//
//  ViewController.m
//  AppExtensionDemo
//
//  Created by wangzz on 14-6-16.
//  Copyright (c) 2014年 FOOGRY. All rights reserved.
//

#import "ViewController.h"
#import <Dylib/Dylib.h>
#import <NotificationCenter/NCWidgetController.h>


@interface ViewController ()
{
    IBOutlet    UITextField *_textField;
}

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self logAppPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//让隐藏的插件重新显示
- (void)showTodayExtension
{
    [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:@"com.wangzz.app.extension"];
}

//隐藏插件
- (void)hiddeTodayExtension
{
    [[NCWidgetController widgetController] setHasContent:NO forWidgetWithBundleIdentifier:@"com.wangzz.app.extension"];
}

//通过NSUserDefaults保存text
- (void)saveTextByNSUserDefaults
{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.wangzz"];
    [shared setObject:_textField.text forKey:@"wangzz"];
    [shared synchronize];
}

//通过NSFileManager保存text
- (BOOL)saveTextByNSFileManager
{
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.wangzz"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/good"];

    NSString *value = _textField.text;
    BOOL result = [value writeToURL:containerURL atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!result) {
        NSLog(@"%@",err);
    } else {
        NSLog(@"save value:%@ success.",value);
    }
    
    return result;
}

//将framework从app的main bundle中copy到app group中
- (BOOL)copyFrameworkFromMainBundleToAppGroup
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.wangzz"];
    NSString *sorPath = [NSString stringWithFormat:@"%@/Dylib.framework",[[NSBundle mainBundle] bundlePath]];
    NSString *desPath = [NSString stringWithFormat:@"%@/Library/Caches/Dylib.framework",containerURL.path];
    
    BOOL removeResult = [manager removeItemAtPath:desPath error:&err];
    if (!removeResult) {
        NSLog(@"%@",err);
    } else {
        NSLog(@"remove success.");
    }
    
    BOOL copyResult = [[NSFileManager defaultManager] copyItemAtPath:sorPath toPath:desPath error:&err];
    if (!copyResult) {
        NSLog(@"%@",err);
    } else {
        NSLog(@"copy success.");
    }

    return copyResult;
}

//加载指定路径下的framework
- (BOOL)loadDylibWithPath:(NSString *)path
{
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    if ([bundle loadAndReturnError:nil]) {
        Class root = NSClassFromString(@"Person");
        if (root) {
            Person *person = [[root alloc] init];
            [person run];
        }
        
        return YES;
    }
    
    return NO;
}

//打印和应用相关的几个路径
- (void)logAppPath
{
    //app group路径
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.wangzz"];
    NSLog(@"app group:\n%@",containerURL.path);
    
    //打印可执行文件路径
    NSLog(@"bundle:\n%@",[[NSBundle mainBundle] bundlePath]);
    
    //打印documents
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"documents:\n%@",path);
}

- (IBAction)saveAction:(id)sender
{
    //在此调用以上实现的方法进行测试
    
}




@end
