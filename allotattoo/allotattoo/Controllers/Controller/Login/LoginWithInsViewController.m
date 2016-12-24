//
//  LoginWithInsViewController.m
//  AllTattoo
//
//  Created by My Star on 7/7/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "LoginWithInsViewController.h"

@interface LoginWithInsViewController ()
{
    NSString *client_id;
    NSString *secret;
    NSString *callback;
    NSMutableData *receivedData;
}
@end

@implementation LoginWithInsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    client_id = @"97464d6fc6714e8a96b032e4aaf0fe9c";
    secret = @"fb572749d75f4b3e98fe155f2a6157b4";
    callback = @"https://alltattoo.com";
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code",client_id,callback];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //    [indicator startAnimating];
    NSLog(@"Request URL = %@",[NSString stringWithFormat:@"%@",[[request URL] host]]);
    if ([[[request URL] host] isEqualToString:@"www.snapstats.com"]) {
        
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"code"]) {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
            if ([key isEqualToString:@"client_id"]) {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
        }
        
        if (verifier) {
            
            NSString *data = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",client_id,secret,callback,verifier];
            
            NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/access_token"];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
            NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            receivedData = [[NSMutableData alloc] init];
        } else {
            // ERROR!
        }
        
        [webView removeFromSuperview];
        
        return NO;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // [indicator stopAnimating];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"%@", error]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary * dicData = [NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil]];
    NSLog(@"%@", dicData);
    if (dicData[@"user"][@"id"]) {
//        [PFUser currentUser][@"userIdInstagram"] = [NSString stringWithFormat:@"%@", dicData[@"user"][@"id"]];
//        [PFUser currentUser][@"accessTokenInstagram"] = [NSString stringWithFormat:@"%@", dicData[@"access_token"]];
//        [[PFUser currentUser] saveEventually];
//        [[Global sharedInstance] loadAllPhotosForFacebookId:[PFUser currentUser][@"facebookId"] WithInstagramID:[PFUser currentUser][@"userIdInstagram"] withToken:[PFUser currentUser][@"accessTokenInstagram"]];
//        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoggedInInstagramPN" object:self userInfo:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
