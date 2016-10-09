//
//  Customer+CoreDataProperties.h
//  
//
//  Created by ovlesser on 25/09/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Customer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Customer (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *identification;
@property (nullable, nonatomic, retain) NSString *mobile;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *nickname;

@end

NS_ASSUME_NONNULL_END
