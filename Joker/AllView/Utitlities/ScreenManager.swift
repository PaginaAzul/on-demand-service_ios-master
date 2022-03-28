//
//  ScreenManager.swift
//  Homefuud
//
//  Created by Callsoft on 20/02/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import Foundation
import UIKit

class ScreenManager {
    
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class func loginSignupStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Login_SignUP", bundle: nil)
    }
    
    class func remainingStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "RemainingStoryboard", bundle: nil)
    }
    
    
    class func getTermsAndConditionViewController()->TermsAndConditionVC{
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
    }

    class func getAgreeDisagreeAlertVC()->MarketingLoremAlert{
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "MarketingLoremAlert") as! MarketingLoremAlert
    }
    
    class func getServiceProviderMapVC()->ServiceProviderMapVC{
        return mainStoryboard().instantiateViewController(withIdentifier: "ServiceProviderMapVC") as! ServiceProviderMapVC
    }
    
    class func getDeliveryPersonGoOrderVC()->GoOrderVC{
        return mainStoryboard().instantiateViewController(withIdentifier: "GoOrderVC") as! GoOrderVC
    }

    class func getPrfessionalWorkerGoOrderVC()->MapWithServiceVC{
        return mainStoryboard().instantiateViewController(withIdentifier: "MapWithServiceVC") as! MapWithServiceVC
    }
    
    class func getOfferDetailVC()->OfferDetailsVC{
        return remainingStoryboard().instantiateViewController(withIdentifier: "OfferDetailsVC") as! OfferDetailsVC
    }
    
    class func getOfferDetailPopupVC()->OfferDetailsPopUPVC{
        return remainingStoryboard().instantiateViewController(withIdentifier: "OfferDetailsPopUPVC") as! OfferDetailsPopUPVC
    }
    
    class func getMoreVC()->MoreVC{
        return remainingStoryboard().instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
    }
    
    class func getMyWalletPassbookVC()->MyWalletOrPassbookVC{
        return remainingStoryboard().instantiateViewController(withIdentifier: "MyWalletOrPassbookVC") as! MyWalletOrPassbookVC
    }
    
    class func getAddNewAddressVC()->ManageNewAddressesVC{
        return remainingStoryboard().instantiateViewController(withIdentifier: "ManageNewAddressesVC") as! ManageNewAddressesVC
    }
    
    class func getMyProfileVC()->MyProfileVC{
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
    }
    
    class func getBecomeADeliveryPersonVC()->BecomeDeliveryPersonVC{
        return remainingStoryboard().instantiateViewController(withIdentifier: "BecomeDeliveryPersonVC") as! BecomeDeliveryPersonVC
    }
    
    class func getBecomeAProfessionalWorkerVC()->BecomeProfessionalPersonVC{
        return remainingStoryboard().instantiateViewController(withIdentifier: "BecomeProfessionalPersonVC") as! BecomeProfessionalPersonVC
    }
    
    class func getSettingsVC()->SettingsVC{
        return remainingStoryboard().instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
    }
    
    class func getChangeLanguageVC()->ChangeLanguageVC{
        return remainingStoryboard().instantiateViewController(withIdentifier: "ChangeLanguageVC") as! ChangeLanguageVC
    }
    
    class func getContactAdminVC()->ContactAdminVC{
        return remainingStoryboard().instantiateViewController(withIdentifier: "ContactAdminVC") as! ContactAdminVC
    }
    
    class func getAdd_MoneyVC()->Add_MoneyVC{
        return remainingStoryboard().instantiateViewController(withIdentifier: "Add_MoneyVC") as! Add_MoneyVC
    }
    
    class func getPayYourCreditVC()->PayYourCreditVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "PayYourCreditVC") as! PayYourCreditVC
    }
    
    class func getManagedSavedCardsVC()->ManageSavedCardsVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "ManageSavedCardsVC") as! ManageSavedCardsVC
    }
    
    class func getPopupVC()->PopUpVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC
    }
    
    class func getAddCardVC()->AddCardVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
    }
    
    class func getManageCardVC()->ManageCardVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "ManageCardVC") as! ManageCardVC
    }
    
    class func getBankToBankVC()->BankToBankVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "BankToBankVC") as! BankToBankVC
    }
    
    class func getMyCaptionProfileVC()->MyCaptionProfileVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "MyCaptionProfileVC") as! MyCaptionProfileVC
    }
    
    class func getMyCaptionProfile2VC()->MyCapitan2VC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "MyCapitan2VC") as! MyCapitan2VC
    }
    
    class func getMyCaptionScrollManagerVC()->MyCaptionScrollManagerVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "MyCaptionScrollManagerVC") as! MyCaptionScrollManagerVC
    }
    
    class func getMyRateVC()->MyRateVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "MyRateVC") as! MyRateVC
    }
    
    class func getWalletPassbookNormalVC()->MyWalletPassbookNormalUserVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "MyWalletPassbookNormalUserVC") as! MyWalletPassbookNormalUserVC
    }
    
    class func getWalletPassbookProfessionalVC()->MyWalletPassbookProfessionalVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "MyWalletPassbookProfessionalVC") as! MyWalletPassbookProfessionalVC
    }
    
    class func getWalletPassbookDeliveryPersonVC()->MyWalletPassbookDeliveryPersonVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "MyWalletPassbookDeliveryPersonVC") as! MyWalletPassbookDeliveryPersonVC
    }
    
    class func getMyOrderDashboardVC()->MyOrderDashboardVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "MyOrderDashboardVC") as! MyOrderDashboardVC
    }
    
    class func getNormalUserMapOrderDashboardVC()->NormalUserMapOrderDashboardVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "NormalUserMapOrderDashboardVC") as! NormalUserMapOrderDashboardVC
    }
    
    
    class func getMyOrderNoralUserScrollerVC()->MyOrderNormalUserScrollerVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "MyOrderNormalUserScrollerVC") as! MyOrderNormalUserScrollerVC
    }
    
    class func getMyOrderNoralUserPendingVC()->MyOrderNormalUserPendingVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "MyOrderNormalUserPendingVC") as! MyOrderNormalUserPendingVC
    }
    
    class func getMyOrderNoralUserActiveVC()->MyOrderNormalUserActiveVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "MyOrderNormalUserActiveVC") as! MyOrderNormalUserActiveVC
    }
    
    class func getMyOrderNoralUserPastVC()->MyOrderNormalUserPastVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "MyOrderNormalUserPastVC") as! MyOrderNormalUserPastVC
    }
    //
    
    class func getNormalUserWithProfessionalWorkerScrollerVC()->NormalUserWithProfessionalWorkerScrollerVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "NormalUserWithProfessionalWorkerScrollerVC") as! NormalUserWithProfessionalWorkerScrollerVC
    }
    
    class func getNoramlUserProfessionalPendingVC()->NoramlUserProfessionalPendingVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "NoramlUserProfessionalPendingVC") as! NoramlUserProfessionalPendingVC
    }
    
    class func getNormalUserProfessionalActiveVC()->NormalUserProfessionalActiveVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "NormalUserProfessionalActiveVC") as! NormalUserProfessionalActiveVC
    }
    
    class func getNormalUserProfessionalPastVC()->NormalUserProfessionalPastVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "NormalUserProfessionalPastVC") as! NormalUserProfessionalPastVC
    }
    
    
    ///
    
    class func getDeliveryPersonScrollManagerVC()->DeliveryPersonScrollManagerVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "DeliveryPersonScrollManagerVC") as! DeliveryPersonScrollManagerVC
    }
    
    class func getDeliveryPersonNewVC()->DeliveryPersonNewVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "DeliveryPersonNewVC") as! DeliveryPersonNewVC
    }
    
    class func getDeliveryPersonPendingVC()->DeliveryPersonPendingVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "DeliveryPersonPendingVC") as! DeliveryPersonPendingVC
    }
    
    class func getDeliveryPersonActiveVC()->DeliveryPersonActiveVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "DeliveryPersonActiveVC") as! DeliveryPersonActiveVC
    }
    
    class func getDeliveryPersonPastVC()->DeliveryPersonPastVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "DeliveryPersonPastVC") as! DeliveryPersonPastVC
    }
    
    ///
    
    class func getProfessionalWorkerScrollManagerVC()->ProfessionalWorkerScrollManagerVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "ProfessionalWorkerScrollManagerVC") as! ProfessionalWorkerScrollManagerVC
    }
    
    class func getProfessionalWorkerNewVC()->ProfessionalWorkerNewVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "ProfessionalWorkerNewVC") as! ProfessionalWorkerNewVC
    }
    
    class func getProfessionalWorkerPendingVC()->ProfessionalWorkerPendingVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "ProfessionalWorkerPendingVC") as! ProfessionalWorkerPendingVC
    }
    
    class func getProfessionalWorkerActiveVC()->ProfessionalWorkerActiveVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "ProfessionalWorkerActiveVC") as! ProfessionalWorkerActiveVC
    }
    
    class func getProfessionalWorkerPastVC()->ProfessionalWorkerPastVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "ProfessionalWorkerPastVC") as! ProfessionalWorkerPastVC
    }
    
    //
    
    class func getViewAllOffersVC()->ViewAllOffersVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "ViewAllOffersVC") as! ViewAllOffersVC
    }
    
    class func getCancellationVC()->CancellationVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "CancellationVC") as! CancellationVC
    }
    
    class func getIssueWithMyOrderVC()->IssueWithMyOrderVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "IssueWithMyOrderVC") as! IssueWithMyOrderVC
    }
    
    class func getMakeNewOfferAlertVC()->MakeNewOfferAlertVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "MakeNewOfferAlertVC") as! MakeNewOfferAlertVC
    }
    
    
    class func getProffessionalViewAllOffersVC()->ProffessionalViewAllOffersVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "ProffessionalViewAllOffersVC") as! ProffessionalViewAllOffersVC
    }
    
    class func getReviewAndRatingVC()->ReviewRatingVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "ReviewRatingVC") as! ReviewRatingVC
    }
    
    class func getSignInSignupVC()->SignInSignUPVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "SignInSignUPVC") as! SignInSignUPVC
    }
    
    class func getSignupVC()->SignUpVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
    }
    
    class func getSignInVC()->SignInVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
    }
    
    class func getOtpVerifyVC()->OtpVerifyVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "OtpVerifyVC") as! OtpVerifyVC
    }
    
    class func getTermsAndConditionPopupVC()->TermsAndConditionsPopUPVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "TermsAndConditionsPopUPVC") as! TermsAndConditionsPopUPVC
    }
    
    class func getNotificationVC()->NotificationVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
    }
    
    class func getActiveOrderTrackingVC()->ActiveOrderTrackingVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "ActiveOrderTrackingVC") as! ActiveOrderTrackingVC
    }
    
    class func getMessagesVC()->MessagesVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
    }
    
    class func getFilterTransactionVC()->FilterTransactionVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "FilterTransactionVC") as! FilterTransactionVC
    }
    
    class func getFilterMonthVC()->MonthFilterVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "MonthFilterVC") as! MonthFilterVC
    }
    
    class func getUpdatePhoneVC()->UpdatePhoneVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "UpdatePhoneVC") as! UpdatePhoneVC
    }
    
    class func getAlertPopUPVC()->AlertPopUPVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "AlertPopUPVC") as! AlertPopUPVC
    }
    
    
    
    class func getAdditionalChatAlertVC()->AlertVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "AlertVC") as! AlertVC
    }
    
    class func getAddNewBanksVC()->AddNewBanksVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "AddNewBanksVC") as! AddNewBanksVC
    }
    
    
    class func getLargeImageViewerVC()->LargeImageViewerVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "LargeImageViewerVC") as! LargeImageViewerVC
    }
    
    
    class func getUserDetailVC()->UserDetailVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
    }
    
    
    class func getMapWithServicesSepratedVC()->MapWithServicesSepratedVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "MapWithServicesSepratedVC") as! MapWithServicesSepratedVC
    }
    
    
    class func getInstructionsVC()->InstructionVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "InstructionVC") as! InstructionVC
    }
    
    class func getCreateInvoiceVC()->CreateInvoiceVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "CreateInvoiceVC") as! CreateInvoiceVC
    }
    
    class func getCalendarVC()->CalendarVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
    }
    
    class func getSignupWithPhoneVC()->SignupWithPhoneVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "SignupWithPhoneVC") as! SignupWithPhoneVC
    }
    
    class func getContactUsVC()->ContactUsVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
    }
    
    class func getAboutUsVC()->AboutUsVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
    }
    
    class func getAddNewAddressessVC()->AddNewAddressVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "AddNewAddressVC") as! AddNewAddressVC
    }
    
    class func getDeliveryProfessionalSignupPopupVC()->DeliveryProfessionalSignupPopupVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "DeliveryProfessionalSignupPopupVC") as! DeliveryProfessionalSignupPopupVC
    }
    

    class func getAddressPickerVC()->AddressPickerVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "AddressPickerVC") as! AddressPickerVC
    }
    
    //LandmarkPopupVC
    
    class func getLandmarkPopupVC()->LandmarkPopupVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "LandmarkPopupVC") as! LandmarkPopupVC
    }
    
    class func getPickupCategoryMapVC()->PickupCategoriesMapVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "PickupCategoriesMapVC") as! PickupCategoriesMapVC
    }
    
    class func getPickupCategoryListVC()->PickupCategoriesListVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "PickupCategoriesListVC") as! PickupCategoriesListVC
    }
    
    
    ///new enhancement controller********************************************************
    
    class func getDeleteOfferPopupVC()->DeleteOfferPopupVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "DeleteOfferPopupVC") as! DeleteOfferPopupVC
    }
    
    class func getChatAdditionalFeatureVC()->ChatAdditionalFeatureVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "ChatAdditionalFeatureVC") as! ChatAdditionalFeatureVC
    }
    
    class func getShareLiveLocationPouupVC()->ShareLiveLocationPopupVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "ShareLiveLocationPopupVC") as! ShareLiveLocationPopupVC
    }
    
    class func getChangeDeliveryPersonPouupVC()->ChangeDeliveryPersonPopupVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "ChangeDeliveryPersonPopupVC") as! ChangeDeliveryPersonPopupVC
    }
    
    class func getSuccessfullDeliveredPopupVC()->SuccessfullDeliveredPopupVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "SuccessfullDeliveredPopupVC") as! SuccessfullDeliveredPopupVC
    }
    
    
    class func getNormalUserWaitingForOfferVC()->NormalUserWaitingForOfferVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "NormalUserWaitingForOfferVC") as! NormalUserWaitingForOfferVC
    }
    
    class func getDeliveryDetailOnMapVC()->DeliveryDetailOnMapVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "DeliveryDetailOnMapVC") as! DeliveryDetailOnMapVC
    }
    
    
    class func getSubmitOfferAsDeliveryVC()->SubmitOfferAsDeliveryVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "SubmitOfferAsDeliveryVC") as! SubmitOfferAsDeliveryVC
    }
    
        
    class func getSubmitOfferAsProfessionalWorkerVC()->SubmitOfferAsProfessionalWorkerVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "SubmitOfferAsProfessionalWorkerVC") as! SubmitOfferAsProfessionalWorkerVC
    }
    
    
    class func getViewAllOffersPopupVC()->ViewAllOffersPopupVC{
        
        return remainingStoryboard().instantiateViewController(withIdentifier: "ViewAllOffersPopupVC") as! ViewAllOffersPopupVC
    }
    
    
    class func getOrderRejectionOrTakenByOtherVC()->OrderRejectionOrTakenByOtherVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "OrderRejectionOrTakenByOtherVC") as! OrderRejectionOrTakenByOtherVC
    }
    
    class func getOrderInstructionPopupVC()->InstructionPopupVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "InstructionPopupVC") as! InstructionPopupVC
    }
    
    
    class func getOrderStartedPopupVC()->OrderStartedPopupVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "OrderStartedPopupVC") as! OrderStartedPopupVC
    }
    
    //DeliveryPersonWaitingForBuyerVC
    
    class func getOrderCancelFromDeliverySideVC()->OrderCancelFromDeliverySideVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "OrderCancelFromDeliverySideVC") as! OrderCancelFromDeliverySideVC
    }
    
    class func getDeliveryPersonWaitingForBuyerVC()->DeliveryPersonWaitingForBuyerVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "DeliveryPersonWaitingForBuyerVC") as! DeliveryPersonWaitingForBuyerVC
    }
    
    
    class func getNewSubcategoryViewController()->NewSubcategoryViewController{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "NewSubcategoryViewController") as! NewSubcategoryViewController
    }
    
    class func getSuccessfullDeliverDeliverySideVC()->SuccessfullDeliverDeliverySideVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "SuccessfullDeliverDeliverySideVC") as! SuccessfullDeliverDeliverySideVC
    }
    
    class func getWithdrawOfferVC()->WithdrawOfferVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "WithdrawOfferVC") as! WithdrawOfferVC
    }
    
    
    class func getTermsAndPrivacyWebpagesVC()->TermsAndPrivacyWebPagesVC{
        
        return loginSignupStoryboard().instantiateViewController(withIdentifier: "TermsAndPrivacyWebPagesVC") as! TermsAndPrivacyWebPagesVC
    }
    
    //
    
    class func getNormalUserGettingRequestForWithdrawVC()->NormalUserGettingRequestForWithdrawVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "NormalUserGettingRequestForWithdrawVC") as! NormalUserGettingRequestForWithdrawVC
    }
    
    //NewEditProfileViewController
    
    class func getNewEditProfileViewController()->NewEditProfileViewController{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "NewEditProfileViewController") as! NewEditProfileViewController
    }
    
    //SearchSubcategoryVC
    
    class func getSearchSubcategoryVC()->SearchSubcategoryVC{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "SearchSubcategoryVC") as! SearchSubcategoryVC
    }
    
    //NewProviderDetailViewController
    
    class func getNewProviderDetailViewController()->NewProviderDetailViewController{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "NewProviderDetailViewController") as! NewProviderDetailViewController
    }
    
    
    class func getTackDistanceVCViewController()->TackDistanceVCViewController{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "TackDistanceVCViewController") as! TackDistanceVCViewController
    }
    
    
    //MARK - New StoryBoard by Priyanka - New Module
    class func NewModuleStoryBoard() -> UIStoryboard {
        return UIStoryboard(name: "NewModule", bundle: nil)
    }
    
    //Push - Using NewModule StoryBoard
    class func ratingReviewsNew_VC()->RatingReviewsNew_VC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "RatingReviewsNew_VC") as! RatingReviewsNew_VC
    }
    
    
    class func MyFavNew_VC()->MyFavNew_VC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "MyFavNew_VC") as! MyFavNew_VC
    }
    
    class func MainModuleNew_VC()->MainModuleNew_VC{
           
           return NewModuleStoryBoard().instantiateViewController(withIdentifier: "MainModuleNew_VC") as! MainModuleNew_VC
       }
    
    class func OffersNew_VC()->OffersNew_VC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "OffersNew_VC") as! OffersNew_VC
    }
    
    class func OfferController()->ViewControllerCollection{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "ViewControllerCollection") as! ViewControllerCollection
    }
    
    
    
    class func OfferListNew_VC()->OfferListNew_VC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "OfferListNew_VC") as! OfferListNew_VC
    }
    
    class func HomeScreenNew_VC()->HomeScreenNew_VC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "HomeScreenNew_VC") as! HomeScreenNew_VC
    }
   
    
    class func MyCartNew_VC()->MyCartNew_VC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "MyCartNew_VC") as! MyCartNew_VC
    }
    
    class func ProductListingNew_VC()->ProductListingNew_VC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "ProductListingNew_VC") as! ProductListingNew_VC
    }
    
    class func ShareReviewVC()->ShareReviewVC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "ShareReviewVC") as! ShareReviewVC
    }
   
    class func CustomerStoriesViewController()->CustomerStoriesViewController{
         
         return NewModuleStoryBoard().instantiateViewController(withIdentifier: "CustomerStoriesViewController") as! CustomerStoriesViewController
     }
    
  
    class func TubeFilterVC()->TubeFilterVC{
           
           return NewModuleStoryBoard().instantiateViewController(withIdentifier: "TubeFilterVC") as! TubeFilterVC
       }
    
    class func ResturantInfoViewC()->ResturantInfoViewC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "ResturantInfoViewC") as! ResturantInfoViewC
        
    }
    
   class func RestaurentDetailsVC()->RestaurentDetailsVC{
          
          return NewModuleStoryBoard().instantiateViewController(withIdentifier: "RestaurentDetailsVC") as! RestaurentDetailsVC
          
      }

    class func GroceryScheduleDeliveryPoPUpVC()->GroceryScheduleDeliveryVC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "GroceryScheduleDeliveryVC") as! GroceryScheduleDeliveryVC
    }
    class func MenuItemsPoPUpVC()->MenuItemsVC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "MenuItemsVC") as! MenuItemsVC
    }
    
    class func OrderPlacedPopUp_VC()->OrderPlacedPopUp_VC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "OrderPlacedPopUp_VC") as! OrderPlacedPopUp_VC
    }
    
    
    
    class func SearchNew_VC()->SearchNew_VC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "SearchNew_VC") as! SearchNew_VC
    }
    
    class func SubMenuListingVC()->SubMenuListingVC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "SubMenuListingVC") as! SubMenuListingVC
    }
    
    
    class func GroceryDetailVC()->GroceryDetailVC{
           
           return NewModuleStoryBoard().instantiateViewController(withIdentifier: "GroceryDetailVC") as! GroceryDetailVC
       }
    
    
    class func SubCategoriesVC()->SubCategoriesVC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "SubCategoriesVC") as! SubCategoriesVC
    }
    
    class func MenuListVC()->MenuListVC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "MenuListVC") as! MenuListVC
    }
    
    
    class func ProductDetailVC()->ProductDetailVC{
           
           return NewModuleStoryBoard().instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
       }
    
    class func MyOrderOngoingVC()->MyOrderOngoingVC{
              
              return NewModuleStoryBoard().instantiateViewController(withIdentifier: "MyOrderOngoingVC") as! MyOrderOngoingVC
          }
    
    class func NewFilterVCAman()->NewFilterVCAman{
                 
                 return NewModuleStoryBoard().instantiateViewController(withIdentifier: "NewFilterVCAman") as! NewFilterVCAman
             }
    
    class func FilterNewPOPUP_VC()->FilterNewPOPUP_VC{
        
        return NewModuleStoryBoard().instantiateViewController(withIdentifier: "FilterNewPOPUP_VC") as! FilterNewPOPUP_VC
    }
    
    class func ClearCartPOPUP()->ClearCartPOPUP{
        
        return mainStoryboard().instantiateViewController(withIdentifier: "ClearCartPOPUP") as! ClearCartPOPUP
    }
    
  
    
    
    class func animateScrollViewHorizontally(destinationPoint destination: CGPoint, andScrollView scrollView: UIScrollView, andAnimationMargin margin: CGFloat) {
        
        var change: Int = 0;
        let diffx: CGFloat = destination.x - scrollView.contentOffset.x;
        var _: CGFloat = destination.y - scrollView.contentOffset.y;
        
        if(diffx < 0) {
            
            change = 1
        }
        else {
            
            change = 2
            
        }
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3);
        UIView.setAnimationCurve(.easeIn);
        switch (change) {
            
        case 1:
            scrollView.contentOffset = CGPoint(x: destination.x - margin, y: destination.y);
        case 2:
            scrollView.contentOffset = CGPoint(x: destination.x + margin, y: destination.y);
        default:
            return;
        }
        
        UIView.commitAnimations();
        
        let firstDelay: Double  = 0.3;
        let startTime: DispatchTime = DispatchTime.now() + Double(Int64(firstDelay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: startTime, execute: {
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.2);
            UIView.setAnimationCurve(.linear);
            switch (change) {
                
            case 1:
                scrollView.contentOffset = CGPoint(x: destination.x + margin, y: destination.y);
            case 2:
                scrollView.contentOffset = CGPoint(x: destination.x - margin, y: destination.y);
            default:
                return;
            }
            
            UIView.commitAnimations();
            let secondDelay: Double  = 0.2;
            let startTimeSecond: DispatchTime = DispatchTime.now() + Double(Int64(secondDelay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: startTimeSecond, execute: {
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.1);
                UIView.setAnimationCurve(.easeInOut);
                scrollView.contentOffset = CGPoint(x: destination.x, y: destination.y);
                UIView.commitAnimations();
                
            })
        })
    }

}
