//
//  AddReceiptViewController.m
//  Receipts++
//
//  Created by Kevin Cleathero on 2017-06-22.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import "AddReceiptViewController.h"
#import "CategoryTableViewCell.h"
#import "AppDelegate.h"
#import "Receipt+CoreDataProperties.h"
#import "Tag+CoreDataProperties.h"

@interface AddReceiptViewController ()

@property (strong, nonatomic) IBOutlet UITextField *receiptAmountText;

@property (strong, nonatomic) IBOutlet UITextField *receiptDescriptionText;

@property (strong, nonatomic) IBOutlet UIDatePicker *receiptDate;
@property (strong, nonatomic) IBOutlet UITableView *receiptTableView;

@property (nonatomic) NSArray *categories;

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic) NSString *categorySelected;



@end

@implementation AddReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.context = self.persistentContainer.viewContext;
    
    self.receiptAmountText.placeholder = @"AMOUNT";
    self.receiptDescriptionText.placeholder = @"DESCRIPTION";
    self.categories = @[@"Personal", @"Family", @"Business"];
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Category";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //CategoryTableViewCell *catCellObject = [[CategoryTableViewCell alloc] init];
    //NSLog(@"path: %@", indexPath);
    
    cell.categoryCellLabel.text = self.categories[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0 :
             self.categorySelected = @"Personal";
            break;
        case 1 :
            self.categorySelected = @"Family";
            break;
        default:
             self.categorySelected = @"Business";
            break;
    }
   // self.categorySelected = cell.textLabel.text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 30.0;
    return height;
}

- (IBAction)receiptDoneAction:(UIButton *)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.persistentContainer = appDelegate.persistentContainer;
    
   // NSManagedObjectContext *nsManageContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.persistentContainer.viewContext];
    
    Receipt *receipt = [[Receipt alloc] initWithEntity:entity insertIntoManagedObjectContext:self.persistentContainer.viewContext];
    receipt.receiptAmount = [self.receiptAmountText.text doubleValue];
    receipt.receiptNote =  self.receiptDescriptionText.text;
    receipt.receiptTimeStamp = self.receiptDate.date;
    
    
    NSEntityDescription *entityTag = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.persistentContainer.viewContext];
    
    Tag *tag = [[Tag alloc] initWithEntity:entityTag insertIntoManagedObjectContext:self.persistentContainer.viewContext];
    tag.tagName = self.categorySelected;

    
    //set the many to many relationshipa
    NSSet *tags = [NSSet setWithObject:tag];
    receipt.tag = tags;
    
    NSSet *receipts = [NSSet setWithObject:receipt];
    tag.receipt = receipts;
    
    
    //[self saveContext];
    NSError *error = nil;
    [self.persistentContainer.viewContext save:&error];
    [self.delegate saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)receiptCancelAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
