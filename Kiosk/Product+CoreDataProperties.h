//
//  Product+CoreDataProperties.h
//  Kiosk
//
//  Created by ovlesser on 19/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@interface Product (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *brand;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDecimalNumber *price;
@property (nullable, nonatomic, retain) NSString *vendor;
@property (nullable, nonatomic, retain) NSNumber *volume;

@end

NS_ASSUME_NONNULL_END
