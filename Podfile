platform :ios, '11.0'
use_frameworks!

def paywall
  pod 'CDDA-Paywall', :path => './Libraries/CDDA-Paywall'
end

def cDDADependencies
  pod 'SDL2', :path => './Libraries/SDL'
end

def iOSDependencies
  pod 'Sentry', '~> 8'
  pod 'Zip', '~> 2'
end

target 'CBNfreeIAP' do
  cDDADependencies
  iOSDependencies
  paywall
end

target 'CBN' do
  cDDADependencies
  iOSDependencies
end

target 'CDDA0F' do
  cDDADependencies
  iOSDependencies
end

target 'CDDA0G' do
  cDDADependencies
  iOSDependencies
  paywall
end

target 'CDDA0GFramework' do
  cDDADependencies
end

target 'DynLoadTest' do
  cDDADependencies
end
