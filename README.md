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

If you want to plot more than one function, use the advanced interface:

		# create new plot of size 800x300
		pl = Plot(800, 300)

		# add functions
		add(pl, x -> sin(x))
		# optionally choose a color
		add(pl, x -> cos(x))

		# export to a file
		paint(pl, "myplot.png")


Screenshot
-------------------------
![screenshot](https://github.com/Mononofu/julia-plot/raw/master/colored.png)