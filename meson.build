project(
  'fragments', ['vala', 'c'],
  version: '0.0.1',
  license: 'GPL3',
  meson_version: '>= 0.40.0'
)

gnome = import('gnome')
i18n = import('i18n')

cc = meson.get_compiler('c')
valac = meson.get_compiler('vala')

vapi_dir = join_paths (meson.source_root (), 'src', 'vapis')
po_dir = join_paths(meson.source_root(), 'po')

# Fragments dependencies
glib_dep = dependency('glib-2.0', version : '>=2.38')
gobject_dep = dependency('gobject-2.0')
gio_dep = dependency('gio-2.0')
gtk_dep = dependency('gtk+-3.0', version : '>=3.20.10')
dazzle_dep = dependency('libdazzle-1.0', version : '>=3.20.10')

# libtransmission dependencies
b64_lib = meson.get_compiler('c').find_library('b64')
utp_lib = meson.get_compiler('c').find_library('utp')
miniupnpc_lib = meson.get_compiler('c').find_library('miniupnpc')
dht_lib = meson.get_compiler('c').find_library('dht')
natpmp_lib = meson.get_compiler('c').find_library('natpmp')
curl_lib = meson.get_compiler('c').find_library('libcurl')
crypto_lib = meson.get_compiler('c').find_library('libcrypto')
event_lib = meson.get_compiler('c').find_library('event')
pthread_lib = meson.get_compiler('c').find_library('libpthread')
zlib_lib = meson.get_compiler('c').find_library('libz')
transmission_lib = meson.get_compiler('c').find_library('transmission')
transmission_vapi = meson.get_compiler('vala').find_library('transmission', dirs: vapi_dir)
transmission_dep = declare_dependency(dependencies: [pthread_lib, b64_lib, utp_lib, miniupnpc_lib, dht_lib, natpmp_lib, curl_lib, crypto_lib, event_lib, zlib_lib, transmission_lib, transmission_vapi])

subdir('data')
subdir('po')
subdir('src')

meson.add_install_script('postinstall.py')

