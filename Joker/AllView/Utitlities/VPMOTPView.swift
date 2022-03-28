//
//  VPMOTPView.swift
//  VPMOTPView
//  Version 1.1.0
//
//  Created by Varun P M on 14/12/16.
//  Copyright © 2016 Varun P M. All rights reserved.
//

//  MIT License
//
//  Copyright (c) 2016 Varun P M
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

protocol VPMOTPViewDelegate: class {
    /// Called whenever the textfield has to become first responder. Called for the first field when loading
    ///
    /// - Parameter index: the index of the field. Index starts from 0.
    /// - Returns: return true to show keyboard and vice versa
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool
    
    /// Called whenever all the OTP fields have been entered. It'll be called immediately after `hasEnteredAllOTP` delegate method is called.
    ///
    /// - parameter otpString: The entered otp characters
    func enteredOTP(otpString: String)
    
    /// Called whenever an OTP is entered.
    ///
    /// - parameter hasEntered: `hasEntered` will be `true` if all the OTP fields have been filled.
    func hasEnteredAllOTP(hasEntered: Bool)
}

class VPMOTPView: UIView {
    /// Different display type for text fields.
    enum DisplayType {
        case circular
        case square
        case diamond
        case underlinedBottom
    }
    
    /// Different input type for OTP fields.
    enum KeyboardType: Int {
        case numeric
        case alphabet
        case alphaNumeric
    }
    
    /// Define the display type for OTP fields. Defaults to `circular`.
    var otpFieldDisplayType: DisplayType = .circular
    
    /// Defines the number of OTP field needed. Defaults to 4.
    var otpFieldsCount: Int = 4
    
    /// Defines the type of the data that can be entered into OTP fields. Defaults to `numeric`.
    var otpFieldInputType: KeyboardType = .numeric
    
    /// Define the font to be used to OTP field. Defaults tp `systemFont` with size `20`.
    var otpFieldFont: UIFont = UIFont.systemFont(ofSize: 20)
    
    /// If set to `true`, then the content inside OTP field will be displayed in asterisk (*) format. Defaults to `false`.
    var otpFieldEntrySecureType: Bool = false
    
    /// If set to `true`, then the content inside OTP field will not be displayed. Instead whatever was set in `otpFieldEnteredBorderColor` will be used to mask the passcode. If `otpFieldEntrySecureType` is set to `true`, then it'll be ignored. This acts similar to Apple's lock code. Defaults to `false`.
    var otpFilledEntryDisplay: Bool = false
    
    /// If set to `false`, the blinking cursor for OTP field will not be visible. Defaults to `true`.
    var shouldRequireCursor: Bool = true
    
    /// If `shouldRequireCursor` is set to `false`, then this property will not have any effect. If `true`, then the color of cursor can be changed using this property. Defaults to `blue` color.
    var cursorColor: UIColor = UIColor.blue
    
    /// Defines the size of OTP field. Defaults to `60`.
    var otpFieldSize: CGFloat = 60
    
    /// Space between 2 OTP field. Defaults to `16`.
    var otpFieldSeparatorSpace: CGFloat = 16
    
    /// Border width to be used, if border is needed. Defaults to `2`.
    var otpFieldBorderWidth: CGFloat = 2
    
    /// If set, then editing can be done to intermediate fields even though previous fields are empty. Else editing will take place from last filled text field only. Defaults to `true`.
    var shouldAllowIntermediateEditing: Bool = true
    
    /// Set this value if a background color is needed when a text is not enetered in the OTP field. Defaults to `clear` color.
    var otpFieldDefaultBackgroundColor: UIColor = UIColor.clear
    
    /// Set this value if a background color is needed when a text is enetered in the OTP field. Defaults to `clear` color.
    var otpFieldEnteredBackgroundColor: UIColor = UIColor.clear
    
    /// Set this value if a border color is needed when a text is not enetered in the OTP field. Defaults to `black` color.
    var otpFieldDefaultBorderColor: UIColor = UIColor.black
    
    /// Set this value if a border color is needed when a text is enetered in the OTP field. Defaults to `black` color.
    var otpFieldEnteredBorderColor: UIColor = UIColor.black
    
    weak var delegate: VPMOTPViewDelegate?
    
    fileprivate var secureEntryData = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: Public functions
    /// Call this method to create the OTP field view. This method should be called at the last after necessary customization needed. If any property is modified at a later stage is simply ignored.
    func initalizeUI() {
        self.layer.masksToBounds = true
        self.layoutIfNeeded()
        
        initalizeOTPFields()
        
        // Forcefully try to make first otp field as first responder
        (viewWithTag(1) as? VPMOTPTextField)?.becomeFirstResponder()
    }
    
    //MARK: Private functions
    // Set up the fields
    fileprivate func initalizeOTPFields() {
        secureEntryData.removeAll()
        
        for index in stride(from: 0, to: otpFieldsCount, by: 1) {
            var otpField = viewWithTag(index + 1) as? VPMOTPTextField
            
            if otpField == nil {
                otpField = getOTPField(forIndex: index)
            }
            
            //add by tarun
            otpField?.text = ""
            //
            secureEntryData.append("")
            
            self.addSubview(otpField!)
        }
    }
    
    // Initalize the required OTP fields
    fileprivate func getOTPField(forIndex index: Int) -> VPMOTPTextField {
        let hasOddNumberOfFields = (otpFieldsCount % 2 == 1)
        var fieldFrame = CGRect(x: 0, y: 0, width: otpFieldSize, height: otpFieldSize)
        
        // If odd, then center of self will be center of middle field. If false, then center of self will be center of space between 2 middle fields.
        if hasOddNumberOfFields {
            // Calculate from middle each fields x and y values so as to align the entire view in center
            fieldFrame.origin.x = bounds.size.width / 2 - (CGFloat(otpFieldsCount / 2 - index) * (otpFieldSize + otpFieldSeparatorSpace) + otpFieldSize / 2)
        }
        else {
            // Calculate from middle each fields x and y values so as to align the entire view in center
            fieldFrame.origin.x = bounds.size.width / 2 - (CGFloat(otpFieldsCount / 2 - index) * otpFieldSize + CGFloat(otpFieldsCount / 2 - index - 1) * otpFieldSeparatorSpace + otpFieldSeparatorSpace / 2)
        }
        
        fieldFrame.origin.y = (bounds.size.height - otpFieldSize) / 2
        
        let otpField = VPMOTPTextField(frame: fieldFrame)
        otpField.delegate = self
        otpField.tag = index + 1
        otpField.font = otpFieldFont
        
        // Set input type for OTP fields
        switch otpFieldInputType {
        case .numeric:
            otpField.keyboardType = .numberPad
        case .alphabet:
            otpField.keyboardType = .alphabet
        case .alphaNumeric:
            otpField.keyboardType = .namePhonePad
        }
        
        // Set the border values if needed
        
//        if #available(iOS 12, *) {
//            // iOS 12 & 13: Not the best solution, but it works.
//            otpField.textContentType = .oneTimeCode
//        } else {
//            // iOS 11: Disables the autofill accessory view.
//            // For more information see the explanation below.
//            otpField.textContentType = .init(rawValue: "")
//        }
        
        ////*****Tarun code for autofilled
        
       // otpField.textContentType = .init(rawValue: "")
        
        ///******
        
        otpField.borderColor = otpFieldDefaultBorderColor
        otpField.borderWidth = Double(otpFieldBorderWidth)
        
        if shouldRequireCursor {
            otpField.tintColor = cursorColor
        }
        else {
            otpField.tintColor = UIColor.clear
        }
        
        // Set the default background color when text not set
        otpField.backgroundColor = otpFieldDefaultBackgroundColor
        
        // Finally create the fields
        otpField.initalizeUI(forFieldType: otpFieldDisplayType)
        
        return otpField
    }
    
    // Check if previous text fields have been entered or not before textfield can edit the selected field. This will have effect only if
    fileprivate func isPreviousFieldsEntered(forTextField textField: UITextField) -> Bool {
        var isTextFilled = true
        var nextOTPField: UITextField?
        
        // If intermediate editing is not allowed, then check for last filled from the current field in forward direction.
        if !shouldAllowIntermediateEditing {
            for index in stride(from: textField.tag + 1, to: otpFieldsCount + 1, by: 1) {
                let tempNextOTPField = viewWithTag(index) as? UITextField
                
                if let tempNextOTPFieldText = tempNextOTPField?.text, tempNextOTPFieldText.characters.count != 0 {
                    nextOTPField = tempNextOTPField
                }
            }
            
            if let nextOTPField = nextOTPField {
                if nextOTPField != textField {
                    nextOTPField.becomeFirstResponder()
                }
                
                isTextFilled = false
            }
        }
        
        return isTextFilled
    }
    
    // Helper function to get the OTP String entered
    fileprivate func calculateEnteredOTPSTring(isDeleted: Bool) {
        if isDeleted {
            delegate?.hasEnteredAllOTP(hasEntered: false)
        }
        else {
            var enteredOTPString = ""
            
            // Check for entered OTP
            for index in stride(from: 0, to: secureEntryData.count, by: 1) {
                if secureEntryData[index].characters.count > 0 {
                    enteredOTPString.append(secureEntryData[index])
                }
            }
            
            // Check if all OTP fields have been filled or not. Based on that call the 2 delegate methods.
            delegate?.hasEnteredAllOTP(hasEntered: (enteredOTPString.characters.count == otpFieldsCount))
            
            if enteredOTPString.characters.count == otpFieldsCount {
                delegate?.enteredOTP(otpString: enteredOTPString)
            }
        }
    }
}

extension VPMOTPView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let shouldBeginEditing = delegate?.shouldBecomeFirstResponderForOTP(otpFieldIndex: (textField.tag - 1)) ?? true
        if shouldBeginEditing {
            
            ///added by ayush
            
            textField.backgroundColor = otpFieldDefaultBackgroundColor
            textField.layer.borderColor = otpFieldDefaultBorderColor.cgColor
            textField.layer.borderWidth = 0.5
            
            textField.layer.shadowRadius = 3.0
            textField.layer.shadowColor = UIColor.blue.cgColor
            textField.layer.shadowColor = UIColor(red: 153.0/255, green: 140.0/255, blue: 247.0/255, alpha: 1.0).cgColor
            textField.layer.shadowOffset = CGSize(width: 1, height: 1)
            textField.layer.shadowOpacity = 1.0
            textField.backgroundColor = UIColor.white
            textField.layer.borderColor = UIColor.clear.cgColor
            
            
            //
            
            
            
            return isPreviousFieldsEntered(forTextField: textField)
        }
        
        return shouldBeginEditing
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let replacedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        // Check since only alphabet keyboard is not available in iOS
        if replacedText.characters.count > 0 && otpFieldInputType == .alphabet && replacedText.rangeOfCharacter(from: .letters) == nil {
            return false
        }
        
        if replacedText.characters.count >= 1 {
            // If field has a text already, then replace the text and move to next field if present
            secureEntryData[textField.tag - 1] = string
            
            if otpFilledEntryDisplay {
                textField.text = " "
            }
            else {
                if otpFieldEntrySecureType {
                    textField.text = "*"
                }
                else {
                    textField.text = string
                }
            }
            
            if otpFieldDisplayType == .diamond || otpFieldDisplayType == .underlinedBottom {
                (textField as! VPMOTPTextField).shapeLayer.fillColor = otpFieldEnteredBackgroundColor.cgColor
                (textField as! VPMOTPTextField).shapeLayer.strokeColor = otpFieldEnteredBorderColor.cgColor
            }
            else {
                textField.backgroundColor = otpFieldEnteredBackgroundColor
                textField.layer.borderColor = otpFieldEnteredBorderColor.cgColor
                
                //tarun is adding below code
                
//                textField.layer.shadowRadius = 0.0
//                textField.layer.shadowColor = UIColor.clear.cgColor
//                textField.layer.shadowOffset = CGSize(width: 0, height: 0)
//                textField.layer.shadowOpacity = 0.0
//                textField.layer.borderColor = UIColor(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0).cgColor
                
                //added by ayush
                
              //  textField.backgroundColor = otpFieldEnteredBackgroundColor
             //   textField.layer.borderColor = otpFieldEnteredBorderColor.cgColor
                
                textField.layer.borderWidth = 0.5
                
                textField.layer.shadowRadius = 0.0
                textField.layer.shadowColor = UIColor.clear.cgColor
                textField.layer.shadowOffset = CGSize(width: 0, height: 0)
                textField.layer.shadowOpacity = 0.0
                textField.layer.borderColor = UIColor(red: 117.0/255, green: 117.0/255, blue: 122.0/255, alpha: 1.0).cgColor
                
                //
                
                
                
            }
            
            let nextOTPField = viewWithTag(textField.tag + 1)
            
            if let nextOTPField = nextOTPField {
                nextOTPField.becomeFirstResponder()
            }
            else {
                textField.resignFirstResponder()
            }
            
            // Get the entered string
            calculateEnteredOTPSTring(isDeleted: false)
        }
        else {
            // If deleting the text, then move to previous text field if present
            secureEntryData[textField.tag - 1] = ""
            textField.text = ""
            
            if otpFieldDisplayType == .diamond || otpFieldDisplayType == .underlinedBottom {
                (textField as! VPMOTPTextField).shapeLayer.fillColor = otpFieldDefaultBackgroundColor.cgColor
                (textField as! VPMOTPTextField).shapeLayer.strokeColor = otpFieldDefaultBorderColor.cgColor
            }
            else {
                textField.backgroundColor = otpFieldDefaultBackgroundColor
                textField.layer.borderColor = otpFieldDefaultBorderColor.cgColor
                
                //tarun is adding below code
//                textField.layer.shadowRadius = 3.0
//                textField.layer.shadowColor = UIColor.blue.cgColor
//                textField.layer.shadowColor = UIColor(red: 153.0/255, green: 140.0/255, blue: 247.0/255, alpha: 1.0).cgColor
//                textField.layer.shadowOffset = CGSize(width: 1, height: 1)
//                textField.layer.shadowOpacity = 1.0
//                textField.backgroundColor = UIColor.white
//                textField.layer.borderColor = UIColor.clear.cgColor
                
                
                //added by ayush
                
                textField.backgroundColor = otpFieldEnteredBackgroundColor
                textField.layer.borderColor = otpFieldEnteredBorderColor.cgColor
                
                textField.layer.borderWidth = 0.5
                textField.layer.shadowRadius = 0.0
                textField.layer.shadowColor = UIColor.clear.cgColor
                textField.layer.shadowOffset = CGSize(width: 0, height: 0)
                textField.layer.shadowOpacity = 0.0
                textField.layer.borderColor = UIColor(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0).cgColor
                
                //
                
                
            }
            
            let prevOTPField = viewWithTag(textField.tag - 1)
            
            if let prevOTPField = prevOTPField {
                prevOTPField.becomeFirstResponder()
            }
            
            // Get the entered string
            calculateEnteredOTPSTring(isDeleted: true)
        }
        
        return false
    }
}
