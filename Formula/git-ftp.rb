class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/git-ftp"
  url "https://github.com/git-ftp/git-ftp/archive/1.3.2.tar.gz"
  sha256 "a86e2437e60ab4314874a2da71fe330f0a892ed1c9b038b97f755c4b68d60dd1"

  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8baec08e9a4322348eb26bb052e964b4f8d2c209e36c5657a437843f1cc7793" => :sierra
    sha256 "d8baec08e9a4322348eb26bb052e964b4f8d2c209e36c5657a437843f1cc7793" => :el_capitan
    sha256 "d8baec08e9a4322348eb26bb052e964b4f8d2c209e36c5657a437843f1cc7793" => :yosemite
  end

  option "with-manpage", "build and install the manpage (depends on pandoc)"

  depends_on "curl" => "with-libssh2"
  depends_on "pandoc" => :build if build.with? "manpage"

  def install
    system "make", "prefix=#{prefix}", "install"
    if build.with? "manpage"
      system "make", "-C", "man", "man"
      man1.install "man/git-ftp.1"
    end
    libexec.install bin/"git-ftp"
    (bin/"git-ftp").write <<-EOS.undent
      #!/bin/sh
      PATH=#{Formula["curl"].opt_bin}:$PATH
      #{libexec}/git-ftp "$@"
    EOS
  end

  test do
    system bin/"git-ftp", "--help"
  end
end
