#!/usr/bin/env ruby
require 'fileutils'
require 'xcodeproj'

ROOT = File.expand_path('..', __dir__)
PROJECT_PATH = File.join(ROOT, 'LiteShunt.xcodeproj')
DEPLOYMENT_TARGET = '14.0'
SWIFT_VERSION = '6.0'
APP_NAME = 'LiteShuntApp'
EXTENSION_NAME = 'LiteShuntExtension'
SHARED_NAME = 'LiteShuntSharedKit'
TESTS_NAME = 'LiteShuntPOCTests'

APP_BUNDLE_IDENTIFIER = 'com.zero.LiteShunt'
EXTENSION_BUNDLE_IDENTIFIER = 'com.zero.LiteShunt.extension'
TESTS_BUNDLE_IDENTIFIER = 'com.zero.LiteShunt.tests'

def apply_settings(target, settings)
  target.build_configurations.each do |configuration|
    configuration.build_settings.merge!(settings)
  end
end

def add_group_file(group, path)
  group.new_file(path)
end

FileUtils.rm_rf(PROJECT_PATH)
project = Xcodeproj::Project.new(PROJECT_PATH)
project.root_object.compatibility_version = 'Xcode 16.0'

project.build_configurations.each do |configuration|
  configuration.build_settings['MACOSX_DEPLOYMENT_TARGET'] = DEPLOYMENT_TARGET
  configuration.build_settings['SWIFT_VERSION'] = SWIFT_VERSION
end

app_group = project.main_group.new_group('LiteShuntApp', 'LiteShuntApp')
app_app_group = app_group.new_group('App', 'App')
app_features_group = app_group.new_group('Features', 'Features')
app_status_group = app_features_group.new_group('Status', 'Status')
app_services_group = app_group.new_group('Services', 'Services')
app_resources_group = app_group.new_group('Resources', 'Resources')

extension_group = project.main_group.new_group('LiteShuntExtension', 'LiteShuntExtension')
extension_provider_group = extension_group.new_group('Provider', 'Provider')
extension_resources_group = extension_group.new_group('Resources', 'Resources')

shared_group = project.main_group.new_group('LiteShuntShared', 'LiteShuntShared')
shared_constants_group = shared_group.new_group('Constants', 'Constants')

tests_group = project.main_group.new_group('LiteShuntTests', 'LiteShuntTests')
tests_poc_group = tests_group.new_group('POCTests', 'POCTests')
tests_resources_group = tests_group.new_group('Resources', 'Resources')

app_target = project.new_target(:application, APP_NAME, :osx, DEPLOYMENT_TARGET, project.products_group, :swift)
extension_target = project.new_target(:app_extension, EXTENSION_NAME, :osx, DEPLOYMENT_TARGET, project.products_group, :swift)
shared_target = project.new_target(:static_library, SHARED_NAME, :osx, DEPLOYMENT_TARGET, project.products_group, :swift)
tests_target = project.new_target(:unit_test_bundle, TESTS_NAME, :osx, DEPLOYMENT_TARGET, project.products_group, :swift)

app_target.add_system_framework('NetworkExtension')
extension_target.add_system_framework('NetworkExtension')
tests_target.add_system_framework('XCTest')

app_target.add_dependency(shared_target)
app_target.frameworks_build_phase.add_file_reference(shared_target.product_reference, true)
app_target.add_dependency(extension_target)

extension_target.add_dependency(shared_target)
extension_target.frameworks_build_phase.add_file_reference(shared_target.product_reference, true)

tests_target.add_dependency(shared_target)
tests_target.frameworks_build_phase.add_file_reference(shared_target.product_reference, true)

embed_extensions_phase = app_target.new_copy_files_build_phase('Embed App Extensions')
embed_extensions_phase.symbol_dst_subfolder_spec = :plug_ins
embed_extensions_phase.add_file_reference(extension_target.product_reference, true)

app_source_refs = [
  add_group_file(app_app_group, 'LiteShuntApp.swift'),
  add_group_file(app_status_group, 'StatusView.swift'),
  add_group_file(app_services_group, 'TransparentProxyManagerStore.swift')
]
app_target.add_file_references(app_source_refs)

extension_source_refs = [
  add_group_file(extension_provider_group, 'LiteShuntTransparentProxyProvider.swift')
]
extension_target.add_file_references(extension_source_refs)

shared_source_refs = [
  add_group_file(shared_constants_group, 'LiteShuntSharedConstants.swift')
]
shared_target.add_file_references(shared_source_refs)

tests_source_refs = [
  add_group_file(tests_poc_group, 'LiteShuntPOCTests.swift')
]
tests_target.add_file_references(tests_source_refs)

[
  add_group_file(app_resources_group, 'Info.plist'),
  add_group_file(app_resources_group, 'LiteShuntApp.entitlements'),
  add_group_file(extension_resources_group, 'Info.plist'),
  add_group_file(extension_resources_group, 'LiteShuntExtension.entitlements'),
  add_group_file(tests_resources_group, 'Info.plist')
]

common_target_settings = {
  'CLANG_ENABLE_MODULES' => 'YES',
  'CODE_SIGN_STYLE' => 'Automatic',
  'CURRENT_PROJECT_VERSION' => '1',
  'MARKETING_VERSION' => '0.1.0',
  'SDKROOT' => 'macosx',
  'SWIFT_VERSION' => SWIFT_VERSION
}

apply_settings(app_target, common_target_settings.merge(
  'CODE_SIGN_ENTITLEMENTS' => 'LiteShuntApp/Resources/LiteShuntApp.entitlements',
  'ENABLE_APP_SANDBOX' => 'YES',
  'GENERATE_INFOPLIST_FILE' => 'NO',
  'INFOPLIST_FILE' => 'LiteShuntApp/Resources/Info.plist',
  'LD_RUNPATH_SEARCH_PATHS' => '$(inherited) @executable_path/../Frameworks @executable_path/../PlugIns',
  'PRODUCT_BUNDLE_IDENTIFIER' => APP_BUNDLE_IDENTIFIER,
  'PRODUCT_NAME' => '$(TARGET_NAME)',
  'SWIFT_EMIT_LOC_STRINGS' => 'NO'
))

apply_settings(extension_target, common_target_settings.merge(
  'APPLICATION_EXTENSION_API_ONLY' => 'YES',
  'CODE_SIGN_ENTITLEMENTS' => 'LiteShuntExtension/Resources/LiteShuntExtension.entitlements',
  'ENABLE_APP_SANDBOX' => 'YES',
  'GENERATE_INFOPLIST_FILE' => 'NO',
  'INFOPLIST_FILE' => 'LiteShuntExtension/Resources/Info.plist',
  'LD_RUNPATH_SEARCH_PATHS' => '$(inherited) @executable_path/../Frameworks @executable_path/../../Frameworks',
  'PRODUCT_BUNDLE_IDENTIFIER' => EXTENSION_BUNDLE_IDENTIFIER,
  'PRODUCT_NAME' => '$(TARGET_NAME)',
  'SKIP_INSTALL' => 'YES',
  'SWIFT_EMIT_LOC_STRINGS' => 'NO'
))

apply_settings(shared_target, common_target_settings.merge(
  'DEFINES_MODULE' => 'YES',
  'MACOSX_DEPLOYMENT_TARGET' => DEPLOYMENT_TARGET,
  'MACH_O_TYPE' => 'staticlib',
  'PRODUCT_NAME' => '$(TARGET_NAME)',
  'SKIP_INSTALL' => 'YES',
  'SWIFT_EMIT_LOC_STRINGS' => 'NO'
))

apply_settings(tests_target, common_target_settings.merge(
  'BUNDLE_LOADER' => '',
  'CODE_SIGNING_ALLOWED' => 'NO',
  'GENERATE_INFOPLIST_FILE' => 'NO',
  'INFOPLIST_FILE' => 'LiteShuntTests/Resources/Info.plist',
  'PRODUCT_BUNDLE_IDENTIFIER' => TESTS_BUNDLE_IDENTIFIER,
  'PRODUCT_NAME' => '$(TARGET_NAME)',
  'SWIFT_EMIT_LOC_STRINGS' => 'NO',
  'TEST_HOST' => ''
))

scheme = Xcodeproj::XCScheme.new
scheme.configure_with_targets(app_target, tests_target, launch_target: true)
scheme.add_build_target(shared_target, false)
scheme.add_build_target(extension_target, false)
scheme.save_as(PROJECT_PATH, APP_NAME, true)

project.sort
project.save

puts "已生成 #{PROJECT_PATH}"
