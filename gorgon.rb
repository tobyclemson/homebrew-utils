class Gorgon < Formula
  desc "Manage GitHub organizations or users."
  homepage "https://github.com/tobyclemson/gorgon"
  url "https://github.com/tobyclemson/gorgon/archive/0.10.0.tar.gz"
  sha256 "3300689c791449ee105ee5a09743a5a1d31ca7ea1c47f641636c1d7b4297c68d"

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
