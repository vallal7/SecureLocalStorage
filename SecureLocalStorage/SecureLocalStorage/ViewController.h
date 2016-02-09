//
//  ViewController.h
//  SecureLocalStorage
//
//  Created by Ganesh, Ashwin on 2/9/16.
//  Copyright © 2016 Ashwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)saveData:(id)sender;
- (IBAction)retrieveData:(id)sender;
- (IBAction)deleteData:(id)sender;
- (IBAction)updateData:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@end

