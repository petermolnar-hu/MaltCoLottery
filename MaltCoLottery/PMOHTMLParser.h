//
//  PMOHTMLParser.h
//  MaltCoLottery
//
//  Created by Peter Molnar on 08/08/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMOHTMLParser : NSObject
+ (NSArray *)drawNumbersFromRawData:(NSData *)drawRawHTMLData;
@end
