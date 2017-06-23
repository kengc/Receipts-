//
//  ViewController.m
//  Receipts++
//
//  Created by Kevin Cleathero on 2017-06-22.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "MainTableViewCell.h"
#import "Receipt+CoreDataProperties.h"
#import "Receipt+CoreDataClass.h"
#import "Tag+CoreDataClass.h"
#import "Tag+CoreDataProperties.h"

NSString * const headerReuseIdentifier = @"headerReuseIdentifier";

@interface ViewController ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic)  NSMutableArray *receipts;
@property (nonatomic)  NSArray *categoryResults;

@property (nonatomic) NSMutableDictionary *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerReuseIdentifier];
    
    //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //self.persistentContainer = appDelegate.persistentContainer;
    
    self.receipts = [[NSMutableArray alloc] init];
    self.dataSource = [[NSMutableDictionary alloc] init];
    
    [self loadFromCD];
    
   
 

    
}

-(void)loadFromCD{
    
    self.context = self.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [Tag fetchRequest];
    
    [fetchRequest setRelationshipKeyPathsForPrefetching:@[@"receipt"]];
    
    NSError *error = nil;
    
    self.categoryResults = [self.context executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"categoryResults: %lu", (unsigned long)self.categoryResults.count);
//    for(Receipt *rec in self.categoryResults){
//        [self.receipts addObject:rec];
//    }
    NSMutableArray *tempArray = [NSMutableArray new];
    NSString *tagName;
    
    for(Tag *tag in self.categoryResults){
        NSLog(@"tag name: %@",tag.tagName);
        NSLog(@"tag name: %@",tag.receipt);
        [tempArray addObject:tag.receipt];
        tagName = tag.tagName;
    }
    
    if (tagName != nil)
    {
        [self.dataSource setObject:tempArray forKey:tagName];
    }
    
    //each category you need an array of receipts
    
    NSLog(@"receipts: %@", self.receipts);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //return self.fetchedResultsController.sections.count;
    NSLog(@"sections: %lu", (unsigned long)self.categoryResults.count);
    return self.dataSource.allKeys.count;
    //return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.fetchedResultsController.sections[section].objects.count;
    //NSLog(@"Rows: %lu", (unsigned long)self.receipts.count);
    //return self.receipts.count;
    NSString *tagName = [self.dataSource.allKeys objectAtIndex:section];
    
    if ([tagName isEqualToString:@"Personal"]) {
        return [[self.dataSource objectForKey:@"Personal"]count];
    } else if ([tagName isEqualToString:@"Family"]) {
        return [[self.dataSource objectForKey:@"Family"]count];
    } else {
        return [[self.dataSource objectForKey:@"Business"]count];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self loadFromCD];
    
    /////////////////
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSEntityDescription *tagEntity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.persistentContainer.viewContext];
    NSEntityDescription *receiptEntity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.persistentContainer.viewContext];

    Tag *tag = [[Tag alloc] initWithEntity:tagEntity insertIntoManagedObjectContext:self.persistentContainer.viewContext];
    Receipt *receipt = [[Receipt alloc] initWithEntity:receiptEntity insertIntoManagedObjectContext:self.persistentContainer.viewContext];
    
    NSArray *array;

    
    NSString *tagName = [self.dataSource.allKeys objectAtIndex:indexPath.section];
    
    if ([tagName isEqualToString:@"Personal"]) {
        array = [NSArray arrayWithArray:[self.dataSource objectForKey:@"Personal"]];
    } else if ([tagName isEqualToString:@"Family"]) {
        array = [NSArray arrayWithArray:[self.dataSource objectForKey:@"Family"]];
    } else {
        array = [NSArray arrayWithArray:[self.dataSource objectForKey:@"Business"]];
    }

//    tag = [array objectAtIndex:indexPath.row];
//    
//    //NSArray *array = [tag allObjects];
//    receipt = [tag valueForKey:@"receipt"];
//    [receipt addTag:tag];
    
    NSSet<Receipt *> *receipts = [array objectAtIndex:indexPath.row];
     //random now - put this ode in viewDidLoad/viewDidAppear ?
    receipt = [receipts anyObject];
    
    //tag name not included
    //pretell fetch results we need receipt with the tag
    
    
    
    cell.mainTableCellLabel.text = receipt.receiptNote;
    
    //Receipt *receipt = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //cell.mainTableCellLabel.text = tag.tagName;
    
    return cell;
}

- (IBAction)addRecriptAction:(UIButton *)sender {
        [self performSegueWithIdentifier:@"showReceiptView" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"showReceiptView"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        ToDo *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        AddReceiptViewController *controller = (AddReceiptViewController *)[segue destinationViewController];
          controller.delegate = self;
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *tagName = [self.dataSource.allKeys objectAtIndex:section];

    if ([tagName isEqualToString:@"Personal"]) {
        return @"Personal";
    } else if ([tagName isEqualToString:@"Family"]) {
        return @"Family";
    } else {
        return @"Business";
    }

}
#pragma mark - Core Data

- (void)saveContext {
//    NSManagedObjectContext *context = self.persistentContainer.viewContext;
//    NSError *error = nil;
//    if ([context hasChanges] && ![context save:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//        abort();
//    }
    [self.tableView reloadData];
}

@end
