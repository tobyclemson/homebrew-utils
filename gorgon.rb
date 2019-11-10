class Gorgon < Formula
  desc "Manage GitHub organizations or users."
  homepage "https://github.com/tobyclemson/gorgon"
  url "https://github.com/tobyclemson/gorgon/archive/0.1.0.tar.gz"
  sha256 "4bf7a9aa69d41253f06c6d63497b86a903fa6d6ce21bc18ff55377da000903ba"

  depends_on "goenv" => [:build, "HEAD"]
  depends_on "rbenv" => :build

  def install
    File.open("#{ENV['HOME']}/.bash_profile", "a") do |f|
      content = <<~EOS
          export GOENV_ROOT="$HOME/.goenv"
          export PATH="$GOENV_ROOT/bin:$PATH"
          eval "$(goenv init -)"

          export PATH="$HOME/.rbenv/bin:$PATH"
          eval "$(rbenv init - bash)"
      EOS
      f.write(content)
    end

    ENV["GOROOT"] = `bash -c "goenv --prefix"`
    ENV["GOPATH"] = "#{ENV['HOME']}/go/#{`cat .go-version`}"
    ENV["PATH"] = "#{ENV['GOROOT']}/bin:#{ENV['GOPATH']}/bin:#{ENV['PATH']}"

    system "bash", "-c", "goenv install"
    system "bash", "-c", "rbenv install"
  end

  test do
    system "false"
  end
end
