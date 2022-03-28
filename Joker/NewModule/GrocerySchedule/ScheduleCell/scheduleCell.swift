//
//  scheduleCell.swift
//  Joker
//
//  Created by User on 05/01/21.
//  Copyright © 2021 Callsoft. All rights reserved.
//

import UIKit

protocol ReloadTablePro{
    
    func reloadProStatus(_ tag:Int)
    
}

protocol GetTimeProtocol {
    
    func getSlotAndTime(_ slot:String , time:String )

}

protocol Reflected {
    
    func reflectedStatus(_ yes:Bool)

}

class scheduleCell: UITableViewCell {
    
    @IBOutlet weak var scheduleColl:UICollectionView!
    @IBOutlet weak var lblNoSlots:UILabel!
    
    var morningSlotArr = [String]()
    var afterSlotArr = [String]()
    var eveningSlotArr = [String]()
    var selectedIndex = Int ()
    var isSelectedCell = false
    var selection = Bool()
    var reflected:Reflected?
    var reloadTableDelegate:ReloadTablePro?
    var getTimeDelegat:GetTimeProtocol?
    var slotIndex = Int()
    var selectedTime = String()
    //var getSlotTime:getGroceryPlaceOrderProtocol?

    var section:Int?
    
    var selectedAfterNoonSlot = Bool()
    var selectedMorningSlot = Bool()
    var selectedEveningSlot = Bool()

    var itemSchedule = [GetDeliverySlotBaseModel]()
    {
        didSet{
            
            morningSlotArr.removeAll()
            afterSlotArr.removeAll()
            eveningSlotArr.removeAll()

            for i in 0..<(itemSchedule.first?.Data?.count ?? 0){
                
                if itemSchedule[0].Data?[i].timeSlot == "Morning" {

                    morningSlotArr.append("\(itemSchedule.first?.Data?[i].openTime ?? "") - \(itemSchedule[0].Data?[i].closeTime ?? "")")

                }else if itemSchedule[0].Data?[i].timeSlot == "Afternoon"{
                    afterSlotArr.append("\(itemSchedule.first?.Data?[i].openTime ?? "") - \(itemSchedule[0].Data?[i].closeTime ?? "")")


                }else if itemSchedule[0].Data?[i].timeSlot == "Evening"{

                    eveningSlotArr.append("\(itemSchedule.first?.Data?[i].openTime ?? "") - \(itemSchedule[0].Data?[i].closeTime ?? "")")

                }
            }

            scheduleColl.register(UINib(nibName: "scheduleCollCell", bundle: nil), forCellWithReuseIdentifier: "scheduleCollCell")
            
            scheduleColl.delegate = self
            scheduleColl.dataSource = self

            
            if selectedMorningSlot{
                section = 0

                for i in 0..<morningSlotArr.count
                {
                    if self.selectedTime == morningSlotArr[i]
                    {
                        selection = true
                        selectedIndex = i

                        if isSelectedCell == false {
                            isSelectedCell = true
                        }else{
                            isSelectedCell = false

                        }

                       // reloadTableDelegate?.reloadProStatus(0)

                        getTimeDelegat?.getSlotAndTime("Morning", time: morningSlotArr[i])

                        break;
                    }
                }
            }
            

            if selectedAfterNoonSlot {
                section = 1

                for i in 0..<afterSlotArr.count
                {
                    if self.selectedTime == afterSlotArr[i]{
                        selection = true
                            if isSelectedCell == false {
                                isSelectedCell = true
                            }else{
                                isSelectedCell = false

                            }
                            selectedIndex = i
                           // reloadTableDelegate?.reloadProStatus(1)

                            getTimeDelegat?.getSlotAndTime("Afternoon", time: afterSlotArr[i])

                        break;
                    }
                }
            }
            
            if selectedEveningSlot{
                section = 2
                for i in 0..<eveningSlotArr.count {

                    if self.selectedTime == eveningSlotArr[i]{
                        selection = true
                        if isSelectedCell == false {
                            isSelectedCell = true
                        }else{
                            isSelectedCell = false
                        }

                        selectedIndex = i

                       // reloadTableDelegate?.reloadProStatus(2)

                        getTimeDelegat?.getSlotAndTime("Evening", time: eveningSlotArr[i] )

                        break;
                    }
                }
            }
            
            scheduleColl.reloadData()

            print("All slots Count",morningSlotArr.count, afterSlotArr.count,eveningSlotArr.count)

                        
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblNoSlots.text = "No slots available".localized()
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionLayout.scrollDirection = .horizontal
        
        let yourWidth = scheduleColl.bounds.width/2.0
        let yourHeight = yourWidth
        
        collectionLayout.itemSize = CGSize(width: yourWidth - 5 , height: 50)
        
        scheduleColl.collectionViewLayout = collectionLayout
        collectionLayout.minimumInteritemSpacing = 2
        collectionLayout.minimumLineSpacing = 5
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


extension scheduleCell : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 0 {
                        
            return morningSlotArr.count
            
        }else if collectionView.tag == 1 {
            
            return afterSlotArr.count
            
        }else if collectionView.tag == 2{
            
            return eveningSlotArr.count
            
        }
        return 0

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scheduleCollCell", for: indexPath) as! scheduleCollCell
        
        if section == 0 {
            
            if selection {
                
                if selectedIndex == indexPath.row && isSelectedCell == true
                {
                    isSelectedCell = false

                    cell.lblSlotTime.textColor = AppColor.whiteColor
                    cell.mainView.backgroundColor = AppColor.themeColor
                }
                else
                {
                    cell.lblSlotTime.textColor = AppColor.textColor
                    cell.mainView.backgroundColor = UIColor.white
                }
                
            }
            
            if morningSlotArr.count > 0 {
                if indexPath.row < morningSlotArr.count {
                    cell.timingItem = morningSlotArr[indexPath.row]

                }
            }
            
        }else if section == 1 {
            
            if selection {
                
                if selectedIndex == indexPath.row && isSelectedCell == true
                {

                    cell.lblSlotTime.textColor = AppColor.whiteColor
                    cell.mainView.backgroundColor = AppColor.themeColor
                    isSelectedCell = false
                }
                else
                {
                    cell.lblSlotTime.textColor = AppColor.textColor
                    cell.mainView.backgroundColor = UIColor.white
                }
            }
            
            if afterSlotArr.count > 0 {
                
                if indexPath.row < afterSlotArr.count {
                    cell.timingItem = afterSlotArr[indexPath.row]

                }

            }
            
        }else  if section == 2 {
            
            if selection {
                if selectedIndex == indexPath.row && isSelectedCell == true
                {
                    isSelectedCell = false

                    cell.lblSlotTime.textColor = AppColor.whiteColor
                    cell.mainView.backgroundColor = AppColor.themeColor
                }
                else
                {
                    cell.lblSlotTime.textColor = AppColor.textColor
                    cell.mainView.backgroundColor = UIColor.white
                }
            }
            

            if eveningSlotArr.count > 0 {
                if indexPath.row < eveningSlotArr.count {
                    cell.timingItem = eveningSlotArr[indexPath.row]

                }
            }
            
        }
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //MARK:- Priyanka Code
        //TODO:- Start
        let noOfCellsInRow = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size , height: size - 50)
        //TODO:- End
    }
    
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       

        selection = true
        
        if section == 0 {
            
            if isSelectedCell == false {
                isSelectedCell = true
            }else{
                isSelectedCell = false

            }
            
            reloadTableDelegate?.reloadProStatus(0)
            selectedIndex = indexPath.row
            if morningSlotArr.count > 0 {
                getTimeDelegat?.getSlotAndTime("Morning", time: morningSlotArr[indexPath.row])

            }
            
        }else if section == 1 {
            
            if isSelectedCell == false {
                isSelectedCell = true
            }else{
                isSelectedCell = false

            }
            selectedIndex = indexPath.row
            reloadTableDelegate?.reloadProStatus(1)
            if afterSlotArr.count > 0
            {
                getTimeDelegat?.getSlotAndTime("Afternoon", time: afterSlotArr[indexPath.row])

            }

        }else{
            
            if isSelectedCell == false {
                isSelectedCell = true
            }else{
                isSelectedCell = false

            }
            
            selectedIndex = indexPath.row
            reloadTableDelegate?.reloadProStatus(2)
            if eveningSlotArr.count > 0 {
                getTimeDelegat?.getSlotAndTime("Evening", time: eveningSlotArr[indexPath.row] )

            }

        }
        
        self.scheduleColl.reloadData()

    }
    
    
    /*
     // UICollectionViewDataSource method
     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
     sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
     
     let numberOfSets = CGFloat(4.0)
     
     let width = (collectionView.frame.size.width - (numberOfSets * collectionView.frame.size.width / 15))/numberOfSets
     
     let height = collectionView.frame.size.height / 2
     
     return CGSize(width: width, height: height)
     }
     
     
     // UICollectionViewDelegateFlowLayout method
     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
     insetForSectionAtIndex section: Int) -> UIEdgeInsets {
     
     let cellWidthPadding = collectionView.frame.size.width / 30
     let cellHeightPadding = collectionView.frame.size.height / 4
     return UIEdgeInsets(top: cellHeightPadding,left: cellWidthPadding, bottom: cellHeightPadding,right: cellWidthPadding)
     }
     */
    
}
