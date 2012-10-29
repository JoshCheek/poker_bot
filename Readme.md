Jumped into a poker tournament late, hacked some shit out with Lee. It was fun :)

It died, we think because it bets when it has a "good" hand, regardless of table history.
The hypothesis is we wound up all in after a betting war with another bot, and the other bot had the better hand.

Changes that should be made, but I'm not going to b/c I have no server to test
changes against, and this currently works, even though it has things I want to change.

* The Tournament#replace uses the wrong key
* make Analyzer#bet? smarter, so it doesn't end up in raising wars
* `Hand#to_discard` is misnamed, it should know that these aren't the important cards for its hand type, but not that this in turn means they should be discarded
* `Player#my_turn?` talks to tournament internals, that should be moved into the tournament object
* `Tournament#should_bet?` is confusing to everyone, Lee suggested we change it, but it made sense to me at the time (still does, but he was right, it should be changed to `can_bet?`)


