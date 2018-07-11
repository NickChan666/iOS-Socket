#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import socket
import json
import threading

class ClientSocket(object):
    def __init__(self,name,socket):
        self.name = name
        self.socket=socket

# 登录操作
def LogIn(sock,socketList,dict):
    name=dict['name']
    for i in socketList:
        if name==i.name:
            sock.sendall(json.dumps({"success":0,"tag":0}).encode('utf-8'))
            return False
    newSocket=ClientSocket(name,sock)
    socketList.append(newSocket)
    users=[]
    for socket in socketList:
        users.append(socket.name)
    for so in socketList:
        #告诉别的客户端更新了
        if so.name !=name:
            try:
                so.socket.sendall(json.dumps({"success":1,"users":users,"tag":3}).encode('utf-8')) #封装成json 返回给客户端
            except Exception as e:
                pass
        else :
            so.socket.sendall(json.dumps({"success":1,"users":users,"tag":0}).encode('utf-8'))  #告诉我自己用户列表
    return True
    pass

# 聊天操作
def talk(socket,socketList,dict):
    name=dict["Reciver"]
    if name=='all':
        for i in socketList:
            i.socket.sendall(json.dumps({"success":1,"sender":dict["UserName"],"reciver":name,"text":dict["text"],"tag":2}).encode('utf-8'))
        socket.sendall(json.dumps({"success":1,"tag":1}).encode('utf-8'))
        return True
    else:
        for i in socketList:  # 通过遍历来找到那个人!
            if name==i.name:
                i.socket.sendall(json.dumps({"success":1,"sender":dict["UserName"],"reciver":name,"text":dict["text"],"tag":2}).encode('utf-8'))
                return True
        socket.sendall(json.dumps({"success":0,"tag":1}).encode('utf-8'))
        return False


# 可以收到信息
def CanRecive(socket,socketList,dict):
    print ('Can recive')
    pass

def NewLink(conn,addr,action):
    while 1:
        data=conn.recv(1024)#把接收的数据实例化
        print (conn,addr)
        if not data:
            print ('not data')
            conn.close()
        else :
            dict=json.loads(data.decode('utf-8')) #解码
            # print (dict)
            action.get(dict['action'])(conn,clientList,dict)
    conn.close() #关闭连接

if __name__ == '__main__':
    #定义端口和IP地址
    HOST ='127.0.0.1'
    PORT =38383
    action = {'LogIn':LogIn,'talk':talk,'CanRecive':CanRecive}
    #创建socket
    s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.bind((HOST,PORT))
    s.listen(5) #最多五个
    clientList=[]
    while 1:
        conn,addr=s.accept() #接收TCP连接，并返回新的SOCKET和IP地址
        print ('Connected By ',addr)
        # 创建新线程来处理TCP连接:
        t = threading.Thread(target=NewLink, args=(conn, addr,action))
        t.start()
