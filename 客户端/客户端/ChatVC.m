//
//  ChatVC.m
//  客户端
//
//  Created by 陈小发 on 2018/6/27.
//  Copyright © 2018年 陈小发. All rights reserved.
//

#import "ChatVC.h"
#import "UserInfo.h"

@interface ChatVC ()<UITableViewDelegate, UITableViewDataSource>
@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UISwipeGestureRecognizer *gestureRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    gestureRecognizer.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];
    
    
    UIBarButtonItem *sendBtn=[[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage)];
    
    self.navigationItem.rightBarButtonItem = sendBtn;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.title=self.contactModel.name;
    [self.tableView reloadData];
}

- (void)sendMessage {
    
    //输入你想对XX说的话
    NSString *title = [NSString stringWithFormat:@"请输入你想对%@说的话",self.contactModel.name];
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"请输入";
        textField.secureTextEntry=NO;
    }];
    
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MessageModel *model=[[MessageModel alloc]initWithReciver:self.contactModel.name Sender:[UserInfo shareInstance].name Component:alert.textFields.firstObject.text];
        [self.contactModel.array addObject:model];
        [self.delegate sendDelegate:model];
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self.tableView reloadData];
    }];
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (UITableView *)tableView {
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.separatorColor=[UIColor clearColor];
    }
    return _tableView;
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactModel.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    cell.name.text=[NSString stringWithFormat:@"%@发送给%@",self.contactModel.array[indexPath.row].sender,self.contactModel.array[indexPath.row].reciver];
    cell.text.text=self.contactModel.array[indexPath.row].component;
    return cell;
}

@end
