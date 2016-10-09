//
//  Stock+CoreDataProperties.h
//  
//
//  Created by ovlesser on 25/09/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Stock.h"

NS_ASSUME_NONNULL_BEGIN

@interface Stock (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *count;
@property (nullable, nonatomic, retain) Product *product;

@end

NS_ASSUME_NONNULL_END
