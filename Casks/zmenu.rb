cask "zmenu" do
  version "0.1.0"
  sha256 "0fb463f7853df564ec134faba08eb0a4bdb7dde7604bb75e5b198cd62573dafb"

  url "https://github.com/angelozangari/homebrew-tap/releases/download/zmenu-v#{version}/zmenu-#{version}.zip"
  name "zmenu"
  desc "Menu bar GUI for miscellaneous services"
  homepage "https://github.com/angelozangari/homebrew-tap"

  app "zmenu.app"
end
