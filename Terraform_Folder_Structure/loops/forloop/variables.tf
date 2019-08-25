variable "names" {
  description = "A list of names"
  type = list(string)
  default = ["hanuman", "Bhajrang", "Chalisa"]
}

variable "hero_thousand_faces" {
  description = "map"
  type = map(string)
  default = {
    neo = "hero"
    trinity = "love interest"
    morpheus = "mentor"
  }
}

variable "bknames" {
  description = "A list of names"
  type = list(string)
  default = ["hanuman", "Bhajrang", "Chalisa"]
}