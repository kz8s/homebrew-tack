require "language/go"

class TerraformProviderTack < Formula
  desc "Terraform provider to support the Tack project"
  homepage "https://github.com/kz8s/terraform-provider-tack"
  sha256 "cc4ac81fb58c11aee6ebae72d86e92de747632cfb562ffebff2d363729084f65"
  url "https://github.com/kz8s/terraform-provider-tack/archive/v0.4.tar.gz"
  # version "0.2.0"

  head "https://github.com/kz8s/terraform-provider-tack.git", :branch => "develop"

  depends_on "glide"
  depends_on "go" => :build
  depends_on "terraform" => :recommended

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    path = buildpath/"src/github.com/kz8s/terraform-provider-tack"

    contents = Dir[ "{*,.git,.gitignore}" ]
    path.install contents

    Language::Go.stage_deps resources, buildpath/"src"

    cd path do
        system "make", "get"
        system "make", "build"
        system "make", "install"
        bin.install "terraform-provider-tack"
    end
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<-EOS.undent
      resource "tack_aws_account_id" "foo" {}

      resource "tack_aws_azs" "foo" { region  = "us-west-2" }

      resource "tack_coreos" "foo" {
        channel = "stable"
        region  = "us-west-1"
        vmtype  = "hvm"
      }

      resource "tack_curl" "foo" {
        url = "http://myip.vg"
      }

      resource "tack_my_ip" "foo" {}

      output "account_id" { value = "${ tack_aws_account_id.foo.id }" }
      output "ami" { value = "${ tack_coreos.foo.ami }" }
      output "body" { value = "${ tack_curl.foo.body }" }
      output "azs" { value = "${ join(",", tack_aws_azs.foo.*.azs) }" }
      output "azs_string" { value = "${ tack_aws_azs.foo.azs_string }" }
      output "my_ip" { value = "${ tack_my_ip.foo.ip }" }
    EOS
    system "#{bin}/terraform", "graph", testpath
  end

end
