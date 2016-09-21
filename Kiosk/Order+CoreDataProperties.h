//
//  Order+CoreDataProperties.h
//  Kiosk
//
//  Created by ovlesser on 19/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Order.h"

NS_ASSUME_NONNULL_BEGIN

@interface Order (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *number;
@property (nullable, nonatomic, retain) NSDecimalNumber *postage;
@property (nullable, nonatomic, retain) NSDecimalNumber *exchangeRate;
@property (nullable, nonatomic, retain) Customer *customer;
@property (nullable, nonatomic, retain) NSSet<Item *> *item;

@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addItemObject:(Item *)value;
- (void)removeItemObject:(Item *)value;
- (void)addItem:(NSSet<Item *> *)values;
- (void)removeItem:(NSSet<Item *> *)values;

@end

NS_ASSUME_NONNULL_END
