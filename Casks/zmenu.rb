cask "zmenu" do
  version "0.1.1"
  sha256 "abbd5651f6a1ce37854fb3b128c5e13dca910a1b71db097fcd15fdf93dfe5cab"

  url "https://github.com/angelozangari/homebrew-tap/releases/download/zmenu-v#{version}/zmenu-#{version}.zip"
  name "zmenu"
  desc "Menu bar GUI for miscellaneous services"
  homepage "https://github.com/angelozangari/homebrew-tap"

  app "zmenu.app"
end
