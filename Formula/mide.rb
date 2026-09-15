class Mide < Formula
  desc "Local Markdown editor served to the browser"
  homepage "https://github.com/angelozangari/MiDe"
  # A private repository, so this clones over SSH with your own keys rather
  # than downloading a release asset.
  url "git@github.com:angelozangari/MiDe.git", using: :git, tag: "v0.1.10"
  version "0.1.10"
  # The service block is a formula-only change, so the keg must be rebuilt for
  # brew services to see it.
  revision 1

  depends_on "node" => :build
  depends_on "python@3.13"

  def install
    # The browser bundle is built here so it does not have to be committed.
    system "npm", "ci"
    system "npm", "run", "build"

    libexec.install "server.py", "mide", "public", "samples"
    (bin/"mide").write_env_script libexec/"mide",
                                  MIDE_ROOT:   libexec,
                                  # Homebrew ships only versioned interpreters: there is no python3 here.
                                  MIDE_PYTHON: formula_opt_bin("python@3.13")/"python3.13"
  end

  # brew services drives launchd, so an installed copy needs no script of its
  # own. service/install.sh in the repository covers a checkout and Linux.
  service do
    run [opt_bin/"mide", "--no-open"]
    run_type :immediate
    keep_alive true
    log_path var/"log/mide.log"
    error_log_path var/"log/mide.log"
  end

  def caveats
    <<~EOS
      Name the directory to edit in ~/.config/mide/config.json:

        mkdir -p ~/.config/mide
        echo '{"documents_dir": "~/Notes"}' > ~/.config/mide/config.json

      Then:
        mide

      Every run reads that file, and it is the only place the directory is set.
      Edit it later with:
        $EDITOR "$(mide --config)"

      To try the bundled sample documents instead:
        mide --samples

      To keep it running and start it again at login:
        brew services start mide
    EOS
  end

  test do
    assert_match "serve the configured directory", shell_output("#{bin}/mide --help")
    # Without a remembered directory it must refuse rather than pick one.
    output = shell_output("#{bin}/mide --no-open 2>&1", 1)
    assert_match "no configuration at", output
  end
end
