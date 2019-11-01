
def test_on_mac()
    sh("xcodebuild -project ../Tambo.xcodeproj -scheme 'Tambo macOS' -destination 'platform=OS X,arch=x86_64' build test")
end