//
//  ViewController.swift
//  jsonProject
//
//  Created by IST-MAC-16 on 4/28/2558 BE.
//  Copyright (c) 2558 MUT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var appsTableView : UITableView?
    var tableData = []
    
    override func viewDidLoad() {
        prefersStatusBarHidden()
        super.viewDidLoad()
        searchJson()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        cell.textLabel?.text = rowData["projectName"] as? String
        let urlString: NSString = "http://www.it.mut.ac.th/old/images/enrol/ist_logo.png"
        let imgURL: NSURL? = NSURL(string: urlString)
        let imgData = NSData(contentsOfURL: imgURL!)
        cell.imageView?.image = UIImage(data: imgData!)
        let studentname: NSString = rowData["studentName"] as NSString
        cell.detailTextLabel?.text = studentname
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
            var studentName: String = rowData["studentName"] as String
            var projectName: String = rowData["projectName"] as String
            var studentId: String = rowData["studentId"] as String
            var alert: UIAlertView = UIAlertView()
            alert.title = projectName
            alert.message = "รหัสนักศึกษา: \(studentId) ชื่อ: \(studentName)"
            alert.addButtonWithTitle("Ok")
            alert.show()
    }
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    func searchJson() {
            let urlPath = "http://54.191.102.248/sirawan/test2.php"
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                println("Task completed")
                if(error != nil) {
                    println(error.localizedDescription)
                }
                var err: NSError?
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                if(err != nil) {
                    println("JSON Error \(err!.localizedDescription)")
                }
                println(jsonResult);
                let results: NSArray = jsonResult["results"] as NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableData = results
                    self.appsTableView!.reloadData()
                })
            })
            task.resume() }
}

