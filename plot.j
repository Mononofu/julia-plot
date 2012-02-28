libmgl = dlopen("libmgl")

function mgl_create_graph_zb(x::Int, y::Int)
	ccall(dlsym(libmgl, :mgl_create_graph_zb), Ptr{Int}, (Int, Int), x, y)
end

function mgl_subplot(gr::Ptr{Int}, x::Int, y::Int, z::Int)
	ccall(dlsym(libmgl, :mgl_subplot), Ptr, (Ptr{Int}, Int, Int, Int), gr, x, y, z)
end

function mgl_rotate(gr::Ptr{Int}, x::Int, y::Int, z::Int)
	ccall(dlsym(libmgl, :mgl_rotate), Ptr, (Ptr{Int}, Int, Int, Int), gr, x, y, z)
end

function mgl_box(gr::Ptr{Int}, f::Bool)
	ccall(dlsym(libmgl, :mgl_box), Ptr, (Ptr{Int}, Bool), gr, f)
end

function mgl_write_png(gr::Ptr{Int}, filename::String)
	ccall(dlsym(libmgl, :mgl_write_png), Ptr, (Ptr{Int}, Ptr{Uint8}, Int), gr, filename, 0)
end

function mgl_set_alpha(gr::Ptr{Int}, f::Bool)
	ccall(dlsym(libmgl, :mgl_set_alpha), Ptr, (Ptr{Int}, Bool), gr, f)
end

function mgl_set_light(gr::Ptr{Int}, f::Bool)
	ccall(dlsym(libmgl, :mgl_set_light), Ptr, (Ptr{Int}, Bool), gr, f)
end

function mgl_surf(gr::Ptr{Int}, plot_data::Ptr{Int}, colors::String)
	ccall(dlsym(libmgl, :mgl_surf), Ptr, (Ptr{Int}, Ptr{Int}, Ptr{Uint8}), gr, plot_data, colors)
end

function mgl_plot(gr::Ptr{Int}, plot_data::Ptr{Int}, colors)
	ccall(dlsym(libmgl, :mgl_plot), Ptr, (Ptr{Int}, Ptr{Int}, Ptr{Uint8}), gr, plot_data, colors)
end

function mgl_bars(gr::Ptr{Int}, plot_data::Ptr{Int}, colors)
	ccall(dlsym(libmgl, :mgl_bars), Ptr, (Ptr{Int}, Ptr{Int}, Ptr{Uint8}), gr, plot_data, colors)
end

function mgl_data_modify(plot_data::Ptr{Int}, fun::String)
	ccall(dlsym(libmgl, :mgl_data_modify), Ptr, (Ptr{Int}, Ptr{Uint8}, Int), plot_data, fun, 0)
end

function mgl_data_set(plot_data::Ptr{Int}, data::Array{Float32, 1})
	ccall(dlsym(libmgl, :mgl_data_set_float), Ptr, (Ptr{Int}, Ptr{Float}, Int, Int, Int), plot_data, pointer(data), length(data), 1, 1)
end

function mgl_data_set(plot_data::Ptr{Int}, data::Array{Float32, 1}, num_funs::Int)
	ccall(dlsym(libmgl, :mgl_data_set_float), Ptr, (Ptr{Int}, Ptr{Float}, Int, Int, Int), plot_data, pointer(data), div(length(data), num_funs), num_funs, 1)
end

function mgl_create_data_size(x::Int, y::Int, z::Int)
	ccall(dlsym(libmgl, :mgl_create_data_size), Ptr{Int}, (Int, Int, Int), x, y, z)
end

function mgl_set_axis(gr::Ptr{Int}, x_min::Float32, x_mid::Float32, x_max::Float32, y_min::Float32, y_mid::Float32, y_max::Float32, z_min::Float32, z_mid::Float32, z_max::Float32)
	ccall(dlsym(libmgl, :mgl_set_axis), Ptr, (Ptr{Int}, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32), gr, x_min, x_mid, x_max, y_min, y_mid, y_max, z_min, z_mid, z_max)
end

function mgl_set_axis(gr::Ptr{Int}, x_min::Float32, x_max::Float32, y_min::Float32, y_max::Float32)
	ccall(dlsym(libmgl, :mgl_set_axis_2d), Ptr, (Ptr{Int}, Float32, Float32, Float32, Float32), gr, x_min, y_min, x_max, y_max)
end

function mgl_set_axis(gr::Ptr{Int}, x_min::Int, x_max::Int, y_min::Int, y_max::Int)
	mgl_set_axis(gr, float32(x_min), float32(x_max), float32(y_min), float32(y_max))
end

function mgl_axis(gr::Ptr{Int}, axis::String)
	ccall(dlsym(libmgl, :mgl_axis), Ptr, (Ptr{Int}, Ptr{Uint8}), gr, axis)
end


type Plot
	width::Int
	height::Int
	funs::Array{Any, 1}
	plot_type::String
	plot_points::Int

	Plot(width::Int, height::Int) = new( width, height, [(x -> 0, "g")], "lines", 500 )
end

type DataPlot
	width::Int
	height::Int
	plot_type::String
	data::Array{Any, 1}

	DataPlot(width::Int, height::Int) = new(width, height, "lines", [ ([float32(2)], "b")])
end
       
function add(plot::Plot, fun::Any)
	add(plot, fun, "r")
end

function add(plot::Plot, fun::Any, color::String)
  plot.funs = cat(1, plot.funs, [(fun, color)])
  plot
end

function add(plot::DataPlot, data::Array{Float32, 1}, color::String)
	plot.data = push(plot.data, (data, color))
	plot
end

function paint(pl::Plot, xmin::Number, xmax::Number, filename::String)
	data = [ (generate_data(fun[1], xmin, xmax, pl.plot_points), fun[2]) | fun=pl.funs]
	plot(data, xmin, xmax, pl.width, pl.height, filename, pl.plot_type)
end

function paint(pl::DataPlot, xmin::Number, xmax::Number, filename::String)
	plot(pl.data, xmin, xmax, pl.width, pl.height, filename, pl.plot_type)
end

function setup_graph(width::Int, height::Int)
	graph = mgl_create_graph_zb(width, height)
	mgl_box(graph, true)
	graph
end

function generate_data(fun::Function, xmin::Number, xmax::Number, plot_points::Int)
	# generate data
	y = Array(Float32, plot_points)

	x = [xmin+float32(i-1)*(xmax-xmin)/(plot_points-1) | i=1:plot_points]

	for i=1:plot_points
		y[i] = fun(x[i])
	end
	y
end


function plot(y::Array{Any, 1}, xmin::Number, xmax::Number, width::Int, height::Int, filename::String, plot_type::String)
	graph = setup_graph(width, height)

	ymin = 1e20
	ymax = -1e20

	for i=1:length(y)
		for j=1:length(y[i][1])
			ymin = min(ymin, y[i][1][j])
			ymax = max(ymax, y[i][1][j])
		end
	end

	mgl_set_axis(graph, float32(xmin), float32(xmax), ymin, ymax)

	# skip first datapoint - placeholder
	for i=2:length(y)
		data, color = y[i]

		# create structure to hold plot data
		# ugly hack because type inference fails
		dat::Array{Float32, 1} = [float32(n) | n=data]
		plot_data = mgl_create_data_size(length(data), 1, 1)

		# save our plot data to the new structure
		mgl_data_set(plot_data, dat)

		if plot_type == "lines"
			mgl_plot(graph, plot_data, color)
		elseif plot_type == "bars"
			mgl_bars(graph, plot_data, color)
		end
	end		

	paint_to_file(graph, filename)
end

function paint_to_file(graph::Ptr{Int}, filename::String)
	mgl_axis(graph,"xy")
	mgl_write_png(graph, filename)
end

function plot(fun::Function, xmin::Number, xmax::Number, filename::String)
	pl = Plot(800, 300)
	add(pl, fun)
	paint(pl, xmin, xmax, filename)
end


pl = Plot(800, 300)
add(pl, x -> sin(x))
add(pl, x -> 2*cos(x), "b")
paint(pl, -4, 4, "classy.png")


# generate random data
num_bins = 50
data = zeros(Float32, num_bins)
[ data[ 1 + ifloor(rand()*num_bins)] += 1 | i=1:100000]

dpl = DataPlot(800, 300)
add(dpl, data, "r")
dpl.plot_type = "bars"
paint(dpl, 0, 1, "random.png")


plot(x -> exp(x), 0, 5, "exp.png")
