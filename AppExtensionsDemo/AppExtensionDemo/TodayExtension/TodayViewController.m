//
//  TodayViewController.m
//  TodayExtension
//
//  Created by wangzz on 14-6-16.
//  Copyright (c) 2014年 FOOGRY. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#import <Dylib/Dylib.h>


@interface TodayViewController () <NCWidgetProviding>
{
    IBOutlet    UILabel *_lable;
    IBOutlet    UIButton    *_button;
}

@end

@implementation TodayViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"%s", __func__);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = [UIColor redColor];
    
    [self setPreferredContentSize:CGSizeMake(self.view.frame.size.width, 200)];
    
    [self logAppPath];
    
    NSLog(@"%s", __func__);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//通常插件要消失的时候会调用，系统会在这个时候对插件截图，以便下次启动插件加载之前快速展示
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encoutered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    NSLog(@"%s", __func__);
    completionHandler(NCUpdateResultNewData);
}

//通过openURL的方式启动Containing APP
- (void)openURLContainingAPP
{
    [self.extensionContext openURL:[NSURL URLWithString:@"appextension://123"]
                 completionHandler:^(BOOL success) {
                     NSLog(@"open url result:%d",success);
                 }];
}

//执行完任务后调用该方法，系统会将插件杀掉
- (void)completeTask
{
    [self.extensionContext completeRequestReturningItems:nil completionHandler:^(BOOL expired) {
        NSLog(@"is expired:%d",expired);
    }];
}

//将自己从Today区域中移除，要想再次显示必须在contaning app中调用显示方法
- (void)removeSelf
{
    [[NCWidgetController widgetController] setHasContent:NO forWidgetWithBundleIdentifier:@"com.wangzz.app.extension"];
}

//从NSUserDefaults中读取数据
- (NSString *)readDataFromNSUserDefaults
{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.wangzz"];
    NSString *value = [shared valueForKey:@"wangzz"];
    
    return value;
}

//通过NSFileManager读取app group中缓存数据
- (NSString *)readTextByNSFileManager
{
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.wangzz"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/good"];
    NSString *value = [NSString stringWithContentsOfURL:containerURL encoding:NSUTF8StringEncoding error:&err];
    
    return value;
}

//加载app group中的framework
- (BOOL)loadFrameworkInAppGroup
{
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.wangzz"];
    NSString *desPath = [NSString stringWithFormat:@"%@/Library/Caches/Dylib.framework",containerURL.path];
    NSBundle *bundle = [NSBundle bundleWithPath:desPath];
    BOOL result = [bundle loadAndReturnError:&err];
    if (result) {
        Class root = NSClassFromString(@"Person");
        if (root) {
            Person *person = [[root alloc] init];
            if (person) {
                [person run];
            }
        }
    } else {
        NSLog(@"%@",err);
    }
    
    return result;
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


- (IBAction)selector:(id)sender
{
    //在此调用上述方法进行测试
    
}


- (void)dealloc
{
    NSLog(@"%s", __func__);
}


@end
