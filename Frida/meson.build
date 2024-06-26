subdir('Frida_Private')

sources = [
  'ApplicationDetails.swift',
  'AsyncOperation.swift',
  'Bus.swift',
  'BusDelegate.swift',
  'ChildDetails.swift',
  'CrashDetails.swift',
  'Device.swift',
  'DeviceDelegate.swift',
  'DeviceManager.swift',
  'DeviceManagerDelegate.swift',
  'Error.swift',
  'IOStream.swift',
  'Marshal.swift',
  'PortalMembership.swift',
  'ProcessDetails.swift',
  'Relay.swift',
  'RpcFunction.swift',
  'RpcRequest.swift',
  'Runtime.swift',
  'Script.swift',
  'ScriptDelegate.swift',
  'Session.swift',
  'SessionDelegate.swift',
  'SignalConnection.swift',
  'SpawnDetails.swift',
]

extra_link_args = []
if host_os_family == 'darwin'
  extra_link_args += ['-Xlinker', '-exported_symbol', '-Xlinker', '_$*']
elif cc.get_argument_syntax() != 'msvc'
  extra_link_args += ['-Xlinker', '-export-symbols-regex', '-Xlinker', '^_\\$.+']
endif

frida_lib = shared_library('Frida', sources,
  include_directories: include_directories('.'),
  swift_args: [
    '-swift-version', '5',
    '-enable-library-evolution',
    '-emit-module-interface',
    '-framework', 'Foundation',
  ],
  link_args: extra_link_args,
  dependencies: frida_private_dep,
  install: host_os_family != 'darwin',
)

if host_os_family == 'darwin'
  custom_target('frida-framework',
    input: [
      frida_lib,
      'Frida.h',
      'Info.plist',
    ],
    output: 'Frida.framework',
    command: [
      python,
      files('generate-framework.py'),
      host_triplet,
      '@OUTPUT@',
      '@INPUT@',
    ],
    install: true,
    install_dir: get_option('prefix') / 'Frameworks',
  )
endif
