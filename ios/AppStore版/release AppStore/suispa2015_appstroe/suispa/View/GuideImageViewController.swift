//
//  GuideImageViewController.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/1/31.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit

class GuideImageViewController: UIViewController {

    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var myPageControl: UIPageControl!
    
    
    let pageImages = [
        UIImage(named:"show1.png"),
        UIImage(named:"show2.png"),
        UIImage(named:"show3.png"),
        UIImage(named:"show4.png")
    ]
    var pageViews:[UIImageView?] = []
    
    var btn_Enter:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btn_Enter = loadBtnEnterView()
        // Do any additional setup after loading the view.
        
        loadGuideView()
    }
    
    override func viewDidAppear(animated: Bool) {
        myPageControl.hidden = true
    }

    
    func loadGuideView(){
        let pageCount = pageImages.count
        myPageControl.currentPage = 0
        myPageControl.numberOfPages = pageCount
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        let pagesScrollViewSize = myScrollView.frame.size
        myScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageImages.count), pagesScrollViewSize.height)
        loadVisiblePages()
    }
    
    func loadVisiblePages(){
        let pageWidth = myScrollView.frame.size.width
        let page = Int(floor((myScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        myPageControl.currentPage = page
        
        if page == pageImages.count - 1 {
            self.view.addSubview(btn_Enter!)
            myPageControl.hidden = true
        }else{
            myPageControl.hidden = false
            btn_Enter?.removeFromSuperview()
        }
        let firstPage = page - 1
        let lastPage = page + 1
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
        
    }
    
    func loadPage(page:Int) {
        if page < 0 || page >= pageImages.count {
            return
        }
        
        if let pageView = pageViews[page] {
        } else {
            var frame = myScrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.frame = frame
            myScrollView.contentSize = CGSizeMake(frame.size.width * 4, 0)
            myScrollView.addSubview(newPageView)
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page:Int) {
        if page < 0 || page >= pageImages.count {
            return
        }
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func loadBtnEnterView() -> UIButton {
        let btnEnter:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        let btnSelectedImg:UIImage = UIImage(named: "splash_btn1")!
        let btnNormalImg:UIImage = UIImage(named: "splash_btn2")!
        btnEnter.setImage(UIImage(named: "splash_btn1"), forState: UIControlState.Normal)
        btnEnter.setImage(UIImage(named: "splash_btn2"), forState: UIControlState.Selected)
        btnEnter.frame = CGRectMake(myScrollView.frame.size.width / 2 - 30.0, 370.0, 60.0, 60.0)
        
        btnEnter.addTarget(self, action: "btnEnterPress:", forControlEvents: UIControlEvents.TouchUpInside)
        return btnEnter
    }
    
    func btnEnterPress(sender:UIButton) -> Void{
        var mainVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_MainView) as! ViewController
        self.navigationController?.pushViewController(mainVC, animated: false)
//        self.view.removeFromSuperview()
    }
    
    func scrollViewDidScroll(scrollView:UIScrollView) {
        loadVisiblePages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
