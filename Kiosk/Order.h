//
//  Order.h
//  Kiosk
//
//  Created by ovlesser on 19/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Customer, Item;

NS_ASSUME_NONNULL_BEGIN

@interface Order : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Order+CoreDataProperties.h"
