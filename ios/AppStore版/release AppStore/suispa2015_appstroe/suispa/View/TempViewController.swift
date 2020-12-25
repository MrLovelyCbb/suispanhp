//
//  TempViewController.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/2/2.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {

    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var myPageControl: UIPageControl!
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var myBtnback: UIButton!
    @IBOutlet weak var myBtnLogin: UIButton!
    
    // JsonImageData
    var imageScrollData:[JSON]? = []
    // ImageViews
    var imageViews: [UIImageView]? = []
    
    override func viewWillAppear(animated: Bool) {
//        println("viewWillAppear")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        println("viewDidAppear")
//        dispatch_async(dispatch_get_main_queue(),{
//            self.myBtnback.setTitle("起开", forState: UIControlState.Normal)
////            self.myBtnback.setTitleColor(<#color: UIColor?#>, forState: <#UIControlState#>)
//        })
    }
    override func loadView() {
        super.loadView()
        println("loadView")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
//        loadMainRequest()
        // Do any additional setup after loading the view.
        let url:NSURL = NSURL(string: "http://map.baidu.com/mobile/webapp/search/search/foo=bar&qt=s&wd=%E6%B4%BE%E5%87%BA%E6%89%80&c=218&searchFlag=more_cate&center_rank=1&nb_x=12725841.93&nb_y=3555105.60&da_src=indexnearbypg.nearby/center_name=%E6%88%91%E7%9A%84%E4%BD%8D%E7%BD%AE&vt=map")!
        var requrl:NSURLRequest = NSURLRequest(URL: url)
        myWebView.loadRequest(requrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadMainRequest()
    {
        var httpPara = HttpParamers().httpArrDescription()
        httpPara.updateValue("1000", forKey: "arr8")
        request(.GET, "http://app.youmsj.cn/", parameters: httpPara)
            .responseJSON { (request, response, json, error) -> Void in
                if (json != nil) {
                    let jsonObj = JSON(json!)
                    // ImgData
                    if let imgData = jsonObj["data"]["img"].arrayValue as [JSON]?{
                        self.imageScrollData = imgData
                        let pageCount = self.imageScrollData?.count
                        
                        // ScrollImageView
                        self.myScrollView!.contentSize = CGSizeMake(self.myScrollView.frame.size.width  * CGFloat(pageCount!), 0)
                        
                        // PageControl
                        self.myPageControl?.numberOfPages = pageCount!
                        
                        var indexImage = 0
                        for imageData in self.imageScrollData! {
                            var urlString = imageData["img"]
                            var imageView:UIImageView = UIImageView()
                            let imgurl = NSURL(string: urlString.stringValue)
                            var scrollFrame = self.myScrollView.bounds
                            scrollFrame.origin.x = scrollFrame.size.width * CGFloat(indexImage)
                            scrollFrame.origin.y = 0.0
                            imageView.frame = scrollFrame
                            dispatch_async(dispatch_get_main_queue(),{
                                imageView.hnk_setImageFromURL(imgurl!)
                                self.imageViews?.append(imageView)
                                self.myScrollView.addSubview(imageView)
                            })
                            
                            indexImage++
                        }
                    }
                    
                }
        }
        
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
