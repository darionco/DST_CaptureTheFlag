return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.3.3",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 10,
  height = 10,
  tilewidth = 64,
  tileheight = 64,
  nextlayerid = 3,
  nextobjectid = 54,
  properties = {},
  tilesets = {
    {
      name = "ground",
      firstgid = 1,
      filename = "../../../../../../Don't Starve Mod Tools/mod_tools/Tiled/dont_starve/ground.tsx",
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      columns = 8,
      image = "../../../../../../Don't Starve Mod Tools/mod_tools/Tiled/dont_starve/tiles.png",
      imagewidth = 512,
      imageheight = 384,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 64,
        height = 64
      },
      properties = {},
      terrains = {},
      tilecount = 48,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 1,
      name = "BG_TILES",
      x = 0,
      y = 0,
      width = 10,
      height = 10,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        2, 2, 2, 2, 9, 7, 7, 7, 7, 7,
        9, 9, 9, 2, 9, 7, 7, 7, 7, 7,
        7, 7, 9, 2, 9, 9, 9, 7, 7, 7,
        7, 7, 9, 2, 2, 2, 9, 7, 7, 7,
        7, 7, 9, 9, 9, 2, 9, 9, 9, 7,
        7, 7, 7, 7, 9, 2, 2, 2, 9, 7,
        7, 7, 7, 7, 9, 9, 9, 2, 9, 9,
        7, 7, 7, 7, 7, 7, 9, 2, 2, 9,
        7, 7, 7, 7, 7, 7, 9, 9, 2, 2,
        7, 7, 7, 7, 7, 7, 7, 9, 9, 2
      }
    },
    {
      type = "objectgroup",
      id = 2,
      name = "FG_OBJECTS",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 7,
          name = "",
          type = "ctf_spawn",
          shape = "point",
          x = 32,
          y = 32,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["color"] = "yellow"
          }
        },
        {
          id = 8,
          name = "",
          type = "ctf_spawn",
          shape = "point",
          x = 608,
          y = 608,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["color"] = "yellow"
          }
        },
        {
          id = 44,
          name = "",
          type = "ctf_spawn",
          shape = "point",
          x = 32,
          y = 32,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["color"] = "yellow"
          }
        },
        {
          id = 53,
          name = "name_name",
          type = "beebox",
          shape = "point",
          x = 337.255,
          y = 220.915,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["data.ctf_team"] = 1
          }
        }
      }
    }
  }
}
