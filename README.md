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

Advanced Plotting
--------------------------

If you want to plot more than one function, use the advanced interface:

		# create new plot of size 800x300
		pl = Plot(800, 300)

		# add functions
		add(pl, x -> sin(x))
		# optionally choose a color
		add(pl, x -> 2*cos(x), "b")

		# export to a file
		paint(pl, "myplot.png")

![screenshot](https://github.com/Mononofu/julia-plot/raw/master/colored.png)

Wait, there's more!
--------------------------

Of course, you can also pass the data directly, without specifying a generating
function. And you don't have to use line charts either - we also support bar charts!

For example, we might want to check how random julia's `rand()` function really is.
On simplistic approach might look like this:

		# generate random data
		num_bins = 50
		data = zeros(Float32, num_bins)
		[ data[ 1 + ifloor(rand()*num_bins)] += 1 | i=1:100000]

		# plot it so we can see clustering
		dpl = DataPlot(800, 300)
		add(dpl, data, "r")
		dpl.plot_type = "bars"
		paint(dpl, 0, 1, "random.png")

![screenshot](https://github.com/Mononofu/julia-plot/raw/master/random.png)

