//
//  SelectWorksTableViewController.swift
//  HtmlJieXiDemo
//
//  Created by lifeng on 16/8/25.
//  Copyright © 2016年 lifeng. All rights reserved.
//

import UIKit

class SelectWorksTableViewController: UITableViewController {
    
    var url:String!
    var data = [SearchResult]()
    @IBOutlet var works: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(url)
        loadData()
    }
    
    func loadData(){
        
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.get()
        }
        
        
        
        
    }
    func get(){
        
        let nsurl: NSURL = NSURL(string: url)!
        
        let request: NSURLRequest = NSURLRequest(URL: nsurl)
        
        let dataTask:NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            if(error==nil){
                
                let string:String = NSString(data: data!, encoding: NSUTF8StringEncoding) as String!
                self.readHtml(string)
                
            }else{
                print(error)
            }
        }
        dataTask.resume()
    }
    
    
    func readHtml(string:String){
        do{
            let doc = try HTMLDocument(string: string, encoding: NSUTF8StringEncoding)
            for ul in doc.css("ul"){
                if ul["class"] == "plau-ul-list" {
                    for li in ul.css("li"){
                        let title = (li.css("a").first?.stringValue)!
                        let link = (li.css("a").first!["href"])!
                        if !link.hasPrefix("thunder") {
                            let result:SearchResult = SearchResult(title: title, link: link)
                            data.append(result)
                            print(link)
                        }
                        
                    }
                }
            }
            
        }catch{
            print("error")
            
        }
        
        
        self.works.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    // MARK: - Table view data source
    //
    //    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("workCell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = data[indexPath.row].title
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc: WebViewController = segue.destinationViewController as! WebViewController
        
        let url = "http://m.ttll.cc\(data[(works.indexPathForSelectedRow?.row)!].link)"
        
        vc.url = url
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
