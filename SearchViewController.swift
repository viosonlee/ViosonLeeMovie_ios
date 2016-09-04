//
//  SearchViewController.swift
//  HtmlJieXiDemo
//
//  Created by lifeng on 16/8/25.
//  Copyright © 2016年 lifeng. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var commit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        input.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc:ViewController = segue.destinationViewController as! ViewController
        
        let kw:String = input.text!
//        print(kw)
        vc.keyWord = kw
    }
    
     func textFieldShouldReturn(textField: UITextField) -> Bool{
        input.resignFirstResponder()
        return true
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
