//
//  PMODrawStorageFactory.m
//  MaltCoLottery
//
//  Created by Peter Molnar on 09/08/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMODrawStorageFactory.h"
#import "PMODrawDateGenerator.h"
#import "PMODrawModelControllerFactory.h"

@interface PMODrawStorageFactory()

@property (strong, nonatomic) PMODrawDateGenerator *dateGenerator;

@end

@implementation PMODrawStorageFactory


#pragma mark - Accessor
- (PMODrawDateGenerator *)dateGenerator {
    if (!_dateGenerator) {
        PMODrawDateGenerator *dateGenerator = [[PMODrawDateGenerator alloc] init];
        _dateGenerator = dateGenerator;
    }
    return _dateGenerator;
}


#pragma mark - Public API

- (nonnull PMODrawStorageController *)buildStorageFromDate:(nonnull NSDate *)fromDate toDate:(nonnull NSDate *)toDate withExistingModelControllers:(nullable NSArray <PMODrawModelController*>*)exisitingModelControllers  {
    NSMutableArray <PMODrawModelController *>*modelControllers = [[NSMutableArray alloc] init];
    
    NSArray <NSDate *>*drawDates = [self.dateGenerator drawDaysFromDate:fromDate toDate:toDate];
    
    for (NSDate *currentDate in drawDates) {
        NSPredicate *predicateForCurrDrawDate = [NSPredicate predicateWithFormat:@"drawDate = %@", currentDate];
        NSArray *filteredArray = [exisitingModelControllers filteredArrayUsingPredicate:predicateForCurrDrawDate];
        PMODrawModelController *currentModelController;
        if ([filteredArray count]) {
            currentModelController = [filteredArray firstObject];
        } else {
            currentModelController = [PMODrawModelControllerFactory buildDrawModellControllerFromDrawDate:currentDate];
        }
        if (currentModelController) {
            [modelControllers addObject:currentModelController];
        }
    }
    
    PMODrawStorageController *storageController = [[PMODrawStorageController alloc] initWithModelControllers:modelControllers];
    
    return storageController;
    
}

- (PMODrawStorageController *)buildStorageWithExistingModelControllers:(nullable NSArray <PMODrawModelController*>*)exisitingModelControllers {
    // The first draw date was in 2004 January in Malta
    NSDate *fromDate = [self.dateGenerator createDateFromComponentsWithYear:2004 withMonth:1 withDay:1];
    NSDate *toDate = [NSDate date];
    
    return [self buildStorageFromDate:fromDate toDate:toDate withExistingModelControllers:(NSArray <PMODrawModelController*>*)exisitingModelControllers];
}

@end
