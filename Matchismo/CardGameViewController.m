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
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong,nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameMode;
@property (weak, nonatomic) IBOutlet UILabel *matchResultsLabel;
@end

@implementation CardGameViewController

- (CardMatchingGame *) game
{
    
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCountAndMode:[self.cardButtons count]
                                                                usingDeck:[self createDeck]
                                                                 gameMode:[self.gameMode selectedSegmentIndex]];
    
    return _game;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    
    // disable game mode selection
    if (self.gameMode.enabled)
        self.gameMode.enabled = NO;
    
    // controller must still do its job of interpreting
    // the Model into the view
    [self updateUI];
}

- (IBAction)dealCards:(id)sender {
    
    // reset game (includes reseting score to zero
    _game = [[CardMatchingGame alloc] initWithCardCountAndMode:[self.cardButtons count]
                                                     usingDeck:[self createDeck]
                                                      gameMode:[self.gameMode selectedSegmentIndex]];
    
    // re-dealing cards to start new game
    // enable game mode selection
    self.gameMode.enabled = YES;
    
    // update UI
    [self updateUI];
    
}


- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:(UIControlStateNormal)];
        cardButton.enabled = !card.isMatched;
     }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    
    self.matchResultsLabel.text = [self.game.matchHistory lastObject];
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *) backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}


@end
