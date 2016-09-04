//
//  WebViewController.swift
//  HtmlJieXiDemo
//
//  Created by lifeng on 16/8/25.
//  Copyright © 2016年 lifeng. All rights reserved.
//

import UIKit

class WebViewController: UIViewController ,UIAlertViewDelegate{
    var link = "https://myunbo.duapp.com/player.php?vid=CNTc0NjcwNA==~2adcdbe7.acku"
    var url:String? = ""
    @IBOutlet weak var web: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadData()
    }
    func loadData(){
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            
            let nsUrl:NSURL = NSURL(string: self.url!)!
            
            let request: NSURLRequest = NSURLRequest(URL: nsUrl)
            
            let dataTask:NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                if error == nil{
                    
                    let string:String = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    
                    self.readHtml(string)
                    
                }else{
                    
                    print(error)
                    
                }
            }
            
            dataTask.resume()
        }
    }
    
    func readHtml(string:String){
        
        do{
            let doc = try HTMLDocument(string: string, encoding: NSUTF8StringEncoding)
            //            for iframe in doc.css("iframe"){
            //                print(iframe["src"])
            //            }
            
            if let iframe = doc.css("iframe").first {
                let url = (iframe["src"])!
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadUrl(url)
                })
            }else{
                //不支持在线播放的
                //                dispatch_async(dispatch_get_main_queue(), {
                //                    self.loadUrl(self.url!)
                //                })
                //                let alertView: UIAlertView = UIAlertView(title: "提示", message: "不支持在线播放的格式", delegate: self, cancelButtonTitle: "ok", otherButtonTitles: nil, nil, nil)
                dispatch_async(dispatch_get_main_queue(), {
                    let alertView:UIAlertView = UIAlertView(title: "提示", message: "不支持在线播放的格式", delegate: self, cancelButtonTitle: "ok")
                    alertView.show()
                    
                })
            }
            
            
        }catch{
            print("error")
        }
        
        
    }
    
    func loadUrl(url:String){
        let nsUrl: NSURL = NSURL(string: url)!
        let request: NSURLRequest = NSURLRequest(URL: nsUrl)
        web.loadRequest(request)
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
