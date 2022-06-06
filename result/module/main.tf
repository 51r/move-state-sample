resource "random_pet" "pet" {
    length = 3
  
}

output "id" {
    value = random_pet.pet.id
  
}