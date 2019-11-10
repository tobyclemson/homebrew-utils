class Gorgon < Formula
  desc "Manage GitHub organizations or users."
  homepage "https://github.com/tobyclemson/gorgon"
  url "https://github.com/tobyclemson/gorgon/archive/0.3.0.tar.gz"
  sha256 "6ee637acb1ae190ab9e17afccdadb071d8a5c8d2403e2a48b3357db5fd3f54ea"

  depends_on "goenv" => [:build, "HEAD"]
  depends_on "rbenv" => :build
  depends_on "ruby-build" => :build
  depends_on "openssl" => :build

  def install
    File.open("build.sh", "w") do |f|
      content = <<-EOS
#!/usr/bin/env bash

set -e
set -o pipefail

export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

goenv install

export GOVERSION="$(cat .go-version | tr -d '\n')"
export GOROOT="$(goenv prefix)"
export GOPATH="$HOME/go/$GOVERSION"
export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=#{prefix}/openssl"

rbenv install

gem install bundler
bundle install

rake 'cli:build:darwin[#{version}]'
      EOS
      f.write(content)
    end

    FileUtils.chmod(0755, "build.sh")

    system "./build.sh"

    bin.install "build/bin/#{version}_darwin_amd64/gorgon"
  end

  test do
    system "#{bin}/gorgon", 'version'
  end
end