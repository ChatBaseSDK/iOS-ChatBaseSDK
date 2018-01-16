//
//  LeftMenuViewController.m
//  chatbase.sdk.ios
//
//  Created by Diego Jimenez Martinez on 8/10/17.
//  Copyright © 2017 chatbase.co. All rights reserved.
//

#import "LeftMenuViewController.h"

@interface LeftMenuViewController ()

@property (nonatomic, retain) IBOutlet UITableView *menuTable;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Setup tableView
    [_menuTable setScrollEnabled:false];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//Method
#pragma mark - UIAlertController MEthod

-(void)showMessage:(NSString*)message withTitle:(NSString *)title
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes, please" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        //do something when click button
        NSLog(@"logout confirmation");
#warning - Here we are notificating de LOGOUT Notifiction to the WelcomeViewController -
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutClassNotification" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okAction];
    
    UIAlertAction *dontAction = [UIAlertAction actionWithTitle:@"No, thanks" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //do something when click button
        NSLog(@"logout cancelation");
    }];
    [alert addAction:dontAction];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)logoutSectionClicked:(id)sender
{
    [self showMessage:@"Please, confirm logout, you will not longer receive more notifications."
            withTitle:@"Are you sure?"];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CBLeftMenuTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = @"";
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *simpleTableIdentifier = @"CBHeaderMenuTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = @"User Name";
    cell.detailTextLabel.text = @"@userid";
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *simpleTableIdentifier = @"CBFooterMenuTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = @"Logout";
    cell.detailTextLabel.text = @"Confirmation required";
    
    UIButton *cellButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 132.0)];
    [cellButton addTarget:self action:@selector(logoutSectionClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:cellButton];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 132.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 132.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

@end
