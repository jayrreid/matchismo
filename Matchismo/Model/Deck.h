//
//  Deck.h
//  Matchismo
//
//  Created by James Reid on 12/31/13.
//  Copyright (c) 2013 Koinonia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
