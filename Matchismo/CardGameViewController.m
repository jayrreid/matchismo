//
//  CardGameViewController.m
//  Matchismo
//
//  Created by James Reid on 12/30/13.
//  Copyright (c) 2013 Koinonia. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong,nonatomic) PlayingCardDeck* deck;
@end

@implementation CardGameViewController


-(Deck*)deck {
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

-(void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flipCount changed to %d", self.flipCount);
}

- (IBAction)touchCardButton:(UIButton *)sender {
    
    
    if([sender.currentTitle length]){
        [sender setBackgroundImage:[UIImage imageNamed:@"cardback"]
                          forState:(UIControlStateNormal)];
        [sender setTitle:@"" forState:UIControlStateNormal];
    } else {
        
        // get deck of cards and get a random card
        Deck* deck = self.deck;
        Card* randomCard = [deck drawRandomCard];

        [sender setBackgroundImage:[UIImage imageNamed:@"cardfront"]
                          forState:(UIControlStateNormal)];
        
        // set title to random card's rank and suit
        [sender setTitle:[randomCard contents]forState:UIControlStateNormal];
    }
    
    self.flipCount++;
    
}


@end
