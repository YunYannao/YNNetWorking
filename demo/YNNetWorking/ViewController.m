//
//  ViewController.m
//  YNNetWorking
//
//  Created by 员延孬 on 16/7/1.
//  Copyright © 2016年 KeviewYun. All rights reserved.
//

#import "ViewController.h"
#import "YNNetAPI_Manager.h"
#import "MBProgressHUD.h"
@interface ViewController ()

@property(nonatomic,strong)UITableView * mainTableView;
@end

@implementation ViewController{
    NSMutableArray * dataSourceArr;
}

-(UITableView*)mainTableView{
    if (_mainTableView==nil) {
        _mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
        _mainTableView.delegate=self;
        _mainTableView.dataSource=self;
    }
    return _mainTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"车辆列表";
    
    self.automaticallyAdjustsScrollViewInsets=YES;
    
    dataSourceArr=[NSMutableArray arrayWithCapacity:10];
    
    MBProgressHUD * hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"正在加载";
    
    __weak typeof(*&self) weakSelf = self;
    
    [[YNNetAPI_Manager shareManager] getHomePageProductListWithStart:[NSString stringWithFormat:@"%lu",(unsigned long)dataSourceArr.count] withLength:@"15" withComplationBlock:^(id data, NSError *error) {
        dataSourceArr=[data objectForKey:@"modelList"];
        [weakSelf.view addSubview:weakSelf.mainTableView];
        
        [hud hideAnimated:YES];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSourceArr.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=[[dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"Name"];
    return cell;
}
@end
