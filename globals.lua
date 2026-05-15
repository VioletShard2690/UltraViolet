G.C.uv = {
    RED = HEX("FF0000"),
    BLACK = HEX("000000"),
    BLUE = HEX("0000FF"),
    GREEN = HEX("00FF00"),
    WHITE = HEX("FFFFFF"),
    TRANSPARENT = HEX("00000000"),
}
local loc_colour_ref = loc_colour
function loc_colour(_c, _default)
    if not G.ARGS.LOC_COLOURS then
        loc_colour_ref()
    end
    G.ARGS.LOC_COLOURS._red = G.C.uv.RED
    G.ARGS.LOC_COLOURS._black = G.C.uv.BLACK
    G.ARGS.LOC_COLOURS._blue = G.C.uv.BLUE
    G.ARGS.LOC_COLOURS._green = G.C.uv.GREEN
    G.ARGS.LOC_COLOURS._white = G.C.uv.WHITE
    G.ARGS.LOC_COLOURS._transparent = G.C.uv.TRANSPARENT
    return loc_colour_ref(_c, _default)
end