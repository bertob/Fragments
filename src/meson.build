vala_sources = [
  'fragments-app.vala',
  'fragments-torrent.vala',
  'fragments-window.vala'
]

vapi_dir = join_paths (meson.current_source_dir (), 'vapis')

deps = [
  gtk_dep,
  transmission_dep,
  valac.find_library('transmission', dirs: vapi_dir)
]

vala_args = [
	'--target-glib=2.38']

executable(
  meson.project_name(),
  vala_sources + resources,
  dependencies: deps,
  vala_args: vala_args,
  install: true
)

