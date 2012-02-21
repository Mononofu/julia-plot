libmgl = dlopen("libmgl")

gr = ccall(dlsym(libmgl, :mgl_create_graph_zb), Ptr{Int}, (Int, Int), 600, 400)


function mgl_subplot(x::Int, y::Int, z::Int)
    ccall(dlsym(libmgl, :mgl_subplot), Ptr, (Ptr{Int}, Int, Int, Int), gr, x, y, z)
end

function mgl_rotate(x::Int, y::Int, z::Int)
    ccall(dlsym(libmgl, :mgl_rotate), Ptr, (Ptr{Int}, Int, Int, Int), gr, x, y, z)
end

function mgl_box(f::Bool)
    ccall(dlsym(libmgl, :mgl_box), Ptr, (Ptr{Int}, Bool), gr, f)
end

function mgl_write_png(filename::String)
    ccall(dlsym(libmgl, :mgl_write_png), Ptr, (Ptr{Int}, Ptr{Uint8}, Int), gr, filename, 0)
end

function mgl_set_alpha(f::Bool)
    ccall(dlsym(libmgl, :mgl_set_alpha), Ptr, (Ptr{Int}, Bool), gr, f)
end

function mgl_set_light(f::Bool)
    ccall(dlsym(libmgl, :mgl_set_light), Ptr, (Ptr{Int}, Bool), gr, f)
end

function mgl_surf(colors::String)
    ccall(dlsym(libmgl, :mgl_surf), Ptr, (Ptr{Int}, Ptr{Int}, Ptr{Uint8}), gr, hmdt, colors)
end

function mgl_data_modify(fun::String)
    ccall(dlsym(libmgl, :mgl_data_modify), Ptr, (Ptr{Int}, Ptr{Uint8}, Int), hmdt, fun, 0)
end


mgl_set_alpha(true)
mgl_set_light(true)

hmdt = ccall(dlsym(libmgl, :mgl_create_data_size), Ptr{Int}, (Int, Int, Int), 30, 20, 1)

mgl_data_modify("0.6*sin(2*pi*x)*sin(3*pi*y) + 0.4*cos(3*pi*(x*y))")

mgl_subplot(2, 2, 0)
mgl_rotate(40, 60, 0)
mgl_surf("BbcyrR#")
mgl_box(true)
mgl_subplot(2, 2, 1)
mgl_rotate(40, 60, 0)

mgl_write_png("sample.png")


