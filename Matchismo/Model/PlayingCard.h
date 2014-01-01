//
//  PlayingCard.h
//  Matchismo
//
//  Created by James Reid on 12/31/13.
//  Copyright (c) 2013 Koinonia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
