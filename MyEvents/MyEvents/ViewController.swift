//
//  ViewController.swift
//  MyEvents
//
//  Created by Tianqi Chen on 5/10/16.
//  Copyright © 2016 Tianqi Chen. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var json_data_url = "https://raw.githubusercontent.com/Tianqi0616/Whova/master/myfile.json"
    
    var TableData:Array< datastruct > = Array < datastruct >()
    
    enum ErrorHandler:ErrorType
    {
        case ErrorFetchingResults
    }
    
    
    struct datastruct
    {
        var eventid:String?
        var imageurl:String?
        var name:String?
        var location:String?
        var date:String?
        var logo:UIImage? = nil
        
        init(add: NSDictionary)
        {
            eventid = add["eventid"] as? String
            imageurl = add["logo"] as? String
            name = add["name"] as? String
            location = add["location"] as? String
            date = add["date_str"] as? String
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        get_data_from_url(json_data_url)
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MyCell
        
        let data = TableData[indexPath.row]
        
        load_image(data.imageurl!, imageview: cell.photo!, index: indexPath.row)
        cell.name.text = data.name
        cell.date_var.text = data.date
        cell.location.text = data.location
        cell.calendar.image = UIImage(named: "calendar")
        cell.loc.image = UIImage(named: "map")
        
        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return TableData.count
    }
    
    
    
    func get_data_from_url(url:String)
    {
        let url:NSURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.extract_json(data!)
                return
            })
            
        }
        
        task.resume()
    }
    
    
    func extract_json(jsonData:NSData)
    {
        let json: NSDictionary?
        do {
            json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
        } catch {
            json = nil
            return
        }

        
        if let list = json!["result"]!["events"]! as? NSArray
        {
            for (var i = 0; i < list.count ; i++ )
            {
                if let data_block = list[i] as? NSDictionary
                {
                    TableData.append(datastruct(add: data_block))
                }
                
            }
            do_table_refresh()
            
        }
        
        
    }
    
    
    
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    
    func load_image(urlString:String, imageview:UIImageView, index:NSInteger)
    {
        
        let url:NSURL = NSURL(string: urlString)!
        let session = NSURLSession.sharedSession()
        
        let task = session.downloadTaskWithURL(url) {
            (
            let location, let response, let error) in
            
            guard let _:NSURL = location, let _:NSURLResponse = response  where error == nil else {
                print("error_img")
                return
            }
            
            let imageData = NSData(contentsOfURL: location!)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                
                self.TableData[index].logo = UIImage(data: imageData!)
                //self.save(index,image: self.TableData[index].logo!)
                
                imageview.image = self.TableData[index].logo
                //cell.photo.image = self.TableData[index].logo
                
                return
            })
            
            
        }
        
        task.resume()
        
        
    }
    

}

