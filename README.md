julia-plot
-----------------------

This library uses [MathGL](http://mathgl.sourceforge.net) to plot, 
please download and compile it, then put it on your path (or just 
in this dir) so julia can find it.

If you don't want to compile it yourself, I've uploaded the version I use.
It was compiled on Ubuntu 11.10 x64, so maybe it works for you - it's in the
downloads area.

Usage
--------------------------

Too plot a singe function:
		plot(x -> sin(x), -4, 4, "sample.png")

		plot(function, xmin, xmax, filename)

a list of functions:
		plot([x -> sin(x), x -> cos(x)], -4, 4, "dual.png")

a list of (function, color) pairs:
		plot([(x -> 2*sin(2x), "r"), (x -> cos(x), "b")], -4, 4, "colored.png")


Screenshot
-------------------------
![screenshot](https://github.com/Mononofu/julia-plot/raw/master/colored.png)