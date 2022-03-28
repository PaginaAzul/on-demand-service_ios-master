//
//  MyOrderOnGoingHeaderView.swift
//  JustBite
//
//  Created by Aman on 16/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import UIKit


protocol  deleteHeader {
    func deleteOrder(_ tag:Int , message:String)
}

var timeLeftGLobal = "05:00"
class MyOrderOnGoingHeaderView: UIView {
    
    @IBOutlet weak var btnTap: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnCancelRef: UIButton!
    
    
    @IBOutlet weak var statusHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPendingStepper: UILabel!
    @IBOutlet weak var lblPendingStatus: UILabel!
    @IBOutlet weak var viewPToC: UIView!
    @IBOutlet weak var lblConfirmedStepper: UILabel!
    @IBOutlet weak var viewCToK: UIView!
    @IBOutlet weak var lblConfirmedStatus: UILabel!
    @IBOutlet weak var lblInTheKitchenStep: UILabel!
    @IBOutlet weak var lblInTheKitchenStatus: UILabel!
    @IBOutlet weak var viewIToO: UIView!
    @IBOutlet weak var lblOutForDeliverStepper: UILabel!
    @IBOutlet weak var lblOutForDeliveryStatus: UILabel!
    @IBOutlet weak var statusLbl: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var stpperView: UIView!
    
    
    @IBOutlet weak var imgConfirmed: UIImageView!
    @IBOutlet weak var imgInKitchen: UIImageView!
    @IBOutlet weak var imgOutForDelivery: UIImageView!
    @IBOutlet weak var imgDelivered: UIImageView!
    
    
    
    var deleteHeaderDelegate:deleteHeader?
    var viewModel = ViewModel()
    
    var count = 300
    var timer:Timer?
    var timeLeft = Int()
    var selectedTab = Int()
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    func setRound(){
        imgConfirmed.layer.cornerRadius = imgConfirmed.frame.height/2
        imgInKitchen.layer.cornerRadius = imgConfirmed.frame.height/2
        imgOutForDelivery.layer.cornerRadius = imgConfirmed.frame.height/2
        imgDelivered.layer.cornerRadius = imgConfirmed.frame.height/2
    }
    
    var item : DataGetOrder? {
        didSet {
            setRound()
            if item?.isSelected == true{
                
                btnTap.setImage(#imageLiteral(resourceName: "up_arrow"), for: .normal)
            }else{
                btnTap.setImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)
                
            }
            
            callForDateTime()
            
            lblTitle.attributedText = CommonClass.sharedInstance.attributedStringOfferNew(title: item?.sellerData?.name ?? "", subTitle: "\("Order Id".localized()) : \(item?.orderNumber ?? "")", subTitle2: self.fetchData(dateToConvert: item?.createdAt ?? ""), delemit: "\n", sizeTitle: 16, sizeSubtitle2: 12, sizeSubtitle: 15, titleColor: AppColor.textColor, SubtitleColor: UIColor.black, SubtitleColor2: UIColor.darkGray)
            
           // lblTime.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: "04:30", subTitle: "", delemit: " ", sizeTitle: 13, sizeSubtitle: 13, titleColor: AppColor.themeColor, SubtitleColor: AppColor.themeColor)
            
            imgView.setImage(withImageId: item?.sellerData?.image ?? "", placeholderImage: #imageLiteral(resourceName: "food_icon"))
            
            statusHeight.constant = 0.0
            lblPendingStepper.isHidden = true
            lblConfirmedStepper.isHidden = true
            lblInTheKitchenStep.isHidden = true
            lblOutForDeliverStepper.isHidden = true
            stpperView.isHidden = true
            
            CommonClass.sharedInstance.provideCustomCornarRadius(btnRef: btnCancelRef, radius: 3)
            
            lblTime.isHidden = false
            btnCancelRef.isHidden = false
            
            btnCancelRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnCancelRef.setTitleColor(AppColor.whiteColor, for: .normal)
            btnCancelRef.backgroundColor = AppColor.themeColor
            btnCancelRef.setTitle("Cancel".localized(), for: .normal)
            
            CommonClass.sharedInstance.provideCustomCornarRadius(btnRef: btnCancelRef, radius: 5)
            statusLbl.isHidden = false
            
            /// Start **** Formatter
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            formatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone?
            /// Formatter **** End
            
            /// Start **** CreatedAt Date
            let createdAt = formatter.date(from: item?.createdAt ?? "") as? Date ?? Date()
            /// CreatedAt Date **** End
            
            /// Start **** Currnet Date string
            var curr_time = Date()
            curr_time = Date().addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
            let curr_time_string = formatter.string(from: curr_time)
            print(curr_time_string)
            /// Currnet Date string **** End
            
            /// Start **** Currnet Date Date
            curr_time = formatter.date(from: curr_time_string) as? Date ?? Date()
            /// Currnet Date Date **** End
            
            print(curr_time.timeAgoSinceDate(date: createdAt as NSDate, numericDates: false))
            //lblTime.text = curr_time.timeAgoSinceDate(date: createdAt as NSDate, numericDates: false)
            
            /// Start **** End Date Date
            var end_time = formatter.date(from: item?.createdAt ?? "") as? Date ?? Date()
            
            /// End Date Date **** End
            var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
            // -7200
            
            end_time.addTimeInterval(TimeInterval(secondsFromGMT + 300))
            
            if curr_time.compare(end_time) == .orderedSame {
                print("Both dates are same")
                stopTimer()
                
            }else if curr_time.compare(end_time) == .orderedAscending {
                
                print("curr_time is smaller then end_time")
               // stopTimer()
                
                let calendar = Calendar.current
                let components = calendar.dateComponents([.second], from: curr_time, to: end_time)
                //START---->Count
                
                if let seconds = components.second{
                    print("seconds",seconds )
                    btnCancelRef.isHidden = false
                    lblTime.isHidden = false
                   // lblTime.text = timeLeftGLobal
                    timeLeft = seconds
                    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
                }
                
                //Count<----END
                
            }else if curr_time.compare(end_time) == .orderedDescending {
                print("curr_time is greater then end_time")
                stopTimer()
            }
        }
    }
    


    
    var itemOnGoing : DataGetOrder? {
        didSet {
            setRound()
            callForDateTime()
            if itemOnGoing?.isSelected == true{
                
                statusHeight.constant = 70.0
                btnTap.setImage(#imageLiteral(resourceName: "up_arrow"), for: .normal)
                
                lblPendingStepper.isHidden = false
                lblConfirmedStepper.isHidden = false
                lblInTheKitchenStep.isHidden = false
                lblOutForDeliverStepper.isHidden = false
                stpperView.isHidden = false
                
            }else{
                
                btnTap.setImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)
                statusHeight.constant = 0.0
                lblPendingStepper.isHidden = true
                lblConfirmedStepper.isHidden = true
                lblInTheKitchenStep.isHidden = true
                lblOutForDeliverStepper.isHidden = true
                stpperView.isHidden = true
            }
          //  \(itemOnGoing?.deliveryDate ?? "") 20:15PM
            lblTitle.attributedText = CommonClass.sharedInstance.attributedStringOfferNew(title: itemOnGoing?.sellerData?.name ?? "", subTitle: "\("Order Id".localized()) : \(itemOnGoing?.orderNumber ?? "")", subTitle2: self.fetchData(dateToConvert: itemOnGoing?.createdAt ?? ""), delemit: "\n", sizeTitle: 16, sizeSubtitle2: 12, sizeSubtitle: 15, titleColor: AppColor.textColor, SubtitleColor: UIColor.black, SubtitleColor2: UIColor.darkGray)
            
           // lblTime.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: "04:30", subTitle: "", delemit: " ", sizeTitle: 13, sizeSubtitle: 13, titleColor: AppColor.themeColor, SubtitleColor: AppColor.themeColor)
            
            imgView.setImage(withImageId: itemOnGoing?.sellerData?.image ?? "", placeholderImage: #imageLiteral(resourceName: "food_icon"))
            
            btnCancelRef.isHidden = true
            btnCancelRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnCancelRef.setTitleColor(AppColor.whiteColor, for: .normal)
            btnCancelRef.backgroundColor = AppColor.themeColor
            btnCancelRef.setTitle("Cancel", for: .normal)
            
            CommonClass.sharedInstance.provideCustomCornarRadius(btnRef: btnCancelRef, radius: 3)
            
            lblPendingStepper.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 10.0)!
            lblPendingStepper.textColor = AppColor.whiteColor
            lblPendingStepper.backgroundColor = AppColor.themeColor
            CommonClass.sharedInstance.provideCornarRadius(btnRef: lblPendingStepper)
            lblPendingStepper.text = "1"
            
            
            lblConfirmedStepper.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 10.0)!
            lblConfirmedStepper.textColor = AppColor.whiteColor
            lblConfirmedStepper.backgroundColor = AppColor.themeColor
            CommonClass.sharedInstance.provideCornarRadius(btnRef: lblConfirmedStepper)
            lblConfirmedStepper.text = "2"
            
            lblInTheKitchenStep.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 10.0)!
            lblInTheKitchenStep.textColor = AppColor.whiteColor
            lblInTheKitchenStep.backgroundColor = AppColor.themeColor
            CommonClass.sharedInstance.provideCornarRadius(btnRef: lblInTheKitchenStep)
            lblInTheKitchenStep.text = "3"
            
            lblOutForDeliverStepper.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 10.0)!
            lblOutForDeliverStepper.textColor = AppColor.whiteColor
            lblOutForDeliverStepper.backgroundColor = AppColor.themeColor
            CommonClass.sharedInstance.provideCornarRadius(btnRef: lblOutForDeliverStepper)
            lblOutForDeliverStepper.text = "4"
            
            lblPendingStatus.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 10.0)!
            lblPendingStatus.textColor = AppColor.themeColor
            lblPendingStatus.text = "Confirmed".localized()
            
            lblConfirmedStatus.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 10.0)!
            lblConfirmedStatus.textColor = AppColor.themeColor
            lblConfirmedStatus.text = "In the Kitchen".localized()
            
            lblInTheKitchenStatus.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 10.0)!
            lblInTheKitchenStatus.textColor = AppColor.themeColor
            lblInTheKitchenStatus.text = "Out for Delivery".localized()
            
            lblOutForDeliveryStatus.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 10.0)!
            lblOutForDeliveryStatus.textColor = AppColor.themeColor
            lblOutForDeliveryStatus.text = "Delivered".localized()
            
            viewPToC.backgroundColor = AppColor.themeColor
            viewCToK.backgroundColor = AppColor.themeColor
            viewIToO.backgroundColor = AppColor.themeColor

        }
    }
    
    @objc func onTimerFires() {
        lblTime.isHidden = false
        btnCancelRef.isHidden = false

        timeLeft -= 1
        
        printSecondsToHoursMinutesSeconds(seconds: timeLeft)
        
        if timeLeft <= 0 {
            updateCancelStatus()
            stopTimer()
            
            print("Timer Has been finished->")
            
        }
    }
    
    func stopTimer(){
        print("Timer Has been finished->")
        timer?.invalidate()
        timer = nil
        btnCancelRef.isHidden = true
        lblTime.isHidden = true
        timeLeft = Int()
                
    }
    
    func printSecondsToHoursMinutesSeconds (seconds:Int) -> () {
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds: seconds)
        print ("\(h) Hours, \(m) Minutes, \(s) Seconds")
        
        if s>9{
            lblTime.text = "0\(m):\(s)"
            timeLeftGLobal = "0\(m):\(s)"

        }else{
            lblTime.text = "0\(m):0\(s)"
            timeLeftGLobal = "0\(m):0\(s)"

        }
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    @IBAction func btnOrderCancel(_ sender: UIButton) {
        
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
    
        let param = ["userId" : UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                     "orderId": item?.Id ?? 0 ,
                     "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]  as [String : Any]
        
        
        
        viewModel.cancelOrderAPI(Domain.baseUrl().appending(APIEndpoint.cancelOrderByUser), param, header)
        closureSetup()

    }
    
}

extension MyOrderOnGoingHeaderView {
    
    func callForDateTime(){
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
    }
    
    func fetchData(dateToConvert:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let pendingDate = dateFormatter.date(from: dateToConvert)!
        let sendTime = self.dateFormatterForTime.string(from: pendingDate)
        let sendDate = self.dateFormatterForDate.string(from: pendingDate)
        
        print("sendTime-->" , sendTime ,sendDate , dateToConvert , pendingDate  )
        
        return "\(sendDate) \(sendTime)"
    }

    
    func updateCancelStatus(){
         
         let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
         
     
         let param = ["userId" : UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                      "orderId": item?.Id ?? 0] as [String : Any]
         
        
        print(param,header )
        
         viewModel.updateCancelStatusAPI(Domain.baseUrl().appending(APIEndpoint.updateCancelStatus), param, header)
     }
    
    func closureSetup(){
        
        /*
        viewModel.reloadList = {() in
            
            self.deleteHeaderDelegate?.deleteOrder(self.selectedTab)
        }
       */
        
        
        viewModel.success = { (message) in
            
            self.deleteHeaderDelegate?.deleteOrder(self.selectedTab, message: message)

        }
        
    }
    
    
}

extension Date{
    func getTimeComponentString(olderDate older: Date,newerDate newer: Date) -> (String?)  {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        
        let componentsLeftTime = Calendar.current.dateComponents([.minute , .hour , .day,.month, .weekOfMonth,.year], from: older, to: newer)
        
        let year = componentsLeftTime.year ?? 0
        if  year > 0 {
            formatter.allowedUnits = [.year]
            return formatter.string(from: older, to: newer)
        }
        
        
        let month = componentsLeftTime.month ?? 0
        if  month > 0 {
            formatter.allowedUnits = [.month]
            return formatter.string(from: older, to: newer)
        }
        
        let weekOfMonth = componentsLeftTime.weekOfMonth ?? 0
        if  weekOfMonth > 0 {
            formatter.allowedUnits = [.weekOfMonth]
            return formatter.string(from: older, to: newer)
        }
        
        let day = componentsLeftTime.day ?? 0
        if  day > 0 {
            formatter.allowedUnits = [.day]
            return formatter.string(from: older, to: newer)
        }
        
        let hour = componentsLeftTime.hour ?? 0
        if  hour > 0 {
            formatter.allowedUnits = [.hour]
            return formatter.string(from: older, to: newer)
        }
        
        let minute = componentsLeftTime.minute ?? 0
        if  minute > 0 {
            formatter.allowedUnits = [.minute]
            return formatter.string(from: older, to: newer) ?? ""
        }
        
        return nil
    }
    
    
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) \(ConstantTexts.yearAgoLT)"
        } else if (components.year! >= 1){
            if (numericDates){
                return "\(ConstantTexts.yearAgo1LT)"
            } else {
                return "\(ConstantTexts.last_yearLT)"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) \(ConstantTexts.monthsAgoLT)"
        } else if (components.month! >= 1){
            if (numericDates){
                return "\(ConstantTexts.monthAgo1LT)"
            } else {
                return "\(ConstantTexts.last_monthLT)"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) \(ConstantTexts.weeksAgoLT)"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "\(ConstantTexts.weekAgo1LT)"
            } else {
                return "\(ConstantTexts.last_weekLT)"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) \(ConstantTexts.daysAgoLT)"
        } else if (components.day! >= 1){
            if (numericDates){
                return "\(ConstantTexts.dayAgo1LT)"
            } else {
                return "\(ConstantTexts.last_dayLT)"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) \(ConstantTexts.hoursAgoLT)"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "\(ConstantTexts.hourAgo1LT)"
            } else {
                return "\(ConstantTexts.last_hourLT)"
            }
        } else if (components.minute! >= 2) {
//            return "\(components.minute!) \(ConstantTexts.minutesAgoLT)"
            return "\(components.minute!)"

            
        } else if (components.minute! >= 1){
            if (numericDates){
               // return "\(ConstantTexts.minutes1LT)"
                return ""
            } else {
//                return "\(ConstantTexts.last_minuteLT)"
                return ""
            }
        } else if (components.second! >= 3) {
            return "\(components.second!)"

//            return "\(components.second!) \(ConstantTexts.secondsAgoLT)"
        } else {
            return ""

//            return "\(ConstantTexts.last_secondLT)"
        }
        
    }
   
    
}

struct ConstantTexts{
    static let yearAgoLT                            =       "years ago"
    static let yearAgo1LT                           =       "1 year ago"
    static let last_yearLT                          =       "Last year"
    
    static let monthsAgoLT                          =       "months ago"
    static let monthAgo1LT                          =       "1 month ago"
    static let last_monthLT                         =       "Last month"
    
    static let weeksAgoLT                           =       "weeks ago"
    static let weekAgo1LT                           =       "1 week ago"
    static let last_weekLT                          =       "Last week"
    
    static let daysAgoLT                            =       "days ago"
    static let dayAgo1LT                            =       "1 day ago"
    static let last_dayLT                           =       "Yesterday"
    
    static let hoursAgoLT                           =       "hours ago"
    static let hourAgo1LT                           =       "1 hour ago"
    static let last_hourLT                          =       "An hour ago"
    
    static let minutesAgoLT                         =       "minutes ago"
    static let minutes1LT                           =       "1 minute ago"
    static let last_minuteLT                        =       "A minute ago"
    
    static let secondsAgoLT                         =       "seconds ago"
    static let last_secondLT                        =       "Just now"
}

