class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.04/nsis-3.04-src.tar.bz2"
  sha256 "609536046c50f35cfd909dd7df2ab38f2e835d0da3c1048aa0d48c59c5a4f4f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdfcc5744bbb90c33f679f119ecd2d5addd507e52c785d3be61d9bf60d6f6f4c" => :mojave
    sha256 "e05324ab124f4bc0b64167b4e4f8f0fe83345a4f2eba5d473b4174fafaa3c987" => :high_sierra
    sha256 "3e87e127f96c88d107943966681d71230232ba522d4d64d7398850383a0ab61f" => :sierra
  end

  depends_on "mingw-w64" => :build
  depends_on "scons" => :build

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.04/nsis-3.04.zip"
    sha256 "22f3349fea453a45551745635c13e5efb7849ecbdce709daa2b2fa8e2ac55fc4"
  end

  def install
    args = [
      "CC=#{ENV.cc}",
      "CXX=#{ENV.cxx}",
      "PREFIX_DOC=#{share}/nsis/Docs",
      "SKIPUTILS=Makensisw,NSIS Menu,zip2exe",
      # Don't strip, see https://github.com/Homebrew/homebrew/issues/28718
      "STRIP=0",
      "VERSION=#{version}",
    ]
    system "scons", "makensis", *args
    bin.install "build/urelease/makensis/makensis"
    (share/"nsis").install resource("nsis")
  end

  test do
    system "#{bin}/makensis", "-VERSION"
    system "#{bin}/makensis", "#{share}/nsis/Examples/bigtest.nsi", "-XOutfile /dev/null"
  end
end
