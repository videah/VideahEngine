return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 10,
  height = 10,
  tilewidth = 64,
  tileheight = 64,
  properties = {},
  tilesets = {
    {
      name = "dev",
      firstgid = 1,
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "../data/images/tilesheets/dev.png",
      imagewidth = 512,
      imageheight = 256,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 10,
      height = 10,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
        3, 1, 2, 1, 2, 1, 2, 1, 2, 3,
        3, 2, 1, 2, 1, 2, 1, 2, 1, 3,
        3, 1, 2, 1, 2, 1, 2, 1, 2, 3,
        3, 2, 1, 2, 1, 2, 1, 2, 1, 3,
        3, 1, 2, 1, 2, 1, 2, 1, 2, 3,
        3, 2, 1, 2, 1, 2, 1, 2, 1, 3,
        3, 1, 2, 1, 2, 1, 2, 1, 2, 3,
        3, 2, 1, 2, 1, 2, 1, 2, 1, 3,
        3, 3, 3, 3, 3, 3, 3, 3, 3, 3
      }
    }
  }
}
