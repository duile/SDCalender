//
//  ViewController.swift
//  SDCalender
//
//  Created by HelloMac on 16/7/4.
//  Copyright © 2016年 HelloMac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let  date = NSDate()
        
        let componentsYear:NSDateComponents = NSCalendar.currentCalendar().components([.Year,.Month,.Day], fromDate: date)
        print(componentsYear.year)
        print(componentsYear.month)
        print(componentsYear.day)
        //2016年7月5号
        
        //本月总天数
        let totalDays:NSRange = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: NSCalendarUnit.Month, forDate: date)
        print(totalDays.length)
        
        let calender:NSCalendar = NSCalendar.currentCalendar()
        calender.firstWeekday = 2
        
        let comp:NSDateComponents = calender.components([.Year,.Month,.Day], fromDate: date)
        comp.day = 1
        let firstDay = calender.dateFromComponents(comp)
        let firstWeekDay = calender.ordinalityOfUnit(NSCalendarUnit.Weekday, inUnit: NSCalendarUnit.WeekOfMonth, forDate: firstDay!)
        
        print(firstWeekDay - 1)
        
        let showView:CalenderView = CalenderView.createView() as! CalenderView
        showView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height/2 + 30)
        self.view.addSubview(showView)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

