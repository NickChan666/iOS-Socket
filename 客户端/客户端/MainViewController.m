//
//  MainViewController.m
//  客户端
//
//  Created by 陈小发 on 2018/6/4.
//  Copyright © 2018年 陈小发. All rights reserved.
//
#import "UserInfo.h"
#import "MainViewController.h"
#import "ChatVC.h"

@interface MainViewController ()<GCDAsyncSocketDelegate,UITableViewDelegate,UITableViewDataSource,SendDelegate>
@property (nonatomic , strong)  ChatVC *vc;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"主界面";
    [self vc];
    UISwipeGestureRecognizer *gestureRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    gestureRecognizer.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gestureRecognizer];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];
    [self.view addSubview:self.tableView];
    UIBarButtonItem *sendBtn=[[UIBarButtonItem alloc] initWithTitle:@"广播" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage)];
    self.navigationItem.rightBarButtonItem=sendBtn;
}

- (void)sendMessage {
    
    //输入你想对XX说的话
    NSString *title = [NSString stringWithFormat:@"请输入你广播的内容"];
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"请输入";
        textField.secureTextEntry=NO;
    }];
    
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MessageModel *model=[[MessageModel alloc]initWithReciver:@"all" Sender:[UserInfo shareInstance].name Component:alert.textFields.firstObject.text];
        [self sendMessageTo:@"all" Text:model.component];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendMessageTo:(NSString *)name Text:(NSString *)text {
    NSDictionary *dict=@{@"action":@"talk",@"UserName":[UserInfo shareInstance].name,@"Reciver":name,@"text":text};
    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"%@,dict",dict);
    //规定了1是发送信息的
    [self.socket writeData:data withTimeout:-1 tag:1];
    [self.socket readDataWithTimeout:-1 tag:1];
}

-(void)sendDelegate:(MessageModel *)model {
    [self sendMessageTo:model.reciver Text:model.component];
}

- (void)reciveMessage:(MessageModel *)model {
    NSLog(@"recive===%@",model.sender);
    for (ContactModel *contactModel in self.contactArray) {
        if ([contactModel.name isEqualToString:model.sender]||[model.reciver isEqualToString:@"all"]) {
            [contactModel.array addObject:model];
            NSLog(@"name====%@",contactModel.name);
        }
    }
    [self.vc.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    cell.name.text=self.contactArray[indexPath.row].name;
    cell.text.hidden=YES;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (UITableView *)tableView {
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor clearColor];
    }
    return _tableView;
}

- (NSMutableArray<ContactModel *> *)contactArray {
    if (_contactArray==nil) {
        _contactArray=[NSMutableArray array];
    }
    return _contactArray;
}

-(ChatVC *)vc {
    if (_vc==nil) {
        _vc=[[ChatVC alloc]init];
        _vc.delegate=self;
    }
    return _vc;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.vc.contactModel=self.contactArray[indexPath.row];
    [self.navigationController pushViewController:self.vc animated:YES];
}


@end
