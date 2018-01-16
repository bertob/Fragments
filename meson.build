project(
  'fragments', ['vala', 'c'],
  version: '0.0.1',
  license: 'GPL3',
  meson_version: '>= 0.40.0'
)

cc = meson.get_compiler('c')
valac = meson.get_compiler('vala')

# Fragments deps
glib_dep = dependency('glib-2.0', version : '>=2.38')
gobject_dep = dependency('gobject-2.0')
gio_dep = dependency('gio-2.0')
gtk_dep = dependency('gtk+-3.0', version : '>=3.20.10')
dazzle_dep = dependency('libdazzle-1.0', version : '>=3.20.10')

# libtransmission deps
dht_dep = dependency('dht', fallback : ['dht', 'dht_dep'])
utp_dep = dependency('libutp', fallback : ['libutp', 'utp_dep'])
natpmp_dep = dependency('libnatpmp', fallback : ['libnatpmp', 'natpmp_dep'])
miniupnpc_dep = dependency('miniupnpc', fallback : ['miniupnpc', 'miniupnpc_dep'])

gnome = import('gnome')
i18n = import('i18n')

po_dir = join_paths(meson.source_root(), 'po')

subdir('external')
subdir('data')
subdir('po')
subdir('src')

meson.add_install_script('postinstall.py')

