//
//  App.swift
//  Homefuud
//
//  Created by Callsoft on 20/02/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import Foundation
import UIKit

struct App {
    
    struct Fonts {
        
        struct SegoeUI{
            
            static let Regular = "SegoeUI"
            static let SemiBold = "SegoeUI-SemiBold"
            static let Bold = "SegoeUI-Bold"

        }
    }
    
    struct URLs {
        
        static let apiCallForGetStaticContent = "getStaticContent"
        static let apiCallForGetStaticContentByType = "getStaticContentByType"
        static let apiCallForSignup = "signup"
        static let apiCallForSignIn = "signin"
        static let apiCallForLogout = "logout"
        static let apiCallForUserDetail = "getUserDetails"
        static let apiCallForChangeLanguage = "changeLanguage"
        static let apiCallForCheckMobileNumber = "checkAvailability"
        static let checkNumberForSignin = "checkNumberForSignin"
        
        static let apiCallForChangeMobileNumber = "mobileNumberChange"
        static let apiCallForUpdateProfile = "updateProfile"
        static let apiCallForGetNotificationStatus = "getSetting"
        static let apiCallForSetNotificationStatus = "updateSetting"
        static let apiCallForRequestOrder = "requestOrder"
        static let apiCallForgetOrderBasedOnRequestId = "getOrder"
        static let apiCallForSubmitOrder = "updateUserId"
        static let apiCallForGetAllAddresses = "getAddress"
        static let apiCallForAddNewAddress = "addAddress"
        static let apiCallForUpdateAddress = "updateAddress"
        static let apiCallForDeleteAddress = "deleteAddress"
        static let apiCallForBecomeDeliveryPerson = "deliveryPerson"
        static let apiCallForBecomeProfessionalPerson = "professionalPerson"
        static let apiCallForSubmitAppRating = "apprating"
        static let apiCallForGetCategory = "getCategory"
        static let getBecomeDeliveryDetails = "getDeliveryDetails"
        static let getBecomeProfessionalDetails = "getProfessionalDetails"
        static let apiCallForDeliveryAndProfessionalWithinRange = "getLocation1"
        static let apiCallForGetSubCategory = "getSubCategory"
        static let apiCallForGetNormalUserPendingOrder = "getNormalUserPendingOrder"
        static let apiCallForGetUserType = "checkUserType"
        static let apiCallForGetNewOrderOfDeliveryPerson = "getNewOrderForDeliveryPerson"
        static let apiCallForMakeOfferByDeliveryPerson = "makeOffer"
        static let apiCallForGetPendingOrderDeliveryPerson = "getPendingOrderDeliveryPerson"
        static let apiCallForGetViewAllOffered = "getOfferList"
        static let apiCallForCancelOrder = "orderCancel"
        static let apiCallForReportOrder = "orderReport"
        static let apiCallForAcceptOfferOfDeliveryPerson = "acceptOffer"
        
        //sprint 3
        static let apiCallForFetchActiveOrderOfNormalUser = "getNormalUserActiveOrder"
        static let apiCallForFetchPastOrderOfNormalUser = "getPastOrderForNormalUser1"
        static let apiCallForGetActiveOrderDeliveryPerson = "getActiveOrderDeliveryPerson"
        static let apiCallForGetPastOrderDeliveryPerson = "getPastOrderDeliveryPerson1"
        static let apiCallForGetAllRating = "getAllRating"
        static let apiCallForWorkDoneByDeliveryPerson = "workDoneByDeliveryPerson"
        static let apiCallForGiveRatingToParticularUser = "rating"
        
        //sprint 4
        static let apiCallForGetNewOrderProfessionalWorker = "getNewOrderForProfessionalWorker"
        static let apiCallForMakeAOfferByProfessionalWorker = "makeAOfferByProfessionalWorker"
        static let apiCallForGetPendingOrderProfessionalWorker =  "getPendingOrderProfessionalWorker"
        static let apiCallForGetActiveOrderProfessionalWorker = "getActiveOrderProfessionalWorker"
        static let apiCallForGetPastOrderProfessionalWorker = "getPastOrderForProfessionalWorker1"
        static let apiCallForWorkDoneByProfessionalWorker = "workDoneByProfessionalWorker"
        static let orderReportByNormalUser = "orderReportByNormalUser"
        static let apiCallForGetMyRating = "getRate"
        static let apiCallForGoStatus = "goStatus"
        static let apiCallForCreateInvoice = "createInvoiceByDeliveryPerson"
        static let apiCallForGetInvoiceDetail = "getInvoiceDetails"
        static let apiCallForArrivedStatus = "arrivedStatus"
        
        static let apiCallForGetChatHistory = "getChatHistory"
        static let apiCallForGetNotificationList = "getNotificationList"
        static let apiCallForNotificationSeen = "notificationSeen"
        
        static let apiCallForSaveLocationOfUser = "updateLocation"
        static let getTotalCountOfBusinessAndProfessionalWithinRange = "getTotal"
        
        static let apiCallForUpdateDeliveryPersonProfile = "updateDeliveryPerson"
        static let apiCallForUpdateProfessionalPersonProfile = "updateProfessionalPerson"
        
        static let apiCallForGetWalletPassbookInvoiceDetail = "getInvoicDetails"
        static let apiCallForContactToAdmin = "contactUs"
        
        static let apiCallForCountBothDelAndProf = "getTotalDeliAndProfUser"
        
        static let apiCallForRejectOfferByNormal = "rejectOffer"
        
        static let apiCallForOrderCancelByDelivery = "orderCancelFromDelivery"
        
        static let apiCallForUpdateOffer = "updateOffer"
        
        static let apiCallForUpdatePopupStatus = "updatePopupStatus"
        
        static let apiCallForDeliveryActiveOrderTracking = "deliveryActiveOrder"
        
        static let apiCallForNormalActiveOrderTracking = "normalActiveOrder"
        
        static let apiCallForChangeDeliveryPerson = "changeDeliveryCaptain"
        
        static let apiCallForGetFreezeStatus = "checkCurrentOrder"
        
        static let apiCallForGetTrackingCordinateOfCaptain = "getTracking"
        
        static let apiCallForWithdrawRequestByCaptain = "orderWithdrawFromDeliveryAndPro"
        
        static let apiCallForAcceptWithdrawRequest = "acceptWithdrawOrderRequest"
        
        static let apiCallForRejectWithdrawRequest = "declineWithdrawOrderRequest"
        
        static let apiCallForCheckOrderAcceptedOrNot = "checkOrderAcceptOrNot"
        
        //Pagianzul New Module-->
        static let getRestaurantAndStoreData = "getRestaurantAndStoreData"
        
        
    }

}
