Pod::Spec.new do |s|
  s.name             = "FMMosaicLayout"
  s.version          = "0.1.0"
  s.summary          = "A drop-in mosaic collection view layout with a focus on simple customizations."
  s.homepage         = "https://github.com/fmitech/FMMosaicLayout"
  s.screenshots      = ["http://fmitech.github.io/FMMosaicLayout/Screenshots/portrait-1.png",
                        "http://fmitech.github.io/FMMosaicLayout/Screenshots/portrait-2.png",
                        "http://fmitech.github.io/FMMosaicLayout/Screenshots/landscape.png"]
  s.license          = 'MIT'
  s.author           = { "JVillella" => "julian.villella@hotmail.com" }
  s.source           = { :git => "https://github.com/fmitech/FMMosaicLayout.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
end
