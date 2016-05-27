//
//  ViewController.swift
//  jifenqi
//
//  Created by lvguorui on 16/4/25.
//  Copyright © 2016年 lvguorui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var daojishi: UIButton!
    var db:SQLiteDB!
    var operandlufui:String = ""//缓存数据
    var operandjinmu:String = " "
    var huancunlufei = 0
    var huancunjinmu = 0
    
    var jishiqi:NSTimer!//定时器
    var daojishi1 = 0
    var miao:Int = 600//10分钟＝600秒
   
    
    @IBOutlet weak var end: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var lufeiresult: UITextField!
    @IBOutlet weak var jinmuresult: UITextField!
  
    @IBAction func lufuiteam(sender: AnyObject) {
        let value = sender.currentTitle//提取每次取得值
        huancunlufei = huancunlufei+Int(value!!)!
        operandlufui = String(huancunlufei)
        lufeiresult.text = operandlufui
    }
   
    @IBAction func jinmuteam(sender: AnyObject) {
        let value = sender.currentTitle
        huancunjinmu = huancunjinmu+Int(value!!)!
        operandjinmu = String(huancunjinmu)
        jinmuresult.text = operandjinmu
    }
    
    @IBAction func delet(sender: AnyObject) {
        operandlufui = " "
        operandjinmu = " "
        self.lufeiresult.text = " 0 "
        self.jinmuresult.text = " 0 "
    }
    
    
    @IBAction func start(sender: UIButton) {
        if daojishi1 == 0//倒计时开始
        {
           jishiqi = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "tickDown", userInfo: nil, repeats: true)
            daojishi1 = 1//停止时间
           
            
            
        }
        
    }
    
    
    
    @IBAction func end(sender: UIButton) {
       if daojishi1 == 1{
            jishiqi.invalidate()//停止记时
         daojishi1 = 0
        
        }
        
    }
    func tickDown()
    {
        if miao>0{
            miao -= 1
            let sec = miao%60
            let min = miao/60
            time.text = String(min) + ":" + String(sec)
        }
        
    }
   
   
   
    
   
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取数据库实例
        db = SQLiteDB.sharedInstance()
        //如果表还不存在则创建表（其中uid为自增主键）
        db.execute("create table if not exists t_user(uid integer primary key,uname varchar(20),mobile varchar(20))")
        //如果有数据则加载
        initUser()
    }
    
    //点击保存
    @IBAction func saveClicked(sender: AnyObject) {
        saveUser()
    }
    
    
    

    //从SQLite加载数据
    func initUser() {
        let data = db.query("select * from t_user")
        if data.count > 0 {
            //获取最后一行数据显示
            let user = data[data.count - 1]
            lufeiresult.text = user["uname"] as? String
            jinmuresult.text = user["mobile"] as? String
        }
    }
    
    //保存数据到SQLite
    func saveUser() {
        let uname = self.lufeiresult.text!
        let mobile = self.jinmuresult.text!
        //插入数据库，这里用到了esc字符编码函数，其实是调用bridge.m实现的
        let sql = "insert into t_user(uname,mobile) values('\(uname)','\(mobile)')"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql)
        print(result)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

