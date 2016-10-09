//
//  Product+CoreDataProperties.h
//  
//
//  Created by ovlesser on 25/09/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@interface Product (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *brand;
@property (nullable, nonatomic, retain) NSDecimalNumber *count;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDecimalNumber *price;
@property (nullable, nonatomic, retain) NSDecimalNumber *stock;
@property (nullable, nonatomic, retain) NSString *vendor;
@property (nullable, nonatomic, retain) NSNumber *volume;
@property (nullable, nonatomic, retain) NSString *format;

@end

NS_ASSUME_NONNULL_END
