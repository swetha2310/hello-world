terraform {
  backend "s3" {
    bucket = "mumbais3bucket"
    key = "mumbais3bucket_Keypair/statefile"
    region = "ap-south-1"
  }
}
