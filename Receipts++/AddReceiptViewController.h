//
//  AddReceiptViewController.h
//  Receipts++
//
//  Created by Kevin Cleathero on 2017-06-22.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddReceiptViewControllerProtocol <NSObject>

-(void)saveContext;

@end

@class NSPersistentContainer;

@interface AddReceiptViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<AddReceiptViewControllerProtocol> delegate;

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

@end
