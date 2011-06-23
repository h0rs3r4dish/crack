Devlog
======

23 June 2011 - 1:15 AM
----------------------

Everything's going pretty well. I've got Foil under wraps, pretty much, except
for the window hiding thing. When you hide a Window, Foil will (eventually) find
the intersection of that window with other windows, then only have windows below
re-draw that rectangle. I'm being lazy, and instead of figuring that out, I just
make *every* window re-draw *everything*. It feels kind of wrong, but so far,
my tech demos haven't show any crazy slowdown or anything like that.

Speaking of which, I've started whipping up tech demos. They're basically tests
for stuff I'm working on, to work out weird bugs I can't quite catch. I just ran
into one that disappeared, actually. Originally, I had `Window#redraw` just use
`Window#text_at`, because it was easy; I passed some coordinates and the bit of
the line I wanted to redraw, and it was there on my screen. But then I noticed a
weird case with `tech_demo/02_replace_characters.rb`: when I'd have the window
clean up behind the `@` as it moved, there would be anomolies out of the blue.
The background is "map!" 20 times per line, so I would notice if something was
off. It worked; every now and then, when moving horizontally, I would end up
with a trail of `mpmpmpmp` behind the symbol, for no good reason. The window's
`@map` thought it should be those two letters, too; it just dropped the A and
exclamation mark. I realized, while looking over the code, that the word-wrap
checks in `#text_at` were kind of pointless for this, since I knew the text was
going to fit perfectly wherever it was put. So, to try and see how the bug was
presented, I rewrote `#redraw` and made it just go to the coordinates and print
letters by itself. Poof. Bug gone. I assume it's still lurking somewhere within
the `#text_at` method, but honestly, I don't care. I have no idea how it got to
where it is, or what caused it, or anything. Everything's working now, so I'm
just going to ignore it and hope I fixed whatever it was.
