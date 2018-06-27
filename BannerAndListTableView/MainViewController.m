//
//  MainViewController.m
//  BannerAndListTableView
//
//  Created by Derek on 26/06/18.
//  Copyright © 2018年 Derek. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *producListTableView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewEnablleOrNot:) name:@"scrollToTop" object:nil];
    
    [self.view addSubview:self.producListTableView];
    
}
-(void)postNetWorkingWithTitle:(NSString *)titleStr{
    self.myTitle = [NSString stringWithFormat:@"%@",titleStr];
}
-(void)scrollViewEnablleOrNot:(NSNotification *)sender{
    
    NSLog(@"%@",sender.userInfo);
    
    
    if ([sender.userInfo[@"insideScrollEnable"] isEqualToString:@"yes"]) {
        _producListTableView.scrollEnabled = YES;
    }else{
        _producListTableView.scrollEnabled = NO;
    }
    
}
-(UITableView *)producListTableView{
    if (!_producListTableView) {
        _producListTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _producListTableView.delegate = self;
        _producListTableView.dataSource = self;
        //_producListTableView.bounces = NO;
        _producListTableView.scrollEnabled = NO;
    }
    return _producListTableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 40;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cellid2"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellid2"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor orangeColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.myTitle];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float y = scrollView.contentOffset.y;
    
    if (y == 0) {
        
        _producListTableView.scrollEnabled = NO;
        
    }else{
        _producListTableView.scrollEnabled = YES;
        
    }
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    float y = scrollView.contentOffset.y;
    
    if (y < 0) {
        _producListTableView.scrollEnabled = NO;
    }
}
- (void)didReceiveMemoryWarning {
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

@end
