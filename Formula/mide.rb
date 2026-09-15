class Mide < Formula
  desc "Local Markdown editor served to the browser"
  homepage "https://github.com/angelozangari/MiDe"
  # A private repository, so this clones over SSH with your own keys rather
  # than downloading a release asset.
  url "git@github.com:angelozangari/MiDe.git", using: :git, tag: "v0.1.0"
  version "0.1.0"

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
      Choose the directory to edit once, and it is remembered:
        mide ~/Notes

      Then just:
        mide

      To try the bundled sample documents without changing that:
        mide samples
    EOS
  end

  test do
    assert_match "serve the remembered directory", shell_output("#{bin}/mide --help")
    # Without a remembered directory it must refuse rather than pick one.
    output = shell_output("#{bin}/mide --no-open 2>&1", 1)
    assert_match "no directory remembered", output
  end
end
