terraform {
  backend "s3" {
    bucket         = "atlanta-dream"
    key            = "/aifsd/state"
    region         = "us-east-1"
  }
}