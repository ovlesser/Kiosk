//
//  Stock+CoreDataProperties.h
//  Kiosk
//
//  Created by ovlesser on 19/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Stock.h"

NS_ASSUME_NONNULL_BEGIN

@interface Stock (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *count;
@property (nullable, nonatomic, retain) NSManagedObject *product;

@end

NS_ASSUME_NONNULL_END