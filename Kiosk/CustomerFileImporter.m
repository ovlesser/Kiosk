//
// Created by Florian on 17.08.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CustomerFileImporter.h"
#import "Customer.h"


@interface CustomerFileImporter ()

@property (nonatomic, strong) NSMutableDictionary *mutableCustomerIdentifierToObjectID;

@end



@implementation CustomerFileImporter

- (id)initWithFileURL:(NSURL *)url managedObjectContext:(NSManagedObjectContext *)context saveInterval:(NSInteger)saveInterval
{
    self = [super initWithFileURL:url managedObjectContext:context saveInterval:saveInterval];
    if (self) {
        self.mutableCustomerIdentifierToObjectID = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)entityName
{
    return @"Customer";
}

- (void)configureObject:(NSManagedObject *)object forLine:(NSString *)line
{
    Customer *customer = (Customer *) object;
    NSArray *fields = [line componentsSeparatedByString:@","];
    customer.name = [fields[0] stringValue];
    customer.mobile = [fields[1] stringValue];
    customer.identification = [fields[2] stringValue];
    customer.address = [fields[3] stringValue];
}

- (void)saveContext
{
    // Object IDs are temporary until saved. We save first, then store the object IDs:
    NSSet *insertedCustomers = self.managedObjectContext.insertedObjects;
    [super saveContext];
    for (Customer *customer in insertedCustomers) {
        self.mutableCustomerIdentifierToObjectID[customer.identification] = customer.objectID;
    }
}

- (NSDictionary *)customerIdentifierToObjectID;
{
    return [self.mutableCustomerIdentifierToObjectID copy];
}

@end
