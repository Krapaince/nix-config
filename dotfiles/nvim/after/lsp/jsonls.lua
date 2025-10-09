return {
  settings = {
    json = {
      validate = { enable = true },
      shcema = require('schemastore').json.schemas(),
    },
  },
}
