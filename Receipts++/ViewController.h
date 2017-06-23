//
//  ViewController.h
//  Receipts++
//
//  Created by Kevin Cleathero on 2017-06-22.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag+CoreDataProperties.h"
#import "AddReceiptViewController.h"

@class NSPersistentContainer;

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AddReceiptViewControllerProtocol>

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

@end

