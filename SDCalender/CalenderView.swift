//
//  ViewController.swift
//  SDCalender
//
//  Created by HelloMac on 16/7/4.
//  Copyright © 2016年 HelloMac. All rights reserved.
//

import UIKit

class CalenderView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    
    var date:NSDate!
    var weekArray:[String] = []
    
    //上次选中item的indexPath.row
    var lastItemIndex:Int?
    
    
   static func createView()-> AnyObject{
    
        return NSBundle.mainBundle().loadNibNamed("CalenderView", owner: nil, options: nil).last!;
    }

    override func awakeFromNib() {
        //当前时间
        date = NSDate()
        //星期日期排布
        weekArray = ["日","一","二","三","四","五","六"]
        
        //九宫格注册单元格
        collectionView .registerNib(UINib.init(nibName: "CalenderCell", bundle: nil), forCellWithReuseIdentifier: "CalenderCell")
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.allowsMultipleSelection = true
        //显示时间
        self.showLabelString(date)
        
        //设置九宫格
        self.setCollectionViewLayout()
    }
    /**
     上一个月
     
     - parameter sender: <#sender description#>
     */
    @IBAction func clickPreBtn(sender: AnyObject) {
        
        let dateComponents:NSDateComponents = NSDateComponents.init()
        dateComponents.month = -1;
        /*************之前把options设置为WrapComponents，结果年份始终为当前年份，设置为MatchStrictly正常********************/
        let newDate:NSDate = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: date, options: .MatchStrictly)!
        
        self.showLabelString(newDate)
        //把时间赋予当前date
        date = newDate;
        collectionView .reloadData()
    }
    /**
     下一个月
     
     - parameter sender: <#sender description#>
     */
    @IBAction func clickNextBtn(sender: AnyObject) {
        
        let dateComponents:NSDateComponents = NSDateComponents.init()
        dateComponents.month = +1;
        
        let newDate:NSDate = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: date, options: .MatchStrictly)!
        
        self.showLabelString(newDate)
        //把时间赋予当前date
        date = newDate;
        collectionView.reloadData()
    }
    
    /**
     九宫格的布局,把cell的大小和边距
     */
    func setCollectionViewLayout(){
    
       //屏幕的宽度
        let width:CGFloat = UIScreen.mainScreen().bounds.size.width
        let layOut:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layOut.itemSize = CGSizeMake(width / 7, width / 9)
        layOut.minimumLineSpacing = 0.0
        layOut.minimumInteritemSpacing = 0.0
        collectionView.setCollectionViewLayout(layOut, animated: true)
        
    }
    /**
     九宫格段数
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2;
    }
    /**
     九宫格cell个数
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return weekArray.count
        }else{
            
            if currentFirstDay(date) == 6{
                return currentMonthOfDays(date)
            }
            
            return currentMonthOfDays(date) + currentFirstDay(date) + 1
        }
    }
    /**
     数据加载
     
     - parameter collectionView: <#collectionView description#>
     - parameter indexPath:      <#indexPath description#>
     
     - returns: <#return value description#>
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:CalenderCell = collectionView.dequeueReusableCellWithReuseIdentifier("CalenderCell", forIndexPath: indexPath) as! CalenderCell
        cell.selected = false
        if indexPath.section == 0 {
            cell.timerLabel.text = weekArray[indexPath.row]
            cell.timerLabel.textColor = UIColor ( red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5 )
        }else{
        
           cell.timerLabel.textColor = UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5 )
            
            var allDayArray:[String] = []
            //首先前面的空格
            let day:Int = self.currentFirstDay(date) + 1
            
            //上个月总天数
            var OneI = 0
            if day  <= 6 {
                while OneI < day {
                    allDayArray.append("")
                    OneI += 1
                }
            }
            
            //中间的日历显示
            OneI = 1
            let days = self.currentMonthOfDays(date)
            while OneI <= days {
                allDayArray.append(String(OneI))
                OneI += 1
            }
            
//            //后面的空格
//            OneI = allDayArray.count
//            var netMonth = 1;
//            while OneI < (currentMonthOfDays(date)+currentFirstDay(date) + 1) {
//                allDayArray.append("")
//                OneI += 1
//                netMonth += 1;
//            }
            //数据加载
            cell.timerLabel.text = allDayArray[indexPath.row]
            
        }
        if indexPath.section == 1 {
            if indexPath.row%7==0||indexPath.row%7==6 {
                cell.timerLabel.textColor = UIColor.blueColor()
                
            }

        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    
        if indexPath.row%7==0||indexPath.row%7==6 || indexPath.row <= currentFirstDay(date){
            return false
        }
        
        return true;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("11111")
        
        if lastItemIndex < indexPath.row {
           
            while (indexPath.row - lastItemIndex!) != 0 {
                
                let indexpath:NSIndexPath = NSIndexPath.init(forItem: lastItemIndex!, inSection: indexPath.section)
                
                let  cell = collectionView.cellForItemAtIndexPath(indexpath) as! CalenderCell
                cell.backgroundColor = UIColor.cyanColor()
                lastItemIndex! += 1
            }
        }else{
            let  cell = collectionView.cellForItemAtIndexPath(indexPath) as! CalenderCell
            cell.backgroundColor = UIColor.cyanColor()
            lastItemIndex = indexPath.row
        
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
       
    }
    /**
     时间标签显示
     
     - parameter date: <#date description#>
     
     - returns: <#return value description#>
     */
    func showLabelString(date:NSDate){
    
        //显示出来年月
        showLabel.text = String(self.currentYear(date)) + "年" + String(self.currentMonth(date)) + "月"
    }
    /**
     *  获取当前的月的年份
     */
    func currentYear(date:NSDate)->Int{
    
        let componentsYear:NSDateComponents = NSCalendar.currentCalendar().components([.Year,.Month,.Day], fromDate: date)
        
        return componentsYear.year
    }
    /**
     *  获取当前的月的月份
     */
    func currentMonth(date:NSDate)->Int{
    
        let componentsYear:NSDateComponents = NSCalendar.currentCalendar().components([.Year,.Month,.Day], fromDate: date)
        
        return componentsYear.month
    }
    /**
     *  获取当前月的天数  今天是当前月几号
     */
    func currentDay(date:NSDate)->Int{
    
        let componentsYear:NSDateComponents = NSCalendar.currentCalendar().components([.Year,.Month,.Day], fromDate: date)
        
        return componentsYear.day
    }
    
    /**
     *  获取本月有几天
     */
    func currentMonthOfDays(date:NSDate)->Int{
    
        let totalDaysInMonth:NSRange = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date)
        return totalDaysInMonth.length
        
    }
    
    /**
     *  本月第一天是星期几
     */
    func currentFirstDay(date:NSDate)->Int{
    
        let calender:NSCalendar = NSCalendar.currentCalendar()
        calender.firstWeekday = 2
       
        let comp:NSDateComponents = calender.components([.Year,.Month,.Day], fromDate: date)
        comp.day = 1
        
        let  firstDayOfMonthDate = calender.dateFromComponents(comp)
        let firstWeekDay = calender.ordinalityOfUnit(NSCalendarUnit.Weekday, inUnit: NSCalendarUnit.WeekOfMonth, forDate: firstDayOfMonthDate!)
        
     return firstWeekDay - 1
    }
}
