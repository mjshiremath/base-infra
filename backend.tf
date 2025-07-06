terraform {
  backend "s3" {
    bucket         = "atlanta-dream"
    key            = "aifsd/state/"
    region         = var.region
  }
}