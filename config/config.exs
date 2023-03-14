import Config

config :my_app, stipe_client: MyApp.Stipe.HTTP

import_config "#{config_env()}.exs"
