//
//  AgreeViewController.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/2/2.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit

class AgreeViewController: UIViewController , UITextViewDelegate{
    
    @IBOutlet weak var myProtocolTxt: UITextView!
    @IBOutlet weak var myLoadingLbl: UILabel!
    
    @IBAction func btnBackClicked(sender: AnyObject) {
        var uiController:UIViewController?
        switch(jumpViewStr)
        {
        case JUMP_login:
            uiController = self.storyboard?.instantiateViewControllerWithIdentifier(SB_LoginView) as! LoginViewController
            (uiController as! LoginViewController).jumpViewStr = JUMP_main
            break
        case JUMP_main:
            uiController = self.storyboard?.instantiateViewControllerWithIdentifier(SB_MainView) as! ViewController
            break
        case JUMP_pay:
            if !NSUserDefaults.standardUserDefaults().boolForKey(USER_isLogin){
                uiController = self.storyboard?.instantiateViewControllerWithIdentifier(SB_LoginView) as! LoginViewController
                (uiController as! LoginViewController).jumpViewStr = JUMP_main
            }else{
                uiController = self.storyboard?.instantiateViewControllerWithIdentifier(SB_PayView) as! PayViewController
                (uiController as! PayViewController).jumpViewStr = JUMP_pay
            }
            break
        case JUMP_renew:
            uiController = self.storyboard?.instantiateViewControllerWithIdentifier(SB_RenewView) as! RenewViewController
//            self.presentViewController(uiController!, animated: false, completion: nil)
            break
        case JUMP_report:
            uiController = self.storyboard?.instantiateViewControllerWithIdentifier(SB_ReportView) as! ReportViewController
//            self.presentViewController(uiController!, animated: false, completion: nil)
            break
        default:
            self.navigationController?.popViewControllerAnimated(true)
            break
        }
        if uiController != nil {
            self.navigationController?.pushViewController(uiController!, animated: true)
        }
    }
    
    var jumpViewStr = JUMP_main
    
    override func viewDidAppear(animated: Bool) {
//        if self.myLoadingLbl != nil {
//            return
//        }
        myLoadingLbl.hidden = false
        request(.GET, get_ProtocolUrl, parameters: nil).responseString { (_, _, data, error) -> Void in
            if data != "" {
                if let dataHtml = data?.htmlString {
                    self.myProtocolTxt.attributedText = dataHtml
                    self.myLoadingLbl.hidden = true
                }
            }else{
                // 检测网络
                if AppDelegate.isConnectedToNetwork() == false {
                    self.myLoadingLbl.hidden = false
                    self.myLoadingLbl.text = "网络异常，请检查网络设置！"
                    return
                }

            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myLoadingLbl.text = "正在加载中..."
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
