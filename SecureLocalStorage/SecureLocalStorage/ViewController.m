//
//  ViewController.m
//  SecureLocalStorage
//
//  Created by Ganesh, Ashwin on 2/9/16.
//  Copyright © 2016 Ashwin. All rights reserved.
//

#import "ViewController.h"
#import <Security/Security.h>

@interface ViewController ()
{
    NSString *service;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    service = @"serviceName";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableDictionary*) prepareDict:(NSString *) key
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrGeneric];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrAccount];
    [dict setObject:service forKey:(__bridge id)kSecAttrService];
    
    [dict setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    
    return  dict;
}

-(BOOL) setKey:(NSString *)key withValue:(NSString *)value
{
    NSData * encodedData = [value dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary * dict =[self prepareDict:key];
    [dict setObject:encodedData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dict, NULL);
    if(errSecSuccess != status) {
        NSLog(@"Unable to add item with key =%@ error:%d",key,(int)status);
        return false;
    }
    return true;
}

-(NSString*) getKey:(NSString*)key
{
    NSMutableDictionary *dict = [self prepareDict:key];
    [dict setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [dict setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)dict,&result);
    
    if( status != errSecSuccess) {
        NSLog(@"Unable to fetch item for key %@ with error:%d",key,(int)status);
        return nil;
    }
    
    return [[NSString alloc] initWithData:(__bridge NSData *)result encoding:NSUTF8StringEncoding];
}

-(BOOL) updateKey:(NSString*)key withValue:(NSString*)value
{
    NSData * encodedData = [value dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary * dictKey =[self prepareDict:key];
    
    NSMutableDictionary * dictUpdate =[[NSMutableDictionary alloc] init];
    [dictUpdate setObject:encodedData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)dictKey, (__bridge CFDictionaryRef)dictUpdate);
    if(errSecSuccess != status) {
        NSLog(@"Unable add update with key =%@ error:%d",key,(int)status);
    }
    //    return (errSecSuccess == status);
    
    return YES;
    
}

-(BOOL) removeKey: (NSString*)key
{
    NSMutableDictionary *dict = [self prepareDict:key];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dict);
    if( status != errSecSuccess) {
        NSLog(@"Unable to remove item for key %@ with error:%d",key,(int)status);
        return NO;
    }
    return  YES;
}

- (IBAction)saveData:(id)sender {
    NSString *resultStatus;
    if([self setKey:self.userNameTextfield.text withValue:self.passwordTextfield.text])
    {
        resultStatus = @"save success";
    }
    else
    {
        resultStatus = @"save failure";
    }
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:[NSString stringWithFormat:@"Data %@",resultStatus]
                                  message:[NSString stringWithFormat:@"Data %@",resultStatus]
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [self dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)retrieveData:(id)sender {
    NSString *result = [self getKey:self.userNameTextfield.text];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Data saved"
                                  message:[NSString stringWithFormat:@"The retrieved string is %@",result]
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [self dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (IBAction)deleteData:(id)sender {
    NSString *resultStatus;
    if([self removeKey:self.userNameTextfield.text])
    {
        resultStatus = @"deletion success";
    }
    else
    {
        resultStatus = @"deletion failure";
    }
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:[NSString stringWithFormat:@"Data %@",resultStatus]
                                  message:[NSString stringWithFormat:@"Data %@",resultStatus]
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [self dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)updateData:(id)sender {
    NSString *resultStatus;
    if([self updateKey:self.userNameTextfield.text withValue:self.passwordTextfield.text])
    {
        resultStatus = @"update success";
    }
    else
    {
        resultStatus = @"update failure";
    }
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:[NSString stringWithFormat:@"Data %@",resultStatus]
                                  message:[NSString stringWithFormat:@"Data %@",resultStatus]
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [self dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
