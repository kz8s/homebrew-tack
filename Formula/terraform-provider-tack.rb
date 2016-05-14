require "language/go"

class TerraformProviderTack < Formula
  desc "Terraform provider to support the Tack project"
  homepage "https://github.com/kz8s/terraform-provider-tack"
  url "https://github.com/kz8s/terraform-tack/archive/develop.tar.gz"

  revision 1

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "-o", "terraform-provider-tack"
    bin.install "terraform-provider-tack"
  end
  
end
