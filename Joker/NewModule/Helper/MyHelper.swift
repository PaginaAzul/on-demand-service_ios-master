//
//  MyHelper.swift
//  Joker
//
//  Created by mobulous on 21/05/21.
//  Copyright © 2021 Callsoft. All rights reserved.
//

import Foundation
import UIKit
struct MyHelper{
    //MARK:-Valid Period check
    static func isValidOfferPeriod (endDate:String) -> Bool{
        
        let nowD = Date()
        
       
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let currentD = formatter.string(from: nowD)
       
        
        let currentDate = convertFormatOfDate(date: currentD, originalFormat: "yyyy-MM-dd'T'HH:mm:ss.ssZ", destinationFormat: "yyyy-MM-dd'T'HH:mm:ss.ssZ")
        let offerEndDate = convertFormatOfDate(date: endDate, originalFormat: "yyyy-MM-dd'T'HH:mm:ss.ssZ", destinationFormat: "yyyy-MM-dd'T'HH:mm:ss.ssZ")
        print("currentDate",currentDate)
        print("offerEndDate",offerEndDate)
        
        let new_currentDate = convertFormatOfDate(date: currentD, originalFormat: "yyyy-MM-dd'T'HH:mm:ssZ", destinationFormat: "yyyy-MM-dd")
        let new_offerEndDate = convertFormatOfDate(date: endDate, originalFormat: "yyyy-MM-dd'T'HH:mm:ssZ", destinationFormat: "yyyy-MM-dd")
        
        print("currentD",currentD)
        print("endDate",endDate)
        print("new_currentDate",new_currentDate)
        
        
        print("new_offerEndDate",new_offerEndDate)
        
        
        if currentDate > offerEndDate{
            print("current Date is greater than end Date")
            return false
        }
        
        return true
    }
    
    static func isValidNewOfferPeriod (endDate:String) -> Bool{
        
        let nowD = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let currentD = formatter.string(from: nowD)
       
        
        let currentDate = convertFormatOfDate(date: currentD, originalFormat: "yyyy-MM-dd'T'HH:mm:ss.ssZ", destinationFormat: "yyyy-MM-dd'T'HH:mm:ss.ssZ")
        let offerEndDate = convertFormatOfDate(date: endDate, originalFormat: "yyyy-MM-dd'T'HH:mm:ss.ssZ", destinationFormat: "yyyy-MM-dd'T'HH:mm:ss.ssZ")
        print("currentDate",currentDate)
        print("offerEndDate",offerEndDate)
        
        let currentDate1 = formattedDateFromString(dateString: currentD, withFormat: "dd-MM-yyyy", originalFormat: "yyyy-MM-dd'T'HH:mm:ss.ssZ")
        let offerEndDate1 = formattedDateFromString(dateString: endDate, withFormat: "dd-MM-yyyy", originalFormat: "yyyy-MM-dd'T'HH:mm:ss.ssZ")
        print("currentDate1",currentDate1)
        print("offerEndDate1",offerEndDate1)
        

        
        if (currentDate1 ?? "") > (offerEndDate1 ?? "")
        {
            print("current Date is equal than end Date")
            return false
        }
        
        
        return true
    }
    static func convertFormatOfDate(date: String, originalFormat: String, destinationFormat: String) -> Date {
            
          
            let dateOriginalFormat = DateFormatter()
            dateOriginalFormat.dateFormat = originalFormat
            dateOriginalFormat.locale = Locale(identifier: "en_US_POSIX")
        // in the
            let dateDestinationFormat = DateFormatter()
            dateDestinationFormat.dateFormat = destinationFormat
            dateDestinationFormat.locale = Locale(identifier: "en_US_POSIX")
        // in the
            let dateFromString = dateOriginalFormat.date(from: date)
            
            return dateFromString ?? Date()
            
        }
    
    
    static func convertFormatOfDate1(date: String, originalFormat: String, destinationFormat: String) -> Date {
            
          
            let dateOriginalFormat = DateFormatter()
            dateOriginalFormat.dateFormat = originalFormat
            dateOriginalFormat.locale = Locale(identifier: "en_US_POSIX")
        // in the
            let dateDestinationFormat = DateFormatter()
            dateDestinationFormat.dateFormat = destinationFormat
            dateDestinationFormat.locale = Locale(identifier: "en_US_POSIX")
        // in the
            let dateFromString = dateOriginalFormat.date(from: date)
            
            return dateFromString ?? Date()
            
        }
    static func formattedDateFromString(dateString: String, withFormat format: String, originalFormat: String) -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = originalFormat

        if let date = inputFormatter.date(from: dateString) {

          let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = format

            return outputFormatter.string(from: date)
        }

        return nil
    }
    
    //MARK:- ValidTime check
    static func isValidTime (closingTime:String) -> Bool{
        //print("closingTime..........\(closingTime)")
        
        let closingTime1 = closingTime.split(separator: " ")
        print(closingTime1)
        let closingTime2 = closingTime1[0].split(separator: ":")
        print(closingTime2)
        var mins = 0
        var hours = Int(closingTime2[0]) ?? 0
        print(hours)
        let min = Int(closingTime2[1]) ?? 0
        print(min)
//        if closingTime1.count > 1
//        {
            if (closingTime1.count > 1) && (closingTime1[1] == "PM") {
                
                if closingTime2[0] == "12" {
                    mins = (hours * 60) + (min)
                    
                }
                else
                {
                    if hours > 12 {
                        hours = hours - 12
                        
                    }
                    mins = 12 * 60 + (hours * 60) + (min)
                }
            }
            else
            {
                mins = (hours * 60) + (min)
            }
//        }
//        else
//        {
//            mins = (hours * 60) + (min)
//        }
        
        print(mins)
        
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let currentDate = Date()
        dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss "
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let DateInFormat = dateFormatter.string(from: currentDate)
        
        print("\(DateInFormat) ")
        
        let closingTime1_Today = DateInFormat.split(separator: " ")
        print(closingTime1_Today)
        let closingTime2_Today = closingTime1_Today[0].split(separator: ":")
        print(closingTime2_Today)
        var mins_Today = 0
        let hours_Today = Int(closingTime2_Today[0]) ?? 0
        print(hours_Today)
        let min_Today = Int(closingTime2_Today[1]) ?? 0
        print(min)
        
        if closingTime1_Today[1] == "PM" {
            if closingTime2_Today[0] == "12" {
                mins_Today = (hours_Today * 60) + (min_Today)
                
            }
            else
            {
                mins_Today = 12 * 60 + (hours_Today * 60) + (min_Today)
            }
        }
        else
        {
            mins_Today = (hours_Today * 60) + (min_Today)
        }
        print(mins_Today)
        
        
        if mins < mins_Today {
            return false
        }
       
       return true
    }
    
    //MARK:- ValidTime check for 24 hours format
    static func isValidTime24HRS (closingTime:String) -> Bool{
        //print("closingTime..........\(closingTime)")
        
        
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let currentDate = Date()
        dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss "
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let DateInFormat = dateFormatter.string(from: currentDate)
        
        print("\(DateInFormat) ")
        
        
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = "HH:mm"

        let outFormatter = DateFormatter()
        outFormatter.locale = Locale(identifier: "en_US_POSIX")
        outFormatter.dateFormat = "hh:mm a"

        
        let date = inFormatter.date(from: closingTime)!
        let outStr = outFormatter.string(from: date)
        print(outStr) // -> outputs 04:50
        let closingDate = date
        print(closingDate)
        
        
        ////
//        let nowD = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "hh:mm a"
//        formatter.locale = Locale.current
//        let currentTime = formatter.string(from: nowD)
//        guard let currentDate = formatter.date(from: currentTime) else{return false}
//        let dateformat = DateFormatter()
//        dateformat.dateFormat = "hh:mm a"
//        dateformat.locale = Locale.current
//        guard let closingDate = dateformat.date(from: closingTime) else{return false}
        //print("currentDate..........\(currentDate)")
        if outStr > DateInFormat {
            return false
        }
//        if currentDate > closingDate{
//            return false
//        }
       
       return true
    }
    
    func convertDateFormat(inputDate: String) -> String {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

         let oldDate = olDateFormatter.date(from: inputDate)

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "MMM dd yyyy h:mm a"

         return convertDateFormatter.string(from: oldDate!)
    }
    
}
