require "language/go"

class TerraformProviderTack < Formula
#  head "https://github.com/some/package.git", :branch => "develop"
  desc "Terraform provider to support the Tack project"
  homepage "https://github.com/kz8s/terraform-tack"
  url "https://github.com/kz8s/terraform-tack/archive/develop.tar.gz"
  version "0.0.1"

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    path = buildpath/"src/github.com/kz8s/terraform-tack"
    path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd path do
        system "go", "get"
        system "go", "build", "-o", "terraform-provider-tack"
        bin.install "terraform-provider-tack"
    end
  end

end
