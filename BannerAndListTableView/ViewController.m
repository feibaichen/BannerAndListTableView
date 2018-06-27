//
//  ViewController.m
//  BannerAndListTableView
//
//  Created by Derek on 26/06/18.
//  Copyright © 2018年 Derek. All rights reserved.
//

#import "ViewController.h"
#import "ScrollBannerFBC.h"
#import "ScrollMenuView.h"
#import "MainViewController.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,ScrollMenuDIYFBCDelgate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableView *producListTableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIView *headTopView;

@property (nonatomic,strong) UIView *navView;
@property (nonatomic,strong) UIView *searchView;

@property (nonatomic,strong) ScrollBannerFBC *scrollBannerFBC;
@property (nonatomic,strong) ScrollMenuView *scrollMenu;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.headTopView addSubview:self.scrollBannerFBC];
     
    [self.view addSubview:self.tableView];
    
    [self setUpNav];
}
-(void)setUpNav{

    [self.view addSubview:self.navView];
    
    [self.navView addSubview:self.searchView];
    
}
-(UIView *)searchView{
    if (!_searchView) {
        
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(30, 7, SCREENW - 30 - 60, 30)];
        _searchView.layer.borderWidth = 0.5;
        _searchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearch)];
        [_searchView addGestureRecognizer:tap];
    }
    return _searchView;
}
-(void)tapSearch{
    MainViewController *main = [MainViewController new];
    [self.navigationController pushViewController:main animated:YES];
}
-(UIView *)navView{
    if (!_navView) {
        
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
        _navView.alpha = 0.5;
        //_navView.hidden = YES;
        _navView.backgroundColor = [UIColor clearColor];
    }
    return _navView;
}
-(ScrollBannerFBC *)scrollBannerFBC{
    
    if (!_scrollBannerFBC) {
        
        _scrollBannerFBC = [[ScrollBannerFBC alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.width * 0.56) andBannerArray:@[@"1",@"2",@"3",@"4",@"5",@"6"] andBannerBackGroundArray:@[@"p1",@"p2",@"p3",@"p4",@"p5",@"p6"] andHideLeftRight:NO];
        
    }
    return _scrollBannerFBC;
}
-(ScrollMenuView *)scrollMenu{
    
    if (!_scrollMenu) {
        
        _scrollMenu = [[ScrollMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 44)];
        _scrollMenu.delegate = self;//代理事件根据需要添加，ScrollMenuDIYFBCDelgate
        //NSArray *array=@[@"首页",@"热点",@"最新"];
        //NSArray *array=@[@"首页",@"热点",@"最新",@"最火",@"最冷",@"商业"];
        NSArray *array=@[@"首页",@"热点",@"最新",@"最火",@"最冷",@"商业",@"艺术",@"文化",@"教育",@"历史",@"文学",@"社会",@"美术",@"地理",@"科学"];
        //初始化菜单栏
        [_scrollMenu initScrollMenuFrame:CGRectMake(0, 0, SCREENW, 44) andTitleArray:array andDisplayNumsOfMenu:6];
        //初始化内容翻页
        [_scrollMenu ScrollViewContent:CGRectMake(0, 44, SCREENW, SCREENH)];
        
        //[self.navigationController.navigationBar addSubview:scrollMenu];//添加菜单栏
        //[self.navigationController.navigationBar addSubview:scrollMenu.plusMenuBTN];//添加加号按钮
        
        //添加滚动内容页面到指定视图
        //[self.view addSubview:scrollMenu.contentScrollView];
        
        //添加子视图，请求数据
        for (int i = 0 ; i < array.count; i++) {
            MainViewController *vc = [[MainViewController alloc]init];
            vc.view.frame=CGRectMake(i * SCREENW, 0, SCREENW, SCREENH);
            [vc postNetWorkingWithTitle:array[i]];//传递请求数据
            [_scrollMenu.contentScrollView addSubview:vc.view];
            [self addChildViewController:vc];
            
        }
        
        [self.view addSubview:_scrollMenu.myPlusShowBackView];
    }
    return _scrollMenu;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(UITableView *)producListTableView{
    if (!_producListTableView) {
        _producListTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _producListTableView.delegate = self;
        _producListTableView.dataSource = self;
    }
    return _producListTableView;
}
-(UIView *)headTopView{
    if (!_headTopView) {
        _headTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
        _headTopView.backgroundColor = [UIColor redColor];
    }
    return _headTopView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableView) {
        
        if (section == 0) {
            
            return 1;
            
        }else{
            
            return 0;
        }
        
    }else{
        
        return 40;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == self.tableView) {
        
        return 2;
        
    }else{
        
        return 1;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView) {
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cellid1"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellid1"];
        }
        
        if ([indexPath section] == 0) {
            
            [cell.contentView addSubview:self.headTopView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            
            cell.backgroundColor = [UIColor blueColor];
        }
        
        return cell;
        
    }else{
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cellid2"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellid2"];
        }
        cell.backgroundColor = [UIColor orangeColor];
        cell.textLabel.text = @"这是一个嵌入的taleView";
        return cell;
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        
        if ([indexPath section] == 0) {
            
            return 300;
            
        }else{
            
            return 0;
        }
        
    }else{
        
        return 40;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.tableView) {
        
        if (section == 0) {
            
            return nil;
            
        }else{
            
            UIView *v = [[UIView alloc] init];
            v.userInteractionEnabled = YES;
            [v addSubview:self.scrollMenu];
            [v addSubview:self.scrollMenu.plusMenuBTN];
            [v addSubview:self.scrollMenu.contentScrollView];
            
            return v;
        }
        
    }else{
        
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.tableView) {
        
        if (section == 0) {
            
            return 0;
            
        }else{
            
            return self.view.frame.size.height;
        }
        
    }else{
        
        return 0;
    }
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToTop" object:nil userInfo:@{@"insideScrollEnable":@"no"}];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    float y = scrollView.contentOffset.y;
    
    if (y >= 300) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToTop" object:nil userInfo:@{@"insideScrollEnable":@"yes"}];
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToTop" object:nil userInfo:@{@"insideScrollEnable":@"no"}];
    }

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"-------scroll----------");
    
    float y = scrollView.contentOffset.y;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        __weak __typeof__(self) weakSelf = self;
        weakSelf.navigationController.navigationBar.hidden = NO;
        weakSelf.navigationController.navigationBar.alpha = y/300;
        
    }];
    
    
    if (y >= 300) {
        NSLog(@"y >= 300--------");
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            __weak __typeof__(self) weakSelf = self;
            
            //weakSelf.navigationController.navigationBar.alpha = 1;
            weakSelf.navigationController.navigationBar.translucent = NO;
            [weakSelf.navigationController.navigationBar addSubview:weakSelf.searchView];
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToTop" object:nil userInfo:@{@"insideScrollEnable":@"yes"}];
        
    }else{
        
        NSLog(@"y < 300");
        
        [UIView animateWithDuration:0.3 animations:^{
            
            __weak __typeof__(self) weakSelf = self;
            weakSelf.navigationController.navigationBar.hidden = YES;
            //weakSelf.navigationController.navigationBar.alpha = 0;
            weakSelf.navigationController.navigationBar.translucent = YES;
            [weakSelf.navView addSubview:weakSelf.searchView];
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToTop" object:nil userInfo:@{@"insideScrollEnable":@"no"}];
    }
    
}
/*
 ScrollMenuDIYFBCDelgate  代理事件，根据需求可用可不用
 */
-(void)MenuButtonIsReallyClick:(UISegmentedControl *)SegmentedC{
    NSLog(@"v----selectedSegmentIndex = %ld",SegmentedC.selectedSegmentIndex);
}
-(void)PlusButtonIsReallyClick:(UIButton *)button{
    NSLog(@"v----PlusButtonIsReallyClick =%ld",button.tag);
}
-(void)PlusShowViewInsideButtonIsReallyClick:(UIButton *)button{
    NSLog(@"v----PlusShowViewInsideButtonIsReallyClick = %ld",button.tag);
}
-(void)scrollToWhichMenu:(int)MenuSegmentIndex{
    NSLog(@"v----scrollToWhichMenu = %d",MenuSegmentIndex);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
