vala_sources = [
  'fragments-app.vala',
  'fragments-torrent.vala',
  'fragments-window.vala'
]

deps = [
#  dazzle_dep,
  gtk_dep,
  transmission_dep
]

vala_args = [
        '--vapidir=' + meson.current_source_dir() + '/vapis',
	'--target-glib=2.38']

executable(
  meson.project_name(),
  vala_sources + resources,
  dependencies: deps,
  vala_args: vala_args,
  install: true
)

