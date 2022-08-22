resource "aws_placement_group" "redundant" {
  name     = "redundant"
  strategy = "spread"
}


resource "aws_placement_group" "speed" {
  name     = "redundant"
  strategy = "cluster"
}