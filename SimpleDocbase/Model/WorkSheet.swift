//
//  WorkSheet.swift
//  SimpleDocbase
//
//  Created by Lee jaeeun on 2017/11/10.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

//enum WeekDay: Int {
//    case Sun
//    case Mon
//    case Tue
//    case Wed
//    case Thu
//    case Fri
//    case Sat
//}

struct WorkSheet {
    var workdate: Date?
    var workTimeSum: Double?
    var workDaySum: Int?
    var items: [WorkSheetItem]?
    
    init(date: Date) {
        self.workdate = date
        self.workTimeSum = 0
        self.workDaySum = 0
        
        self.items = [WorkSheetItem]()
    }
    
    init(dict: Dictionary<String, Any>) {
        
        if let workdate = dict["workdata"] as? Date {
            self.workdate = workdate
        }
        
        if let workTimeSum = dict["workTimeSum"] as? Double {
            self.workTimeSum = workTimeSum
        }
        
        if let workDaySum = dict["workDaySum"] as? Int {
            self.workDaySum = workDaySum
        }
        
        if let items = dict["items"] as? Array<Dictionary<String, Any>> {
            self.items = [WorkSheetItem]()
            
            for item in items {
                let sheet = WorkSheetItem(dict: item)
                
                self.items?.append(sheet)
            }
        }
    }
}

struct WorkSheetItem {
    var workYear: Int?      /// yyyy
    var workMonth: Int?     /// mm
    var workDay: Int?       /// dd
    var workFlag: Bool?
    var week: Int?
    var beginTime: Date?
    var endTime: Date?
    var breakTime: Double?
    var duration: Double?
    var remark: String?
    
    init(dict: Dictionary <String, Any>) {
        
        if let workYear = dict["workYear"] as? Int {
            self.workYear = workYear
        }else {
            
        }
        
        if let workMonth = dict["workMonth"] as? Int {
            self.workMonth = workMonth
        }
        
        if let workDay = dict["workDay"] as? Int {
            self.workDay = workDay
        }
        
        if let workFlag = dict["workFlag"] as? Bool {
            self.workFlag = workFlag
        }
        
        if let week = dict["week"] as? Int {
            self.week = week
        }
        
        if let beginTime = dict["beginTime"] as? Date {
            self.beginTime = beginTime
        }
        
        if let endTime = dict["endTime"] as? Date {
            self.endTime = endTime
        }
        
        if let breakTime = dict["breakTime"] as? Double {
            self.breakTime = breakTime
        }
        
        if let duration = dict["duration"] as? Double {
            self.duration = duration
        }
        
        if let remark = dict["remark"] as? String {
            self.remark = remark
        }
    }
    
    init(year: Int, month: Int, day: Int) {
        self.workYear = year
        self.workMonth = month
        self.workDay = day
        
        if let workDate = Date.createDate(year: year, month: month, day: day) {
            self.week = workDate.weekDay()
            self.workFlag = !workDate.isHoliday()
        }
    }
}
