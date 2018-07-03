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
#import "SquareUpFBC.h"
#import "MainViewController.h"
#import "MJRefresh.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,ScrollMenuDIYFBCDelgate,ScrollBannerFBCdelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableView *producListTableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIView *headTopView;

@property (nonatomic,strong) UIView *navView;
@property (nonatomic,strong) UIView *searchView;
@property (nonatomic,strong) UIButton *headMessage;

@property (nonatomic,strong) ScrollBannerFBC *scrollBannerFBC;
@property (nonatomic,strong) ScrollMenuView *scrollMenu;
@property (nonatomic,strong) SquareUpFBC *squareUp;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.hidden = NO;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setHeadRefresh];
    
    [self.headTopView addSubview:self.scrollBannerFBC];
     
    [self.view addSubview:self.tableView];
    
    [self setUpNav];

}
-(void)setUpNav{

    [self.scrollBannerFBC addSubview:self.navView];
    
    [self.navView addSubview:self.searchView];
    
    [self.navView addSubview:self.headMessage];
    
}
-(void)setHeadRefresh{
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    
    
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(clickHeader)];
    
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:refreshingImages forState:MJRefreshStatePulling];
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    [header setIgnoredScrollViewContentInsetTop:30];
    header.mj_h = 80;
    header.lastUpdatedTimeLabel.hidden =YES;
    header.stateLabel.hidden = YES;
    
    self.tableView.mj_header = header;
    
//    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(clickFooter)];
//
//    [footer setImages:idleImages forState:MJRefreshStateIdle];
//    [footer setImages:refreshingImages forState:MJRefreshStatePulling];
//    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
//
//    footer.stateLabel.hidden = YES;
//
//    self.tableView.mj_footer = footer;
}
-(void)clickHeader{
    
    [self.tableView.mj_header beginRefreshing];
    __weak __typeof__(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf.tableView.mj_header endRefreshing];
        
    });
    
}
-(void)clickFooter{
    [self.tableView.mj_footer beginRefreshing];
    
    __weak __typeof__(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf.tableView.mj_footer endRefreshing];
    });
    
    
    
}
-(UIView *)searchView{
    if (!_searchView) {
        
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(35, 7, SCREENW - 35 - 60, 30)];
        _searchView.layer.borderWidth = 0.5;
        _searchView.layer.borderColor = [UIColor lightTextColor].CGColor;
        _searchView.layer.cornerRadius = 10;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearch)];
        [_searchView addGestureRecognizer:tap];
    }
    return _searchView;
}
-(UIButton *)headMessage{
    if (!_headMessage) {
        
        _headMessage = [[UIButton alloc] initWithFrame:CGRectMake(SCREENW - 45, 7, 30, 30)];
        [_headMessage setImage:[UIImage imageNamed:@"msg"] forState:UIControlStateNormal];
    }
    return _headMessage;
}
-(void)tapSearch{
    MainViewController *main = [MainViewController new];
    [self.navigationController pushViewController:main animated:YES];
}
-(UIView *)navView{
    if (!_navView) {
        
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
        _navView.backgroundColor = [UIColor clearColor];
    }
    return _navView;
}
-(UIView *)squareUp{
    
    if (!_squareUp) {
        
        _squareUp = [[SquareUpFBC alloc] initWithBaseFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.width * 0.7 - 44, SCREENW, 140) andNum_of_squareness:8 andNum_of_squareness_horizontal:4 andSquareness_width:40 andSquareness_height:40 andSquareness_padding_to_top:15 andSquareness_padding_to_left:40 andSquareness_padding_to_right:40 andSquareness_avage_distence_horizental:30 andSquareness_avage_distence_vertical:20];
        _squareUp.backgroundColor = [UIColor lightGrayColor];
    }
    return _squareUp;
}
-(ScrollBannerFBC *)scrollBannerFBC{
    
    if (!_scrollBannerFBC) {
        
        _scrollBannerFBC = [[ScrollBannerFBC alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.width * 0.7) andBannerArray:@[@"1",@"2",@"3",@"4",@"5",@"6"] andBannerBackGroundArray:@[@"p1",@"p2",@"p3",@"p4",@"p5",@"p6"] andHideLeftRight:NO];
        _scrollBannerFBC.delegate = self;
        _scrollBannerFBC.userInteractionEnabled = YES;
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
        _headTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.7 - 44 + 140)];
        _headTopView.userInteractionEnabled = YES;
        _headTopView.backgroundColor = [UIColor blueColor];
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
            [cell.contentView addSubview:self.squareUp];
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
            
            return 400;
            
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
            [v addSubview:_scrollMenu.myPlusShowBackView];
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
            
            return self.view.frame.size.height ;
        }
        
    }else{
        
        return 0;
    }
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToTop" object:nil userInfo:@{@"insideScrollEnable":@"no"}];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    float y = scrollView.contentOffset.y;
    
    self.navigationController.navigationBar.hidden = NO;
    
    if (y <= 0) {

    [UIView animateWithDuration:0.1 animations:^{
        
        __weak __typeof__(self) weakSelf = self;
        [weakSelf.tableView setContentOffset:CGPointMake(0, -20)];
    }];
        
    }
    
    
    if (y >= 400) {
        
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
        weakSelf.navigationController.navigationBar.alpha = y / 400;
        
    }];
    
    
    if (y >= 400) {
        NSLog(@"y >= 400--------");
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            __weak __typeof__(self) weakSelf = self;
            
            //weakSelf.navigationController.navigationBar.alpha = 1;
            weakSelf.navigationController.navigationBar.translucent = NO;
            [weakSelf.navigationController.navigationBar addSubview:weakSelf.searchView];
            [weakSelf.navigationController.navigationBar addSubview:weakSelf.headMessage];
            weakSelf.searchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToTop" object:nil userInfo:@{@"insideScrollEnable":@"yes"}];
        
    }else{
        
        NSLog(@"y < 300");
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            __weak __typeof__(self) weakSelf = self;
            weakSelf.navigationController.navigationBar.translucent = YES;
            [weakSelf.navView addSubview:weakSelf.searchView];
            [weakSelf.navView addSubview:weakSelf.headMessage];
            [weakSelf.scrollBannerFBC addSubview:weakSelf.navView];
             weakSelf.searchView.layer.borderColor = [UIColor whiteColor].CGColor;
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToTop" object:nil userInfo:@{@"insideScrollEnable":@"no"}];
        
    }
    
}

//代理事件
//图片被点击事件
-(void)imageViewIsTaped:(UITapGestureRecognizer *)tap{
    
    NSLog(@"imageViewIsTaped %ld",tap.view.tag);
}
//自动滚动到哪一张图，非人为拖动
-(void)autoScrollToWhichBanner:(UIImageView *)imageView{
    
    NSLog(@"autoScrollToWhichBanner %ld",imageView.tag);
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
