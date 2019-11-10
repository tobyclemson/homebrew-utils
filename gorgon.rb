class Gorgon < Formula
  desc "Manage GitHub organizations or users."
  homepage "https://github.com/tobyclemson/gorgon"
  url "https://github.com/tobyclemson/gorgon/archive/0.1.0.tar.gz"
  sha256 "4bf7a9aa69d41253f06c6d63497b86a903fa6d6ce21bc18ff55377da000903ba"

  depends_on "goenv" => [:build, "HEAD"]
  depends_on "rbenv" => :build
  depends_on "ruby-build" => :build
  depends_on "openssl" => :build
  depends_on "tree" => :build

  def install
    File.open("build.sh", "w") do |f|
      content = <<~EOS
          #!/usr/bin/env bash

          set -e
          set -o pipefail
          
          export GOENV_ROOT="$HOME/.goenv"
          export PATH="$GOENV_ROOT/bin:$PATH"
          eval "$(goenv init -)"

          goenv install

          export GOVERSION="$(cat .go-version | tr -d '\n')"
          export GOROOT="$(goenv prefix)"
          export GOPATH="$PATH/go/$GOVERSION"
          export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
    
          export PATH="$HOME/.rbenv/bin:$PATH"
          eval "$(rbenv init - bash)"

          export RUBY_CONFIGURE_OPTS="--with-openssl-dir=#{prefix}/openssl"

          rbenv install

          gem install bundler
          bundle install
          
          env | sort
          tree -L 4 .brew_home

          rake 'cli:build[0.1.0]'
      EOS
      f.write(content)
    end

    FileUtils.chmod(0755, "build.sh")

    system "./build.sh"

    bin.install "build/bin/0.1.0_darwin_amd64/gorgon"
  end

  test do
    system "false"
  end
end
