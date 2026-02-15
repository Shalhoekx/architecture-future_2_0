variable "zone" {
  description = "Зона доступности, в которой будет находиться ВМ"
  type        = string
  default     = "ru-central1-a"
}

variable "username" {
  description = "имя пользователя, который будет создан на ВМ."
  type        = string
  default     = "vmuser"
}

variable "ssh_key_path" {
  description = "путь к файлу с открытым SSH-ключом для аутентификации пользователя на ВМ."
  type        = string
  default     = "./vmtest.pub"
}

variable "target_folder_id" {
  description = "идентификатор каталога, в котором будет находиться ВМ."
  type        = string
  default     = "b1g294c1hq2fea32i19t"
}

variable "registry_name" {
  description = "имя реестра Container Registry."
  type        = string
  default     = "registrya"
}

variable "sa_name" {
  description = "имя сервисного аккаунта"
  type        = string
  default     = "test-latest"
}

variable "network_name" {
  description = "имя облачной сети."
  type        = string
  default     = "vmtest"
}

variable "subnet_name" {
  description = "имя подсети."
  type        = string
  default     = "vmtest"
}

variable "vm_name" {
  description = "имя ВМ."
  type        = string
  default     = "vmtest"
}

variable "image_id" {
  description = "идентификатор образа, из которого будет создана ВМ"
  type        = string
  default     = "fd8kiogst6b2vj84enm8"
}