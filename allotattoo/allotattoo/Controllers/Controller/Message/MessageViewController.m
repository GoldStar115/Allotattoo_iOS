//
//  MessageViewController.m
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "MessageViewController.h"
#import "PhotoFeedViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    _arrMessageStr = [NSMutableArray arrayWithObjects:
                      @"ocated in downtown Prague, The Boscolo Prague hotel, Autograph Collection is a ..",
                      @"utograph Collection is a stroll from Wenceslas Square and all celebrate. Nice sneakers…",
                      @"Autograph Collection is a stroll from Wenceslas Square and all celebrated Prague…", nil];
    _arrMessageTime = [NSMutableArray arrayWithObjects:@"il y a 29 minutes",@"il y a 1 heure",@"10:30", nil];
    _arrMessageUserPic = [NSMutableArray arrayWithObjects:@"imgUserPic1",@"imgUserPic2",@"imgUserPic1", nil];
    _arrName = [NSMutableArray arrayWithObjects:@"Sarah Martin",@"Arthur James",@"Max Shepard", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrName.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableCell *messageTableCell = (MessageTableCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageTableCell"];
    messageTableCell.imgUserPic.image = [UIImage imageNamed:_arrMessageUserPic[indexPath.row]];
    messageTableCell.lblUserName.text = _arrName[indexPath.row];
    messageTableCell.lblChatTIme.text = _arrMessageTime[indexPath.row];
    messageTableCell.lblChatContent.text  = _arrMessageStr[indexPath.row];
    return  messageTableCell;
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height/6;
}
- (IBAction)onBack:(id)sender {
    PhotoFeedViewController *photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
    [SharedModel instance].feedIndex = 0;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:photoFeedVC] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}


@end
