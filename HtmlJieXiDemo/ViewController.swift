//
//  ViewController.swift
//  HtmlJieXiDemo
//
//  Created by lifeng on 16/8/24.
//  Copyright © 2016年 lifeng. All rights reserved.
//

import UIKit

class ViewController: UITableViewController{
    var url = "http://m.ttll.cc/index.php?s=vod-search"
    var key1:String = "s"
    var key2: String = "wd"
    
    var keyWord:String? = ""
    
    var data:[SearchResult] = [SearchResult]()
    
    @IBOutlet var tab: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = keyWord!
        
        print(keyWord!)
        
        loadData()
    }
    
    
    func loadData(){
        dispatch_async(dispatch_get_global_queue(0, 0), {
            self.post()
        })
    }
    
    
    func post(){
        
        let url:NSURL = NSURL(string: self.url)!
        
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        
        request.HTTPBody = "s=vod-search&wd=\(keyWord!)".dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let dataTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if(error != nil)
            {
                print("error")
                
            }else{
                //                print("\(data?.description)")
                let str:String = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
                //                print(str)
                self.readHtml(str)
                
            }
        })
        dataTask.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //解析
    func readHtml(html:String){
        do{
            let doc = try HTMLDocument(string: html, encoding: NSUTF8StringEncoding)
            for div in doc.css("div"){
                //                print(div["class"])
                if div["class"] == "list_info" {
                    
                    for h2 in div.css("h2"){
                        let a = h2.css("a").first
                        let href = a?.attr("href")
                        let title = a?.stringValue
                        print((href)!)
                        print((title)!)
                        let result: SearchResult = SearchResult(title: title!, link: href!)
                        data.append(result)
                        //                        print(h2.css("a"))
                    }
                    print(data.count)
                }
            }
            
                       //            print(divString)
            //            for link in doc.css("div"){
            ////                print(link.rawXML)
            //            }
            //
            //            if let elementById = doc.firstChild(css: "#id") {
            ////                print(elementById.stringValue)
            //            }
            //
            //            for link in doc.css("a, link") {
            ////                print(link.rawXML)
            ////                print(link["href"])
            //            }
            //
            //            // XPath queries
            //            if let firstAnchor = doc.firstChild(xpath:"//body/a") {
            ////                print(firstAnchor["href"])
            //            }
            //
            //            for  a in doc.xpath("//body/div"){
            ////                print(a["id"])
            //            }
            //
            //            for script in doc.xpath("//head/script") {
            ////                print(script["src"])
            //            }
            //
            //            // Evaluate XPath functions
            //            if let result = doc.eval(xpath: "count(/*/div)") {
            ////                print("anchor count : \(result.doubleValue)")
            //            }
            
            // Convenient HTML methods
            //            print(doc.title) // gets <title>'s innerHTML in <head>
            //            print(doc.head)  // gets <head> element
            //            print(doc.body)  //
            
        }catch let error as XMLError{
            
            print(error)
            
        }catch{
            print("catch final")
            
        }
        dispatch_async(dispatch_get_main_queue()) { 
            
            self.tab.reloadData()
        }
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("titleCell")
        cell?.textLabel?.text = data[indexPath.row].title
        
        return cell!
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        //click to do
//        let url = "http://m.ttll.cc\(data[indexPath.row].link)"
//        
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! SelectWorksTableViewController
        
        let indexPath = tab.indexPathForSelectedRow
        
        let url = "http://m.ttll.cc\(data[indexPath!.row].link)"
        
        vc.url = url
    }
    
    
}

