//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by James Reid on 1/4/14.
//  Copyright (c) 2014 Koinonia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject


//designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                   usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;


// Readonly public method. It's overridden implementation
// so it can be set privately. Readonly means there is
// no setter (only a getter)
@property (nonatomic, readonly) NSInteger score;

@property (nonatomic, strong) NSMutableArray *matchHistory; // of NSString

@end
