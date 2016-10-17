//
//  PMODraw.h
//  MaltCoLottery
//
//  Created by Peter Molnar on 07/08/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMODrawProtocol.h"
/**
 PMODraw: a pure and immutable dataset of each draw.
 */
@interface PMODraw : NSObject <PMODrawProtocol>

/**
 drawDate : The date of the draw.
 */
@property (strong, nonatomic, nonnull) NSDate *drawDate;

/**
 Numbers: Array of NSNumbers, representing the numbers were drawn on that particular day.
 
 Can be nil!
 */
@property (strong, nonatomic, nullable) NSArray<NSNumber*> *numbers;


@end
