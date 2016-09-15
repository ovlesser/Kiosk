//
// Created by Florian on 17.08.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "FileImporter.h"



@interface CustomerFileImporter : FileImporter

@property (readonly, nonatomic, copy) NSDictionary *customerIdentifierToObjectID;

@end
