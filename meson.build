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

glib_dep = dependency('glib-2.0', version : '>=2.38')
gobject_dep = dependency('gobject-2.0')
gio_dep = dependency('gio-2.0')
gtk_dep = dependency('gtk+-3.0', version : '>=3.20.10')
dazzle_dep = dependency('libdazzle-1.0', version : '>=3.20.10')

subdir('data')
subdir('po')
subdir('src')

meson.add_install_script('postinstall.py')

