//
//  ViewController.m
//  WebViewNativeDemo
//
//  Created by Yongwei.Chen on 12/19/15.
//  Copyright © 2015 51tywy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;


@end

@implementation ViewController

- (IBAction)showWebAlert:(id)sender {
    NSString *jsScript = [NSString stringWithFormat:@"nativeCallWeb('%@');", @"test pass param"];
    [self.webview stringByEvaluatingJavaScriptFromString:jsScript];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSString *htmlPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:[NSString stringWithFormat:@"/%@", @"demo.html"]];
    
    self.webview.delegate = self;
    self.webview.scalesPageToFit = YES;
    self.webview.scrollView.bounces = NO;
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlPath]]];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL * url = [request URL];
    if ([[url scheme] isEqualToString:@"mgnative"])
    {
        NSString *methodParam = [[url absoluteString] stringByReplacingOccurrencesOfString:@"mgnative://" withString:@""];
        NSArray *mpArray = [methodParam componentsSeparatedByString:@"/"];
        if (mpArray.count >= 2) {
            NSString *method = mpArray[0];
            NSString *param = mpArray[1];
            
            UIAlertController * alert=  [UIAlertController
                                          alertControllerWithTitle:[NSString stringWithFormat:@"method:%@ from web", method]
                                          message:[NSString stringWithFormat:@"param:%@ from web",param]
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok];
        }
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
