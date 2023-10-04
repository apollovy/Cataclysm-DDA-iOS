platform :ios, '11.0'
use_frameworks!
pod 'Sentry', '~> 8'
pod 'Zip', '~> 2'
pod 'SDL2', :path => './Libraries/SDL'

def paywall
  pod 'CDDA-Paywall', :path => './Libraries/CDDA-Paywall'
end

target 'CBNfreeIAP' do
  paywall
end

target 'CBN' do
end

target 'CDDA0F' do
end

target 'CDDA0G' do
  paywall
end
