//
//  CalendarVC.swift
//  HomeFudd
//
//  Created by Callsoft on 28/03/18.
//  Copyright © 2018 Mobulous. All rights reserved.
//

protocol calendarDateDelegate {
    func calendarDatePicker(date:String)
}

import UIKit
import FSCalendar

class CalendarVC: UIViewController {

    @IBOutlet weak var vwCalendar: FSCalendar!
    
    @IBOutlet weak var calendarToolBarView: UIView!
    
    @IBOutlet weak var datelbl: UILabel!
    
    @IBOutlet weak var lblYear: UILabel!
    
    var fsDate:Date?
    var currentPageDate:Date = Date()
    var year:Int = Int()
    var month:Int = Int()
    var calDelegate:calendarDateDelegate?
    var selectedDateStr = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async() {
            
            self.calendarToolBarView.setRoundCorners(.topRight, radius: 5)
            self.calendarToolBarView.setRoundCorners([.topLeft,.topRight], radius: 5)
            self.calendarToolBarView.clipsToBounds = true
        }
    }
    
    @IBAction func tap_previousBtn(_ sender: Any) {
        
        let date = Calendar.current.date(byAdding: .month, value: -1, to: fsDate!)
        vwCalendar.currentPage = date!
        currentPageDate = date!
        let calendar = Calendar.current
        year = calendar.component(.year, from: fsDate!)
        month = calendar.component(.month, from: fsDate!)
        setDate()
    }
    
    @IBAction func tap_nextBtn(_ sender: Any) {
        
        let date = Calendar.current.date(byAdding: .month, value: 1, to: fsDate!)
        vwCalendar.currentPage = date!
        currentPageDate = date!
        let calendar = Calendar.current
        year = calendar.component(.year, from: fsDate!)
        month = calendar.component(.month, from: fsDate!)
        setDate()
    }
    
    @IBAction func tap_closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_submitBtn(_ sender: Any) {
        
        if selectedDateStr == ""{
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy/MM/dd"
            let date = NSDate()
            selectedDateStr = dateFormatter1.string(from: date as Date)
            calDelegate?.calendarDatePicker(date: selectedDateStr)
            self.dismiss(animated: true, completion: nil)
            
        }
        else{
            calDelegate?.calendarDatePicker(date: selectedDateStr)
            self.dismiss(animated: true, completion: nil)
            
        }
    }
}

//MARK:- Custom method
//MARK:-
extension CalendarVC{
    
    func initialSetup(){
        
        currentPageDate = NSDate() as Date
        let calendar = Calendar.current
        year = calendar.component(.year, from: currentPageDate)
        month = calendar.component(.month, from: currentPageDate)
        setDate()
        vwCalendar.dataSource = self
        vwCalendar.delegate = self
        let today = Date()
        vwCalendar.currentPage = today
        
        
        
    }
    
    func setDate() {
        
        switch month {
            
        case 1:
            
            datelbl.text = "January "
            lblYear.text = String(describing: year)
            
        case 2:
            
            datelbl.text = "February "
            lblYear.text = String(describing: year)
            
        case 3:
            
            datelbl.text = "March "
            lblYear.text = String(describing: year)
            
        case 4:
            
            datelbl.text = "April "
            lblYear.text = String(describing: year)
            
        case 5:
            
            datelbl.text = "May "
            lblYear.text = String(describing: year)
            
        case 6:
            
            datelbl.text = "June "
            lblYear.text = String(describing: year)
            
        case 7:
            
            datelbl.text = "July "
            lblYear.text = String(describing: year)
            
        case 8:
            
            datelbl.text = "August "
            lblYear.text = String(describing: year)
            
        case 9:
            
            datelbl.text = "September "
            lblYear.text = String(describing: year)
            
        case 10:
            
            datelbl.text = "October "
            lblYear.text = String(describing: year)
            
        case 11:
            
            datelbl.text = "November "
            lblYear.text = String(describing: year)
            
        case 12:
            
            datelbl.text = "December "
            lblYear.text = String(describing: year)
            
        default:
            break
        }
    }
}

//MARK:- Calendar delegate
//MARK:-
extension CalendarVC:FSCalendarDelegate,FSCalendarDataSource{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy/MM/dd"
        selectedDateStr = dateFormatter1.string(from: date)
        
        if monthPosition == .previous || monthPosition == .next {
            
            calendar.setCurrentPage(date, animated: true)
        }
        
        print(selectedDateStr)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        let date = calendar.currentPage
        fsDate = calendar.currentPage
        let calendar = Calendar.current
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        setDate()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        fsDate = calendar.currentPage
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let currentDate = formatter.string(from: date)
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, hasEventFor date: Date) -> Bool {
        
        return true
    }
}


extension  UIView{
    func setRoundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
