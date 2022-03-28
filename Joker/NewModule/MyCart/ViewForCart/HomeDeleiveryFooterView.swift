//
//  HomeDeleiveryFooterView.swift
//  JustBite
//
//  Created by cst on 03/02/20.
//  Copyright © 2020 Mobulous. All rights reserved.
//

import UIKit


//////New Code

class HomeDeleiveryFooterView: UIView {

    @IBOutlet weak var lblScheduleDelivery: UILabel!
    @IBOutlet weak var addressTV: UILabel!
    @IBOutlet weak var btnSchedulDelivery: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var itemprice: UILabel!
    @IBOutlet weak var deliveryChargeLbl: UILabel!
    @IBOutlet weak var DeliveryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnAdresss: UIButton!
    @IBOutlet weak var DeliveryView:UIView!
    @IBOutlet weak var txtFldAddressTop: UITextField!
    @IBOutlet weak var lblITemTotaal: UILabel!
    @IBOutlet weak var lblBillDetails: UILabel!
    @IBOutlet weak var lblDeliveryFee: UILabel!
    @IBOutlet weak var lblFixedTotalAmout: UILabel!
    
    @IBOutlet weak var stackVwSchedule: UIStackView!
    @IBOutlet weak var lblDeliveryDate: UILabel!
    @IBOutlet weak var lblDeliveryDay: UILabel!
    @IBOutlet weak var lblDeliveryTimeSlot: UILabel!
    @IBOutlet weak var lblDeliverySlot: UILabel!
  
    
    func setLocal(){
        
        lblScheduleDelivery.text = "Schedule Delivery".localized()
        lblITemTotaal.text = "Item Total".localized()
        lblBillDetails.text = "Bill Details".localized()
        lblDeliveryFee.text = "Delivery Fees".localized()
        lblFixedTotalAmout.text = "Total amount to be paid".localized()
        
    }
    
    var deliveryPriceValue = Int()
    
    var item: CartItemData?{
        didSet{
            setLocal()
            txtFldAddressTop.text = item?.sellerData?.address
            locationBtn.addTarget(self, action: #selector(locationBtnTap), for: .touchUpInside)
            itemprice.text = "\(item?.productData?.currency == "Kz" ? "\(minimumPrice.description) Kz" : "$ \(minimumPrice.description)")"
            
            print(item?.productData?.offerPrice?.description)
            totalAmount.text = "\(item?.productData?.currency == "Kz" ? "\(minimumPrice + deliveryPriceValue) Kz" : "$ \(minimumPrice + deliveryPriceValue)")"
            addressTV.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)
        }
    }

    var itemPrice: [CartItemData]?{
        didSet{
            setLocal()
            txtFldAddressTop.text = itemPrice?.first?.sellerData?.address
            locationBtn.addTarget(self, action: #selector(locationBtnTap), for: .touchUpInside)
            addressTV.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)

            var price = Int()
            for i in 0..<(itemPrice?.count ?? 0){
                print("status..............\(itemPrice?[i].productData?.oStatus)")

                if itemPrice?[i].productData?.oStatus == "Inactive"{
                    price += ((itemPrice?[i].productData?.price ?? 0) * (itemPrice?[i].quantity ?? 0))
                }
                else
                {
                    if itemPrice?[i].sellerData?.offerStatus == "Active"{
                        if MyHelper.isValidNewOfferPeriod(endDate: itemPrice?[i].productData?.endDate ?? ""){

                                price += ((itemPrice?[i].productData?.offerPrice ?? 0) * (itemPrice?[i].quantity ?? 0))

                            
                        }else{
                            
                            price += ((itemPrice?[i].productData?.price ?? 0) * (itemPrice?[i].quantity ?? 0))
                        }
                    }
                    else
                    {
                        price += ((itemPrice?[i].productData?.price ?? 0) * (itemPrice?[i].quantity ?? 0))
                       
                    }

                }
                
                
                
                
                
                //price += (((itemPrice?[i].productData?.offerPrice ?? 0) == 0 ? (itemPrice?[i].productData?.price ?? 0):(itemPrice?[i].productData?.offerPrice ?? 0)) * (itemPrice?[i].quantity ?? 0))
            }
            
            let locaPrice = price.description as NSString?
            print("Total = ",locaPrice)
            
            itemprice.text = "\(itemPrice?.first?.productData?.currency == "Kz" ? "\(getCurrencyFormat(amount: locaPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: locaPrice?.doubleValue ?? 0.0))")"
            
            let priceToUse = ((price) + (deliveryPriceValue))
            print("Price ===",price)
            print("priceToUse",priceToUse)
            let usedPrice = priceToUse.description as NSString?
            
            totalAmount.text = "\(itemPrice?.first?.productData?.currency == "Kz" ? "\(getCurrencyFormat(amount: usedPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: usedPrice?.doubleValue ?? 0.0))")"
            
            
        }
    }
    
    var deliveryPrice: DeliveryChargeData?{
        didSet{
            
            let charge = deliveryPrice?.deliveryCharge ?? 0
            let locaPrice = charge.description as NSString?
            
            deliveryChargeLbl.text = "\(itemPrice?.first?.productData?.currency == "Kz" ? "\(getCurrencyFormat(amount: locaPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: locaPrice?.doubleValue ?? 0.0))")"
            
    }
    }
    //Price Change Currancy
    
    func getCurrencyFormat(amount: Double) -> String
    {
        let amountFormatter = NumberFormatter()
        amountFormatter.numberStyle = .decimal ///ERROR
        amountFormatter.locale = NSLocale.system
        let price = amountFormatter.string(from: amount as NSNumber)! as NSString
        return String(price.description)
//        return String(price.description.prefix(price.description.count - 3))
    }
    
    @objc func locationBtnTap(_ sender: UIButton) {
        CommonClass.sharedInstance.openMapButtonAction(commonController, itemPrice?.first?.sellerData?.latitude ?? "", itemPrice?.first?.sellerData?.longitude ?? "")
    }
}

