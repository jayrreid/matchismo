//
//  Card.h
//  Matchismo
//
//  Created by James Reid on 12/31/13.
//  Copyright (c) 2013 Koinonia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
