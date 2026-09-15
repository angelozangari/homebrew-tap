class Mide < Formula
  desc "Local Markdown editor served to the browser"
  homepage "https://github.com/angelozangari/MiDe"
  # A private repository, so this clones over SSH with your own keys rather
  # than downloading a release asset.
  url "git@github.com:angelozangari/MiDe.git", using: :git, tag: "v0.1.1"
  version "0.1.1"

  depends_on "node" => :build
  depends_on "python@3.13"

  def install
    # The browser bundle is built here so it does not have to be committed.
    system "npm", "ci"
    system "npm", "run", "build"

    libexec.install "server.py", "mide", "public", "samples"
    (bin/"mide").write_env_script libexec/"mide",
                                  MIDE_ROOT:   libexec,
                                  MIDE_PYTHON: formula_opt_bin("python@3.13")/"python3"
  end

  def caveats
    <<~EOS
      Point MiDe at a directory once:
        mide ~/Notes

      Then just:
        mide

      The directory lives in ~/.config/mide/config.json and is read on every
      run, so editing that file is the same as passing the directory again.

      To try the bundled sample documents without changing it:
        mide --samples
    EOS
  end

  test do
    assert_match "serve the configured directory", shell_output("#{bin}/mide --help")
    # Without a remembered directory it must refuse rather than pick one.
    output = shell_output("#{bin}/mide --no-open 2>&1", 1)
    assert_match "no directory configured", output
  end
end
