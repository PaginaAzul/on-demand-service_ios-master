//
//  Validation.m
//  WatchMovement
//
//  Created by promatics on 5/15/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "Validation.h"

@implementation Validation

+(id)validationManager
{
    static Validation *newValidation=nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        newValidation=[[self alloc]init];
    });
    NSLog(@"connection %@ self %@",newValidation, self);
    return newValidation;
}

-(id)init
{
    if (self=[super init]) {
        
    }
    return self;
}

-(BOOL)validateEmail:(NSString*)emailString
{
    //[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z ]{2,}
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

-(BOOL)validateZipCode:(NSString*)zipcodeString
{
    //[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z ]{2,}
    NSString *zipcodeRegex = @"[0-9]{5}";
    NSPredicate *zipcodeTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipcodeRegex];
    return [zipcodeTest evaluateWithObject:zipcodeString];;
}

-(BOOL)validateNumber:(NSString*)numberString
{
    //[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z ]{2,}
    NSString *numberRegex = @"[0-9]{1,}";
    NSPredicate *numberTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:numberString];;
}


-(BOOL)validatePassword:(NSString*)password
{
    NSLog(@"In Password");
    //    BOOL isValidate=NO;
    //    NSString *passwordPattern=@"^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\\d]){1,})(?=(.*[\\W]){1,})(?!.*\\s).{8,}$";
    //    NSPredicate *passwordPred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordPattern];
    //    isValidate=[passwordPred evaluateWithObject:password];
    
    if (password.length < 1) {
        return false;
    }else{
        return true;
    }
}

-(BOOL)validateBlankField:(NSString*)string
{
    if (string.length < 1) {
        return false;
    }else{
        return true;
    }
}

-(BOOL)validatePhoneNumber:(NSString*)phoneString
{
    //^\([0-9]{3}\)[0-9]{3}-[0-9]{4}$
    //@"[789][0-9]{9}"
    NSString *phoneRegex = @"[0-9]{10}";
    NSPredicate *phonePredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phonePredicate evaluateWithObject:phoneString];
}

-(BOOL)validateCharacters:(NSString*)string
{
    //[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z ]{2,}
    NSString *regex = @"[A-Za-z]{1,}";
    NSPredicate *test =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:string];
}
-(BOOL)validateNumberDigits:(NSString*)numberString
{
    //^\([0-9]{3}\)[0-9]{3}-[0-9]{4}$
    
    NSString *phoneRegex = @"[0-9]{1,}";
    
    NSPredicate *phonePredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phonePredicate evaluateWithObject:numberString];
}


-(BOOL)validateUsername:(NSString*)usernameString
{
   
   // NSString *regex = @"[A-Z0-9a-z]{1,}";
    NSString *regex = @"[A-Za-z]{1,}";
    NSPredicate *test =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [test evaluateWithObject:usernameString];
}

-(BOOL)validateUsernameLength:(NSString *)usernameStringLength{
    
    if(usernameStringLength.length <4){
        return false;
        
    }else{
        return true;
    }
}

-(BOOL)validateString:(NSString*)string equalTo:(NSString*)match {
    
    if ([string isEqualToString:match]) {
        return true;
    
    } else {
       
        return false;
    }
}

@end
