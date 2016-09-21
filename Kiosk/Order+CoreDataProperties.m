//
//  Order+CoreDataProperties.m
//  Kiosk
//
//  Created by ovlesser on 19/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Order+CoreDataProperties.h"

@implementation Order (CoreDataProperties)

@dynamic date;
@dynamic number;
@dynamic postage;
@dynamic exchangeRate;
@dynamic customer;
@dynamic item;

@end
