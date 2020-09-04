sources = [
    'PortableObject.vala',
    'String.vala',
]

executable(
    meson.project_name(),
    sources + ['Application.vala'],
    dependencies: dependencies,
    install : true
)

tests = [
    'String'
]

foreach test_name : tests
    test_exe = executable(
        '_'.join(test_name.split('/')),
        sources + [test_name + '.test.vala'],
        dependencies: dependencies
    )
    test(
        '_'.join(test_name.split('/')),
        test_exe
    )
endforeach
