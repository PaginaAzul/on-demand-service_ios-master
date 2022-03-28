//
//  Validation.h
//  WatchMovement
//
//  Created by promatics on 5/15/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validation : NSObject

+(id)validationManager;
-(BOOL)validateEmail:(NSString*)emailString;
-(BOOL)validatePassword:(NSString*)password;
-(BOOL)validateBlankField:(NSString*)string;
-(BOOL)validatePhoneNumber:(NSString*)phoneString;
-(BOOL)validateZipCode:(NSString*)zipcodeString;
-(BOOL)validateCharacters:(NSString*)string;
-(BOOL)validateString:(NSString*)string equalTo:(NSString*)match ;
-(BOOL)validateUsername:(NSString*)usernameString;
-(BOOL)validateUsernameLength:(NSString*)usernameStringLength;
-(BOOL)validateNumber:(NSString*)numberString;
-(BOOL)validateNumberDigits:(NSString*)numberString;

@end
