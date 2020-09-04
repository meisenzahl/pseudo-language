project('com.github.meisenzahl.pseudo-language', 'vala', 'c')

# Include the translations module
i18n = import('i18n')

# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

gee_dep = dependency('gee-0.8')
gio_dep = dependency('gio-2.0')

dependencies = [
    gee_dep,
    gio_dep,
]

subdir('src')
